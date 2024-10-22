#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami MySQL Client library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libversion.sh

########################
# Validate settings in MYSQL_CLIENT_* environment variables
# Globals:
#   MYSQL_CLIENT_*
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

    check_multi_value() {
        if [[ " ${2} " != *" ${!1} "* ]]; then
            print_validation_error "The allowed values for ${1} are: ${2}"
        fi
    }

    # Only validate environment variables if any action needs to be performed
    check_yes_no_value "MYSQL_CLIENT_ENABLE_SSL_WRAPPER"
    check_multi_value "MYSQL_CLIENT_FLAVOR" "mariadb mysql"

    if [[ -n "$MYSQL_CLIENT_CREATE_DATABASE_USER" || -n "$MYSQL_CLIENT_CREATE_DATABASE_NAME" ]]; then
        if is_boolean_yes "$ALLOW_EMPTY_PASSWORD"; then
            empty_password_enabled_warn
        else
            if [[ -z "$MYSQL_CLIENT_DATABASE_ROOT_PASSWORD" ]]; then
                empty_password_error "MYSQL_CLIENT_DATABASE_ROOT_PASSWORD"
            fi
            if [[ -n "$MYSQL_CLIENT_CREATE_DATABASE_USER" ]] && [[ -z "$MYSQL_CLIENT_CREATE_DATABASE_PASSWORD" ]]; then
                empty_password_error "MYSQL_CLIENT_CREATE_DATABASE_PASSWORD"
            fi
        fi
        if [[ "${MYSQL_CLIENT_DATABASE_ROOT_PASSWORD:-}" = *\\* ]]; then
            backslash_password_error "MYSQL_CLIENT_DATABASE_ROOT_PASSWORD"
        fi
        if [[ "${MYSQL_CLIENT_CREATE_DATABASE_PASSWORD:-}" = *\\* ]]; then
            backslash_password_error "MYSQL_CLIENT_CREATE_DATABASE_PASSWORD"
        fi
    fi
    return "$error_code"
}

########################
# Perform actions to a database
# Globals:
#   DB_*
#   MYSQL_CLIENT_*
# Arguments:
#   None
# Returns:
#   None
#########################
mysql_client_initialize() {
    # Wrap binary to force the usage of SSL
    if is_boolean_yes "$MYSQL_CLIENT_ENABLE_SSL_WRAPPER"; then
        mysql_client_wrap_binary_for_ssl
    fi
    # Wait for the database to be accessible if any action needs to be performed
    if [[ -n "$MYSQL_CLIENT_CREATE_DATABASE_USER" || -n "$MYSQL_CLIENT_CREATE_DATABASE_NAME" ]]; then
        info "Trying to connect to the database server"
        check_mysql_connection() {
            echo "SELECT 1" | mysql_execute "mysql" "$MYSQL_CLIENT_DATABASE_ROOT_USER" "$MYSQL_CLIENT_DATABASE_ROOT_PASSWORD" "-h" "$MYSQL_CLIENT_DATABASE_HOST" "-P" "$MYSQL_CLIENT_DATABASE_PORT_NUMBER"
        }
        if ! retry_while "check_mysql_connection"; then
            error "Could not connect to the database server"
            return 1
        fi
    fi
    # Ensure a database user exists in the server
    if [[ -n "$MYSQL_CLIENT_CREATE_DATABASE_USER" ]]; then
        info "Creating database user ${MYSQL_CLIENT_CREATE_DATABASE_USER}"
        local -a args=("$MYSQL_CLIENT_CREATE_DATABASE_USER" "--host" "$MYSQL_CLIENT_DATABASE_HOST" "--port" "$MYSQL_CLIENT_DATABASE_PORT_NUMBER")
        [[ -n "$MYSQL_CLIENT_CREATE_DATABASE_PASSWORD" ]] && args+=("-p" "$MYSQL_CLIENT_CREATE_DATABASE_PASSWORD")
        [[ -n "$MYSQL_CLIENT_DATABASE_AUTHENTICATION_PLUGIN" ]] && args+=("--auth-plugin" "$MYSQL_CLIENT_DATABASE_AUTHENTICATION_PLUGIN")
        mysql_ensure_optional_user_exists "${args[@]}"
    fi
    # Ensure a database exists in the server (and that the user has write privileges, if specified)
    if [[ -n "$MYSQL_CLIENT_CREATE_DATABASE_NAME" ]]; then
        info "Creating database ${MYSQL_CLIENT_CREATE_DATABASE_NAME}"
        local -a createdb_args=("$MYSQL_CLIENT_CREATE_DATABASE_NAME" "--host" "$MYSQL_CLIENT_DATABASE_HOST" "--port" "$MYSQL_CLIENT_DATABASE_PORT_NUMBER")
        [[ -n "$MYSQL_CLIENT_CREATE_DATABASE_USER" ]] && createdb_args+=("-u" "$MYSQL_CLIENT_CREATE_DATABASE_USER")
        [[ -n "$MYSQL_CLIENT_CREATE_DATABASE_CHARACTER_SET" ]] && createdb_args+=("--character-set" "$MYSQL_CLIENT_CREATE_DATABASE_CHARACTER_SET")
        [[ -n "$MYSQL_CLIENT_CREATE_DATABASE_COLLATE" ]] && createdb_args+=("--collate" "$MYSQL_CLIENT_CREATE_DATABASE_COLLATE")
        [[ -n "$MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES" ]] && createdb_args+=("--privileges" "$MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES")
        mysql_ensure_optional_database_exists "${createdb_args[@]}"
    fi
}

########################
# Wrap binary to force the usage of SSL
# Globals:
#   DB_*
#   MYSQL_CLIENT_*
# Arguments:
#   None
# Returns:
#   None
#########################
mysql_client_wrap_binary_for_ssl() {
    local wrapper_file="${DB_BIN_DIR}/mysql"
    # In MySQL Client 10.6, mysql is a link to the mariadb binary
    if [[ -f "${DB_BIN_DIR}/mariadb" ]]; then
        wrapper_file="${DB_BIN_DIR}/mariadb"
    fi
    local -r wrapped_binary_file="${DB_BASE_DIR}/.bin/mysql"
    local -a ssl_opts=()
    read -r -a ssl_opts <<<"$(mysql_client_extra_opts)"

    mv "$wrapper_file" "$wrapped_binary_file"
    cat >"$wrapper_file" <<EOF
#!/bin/sh
exec "${wrapped_binary_file}" "\$@" ${ssl_opts[@]:-}
EOF
    chmod +x "$wrapper_file"
}

#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Library for mysql common

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
    read -r -a ver_split <<< "$ver_string"

    if [[ "$ver_string" = *" Distrib "* ]]; then
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
    local -r prefix="${DB_FLAVOR//-/_}"
    echo "${prefix^^}_${id}"
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
    local -a opts extra_opts
    read -r -a opts <<< "${@:4}"
    read -r -a extra_opts <<< "$(mysql_client_extra_opts)"

    # Process mysql CLI arguments
    local -a args=()
    if [[ -f "$DB_CONF_FILE" ]]; then
        args+=("--defaults-file=${DB_CONF_FILE}")
    fi
    args+=("-N" "-u" "$user")
    [[ -n "$db" ]] && args+=("$db")
    [[ -n "$pass" ]] && args+=("-p$pass")
    [[ "${#opts[@]}" -gt 0 ]] && args+=("${opts[@]}")
    [[ "${#extra_opts[@]}" -gt 0 ]] && args+=("${extra_opts[@]}")

    # Obtain the command specified via stdin
    if [[ "${BITNAMI_DEBUG:-false}" = true ]]; then
        local mysql_cmd
        mysql_cmd="$(</dev/stdin)"
        debug "Executing SQL command:\n$mysql_cmd"
        "$DB_BIN_DIR/mysql" "${args[@]}" <<<"$mysql_cmd"
    else
        # Do not store the command(s) as a variable, to avoid issues when importing large files
        # https://github.com/bitnami/bitnami-docker-mariadb/issues/251
        "$DB_BIN_DIR/mysql" "${args[@]}"
    fi
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
# Execute an arbitrary query/queries against a remote MySQL/MariaDB service and print to stdout
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
mysql_remote_execute_print_output() {
    local -r hostname="${1:?hostname is required}"
    local -r port="${2:?port is required}"
    local -a args=("-h" "$hostname" "-P" "$port" "--connect-timeout=5")
    # When using "localhost" it would try to connect to the socket, which will not exist for mysql-client
    [[ -n "${MYSQL_CLIENT_FLAVOR:-}" && "$hostname" = "localhost" ]] && args+=("--protocol=tcp")
    shift 2
    "mysql_execute_print_output" "$@" "${args[@]}"
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
    debug_execute "mysql_remote_execute_print_output" "$@"
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
# Wait for MySQL/MariaDB to be running
# Globals:
#   DB_TMP_DIR
#   DB_STARTUP_WAIT_RETRIES
#   DB_STARTUP_WAIT_SLEEP_TIME
# Arguments:
#   None
# Returns:
#   Boolean
#########################
wait_for_mysql() {
    local pid
    local -r retries="${DB_STARTUP_WAIT_RETRIES:-300}"
    local -r sleep_time="${DB_STARTUP_WAIT_SLEEP_TIME:-2}"
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
    local -r user="${1:-root}"
    local -a args=("mysql" "$user")
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
    local -r retries=25
    local -r sleep_time=5

    are_db_files_locked() {
        local return_value=0
        read -r -a db_files <<< "$(find "$DB_DATA_DIR" -regex "^.*ibdata[0-9]+" -print0 -o -regex "^.*ib_logfile[0-9]+" -print0 | xargs -0)"
        for f in "${db_files[@]}"; do
            debug_execute fuser "$f" && return_value=1
        done
        return "$return_value"
    }

    ! is_mysql_running && return

    info "Stopping $DB_FLAVOR"
    stop_service_using_pid "$DB_PID_FILE"
    debug "Waiting for $DB_FLAVOR to unlock db files"
    if ! retry_while are_db_files_locked "$retries" "$sleep_time"; then
        error "$DB_FLAVOR failed to stop"
        return 1
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
mysql_migrate_old_configuration() {
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

    local -a mysql_execute_cmd=("mysql_execute")
    local -a mysql_execute_print_output_cmd=("mysql_execute_print_output")
    if [[ -n "$db_host" && -n "$db_port" ]]; then
        mysql_execute_cmd=("mysql_remote_execute" "$db_host" "$db_port")
        mysql_execute_print_output_cmd=("mysql_remote_execute_print_output" "$db_host" "$db_port")
    fi

    local mysql_create_user_cmd
    [[ "$DB_FLAVOR" = "mariadb" ]] && mysql_create_user_cmd="create or replace user" || mysql_create_user_cmd="create user if not exists"
    "${mysql_execute_cmd[@]}" "mysql" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD" <<EOF
${mysql_create_user_cmd} '${user}'@'%' ${auth_string};
EOF
    debug "Removing all other hosts for the user"
    hosts=$("${mysql_execute_print_output_cmd[@]}" "mysql" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD" <<EOF
select Host from user where User='${user}' and Host!='%';
EOF
)
    for host in $hosts; do
        "${mysql_execute_cmd[@]}" "mysql" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD" <<EOF
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
    if [[ "$DB_FLAVOR" = "mariadb" ]]; then
        mysql_execute "mysql" "root" <<EOF
-- create root@localhost user for local admin access
-- create user 'root'@'localhost' $([ "$password" != "" ] && echo "identified by \"$password\"");
-- grant all on *.* to 'root'@'localhost' with grant option;
-- create admin user for remote access
create user '$user'@'%' $([ "$password" != "" ] && echo "identified $auth_plugin_str by \"$password\"");
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
create user '$user'@'%' $([ "$password" != "" ] && echo "identified by \"$password\"");
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

    local -a mysql_execute_cmd=("mysql_execute")
    [[ -n "$db_host" && -n "$db_port" ]] && mysql_execute_cmd=("mysql_remote_execute" "$db_host" "$db_port")

    local -a create_database_args=()
    [[ -n "$character_set" ]] && create_database_args+=("character set = '${character_set}'")
    [[ -n "$collate" ]] && create_database_args+=("collate = '${collate}'")

    debug "Creating database $database"
    "${mysql_execute_cmd[@]}" "mysql" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD" <<EOF
create database if not exists \`$database\` ${create_database_args[@]:-};
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
    local -r privileges="${3:-all}"
    local -r db_host="${4:-}"
    local -r db_port="${5:-}"

    local -a mysql_execute_cmd=("mysql_execute")
    [[ -n "$db_host" && -n "$db_port" ]] && mysql_execute_cmd=("mysql_remote_execute" "$db_host" "$db_port")

    debug "Providing privileges to username $user on database $database"
    "${mysql_execute_cmd[@]}" "mysql" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD" <<EOF
grant ${privileges} on \`${database}\`.* to '${user}'@'%';
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
    local privileges=""
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
            --privileges)
                shift
                privileges="${1:?missing privileges}"
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
        mysql_ensure_user_has_database_privileges "$user" "$database" "$privileges" "$db_host" "$db_port"
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
    local -r ignore_inline_comments="${4:-no}"
    local -r file="${5:-"$DB_CONF_FILE"}"
    info "Setting ${key} option"
    debug "Setting ${key} to '${value}' in ${DB_FLAVOR} configuration file ${file}"
    # Check if the configuration exists in the file
    for section in "${sections[@]}"; do
        if is_boolean_yes "$ignore_inline_comments"; then
            ini-file set --ignore-inline-comments --section "$section" --key "$key" --value "$value" "$file"
        else
            ini-file set --section "$section" --key "$key" --value "$value" "$file"
        fi
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
    ! is_dir_empty "$DB_VOLUME_DIR" && [[ -d "$DB_VOLUME_DIR/conf" ]] && mysql_migrate_old_configuration

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
    ! is_empty_value "$DB_ENABLE_SLOW_QUERY" && mysql_conf_set "slow_query_log" "$DB_ENABLE_SLOW_QUERY"
    ! is_empty_value "$DB_LONG_QUERY_TIME" && mysql_conf_set "long_query_time" "$DB_LONG_QUERY_TIME"

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

########################
# Execute a reliable health check against the current mysql instance
# Globals:
#   DB_ROOT_USER, DB_ROOT_PASSWORD, DB_MASTER_ROOT_PASSWORD
# Arguments:
#   None
# Returns:
#   mysqladmin output
#########################
mysql_healthcheck() {
    local args=("-u${DB_ROOT_USER}" "-h0.0.0.0")
    local root_password

    root_password="$(get_master_env_var_value ROOT_PASSWORD)"
    if [[ -n "$root_password" ]]; then
        args+=("-p${root_password}")
    fi

    mysqladmin "${args[@]}" ping && mysqladmin "${args[@]}" status
}

########################
# Prints flavor of 'mysql' client (useful to determine proper CLI flags that can be used)
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   mysql client flavor
#########################
mysql_client_flavor() {
    if "${DB_BIN_DIR}/mysql" "--version" 2>&1 | grep -q MariaDB; then
        echo "mariadb"
    else
        echo "mysql"
    fi
}

########################
# Prints extra options for MySQL client calls (i.e. SSL options)
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   List of options to pass to "mysql" CLI
#########################
mysql_client_extra_opts() {
    # Helper to get the proper value for the MySQL client environment variable
    mysql_client_env_value() {
        local env_name="MYSQL_CLIENT_${1:?missing name}"
        if [[ -n "${!env_name:-}" ]]; then
            echo "${!env_name:-}"
        else
            env_name="DB_CLIENT_${1}"
            echo "${!env_name:-}"
        fi
    }
    local -a opts=()
    local key value
    if is_boolean_yes "${DB_ENABLE_SSL:-no}"; then
        if [[ "$(mysql_client_flavor)" = "mysql" ]]; then
            opts+=("--ssl-mode=REQUIRED")
        else
            opts+=("--ssl=TRUE")
        fi
        # Add "--ssl-ca", "--ssl-key" and "--ssl-cert" options if the env vars are defined
        for key in ca key cert; do
            value="$(mysql_client_env_value "SSL_${key^^}_FILE")"
            [[ -n "${value}" ]] && opts+=("--ssl-${key}=${value}")
        done
    else
        # Skip SSL validation
        if [[ "$(mysql_client_flavor)" = "mariadb" ]]; then
            # SSL connections are enabled by default in MariaDB >=10.11
            local mysql_version=""
            local major_version=""
            local minor_version=""
            mysql_version="$(mysql_get_version)"
            major_version="$(get_sematic_version "${mysql_version}" 1)"
            minor_version="$(get_sematic_version "${mysql_version}" 2)"
            if [[ "${major_version}" -gt 10 ]] || [[ "${major_version}" -eq 10 && "${minor_version}" -eq 11 ]]; then
                opts+=("--skip-ssl")
            fi
        fi
    fi
    echo "${opts[@]:-}"
}
