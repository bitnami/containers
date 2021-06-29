#!/bin/bash
#
# Bitnami PostgreSQL Client library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libvalidations.sh

########################
# Validate settings in POSTGRESQL_CLIENT_* environment variables
# Globals:
#   POSTGRESQL_CLIENT_*
# Arguments:
#   None
# Returns:
#   None
#########################
postgresql_client_validate() {
    info "Validating settings in POSTGRESQL_CLIENT_* env vars"
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
    if [[ -n "$POSTGRESQL_CLIENT_CREATE_DATABASE_USERNAME" || -n "$POSTGRESQL_CLIENT_CREATE_DATABASE_NAME" ]]; then
        if is_boolean_yes "$ALLOW_EMPTY_PASSWORD"; then
            empty_password_enabled_warn
        else
            if [[ -z "$POSTGRESQL_CLIENT_POSTGRES_PASSWORD" ]]; then
                empty_password_error "POSTGRESQL_CLIENT_POSTGRES_PASSWORD"
            fi
            if [[ -n "$POSTGRESQL_CLIENT_CREATE_DATABASE_USERNAME" ]] && [[ -z "$POSTGRESQL_CLIENT_CREATE_DATABASE_PASSWORD" ]]; then
                empty_password_error "POSTGRESQL_CLIENT_CREATE_DATABASE_PASSWORD"
            fi
        fi
    fi
    # When enabling extensions, the DB name must be provided
    local -a extensions
    read -r -a extensions <<< "$(tr ',;' ' ' <<< "$POSTGRESQL_CLIENT_CREATE_DATABASE_EXTENSIONS")"
    if [[ -z "$POSTGRESQL_CLIENT_CREATE_DATABASE_NAME" && "${#extensions[@]}" -gt 0 ]]; then
        print_validation_error "POSTGRESQL_CLIENT_CREATE_DATABASE_EXTENSIONS requires POSTGRESQL_CLIENT_CREATE_DATABASE_NAME to be set."
    fi
    return "$error_code"
}

########################
# Perform actions to a database
# Globals:
#   POSTGRESQL_CLIENT_*
# Arguments:
#   None
# Returns:
#   None
#########################
postgresql_client_initialize() {
    # Wait for the database to be accessible if any action needs to be performed
    if [[ -n "$POSTGRESQL_CLIENT_CREATE_DATABASE_USERNAME" || -n "$POSTGRESQL_CLIENT_CREATE_DATABASE_NAME" ]]; then
        info "Trying to connect to the database server"
        check_postgresql_connection() {
            echo "SELECT 1" | postgresql_remote_execute "$POSTGRESQL_CLIENT_DATABASE_HOST" "$POSTGRESQL_CLIENT_DATABASE_PORT_NUMBER" "" "$POSTGRESQL_CLIENT_POSTGRES_USER" "$POSTGRESQL_CLIENT_POSTGRES_PASSWORD"
        }
        if ! retry_while "check_postgresql_connection"; then
            error "Could not connect to the database server"
            return 1
        fi
    fi
    # Ensure a database user exists in the server
    if [[ -n "$POSTGRESQL_CLIENT_CREATE_DATABASE_USERNAME" ]]; then
        info "Creating database user ${POSTGRESQL_CLIENT_CREATE_DATABASE_USERNAME}"
        local -a args=("$POSTGRESQL_CLIENT_CREATE_DATABASE_USERNAME" "--host" "$POSTGRESQL_CLIENT_DATABASE_HOST" "--port" "$POSTGRESQL_CLIENT_DATABASE_PORT_NUMBER")
        [[ -n "$POSTGRESQL_CLIENT_CREATE_DATABASE_PASSWORD" ]] && args+=("-p" "$POSTGRESQL_CLIENT_CREATE_DATABASE_PASSWORD")
        postgresql_ensure_user_exists "${args[@]}"
    fi
    # Ensure a database exists in the server (and that the user has write privileges, if specified)
    if [[ -n "$POSTGRESQL_CLIENT_CREATE_DATABASE_NAME" ]]; then
        info "Creating database ${POSTGRESQL_CLIENT_CREATE_DATABASE_NAME}"
        local -a createdb_args=("$POSTGRESQL_CLIENT_CREATE_DATABASE_NAME" "--host" "$POSTGRESQL_CLIENT_DATABASE_HOST" "--port" "$POSTGRESQL_CLIENT_DATABASE_PORT_NUMBER")
        [[ -n "$POSTGRESQL_CLIENT_CREATE_DATABASE_USERNAME" ]] && createdb_args+=("-u" "$POSTGRESQL_CLIENT_CREATE_DATABASE_USERNAME")
        postgresql_ensure_database_exists "${createdb_args[@]}"
        # Ensure the list of extensions are enabled in the specified database
        local -a extensions
        read -r -a extensions <<< "$(tr ',;' ' ' <<< "$POSTGRESQL_CLIENT_CREATE_DATABASE_EXTENSIONS")"
        if [[ "${#extensions[@]}" -gt 0 ]]; then
            for extension_to_create in "${extensions[@]}"; do
                echo "CREATE EXTENSION IF NOT EXISTS ${extension_to_create}" | postgresql_remote_execute "$POSTGRESQL_CLIENT_DATABASE_HOST" "$POSTGRESQL_CLIENT_DATABASE_PORT_NUMBER" "$POSTGRESQL_CLIENT_CREATE_DATABASE_NAME" "$POSTGRESQL_CLIENT_POSTGRES_USER" "$POSTGRESQL_CLIENT_POSTGRES_PASSWORD"
            done
        fi
    fi
}

########################
# Return PostgreSQL major version
# Globals:
#   POSTGRESQL_*
# Arguments:
#   None
# Returns:
#   String
#########################
postgresql_get_major_version() {
    psql --version | grep -oE "[0-9]+\.[0-9]+" | grep -oE "^[0-9]+"
}

########################
# Gets an environment variable name based on the suffix
# Arguments:
#   $1 - environment variable suffix
# Returns:
#   environment variable name
#########################
get_env_var_value() {
    local env_var_suffix="${1:?missing suffix}"
    local env_var_name
    for env_var_prefix in POSTGRESQL POSTGRESQL_CLIENT; do
        env_var_name="${env_var_prefix}_${env_var_suffix}"
        if [[ -n "${!env_var_name:-}" ]]; then
            echo "${!env_var_name}"
            break
        fi
    done
}

########################
# Execute an arbitrary query/queries against the running PostgreSQL service and print the output
# Stdin:
#   Query/queries to execute
# Globals:
#   BITNAMI_DEBUG
#   POSTGRESQL_*
# Arguments:
#   $1 - Database where to run the queries
#   $2 - User to run queries
#   $3 - Password
#   $4 - Extra options (eg. -tA)
# Returns:
#   None
#########################
postgresql_execute_print_output() {
    local -r db="${1:-}"
    local -r user="${2:-postgres}"
    local -r pass="${3:-}"
    local opts
    read -r -a opts <<<"${@:4}"

    local args=("-U" "$user")
    [[ -n "$db" ]] && args+=("-d" "$db")
    [[ "${#opts[@]}" -gt 0 ]] && args+=("${opts[@]}")

    # Obtain the command specified via stdin
    local sql_cmd
    sql_cmd="$(</dev/stdin)"
    debug "Executing SQL command:\n$sql_cmd"
    PGPASSWORD=$pass psql "${args[@]}" <<<"$sql_cmd"
}

########################
# Execute an arbitrary query/queries against the running PostgreSQL service
# Stdin:
#   Query/queries to execute
# Globals:
#   BITNAMI_DEBUG
#   POSTGRESQL_*
# Arguments:
#   $1 - Database where to run the queries
#   $2 - User to run queries
#   $3 - Password
#   $4 - Extra options (eg. -tA)
# Returns:
#   None
#########################
postgresql_execute() {
    if [[ "${BITNAMI_DEBUG:-false}" = true ]]; then
        "postgresql_execute_print_output" "$@"
    elif [[ "${NO_ERRORS:-false}" = true ]]; then
        "postgresql_execute_print_output" "$@" 2>/dev/null
    else
        "postgresql_execute_print_output" "$@" >/dev/null 2>&1
    fi
}

########################
# Execute an arbitrary query/queries against a remote PostgreSQL service and print to stdout
# Stdin:
#   Query/queries to execute
# Globals:
#   BITNAMI_DEBUG
#   DB_*
# Arguments:
#   $1 - Remote PostgreSQL service hostname
#   $2 - Remote PostgreSQL service port
#   $3 - Database where to run the queries
#   $4 - User to run queries
#   $5 - Password
#   $6 - Extra options (eg. -tA)
# Returns:
#   None
postgresql_remote_execute_print_output() {
    local -r hostname="${1:?hostname is required}"
    local -r port="${2:?port is required}"
    local -a args=("-h" "$hostname" "-p" "$port")
    shift 2
    "postgresql_execute_print_output" "$@" "${args[@]}"
}

########################
# Execute an arbitrary query/queries against a remote PostgreSQL service
# Stdin:
#   Query/queries to execute
# Globals:
#   BITNAMI_DEBUG
#   DB_*
# Arguments:
#   $1 - Remote PostgreSQL service hostname
#   $2 - Remote PostgreSQL service port
#   $3 - Database where to run the queries
#   $4 - User to run queries
#   $5 - Password
#   $6 - Extra options (eg. -tA)
# Returns:
#   None
postgresql_remote_execute() {
    if [[ "${BITNAMI_DEBUG:-false}" = true ]]; then
        "postgresql_remote_execute_print_output" "$@"
    elif [[ "${NO_ERRORS:-false}" = true ]]; then
        "postgresql_remote_execute_print_output" "$@" 2>/dev/null
    else
        "postgresql_remote_execute_print_output" "$@" >/dev/null 2>&1
    fi
}

########################
# Optionally create the given database user
# Flags:
#   -p|--password - database password
#   --host - database host
#   --port - database port
# Arguments:
#   $1 - user
# Returns:
#   None
#########################
postgresql_ensure_user_exists() {
    local -r user="${1:?user is missing}"
    local password=""
    # For accessing an external database
    local db_host=""
    local db_port=""

    # Validate arguments
    shift 1
    while [ "$#" -gt 0 ]; do
        case "$1" in
        -p | --password)
            shift
            password="${1:?missing password}"
            ;;
        --host)
            shift
            db_host="${1:?missing database host}"
            ;;
        --port)
            shift
            db_port="${1:?missing database port}"
            ;;
        *)
            echo "Invalid command line flag $1" >&2
            return 1
            ;;
        esac
        shift
    done

    local -a postgresql_execute_cmd=("postgresql_execute")
    [[ -n "$db_host" && -n "$db_port" ]] && postgresql_execute_cmd=("postgresql_remote_execute" "$db_host" "$db_port")
    local -a postgresql_execute_flags=("" "$(get_env_var_value POSTGRES_USER)" "$(get_env_var_value POSTGRES_PASSWORD)")

    "${postgresql_execute_cmd[@]}" "${postgresql_execute_flags[@]}" <<EOF
DO
\$do\$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_catalog.pg_roles WHERE rolname = '${user}'
   ) THEN
      CREATE ROLE "${user}" LOGIN PASSWORD '${password}';
   END IF;
END
\$do\$;
EOF
}

########################
# Ensure a user has all privileges to access a database
# Arguments:
#   $1 - database name
#   $2 - database user
#   $3 - database host (optional)
#   $4 - database port (optional)
# Returns:
#   None
#########################
postgresql_ensure_user_has_database_privileges() {
    local -r user="${1:?user is required}"
    local -r database="${2:?db is required}"
    local -r db_host="${3:-}"
    local -r db_port="${4:-}"

    local -a postgresql_execute_cmd=("postgresql_execute")
    [[ -n "$db_host" && -n "$db_port" ]] && postgresql_execute_cmd=("postgresql_remote_execute" "$db_host" "$db_port")
    local -a postgresql_execute_flags=("" "$(get_env_var_value POSTGRES_USER)" "$(get_env_var_value POSTGRES_PASSWORD)")

    debug "Providing privileges to username ${user} on database ${database}"
    "${postgresql_execute_cmd[@]}" "${postgresql_execute_flags[@]}" <<EOF
GRANT ALL PRIVILEGES ON DATABASE "${database}" TO "${user}";
ALTER DATABASE "${database}" OWNER TO "${user}";
EOF
}

########################
# Optionally create the given database, and then optionally give a user
# full privileges on the database.
# Flags:
#   -u|--user - database user
#   --host - database host
#   --port - database port
# Arguments:
#   $1 - database name
# Returns:
#   None
#########################
postgresql_ensure_database_exists() {
    local -r database="${1:?database is missing}"
    local user=""
    # For accessing an external database
    local db_host=""
    local db_port=""

    # Validate arguments
    shift 1
    while [ "$#" -gt 0 ]; do
        case "$1" in
        -u | --user)
            shift
            user="${1:?missing database user}"
            ;;
        --host)
            shift
            db_host="${1:?missing database host}"
            ;;
        --port)
            shift
            db_port="${1:?missing database port}"
            ;;
        *)
            echo "Invalid command line flag $1" >&2
            return 1
            ;;
        esac
        shift
    done

    local -a postgresql_execute_cmd=("postgresql_execute")
    [[ -n "$db_host" && -n "$db_port" ]] && postgresql_execute_cmd=("postgresql_remote_execute" "$db_host" "$db_port")
    local -a postgresql_execute_flags=("" "$(get_env_var_value POSTGRES_USER)" "$(get_env_var_value POSTGRES_PASSWORD)")

    "${postgresql_execute_cmd[@]}" "${postgresql_execute_flags[@]}" <<EOF
SELECT 'CREATE DATABASE "${database}"'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '${database}')\gexec
EOF
    if [[ -n "$user" ]]; then
        local -a grant_flags=("$user" "$database")
        [[ -n "$db_host" ]] && grant_flags+=("$db_host")
        [[ -n "$db_port" ]] && grant_flags+=("$db_port")
        postgresql_ensure_user_has_database_privileges "${grant_flags[@]}"
    fi
}
