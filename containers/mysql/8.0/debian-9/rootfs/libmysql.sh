#!/bin/bash
#
# Bitnami MySQL library

# shellcheck disable=SC1090
# shellcheck disable=SC1091

# Load Generic Libraries
. /libfile.sh
. /liblog.sh
. /libservice.sh
. /libvalidations.sh

# Functions

########################
# Gets an env. variable name based on the suffix
# Globals:
#   DB_FLAVOR
# Arguments:
#   $1 - env. variable suffix
# Returns:
#   env. variable name
#########################
get_env_var() {
    local id="${1:?id is required}"
    echo "${DB_FLAVOR^^}_${id}"
}

########################
# Gets an env. variable value based on the suffix
# Arguments:
#   $1 - env. variable suffix
# Returns:
#   env. variable value
#########################
get_env_var_value() {
    local envVar
    envVar="$(get_env_var "$1")"
    echo "${!envVar:-}"
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
# Returns:
#   None
mysql_execute() {
    local db="${1:-}"
    local user="${2:-root}"
    local pass="${3:-}"

    local args=("--defaults-file=$DB_CONFDIR/my.cnf" "-N" "-u" "$user" "$db")
    [[ -n "$pass" ]] && args+=("-p$pass")
    if [[ "${BITNAMI_DEBUG:-false}" = true ]]; then
        "$DB_BINDIR/mysql" "${args[@]}"
    else
        "$DB_BINDIR/mysql" "${args[@]}" >/dev/null 2>&1
    fi
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
    local db="${1:-}"
    local hostname="${2:?hostname is required}"
    local port="${3:?port is required}"
    local user="${4:?user is required}"
    local pass="${5:-}"

    local args=("-N" "-h" "$hostname" "-P" "$port" "-u" "$user" "--connect-timeout=5" "$db")
    [[ -n "$pass" ]] && args+=("-p$pass")
    if [[ "${BITNAMI_DEBUG:-false}" = true ]]; then
        "$DB_BINDIR/mysql" "${args[@]}"
    else
        "$DB_BINDIR/mysql" "${args[@]}" >/dev/null 2>&1
    fi
}

########################
# Checks if MySQL/MariaDB is running
# Globals:
#   DB_TMPDIR
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_mysql_running() {
    local pid
    pid="$(get_pid_from_file "$DB_TMPDIR/mysqld.pid")"

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
    local flags=("--defaults-file=${DB_BASEDIR}/conf/my.cnf" "--basedir=${DB_BASEDIR}" "--datadir=${DB_DATADIR}" "--socket=$DB_TMPDIR/mysql.sock" "--port=$DB_PORT_NUMBER")
    [[ -z "${DB_EXTRA_FLAGS:-}" ]] || flags=("${flags[@]}" "${DB_EXTRA_FLAGS[@]}")

    debug "Starting $DB_FLAVOR in background..."
    is_mysql_running && return

    if [[ "${BITNAMI_DEBUG:-false}" = true ]]; then
        "${DB_SBINDIR}/mysqld" "${flags[@]}" &
    else
        "${DB_SBINDIR}/mysqld" "${flags[@]}" >/dev/null 2>&1 &
    fi

    # wait until the server is up and answering queries.
    local args=(mysql root)
    is_boolean_yes "${ROOT_AUTH_ENABLED:-false}" && args+=("$DB_ROOT_PASSWORD")
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
    info "Stopping $DB_FLAVOR..."
    stop_service_using_pid "$DB_TMPDIR/mysqld.pid"
}

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
    randNumber=$(head /dev/urandom | tr -dc 0-9 | head -c 3 ; echo '')
    read -r -a dbExtraFlags <<< "$(get_env_var_value EXTRA_FLAGS)"

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

    echo "${dbExtraFlags[@]}"
}

########################
# Loads global variables used on MySQL/MariaDB configuration.
# Globals:
#   DB_FLAVOR
#   DB_SBINDIR
#   MYSQL_*/MARIADB_*
# Arguments:
#   None
# Returns:
#   Series of exports to be used as 'eval' arguments
#########################
mysql_env() {
    cat <<"EOF"
export DB_FLAVOR="${DB_FLAVOR:-"mysql"}"
export DB_VOLUMEDIR="/bitnami/$DB_FLAVOR"
export DB_DATADIR="$DB_VOLUMEDIR/data"
export DB_BASEDIR="/opt/bitnami/$DB_FLAVOR"
export DB_CONFDIR="$DB_BASEDIR/conf"
export DB_LOGDIR="$DB_BASEDIR/logs"
export DB_TMPDIR="$DB_BASEDIR/tmp"
export DB_BINDIR="$DB_BASEDIR/bin"
export DB_SBINDIR="${DB_SBINDIR:-$DB_BASEDIR/bin}"
export PATH="$DB_BINDIR:$PATH"
export DB_DAEMON_USER="mysql"
export DB_DAEMON_GROUP="mysql"
export DB_MASTER_HOST="$(get_env_var_value MASTER_HOST)"
MASTER_PORT_NUMBER="$(get_env_var_value MASTER_PORT_NUMBER)"
export DB_MASTER_PORT_NUMBER="${MASTER_PORT_NUMBER:-3306}"
MASTER_ROOT_USER="$(get_env_var_value MASTER_ROOT_USER)"
export DB_MASTER_ROOT_USER="${MASTER_ROOT_USER:-root}"
export DB_MASTER_ROOT_PASSWORD="$(get_env_var_value MASTER_ROOT_PASSWORD)"
PORT_NUMBER="$(get_env_var_value PORT_NUMBER)"
export DB_PORT_NUMBER="${PORT_NUMBER:-3306}"
export DB_REPLICATION_MODE="$(get_env_var_value REPLICATION_MODE)"
export DB_REPLICATION_USER="$(get_env_var_value REPLICATION_USER)"
export DB_REPLICATION_PASSWORD="$(get_env_var_value REPLICATION_PASSWORD)"
export DB_DATABASE="$(get_env_var_value DATABASE)"
export DB_USER="$(get_env_var_value USER)"
export DB_PASSWORD="$(get_env_var_value PASSWORD)"
ROOT_USER="$(get_env_var_value ROOT_USER)"
export DB_ROOT_USER="${ROOT_USER:-root}"
export DB_ROOT_PASSWORD="$(get_env_var_value ROOT_PASSWORD)"
read -r -a DB_EXTRA_FLAGS <<< "$(mysql_extra_flags)"
export DB_EXTRA_FLAGS
EOF
}

########################
# Validate settings in MYSQL_*/MARIADB_* env. variables
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mysql_validate() {
    info "Validating settings in MYSQL_*/MARIADB_* env vars.."

    # Auxiliary functions
    empty_password_enabled_warn() {
        warn "You set the environment variable ALLOW_EMPTY_PASSWORD=${ALLOW_EMPTY_PASSWORD}. For safety reasons, do not use this flag in a production environment."
    }
    empty_password_error() {
        error "The $1 environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow the container to be started with blank passwords. This is recommended only for development."
        exit 1
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
                    error "The password can not be longer than 32 characters. Set the environment variable $1 with a shorter value"
                    exit 1
                fi
                if [[ -n "$DB_USER" ]] && [[ -z "$DB_PASSWORD" ]]; then
                    empty_password_error "$(get_env_var PASSWORD)"
                fi
            fi
        elif [[ "$DB_REPLICATION_MODE" = "slave" ]]; then
            if [[ -z "$DB_MASTER_HOST" ]]; then
                error "Slave replication mode chosen without setting the environment variable $(get_env_var MASTER_HOST). Use it to indicate where the Master node is running"
                exit 1
            fi
        else
            error "Invalid replication mode. Available options are 'master/slave'"
            exit 1
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
    cat > "$DB_CONFDIR/my.cnf" <<EOF
[mysqladmin]
user=$DB_USER

[mysqld]
skip-name-resolve
explicit_defaults_for_timestamp
basedir=$DB_BASEDIR
port=$DB_PORT_NUMBER
tmpdir=$DB_TMPDIR
socket=$DB_TMPDIR/mysql.sock
pid-file=$DB_TMPDIR/mysqld.pid
max_allowed_packet=16M
bind-address=0.0.0.0
log-error=$DB_LOGDIR/mysqld.log
character-set-server=UTF8
collation-server=utf8_general_ci
plugin_dir=$DB_BASEDIR/plugin

[client]
port=$DB_PORT_NUMBER
socket=$DB_TMPDIR/mysql.sock
default-character-set=UTF8

[manager]
port=$DB_PORT_NUMBER
socket=$DB_TMPDIR/mysql.sock
pid-file=$DB_TMPDIR/mysqld.pid

!include $DB_CONFDIR/bitnami/my_custom.cnf
EOF
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
    local command="${DB_BINDIR}/mysql_install_db"
    local args=("--defaults-file=${DB_CONFDIR}/my.cnf" "--basedir=${DB_BASEDIR}" "--datadir=${DB_DATADIR}")
    debug "Installing database..."
    if [[ "$DB_FLAVOR" = "mysql" ]]; then
        command="${DB_BINDIR}/mysqld"
        args+=("--initialize-insecure")
    fi
    if [[ "${BITNAMI_DEBUG:-false}" = true ]]; then
        $command "${args[@]}"
    else
        $command "${args[@]}" >/dev/null 2>&1
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
    local old_custom_conf_file="$DB_VOLUMEDIR/conf/my_custom.cnf"
    local custom_conf_file="$DB_CONFDIR/bitnami/my_custom.cnf"
    debug "Persisted configuration detected. Migrating any existing 'my_custom.cnf' file to new location..."
    warn "Custom configuration files won't be persisted any longer!"
    if [[ -f "$old_custom_conf_file" ]]; then
        info "Adding old custom configuration to user configuration"
        echo "" >> "$custom_conf_file"
        cat "$old_custom_conf_file" >> "$custom_conf_file"
    fi
    if am_i_root; then
        [[ -e "$DB_VOLUMEDIR/.initialized" ]] && rm "$DB_VOLUMEDIR/.initialized"
        rm -rf "$DB_VOLUMEDIR/conf"
    else
        warn "Old custom configuration migrated, please manually remove the 'conf' directory from the volume use to persist data"
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
mysql_configure_replication() {
    info "Configuration replication mode..."
    if [[ "$DB_REPLICATION_MODE" = "slave" ]]; then
        debug "Checking if replication master is ready to accept connection ..."
        while ! echo "select 1" | mysql_remote_execute "mysql" "$DB_MASTER_HOST" "$DB_MASTER_PORT_NUMBER" "$DB_MASTER_ROOT_USER" "$DB_MASTER_ROOT_PASSWORD"; do
            sleep 1
        done
        debug "Replication master ready!"
        debug "Setting the master configuration..."
        mysql_execute "mysql" <<EOF
CHANGE MASTER TO MASTER_HOST='$DB_MASTER_HOST',
MASTER_PORT=$DB_MASTER_PORT_NUMBER,
MASTER_USER='$DB_REPLICATION_USER',
MASTER_PASSWORD='$DB_REPLICATION_PASSWORD',
MASTER_CONNECT_RETRY=10;
EOF
    elif [[ "$DB_REPLICATION_MODE" = "master" ]]; then
        if [[ -n "$DB_REPLICATION_USER" ]]; then
            mysql_ensure_replication_user_exists "$DB_REPLICATION_USER" "$DB_REPLICATION_PASSWORD"
        fi
    fi
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
    local args=("--defaults-file=${DB_CONFDIR}/my.cnf" "-u" "$DB_ROOT_USER")
    debug "Running mysql_upgrade..."
    if is_boolean_yes "${ROOT_AUTH_ENABLED:-false}"; then
        args+=("-p$DB_ROOT_PASSWORD")
    fi
    if [[ "${BITNAMI_DEBUG:-false}" = true ]]; then
        "${DB_BINDIR}/mysql_upgrade" "${args[@]}"
    else
        "${DB_BINDIR}/mysql_upgrade" "${args[@]}" >/dev/null 2>&1
    fi
}

########################
# Ensure a db user exists with the given password for the '%' host
# Globals:
#   DB_*
# Arguments:
#   $1 - db user
#   $2 - password
# Returns:
#   None
#########################
mysql_ensure_user_exists() {
    local user="${1:?user is required}"
    local password="${2:-}"
    local hosts

    debug "creating db user \'$user\'..."
    mysql_execute "mysql" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD" <<EOF
create $([[ "$DB_FLAVOR" = "mariadb" ]] && echo "or replace") user '$user'@'%' $([[ "$password" != "" ]] && echo "identified by '$password'");
EOF
    debug "Removing all other hosts for the user..."
    hosts=$(mysql_execute "mysql" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD" <<EOF
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
    local user="${1}"
    local hosts

    if [[ -z "$user" ]]; then
        debug "removing the unknown user"
    else
        debug "removing user $user"
    fi
    hosts=$(mysql_execute "mysql" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD" <<EOF
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
    local user="${1:?user is required}"
    local password="${2:-}"

    debug "Configure replication user credentials..."
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
# Ensure the root user exists for host '%' and has full access
# Globals:
#   DB_*
# Arguments:
#   $1 - root user
#   $2 - root password
# Returns:
#   None
#########################
mysql_ensure_root_user_exists() {
    local user="${1:?user is required}"
    local password="${2:-}"

    debug "Configuring root user credentials..."
    [[ -n "$password" ]] && export ROOT_AUTH_ENABLED="yes"
    if [ "$DB_FLAVOR" == "mariadb" ]; then
        mysql_execute "mysql" "root" <<EOF
-- create root@localhost user for local admin access
-- create user 'root'@'localhost' $([ "$password" != "" ] && echo "identified by '$password'");
-- grant all on *.* to 'root'@'localhost' with grant option;
-- create admin user for remote access
create user '$user'@'%' $([ "$password" != "" ] && echo "identified by '$password'");
grant all on *.* to '$user'@'%' with grant option;
flush privileges;
EOF
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
    local database="${1:?database is required}"

    debug "Creating database $database..."
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
    local user="${1:?user is required}"
    local database="${2:?db is required}"

    debug "Providing privileges to username $user on database $database..."
    mysql_execute "mysql" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD" <<EOF
grant all on \`$database\`.* to '$user'@'%';
EOF
}

########################
# Optionally create the given database, and then optionally create a user with
# full privileges on the database.
# Globals:
#   DB_*
# Arguments:
#   $1 - database name
#   $2 - database user
#   $3 - database password
# Returns:
#   None
#########################
mysql_ensure_optional_database_exists() {
    local database="${1:-}"
    local user="${2:-}"
    local password="${3:-}"

    if [[ "$database" != "" ]]; then
        mysql_ensure_database_exists "$database"
        if [[ "$user" != "" ]]; then
            mysql_ensure_user_exists "$user" "$password"
            mysql_ensure_user_has_database_privileges "$user" "$database"
        fi
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

    # User injected custom configuration
    if [[ -f "$DB_CONFDIR/my_custom.cnf" ]]; then
        debug "Custom configuration detected. Injecting..."
        cat "$DB_CONFDIR/my_custom.cnf" > "$DB_CONFDIR/bitnami/my_custom.cnf"
    fi

    # Persisted configuration files from old versions
    ! is_dir_empty "$DB_VOLUMEDIR" && [[ -d "$DB_VOLUMEDIR/conf" ]] && migrate_old_configuration

    debug "Ensuring expected directories/files exist..."
    for dir in "$DB_DATADIR" "$DB_TMPDIR" "$DB_LOGDIR"; do
        ensure_dir_exists "$dir"
        am_i_root && chown "$DB_DAEMON_USER:$DB_DAEMON_GROUP" "$dir"
    done
    [[ ! -e "$DB_CONFDIR/my.cnf" ]] && mysql_create_config

    if [[ -e "$DB_DATADIR/mysql" ]]; then
        info "Persisted data detected. Restoring..."
        return
    else
        debug "Cleaning data directory to ensure successfully initialization..."
        rm -rf "${DB_DATADIR:?}"/*
        mysql_install_db
        mysql_start_bg
        debug "Deleting all users to avoid issues with master-slave configurations..."
        mysql_execute "mysql" <<EOF
DELETE FROM mysql.user WHERE user<>'mysql.sys';
EOF
        # slaves do not need to configure users
        if [[ -z "$DB_REPLICATION_MODE" ]] || [[ "$DB_REPLICATION_MODE" = "master" ]]; then
            if  [[ "$DB_REPLICATION_MODE" = "master" ]]; then
                debug "Starting replication..."
                if [[ "${BITNAMI_DEBUG:-false}" = true ]]; then
                    echo "RESET MASTER;" | "$DB_BINDIR/mysql" --defaults-file="$DB_CONFDIR/my.cnf" -N -u root
                else
                    echo "RESET MASTER;" | "$DB_BINDIR/mysql" --defaults-file="$DB_CONFDIR/my.cnf" -N -u root >/dev/null 2>&1
                fi
            fi
            mysql_ensure_root_user_exists "$DB_ROOT_USER" "$DB_ROOT_PASSWORD"
            mysql_ensure_user_not_exists "" # ensure unknown user does not exist
            mysql_ensure_optional_database_exists "$DB_DATABASE" "$DB_USER" "$DB_PASSWORD"
        fi
        # configure replication mode
        [[ -n "$DB_REPLICATION_MODE" ]] && mysql_configure_replication
        if [[ "$DB_FLAVOR" = "mysql" ]]; then
            mysql_upgrade
        else
            local args=(mysql)
            if [[ -z "$DB_REPLICATION_MODE" ]] || [[ "$DB_REPLICATION_MODE" = "master" ]]; then
                args+=("$DB_ROOT_USER" "$DB_ROOT_PASSWORD")
            fi
            debug "Flushing privileges..."
            mysql_execute "${args[@]}" <<EOF
flush privileges;
EOF
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
msyql_custom_init_scripts() {
    if [[ -n $(find /docker-entrypoint-initdb.d/ -type f -regex ".*\.\(sh\|sql\|sql.gz\)") ]] && [[ ! -f "$DB_VOLUMEDIR/.user_scripts_initialized" ]] ; then
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
                *.sql)    debug "Executing $f"; mysql_execute "$DB_DATABASE" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD" < "$f";;
                *.sql.gz) debug "Executing $f"; gunzip -c "$f" | mysql_execute "$DB_DATABASE" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD";;
                *)        debug "Ignoring $f" ;;
            esac
        done
        touch "$DB_VOLUMEDIR"/.user_scripts_initialized
    fi
}
