#!/bin/bash
#
# Bitnami MySQL Client library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libvalidations.sh

########################
# Validate settings in MYSQL_CLIENT_* environment variables
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mysql_client_validate() {
    info "Validating settings in MYSQL_CLIENT_* env vars"
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
    backslash_password_error() {
        print_validation_error "The password cannot contain backslashes ('\'). Set the environment variable $1 with no backslashes (more info at https://dev.mysql.com/doc/refman/8.0/en/string-comparison-functions.html)"
    }

    check_yes_no_value() {
        if ! is_yes_no_value "${!1}" && ! is_true_false_value "${!1}"; then
            print_validation_error "The allowed values for ${1} are: yes no"
        fi
    }

    # Only validate environment variables if any action needs to be performed
    check_yes_no_value "DB_TLS_ENABLED"

    if [[ -n "$DB_CREATE_DATABASE_USER" || -n "$DB_CREATE_DATABASE_NAME" ]]; then
        if is_boolean_yes "$ALLOW_EMPTY_PASSWORD"; then
            empty_password_enabled_warn
        else
            if [[ -z "$DB_ROOT_PASSWORD" ]]; then
                empty_password_error "$(get_env_var ROOT_PASSWORD)"
            fi
            if [[ -n "$DB_CREATE_DATABASE_USER" ]] && [[ -z "$DB_CREATE_DATABASE_PASSWORD" ]]; then
                empty_password_error "$(get_env_var CREATE_DATABASE_PASSWORD)"
            fi
        fi
        if [[ "${DB_ROOT_PASSWORD:-}" = *\\* ]]; then
            backslash_password_error "$(get_env_var ROOT_PASSWORD)"
        fi
        if [[ "${DB_CREATE_DATABASE_PASSWORD:-}" = *\\* ]]; then
            backslash_password_error "$(get_env_var CREATE_DATABASE_PASSWORD)"
        fi
    fi
    return "$error_code"
}

########################
# Perform actions to a database
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mysql_client_initialize() {
    # Wrap binary to force the usage of TLS
    if is_boolean_yes "$DB_TLS_ENABLED"; then
        mysql_client_wrap_binary_for_tls
    fi
    # Wait for the database to be accessible if any action needs to be performed
    if [[ -n "$DB_CREATE_DATABASE_USER" || -n "$DB_CREATE_DATABASE_NAME" ]]; then
        info "Trying to connect to the database server"
        check_mysql_connection() {
            echo "SELECT 1" | mysql_execute "mysql" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD" "-h" "$DB_DATABASE_HOST" "-P" "$DB_DATABASE_PORT_NUMBER"
        }
        if ! retry_while "check_mysql_connection"; then
            error "Could not connect to the database server"
            return 1
        fi
    fi
    # Ensure a database user exists in the server
    if [[ -n "$DB_CREATE_DATABASE_USER" ]]; then
        info "Creating database user ${DB_CREATE_DATABASE_USER}"
        local -a args=("$DB_CREATE_DATABASE_USER" "--host" "$DB_DATABASE_HOST" "--port" "$DB_DATABASE_PORT_NUMBER")
        [[ -n "$DB_CREATE_DATABASE_PASSWORD" ]] && args+=("-p" "$DB_CREATE_DATABASE_PASSWORD")
        [[ -n "$DB_DATABASE_AUTHENTICATION_PLUGIN" ]] && args+=("--auth-plugin" "$DB_DATABASE_AUTHENTICATION_PLUGIN")
        mysql_ensure_optional_user_exists "${args[@]}"
    fi
    # Ensure a database exists in the server (and that the user has write privileges, if specified)
    if [[ -n "$DB_CREATE_DATABASE_NAME" ]]; then
        info "Creating database ${DB_CREATE_DATABASE_NAME}"
        local -a createdb_args=("$DB_CREATE_DATABASE_NAME" "--host" "$DB_DATABASE_HOST" "--port" "$DB_DATABASE_PORT_NUMBER")
        [[ -n "$DB_CREATE_DATABASE_USER" ]] && createdb_args+=("-u" "$DB_CREATE_DATABASE_USER")
        [[ -n "$DB_CREATE_DATABASE_CHARACTER_SET" ]] && createdb_args+=("--character-set" "$DB_CREATE_DATABASE_CHARACTER_SET")
        [[ -n "$DB_CREATE_DATABASE_COLLATE" ]] && createdb_args+=("--collate" "$DB_CREATE_DATABASE_COLLATE")
        mysql_ensure_optional_database_exists "${createdb_args[@]}"
    fi
}

########################
# Wrap binary to force the usage of TLS
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mysql_client_wrap_binary_for_tls() {
    local -r wrapper_file="${DB_BIN_DIR}/mysql"
    local -r wrapped_binary_file="${DB_BASE_DIR}/.bin/mysql"

    mv "$wrapper_file" "$wrapped_binary_file"
    cat >"$wrapper_file" <<EOF
#!/bin/sh
exec "${wrapped_binary_file}" "\$@" --ssl=1
EOF
    chmod +x "$wrapper_file"
}

########################
# Extract mysql version from version string
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   Version string
#########################
mysql_get_version() {
    local ver_string
    local -a ver_split

    ver_string=$("${DB_BIN_DIR}/mysql" "--version")
    ver_split=(${ver_string// / })

    if [[ "$ver_string" == *" Distrib "* ]]; then
        echo "${ver_split[4]::-1}"
    else
        echo "${ver_split[2]}"
    fi
}

########################
# Gets an environment variable name based on the suffix
# Globals:
#   DB_FLAVOR
# Arguments:
#   $1 - environment variable suffix
# Returns:
#   environment variable name
#########################
get_env_var() {
    local -r id="${1:?id is required}"
    echo "${DB_FLAVOR^^}_${id}"
}

########################
# Gets an environment variable value for the master node and based on the suffix
# Arguments:
#   $1 - environment variable suffix
# Returns:
#   environment variable value
#########################
get_master_env_var_value() {
    local envVar

    PREFIX=""
    [[ "${DB_REPLICATION_MODE:-}" = "slave" ]] && PREFIX="MASTER_"
    envVar="$(get_env_var "${PREFIX}${1}_FILE")"
    if [[ -f "${!envVar:-}" ]]; then
        echo "$(< "${!envVar}")"
    else
        envVar="$(get_env_var "${PREFIX}${1}")"
        echo "${!envVar:-}"
    fi
}

########################
# Execute an arbitrary query/queries against the running MySQL/MariaDB service and print to stdout
# Stdin:
#   Query/queries to execute
# Globals:
#   BITNAMI_DEBUG
#   DB_*
# Arguments:
#   $1 - Database where to run the queries
#   $2 - User to run queries
#   $3 - Password
#   $4 - Extra MySQL CLI options
# Returns:
#   None
mysql_execute_print_output() {
    local -r db="${1:-}"
    local -r user="${2:-root}"
    local -r pass="${3:-}"
    local mysql_cmd opts
    read -r -a opts <<<"${@:4}"

    # Process mysql CLI arguments
    local -a args=()
    if [[ -f "$DB_CONF_FILE" ]]; then
        args+=("--defaults-file=${DB_CONF_FILE}")
    fi
    args+=("-N" "-u" "$user" "$db")
    [[ -n "$pass" ]] && args+=("-p$pass")
    [[ -n "${opts[*]:-}" ]] && args+=("${opts[@]:-}")

    # Obtain the command specified via stdin
    mysql_cmd="$(</dev/stdin)"
    debug "Executing SQL command:\n$mysql_cmd"
    "$DB_BIN_DIR/mysql" "${args[@]}" <<<"$mysql_cmd"
}

########################
# Execute an arbitrary query/queries against the running MySQL/MariaDB service
# Stdin:
#   Query/queries to execute
# Globals:
#   BITNAMI_DEBUG
#   DB_*
# Arguments:
#   $1 - Database where to run the queries
#   $2 - User to run queries
#   $3 - Password
#   $4 - Extra MySQL CLI options
# Returns:
#   None
mysql_execute() {
    debug_execute "mysql_execute_print_output" "$@"
}

########################
# Execute an arbitrary query/queries against a remote MySQL/MariaDB service
# Stdin:
#   Query/queries to execute
# Globals:
#   BITNAMI_DEBUG
#   DB_*
# Arguments:
#   $1 - Remote MySQL/MariaDB service hostname
#   $2 - Remote MySQL/MariaDB service port
#   $3 - Database where to run the queries
#   $4 - User to run queries
#   $5 - Password
#   $6 - Extra MySQL CLI options
# Returns:
#   None
mysql_remote_execute() {
    local -r hostname="${1:?hostname is required}"
    local -r port="${2:?port is required}"
    local -a args=("-h" "$hostname" "-P" "$port" "--connect-timeout=5")
    shift 2
    debug_execute "mysql_execute_print_output" "$@" "${args[@]}"
}

########################
# Checks if MySQL/MariaDB is running
# Globals:
#   DB_TMP_DIR
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_mysql_running() {
    local pid
    pid="$(get_pid_from_file "$DB_PID_FILE")"

    if [[ -z "$pid" ]]; then
        false
    else
        is_service_running "$pid"
    fi
}

########################
# Checks if MySQL/MariaDB is not running
# Globals:
#   DB_TMP_DIR
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_mysql_not_running() {
    ! is_mysql_running
}

########################
# Starts MySQL/MariaDB in the background and waits until it's ready
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mysql_start_bg() {
    local -a flags=("--defaults-file=${DB_CONF_FILE}" "--basedir=${DB_BASE_DIR}" "--datadir=${DB_DATA_DIR}" "--socket=${DB_SOCKET_FILE}")

    # Only allow local connections until MySQL is fully initialized, to avoid apps trying to connect to MySQL before it is fully initialized
    flags+=("--bind-address=127.0.0.1")

    # Add flags specified via the 'DB_EXTRA_FLAGS' environment variable
    read -r -a db_extra_flags <<< "$(mysql_extra_flags)"
    [[ "${#db_extra_flags[@]}" -gt 0 ]] && flags+=("${db_extra_flags[@]}")

    # Do not start as root, to avoid permission issues
    am_i_root && flags+=("--user=${DB_DAEMON_USER}")

    # The slave should only start in 'run.sh', elseways user credentials would be needed for any connection
    flags+=("--skip-slave-start")
    flags+=("$@")

    is_mysql_running && return

    info "Starting $DB_FLAVOR in background"
    debug_execute "${DB_SBIN_DIR}/mysqld" "${flags[@]}" &

    # we cannot use wait_for_mysql_access here as mysql_upgrade for MySQL >=8 depends on this command
    # users are not configured on slave nodes during initialization due to --skip-slave-start
    wait_for_mysql

    # Special configuration flag for system with slow disks that could take more time
    # in initializing
    if [[ -n "${DB_INIT_SLEEP_TIME}" ]]; then
        debug "Sleeping ${DB_INIT_SLEEP_TIME} seconds before continuing with initialization"
        sleep "${DB_INIT_SLEEP_TIME}"
    fi
}

########################
# Wait for MySQL/MariaDB to be running
# Globals:
#   DB_TMP_DIR
# Arguments:
#   None
# Returns:
#   Boolean
#########################
wait_for_mysql() {
    local pid
    local -r retries=300
    local -r sleep_time=2
    if ! retry_while is_mysql_running "$retries" "$sleep_time"; then
        error "MySQL failed to start"
        return 1
    fi
}

########################
# Wait for MySQL/MariaDB to be ready for accepting connections
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
wait_for_mysql_access() {
    # wait until the server is up and answering queries.
    local -a args=("mysql" "root")
    is_boolean_yes "${ROOT_AUTH_ENABLED:-false}" && args+=("$(get_master_env_var_value ROOT_PASSWORD)")
    local -r retries=300
    local -r sleep_time=2
    is_mysql_accessible() {
        echo "select 1" | mysql_execute "${args[@]}"
    }
    if ! retry_while is_mysql_accessible "$retries" "$sleep_time"; then
        error "Timed out waiting for MySQL to be accessible"
        return 1
    fi
}

########################
# Stop MySQL/Mariadb
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mysql_stop() {
    ! is_mysql_running && return

    info "Stopping $DB_FLAVOR"
    stop_service_using_pid "$DB_PID_FILE"
}

########################
# Initialize database data
# Globals:
#   BITNAMI_DEBUG
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mysql_install_db() {
    local command="${DB_BIN_DIR}/mysql_install_db"
    local -a args=("--defaults-file=${DB_CONF_FILE}" "--basedir=${DB_BASE_DIR}" "--datadir=${DB_DATA_DIR}")
    am_i_root && args=("${args[@]}" "--user=$DB_DAEMON_USER")
    if [[ "$DB_FLAVOR" = "mysql" ]]; then
        command="${DB_BIN_DIR}/mysqld"
        args+=("--initialize-insecure")
    else
        args+=("--auth-root-authentication-method=normal")
    fi
    debug_execute "$command" "${args[@]}"
}

########################
# Upgrade Database Schema
# Globals:
#   BITNAMI_DEBUG
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mysql_upgrade() {
    local -a args=("--defaults-file=${DB_CONF_FILE}" "-u" "$DB_ROOT_USER" "--force")
    local major_version minor_version patch_version
    major_version="$(get_sematic_version "$(mysql_get_version)" 1)"
    minor_version="$(get_sematic_version "$(mysql_get_version)" 2)"
    patch_version="$(get_sematic_version "$(mysql_get_version)" 3)"
    info "Running mysql_upgrade"
    if [[ "$DB_FLAVOR" = "mysql" ]] && [[
        "$major_version" -gt "8"
        || ( "$major_version" -eq "8" && "$minor_version" -gt "0" )
        || ( "$major_version" -eq "8" && "$minor_version" -eq "0" && "$patch_version" -ge "16" )
    ]]; then
        mysql_stop
        mysql_start_bg "--upgrade=FORCE"
    else
        mysql_start_bg
        is_boolean_yes "${ROOT_AUTH_ENABLED:-false}" && args+=("-p$(get_master_env_var_value ROOT_PASSWORD)")
        debug_execute "${DB_BIN_DIR}/mysql_upgrade" "${args[@]}"
    fi
}

########################
# Migrate old custom configuration files
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
migrate_old_configuration() {
    local -r old_custom_conf_file="$DB_VOLUME_DIR/conf/my_custom.cnf"
    local -r custom_conf_file="$DB_CONF_DIR/bitnami/my_custom.cnf"
    debug "Persisted configuration detected. Migrating any existing 'my_custom.cnf' file to new location"
    warn "Custom configuration files are not persisted any longer"
    if [[ -f "$old_custom_conf_file" ]]; then
        info "Adding old custom configuration to user configuration"
        echo "" >> "$custom_conf_file"
        cat "$old_custom_conf_file" >> "$custom_conf_file"
    fi
    if am_i_root; then
        [[ -e "$DB_VOLUME_DIR/.initialized" ]] && rm "$DB_VOLUME_DIR/.initialized"
        rm -rf "$DB_VOLUME_DIR/conf"
    else
        warn "Old custom configuration migrated, please manually remove the 'conf' directory from the volume use to persist data"
    fi
}

########################
# Ensure a db user exists with the given password for the '%' host
# Globals:
#   DB_*
# Flags:
#   -p|--password - database password
#   -u|--user - database user
#   --auth-plugin - authentication plugin
#   --use-ldap - authenticate user via LDAP
#   --host - database host
#   --port - database host
# Arguments:
#   $1 - database user
# Returns:
#   None
#########################
mysql_ensure_user_exists() {
    local -r user="${1:?user is required}"
    local password=""
    local auth_plugin=""
    local use_ldap="no"
    local hosts
    local auth_string=""
    local ssl_ca=""
    # For accessing an external database
    local db_host=""
    local db_port=""

    # Validate arguments
    shift 1
    while [ "$#" -gt 0 ]; do
        case "$1" in
            -p|--password)
                shift
                password="${1:?missing database password}"
                ;;
            --auth-plugin)
                shift
                auth_plugin="${1:?missing authentication plugin}"
                ;;
            --use-ldap)
                use_ldap="yes"
                ;;
            --ssl-ca)
                shift
                ssl_ca="${1:?missing path to ssl CA}"
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
    if is_boolean_yes "$use_ldap"; then
        auth_string="identified via pam using '$DB_FLAVOR'"
    elif [[ -n "$password" ]]; then
        if [[ -n "$auth_plugin" ]]; then
            auth_string="identified with $auth_plugin by '$password'"
        else
            auth_string="identified by '$password'"
        fi
    fi
    debug "creating database user \'$user\'"
    local -a opts=()
    [[ -n "$db_host" ]] && opts+=("-h" "${db_host}")
    [[ -n "$db_port" ]] && opts+=("-P" "${db_port}")
    [[ -n "$ssl_ca" ]] && opts+=("--ssl-ca" "$ssl_ca")
    local mysql_create_user_cmd
    [[ "$DB_FLAVOR" = "mariadb" ]] && mysql_create_user_cmd="create or replace user" || mysql_create_user_cmd="create user if not exists"
    mysql_execute "mysql" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD" "${opts[@]:-}" <<EOF
${mysql_create_user_cmd} '${user}'@'%' ${auth_string};
EOF
    debug "Removing all other hosts for the user"
    hosts=$(mysql_execute_print_output "mysql" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD" "${opts[@]:-}" <<EOF
select Host from user where User='${user}' and Host!='%';
EOF
)
    for host in $hosts; do
        mysql_execute "mysql" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD" "${opts[@]:-}" <<EOF
drop user '$user'@'$host';
EOF
    done
}

########################
# Ensure a db user does not exist
# Globals:
#   DB_*
# Arguments:
#   $1 - db user
# Returns:
#   None
#########################
mysql_ensure_user_not_exists() {
    local -r user="${1}"
    local hosts

    if [[ -z "$user" ]]; then
        debug "removing the unknown user"
    else
        debug "removing user $user"
    fi
    hosts=$(mysql_execute_print_output "mysql" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD" <<EOF
select Host from user where User='$user';
EOF
)
    for host in $hosts; do
        mysql_execute "mysql" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD" <<EOF
drop user '$user'@'$host';
EOF
    done
}

########################
# Ensure the root user exists for host '%' and has full access
# Globals:
#   DB_*
# Arguments:
#   $1 - root user
#   $2 - root password
#   $3 - authentication plugin
# Returns:
#   None
#########################
mysql_ensure_root_user_exists() {
    local -r user="${1:?user is required}"
    local -r password="${2:-}"
    local -r auth_plugin="${3:-}"
    local auth_plugin_str=""
    local alter_view_str=""

    if [[ -n "$auth_plugin" ]]; then
        auth_plugin_str="with $auth_plugin"
    fi

    debug "Configuring root user credentials"
    if [ "$DB_FLAVOR" == "mariadb" ]; then
        mysql_execute "mysql" "root" <<EOF
-- create root@localhost user for local admin access
-- create user 'root'@'localhost' $([ "$password" != "" ] && echo "identified by '$password'");
-- grant all on *.* to 'root'@'localhost' with grant option;
-- create admin user for remote access
create user '$user'@'%' $([ "$password" != "" ] && echo "identified $auth_plugin_str by '$password'");
grant all on *.* to '$user'@'%' with grant option;
flush privileges;
EOF
        # Since MariaDB >=10.4, the mysql.user table was replaced with a view: https://mariadb.com/kb/en/mysqluser-table/
        # Views have a definer user, in this case set to 'root', which needs to exist for the view to work
        # In MySQL, to avoid issues when renaming the root user, they use the 'mysql.sys' user as a definer: https://dev.mysql.com/doc/refman/5.7/en/sys-schema.html
        # However, for MariaDB that is not the case, so when the 'root' user is renamed the 'mysql.user' table stops working and the view needs to be fixed
        if [[ "$user" != "root" && ! "$(mysql_get_version)" =~ ^10.[0123]. ]]; then
            alter_view_str="$(mysql_execute_print_output "mysql" "$user" "$password" "-s" <<EOF
-- create per-view string for altering its definer
select concat("alter definer='$user'@'%' VIEW ", table_name, " AS ", view_definition, ";") FROM information_schema.views WHERE table_schema='mysql';
EOF
)"
            mysql_execute "mysql" "$user" "$password" <<<"$alter_view_str; flush privileges;"
        fi
    else
        mysql_execute "mysql" "root" <<EOF
-- create admin user
create user '$user'@'%' $([ "$password" != "" ] && echo "identified by '$password'");
grant all on *.* to '$user'@'%' with grant option;
flush privileges;
EOF
    fi
}

########################
# Ensure the application database exists
# Globals:
#   DB_*
# Arguments:
#   $1 - database name
# Flags:
#   --character-set - character set
#   --collation - collation
#   --host - database host
#   --port - database port
# Returns:
#   None
#########################
mysql_ensure_database_exists() {
    local -r database="${1:?database is required}"
    local character_set=""
    local collate=""
    # For accessing an external database
    local db_host=""
    local db_port=""

    # Validate arguments
    shift 1
    while [ "$#" -gt 0 ]; do
        case "$1" in
            --character-set)
                shift
                character_set="${1:?missing character set}"
                ;;
            --collate)
                shift
                collate="${1:?missing collate}"
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

    local -a extra_args=()
    [[ -n "$character_set" ]] && extra_args=("character set = '${character_set}'")
    [[ -n "$collate" ]] && extra_args=("collate = '${collate}'")

    local -a mysql_execute_cmd=("mysql_execute")
    [[ -n "$db_host" && -n "$db_port" ]] && mysql_execute_cmd=("mysql_remote_execute" "$db_host" "$db_port")

    debug "Creating database $database"
    "${mysql_execute_cmd[@]}" "mysql" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD" <<EOF
create database if not exists \`$database\` ${extra_args[@]:-};
EOF
}

########################
# Ensure a user has all privileges to access a database
# Globals:
#   DB_*
# Arguments:
#   $1 - database name
#   $2 - database user
#   $3 - database host (optional)
#   $4 - database port (optional)
# Returns:
#   None
#########################
mysql_ensure_user_has_database_privileges() {
    local -r user="${1:?user is required}"
    local -r database="${2:?db is required}"
    local -r db_host="${3:-}"
    local -r db_port="${4:-}"

    local -a mysql_execute_cmd=("mysql_execute")
    [[ -n "$db_host" && -n "$db_port" ]] && mysql_execute_cmd=("mysql_remote_execute" "$db_host" "$db_port")

    debug "Providing privileges to username $user on database $database"
    "${mysql_execute_cmd[@]}" "mysql" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD" <<EOF
grant all on \`$database\`.* to '$user'@'%';
EOF
}

########################
# Optionally create the given database user
# Flags:
#   -p|--password - database password
#   --auth-plugin - authentication plugin
#   --use-ldap - authenticate user via LDAP
#   --host - database host
#   --port - database port
# Arguments:
#   $1 - user
# Returns:
#   None
#########################
mysql_ensure_optional_user_exists() {
    local -r user="${1:?user is missing}"
    local password=""
    local auth_plugin=""
    local use_ldap="no"
    # For accessing an external database
    local db_host=""
    local db_port=""

    # Validate arguments
    shift 1
    while [ "$#" -gt 0 ]; do
        case "$1" in
            -p|--password)
                shift
                password="${1:?missing password}"
                ;;
            --auth-plugin)
                shift
                auth_plugin="${1:?missing authentication plugin}"
                ;;
            --use-ldap)
                use_ldap="yes"
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

    local -a flags=("$user")
    [[ -n "$db_host" ]] && flags+=("--host" "${db_host}")
    [[ -n "$db_port" ]] && flags+=("--port" "${db_port}")
    if is_boolean_yes "$use_ldap"; then
        flags+=("--use-ldap")
    elif [[ -n "$password" ]]; then
        flags+=("-p" "$password")
        [[ -n "$auth_plugin" ]] && flags=("${flags[@]}" "--auth-plugin" "$auth_plugin")
    fi
    mysql_ensure_user_exists "${flags[@]}"
}

########################
# Optionally create the given database, and then optionally give a user
# full privileges on the database.
# Flags:
#   -u|--user - database user
#   --character-set - character set
#   --collation - collation
#   --host - database host
#   --port - database port
# Arguments:
#   $1 - database name
# Returns:
#   None
#########################
mysql_ensure_optional_database_exists() {
    local -r database="${1:?database is missing}"
    local character_set=""
    local collate=""
    local user=""
    # For accessing an external database
    local db_host=""
    local db_port=""

    # Validate arguments
    shift 1
    while [ "$#" -gt 0 ]; do
        case "$1" in
            --character-set)
                shift
                character_set="${1:?missing character set}"
                ;;
            --collate)
                shift
                collate="${1:?missing collate}"
                ;;
            -u|--user)
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

    local -a flags=("$database")
    [[ -n "$character_set" ]] && flags+=("--character-set" "$character_set")
    [[ -n "$collate" ]] && flags+=("--collate" "$collate")
    [[ -n "$db_host" ]] && flags+=("--host" "$db_host")
    [[ -n "$db_port" ]] && flags+=("--port" "$db_port")
    mysql_ensure_database_exists "${flags[@]}"

    if [[ -n "$user" ]]; then
        local -a grant_flags=("$user" "$database")
        [[ -n "$db_host" ]] && grant_flags+=("$db_host")
        [[ -n "$db_port" ]] && grant_flags+=("$db_port")
        mysql_ensure_user_has_database_privileges "${grant_flags[@]}"
    fi
}

########################
# Add or modify an entry in the MySQL configuration file ("$DB_CONF_FILE")
# Globals:
#   DB_*
# Arguments:
#   $1 - MySQL variable name
#   $2 - Value to assign to the MySQL variable
#   $3 - Section in the MySQL configuration file the key is located (default: mysqld)
#   $4 - Configuration file (default: "$BD_CONF_FILE")
# Returns:
#   None
#########################
mysql_conf_set() {
    local -r key="${1:?key missing}"
    local -r value="${2:?value missing}"
    read -r -a sections <<<"${3:-mysqld}"
    local -r file="${4:-"$DB_CONF_FILE"}"
    info "Setting ${key} option"
    debug "Setting ${key} to '${value}' in ${DB_FLAVOR} configuration file ${file}"
    # Check if the configuration exists in the file
    for section in "${sections[@]}"; do
        ini-file set --section "$section" --key "$key" --value "$value" "$file"
    done
}

########################
# Update MySQL/MariaDB configuration file with user custom inputs
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mysql_update_custom_config() {
    # Persisted configuration files from old versions
    ! is_dir_empty "$DB_VOLUME_DIR" && [[ -d "$DB_VOLUME_DIR/conf" ]] && migrate_old_configuration

    # User injected custom configuration
    if [[ -f "$DB_CONF_DIR/my_custom.cnf" ]]; then
        debug "Injecting custom configuration from my_custom.conf"
        cat "$DB_CONF_DIR/my_custom.cnf" > "$DB_CONF_DIR/bitnami/my_custom.cnf"
    fi

    ! is_empty_value "$DB_USER" && mysql_conf_set "user" "$DB_USER" "mysqladmin"
    ! is_empty_value "$DB_PORT_NUMBER" && mysql_conf_set "port" "$DB_PORT_NUMBER" "mysqld client manager"
    ! is_empty_value "$DB_CHARACTER_SET" && mysql_conf_set "character_set_server" "$DB_CHARACTER_SET"
    ! is_empty_value "$DB_COLLATE" && mysql_conf_set "collation_server" "$DB_COLLATE"
    ! is_empty_value "$DB_BIND_ADDRESS" && mysql_conf_set "bind_address" "$DB_BIND_ADDRESS"
    ! is_empty_value "$DB_AUTHENTICATION_PLUGIN" && mysql_conf_set "default_authentication_plugin" "$DB_AUTHENTICATION_PLUGIN"
    ! is_empty_value "$DB_SQL_MODE" && mysql_conf_set "sql_mode" "$DB_SQL_MODE"

    # Avoid exit code of previous commands to affect the result of this function
    true
}

########################
# Find the path to the libjemalloc library file
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   Path to a libjemalloc shared object file
#########################
find_jemalloc_lib() {
    local -a locations=( "/usr/lib" "/usr/lib64" )
    local -r pattern='libjemalloc.so.[0-9]'
    local path
    for dir in "${locations[@]}"; do
        # Find the first element matching the pattern and quit
        [[ ! -d "$dir" ]] && continue
        path="$(find "$dir" -name "$pattern" -print -quit)"
        [[ -n "$path" ]] && break
    done
    echo "${path:-}"
}
