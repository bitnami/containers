#!/bin/bash
#
# Bitnami MongoDB Client library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libvalidations.sh

########################
# Validate settings in MONGODB_CLIENT_* environment variables
# Globals:
#   MONGODB_CLIENT_*
# Arguments:
#   None
# Returns:
#   None
#########################
mongodb_client_validate() {
    info "Validating settings in MONGODB_CLIENT_* env vars"
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }

    empty_password_enabled_warn() {
        warn "You set the environment variable ALLOW_EMPTY_PASSWORD=${ALLOW_EMPTY_PASSWORD}. For safety reasons, do not use this flag in a production environment."
    }
    empty_password_error() {
        print_validation_error "The $1 environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow the container to be started with blank passwords. This is recommended only for development."
    }

    # Only validate environment variables if any action needs to be performed
    # We need that the both the database and the password must be set
    if [[ -n "$MONGODB_CLIENT_CREATE_DATABASE_USERNAME" || -n "$MONGODB_CLIENT_CREATE_DATABASE_NAME" ]]; then
        if is_boolean_yes "$ALLOW_EMPTY_PASSWORD"; then
            empty_password_enabled_warn
        else
            if [[ -z "$MONGODB_CLIENT_CREATE_DATABASE_NAME" ]]; then
                print_validation_error "Database name not configured. Set the MONGODB_CLIENT_CREATE_DATABASE_PASSWORD variable"
            fi
            if [[ -z "$MONGODB_CLIENT_CREATE_DATABASE_PASSWORD" ]]; then
                empty_password_error "MONGODB_CLIENT_CREATE_DATABASE_PASSWORD"
            fi
        fi
    fi
    return "$error_code"
}

########################
# Perform actions to a database
# Globals:
#   MONGODB_CLIENT_*
# Arguments:
#   None
# Returns:
#   None
#########################
mongodb_client_initialize() {
    # Wait for the database to be accessible if any action needs to be performed
    if [[ -n "$MONGODB_CLIENT_CREATE_DATABASE_USERNAME" && -n "$MONGODB_CLIENT_CREATE_DATABASE_NAME" ]]; then
        info "Trying to connect to the database server"
        check_mongodb_connection() {
            local -r res=$(
                mongodb_execute "$MONGODB_CLIENT_ROOT_USER" "$MONGODB_CLIENT_CREATE_ROOT_PASSWORD" "admin" "$MONGODB_CLIENT_DATABASE_HOST" "$MONGODB_CLIENT_DATABASE_PORT_NUMBER" <<EOF
            db.stats();
EOF
            )
            debug_execute echo "$res"
            echo "$res" | grep -q '"ok" : 1'
        }
        if ! retry_while "check_mongodb_connection"; then
            error "Could not connect to the database server"
            return 1
        fi
        info "Creating database ${MONGODB_CLIENT_CREATE_DATABASE_NAME} and user ${MONGODB_CLIENT_CREATE_DATABASE_USERNAME}"
        debug_execute mongodb_execute "$MONGODB_CLIENT_ROOT_USER" "$MONGODB_CLIENT_CREATE_ROOT_PASSWORD" "admin" "$MONGODB_CLIENT_DATABASE_HOST" "$MONGODB_CLIENT_DATABASE_PORT_NUMBER" <<EOF
            db.getSiblingDB('$MONGODB_CLIENT_CREATE_DATABASE_NAME').createUser({ user: '$MONGODB_CLIENT_CREATE_DATABASE_USERNAME', pwd: '$MONGODB_CLIENT_CREATE_DATABASE_PASSWORD', roles: [{role: 'readWrite', db: '$MONGODB_CLIENT_CREATE_DATABASE_NAME'}] })
EOF
    fi
}

########################
# Execute an arbitrary query/queries against the running MongoDB service
# Stdin:
#   Query/queries to execute
# Arguments:
#   $1 - User to run queries
#   $2 - Password
#   $3 - Database where to run the queries
#   $4 - Host (default to result of get_mongo_hostname function)
#   $5 - Port (default $MONGODB_PORT_NUMBER)
#   $6 - Extra arguments (default $MONGODB_CLIENT_EXTRA_FLAGS)
# Returns:
#   None
########################
mongodb_execute() {
    local -r user="${1:-}"
    local -r password="${2:-}"
    local -r database="${3:-}"
    local -r host="${4:-$(get_mongo_hostname)}"
    local -r port="${5:-$MONGODB_PORT_NUMBER}"
    local -r extra_args="${6:-$MONGODB_CLIENT_EXTRA_FLAGS}"
    local final_user="$user"
    # If password is empty it means no auth, do not specify user
    [[ -z "$password" ]] && final_user=""

    local -a args=("--host" "$host" "--port" "$port")
    [[ -n "$final_user" ]] && args+=("-u" "$final_user")
    [[ -n "$password" ]] && args+=("-p" "$password")
    if [[ -n "$extra_args" ]]; then
        local extra_args_array=()
        read -r -a extra_args_array <<<"$extra_args"
        [[ "${#extra_args_array[@]}" -gt 0 ]] && args+=("${extra_args_array[@]}")
    fi
    [[ -n "$database" ]] && args+=("$database")

    "$MONGODB_BIN_DIR/mongo" "${args[@]}"
}
