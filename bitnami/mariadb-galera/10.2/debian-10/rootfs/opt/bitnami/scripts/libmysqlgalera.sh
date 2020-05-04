#!/bin/bash
#
# Bitnami MySQL Galera library

# shellcheck disable=SC1091

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
    local dbExtraFlags
    read -r -a dbExtraFlags <<< "$(get_env_var_value EXTRA_FLAGS)"
    dbExtraFlags+=("--wsrep_cluster_name=$DB_GALERA_CLUSTER_NAME" "--wsrep_node_name=$(hostname)" "--wsrep_node_address=$(get_node_address)" "--wsrep_cluster_address=$DB_GALERA_CLUSTER_ADDRESS" "--wsrep_sst_method=mariabackup" "--wsrep_sst_auth=$DB_GALERA_MARIABACKUP_USER:$DB_GALERA_MARIABACKUP_PASSWORD")
    echo "${dbExtraFlags[@]}"
}

get_galera_cluster_bootstrap_value() {
    local clusterBootstrap
    clusterBootstrap="$(get_env_var_value GALERA_CLUSTER_BOOTSTRAP)"
    if ! is_boolean_yes "${clusterBootstrap}"; then
        local clusterAddress
        clusterAddress="$(get_env_var_value GALERA_CLUSTER_ADDRESS)"
        if [[ -z "$clusterAddress" ]]; then
            clusterBootstrap="yes"
        elif [[ -n "$clusterAddress" ]]; then
            local host=${clusterAddress#*://}
            local host=${host%:*}
            if ! resolveip -s "$host" >/dev/null 2>&1; then
                clusterBootstrap="yes"
            fi
        fi
    fi
    echo "${clusterBootstrap}"
}

get_galera_cluster_address_value() {
    local clusterBootstrap
    local clusterAddress
    clusterBootstrap="$(get_galera_cluster_bootstrap_value)"
    if is_boolean_yes "${clusterBootstrap}"; then
        clusterAddress="gcomm://"
    else
        clusterAddress="$(get_env_var_value GALERA_CLUSTER_ADDRESS)"
    fi
    echo "${clusterAddress}"
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
# Paths
export DB_FLAVOR="${DB_FLAVOR:-"mysql"}"
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
export ALLOW_EMPTY_PASSWORD=${ALLOW_EMPTY_PASSWORD:-no}
PORT_NUMBER="$(get_env_var_value PORT_NUMBER)"
export DB_PORT_NUMBER="${PORT_NUMBER:-3306}"
export DB_DATABASE="$(get_env_var_value DATABASE)"
export DB_USER="$(get_env_var_value USER)"
export DB_PASSWORD="$(get_env_var_value PASSWORD)"
ROOT_USER="$(get_env_var_value ROOT_USER)"
export DB_ROOT_USER="${ROOT_USER:-root}"
export DB_ROOT_PASSWORD="$(get_env_var_value ROOT_PASSWORD)"
export DB_GALERA_CLUSTER_BOOTSTRAP="$(get_galera_cluster_bootstrap_value)"
export DB_GALERA_CLUSTER_ADDRESS="$(get_galera_cluster_address_value)"
DB_GALERA_CLUSTER_NAME="$(get_env_var_value GALERA_CLUSTER_NAME)"
export DB_GALERA_CLUSTER_NAME="${DB_GALERA_CLUSTER_NAME:-galera}"
export DB_GALERA_NODE_ADDRESS="$(get_env_var_value GALERA_NODE_ADDRESS)"
export DB_GALERA_MARIABACKUP_USER="$(get_env_var_value GALERA_MARIABACKUP_USER)"
export DB_GALERA_MARIABACKUP_USER="${DB_GALERA_MARIABACKUP_USER:-mariabackup}"
export DB_GALERA_MARIABACKUP_PASSWORD="$(get_env_var_value GALERA_MARIABACKUP_PASSWORD)"
read -r -a DB_EXTRA_FLAGS <<< "$(mysql_extra_flags)"
export DB_EXTRA_FLAGS
DB_INIT_SLEEP_TIME="$(get_env_var_value INIT_SLEEP_TIME)"
export DB_INIT_SLEEP_TIME="${DB_INIT_SLEEP_TIME:-}"
ENABLE_LDAP="$(get_env_var_value ENABLE_LDAP)"
export DB_ENABLE_LDAP="${ENABLE_LDAP:-no}"
ENABLE_TLS="$(get_env_var_value ENABLE_TLS)"
export DB_ENABLE_TLS="${ENABLE_TLS:-no}"
export DB_TLS_CERT_FILE="$(get_env_var_value TLS_CERT_FILE)"
export DB_TLS_KEY_FILE="$(get_env_var_value TLS_KEY_FILE)"
export DB_TLS_CA_FILE="$(get_env_var_value TLS_CA_FILE)"
EOF
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
    info "Validating settings in MYSQL_*/MARIADB_* env vars.."
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

    if is_boolean_yes "$ALLOW_EMPTY_PASSWORD"; then
        empty_password_enabled_warn
    else
        if [[ -n "$DB_GALERA_MARIABACKUP_USER" ]] && [[ -z "$DB_GALERA_MARIABACKUP_PASSWORD" ]]; then
            empty_password_error "$(get_env_var GALERA_MARIABACKUP_PASSWORD)"
        fi

        if is_boolean_yes "$DB_GALERA_CLUSTER_BOOTSTRAP"; then
            if [[ -z "$DB_ROOT_PASSWORD" ]]; then
                empty_password_error "$(get_env_var ROOT_PASSWORD)"
            fi
            if (( ${#DB_ROOT_PASSWORD} > 32 )); then
                print_validation_error "The password can not be longer than 32 characters. Set the environment variable $(get_env_var ROOT_PASSWORD) with a shorter value (currently ${#DB_ROOT_PASSWORD} characters)"
            fi
            if [[ -n "$DB_USER" ]]; then
                if is_boolean_yes "$DB_ENABLE_LDAP" && [[ -n "$DB_PASSWORD" ]]; then
                    warn "You enabled LDAP authentication. '$DB_USER' user will be authentication using LDAP, the password set at the environment variable $(get_env_var PASSWORD) will be ignored"
                elif ! is_boolean_yes "$DB_ENABLE_LDAP" && [[ -z "$DB_PASSWORD" ]]; then
                    empty_password_error "$(get_env_var PASSWORD)"
                fi
            fi
        fi
    fi

    if [[ -z "$DB_GALERA_CLUSTER_NAME" ]]; then
        print_validation_error "Galera cluster cannot be created without setting the environment variable $(get_env_var GALERA_CLUSTER_NAME)."
    fi

    if ! is_boolean_yes "$DB_GALERA_CLUSTER_BOOTSTRAP" && [[ -z "$DB_GALERA_CLUSTER_ADDRESS" ]]; then
        print_validation_error "Galera cluster cannot be created without setting the environment variable $(get_env_var GALERA_CLUSTER_ADDRESS). If you are bootstrapping a new Galera cluster, set the environment variable MARIADB_GALERA_CLUSTER_BOOTSTRAP=yes."
    fi

    if [[ "${DB_ROOT_PASSWORD:-}" = *\\* ]]; then
        backslash_password_error "$(get_env_var ROOT_PASSWORD)"
    fi
    if [[ "${DB_PASSWORD:-}" = *\\* ]]; then
        backslash_password_error "$(get_env_var PASSWORD)"
    fi

    if is_boolean_yes "$DB_ENABLE_LDAP" && ( [[ -z "${LDAP_URI}" ]] || [[ -z "${LDAP_BASE}" ]] || [[ -z "${LDAP_BIND_DN}" ]] || [[ -z "${LDAP_BIND_PASSWORD}" ]] ); then
        print_validation_error "The LDAP configuration is required when LDAP authentication is enabled. Set the environment variables LDAP_URI, LDAP_BASE, LDAP_BIND_DN and LDAP_BIND_PASSWORD with the LDAP configuration."
    fi

    if is_boolean_yes "$DB_ENABLE_TLS"; then
        if ( [[ -z "${DB_TLS_CERT_FILE}" ]] || [[ -z "${DB_TLS_KEY_FILE}" ]] || [[ -z "${DB_TLS_CA_FILE}" ]]); then
            print_validation_error "The TLS cert file, key and CA are required when TLS is enabled. Set the environment variables TLS_CERT_FILE, TLS_KEY_FILE and TLS_CA_FILE with the path to each file."
        fi
        if ( [[ ! -f "${DB_TLS_CERT_FILE}" ]] ); then
            print_validation_error "The TLS_CERT file ${DB_TLS_CERT_FILE} must exist."
        fi
        if ( [[ ! -f "${DB_TLS_KEY_FILE}" ]] ); then
            print_validation_error "The TLS_KEY file ${DB_TLS_KEY_FILE} must exist."
        fi
        if ( [[ ! -f "${DB_TLS_CA_FILE}" ]] ); then
            print_validation_error "The TLS_CA file ${DB_TLS_CA_FILE} must exist."
        fi
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
    debug "Creating main configuration file..."
    cat > "${DB_CONF_DIR}/my.cnf" <<EOF
[mysqladmin]
user=$DB_USER

[mysqld]
skip-host-cache
skip-name-resolve
explicit_defaults_for_timestamp
basedir=$DB_BASE_DIR
datadir=$DB_DATA_DIR
port=$DB_PORT_NUMBER
tmpdir=$DB_TMP_DIR
socket=$DB_TMP_DIR/mysql.sock
pid-file=$DB_TMP_DIR/mysqld.pid
max_allowed_packet=16M
bind-address=0.0.0.0
log-error=$DB_LOG_DIR/mysqld.log
character-set-server=UTF8
collation-server=utf8_general_ci
plugin_dir=$DB_BASE_DIR/plugin
binlog-format=row
log-bin=mysql-bin

[client]
port=$DB_PORT_NUMBER
socket=$DB_TMP_DIR/mysql.sock
default-character-set=UTF8
plugin_dir=$DB_BASE_DIR/plugin

[manager]
port=$DB_PORT_NUMBER
socket=$DB_TMP_DIR/mysql.sock
pid-file=$DB_TMP_DIR/mysqld.pid

[galera]
wsrep_on=ON
wsrep_provider=$DB_BASE_DIR/lib/libgalera_smm.so
wsrep_sst_method=mariabackup
wsrep_slave_threads=4
wsrep_cluster_address=gcomm://

[mariadb]
plugin_load_add = auth_pam
EOF

    if is_boolean_yes "$DB_ENABLE_TLS"; then
        cat >> "${DB_CONF_DIR}/my.cnf" <<EOF
ssl_cert=$DB_TLS_CERT_FILE
ssl_key=$DB_TLS_KEY_FILE
ssl_ca=$DB_TLS_CA_FILE
wsrep_provider_options="socket.ssl_cert=$DB_TLS_CERT_FILE;socket.ssl_key=$DB_TLS_KEY_FILE;socket.ssl_ca=$DB_TLS_CA_FILE"
EOF
    fi

    cat >> "${DB_CONF_DIR}/my.cnf" <<EOF

!include $DB_CONF_DIR/bitnami/my_custom.cnf
EOF
}

########################
# Ensure the mariabackup user exists for host 'localhost' and has full access (galera)
# Globals:
#   DB_*
# Arguments:
#   $1 - mariabackup user
#   $2 - mariaback password
# Returns:
#   None
#########################
mysql_ensure_galera_mariabackup_user_exists() {
    local user="${1:?user is required}"
    local password="${2:-}"

    debug "Configure mariabackup user credentials..."
    if [[ "$DB_FLAVOR" = "mariadb" ]]; then
        mysql_execute "mysql" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD" <<EOF
create or replace user '$user'@'localhost' $([ "$password" != "" ] && echo "identified by '$password'");
EOF
    else
        mysql_execute "mysql" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD" <<EOF
create user '$user'@'localhost' $([ "$password" != "" ] && echo "identified with 'mysql_native_password' by '$password'");
EOF
    fi
    mysql_execute "mysql" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD" <<EOF
grant RELOAD,PROCESS,LOCK TABLES,REPLICATION CLIENT on *.* to '$user'@'localhost';
flush privileges;
EOF
}

########################
# Ensure the replication client exists for host '%' and has PROCESS access (galera)
# Globals:
#   DB_*
# Arguments:
#   $1 - user
#   $2 - password
# Returns:
#   None
#########################
mysql_ensure_replication_user_exists() {
    local user="${1:?user is required}"
    local password="${2:-}"

    debug "Configure replication user..."

    if [[ "$DB_FLAVOR" = "mariadb" ]]; then
        mysql_execute "mysql" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD" <<EOF
grant REPLICATION CLIENT ON *.* to '$user'@'%' identified by '$password';
grant PROCESS ON *.* to '$user'@'localhost' identified by '$password';
flush privileges;
EOF
    else
        mysql_execute "mysql" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD" <<EOF
grant REPLICATION CLIENT ON *.* to '$user'@'%' identified with 'mysql_native_password' by '$password';
grant PROCESS ON *.* to '$user'@'localhost' identified with 'mysql_native_password' by '$password';
flush privileges;
EOF
    fi
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
    info "Initializing $DB_FLAVOR database..."

    # This fixes an issue where the trap would kill the entrypoint.sh, if a PID was left over from a previous run
    # Exec replaces the process without creating a new one, and when the container is restarted it may have the same PID
    rm -f "$DB_TMP_DIR/mysqld.pid"

    # User injected custom configuration
    if [[ -f "$DB_CONF_DIR/my_custom.cnf" ]]; then
        debug "Custom configuration detected. Injecting..."
        cat "$DB_CONF_DIR/my_custom.cnf" > "$DB_CONF_DIR/bitnami/my_custom.cnf"
    fi

    # Persisted configuration files from old versions
    ! is_dir_empty "$DB_VOLUME_DIR" && [[ -d "$DB_VOLUME_DIR/conf" ]] && migrate_old_configuration

    debug "Ensuring expected directories/files exist..."
    for dir in "$DB_DATA_DIR" "$DB_TMP_DIR" "$DB_LOG_DIR"; do
        ensure_dir_exists "$dir"
        am_i_root && chown "$DB_DAEMON_USER:$DB_DAEMON_GROUP" "$dir"
    done
    [[ ! -e "$DB_CONF_DIR/my.cnf" ]] && mysql_create_config

    if [[ -e "$DB_DATA_DIR/mysql" ]]; then
        info "Persisted data detected. Restoring..."
        return
    else
        # initialization should not be performed on non-primary nodes of a galera cluster
        if is_boolean_yes "$DB_GALERA_CLUSTER_BOOTSTRAP"; then
            debug "Cleaning data directory to ensure successfully initialization..."
            rm -rf "${DB_DATA_DIR:?}"/*
            mysql_install_db
            mysql_start_bg
            debug "Deleting all users to avoid issues with galera configuration..."
            mysql_execute "mysql" <<EOF
DELETE FROM mysql.user WHERE user<>'mysql.sys';
EOF

            mysql_ensure_root_user_exists "$DB_ROOT_USER" "$DB_ROOT_PASSWORD"
            mysql_ensure_user_not_exists "" # ensure unknown user does not exist
            if [[ -n "$DB_DATABASE" ]]; then
                if [[ -n "$DB_USER" ]]; then
                    local -a flags=("-u" "$DB_USER")
                    if is_boolean_yes "$DB_ENABLE_LDAP"; then
                        flags=("${flags[@]}" "--use-ldap")
                    elif [[ -n "$DB_PASSWORD" ]]; then
                        flags=("${flags[@]}" "-p" "$DB_PASSWORD")
                    fi
                    mysql_ensure_optional_database_exists "$DB_DATABASE" "${flags[@]:-}"
                fi
                mysql_ensure_optional_database_exists "$DB_DATABASE"
            fi
            mysql_ensure_galera_mariabackup_user_exists "$DB_GALERA_MARIABACKUP_USER" "$DB_GALERA_MARIABACKUP_PASSWORD"
            mysql_ensure_replication_user_exists "monitor" "monitor"

            [[ -n "$(get_master_env_var_value ROOT_PASSWORD)" ]] && export ROOT_AUTH_ENABLED="yes"
            if [[ "$DB_FLAVOR" = "mysql" ]]; then
                mysql_upgrade
            else
                local args=(mysql)
                args+=("$DB_ROOT_USER" "$DB_ROOT_PASSWORD")
                debug "Flushing privileges..."
                mysql_execute "${args[@]}" <<EOF
flush privileges;
EOF
            fi
        fi
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
        info "Loading user's custom files from /docker-entrypoint-initdb.d ...";
        for f in /docker-entrypoint-initdb.d/*; do
            case "$f" in
                *.sh)
                    if [[ -x "$f" ]]; then
                        debug "Executing $f"; "$f"
                    else
                        debug "Sourcing $f"; . "$f"
                    fi
                    ;;
                *.sql)
                    # sql initialization should not be executed on non-primary nodes of a galera cluster
                    if is_boolean_yes "$DB_GALERA_CLUSTER_BOOTSTRAP"; then
                        debug "Executing $f"; mysql_execute "$DB_DATABASE" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD" < "$f"
                    fi
                    ;;
                *.sql.gz)
                    # sql initialization should not be executed on non-primary nodes of a galera cluster
                    if is_boolean_yes "$DB_GALERA_CLUSTER_BOOTSTRAP"; then
                        debug "Executing $f"; gunzip -c "$f" | mysql_execute "$DB_DATABASE" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD"
                    fi
                    ;;
                *)
                    debug "Ignoring $f"
                    ;;
            esac
        done
        touch "$DB_VOLUME_DIR"/.user_scripts_initialized
    fi
}

########################
# Check for user override of wsrep_node_address.
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   String with node address
#########################
get_node_address() {
    if [[ -n "$DB_GALERA_NODE_ADDRESS" ]]; then
        echo "$DB_GALERA_NODE_ADDRESS"
    else
        hostname -i
    fi
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
    read -r -a opts <<<"${4:-}"

    # Process mysql CLI arguments
    local args=("--defaults-file=$DB_CONF_DIR/my.cnf" "-N" "-u" "$user" "$db")
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
    mysql_execute "mysql" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD" <<EOF
create $([[ "$DB_FLAVOR" = "mariadb" ]] && echo "or replace") user '$user'@'%' $auth_string;
EOF
    debug "Removing all other hosts for the user"
    hosts=$(mysql_execute_print_output "mysql" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD" <<EOF
select Host from user where User='$user' and Host!='%';
EOF
)
    for host in $hosts; do
        mysql_execute "mysql" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD" <<EOF
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

    debug "Creating database $database"
    mysql_execute "mysql" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD" <<EOF
create database if not exists \`$database\`;
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
# Optionally create the given database, and then optionally create a user with
# full privileges on the database.
# Flags:
#   -p|--password - database password
#   -u|--user - database user
#   --auth-plugin - authentication plugin
#   --use-ldap - authenticate user via LDAP
# Arguments:
#   $1 - database name
# Returns:
#   None
#########################
mysql_ensure_optional_database_exists() {
    local -r database="${1:?database is missing}"
    local user=""
    local password=""
    local auth_plugin=""
    local use_ldap="no"

    # Validate arguments
    shift 1
    while [ "$#" -gt 0 ]; do
        case "$1" in
            -p|--password)
                shift
                password="${1:?missing database password}"
                ;;
            -u|--user)
                shift
                user="${1:?missing database user}"
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

    mysql_ensure_database_exists "$database"

    if [[ -n "$user" ]]; then
        if is_boolean_yes "$use_ldap"; then
            mysql_ensure_user_exists "$user" "--use-ldap"
        elif [[ -n "$password" ]]; then
            local -a flags=("-p" "$password")
            [[ -n "$auth_plugin" ]] && flags=("${flags[@]}" "--auth-plugin" "$auth_plugin")
            mysql_ensure_user_exists "$user" "${flags[@]:-}"
        else
            mysql_ensure_user_exists "$user"
        fi
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
