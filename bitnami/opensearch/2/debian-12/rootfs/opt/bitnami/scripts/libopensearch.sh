#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami Opensearch library

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

# Opensearch Functions

########################
# Bootstrap Opensearch Security by running the securityadmin.sh tool
# Globals:
#   DB_*
#   OPENSEARCH_SECURITY_*
# Arguments:
#   None
# Returns:
#   None
#########################
opensearch_security_bootstrap() {
    local failure=0
    local cmd=("${OPENSEARCH_SECURITY_DIR}/tools/securityadmin.sh" "-nhnv")

    cmd+=("-cd" "$OPENSEARCH_SECURITY_CONF_DIR")
    cmd+=("-cn" "$DB_CLUSTER_NAME")
    cmd+=("-h" "$(get_elasticsearch_hostname)")
    cmd+=("-cacert" "$DB_CA_CERT_LOCATION")
    cmd+=("-cert" "$OPENSEARCH_SECURITY_ADMIN_CERT_LOCATION")
    cmd+=("-key" "$OPENSEARCH_SECURITY_ADMIN_KEY_LOCATION")

    elasticsearch_start

    info "Running Opensearch Admin tool..."
    "${cmd[@]}" || failure=$?
    elasticsearch_stop

    return "$failure"
}

########################
# Write the username information inside the Opendistro Security internal_users.yml configuration file
# Globals:
#   DB_*
#   OPENSEARCH_SECURITY_*
# Arguments:
#   None
# Returns:
#   None
#########################
opensearch_security_internal_user_set() {
    local username="${1:?missing key}"
    local password="${2:?missing key}"
    local reserved="${3:?missing key}"
    read -r -a backend_roles <<<"$(tr ',;' ' ' <<<"${4:-}")"
    read -r -a attributes <<<"$(tr ',;' ' ' <<<"${5:-}")"
    local description="${6:-}"

    local hash

    hash=$("${OPENSEARCH_SECURITY_DIR}/tools/hash.sh" -p "$password" | sed '/^\*\*/d')
    yq -i eval ".$username.hash = \"$hash\"" "${OPENSEARCH_SECURITY_CONF_DIR}/internal_users.yml"

    if [[ -n "${backend_roles[*]:-}" ]]; then
        for backend_role in "${backend_roles[@]}"; do
            yq -i eval ".${username}.backend_roles += [\"${backend_role}\"]" "${OPENSEARCH_SECURITY_CONF_DIR}/internal_users.yml"
        done
    fi

    if [[ -n "${attributes[*]:-}" ]]; then
        for attribute in "${attributes[@]}"; do
            yq -i eval ".${username}.attributes += [\"${attribute}\"]" "${OPENSEARCH_SECURITY_CONF_DIR}/internal_users.yml"
        done
    fi

    yq -i eval ".${username}.description = \"$description\"" "${OPENSEARCH_SECURITY_CONF_DIR}/internal_users.yml"
    yq -i eval ".${username}.reserved = $reserved" "${OPENSEARCH_SECURITY_CONF_DIR}/internal_users.yml"
}

########################
# Configure Opensearch Security built-in users and passwords
# Globals:
#   ELASTICSEARCH_*
#   OPENSEARCH_SECURITY_*
# Arguments:
#   None
# Returns:
#   None
#########################
opensearch_security_configure_users() {
    info "Configuring Opensearch security users and roles..."
    # Execute permission for configuration binaries
    chmod +x "${OPENSEARCH_SECURITY_DIR}/tools/hash.sh"
    chmod +x "${OPENSEARCH_SECURITY_DIR}/tools/securityadmin.sh"
    # Opensearch security configuration
    if [ ! -f "${OPENSEARCH_SECURITY_DIR}/internal_users.yml" ]; then
        # Delete content of the demo file
        echo "" > "${OPENSEARCH_SECURITY_CONF_DIR}/internal_users.yml"

        yq -i eval '._meta.type = "internalusers"' "${OPENSEARCH_SECURITY_CONF_DIR}/internal_users.yml"
        yq -i eval '._meta.config_version = "2"' "${OPENSEARCH_SECURITY_CONF_DIR}/internal_users.yml"

        # Create default users
        opensearch_security_internal_user_set "$OPENSEARCH_USERNAME" "$OPENSEARCH_PASSWORD" true "admin" "" "Admin user"
        opensearch_security_internal_user_set "kibanaserver" "$OPENSEARCH_DASHBOARDS_PASSWORD" true "" "" "Kibana Server user"
        opensearch_security_internal_user_set "logstash" "$LOGSTASH_PASSWORD" true "logstash" "" "Logstash user"
    fi
}

########################
# Configure Opensearch TLS settings
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
opensearch_transport_tls_configuration(){
    info "Configuring Opensearch Transport TLS settings..."
    elasticsearch_conf_set plugins.security.ssl.transport.enabled "true"
    elasticsearch_conf_write plugins.security.ssl.transport.enforce_hostname_verification "$DB_TLS_VERIFICATION_MODE" bool

    if is_boolean_yes "$DB_TRANSPORT_TLS_USE_PEM"; then
        debug "Configuring Transport Layer TLS settings using PEM certificates..."
        ! is_empty_value "$DB_TRANSPORT_TLS_KEY_PASSWORD" && elasticsearch_conf_set plugins.security.ssl.transport.pemkey_password "$DB_TRANSPORT_TLS_KEY_PASSWORD"
        elasticsearch_conf_set plugins.security.ssl.transport.pemkey_filepath "$DB_TRANSPORT_TLS_NODE_KEY_LOCATION"
        elasticsearch_conf_set plugins.security.ssl.transport.pemcert_filepath "$DB_TRANSPORT_TLS_NODE_CERT_LOCATION"
        elasticsearch_conf_set plugins.security.ssl.transport.pemtrustedcas_filepath "$DB_TRANSPORT_TLS_CA_CERT_LOCATION"
    else
        debug "Configuring Transport Layer TLS settings using JKS/PKCS certificates..."
        ! is_empty_value "$DB_TRANSPORT_TLS_KEYSTORE_PASSWORD" && elasticsearch_conf_set plugins.security.ssl.transport.keystore_password "$DB_TRANSPORT_TLS_KEYSTORE_PASSWORD"
        ! is_empty_value "$DB_TRANSPORT_TLS_TRUSTSTORE_PASSWORD" && elasticsearch_conf_set plugins.security.ssl.transport.truststore_password "$DB_TRANSPORT_TLS_TRUSTSTORE_PASSWORD"
        elasticsearch_conf_set plugins.security.ssl.transport.keystore_filepath "$DB_TRANSPORT_TLS_KEYSTORE_LOCATION"
        elasticsearch_conf_set plugins.security.ssl.transport.truststore_filepath "$DB_TRANSPORT_TLS_TRUSTSTORE_LOCATION"
    fi
}

########################
# Configure TLS settings
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
opensearch_http_tls_configuration(){
    info "Configuring ${DB_FLAVOR^^} HTTP TLS settings..."
    elasticsearch_conf_set plugins.security.ssl.http.enabled "true"
    if is_boolean_yes "$DB_HTTP_TLS_USE_PEM"; then
        debug "Configuring REST API TLS settings using PEM certificates..."
        ! is_empty_value "$DB_HTTP_TLS_KEY_PASSWORD" && elasticsearch_conf_set plugins.security.ssl.http.key "$DB_HTTP_TLS_KEY_PASSWORD"
        elasticsearch_conf_set plugins.security.ssl.http.pemkey_filepath "$DB_HTTP_TLS_NODE_KEY_LOCATION"
        elasticsearch_conf_set plugins.security.ssl.http.pemcert_filepath "$DB_HTTP_TLS_NODE_CERT_LOCATION"
        elasticsearch_conf_set plugins.security.ssl.http.pemtrustedcas_filepath "$DB_HTTP_TLS_CA_CERT_LOCATION"
    else
        debug "Configuring REST API TLS settings using JKS/PKCS certificates..."
        ! is_empty_value "$DB_HTTP_TLS_KEYSTORE_PASSWORD" && elasticsearch_conf_set plugins.security.ssl.http.keystore_password "$DB_HTTP_TLS_KEYSTORE_PASSWORD"
        ! is_empty_value "$DB_HTTP_TLS_TRUSTSTORE_PASSWORD" && elasticsearch_conf_set plugins.security.ssl.http.truststore_password "$DB_HTTP_TLS_TRUSTSTORE_PASSWORD"
        elasticsearch_conf_set plugins.security.ssl.http.keystore_filepath "$DB_HTTP_TLS_KEYSTORE_LOCATION"
        elasticsearch_conf_set plugins.security.ssl.http.truststore_filepath "$DB_HTTP_TLS_TRUSTSTORE_LOCATION"
    fi
}

#!/bin/bash
#
# Bitnami Elasticsearch/Opensearch common library

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
#   DB_CONF_FILE
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
        yq eval "(.${key}) |= \"${value}\"" "$DB_CONF_FILE" >"$tempfile"
        ;;
    int)
        yq eval "(.${key}) |= ${value}" "$DB_CONF_FILE" >"$tempfile"
        ;;
    bool)
        yq eval "(.${key}) |= (\"${value}\" | test(\"true\"))" "$DB_CONF_FILE" >"$tempfile"
        ;;
    *)
        error "Type unknown: ${type}"
        return 1
        ;;
    esac
    cp "$tempfile" "$DB_CONF_FILE"
}

########################
# Set a configuration setting value
# Globals:
#   DB_CONF_FILE
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
        stderr_print "$key"
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
#   DB_TMP_DIR
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_elasticsearch_running() {
    local pid
    pid="$(get_pid_from_file "$DB_PID_FILE")"

    if [[ -z "$pid" ]]; then
        false
    else
        is_service_running "$pid"
    fi
}

########################
# Check if Elasticsearch is not running
# Globals:
#   DB_TMP_DIR
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
#   DB_TMP_DIR
# Arguments:
#   None
# Returns:
#   None
#########################
elasticsearch_stop() {
    ! is_elasticsearch_running && return
    debug "Stopping ${DB_FLAVOR^}..."
    stop_service_using_pid "$DB_PID_FILE"
}

########################
# Start Elasticsearch and wait until it's ready
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
elasticsearch_start() {
    is_elasticsearch_running && return

    debug "Starting ${DB_FLAVOR^}..."
    local command=("${DB_BASE_DIR}/bin/${DB_FLAVOR}" "-d" "-p" "$DB_PID_FILE")
    am_i_root && command=("run_as_user" "$DB_DAEMON_USER" "${command[@]}")
    if [[ "$BITNAMI_DEBUG" = true ]]; then
        "${command[@]}" &
    else
        "${command[@]}" >/dev/null 2>&1 &
    fi

    local retries=50
    local seconds=2
    # Check the process is running
    retry_while "is_elasticsearch_running" "$retries" "$seconds"
    # Check Elasticsearch API is reachable
    retry_while "elasticsearch_healthcheck" "$retries" "$seconds"
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
            error "Invalid kernel settings. ${DB_FLAVOR^} requires at least: $key = $value"
            exit 1
        fi
    }

    debug "Validating Kernel settings..."
    if [[ $(yq eval .index.store.type "$DB_CONF_FILE") ]]; then
        debug "Custom index.store.type found in the config file. Skipping kernel validation..."
    else
        validate_sysctl_key "fs.file-max" 65536
    fi
    if [[ $(yq eval .node.store.allow_mmap "$DB_CONF_FILE") ]]; then
        debug "Custom node.store.allow_mmap found in the config file. Skipping kernel validation..."
    else
        validate_sysctl_key "vm.max_map_count" 262144
    fi
}

########################
# Validate settings in DB_* env vars
# Globals:
#   DB_*
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

    validate_node_roles() {
        if [ -n "$DB_NODE_ROLES" ]; then
            read -r -a roles_list <<<"$(get_elasticsearch_roles)"
            local master_role="master"
            [[ "$DB_FLAVOR" = "opensearch" && "$APP_VERSION" =~ ^2\. ]] && master_role="cluster_manager"
            if [[ "${#roles_list[@]}" -le 0 ]]; then
                warn "Setting ${DB_FLAVOR^^}_NODE_ROLES is empty and ${DB_FLAVOR^^}_IS_DEDICATED_NODE is set to true, ${DB_FLAVOR^} will be configured as coordinating-only node."
            fi
            for role in "${roles_list[@]}"; do
                case "$role" in
                "$master_role" | data | data_content | data_hot | data_warm | data_cold | data_frozen | ingest | ml | remote_cluster_client | transform) ;;

                *)
                    print_validation_error "Invalid node role '$role'. Supported roles are '${master_role},data,data_content,data_hot,data_warm,data_cold,data_frozen,ingest,ml,remote_cluster_client,transform'"
                    ;;
                esac
            done
        fi
    }

    debug "Ensuring expected directories/files exist..."
    am_i_root && ensure_user_exists "$DB_DAEMON_USER" --group "$DB_DAEMON_GROUP"
    for dir in "$DB_TMP_DIR" "$DB_LOGS_DIR" "$DB_PLUGINS_DIR" "$DB_BASE_DIR/modules" "$DB_CONF_DIR"; do
        ensure_dir_exists "$dir"
        am_i_root && chown -R "$DB_DAEMON_USER:$DB_DAEMON_GROUP" "$dir"
    done

    debug "Validating settings in DB_* env vars..."
    for var in "DB_HTTP_PORT_NUMBER" "DB_TRANSPORT_PORT_NUMBER"; do
        if ! err=$(validate_port "${!var}"); then
            print_validation_error "An invalid port was specified in the environment variable $var: $err"
        fi
    done

    if ! is_boolean_yes "$DB_IS_DEDICATED_NODE"; then
        warn "Setting ${DB_FLAVOR^^}_IS_DEDICATED_NODE is disabled."
        warn "${DB_FLAVOR^^}_NODE_ROLES will be ignored and ${DB_FLAVOR^} will asume all different roles."
    else
        validate_node_roles
    fi

    if [[ -n "$DB_BIND_ADDRESS" ]] && ! validate_ipv4 "$DB_BIND_ADDRESS"; then
        print_validation_error "The Bind Address specified in the environment variable ${DB_FLAVOR^^}_BIND_ADDRESS is not a valid IPv4"
    fi

    if is_boolean_yes "$DB_ENABLE_SECURITY"; then
        if [[ "$DB_FLAVOR" = "opensearch" ]]; then
            if [[ ! -f "$OPENSEARCH_SECURITY_ADMIN_KEY_LOCATION" ]] || [[ ! -f "$OPENSEARCH_SECURITY_ADMIN_CERT_LOCATION" ]]; then
                print_validation_error "In order to enable Opensearch Security, you must provide a valid admin PEM key and certificate."
            fi
            if is_empty_value "$OPENSEARCH_SECURITY_NODES_DN"; then
                print_validation_error "The variable OPENSEARCH_SECURITY_NODES_DN is required."
            fi
            if is_empty_value "$OPENSEARCH_SECURITY_ADMIN_DN"; then
                print_validation_error "The variable OPENSEARCH_SECURITY_ADMIN_DN is required."
            fi
            if ! is_boolean_yes "$OPENSEARCH_ENABLE_REST_TLS"; then
                print_validation_error "Opensearch does not support plaintext conections (HTTP) when Security is enabled."
            fi
        fi
        if ! is_boolean_yes "$DB_SKIP_TRANSPORT_TLS"; then
            if is_boolean_yes "$DB_TRANSPORT_TLS_USE_PEM"; then
                if [[ ! -f "$DB_TRANSPORT_TLS_NODE_CERT_LOCATION" ]] || [[ ! -f "$DB_TRANSPORT_TLS_NODE_KEY_LOCATION" ]] || [[ ! -f "$DB_TRANSPORT_TLS_CA_CERT_LOCATION" ]]; then
                    print_validation_error "In order to configure the TLS encryption for ${DB_FLAVOR^} Transport you must provide your node key, certificate and a valid certification_authority certificate."
                fi
            elif [[ ! -f "$DB_TRANSPORT_TLS_KEYSTORE_LOCATION" ]] || [[ ! -f "$DB_TRANSPORT_TLS_TRUSTSTORE_LOCATION" ]]; then
                print_validation_error "In order to configure the TLS encryption for ${DB_FLAVOR^} Transport with JKS/PKCS12 certs you must mount a valid keystore and truststore."
            fi
        fi
        if is_boolean_yes "$DB_HTTP_TLS_USE_PEM"; then
            if is_boolean_yes "$DB_HTTP_TLS_USE_PEM"; then
                if [[ ! -f "$DB_HTTP_TLS_NODE_CERT_LOCATION" ]] || [[ ! -f "$DB_HTTP_TLS_NODE_KEY_LOCATION" ]] || [[ ! -f "$DB_HTTP_TLS_CA_CERT_LOCATION" ]]; then
                    print_validation_error "In order to configure the TLS encryption for ${DB_FLAVOR^} you must provide your node key, certificate and a valid certification_authority certificate."
                fi
            elif [[ ! -f "$DB_HTTP_TLS_KEYSTORE_LOCATION" ]] || [[ ! -f "$DB_HTTP_TLS_TRUSTSTORE_LOCATION" ]]; then
                print_validation_error "In order to configure the TLS encryption for ${DB_FLAVOR^} with JKS/PKCS12 certs you must mount a valid keystore and truststore."
            fi
        fi
    fi

    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}

########################
# Determine the hostname by which Elasticsearch can be contacted
# Returns:
#   The value of $DB_ADVERTISED_HOSTNAME or the current host address
########################
get_elasticsearch_hostname() {
    if [[ -n "$DB_ADVERTISED_HOSTNAME" ]]; then
        echo "$DB_ADVERTISED_HOSTNAME"
    else
        get_machine_ip
    fi
}

########################
# Evaluates the env variable DB_NODE_ROLES and replaces master with
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   Array of node roles
#########################
get_elasticsearch_roles() {
    read -r -a roles_list_tmp <<<"$(tr ',;' ' ' <<<"$DB_NODE_ROLES")"
    roles_list=("${roles_list_tmp[@]}")
    for i in "${!roles_list[@]}"; do
        if [[ ${roles_list[$i]} == "master" ]] && [[ "$DB_FLAVOR" = "opensearch" && "$APP_VERSION" =~ ^2\. ]]; then
            roles_list[i]="cluster_manager"
        fi
    done
    echo "${roles_list[@]}"
}

########################
# Configure cluster settings
# Globals:
#  DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
elasticsearch_cluster_configuration() {
    # Auxiliary functions
    bind_address() {
        if [[ -n "$DB_BIND_ADDRESS" ]]; then
            echo "$DB_BIND_ADDRESS"
        else
            echo "0.0.0.0"
        fi
    }

    is_node_master() {
        if is_boolean_yes "$DB_IS_DEDICATED_NODE"; then
            if [ -n "$DB_NODE_ROLES" ]; then
                read -r -a roles_list <<<"$(get_elasticsearch_roles)"
                if [[ " ${roles_list[*]} " = *" master "* ]]; then
                    true
                elif [[ "$DB_FLAVOR" = "opensearch" && " ${roles_list[*]} " = *" cluster_manager "* ]]; then
                    true
                else
                    false
                fi
            else
                false
            fi
        else
            true
        fi
    }

    info "Configuring ${DB_FLAVOR^} cluster settings..."
    elasticsearch_conf_set network.host "$(get_elasticsearch_hostname)"
    elasticsearch_conf_set network.publish_host "$(get_elasticsearch_hostname)"
    elasticsearch_conf_set network.bind_host "$(bind_address)"
    elasticsearch_conf_set cluster.name "$DB_CLUSTER_NAME"
    elasticsearch_conf_set node.name "${DB_NODE_NAME:-$(hostname)}"

    if [[ -n "$DB_CLUSTER_HOSTS" ]]; then
        read -r -a host_list <<<"$(tr ',;' ' ' <<<"$DB_CLUSTER_HOSTS")"
        master_list=("${host_list[@]}")
        if [[ -n "$DB_CLUSTER_MASTER_HOSTS" ]]; then
            read -r -a master_list <<<"$(tr ',;' ' ' <<<"$DB_CLUSTER_MASTER_HOSTS")"
        fi
        elasticsearch_conf_set discovery.seed_hosts "${host_list[@]}"
        if is_node_master; then
            if [[ "$DB_FLAVOR" = "opensearch" && "$APP_VERSION" =~ ^2\. ]]; then
                elasticsearch_conf_set cluster.initial_cluster_manager_nodes "${master_list[@]}"
            else
                elasticsearch_conf_set cluster.initial_master_nodes "${master_list[@]}"
            fi
        fi
        elasticsearch_conf_set discovery.initial_state_timeout "10m"
    else
        elasticsearch_conf_set "discovery.type" "single-node"
    fi
}

########################
# Extend cluster settings with custom, user-provided config
# Globals:
#  DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
elasticsearch_custom_configuration() {
    local custom_conf_file="${DB_CONF_DIR}/my_${DB_FLAVOR}.yml"
    local -r tempfile=$(mktemp)
    [[ ! -s "$custom_conf_file" ]] && return
    info "Adding custom configuration"
    yq eval-all 'select(fileIndex == 0) * select(fileIndex == 1)' "$DB_CONF_FILE" "$custom_conf_file" >"$tempfile"
    cp "$tempfile" "$DB_CONF_FILE"
}

########################
# Configure node roles.
# There are 3 scenarios:
# * If DB_IS_DEDICATED_NODE is disabled, 'node.roles' is omitted and assumes all the roles (check docs).
# * Otherwise, 'node.roles' with a list of roles provided with DB_NODE_ROLES.
# * In addition, if DB_NODE_ROLES is empty, node.roles will be configured empty, meaning that the role is 'coordinating-only'.
#
# Docs ref: https://www.elastic.co/guide/en/opensearch/reference/current/modules-node.html
#
# Globals:
#  DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
elasticsearch_configure_node_roles() {
    debug "Configure ${DB_FLAVOR^} Node roles..."

    local set_repo_path="no"
    if is_boolean_yes "$DB_IS_DEDICATED_NODE"; then
        read -r -a roles_list <<<"$(get_elasticsearch_roles)"
        if [[ "${#roles_list[@]}" -eq 0 ]]; then
            elasticsearch_conf_write node.roles "[]" int
        else
            elasticsearch_conf_set node.roles "${roles_list[@]}"
            for role in "${roles_list[@]}"; do
                case "$role" in
                    cluster_manager | master | data | data_content | data_hot | data_warm | data_cold | data_frozen)
                        set_repo_path="yes"
                        ;;
                    *) ;;
                esac
            done
        fi
    else
        set_repo_path="yes"
    fi

    if is_boolean_yes "$set_repo_path" && [[ -n "$DB_FS_SNAPSHOT_REPO_PATH" ]]; then
        # Configure path.repo to restore snapshots from system repository
        # It must be set on every cluster_manager and data node
        # ref: https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-filesystem-repository.html
        elasticsearch_conf_set path.repo "$DB_FS_SNAPSHOT_REPO_PATH"
    fi
}

########################
# Configure Heap Size
# Globals:
#  DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
elasticsearch_set_heap_size() {
    local heap_size

    # Remove heap.options if it already exists
    rm -f "${DB_CONF_DIR}/jvm.options.d/heap.options"

    if [[ -n "$DB_HEAP_SIZE" ]]; then
        debug "Using specified values for Xmx and Xms heap options..."
        heap_size="$DB_HEAP_SIZE"
    else
        debug "Calculating appropriate Xmx and Xms values..."
        local machine_mem=""
        machine_mem="$(get_total_memory)"
        if [[ "$machine_mem" -lt 65536 ]]; then
            local max_allowed_memory
            local calculated_heap_size
            calculated_heap_size="$((machine_mem / 2))"
            max_allowed_memory="$((DB_MAX_ALLOWED_MEMORY_PERCENTAGE * machine_mem))"
            max_allowed_memory="$((max_allowed_memory / 100))"
            # Allow for absolute memory limit when calculating limit from percentage
            if [[ -n "$DB_MAX_ALLOWED_MEMORY" && "$max_allowed_memory" -gt "$DB_MAX_ALLOWED_MEMORY" ]]; then
                max_allowed_memory="$DB_MAX_ALLOWED_MEMORY"
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
    cat >"${DB_CONF_DIR}/jvm.options.d/heap.options" <<EOF
-Xms${heap_size}
-Xmx${heap_size}
EOF
    am_i_root && chown "$DB_DAEMON_USER:$DB_DAEMON_GROUP" "${DB_CONF_DIR}/jvm.options.d/heap.options"

    # Avoid exit code of previous commands to affect the result of this function
    true
}

########################
# Configure/initialize Elasticsearch/Opensearch
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
elasticsearch_initialize() {
    info "Configuring/Initializing ${DB_FLAVOR^}..."

    # This fixes an issue where the trap would kill the entrypoint.sh, if a PID was left over from a previous run
    # Exec replaces the process without creating a new one, and when the container is restarted it may have the same PID
    rm -f "$DB_PID_FILE"

    read -r -a data_dirs_list <<<"$(tr ',;' ' ' <<<"$DB_DATA_DIR_LIST")"
    if [[ "${#data_dirs_list[@]}" -gt 0 ]]; then
        info "Multiple data directories specified, ignoring ${DB_FLAVOR^^}_DATA_DIR environment variable."
    else
        data_dirs_list+=("$DB_DATA_DIR")

        # Persisted data from old versions of
        if [[ "$DB_FLAVOR" = "elasticsearch" ]] && ! is_dir_empty "$DB_DATA_DIR"; then
            debug "Detected persisted data from previous deployments"
            [[ -d "$DB_DATA_DIR/elasticsearch" ]] && [[ -f "$DB_DATA_DIR/elasticsearch/.initialized" ]] && migrate_old_data
        fi
    fi

    debug "Ensuring expected directories/files exist..."
    for dir in "$DB_TMP_DIR" "$DB_LOGS_DIR" "$DB_PLUGINS_DIR" "$DB_BASE_DIR/modules" "$DB_CONF_DIR"; do
        ensure_dir_exists "$dir"
        am_i_root && chown -R "$DB_DAEMON_USER:$DB_DAEMON_GROUP" "$dir"
    done
    for dir in "${data_dirs_list[@]}"; do
        ensure_dir_exists "$dir"
        am_i_root && is_mounted_dir_empty "$dir" && chown -R "$DB_DAEMON_USER:$DB_DAEMON_GROUP" "$dir"
    done

    if is_file_writable "${DB_CONF_DIR}/jvm.options" && is_file_writable "${DB_CONF_DIR}/jvm.options.d"; then
        if is_boolean_yes "$DB_DISABLE_JVM_HEAP_DUMP"; then
            info "Disabling JVM heap dumps..."
            replace_in_file "${DB_CONF_DIR}/jvm.options" "-XX:[+]HeapDumpOnOutOfMemoryError" "# -XX:+HeapDumpOnOutOfMemoryError"
        fi
        if is_boolean_yes "$DB_DISABLE_GC_LOGS"; then
            info "Disabling JVM GC logs..."
            replace_in_file "${DB_CONF_DIR}/jvm.options" "(^.*logs[/]gc.log.*$)" "# \1"
        fi
        elasticsearch_set_heap_size
    else
        warn "The JVM options configuration files are not writable. Configurations based on environment variables will not be applied"
    fi

    if [[ -f "$DB_CONF_FILE" ]]; then
        info "Custom configuration file detected, using it..."
    else
        info "Setting default configuration"
        touch "$DB_CONF_FILE"
        elasticsearch_conf_set http.port "$DB_HTTP_PORT_NUMBER"
        elasticsearch_conf_set path.data "${data_dirs_list[@]}"
        elasticsearch_conf_set transport.port "$DB_TRANSPORT_PORT_NUMBER"
        is_boolean_yes "$DB_LOCK_ALL_MEMORY" && elasticsearch_conf_set bootstrap.memory_lock "true"
        elasticsearch_cluster_configuration
        elasticsearch_configure_node_roles
        elasticsearch_custom_configuration
        if [[ "$DB_FLAVOR" = "opensearch" ]]; then
            if is_boolean_yes "$DB_ENABLE_SECURITY"; then
                info "Configuring ${DB_FLAVOR^} security plugin"
                read -r -a nodes_dn <<<"$(tr ';' ' ' <<<"$OPENSEARCH_SECURITY_NODES_DN")"
                read -r -a admin_dn <<<"$(tr ';' ' ' <<<"$OPENSEARCH_SECURITY_ADMIN_DN")"
                elasticsearch_conf_set plugins.security.nodes_dn "${nodes_dn[@]}"
                elasticsearch_conf_set plugins.security.authcz.admin_dn "${admin_dn[@]}"

                is_boolean_yes "$DB_ENABLE_REST_TLS" && opensearch_http_tls_configuration
                ! is_boolean_yes "$DB_SKIP_TRANSPORT_TLS" && opensearch_transport_tls_configuration

                opensearch_security_configure_users
                if is_boolean_yes "$OPENSEARCH_SECURITY_BOOTSTRAP"; then
                    opensearch_security_bootstrap
                fi
            else
                elasticsearch_conf_set plugins.security.disabled "true"
            fi
        else
            [[ -n "$DB_ACTION_DESTRUCTIVE_REQUIRES_NAME" ]] && elasticsearch_conf_set action.destructive_requires_name "$(is_boolean_yes "$DB_ACTION_DESTRUCTIVE_REQUIRES_NAME" && echo "true" || echo "false")"
            # X-Pack settings.
            elasticsearch_conf_set xpack.security.enabled "$(is_boolean_yes "$DB_ENABLE_SECURITY" && echo "true" || echo "false")"
            ! is_empty_value "$DB_PASSWORD" && elasticsearch_set_key_value "bootstrap.password" "$DB_PASSWORD"
            if is_boolean_yes "$DB_ENABLE_SECURITY"; then
                is_boolean_yes "$DB_ENABLE_REST_TLS" && elasticsearch_http_tls_configuration
                ! is_boolean_yes "$DB_SKIP_TRANSPORT_TLS" && elasticsearch_transport_tls_configuration
                if is_boolean_yes "$ELASTICSEARCH_ENABLE_FIPS_MODE"; then
                    elasticsearch_conf_set xpack.security.fips_mode.enabled "true"
                    elasticsearch_conf_set xpack.security.authc.password_hashing.algorithm "pbkdf2"
                fi
            fi
            # Latest Elasticseach releases install x-pack-ml  by default. Since we have faced some issues with this library on certain platforms,
            # currently we are disabling this machine learning module whatsoever by defining "xpack.ml.enabled=false" in the "elasicsearch.yml" file
            if is_dir_empty "${DB_BASE_DIR}/modules/x-pack-ml/platform/linux-"*; then
                elasticsearch_conf_set xpack.ml.enabled "false"
            fi
        fi
    fi
}

########################
# Install Elasticsearch plugins
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
elasticsearch_install_plugins() {
    read -r -a plugins_list <<<"$(tr ',;' ' ' <<<"$DB_PLUGINS")"
    local mandatory_plugins=""
    local cmd="elasticsearch-plugin"
    [[ "$DB_FLAVOR" = "opensearch" ]] && cmd="opensearch-plugin"

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
    read -r -a mounted_plugins <<<"$(find "$DB_MOUNTED_PLUGINS_DIR" -type f -name "*.zip" -print0 | xargs -0)"
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
        if [[ -d "${DB_PLUGINS_DIR}/${plugin_name}" ]]; then
            debug "Plugin already installed: ${plugin}"
            continue
        fi

        debug "Installing plugin: ${plugin}"
        if [[ "${BITNAMI_DEBUG:-false}" = true ]]; then
            "$cmd" install -b -v "$plugin"
        else
            "$cmd" install -b -v "$plugin" >/dev/null 2>&1
        fi
    done

    # Mark plugins as mandatory
    elasticsearch_conf_set plugin.mandatory "$mandatory_plugins"
}

########################
# Run custom initialization scripts
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
elasticsearch_custom_init_scripts() {
    read -r -a init_scripts <<<"$(find "$DB_INITSCRIPTS_DIR" -type f -name "*.sh" -print0 | xargs -0)"
    if [[ "${#init_scripts[@]}" -gt 0 ]] && [[ ! -f "$DB_VOLUME_DIR"/.user_scripts_initialized ]]; then
        info "Loading user's custom files from $DB_INITSCRIPTS_DIR"
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
        touch "$DB_VOLUME_DIR"/.user_scripts_initialized
    fi
}

########################
# Modify log4j2.properties to send events to stdout instead of a logfile
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
elasticsearch_configure_logging() {
    # Back up the original file for users who'd like to use logfile logging
    cp "${DB_CONF_DIR}/log4j2.properties" "${DB_CONF_DIR}/log4j2.file.properties"

    # Replace RollingFile with Console
    replace_in_file "${DB_CONF_DIR}/log4j2.properties" "RollingFile" "Console"

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
        # Remove .filePermissions config
        "\.filePermissions"
    )
    for pattern in "${delete_patterns[@]}"; do
        remove_in_file "${DB_CONF_DIR}/log4j2.properties" "$pattern"
    done
}

########################
# Check Elasticsearch/Opensearch health
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   0 when healthy (or waiting for Opensearch security bootstrap)
#   1 when unhealthy
#########################
elasticsearch_healthcheck() {
    info "Checking ${DB_FLAVOR^} health..."
    local -r cmd="curl"
    local command_args=("--silent" "--write-out" "%{http_code}")
    local protocol="http"
    local host

    host=$(get_elasticsearch_hostname)
    if validate_ipv6 "$host"; then
        host="[${host}]"
    fi

    if is_boolean_yes "$DB_ENABLE_SECURITY"; then
        command_args+=("-k" "--user" "${DB_USERNAME}:${DB_PASSWORD}")
        is_boolean_yes "$DB_ENABLE_REST_TLS" && protocol="https"
    fi

    # Combination of --silent, --output and --write-out allows us to obtain both the status code and the request body
    output=$(mktemp)
    command_args+=("-o" "$output" "${protocol}://${host}:${DB_HTTP_PORT_NUMBER}/_cluster/health?local=true")
    HTTP_CODE=$("$cmd" "${command_args[@]}")
    if [[ ${HTTP_CODE} -ge 200 && ${HTTP_CODE} -le 299 ]] || ([[ "$DB_FLAVOR" = "opensearch" ]] && [[ ${HTTP_CODE} -eq 503 ]] && grep -q "OpenSearch Security not initialized" "$output" ); then
        rm "$output"
        return 0
    else
        rm "$output"
        return 1
    fi
}
