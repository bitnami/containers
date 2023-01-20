#!/bin/bash
#
# Bitnami Elasticsearch library

# shellcheck disable=SC1090,SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libversion.sh
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
#   $3 - YAML type (string, int or bool)
# Returns:
#   None
#########################
elasticsearch_conf_write() {
    local -r key="${1:?Missing key}"
    local -r value="${2:-}"
    local -r type="${3:-string}"
    local -r tempfile=$(mktemp)

    case "$type" in
    string)
        yq eval "(.${key}) |= \"${value}\"" "$ELASTICSEARCH_CONF_FILE" >"$tempfile"
        ;;
    int)
        yq eval "(.${key}) |= ${value}" "$ELASTICSEARCH_CONF_FILE" >"$tempfile"
        ;;
    bool)
        yq eval "(.${key}) |= (\"${value}\" | test(\"true\"))" "$ELASTICSEARCH_CONF_FILE" >"$tempfile"
        ;;
    *)
        error "Type unknown: ${type}"
        return 1
        ;;
    esac
    cp "$tempfile" "$ELASTICSEARCH_CONF_FILE"
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
                elasticsearch_conf_write "${key}[$i]" "${values[$i]}"
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
# Check if Elasticsearch is not running
# Globals:
#   ELASTICSEARCH_TMP_DIR
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_elasticsearch_not_running() {
    ! is_elasticsearch_running
    return "$?"
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
    local command=("${ELASTICSEARCH_BASE_DIR}/bin/elasticsearch" "-d" "-p" "${ELASTICSEARCH_TMP_DIR}/elasticsearch.pid")
    am_i_root && command=("gosu" "$ELASTICSEARCH_DAEMON_USER" "${command[@]}")
    if [[ "$BITNAMI_DEBUG" = true ]]; then
        "${command[@]}" &
    else
        "${command[@]}" >/dev/null 2>&1 &
    fi

    local counter=50
    while ! is_elasticsearch_running; do
        if [[ "$counter" -ne 0 ]]; then
            break
        fi
        sleep 2
        counter=$((counter - 1))
    done
    local log_result=""
    local log_counter=30
    while [[ -z "$log_result" ]] && [[ "$log_counter" -ne 0 ]]; do
        log_counter=$((log_counter - 1))
        log_result="$(tail -7 "$ELASTICSEARCH_LOG_FILE" | grep -i "Node" | grep -i "started")"
        sleep 2
    done
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
    if [[ $(yq eval .index.store.type "$ELASTICSEARCH_CONF_FILE") ]]; then
        debug "Custom index.store.type found in the config file. Skipping kernel validation..."
    else
        validate_sysctl_key "fs.file-max" 65536
    fi
    if [[ $(yq eval .node.store.allow_mmap "$ELASTICSEARCH_CONF_FILE") ]]; then
        debug "Custom node.store.allow_mmap found in the config file. Skipping kernel validation..."
    else
        validate_sysctl_key "vm.max_map_count" 262144
    fi
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
    local es_version es_major_version

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }

    check_multi_value() {
        if [[ " ${2} " != *" ${!1} "* ]]; then
            print_validation_error "The allowed values for ${1} are: ${2}"
        fi
    }

    validate_node_type() {
        case "$ELASTICSEARCH_NODE_TYPE" in
        coordinating | data | ingest | master) ;;

        *)
            print_validation_error "Invalid node type $ELASTICSEARCH_NODE_TYPE. Supported types are 'coordinating/data/ingest/master'"
            ;;
        esac
    }

    validate_node_roles() {
        if [ -n "$ELASTICSEARCH_NODE_ROLES" ]; then
            read -r -a roles_list <<<"$(tr ',;' ' ' <<<"$ELASTICSEARCH_NODE_ROLES")"
            if [[ "${#roles_list[@]}" -le 0 ]]; then
                warn "Setting ELASTICSEARCH_NODE_ROLES is empty and ELASTICSEARCH_IS_DEDICATED_NODE is set to true, Elasticsearch will be configured as coordinating-only node."
            fi
            for role in "${roles_list[@]}"; do
                case "$role" in
                master | data | data_content | data_hot | data_warm | data_cold | data_frozen | ingest | ml | remote_cluster_client | transform) ;;

                *)
                    print_validation_error "Invalid node role '$role'. Supported roles are 'master,data,data_content,data_hot,data_warm,data_cold,data_frozen,ingest,ml,remote_cluster_client,transform'"
                    ;;
                esac
            done
        fi
    }

    # Temporary fix until ELASTICSEARCH_NODE_TYPE is removed to ensure the correct permissions to run 'elasticsearch --version'
    debug "Ensuring expected directories/files exist..."
    am_i_root && ensure_user_exists "$ELASTICSEARCH_DAEMON_USER" --group "$ELASTICSEARCH_DAEMON_GROUP"
    for dir in "$ELASTICSEARCH_TMP_DIR" "$ELASTICSEARCH_LOGS_DIR" "$ELASTICSEARCH_PLUGINS_DIR" "$ELASTICSEARCH_BASE_DIR/modules" "$ELASTICSEARCH_CONF_DIR"; do
        ensure_dir_exists "$dir"
        am_i_root && chown -R "$ELASTICSEARCH_DAEMON_USER:$ELASTICSEARCH_DAEMON_GROUP" "$dir"
    done

    es_version="$(elasticsearch_get_version)"
    es_major_version="$(get_sematic_version "$es_version" 1)"

    debug "Validating settings in ELASTICSEARCH_* env vars..."
    for var in "ELASTICSEARCH_HTTP_PORT_NUMBER" "ELASTICSEARCH_TRANSPORT_PORT_NUMBER"; do
        if ! err=$(validate_port "${!var}"); then
            print_validation_error "An invalid port was specified in the environment variable $var: $err"
        fi
    done

    if ! is_boolean_yes "$ELASTICSEARCH_IS_DEDICATED_NODE"; then
        warn "Setting ELASTICSEARCH_IS_DEDICATED_NODE is disabled."
        warn "ELASTICSEARCH_NODE_ROLES and ELASTICSEARCH_NODE_TYPE will be ignored and Elasticsearch will asume all different roles."
    else
        # Node types deprecated in Elasticsearch 8
        if [[ -n "$ELASTICSEARCH_NODE_TYPE" ]] && [[ "$es_major_version" -ge 8 ]] ; then
            print_validation_error "Setting ELASTICSEARCH_NODE_TYPE is not available when using Elasticsearch 8, use ELASTICSEARCH_NODE_ROLES instead."
        fi

        if [[ "$es_major_version" -ge 8 ]]; then
            validate_node_roles
        elif [[ "$es_major_version" -eq 7 ]]; then
            if [[ -n "$ELASTICSEARCH_NODE_TYPE" ]]; then
                warn "Setting ELASTICSEARCH_NODE_TYPE will be deprecated soon. We recommend using ELASTICSEARCH_NODE_ROLES instead."
                validate_node_type
            else
                validate_node_roles
            fi
        fi
    fi

    if [[ -n "$ELASTICSEARCH_BIND_ADDRESS" ]] && ! validate_ipv4 "$ELASTICSEARCH_BIND_ADDRESS"; then
        print_validation_error "The Bind Address specified in the environment variable ELASTICSEARCH_BIND_ADDRESS is not a valid IPv4"
    fi

    if is_boolean_yes "$ELASTICSEARCH_ENABLE_SECURITY"; then
        if ! is_boolean_yes "$ELASTICSEARCH_SKIP_TRANSPORT_TLS"; then
            check_multi_value "ELASTICSEARCH_TLS_VERIFICATION_MODE" "full certificate none"
            if is_boolean_yes "$ELASTICSEARCH_TRANSPORT_TLS_USE_PEM"; then
                if [[ ! -f "$ELASTICSEARCH_TRANSPORT_TLS_NODE_CERT_LOCATION" ]] || [[ ! -f "$ELASTICSEARCH_TRANSPORT_TLS_NODE_KEY_LOCATION" ]] || [[ ! -f "$ELASTICSEARCH_TRANSPORT_TLS_CA_CERT_LOCATION" ]]; then
                    print_validation_error "In order to configure the TLS encryption for Elasticsearch Transport you must provide your node key, certificate and a valid certification_authority certificate."
                fi
            elif [[ ! -f "$ELASTICSEARCH_TRANSPORT_TLS_KEYSTORE_LOCATION" ]] || [[ ! -f "$ELASTICSEARCH_TRANSPORT_TLS_TRUSTSTORE_LOCATION" ]]; then
                print_validation_error "In order to configure the TLS encryption for Elasticsearch Transport with JKS/PKCS12 certs you must mount a valid keystore and truststore."
            fi
        fi

        if is_boolean_yes "$ELASTICSEARCH_ENABLE_REST_TLS"; then
            if is_boolean_yes "$ELASTICSEARCH_HTTP_TLS_USE_PEM"; then
                if [[ ! -f "$ELASTICSEARCH_HTTP_TLS_NODE_CERT_LOCATION" ]] || [[ ! -f "$ELASTICSEARCH_HTTP_TLS_NODE_KEY_LOCATION" ]] || [[ ! -f "$ELASTICSEARCH_HTTP_TLS_CA_CERT_LOCATION" ]]; then
                    print_validation_error "In order to configure the TLS encryption for Elasticsearch you must provide your node key, certificate and a valid certification_authority certificate."
                fi
            elif [[ ! -f "$ELASTICSEARCH_HTTP_TLS_KEYSTORE_LOCATION" ]] || [[ ! -f "$ELASTICSEARCH_HTTP_TLS_TRUSTSTORE_LOCATION" ]]; then
                print_validation_error "In order to configure the TLS encryption for Elasticsearch with JKS/PKCS12 certs you must mount a valid keystore and truststore."
            fi
        fi
    fi

    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}

########################
# Determine the hostname by which to contact the locally running mongo daemon
# Returns:
#   The value of $ELASTICSEARCH_ADVERTISED_HOSTNAME or the current host address
########################
get_elasticsearch_hostname() {
    if [[ -n "$ELASTICSEARCH_ADVERTISED_HOSTNAME" ]]; then
        echo "$ELASTICSEARCH_ADVERTISED_HOSTNAME"
    else
        get_machine_ip
    fi
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
            echo "$ELASTICSEARCH_BIND_ADDRESS"
        else
            echo "0.0.0.0"
        fi
    }

    is_node_type_master() {
        if is_boolean_yes "$ELASTICSEARCH_IS_DEDICATED_NODE"; then
            if [[ -n "$ELASTICSEARCH_NODE_TYPE" ]]; then
                if [[ "$ELASTICSEARCH_NODE_TYPE" = "master" ]]; then
                    true
                else
                    false
                fi
            else
                if [ -n "$ELASTICSEARCH_NODE_ROLES" ]; then
                    read -r -a roles_list <<<"$(tr ',;' ' ' <<<"$ELASTICSEARCH_NODE_ROLES")"
                    if [[ " ${roles_list[*]} " = *" master "* ]]; then
                        true
                    else
                        false
                    fi
                else
                    false
                fi
            fi
        else
            true
        fi
    }

    info "Configuring Elasticsearch cluster settings..."
    elasticsearch_conf_set network.host "$(get_elasticsearch_hostname)"
    elasticsearch_conf_set network.publish_host "$(get_elasticsearch_hostname)"
    elasticsearch_conf_set network.bind_host "$(bind_address)"
    elasticsearch_conf_set cluster.name "$ELASTICSEARCH_CLUSTER_NAME"
    elasticsearch_conf_set node.name "${ELASTICSEARCH_NODE_NAME:-$(hostname)}"

    if [[ -n "$ELASTICSEARCH_CLUSTER_HOSTS" ]]; then
        read -r -a host_list <<<"$(tr ',;' ' ' <<<"$ELASTICSEARCH_CLUSTER_HOSTS")"
        master_list=("${host_list[@]}")
        if [[ -n "$ELASTICSEARCH_CLUSTER_MASTER_HOSTS" ]]; then
            read -r -a master_list <<<"$(tr ',;' ' ' <<<"$ELASTICSEARCH_CLUSTER_MASTER_HOSTS")"
        fi
        es_version="$(elasticsearch_get_version)"
        es_major_version="$(get_sematic_version "$es_version" 1)"
        elasticsearch_conf_set discovery.seed_hosts "${host_list[@]}"
        if is_node_type_master; then
            elasticsearch_conf_set cluster.initial_master_nodes "${master_list[@]}"
        fi
        elasticsearch_conf_set discovery.initial_state_timeout "10m"
    else
        elasticsearch_conf_set "discovery.type" "single-node"
    fi
}

########################
# Configure Elasticsearch TLS settings
# Globals:
#   ELASTICSEARCH_*
# Arguments:
#   None
# Returns:
#   None
#########################
elasticsearch_transport_tls_configuration(){
    info "Configuring Elasticsearch Transport TLS settings..."
    elasticsearch_conf_set xpack.security.transport.ssl.enabled "true"
    elasticsearch_conf_set xpack.security.transport.ssl.verification_mode "$ELASTICSEARCH_TLS_VERIFICATION_MODE"

    if is_boolean_yes "$ELASTICSEARCH_TRANSPORT_TLS_USE_PEM"; then
        debug "Configuring Transport Layer TLS settings using PEM certificates..."
        ! is_empty_value "$ELASTICSEARCH_TRANSPORT_TLS_KEY_PASSWORD" && elasticsearch_set_key_value "xpack.security.transport.ssl.secure_key_passphrase" "$ELASTICSEARCH_TRANSPORT_TLS_KEY_PASSWORD"
        elasticsearch_conf_set xpack.security.transport.ssl.key "$ELASTICSEARCH_TRANSPORT_TLS_NODE_KEY_LOCATION"
        elasticsearch_conf_set xpack.security.transport.ssl.certificate "$ELASTICSEARCH_TRANSPORT_TLS_NODE_CERT_LOCATION"
        elasticsearch_conf_set xpack.security.transport.ssl.certificate_authorities "$ELASTICSEARCH_TRANSPORT_TLS_CA_CERT_LOCATION"
    else
        debug "Configuring Transport Layer TLS settings using JKS/PKCS certificates..."
        ! is_empty_value "$ELASTICSEARCH_TRANSPORT_TLS_KEYSTORE_PASSWORD" && elasticsearch_set_key_value "xpack.security.transport.ssl.keystore.secure_password" "$ELASTICSEARCH_TRANSPORT_TLS_KEYSTORE_PASSWORD"
        ! is_empty_value "$ELASTICSEARCH_TRANSPORT_TLS_TRUSTSTORE_PASSWORD" && elasticsearch_set_key_value "xpack.security.transport.ssl.truststore.secure_password" "$ELASTICSEARCH_TRANSPORT_TLS_TRUSTSTORE_PASSWORD"
        elasticsearch_conf_set xpack.security.transport.ssl.keystore.path "$ELASTICSEARCH_TRANSPORT_TLS_KEYSTORE_LOCATION"
        elasticsearch_conf_set xpack.security.transport.ssl.truststore.path "$ELASTICSEARCH_TRANSPORT_TLS_TRUSTSTORE_LOCATION"
    fi
}

########################
# Configure Elasticsearch TLS settings
# Globals:
#   ELASTICSEARCH_*
# Arguments:
#   None
# Returns:
#   None
#########################
elasticsearch_http_tls_configuration(){
    info "Configuring Elasticsearch HTTP TLS settings..."
    elasticsearch_conf_set xpack.security.http.ssl.enabled "true"
    if is_boolean_yes "$ELASTICSEARCH_HTTP_TLS_USE_PEM"; then
        debug "Configuring REST API TLS settings using PEM certificates..."
        ! is_empty_value "$ELASTICSEARCH_HTTP_TLS_KEY_PASSWORD" && elasticsearch_set_key_value "xpack.security.http.ssl.secure_key_passphrase" "$ELASTICSEARCH_HTTP_TLS_KEY_PASSWORD"
        elasticsearch_conf_set xpack.security.http.ssl.key "$ELASTICSEARCH_HTTP_TLS_NODE_KEY_LOCATION"
        elasticsearch_conf_set xpack.security.http.ssl.certificate "$ELASTICSEARCH_HTTP_TLS_NODE_CERT_LOCATION"
        elasticsearch_conf_set xpack.security.http.ssl.certificate_authorities "$ELASTICSEARCH_HTTP_TLS_CA_CERT_LOCATION"
    else
        debug "Configuring REST API TLS settings using JKS/PKCS certificates..."
        ! is_empty_value "$ELASTICSEARCH_HTTP_TLS_KEYSTORE_PASSWORD" && elasticsearch_set_key_value "xpack.security.http.ssl.keystore.secure_password" "$ELASTICSEARCH_HTTP_TLS_KEYSTORE_PASSWORD"
        ! is_empty_value "$ELASTICSEARCH_HTTP_TLS_TRUSTSTORE_PASSWORD" && elasticsearch_set_key_value "xpack.security.http.ssl.truststore.secure_password" "$ELASTICSEARCH_HTTP_TLS_TRUSTSTORE_PASSWORD"
        elasticsearch_conf_set xpack.security.http.ssl.keystore.path "$ELASTICSEARCH_HTTP_TLS_KEYSTORE_LOCATION"
        elasticsearch_conf_set xpack.security.http.ssl.truststore.path "$ELASTICSEARCH_HTTP_TLS_TRUSTSTORE_LOCATION"
    fi
}

########################
# Extend Elasticsearch cluster settings with custom, user-provided config
# Globals:
#  ELASTICSEARCH_*
# Arguments:
#   None
# Returns:
#   None
#########################
elasticsearch_custom_configuration() {
    local custom_conf_file="${ELASTICSEARCH_CONF_DIR}/my_elasticsearch.yml"
    local -r tempfile=$(mktemp)
    [[ ! -s "$custom_conf_file" ]] && return
    info "Adding custom configuration"
    yq eval-all 'select(fileIndex == 0) * select(fileIndex == 1)' "$ELASTICSEARCH_CONF_FILE" "$custom_conf_file" >"$tempfile"
    cp "$tempfile" "$ELASTICSEARCH_CONF_FILE"
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
        coordinating) ;;

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
        is_ingest="true"
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
# Configure Elasticsearch node roles.
# There are 3 scenarios:
# * If ELASTICSEARCH_IS_DEDICATED_NODE is disabled, 'node.roles' is omitted and Elasticsearch assumes all the roles (check docs).
# * Otherwise, 'node.roles' with a list of roles provided with ELASTICSEARCH_NODE_ROLES.
# * In addition, if ELASTICSEARCH_NODE_ROLES is empty, node.roles will be configured empty, meaning that the role is 'coordinating-only'.
#
# Docs ref: https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-node.html
#
# Globals:
#  ELASTICSEARCH_*
# Arguments:
#   None
# Returns:
#   None
#########################
elasticsearch_configure_node_roles() {
    debug "Configure Elasticsearch Node roles..."

    local set_repo_path="no"
    read -r -a roles_list <<<"$(tr ',;' ' ' <<<"$ELASTICSEARCH_NODE_ROLES")"
    if is_boolean_yes "$ELASTICSEARCH_IS_DEDICATED_NODE"; then
        if [[ "${#roles_list[@]}" -eq 0 ]]; then
            elasticsearch_conf_write node.roles "[]" int
        else
            elasticsearch_conf_set node.roles "${roles_list[@]}"
            for role in "${roles_list[@]}"; do
                case "$role" in
                    master | data | data_content | data_hot | data_warm | data_cold | data_frozen)
                        set_repo_path="yes"
                        ;;
                    *) ;;
                esac
            done
        fi
    else
        set_repo_path="yes"
    fi



    if is_boolean_yes "$set_repo_path" && [[ -n "$ELASTICSEARCH_FS_SNAPSHOT_REPO_PATH" ]]; then
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

    # Remove heap.options if it already exists
    rm -f "${ELASTICSEARCH_CONF_DIR}/jvm.options.d/heap.options"

    if [[ -n "$ELASTICSEARCH_HEAP_SIZE" ]]; then
        debug "Using specified values for Xmx and Xms heap options..."
        heap_size="$ELASTICSEARCH_HEAP_SIZE"
    else
        debug "Calculating appropriate Xmx and Xms values..."
        local machine_mem=""
        machine_mem="$(get_total_memory)"
        if [[ "$machine_mem" -lt 65536 ]]; then
            local max_allowed_memory
            local calculated_heap_size
            calculated_heap_size="$((machine_mem / 2))"
            max_allowed_memory="$((ELASTICSEARCH_MAX_ALLOWED_MEMORY_PERCENTAGE * machine_mem))"
            max_allowed_memory="$((max_allowed_memory / 100))"
            # Allow for absolute memory limit when calculating limit from percentage
            if [[ -n "$ELASTICSEARCH_MAX_ALLOWED_MEMORY" && "$max_allowed_memory" -gt "$ELASTICSEARCH_MAX_ALLOWED_MEMORY" ]]; then
                max_allowed_memory="$ELASTICSEARCH_MAX_ALLOWED_MEMORY"
            fi
            if [[ "$calculated_heap_size" -gt "$max_allowed_memory" ]]; then
                info "Calculated Java heap size of ${calculated_heap_size} will be limited to ${max_allowed_memory}"
                calculated_heap_size="$max_allowed_memory"
            fi
            heap_size="${calculated_heap_size}m"

        else
            heap_size=32768m
        fi
    fi
    debug "Setting '-Xmx${heap_size} -Xms${heap_size}' heap options..."
    cat >"${ELASTICSEARCH_CONF_DIR}/jvm.options.d/heap.options" <<EOF
-Xms${heap_size}
-Xmx${heap_size}
EOF
    am_i_root && chown "$ELASTICSEARCH_DAEMON_USER:$ELASTICSEARCH_DAEMON_GROUP" "${ELASTICSEARCH_CONF_DIR}/jvm.options.d/heap.options"

    # Avoid exit code of previous commands to affect the result of this function
    true
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
        echo "" >>"$custom_conf_file"
        cat "$old_custom_conf_file" >>"$custom_conf_file"
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

    read -r -a data_dirs_list <<<"$(tr ',;' ' ' <<<"$ELASTICSEARCH_DATA_DIR_LIST")"
    if [[ "${#data_dirs_list[@]}" -gt 0 ]]; then
        info "Multiple data directories specified, ignoring ELASTICSEARCH_DATA_DIR environment variable."
    else
        data_dirs_list+=("$ELASTICSEARCH_DATA_DIR")

        # Persisted data from old versions
        if ! is_dir_empty "$ELASTICSEARCH_DATA_DIR"; then
            debug "Detected persisted data from previous deployments"
            [[ -d "$ELASTICSEARCH_DATA_DIR/elasticsearch" ]] && [[ -f "$ELASTICSEARCH_DATA_DIR/elasticsearch/.initialized" ]] && migrate_old_data
        fi
    fi

    debug "Ensuring expected directories/files exist..."
    for dir in "$ELASTICSEARCH_TMP_DIR" "$ELASTICSEARCH_LOGS_DIR" "$ELASTICSEARCH_PLUGINS_DIR" "$ELASTICSEARCH_BASE_DIR/modules" "$ELASTICSEARCH_CONF_DIR"; do
        ensure_dir_exists "$dir"
        am_i_root && chown -R "$ELASTICSEARCH_DAEMON_USER:$ELASTICSEARCH_DAEMON_GROUP" "$dir"
    done
    for dir in "${data_dirs_list[@]}"; do
        ensure_dir_exists "$dir"
        am_i_root && is_mounted_dir_empty "$dir" && chown -R "$ELASTICSEARCH_DAEMON_USER:$ELASTICSEARCH_DAEMON_GROUP" "$dir"
    done

    if [[ -f "$ELASTICSEARCH_CONF_FILE" ]]; then
        info "Custom configuration file detected, using it..."
    else
        info "Setting default configuration"
        touch "$ELASTICSEARCH_CONF_FILE"
        elasticsearch_conf_set http.port "$ELASTICSEARCH_HTTP_PORT_NUMBER"
        elasticsearch_conf_set path.data "${data_dirs_list[@]}"
        elasticsearch_conf_set transport.port "$ELASTICSEARCH_TRANSPORT_PORT_NUMBER"
        [[ -n "$ELASTICSEARCH_ACTION_DESTRUCTIVE_REQUIRES_NAME" ]] && elasticsearch_conf_set action.destructive_requires_name "$(is_boolean_yes "$ELASTICSEARCH_ACTION_DESTRUCTIVE_REQUIRES_NAME" && echo "true" || echo "false")"
        is_boolean_yes "$ELASTICSEARCH_LOCK_ALL_MEMORY" && elasticsearch_conf_set bootstrap.memory_lock "true"
        elasticsearch_cluster_configuration
        if [[ -n "$ELASTICSEARCH_NODE_TYPE" ]]; then
            elasticsearch_configure_node_type
        else
            elasticsearch_configure_node_roles
        fi
        elasticsearch_custom_configuration
        # X-Pack settings.
        elasticsearch_conf_set xpack.security.enabled "$(is_boolean_yes "$ELASTICSEARCH_ENABLE_SECURITY" && echo "true" || echo "false")"
        ! is_empty_value "$ELASTICSEARCH_PASSWORD" && elasticsearch_set_key_value "bootstrap.password" "$ELASTICSEARCH_PASSWORD"
        if is_boolean_yes "$ELASTICSEARCH_ENABLE_SECURITY"; then
            is_boolean_yes "$ELASTICSEARCH_ENABLE_REST_TLS" && elasticsearch_http_tls_configuration
            ! is_boolean_yes "$ELASTICSEARCH_SKIP_TRANSPORT_TLS" && elasticsearch_transport_tls_configuration
            if is_boolean_yes "$ELASTICSEARCH_ENABLE_FIPS_MODE"; then
                elasticsearch_conf_set xpack.security.fips_mode.enabled "true"
                elasticsearch_conf_set xpack.security.authc.password_hashing.algorithm "pbkdf2"
            fi
        fi
        # Latest Elasticseach releases install x-pack-ml  by default. Since we have faced some issues with this library on certain platforms,
        # currently we are disabling this machine learning module whatsoever by defining "xpack.ml.enabled=false" in the "elasicsearch.yml" file
        if is_dir_empty "${ELASTICSEARCH_BASE_DIR}/modules/x-pack-ml/platform/linux-"*; then
            elasticsearch_conf_set xpack.ml.enabled "false"
        fi
    fi

    if is_file_writable "${ELASTICSEARCH_CONF_DIR}/jvm.options" && is_file_writable "${ELASTICSEARCH_CONF_DIR}/jvm.options.d"; then
        if is_boolean_yes "$ELASTICSEARCH_DISABLE_JVM_HEAP_DUMP"; then
            info "Disabling JVM heap dumps..."
            replace_in_file "${ELASTICSEARCH_CONF_DIR}/jvm.options" "-XX:[+]HeapDumpOnOutOfMemoryError" "# -XX:+HeapDumpOnOutOfMemoryError"
        fi
        if is_boolean_yes "$ELASTICSEARCH_DISABLE_GC_LOGS"; then
            info "Disabling JVM GC logs..."
            replace_in_file "${ELASTICSEARCH_CONF_DIR}/jvm.options" "(^.*logs[/]gc.log.*$)" "# \1"
        fi
        elasticsearch_set_heap_size
    else
        warn "The JVM options configuration files are not writable. Configurations based on environment variables will not be applied"
    fi
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
    read -r -a plugins_list <<<"$(tr ',;' ' ' <<<"$ELASTICSEARCH_PLUGINS")"
    local mandatory_plugins=""

    # Helper function for extracting the plugin name from a tarball name
    # Examples:
    #   get_plugin_name plugin -> plugin
    #   get_plugin_name file://plugin.zip -> plugin
    #   get_plugin_name http://plugin-0.1.2.zip -> plugin
    get_plugin_name() {
        local plugin="${1:?missing plugin}"
        # Remove any paths, and strip both the .zip extension and the version
        basename "$plugin" | sed -E -e 's/.zip$//' -e 's/-[0-9]+\.[0-9]+(\.[0-9]+){0,}$//'
    }

    # Collect plugins that should be installed offline
    read -r -a mounted_plugins <<<"$(find "$ELASTICSEARCH_MOUNTED_PLUGINS_DIR" -type f -name "*.zip" -print0 | xargs -0)"
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
# Set Elasticsearch keystore values
# Globals:
#   ELASTICSEARCH_*
# Arguments:
#   None
# Returns:
#   None
#########################
elasticsearch_set_keys() {
    read -r -a keys_list <<<"$(tr ',;' ' ' <<<"$ELASTICSEARCH_KEYS")"
    if [[ "${#keys_list[@]}" -gt 0 ]]; then
        for key_value in "${keys_list[@]}"; do
            read -r -a key_value <<<"$(tr '=' ' ' <<<"$key_value")"
            local key="${key_value[0]}"
            local value="${key_value[1]}"

            elasticsearch_set_key_value "$key" "$value"
        done
    fi
}

########################
# Set Elasticsearch keystore values
# Globals:
#   ELASTICSEARCH_*
# Arguments:
#   None
# Returns:
#   None
#########################
elasticsearch_set_key_value() {
    local key="${1:?missing key}"
    local value="${2:?missing value}"

    debug "Storing key: ${key}"
    elasticsearch-keystore add --stdin --force "$key" <<<"$value"

    am_i_root && chown "$ELASTICSEARCH_DAEMON_USER:$ELASTICSEARCH_DAEMON_GROUP" "${ELASTICSEARCH_CONF_DIR}/elasticsearch.keystore"
    # Avoid exit code of previous commands to affect the result of this function
    true
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
    read -r -a init_scripts <<<"$(find "$ELASTICSEARCH_INITSCRIPTS_DIR" -type f -name "*.sh" -print0 | xargs -0)"
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

########################
# Get elasticsearch version
# Globals:
#   ELASTICSEARCH_*
# Arguments:
#   None
# Returns:
#   version
#########################
elasticsearch_get_version() {
    local -a elasticsearch_cmd=("elasticsearch" "--version")
    am_i_root && elasticsearch_cmd=("gosu" "$ELASTICSEARCH_DAEMON_USER" "${elasticsearch_cmd[@]}")
    if [[ -f "$ELASTICSEARCH_CONF_FILE" ]]; then
        ES_JAVA_OPTS="-Xms1m -Xmx20m" "${elasticsearch_cmd[@]}" | grep Version: | awk -F "," '{print $1}' | awk -F ":" '{print $2}'
    else
        touch "$ELASTICSEARCH_CONF_FILE"
        ES_JAVA_OPTS="-Xms1m -Xmx20m" "${elasticsearch_cmd[@]}" | grep Version: | awk -F "," '{print $1}' | awk -F ":" '{print $2}'
        rm "$ELASTICSEARCH_CONF_FILE"
    fi
}

########################
# Modify log4j2.properties to send events to stdout instead of a logfile
# Globals:
#   ELASTICSEARCH_*
# Arguments:
#   None
# Returns:
#   None
#########################
elasticsearch_configure_logging() {
    # Back up the original file for users who'd like to use logfile logging
    cp "${ELASTICSEARCH_CONF_DIR}/log4j2.properties" "${ELASTICSEARCH_CONF_DIR}/log4j2.file.properties"

    # Replace RollingFile with Console
    replace_in_file "${ELASTICSEARCH_CONF_DIR}/log4j2.properties" "RollingFile" "Console"

    local -a delete_patterns=(
        # Remove RollingFile specific settings
        "^.*\.policies\..*$" "^.*\.filePattern.*$" "^.*\.fileName.*$" "^.*\.strategy\..*$"
        # Remove headers
        "^###.*$"
        # Remove .log and .json because of multiline configurations (filename)
        "^\s\s.*\.log" "^\s\s.*\.json"
        # Remove default rolling logger and references
        "^appender\.rolling" "appenderRef\.rolling"
        # Remove _old loggers
        "_old\."
    )
    for pattern in "${delete_patterns[@]}"; do
        remove_in_file "${ELASTICSEARCH_CONF_DIR}/log4j2.properties" "$pattern"
    done
}

########################
# Check Elasticsearch health
# Globals:
#   ELASTICSEARCH_*
# Arguments:
#   None
# Returns:
#   0 when healthy
#   1 when unhealthy
#########################
elasticsearch_healthcheck() {
    info "Checking Elasticsearch health..."
    local -r exec="curl"
    local command_args=("--silent" "--show-error" "--fail")
    local protocol="http"
    local host

    host=$(get_elasticsearch_hostname)

    is_boolean_yes "$ELASTICSEARCH_ENABLE_REST_TLS" && protocol="https" && command_args+=("-k")
    is_boolean_yes "$ELASTICSEARCH_ENABLE_SECURITY" && command_args+=("--user" "elastic:${ELASTICSEARCH_PASSWORD}")

    command_args+=("${protocol}://${host}:${ELASTICSEARCH_HTTP_PORT_NUMBER}/_cluster/health?local=true")

    if ! "$exec" "${command_args[@]}" >/dev/null; then
        return 1
    else
        return 0
    fi
}
