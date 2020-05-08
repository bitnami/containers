#!/bin/bash
#
# Bitnami MySQL library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libversion.sh

########################
# Configure database extra start flags
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   Array with extra flags to use
#########################
mysql_extra_flags() {
    local randNumber
    local dbExtraFlags
    local userExtraFlags
    randNumber=$(head /dev/urandom | tr -dc 0-9 | head -c 3 ; echo '')
    read -r -a userExtraFlags <<< "$(get_env_var_value EXTRA_FLAGS)"

    if [[ -n "$DB_REPLICATION_MODE" ]]; then
        dbExtraFlags+=("--server-id=$randNumber" "--binlog-format=ROW" "--log-bin=mysql-bin" "--sync-binlog=1")
        if [[ "$DB_REPLICATION_MODE" = "slave" ]]; then
            dbExtraFlags+=("--relay-log=mysql-relay-bin" "--log-slave-updates=1" "--read-only=1")
            if [[ "$DB_FLAVOR" = "mysql" ]]; then
                dbExtraFlags+=("--master-info-repository=TABLE" "--relay-log-info-repository=TABLE")
            fi
        elif [[ "$DB_REPLICATION_MODE" = "master" ]]; then
            dbExtraFlags+=("--innodb_flush_log_at_trx_commit=1")
        fi
    fi

    [[ -z ${userExtraFlags:-} ]] || dbExtraFlags=("${dbExtraFlags[@]:-}" "${userExtraFlags[@]}")

    echo "${dbExtraFlags[@]:-}"
}

########################
# Loads global variables used on MySQL/MariaDB configuration.
# Globals:
#   DB_FLAVOR
#   DB_SBIN_DIR
#   MYSQL_*/MARIADB_*
# Arguments:
#   None
# Returns:
#   Series of exports to be used as 'eval' arguments
#########################
mysql_env() {
    cat <<"EOF"
export DB_FLAVOR="${DB_FLAVOR:-mysql}"
# Format log messages
export MODULE="$DB_FLAVOR"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"
# Paths
export DB_VOLUME_DIR="/bitnami/$DB_FLAVOR"
export DB_DATA_DIR="$DB_VOLUME_DIR/data"
export DB_BASE_DIR="/opt/bitnami/$DB_FLAVOR"
export DB_CONF_DIR="$DB_BASE_DIR/conf"
export DB_LOG_DIR="$DB_BASE_DIR/logs"
export DB_TMP_DIR="$DB_BASE_DIR/tmp"
export DB_BIN_DIR="$DB_BASE_DIR/bin"
export DB_SBIN_DIR="${DB_SBIN_DIR:-$DB_BASE_DIR/bin}"
export PATH="$DB_BIN_DIR:$PATH"
# Users
export DB_DAEMON_USER="mysql"
export DB_DAEMON_GROUP="mysql"
# Settings
export DB_MASTER_HOST="$(get_env_var_value MASTER_HOST)"
MASTER_PORT_NUMBER="$(get_env_var_value MASTER_PORT_NUMBER)"
export DB_MASTER_PORT_NUMBER="${MASTER_PORT_NUMBER:-3306}"
PORT_NUMBER="$(get_env_var_value PORT_NUMBER)"
export DB_PORT_NUMBER="${PORT_NUMBER:-3306}"
export DB_REPLICATION_MODE="$(get_env_var_value REPLICATION_MODE)"
read -r -a DB_EXTRA_FLAGS <<< "$(mysql_extra_flags)"
export DB_EXTRA_FLAGS
DB_INIT_SLEEP_TIME="$(get_env_var_value INIT_SLEEP_TIME)"
export DB_INIT_SLEEP_TIME="${DB_INIT_SLEEP_TIME:-}"
# Authentication
export ALLOW_EMPTY_PASSWORD="${ALLOW_EMPTY_PASSWORD:-no}"
ROOT_USER="$(get_env_var_value ROOT_USER)"
export DB_ROOT_USER="${ROOT_USER:-root}"
export DB_DATABASE="$(get_env_var_value DATABASE)"
export DB_USER="$(get_env_var_value USER)"
export DB_AUTHENTICATION_PLUGIN="$(get_env_var_value AUTHENTICATION_PLUGIN)"
export DB_REPLICATION_USER="$(get_env_var_value REPLICATION_USER)"
MASTER_ROOT_USER="$(get_env_var_value MASTER_ROOT_USER)"
export DB_MASTER_ROOT_USER="${MASTER_ROOT_USER:-root}"
CHARACTER_SET="$(get_env_var_value CHARACTER_SET)"
export DB_CHARACTER_SET="${CHARACTER_SET:-utf8}"
COLLATE="$(get_env_var_value COLLATE)"
export DB_COLLATE="${COLLATE:-utf8_general_ci}"
EOF
    DB_FLAVOR="${DB_FLAVOR:-mysql}"
    # Credentials should be allowed to be mounted as files to avoid sensitive data
    # in the environment variables
    password_file="$(get_env_var_value ROOT_PASSWORD_FILE)"
    if [[ -f "${password_file:-}" ]]; then
        cat <<"EOF"
    DB_ROOT_PASSWORD_FILE="$(get_env_var_value ROOT_PASSWORD_FILE)"
    export DB_ROOT_PASSWORD="$(< "${DB_ROOT_PASSWORD_FILE}")"
EOF
    else
        cat <<"EOF"
    DB_ROOT_PASSWORD="$(get_env_var_value ROOT_PASSWORD)"
    export DB_ROOT_PASSWORD="${DB_ROOT_PASSWORD:-}"
EOF
    fi
    password_file="$(get_env_var_value PASSWORD_FILE)"
    if [[ -f "${password_file:-}" ]]; then
        cat <<"EOF"
    DB_PASSWORD_FILE="$(get_env_var_value PASSWORD_FILE)"
    export DB_PASSWORD="$(< "${DB_PASSWORD_FILE}")"
EOF
    else
        cat <<"EOF"
    DB_PASSWORD="$(get_env_var_value PASSWORD)"
    export DB_PASSWORD="${DB_PASSWORD:-}"
EOF
    fi
    password_file="$(get_env_var_value REPLICATION_PASSWORD_FILE)"
    if [[ -f "${password_file:-}" ]]; then
        cat <<"EOF"
    DB_REPLICATION_PASSWORD_FILE="$(get_env_var_value REPLICATION_PASSWORD_FILE)"
    export DB_REPLICATION_PASSWORD="$(< "${DB_REPLICATION_PASSWORD_FILE}")"
EOF
    else
        cat <<"EOF"
    DB_REPLICATION_PASSWORD="$(get_env_var_value REPLICATION_PASSWORD)"
    export DB_REPLICATION_PASSWORD="${DB_REPLICATION_PASSWORD:-}"
EOF
    fi
    password_file="$(get_env_var_value MASTER_ROOT_PASSWORD_FILE)"
    if [[ -f "${password_file:-}" ]]; then
        cat <<"EOF"
    DB_MASTER_ROOT_PASSWORD_FILE="$(get_env_var_value MASTER_ROOT_PASSWORD_FILE)"
    export DB_MASTER_ROOT_PASSWORD="$(< "${DB_MASTER_ROOT_PASSWORD_FILE}")"
EOF
    else
        cat <<"EOF"
    DB_MASTER_ROOT_PASSWORD="$(get_env_var_value MASTER_ROOT_PASSWORD)"
    export DB_MASTER_ROOT_PASSWORD="${DB_MASTER_ROOT_PASSWORD:-}"
EOF
    fi
}

########################
# Validate settings in MYSQL_*/MARIADB_* environment variables
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mysql_validate() {
    info "Validating settings in MYSQL_*/MARIADB_* env vars"
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

    if [[ -n "$DB_REPLICATION_MODE" ]]; then
        if [[ "$DB_REPLICATION_MODE" = "master" ]]; then
            if is_boolean_yes "$ALLOW_EMPTY_PASSWORD"; then
                empty_password_enabled_warn
            else
                if [[ -n "$DB_REPLICATION_USER" ]] && [[ -z "$DB_REPLICATION_PASSWORD" ]]; then
                    empty_password_error "$(get_env_var REPLICATION_PASSWORD)"
                fi
                if [[ -z "$DB_ROOT_PASSWORD" ]]; then
                    empty_password_error "$(get_env_var ROOT_PASSWORD)"
                fi
                if (( ${#DB_ROOT_PASSWORD} > 32 )); then
                    print_validation_error "The password can not be longer than 32 characters. Set the environment variable $(get_env_var ROOT_PASSWORD) with a shorter value (currently ${#DB_ROOT_PASSWORD} characters)"
                fi
                if [[ -n "$DB_USER" ]] && [[ -z "$DB_PASSWORD" ]]; then
                    empty_password_error "$(get_env_var PASSWORD)"
                fi
            fi
        elif [[ "$DB_REPLICATION_MODE" = "slave" ]]; then
            if [[ -z "$DB_MASTER_HOST" ]]; then
                print_validation_error "Slave replication mode chosen without setting the environment variable $(get_env_var MASTER_HOST). Use it to indicate where the Master node is running"
            fi
        else
            print_validation_error "Invalid replication mode. Available options are 'master/slave'"
        fi
    else
        if is_boolean_yes "$ALLOW_EMPTY_PASSWORD"; then
            empty_password_enabled_warn
        else
            if [[ -z "$DB_ROOT_PASSWORD" ]]; then
                empty_password_error "$(get_env_var ROOT_PASSWORD)"
            fi
            if [[ -n "$DB_USER" ]] && [[ -z "$DB_PASSWORD" ]]; then
                empty_password_error "$(get_env_var PASSWORD)"
            fi
        fi
    fi
    if [[ "${DB_ROOT_PASSWORD:-}" = *\\* ]]; then
        backslash_password_error "$(get_env_var ROOT_PASSWORD)"
    fi
    if [[ "${DB_PASSWORD:-}" = *\\* ]]; then
        backslash_password_error "$(get_env_var PASSWORD)"
    fi
    if [[ "${DB_REPLICATION_PASSWORD:-}" = *\\* ]]; then
        backslash_password_error "$(get_env_var REPLICATION_PASSWORD)"
    fi

    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}

########################
# Creates MySQL/MariaDB configuration file
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mysql_create_config() {
    debug "Creating main configuration file"
    cat > "$DB_CONF_DIR/my.cnf" <<EOF
[mysqladmin]
user=$DB_USER

[mysqld]
skip-name-resolve
explicit_defaults_for_timestamp
basedir=$DB_BASE_DIR
port=$DB_PORT_NUMBER
tmpdir=$DB_TMP_DIR
socket=$DB_TMP_DIR/mysql.sock
pid-file=$DB_TMP_DIR/mysqld.pid
max_allowed_packet=16M
bind-address=127.0.0.1
log-error=$DB_LOG_DIR/mysqld.log
character-set-server=$DB_CHARACTER_SET
collation-server=$DB_COLLATE
plugin_dir=$DB_BASE_DIR/plugin

[client]
port=$DB_PORT_NUMBER
socket=$DB_TMP_DIR/mysql.sock
default-character-set=UTF8
plugin_dir=$DB_BASE_DIR/plugin

[manager]
port=$DB_PORT_NUMBER
socket=$DB_TMP_DIR/mysql.sock
pid-file=$DB_TMP_DIR/mysqld.pid

!include $DB_CONF_DIR/bitnami/my_custom.cnf
EOF
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
mysql_configure_replication() {
    if [[ "$DB_REPLICATION_MODE" = "slave" ]]; then
        info "Configuring replication in slave node"
        debug "Checking if replication master is ready to accept connection"
        while ! echo "select 1" | mysql_remote_execute "mysql" "$DB_MASTER_HOST" "$DB_MASTER_PORT_NUMBER" "$DB_MASTER_ROOT_USER" "$DB_MASTER_ROOT_PASSWORD"; do
            sleep 1
        done
        debug "Replication master ready!"
        debug "Setting the master configuration"
        mysql_execute "mysql" <<EOF
CHANGE MASTER TO MASTER_HOST='$DB_MASTER_HOST',
MASTER_PORT=$DB_MASTER_PORT_NUMBER,
MASTER_USER='$DB_REPLICATION_USER',
MASTER_PASSWORD='$DB_REPLICATION_PASSWORD',
MASTER_CONNECT_RETRY=10;
EOF
    elif [[ "$DB_REPLICATION_MODE" = "master" ]]; then
        info "Configuring replication in master node"
        if [[ -n "$DB_REPLICATION_USER" ]]; then
            mysql_ensure_replication_user_exists "$DB_REPLICATION_USER" "$DB_REPLICATION_PASSWORD"
        fi
    fi
}

########################
# Ensure the replication user exists for host '%' and has full access
# Globals:
#   DB_*
# Arguments:
#   $1 - replication user
#   $2 - replication password
# Returns:
#   None
#########################
mysql_ensure_replication_user_exists() {
    local -r user="${1:?user is required}"
    local -r password="${2:-}"

    debug "Configure replication user credentials"
    if [[ "$DB_FLAVOR" = "mariadb" ]]; then
        mysql_execute "mysql" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD" <<EOF
create or replace user '$user'@'%' $([ "$password" != "" ] && echo "identified by '$password'");
EOF
    else
        mysql_execute "mysql" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD" <<EOF
create user '$user'@'%' $([ "$password" != "" ] && echo "identified with 'mysql_native_password' by '$password'");
EOF
    fi
    mysql_execute "mysql" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD" <<EOF
grant REPLICATION SLAVE on *.* to '$user'@'%' with grant option;
flush privileges;
EOF
}

########################
# Ensure MySQL/MariaDB is initialized
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mysql_initialize() {
    info "Initializing $DB_FLAVOR database"

    # This fixes an issue where the trap would kill the entrypoint.sh, if a PID was left over from a previous run
    # Exec replaces the process without creating a new one, and when the container is restarted it may have the same PID
    rm -f "$DB_TMP_DIR/mysqld.pid"

    # User injected custom configuration
    if [[ -f "$DB_CONF_DIR/my_custom.cnf" ]]; then
        debug "Injecting custom configuration from my_custom.conf"
        cat "$DB_CONF_DIR/my_custom.cnf" > "$DB_CONF_DIR/bitnami/my_custom.cnf"
    fi
    local user_provided_conf=no
    # User injected main configuration
    if [[ -f "$DB_CONF_DIR/my.cnf" ]]; then
        debug "Custom configuration my.cnf detected"
        user_provided_conf=yes
    fi

    # Persisted configuration files from old versions
    ! is_dir_empty "$DB_VOLUME_DIR" && [[ -d "$DB_VOLUME_DIR/conf" ]] && migrate_old_configuration

    debug "Ensuring expected directories/files exist"
    for dir in "$DB_DATA_DIR" "$DB_TMP_DIR" "$DB_LOG_DIR"; do
        ensure_dir_exists "$dir"
        am_i_root && chown "$DB_DAEMON_USER":"$DB_DAEMON_GROUP" "$dir"
    done

    ! is_boolean_yes "$user_provided_conf" && mysql_create_config

    if [[ -e "$DB_DATA_DIR/mysql" ]]; then
        info "Using persisted data"
        # mysql_upgrade requires the server to be running
        [[ -n "$(get_master_env_var_value ROOT_PASSWORD)" ]] && export ROOT_AUTH_ENABLED="yes"
        # https://dev.mysql.com/doc/refman/8.0/en/replication-upgrade.html
        mysql_upgrade
    else
        debug "Cleaning data directory to ensure successfully initialization"
        rm -rf "${DB_DATA_DIR:?}"/*
        info "Installing database"
        mysql_install_db
        mysql_start_bg
        wait_for_mysql_access
        # we delete existing users and create new ones with stricter access
        # commands can still be executed until we restart or run 'flush privileges'
        info "Configuring authentication"
        mysql_execute "mysql" <<EOF
DELETE FROM mysql.user WHERE user<>'mysql.sys';
EOF
        # slaves do not need to configure users
        if [[ -z "$DB_REPLICATION_MODE" ]] || [[ "$DB_REPLICATION_MODE" = "master" ]]; then
            if [[ "$DB_REPLICATION_MODE" = "master" ]]; then
                debug "Starting replication"
                echo "RESET MASTER;" | debug_execute "$DB_BIN_DIR/mysql" --defaults-file="$DB_CONF_DIR/my.cnf" -N -u root
            fi
            mysql_ensure_root_user_exists "$DB_ROOT_USER" "$DB_ROOT_PASSWORD" "$DB_AUTHENTICATION_PLUGIN"
            mysql_ensure_user_not_exists "" # ensure unknown user does not exist
            if [[ -n "$DB_USER" ]]; then
                local -a args=("$DB_USER")
                [[ -n "$DB_PASSWORD" ]] && args+=("-p" "$DB_PASSWORD")
                [[ -n "$DB_AUTHENTICATION_PLUGIN" ]] && args+=("--auth-plugin" "$DB_AUTHENTICATION_PLUGIN")
                mysql_ensure_optional_user_exists "${args[@]}"
            fi
            if [[ -n "$DB_DATABASE" ]]; then
                local createdb_args=("$DB_DATABASE")
                [[ -n "$DB_USER" ]] && createdb_args+=("-u" "$DB_USER")
                [[ -n "$DB_CHARACTER_SET" ]] && createdb_args+=("--character-set" "$DB_CHARACTER_SET")
                [[ -n "$DB_COLLATE" ]] && createdb_args+=("--collate" "$DB_COLLATE")
                mysql_ensure_optional_database_exists "${createdb_args[@]}"
            fi
            [[ -n "$DB_ROOT_PASSWORD" ]] && export ROOT_AUTH_ENABLED="yes"
        fi
        [[ -n "$DB_REPLICATION_MODE" ]] && mysql_configure_replication
        # we run mysql_upgrade in order to recreate necessary database users and flush privileges
        mysql_upgrade
    fi

    # After configuration, open mysql
    if ! is_boolean_yes "$user_provided_conf";then
        replace_in_file "$DB_CONF_DIR/my.cnf" "bind\-address=.*" "bind-address=0.0.0.0" false
    fi
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
mysql_custom_init_scripts() {
    if [[ -n $(find /docker-entrypoint-initdb.d/ -type f -regex ".*\.\(sh\|sql\|sql.gz\)") ]] && [[ ! -f "$DB_VOLUME_DIR/.user_scripts_initialized" ]] ; then
        info "Loading user's custom files from /docker-entrypoint-initdb.d";
        for f in /docker-entrypoint-initdb.d/*; do
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
                *.sql)
                    [[ "$DB_REPLICATION_MODE" = "slave" ]] && warn "Custom SQL initdb is not supported on slave nodes, ignoring $f" && continue
                    wait_for_mysql_access
                    if ! mysql_execute "$DB_DATABASE" "$DB_ROOT_USER" "$(get_env_var_value ROOT_PASSWORD)" < "$f"; then
                        error "Failed executing $f"
                        return 1
                    fi
                    ;;
                *.sql.gz)
                    [[ "$DB_REPLICATION_MODE" = "slave" ]] && warn "Custom SQL initdb is not supported on slave nodes, ignoring $f" && continue
                    wait_for_mysql_access
                    if ! gunzip -c "$f" | mysql_execute "$DB_DATABASE" "$DB_ROOT_USER" "$(get_env_var_value ROOT_PASSWORD)"; then
                        error "Failed executing $f"
                        return 1
                    fi
                    ;;
                *)
                    warn "Skipping $f, supported formats are: .sh .sql .sql.gz"
                    ;;
            esac
        done
        touch "$DB_VOLUME_DIR"/.user_scripts_initialized
    fi
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
    local pattern='libjemalloc.so.[0-9]'
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
# Gets an environment variable value based on the suffix
# Arguments:
#   $1 - environment variable suffix
# Returns:
#   environment variable value
#########################
get_env_var_value() {
    local envVar
    envVar="$(get_env_var "$1")"
    echo "${!envVar:-}"
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
    read -r -a opts <<<"${@:4}"

    # Process mysql CLI arguments
    local args=()
    if [[ -f "$DB_CONF_DIR/my.cnf" ]]; then
        args+=("--defaults-file=$DB_CONF_DIR/my.cnf")
    fi
    args+=("-N" "-u" "$user" "$db")
    [[ -n "$pass" ]] && args+=("-p$pass")
    [[ -n "${opts[*]:-}" ]] && args+=("${opts[@]:-}")

    # Obtain the command specified via stdin
    local mysql_cmd=""
    if read -r -t 0; then
        mysql_cmd="$(</dev/stdin)"
    fi
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
#   $1 - Database where to run the queries
#   $2 - Remote MySQL/MariaDB service hostname
#   $3 - Remote MySQL/MariaDB service port
#   $4 - User to run queries
#   $5 - Password
# Returns:
#   None
mysql_remote_execute() {
    local -r db="${1:-}"
    local -r hostname="${2:?hostname is required}"
    local -r port="${3:?port is required}"
    local -r user="${4:?user is required}"
    local -r pass="${5:-}"

    local args=("-N" "-h" "$hostname" "-P" "$port" "-u" "$user" "--connect-timeout=5" "$db")
    [[ -n "$pass" ]] && args+=("-p$pass")
    debug_execute "$DB_BIN_DIR/mysql" "${args[@]}"
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
    pid="$(get_pid_from_file "$DB_TMP_DIR/mysqld.pid")"

    if [[ -z "$pid" ]]; then
        false
    else
        is_service_running "$pid"
    fi
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
    local flags=("--defaults-file=${DB_BASE_DIR}/conf/my.cnf" "--basedir=${DB_BASE_DIR}" "--datadir=${DB_DATA_DIR}" "--socket=$DB_TMP_DIR/mysql.sock" "--port=$DB_PORT_NUMBER")
    [[ -z "${DB_EXTRA_FLAGS:-}" ]] || flags+=("${DB_EXTRA_FLAGS[@]}")
    am_i_root && flags+=("--user=$DB_DAEMON_USER")
    # the slave should only start in run.sh, elseways user credentials would be needed for any connection
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
    while ! is_mysql_running; do
        sleep 1
    done
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
    local args=("mysql" "root")
    is_boolean_yes "${ROOT_AUTH_ENABLED:-false}" && args+=("$(get_master_env_var_value ROOT_PASSWORD)")
    while ! echo "select 1" | mysql_execute "${args[@]}"; do
        sleep 1
    done
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
    stop_service_using_pid "$DB_TMP_DIR/mysqld.pid"
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
    local args=("--defaults-file=${DB_CONF_DIR}/my.cnf" "--basedir=${DB_BASE_DIR}" "--datadir=${DB_DATA_DIR}")
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
    local args=("--defaults-file=${DB_CONF_DIR}/my.cnf" "-u" "$DB_ROOT_USER" "--force")
    local major_version
    major_version="$(get_sematic_version "$(mysql_get_version)" 1)"
    info "Running mysql_upgrade"
    if [[ "$DB_FLAVOR" = "mysql" ]] && [[ "$major_version" -ge "8" ]]; then
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
    local opts=()
    if [[ -n "$db_host" ]]; then
        opts+=("-h${db_host}")
    fi
    if [[ -n "$ssl_ca" ]]; then
        opts+=("--ssl-ca" "$ssl_ca")
    fi
    mysql_execute "mysql" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD" "${opts[@]:-}" <<EOF
create $([[ "$DB_FLAVOR" = "mariadb" ]] && echo "or replace") user '$user'@'%' $auth_string;
EOF
    debug "Removing all other hosts for the user"
    hosts=$(mysql_execute_print_output "mysql" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD" "${opts[@]:-}" <<EOF
select Host from user where User='$user' and Host!='%';
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
# Returns:
#   None
#########################
mysql_ensure_database_exists() {
    local -r database="${1:?database is required}"
    local -r character_set="${2:-}"
    local -r collate="${3:-}"
    local extra_args=()

    [[ -n "$character_set" ]] && extra_args=("character set = '${character_set}'")
    [[ -n "$collate" ]] && extra_args=("collate = '${collate}'")

    debug "Creating database $database"
    mysql_execute "mysql" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD" <<EOF
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
# Returns:
#   None
#########################
mysql_ensure_user_has_database_privileges() {
    local -r user="${1:?user is required}"
    local -r database="${2:?db is required}"

    debug "Providing privileges to username $user on database $database"
    mysql_execute "mysql" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD" <<EOF
grant all on \`$database\`.* to '$user'@'%';
EOF
}

########################
# Optionally create the given database user
# Flags:
#   -p|--password - database password
#   --auth-plugin - authentication plugin
#   --use-ldap - authenticate user via LDAP
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
            *)
                echo "Invalid command line flag $1" >&2
                return 1
                ;;
        esac
        shift
    done

    if is_boolean_yes "$use_ldap"; then
        mysql_ensure_user_exists "$user" "--use-ldap"
    elif [[ -n "$password" ]]; then
        local -a flags=("-p" "$password")
        [[ -n "$auth_plugin" ]] && flags=("${flags[@]}" "--auth-plugin" "$auth_plugin")
        mysql_ensure_user_exists "$user" "${flags[@]:-}"
    else
        mysql_ensure_user_exists "$user"
    fi
}

########################
# Optionally create the given database, and then optionally give a user
# full privileges on the database.
# Flags:
#   -u|--user - database user
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
            *)
                echo "Invalid command line flag $1" >&2
                return 1
                ;;
        esac
        shift
    done

    mysql_ensure_database_exists "$database" "$character_set" "$collate"

    if [[ -n "$user" ]]; then
        mysql_ensure_user_has_database_privileges "$user" "$database"
    fi
}

########################
# Flag MySQL has fully initialized.
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mysql_flag_initialized() {
    touch "$DB_VOLUME_DIR"/.mysql_initialized
}
