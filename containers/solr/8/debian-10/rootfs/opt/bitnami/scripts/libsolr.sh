#!/bin/bash
#
# Bitnami Solr library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libpersistence.sh
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libvalidations.sh

########################
# Create initial security.json
# Globals:
#   SOLR_*
# Arguments:
#   None
# Returns:
#   None
#########################
solr_generate_initial_security() {
    info "Generating initial security file"
    cat >"${SOLR_BASE_DIR}/server/solr/security.json" <<EOF
{
"authentication":{
   "blockUnknown": true,
   "class":"solr.BasicAuthPlugin",
   "credentials":{"${SOLR_ADMIN_USERNAME}":"IV0EHq1OnNrj6gvRCwvFwTrZ1+z1oBbnQdiVC3otuq0= Ndd7LKvVBAaZIF0QAVi1ekCfAJXr1GGfLtRUXhgrF8c="},
   "forwardCredentials": false
},
"authorization":{
   "class":"solr.RuleBasedAuthorizationPlugin",
   "permissions":[{"name":"security-edit",
      "role":"admin"}],
   "user-role":{"${SOLR_ADMIN_USERNAME}":"admin"}
}}
EOF
}

########################
# Validate settings in SOLR_* env. variables
# Globals:
#   SOLR_*
# Arguments:
#   None
# Returns:
#   None
#########################
solr_validate() {
    info "Validating settings in SOLR_* env vars..."
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }

    ! is_yes_no_value "$SOLR_ENABLE_AUTHENTICATION" && print_validation_error "SOLR_ENABLE_AUTHENTICATION possible values are yes or no"
    if is_boolean_yes "$SOLR_ENABLE_AUTHENTICATION"; then
        [[ -z "$SOLR_ADMIN_USERNAME" ]] && print_validation_error "You need to provide an username in SOLR_USERNAME"
        [[ -z "$SOLR_ADMIN_PASSWORD" ]] && print_validation_error "You need to provide a password for the user: ${SOLR_ADMIN_USERNAME}"
    fi

    ! is_yes_no_value "$SOLR_SSL_ENABLED" && print_validation_error "SOLR_SSL_ENABLED possible values are yes or no"
    if is_boolean_yes "$SOLR_SSL_ENABLED"; then
        [[ -z "$SOLR_SSL_KEY_STORE" ]] && print_validation_error "You need to provide a key store file in SOLR_SSL_KEY_STORE"
        [[ -z "$SOLR_SSL_TRUST_STORE" ]] && print_validation_error "You need to provide a trust store file in SOLR_SSL_TRUST_STORE"
        [[ -z "$SOLR_SSL_KEY_STORE_PASSWORD" ]] && print_validation_error "You need to provide a password in SOLR_SSL_KEY_STORE_PASSWORD"
        [[ -z "$SOLR_SSL_TRUST_STORE_PASSWORD" ]] && print_validation_error "You need to provide a password file in SOLR_SSL_TRUST_STORE_PASSWORD"
    fi

    ! is_yes_no_value "$SOLR_ENABLE_CLOUD_MODE" && print_validation_error "SOLR_ENABLE_CLOUD_MODE possible values are yes or no"
    is_boolean_yes "$SOLR_ENABLE_CLOUD_MODE" && [[ -z "$SOLR_ZK_HOSTS" ]] && print_validation_error "You need to provide the Zookeper node list in SOLR_ZK_HOSTS"

    ! is_boolean_yes "$SOLR_CLOUD_BOOTSTRAP" && is_boolean_yes "$SOLR_ENABLE_CLOUD_MODE" && [[ -n "$SOLR_CORE" ]] && info "This node is not a boostrap node and will not create the collection"

    ! is_true_false_value "$SOLR_SSL_CHECK_PEER_NAME" && print_validation_error "SOLR_SSL_CHECK_PEER_NAME possible values are true or false"

    [[ "$SOLR_NUMBER_OF_NODES" -lt $(("$SOLR_COLLECTION_REPLICAS" * "$SOLR_COLLECTION_SHARDS")) ]] && print_validation_error "Not enough nodes for the replicas and shards indicated"

    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}

########################
# Wait for solr root to exists in zookeeper
# Globals:
#   SOLR_*
# Arguments:
#   None
# Returns:
#   None
#########################
solr_wait_for_zk_root() {
    info "Waiting for solr root in zookeeper"
    if ! retry_while solr_zk_root_exists; then
        error "Failed to connect to the zookeeper"
        exit 1
    fi
}

########################
# Wait for Zookeeper to be up
# Globals:
#   SOLR_*
# Arguments:
#   None
# Returns:
#   None
#########################
solr_wait_for_zookeeper() {
    local host
    local port

    info "Waiting for Zookeeper to be up"
    read -r -a zoo_nodes <<<"$(tr ',' ' ' <<<"${SOLR_ZK_HOSTS}")"
    for zoo_node in "${zoo_nodes[@]}"; do
        if [[ "$zoo_node" =~ (.*):([0-9]*) ]]; then
            host="${BASH_REMATCH[1]}"
            port="${BASH_REMATCH[2]}"
            debug "Trying: $host:$port"
            if ! retry_while "debug_execute nc -z ${host} ${port}" "$SOLR_ZK_MAX_RETRIES" "$SOLR_ZK_SLEEP_TIME"; then
                error "Failed to connect to the zookeeper node at ${host}:${port}"
                return 1
            fi
        fi
    done
}

#########################
# Create SOLR core
# Globals:
#   SOLR_*
# Arguments:
#   $1 - Core name
# Returns:
#   None
#########################
solr_create_core() {
    local -r core="${1:?Missing core}"
    local -r exec="curl"
    local command_args=("--silent")
    local protocol="http"

    is_boolean_yes "$SOLR_SSL_ENABLED" && protocol="https" && command_args+=("-k")

    is_boolean_yes "$SOLR_ENABLE_AUTHENTICATION" && command_args+=("--user" "${SOLR_ADMIN_USERNAME}:${SOLR_ADMIN_PASSWORD}")

    mkdir -p "${SOLR_SERVER_DIR}/solr/${core}/data"
    cp -r "${SOLR_CORE_CONF_DIR}"/* "${SOLR_SERVER_DIR}/solr/${core}/"

    command_args+=("${protocol}://localhost:${SOLR_PORT_NUMBER}/solr/admin/cores?action=CREATE&name=${SOLR_CORE}&instanceDir=${SOLR_CORE}&config=solrconfig.xml&schema=schema.xml&dataDir=data")

    info "Creating solr core: ${SOLR_CORE}"

    if ! debug_execute "$exec" "${command_args[@]}" >/dev/null; then
        error "There was an error when creating the core"
        exit 1
    else
        info "Core created"
    fi
}

#########################
# Update user password
# Globals:
#   SOLR_*
# Arguments:
#   $1 - username
#   $2 - password
# Returns:
#   None
#########################
solr_update_password() {
    local -r exec="curl"
    local -r default_password="SolrRocks"
    local -r username="${1:?user is required}"
    local -r password="${2:?password is required}"
    local protocol="http"
    local command_args=()

    is_boolean_yes "$SOLR_SSL_ENABLED" && protocol="https" && command_args+=("-k")

    command_args+=("--silent" "--user" "${username}:${default_password}" "${protocol}://localhost:${SOLR_PORT_NUMBER}/api/cluster/security/authentication" "-H" "'Content-type:application/json'" "-d" "{\"set-user\":{\"${username}\":\"${password}\"}}")

    info "Updating user password"

    if ! debug_execute "$exec" "${command_args[@]}" >/dev/null; then
        error "There was an error when updating the user password"
        exit 1
    else
        info "Password updated"
    fi
}

#########################
# Create SOLR cloud user
# Globals:
#   SOLR_*
# Arguments:
#   $1 - username
#   $2 - password
# Returns:
#   None
#########################
solr_create_cloud_user() {
    local -r exec="${SOLR_BIN_DIR}/solr"
    local -r username="${1:?user is required}"
    local -r password="${2:?password is required}"
    local command_args=("auth" "enable" "-type" "basicAuth" "-credentials" "${username}:${password}" "-blockUnknown" "true" "-z" "$SOLR_ZK_HOSTS")

    info "Creating user: ${username}"

    if ! debug_execute "$exec" "${command_args[@]}" >/dev/null; then
        error "There was an error when creating the user"
        exit 1
    else
        info "User created"
    fi
}

#########################
# Create SOLR collection
# Globals:
#   SOLR_*
# Arguments:
#   None
# Returns:
#   None
#########################
solr_create_collection() {
    local -r exec="curl"
    local command_args=("--silent")
    local protocol="http"

    info "Creating collection:${SOLR_COLLECTION} with ${SOLR_COLLECTION_REPLICAS} replicas and ${SOLR_COLLECTION_SHARDS} shards"

    is_boolean_yes "$SOLR_ENABLE_AUTHENTICATION" && command_args+=("--user" "${SOLR_ADMIN_USERNAME}:${SOLR_ADMIN_PASSWORD}")
    is_boolean_yes "$SOLR_SSL_ENABLED" && protocol="https" && command_args+=("-k")

    command_args+=("${protocol}://localhost:${SOLR_PORT_NUMBER}/solr/admin/collections?action=CREATE&name=${SOLR_COLLECTION}&numShards=${SOLR_COLLECTION_SHARDS}&replicationFactor=${SOLR_COLLECTION_REPLICAS}")

    #Check if the collection exists before creating it
    if ! solr_collection_exists "$SOLR_COLLECTION"; then
        # Will wait for other nodes to join before creating a collection with shards and/or replicas
        if [[ "$SOLR_COLLECTION_REPLICAS" -gt 1 ]] || [[ "$SOLR_COLLECTION_SHARDS" -gt 1 ]]; then
            info "Waiting for other nodes to be available"
            if ! retry_while "solr_check_number_of_nodes ${SOLR_NUMBER_OF_NODES}" "$SOLR_ZK_MAX_RETRIES" "$SOLR_ZK_SLEEP_TIME"; then
                error "There are not enough nodes to create the collection"
            fi
        fi

        if ! debug_execute "$exec" "${command_args[@]}" >/dev/null; then
            error "There was an error when creating the collection"
            exit 1
        else
            info "Collection created"
        fi
    else
        info "Skipping. Collection already exists."
    fi
}

#########################
# Check if the root of solr exists in zookeeper
# Globals:
#   SOLR_*
# Arguments:
#   $1 - Collection name
# Returns:
#   None
#########################
solr_zk_root_exists() {
    local -r exec="${SOLR_BIN_DIR}/solr"
    local command_args=("zk" "ls" "/" "-z" "$SOLR_ZK_HOSTS")

    debug "Checking if root of solr exists in zookeeper"

    "$exec" "${command_args[@]}" 2>/dev/null | grep -q "solr"
}

#########################
# Check if a collection already exists
# Globals:
#   SOLR_*
# Arguments:
#   $1 - Collection name
# Returns:
#   None
#########################
solr_collection_exists() {
    local -r collection="${1:?collection is required}"
    local -r exec="${SOLR_BIN_DIR}/solr"
    local command_args=("zk" "ls" "/solr/collections" "-z" "$SOLR_ZK_HOSTS")
    debug "Checking if ${collection} exists"

    "$exec" "${command_args[@]}" | grep -q "$collection"
}

########################
# Check the number of nodes in the cluster
# Arguments:
#   $1 - expected number of nodes
# Returns:
#   Boolean
########################
solr_check_number_of_nodes() {
    local -r nodes="${1:-1}"
    local -r exec="${SOLR_BIN_DIR}/solr"
    local command_args=("zk" "ls" "/solr/live_nodes" "-z" "$SOLR_ZK_HOSTS")

    [[ $("$exec" "${command_args[@]}" | wc -l) -ge "$nodes" ]]
}

########################
# Check if zookeeper has been initialized
# Arguments:
#   None
# Returns:
#   Boolean
########################
solr_is_zk_initialized() {
    local -r exec="${SOLR_BIN_DIR}/solr"
    local command_args=("zk" "ls" "/solr" "-z" "$SOLR_ZK_HOSTS")

    info "Checking if solr has been initialized in zookeeper"

    if ! debug_execute "$exec" "${command_args[@]}" 2>/dev/null; then
        info "Zookeeper was not initialized."
        return 1
    else
        info "Zookeeper was initialized."
        return 0
    fi
}

#########################
# Start solr in background
# Globals:
#   SOLR_*
# Arguments:
#   $1 - Mode: cloud or empty
# Returns:
#   None
#########################
solr_start_bg() {
    local -r mode="${1:-}"
    local -r exec="${SOLR_BIN_DIR}/solr"
    local start_args=("start" "-p" "${SOLR_PORT_NUMBER}" "-d" "server")

    info "Starting solr in background"
    if [[ "$mode" == "cloud" ]]; then
        start_args+=("-cloud" "-z" "$SOLR_ZK_HOSTS/solr")
    fi
    debug_execute "$exec" "${start_args[@]}"
}

#########################
# Stop SOLR
# Globals:
#   SOLR_*
# Arguments:
#   None
# Returns:
#   None
#########################
solr_stop() {
    info "Stopping solr"
    stop_service_using_pid "$SOLR_PID_FILE"
}

#########################
# Create root in zookeeper
# Globals:
#   SOLR_*
# Arguments:
#   None
# Returns:
#   None
#########################
solr_zk_initialize() {
    local -r exec="${SOLR_BIN_DIR}/solr"
    local command_args=("zk" "mkroot" "/solr" "-z" "$SOLR_ZK_HOSTS")

    if solr_is_zk_initialized; then
        info "Zookeeper is already initialized"
    else
        info "Creating root in zookeeper"
        debug_execute "$exec" "${command_args[@]}"
    fi
}

#########################
# Set cluster properties in zookeeper
# Globals:
#   SOLR_*
# Arguments:
#   None
# Returns:
#   None
#########################
solr_set_ssl_url_scheme() {
    info "Initializing configuring Solr HTTPS in Zookeeper"

    solr_wait_for_zk_root && "${SOLR_SERVER_DIR}/scripts/cloud-scripts/zkcli.sh" -zkhost "${SOLR_ZK_HOSTS}/solr" -cmd clusterprop -name urlScheme -val https
}

#########################
# Create root in zookeeper
# Globals:
#   SOLR_*
# Arguments:
#   None
# Returns:
#   None
#########################
solr_migrate_old_data() {
    local -r exec="mv"
    local command_args=("${SOLR_VOLUME_DIR}/data" "${SOLR_VOLUME_DIR}/server/solr")

    if am_i_root; then
        warn "Persisted data detected in old location. Migrating and changing permissions"
        ensure_dir_exists "${SOLR_VOLUME_DIR}/server"
        debug_execute "$exec" "${command_args[@]}"
        configure_permissions_ownership "${SOLR_VOLUME_DIR}/server/solr" -d 775 -f 664 -g "root"
        warn "Data migrated."
    else
        error "Persisted data detected in old location. You will need to run first the container as root to migrate the data"
        exit 1
    fi
}

#########################
# Initialize SOLR
# Globals:
#   SOLR_*
# Arguments:
#   None
# Returns:
#   None
#########################
solr_initialize() {
    info "Initializing Solr ..."

    # Check if there is persisted data from old version and migrate it
    ! is_dir_empty "${SOLR_VOLUME_DIR}/data" && [[ -f "$SOLR_VOLUME_DIR/.initialized" ]] && solr_migrate_old_data

    is_boolean_yes "$SOLR_SSL_ENABLED" && export SOLR_SSL_ENABLED=true

    # Check if Solr has already been initialized and persisted in a previous run
    local -r app_name="solr"
    if ! is_app_initialized "$app_name"; then
        # Ensure the solr base directory exists and has proper permissions
        info "Configuring file permissions for Solr"
        ensure_dir_exists "$SOLR_VOLUME_DIR"

        rm -f "${SOLR_TMP_DIR}/solr*.pid"

        if is_boolean_yes "$SOLR_ENABLE_CLOUD_MODE"; then
            info "Deploying Solr Cloud from scratch"

            if ! solr_wait_for_zookeeper; then
                error "Zookeeper not detected"
                exit 1
            fi

            if is_boolean_yes "$SOLR_CLOUD_BOOTSTRAP"; then
                solr_zk_initialize

                solr_start_bg "cloud"

                is_boolean_yes "$SOLR_SSL_ENABLED" && solr_set_ssl_url_scheme

                [[ -n "$SOLR_COLLECTION" ]] && solr_create_collection
                is_boolean_yes "$SOLR_ENABLE_AUTHENTICATION" && solr_create_cloud_user "$SOLR_ADMIN_USERNAME" "$SOLR_ADMIN_PASSWORD"

                solr_stop
            else
                if is_boolean_yes "$SOLR_SSL_ENABLED"; then
                    solr_set_ssl_url_scheme
                else
                    solr_wait_for_zk_root
                fi
            fi
        else
            info "Deploying Solr from scratch"

            is_boolean_yes "$SOLR_ENABLE_AUTHENTICATION" && solr_generate_initial_security

            solr_start_bg

            is_boolean_yes "$SOLR_ENABLE_AUTHENTICATION" && solr_update_password "$SOLR_ADMIN_USERNAME" "$SOLR_ADMIN_PASSWORD"

            [[ -n "$SOLR_CORE" ]] && solr_create_core "$SOLR_CORE"

            solr_stop
        fi

        info "Persisting Solr installation"
        persist_app "$app_name" "$SOLR_DATA_TO_PERSIST"
    else
        info "Restoring persisted Solr installation"

        # Compatibility with previous container images
        if [[ "$(ls "$SOLR_VOLUME_DIR")" = "data" ]]; then
            warn "The persisted data for this Solr installation is located at '${SOLR_VOLUME_DIR}/data' instead of '${SOLR_VOLUME_DIR}'"
            warn "This is deprecated and support for this may be removed in a future release"
            rm "${SOLR_BASE_DIR}/server/solr"
            ln -s "${SOLR_VOLUME_DIR}/data" "${SOLR_BASE_DIR}/server/solr"
        fi
        restore_persisted_app "$app_name" "$SOLR_DATA_TO_PERSIST"
    fi
}
