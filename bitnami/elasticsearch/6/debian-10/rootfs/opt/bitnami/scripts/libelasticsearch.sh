#!/bin/bash
#
# Bitnami Elasticsearch library

# shellcheck disable=SC1090
# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libvalidations.sh

# Functions

########################
# Write a configuration setting value
# Globals:
#   ELASTICSEARCH_CONF_FILE
# Arguments:
#   $1 - key
#   $2 - value
# Returns:
#   None
#########################
elasticsearch_conf_write() {
    local key="${1:?missing key}"
    local value="${2:?missing value}"

    if [[ -s "$ELASTICSEARCH_CONF_FILE" ]]; then
        yq w -i "$ELASTICSEARCH_CONF_FILE" "$key" "$value"
    else
        yq n "$key" "$value" > "$ELASTICSEARCH_CONF_FILE"
    fi
}

########################
# Set a configuration setting value
# Globals:
#   ELASTICSEARCH_CONF_FILE
# Arguments:
#   $1 - key
#   $2 - values (array)
# Returns:
#   None
#########################
elasticsearch_conf_set() {
    local key="${1:?missing key}"
    shift
    local values=("${@}")

    if [[ "${#values[@]}" -eq 0 ]]; then
        stderr_print "missing values"
        return 1
    elif [[ "${#values[@]}" -eq 1 ]] && [[ -n "${values[0]}" ]]; then
        elasticsearch_conf_write "$key" "${values[0]}"
    else
        for i in "${!values[@]}"; do
            if [[ -n "${values[$i]}" ]]; then
                elasticsearch_conf_write "${key}[+]" "${values[$i]}"
            fi
        done
    fi
}

########################
# Check if Elasticsearch is running
# Globals:
#   ELASTICSEARCH_TMP_DIR
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_elasticsearch_running() {
    local pid
    pid="$(get_pid_from_file "${ELASTICSEARCH_TMP_DIR}/elasticsearch.pid")"

    if [[ -z "$pid" ]]; then
        false
    else
        is_service_running "$pid"
    fi
}

########################
# Stop Elasticsearch
# Globals:
#   ELASTICSEARCH_TMP_DIR
# Arguments:
#   None
# Returns:
#   None
#########################
elasticsearch_stop() {
    ! is_elasticsearch_running && return
    debug "Stopping Elasticsearch..."
    stop_service_using_pid "$ELASTICSEARCH_TMP_DIR/elasticsearch.pid"
}

########################
# Start Elasticsearch and wait until it's ready
# Globals:
#   ELASTICSEARCH_*
# Arguments:
#   None
# Returns:
#   None
#########################
elasticsearch_start() {
    is_elasticsearch_running && return

    debug "Starting Elasticsearch..."
    local command=("${ELASTICSEARCH_BASE_DIR}/bin/elasticsearch" "-d" "-p" "${ELASTICSEARCH_TMP_DIR}/elasticsearch.pid" "-Epath.data=$ELASTICSEARCH_DATA_DIR")
    am_i_root && command=("gosu" "$ELASTICSEARCH_DAEMON_USER" "${command[@]}")
    if [[ "$BITNAMI_DEBUG" = true ]]; then
        "${command[@]}" &
    else
        "${command[@]}" >/dev/null 2>&1 &
    fi

    local counter=50
    while ! is_elasticsearch_running ; do
        if [[ "$counter" -ne 0 ]]; then
            break
        fi
        sleep 2;
        counter=$((counter - 1))
    done
    local log_result=""
    local log_counter=30
    while [[ -z "$log_result" ]] && [[ "$log_counter" -ne 0 ]]; do
        log_counter=$(("$log_counter" - 1))
        log_result="$(tail -7 "${ELASTICSEARCH_LOG_DIR}/elasticsearch.log" | grep -i "Node" | grep -i "started")"
        sleep 2
    done
}

########################
# Load global variables used on Elasticsearch configuration
# Globals:
#  ELASTICSEARCH_*
# Arguments:
#   None
# Returns:
#   Series of exports to be used as 'eval' arguments
#########################
elasticsearch_env() {
    cat <<"EOF"
# Paths
export ELASTICSEARCH_BASE_DIR="/opt/bitnami/elasticsearch"
export ELASTICSEARCH_VOLUME_DIR="/bitnami/elasticsearch"
export ELASTICSEARCH_DATA_DIR="${ELASTICSEARCH_VOLUME_DIR}/data"
export ELASTICSEARCH_MOUNTED_PLUGINS_DIR="${ELASTICSEARCH_VOLUME_DIR}/plugins"
export ELASTICSEARCH_INITSCRIPTS_DIR="/docker-entrypoint-initdb.d"
export ELASTICSEARCH_CONF_DIR="${ELASTICSEARCH_BASE_DIR}/config"
export ELASTICSEARCH_CONF_FILE="${ELASTICSEARCH_CONF_DIR}/elasticsearch.yml"
export ELASTICSEARCH_TMP_DIR="${ELASTICSEARCH_BASE_DIR}/tmp"
export ELASTICSEARCH_LOG_DIR="${ELASTICSEARCH_BASE_DIR}/logs"
export ELASTICSEARCH_PLUGINS_DIR="${ELASTICSEARCH_BASE_DIR}/plugins"
export PATH="${ELASTICSEARCH_BASE_DIR}/bin:$PATH"

# Users
export ELASTICSEARCH_DAEMON_USER="${ELASTICSEARCH_DAEMON_USER:-elasticsearch}"
export ELASTICSEARCH_DAEMON_GROUP="${ELASTICSEARCH_DAEMON_GROUP:-elasticsearch}"

# Settings
export ELASTICSEARCH_BIND_ADDRESS="${ELASTICSEARCH_BIND_ADDRESS:-}"
export ELASTICSEARCH_CLUSTER_HOSTS="${ELASTICSEARCH_CLUSTER_HOSTS:-}"
export ELASTICSEARCH_TOTAL_NODES="${ELASTICSEARCH_TOTAL_NODES:-}"
export ELASTICSEARCH_CLUSTER_MASTER_HOSTS="${ELASTICSEARCH_CLUSTER_MASTER_HOSTS:-}"
export ELASTICSEARCH_CLUSTER_NAME="${ELASTICSEARCH_CLUSTER_NAME:-}"
export ELASTICSEARCH_HEAP_SIZE="${ELASTICSEARCH_HEAP_SIZE:-1024m}"
export ELASTICSEARCH_IS_DEDICATED_NODE="${ELASTICSEARCH_IS_DEDICATED_NODE:-no}"
export ELASTICSEARCH_MINIMUM_MASTER_NODES="${ELASTICSEARCH_MINIMUM_MASTER_NODES:-}"
export ELASTICSEARCH_NODE_NAME="${ELASTICSEARCH_NODE_NAME:-}"
export ELASTICSEARCH_NODE_PORT_NUMBER="${ELASTICSEARCH_NODE_PORT_NUMBER:-9300}"
export ELASTICSEARCH_NODE_TYPE="${ELASTICSEARCH_NODE_TYPE:-master}"
export ELASTICSEARCH_PLUGINS="${ELASTICSEARCH_PLUGINS:-}"
export ELASTICSEARCH_PORT_NUMBER="${ELASTICSEARCH_PORT_NUMBER:-9200}"
export ELASTICSEARCH_FS_SNAPSHOT_REPO_PATH="${ELASTICSEARCH_FS_SNAPSHOT_REPO_PATH:-}"

## JVM
export JAVA_HOME="${JAVA_HOME:-/opt/bitnami/java}"
EOF
}

########################
# Validate kernel settings
# Arguments:
#   None
# Returns:
#   None
#########################
elasticsearch_validate_kernel() {
    # Auxiliary functions
    validate_sysctl_key() {
        local key="${1:?key is missing}"
        local value="${2:?value is missing}"
        local current_value
        current_value="$(sysctl -n "$key")"
        if [[ "$current_value" -lt "$value" ]]; then
            error "Invalid kernel settings. Elasticsearch requires at least: $key = $value"
            exit 1
        fi
    }

    debug "Validating Kernel settings..."
    validate_sysctl_key "vm.max_map_count" 262144
    validate_sysctl_key "fs.file-max" 65536
}

########################
# Validate settings in ELASTICSEARCH_* env vars
# Globals:
#   ELASTICSEARCH_*
# Arguments:
#   None
# Returns:
#   None
#########################
elasticsearch_validate() {
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }

    validate_node_type() {
        case "$ELASTICSEARCH_NODE_TYPE" in
            coordinating|data|ingest|master)
                ;;
            *)
                print_validation_error "Invalid node type $ELASTICSEARCH_NODE_TYPE. Supported types are 'coordinating/data/ingest/master'"
        esac
    }

    debug "Validating settings in ELASTICSEARCH_* env vars..."
    local validate_port_args=()
    ! am_i_root && validate_port_args+=("-unprivileged")
    for var in "ELASTICSEARCH_PORT_NUMBER" "ELASTICSEARCH_NODE_PORT_NUMBER"; do
        if ! err=$(validate_port "${validate_port_args[@]}" "${!var}"); then
            print_validation_error "An invalid port was specified in the environment variable $var: $err"
        fi
    done
    is_boolean_yes "$ELASTICSEARCH_IS_DEDICATED_NODE" && validate_node_type
    if [[ -n "$ELASTICSEARCH_BIND_ADDRESS" ]] && ! validate_ipv4 "$ELASTICSEARCH_BIND_ADDRESS"; then
        print_validation_error "The Bind Address specified in the environment variable ELASTICSEARCH_BIND_ADDRESS is not a valid IPv4"
    fi

    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}

########################
# Configure Elasticsearch cluster settings
# Globals:
#  ELASTICSEARCH_*
# Arguments:
#   None
# Returns:
#   None
#########################
elasticsearch_cluster_configuration() {
    # Auxiliary functions
    bind_address() {
        if [[ -n "$ELASTICSEARCH_BIND_ADDRESS" ]]; then
            echo "[$ELASTICSEARCH_BIND_ADDRESS, _local_]"
        else
            echo "0.0.0.0"
        fi
    }

    info "Configuring Elasticsearch cluster settings..."
    elasticsearch_conf_set network.host "$(get_machine_ip)"
    elasticsearch_conf_set network.publish_host "$(get_machine_ip)"
    elasticsearch_conf_set network.bind_host "$(bind_address)"
    elasticsearch_conf_set cluster.name "$ELASTICSEARCH_CLUSTER_NAME"
    elasticsearch_conf_set node.name "${ELASTICSEARCH_NODE_NAME:-$(hostname)}"

    if [[ -n "$ELASTICSEARCH_CLUSTER_HOSTS" ]]; then
        read -r -a host_list <<< "$(tr ',;' ' ' <<< "$ELASTICSEARCH_CLUSTER_HOSTS")"
        master_list=( "${host_list[@]}" )
        total_nodes=${#host_list[@]}
        if [[ -n "$ELASTICSEARCH_CLUSTER_MASTER_HOSTS" ]]; then
            read -r -a master_list <<< "$(tr ',;' ' ' <<< "$ELASTICSEARCH_CLUSTER_MASTER_HOSTS")"
        fi
        if [[ -n "$ELASTICSEARCH_TOTAL_NODES" ]]; then
            total_nodes=$ELASTICSEARCH_TOTAL_NODES
        fi
        ELASTICSEARCH_MAJOR_VERSION=$(elasticsearch --version | grep Version: | awk -F "," '{print $1}' | awk -F ":" '{print $2}' | awk -F "." '{print $1}')
        if [[ "$ELASTICSEARCH_MAJOR_VERSION" -le 6 ]]; then
            elasticsearch_conf_set discovery.zen.ping.unicast.hosts "${host_list[@]}"
        else
            elasticsearch_conf_set discovery.seed_hosts "${host_list[@]}"
        fi
        elasticsearch_conf_set discovery.initial_state_timeout "5m"
        elasticsearch_conf_set gateway.recover_after_nodes "$(((total_nodes+1+1)/2))"
        elasticsearch_conf_set gateway.expected_nodes "$total_nodes"
        if [[ "$ELASTICSEARCH_NODE_TYPE" = "master" ]] && [[ "$ELASTICSEARCH_MAJOR_VERSION" -gt 6 ]]; then
            elasticsearch_conf_set cluster.initial_master_nodes "${master_list[@]}"
        fi
        if [[ -n "$ELASTICSEARCH_MINIMUM_MASTER_NODES" ]]; then
            debug "Setting minimum master nodes for quorum to $ELASTICSEARCH_MINIMUM_MASTER_NODES..."
            elasticsearch_conf_set discovery.zen.minimum_master_nodes "$ELASTICSEARCH_MINIMUM_MASTER_NODES"
        elif [[ "${#host_list[@]}" -gt 2 ]]; then
            local min_masters=""
            min_masters=$(((${#host_list[@]} / 2) +1))
            debug "Calculating minimum master nodes for quorum: $min_masters..."
            elasticsearch_conf_set discovery.zen.minimum_master_nodes "$min_masters"
        fi
    else
        elasticsearch_conf_set "discovery.type" "single-node"
    fi
}

########################
# Configure Elasticsearch node type
# Globals:
#  ELASTICSEARCH_*
# Arguments:
#   None
# Returns:
#   None
#########################
elasticsearch_configure_node_type() {
    local is_master="false"
    local is_data="false"
    local is_ingest="false"
    if is_boolean_yes "$ELASTICSEARCH_IS_DEDICATED_NODE"; then
        case "$ELASTICSEARCH_NODE_TYPE" in
            coordinating)
            ;;
            data)
                is_data="true"
                ;;
            ingest)
                is_ingest="true"
                ;;
            master)
                is_master="true"
                ;;
            *)
                error "Invalid node type '$ELASTICSEARCH_NODE_TYPE'"
                exit 1
                ;;
        esac
    else
        is_master="true"
        is_data="true"
    fi
    debug "Configure Elasticsearch Node type..."
    elasticsearch_conf_set node.master "$is_master"
    elasticsearch_conf_set node.data "$is_data"
    elasticsearch_conf_set node.ingest "$is_ingest"
    if [[ "$is_data" = "true" || "$is_master" = "true" ]] && [[ -n "$ELASTICSEARCH_FS_SNAPSHOT_REPO_PATH" ]]; then
        # Configure path.repo to restore snapshots from system repository
        # It must be set on every master an data node
        # ref: https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-filesystem-repository
        elasticsearch_conf_set path.repo "$ELASTICSEARCH_FS_SNAPSHOT_REPO_PATH"
    fi
}

########################
# Configure Elasticsearch Heap Size
# Globals:
#  ELASTICSEARCH_*
# Arguments:
#   None
# Returns:
#   None
#########################
elasticsearch_set_heap_size() {
    local heap_size
    if [[ -n "$ELASTICSEARCH_HEAP_SIZE" ]]; then
        debug "Using specified values for Xmx and Xms heap options..."
        heap_size="$ELASTICSEARCH_HEAP_SIZE"
    else
        debug "Calculating appropiate Xmx and Xms values..."
        local machine_mem=""
        machine_mem="$(get_total_memory)"
        if [[ "$machine_mem" -lt 65536 ]]; then
            heap_size="$(("$machine_mem" / 2))m"
        else
            heap_size=32768m
        fi
    fi
    debug "Setting '-Xmx${heap_size} -Xms${heap_size}' heap options..."
    replace_in_file "${ELASTICSEARCH_CONF_DIR}/jvm.options" "-Xmx[0-9]+[mg]+" "-Xmx${heap_size}"
    replace_in_file "${ELASTICSEARCH_CONF_DIR}/jvm.options" "-Xms[0-9]+[mg]+" "-Xms${heap_size}"
}

########################
# Migrate old Elasticsearch data
# Globals:
#   ELASTICSEARCH_*
# Arguments:
#   None
# Returns:
#   None
#########################
migrate_old_data() {
    warn "Persisted data follows old structure. Migrating to new one..."
    warn "Custom configuration files won't be persisted any longer!"
    local old_data_dir="${ELASTICSEARCH_DATA_DIR}/elasticsearch"
    local old_custom_conf_file="${old_data_dir}/conf/elasticsearch_custom.yml"
    local custom_conf_file="${ELASTICSEARCH_CONF_DIR}/elasticsearch_custom.yml"
    if [[ -f "$old_custom_conf_file" ]]; then
        debug "Adding old custom configuration to user configuration"
        echo "" >> "$custom_conf_file"
        cat "$old_custom_conf_file" >> "$custom_conf_file"
    fi
    debug "Adapting data to new file structure"
    find "${old_data_dir}/data" -maxdepth 1 -mindepth 1 -exec mv {} "$ELASTICSEARCH_DATA_DIR" \;
    debug "Removing data that is not persisted anymore from persisted directory"
    rm -rf "$old_data_dir" "${ELASTICSEARCH_DATA_DIR}/java"
}

########################
# Configure/initialize Elasticsearch
# Globals:
#   ELASTICSEARCH_*
# Arguments:
#   None
# Returns:
#   None
#########################
elasticsearch_initialize() {
    info "Configuring/Initializing Elasticsearch..."

    # This fixes an issue where the trap would kill the entrypoint.sh, if a PID was left over from a previous run
    # Exec replaces the process without creating a new one, and when the container is restarted it may have the same PID
    rm -f "$ELASTICSEARCH_TMP_DIR/elasticsearch.pid"

    # Persisted data from old versions
    if ! is_dir_empty "$ELASTICSEARCH_DATA_DIR"; then
        debug "Detected persisted data from previous deployments"
        [[ -d "$ELASTICSEARCH_DATA_DIR/elasticsearch" ]] && [[ -f "$ELASTICSEARCH_DATA_DIR/elasticsearch/.initialized" ]] && migrate_old_data
    fi

    debug "Ensuring expected directories/files exist..."
    for dir in "$ELASTICSEARCH_TMP_DIR" "$ELASTICSEARCH_DATA_DIR" "$ELASTICSEARCH_LOG_DIR" "$ELASTICSEARCH_BASE_DIR/plugins" "$ELASTICSEARCH_BASE_DIR/modules" "$ELASTICSEARCH_CONF_DIR"; do
        ensure_dir_exists "$dir"
        am_i_root && chown -R "$ELASTICSEARCH_DAEMON_USER:$ELASTICSEARCH_DAEMON_GROUP" "$dir"
    done

    if [[ -f "$ELASTICSEARCH_CONF_FILE" ]]; then
        info "Custom configuration file detected, using it..."
    else
        info "Setting default configuration"
        touch "$ELASTICSEARCH_CONF_FILE"
        elasticsearch_conf_set http.port "$ELASTICSEARCH_PORT_NUMBER"
        elasticsearch_conf_set path.data "$ELASTICSEARCH_DATA_DIR"
        elasticsearch_conf_set transport.tcp.port "$ELASTICSEARCH_NODE_PORT_NUMBER"
        elasticsearch_cluster_configuration
        elasticsearch_configure_node_type
    fi
    elasticsearch_set_heap_size
}

########################
# Install Elasticsearch plugins
# Globals:
#   ELASTICSEARCH_*
# Arguments:
#   None
# Returns:
#   None
#########################
elasticsearch_install_plugins() {
    read -r -a plugins_list <<< "$(tr ',;' ' ' <<< "$ELASTICSEARCH_PLUGINS")"
    local mandatory_plugins=""

    # Helper function for extracting the plugin name from a tarball name
    # Examples:
    #   get_plugin_name plugin -> plugin
    #   get_plugin_name file://plugin.zip -> plugin
    #   get_plugin_name http://plugin-0.1.2.zip -> plugin
    get_plugin_name() {
        local plugin="${1:?missing plugin}"
        # Remove any paths, and strip both the .zip extension and the version
        basename "$plugin" | sed -E -e 's/.zip$//' -e 's/-[0-9]+\.[0-9]+\.[0-9]$//'
    }

    # Collect plugins that should be installed offline
    read -r -a mounted_plugins <<< "$(find "$ELASTICSEARCH_MOUNTED_PLUGINS_DIR" -type f -name "*.zip" -print0 | xargs -0)"
    if [[ "${#mounted_plugins[@]}" -gt 0 ]]; then
        for plugin in "${mounted_plugins[@]}"; do
            plugins_list+=("file://${plugin}")
        done
    fi

    # Skip if there isn't any plugin to install
    [[ -z "${plugins_list[*]:-}" ]] && return

    # Install plugins
    debug "Installing plugins: ${plugins_list[*]}"
    for plugin in "${plugins_list[@]}"; do
        plugin_name="$(get_plugin_name "$plugin")"
        [[ -n "$mandatory_plugins" ]] && mandatory_plugins="${mandatory_plugins},${plugin_name}" || mandatory_plugins="$plugin_name"

        # Check if the plugin was already installed
        if [[ -d "${ELASTICSEARCH_PLUGINS_DIR}/${plugin_name}" ]]; then
            debug "Plugin already installed: ${plugin}"
            continue
        fi

        debug "Installing plugin: ${plugin}"
        if [[ "${BITNAMI_DEBUG:-false}" = true ]]; then
            elasticsearch-plugin install -b -v "$plugin"
        else
            elasticsearch-plugin install -b -v "$plugin" >/dev/null 2>&1
        fi
    done

    # Mark plugins as mandatory
    elasticsearch_conf_set plugin.mandatory "$mandatory_plugins"
}

########################
# Run custom initialization scripts
# Globals:
#   ELASTICSEARCH_*
# Arguments:
#   None
# Returns:
#   None
#########################
elasticsearch_custom_init_scripts() {
    read -r -a init_scripts <<< "$(find "$ELASTICSEARCH_INITSCRIPTS_DIR" -type f -name "*.sh" -print0 | xargs -0)"
    if [[ "${#init_scripts[@]}" -gt 0 ]] && [[ ! -f "$ELASTICSEARCH_VOLUME_DIR"/.user_scripts_initialized ]]; then
        info "Loading user's custom files from $ELASTICSEARCH_INITSCRIPTS_DIR"
        for f in "${init_scripts[@]}"; do
            debug "Executing $f"
            case "$f" in
                *.sh)
                    if [[ -x "$f" ]]; then
                        if ! "$f"; then
                            error "Failed executing $f"
                            return 1
                        fi
                    else
                        warn "Sourcing $f as it is not executable by the current user, any error may cause initialization to fail"
                        . "$f"
                    fi
                    ;;
                *)
                    warn "Skipping $f, supported formats are: .sh"
                    ;;
            esac
        done
        touch "$ELASTICSEARCH_VOLUME_DIR"/.user_scripts_initialized
    fi
}
