#!/bin/bash
#
# Bitnami Elasticsearch library

# shellcheck disable=SC1091

# Load Generic Libraries
. /libfile.sh
. /liblog.sh
. /libnet.sh
. /libos.sh
. /libservice.sh
. /libvalidations.sh

# Functions

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
    local name="${1:?missing key}"
    shift
    local values=("${@}")

    if [[ "${#values[@]}" -eq 0 ]]; then
        stderr_print "missing value"
        return 1
    elif [[ "${#values[@]}" -eq 1 ]]; then
        yq w -i "$ELASTICSEARCH_CONF_FILE" "$name" "${values[0]}"
    else
        for i in "${!values[@]}"; do
            yq w -i "$ELASTICSEARCH_CONF_FILE" "$name[$i]" "${values[$i]}"
        done
    fi
}

########################
# Check if Elasticsearch is running
# Globals:
#   ELASTICSEARCH_TMPDIR
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_elasticsearch_running() {
    local pid
    pid="$(get_pid_from_file "${ELASTICSEARCH_TMPDIR}/elasticsearch.pid")"

    if [[ -z "$pid" ]]; then
        false
    else
        is_service_running "$pid"
    fi
}

########################
# Stop Elasticsearch
# Globals:
#   ELASTICSEARCH_TMPDIR
# Arguments:
#   None
# Returns:
#   None
#########################
elasticsearch_stop() {
    ! is_elasticsearch_running && return
    debug "Stopping Elasticsearch..."
    stop_service_using_pid "$ELASTICSEARCH_TMPDIR/elasticsearch.pid"
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
    local command=("${ELASTICSEARCH_BASEDIR}/bin/elasticsearch" "-d" "-p" "${ELASTICSEARCH_TMPDIR}/elasticsearch.pid" "-Epath.data=$ELASTICSEARCH_DATADIR")
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
        log_result="$(tail -7 "${ELASTICSEARCH_LOGDIR}/elasticsearch.log" | grep -i "Node" | grep -i "started")"
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
export ELASTICSEARCH_BASEDIR="/opt/bitnami/elasticsearch"
export ELASTICSEARCH_DATADIR="/bitnami/elasticsearch/data"
export ELASTICSEARCH_CONFDIR="${ELASTICSEARCH_BASEDIR}/config"
export ELASTICSEARCH_CONF_FILE="${ELASTICSEARCH_CONFDIR}/elasticsearch.yml"
export ELASTICSEARCH_TMPDIR="${ELASTICSEARCH_BASEDIR}/tmp"
export ELASTICSEARCH_LOGDIR="${ELASTICSEARCH_BASEDIR}/logs"
export PATH="${ELASTICSEARCH_BASEDIR}/bin:$PATH"
export ELASTICSEARCH_DAEMON_USER="${ELASTICSEARCH_DAEMON_USER:-elasticsearch}"
export ELASTICSEARCH_DAEMON_GROUP="${ELASTICSEARCH_DAEMON_GROUP:-elasticsearch}"
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
    # Auxiliary functions
    validate_node_type() {
        case "$ELASTICSEARCH_NODE_TYPE" in
            coordinating|data|ingest|master)
                ;;
            *)
                error "Invalid node type $ELASTICSEARCH_NODE_TYPE. Supported types are 'coordinating/data/ingest/master'"
                exit 1
        esac
    }

    debug "Validating settings in ELASTICSEARCH_* env vars..."
    local validate_port_args=()
    ! am_i_root && validate_port_args+=("-unprivileged")
    for var in "ELASTICSEARCH_PORT_NUMBER" "ELASTICSEARCH_NODE_PORT_NUMBER"; do
        if ! err=$(validate_port "${validate_port_args[@]}" "${!var}"); then
            error "An invalid port was specified in the environment variable $var: $err"
            exit 1
        fi
    done
    is_boolean_yes "$ELASTICSEARCH_IS_DEDICATED_NODE" && validate_node_type
    if [[ -n "$ELASTICSEARCH_BIND_ADDRESS" ]] && ! validate_ipv4 "$ELASTICSEARCH_BIND_ADDRESS"; then
        error "The Bind Address specified in the environment variable ELASTICSEARCH_BIND_ADDRESS is not a valid IPv4"
        exit 1
    fi
}

# Bash math operations cannot handle float or complex math operations
calc() {
    local expr="${1:?missing expression}"
    perl <<<"use POSIX qw/ceil/;print $expr"
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

    info "Configuration Elasticsearch cluster settings..."
    elasticsearch_conf_set network.host "$(get_machine_ip)"
    elasticsearch_conf_set network.publish_host "$(get_machine_ip)"
    elasticsearch_conf_set network.bind_host "$(bind_address)"
    elasticsearch_conf_set cluster.name "$ELASTICSEARCH_CLUSTER_NAME"
    elasticsearch_conf_set node.name "${ELASTICSEARCH_NODE_NAME:-$(hostname)}"
    if [[ -n "$ELASTICSEARCH_CLUSTER_HOSTS" ]]; then
        read -r -a host_list <<< "$(tr ',;' ' ' <<< "$ELASTICSEARCH_CLUSTER_HOSTS")"
        elasticsearch_conf_set discovery.zen.ping.unicast.hosts "${host_list[@]}"
        elasticsearch_conf_set discovery.initial_state_timeout "5m"
        elasticsearch_conf_set gateway.recover_after_nodes "$(calc "ceil(${#host_list[@]}*0.8)")"
        elasticsearch_conf_set gateway.expected_nodes "${#host_list[@]}"
        if [[ -n "$ELASTICSEARCH_MINIMUM_MASTER_NODES" ]]; then
            debug "Setting minimum master nodes for quorum to $ELASTICSEARCH_MINIMUM_MASTER_NODES..."
            elasticsearch_conf_set discovery.zen.minimum_master_nodes "$ELASTICSEARCH_MINIMUM_MASTER_NODES"
        elif [[ "${#host_list[@]}" -gt 2 ]]; then
            local min_masters=""
            min_masters=$((("${#host_list[@]}" / 2) +1))
            debug "Calculating minimum master nodes for quorum: $min_masters..."
            elasticsearch_conf_set discovery.zen.minimum_master_nodes "$min_masters"
        fi
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
    sed -r -i "s/-Xmx[0-9]+[mg]+/-Xmx${heap_size}/g" "${ELASTICSEARCH_CONFDIR}/jvm.options"
    sed -r -i "s/-Xms[0-9]+[mg]+/-Xms${heap_size}/g" "${ELASTICSEARCH_CONFDIR}/jvm.options"
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
    local old_data_dir="${ELASTICSEARCH_DATADIR}/elasticsearch"
    local old_custom_conf_file="${old_data_dir}/conf/elasticsearch_custom.yml"
    local custom_conf_file="${ELASTICSEARCH_CONFDIR}/elasticsearch_custom.yml"
    if [[ -f "$old_custom_conf_file" ]]; then
        debug "Adding old custom configuration to user configuration"
        echo "" >> "$custom_conf_file"
        cat "$old_custom_conf_file" >> "$custom_conf_file"
    fi
    debug "Adapting data to new file structure"
    find "${old_data_dir}/data" -maxdepth 1 -mindepth 1 -exec mv {} "$ELASTICSEARCH_DATADIR" \;
    debug "Removing data that is not persisted anymore from persisted directory"
    rm -rf "$old_data_dir" "${ELASTICSEARCH_DATADIR}/java"
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

    # Persisted data from old versions
    if ! is_dir_empty "$ELASTICSEARCH_DATADIR"; then
        debug "Detected persisted data from previous deployments"
        [[ -d "$ELASTICSEARCH_DATADIR/elasticsearch" ]] && [[ -f "$ELASTICSEARCH_DATADIR/elasticsearch/.initialized" ]] && migrate_old_data
    fi

    debug "Ensuring expected directories/files exist..."
    for dir in "$ELASTICSEARCH_TMPDIR" "$ELASTICSEARCH_DATADIR" "$ELASTICSEARCH_LOGDIR" "$ELASTICSEARCH_BASEDIR/plugins" "$ELASTICSEARCH_BASEDIR/modules" "$ELASTICSEARCH_CONFDIR/scripts"; do
        ensure_dir_exists "$dir"
        am_i_root && chown "$ELASTICSEARCH_DAEMON_USER:$ELASTICSEARCH_DAEMON_GROUP" "$dir"
    done

    debug "Setting default configuration"
    elasticsearch_conf_set http.port "$ELASTICSEARCH_PORT_NUMBER"
    elasticsearch_conf_set path.data "$ELASTICSEARCH_DATADIR"
    elasticsearch_conf_set transport.tcp.port "$ELASTICSEARCH_NODE_PORT_NUMBER"
    elasticsearch_cluster_configuration
    elasticsearch_configure_node_type
    elasticsearch_set_heap_size

    # User injected custom configuration
    readonly custom_conf_file="$ELASTICSEARCH_CONFDIR/elasticsearch_custom.yml"
    if [[ -f "$custom_conf_file" ]]; then
        debug "Custom configuration detected. Injecting..."
        echo "" >> "$ELASTICSEARCH_CONF_FILE"
        cat "$custom_conf_file" >> "$ELASTICSEARCH_CONF_FILE"
    fi
}

########################
# Install Elasticsearch plugins
# Globals:
#   ELASTICSEARCH_PLUGINS
# Arguments:
#   None
# Returns:
#   None
#########################
elasticsearch_install_plugins() {
    read -r -a plugins_list <<< "$(tr ',;' ' ' <<< "$ELASTICSEARCH_PLUGINS")"
    debug "Installing plugins: ${plugins_list[*]}"
    elasticsearch_conf_set plugin.mandatory "$ELASTICSEARCH_PLUGINS"
    for plugin in "${plugins_list[@]}"; do
        debug "Installing plugin: $plugin"
        if [[ "${BITNAMI_DEBUG:-false}" = true ]]; then
            elasticsearch-plugin install -b -v "$plugin"
        else
            elasticsearch-plugin install -b -v "$plugin" >/dev/null 2>&1
        fi
    done
}
