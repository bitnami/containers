#!/bin/bash

. /libfile.sh
. /liblog.sh
. /libservice.sh
. /libvalidations.sh


# Gets an env. variable name based on the suffix
get_env_var() {
    local id="${1:?id is required}"
    echo "${DB_FLAVOR^^}_${id}"
}

# Gets an env. variable value based on the suffix
get_env_var_value() {
    local envVar
    envVar="$(get_env_var "$1")"
    echo "${!envVar:-}"
}

# Echo env vars for MySQL/MariaDB global configuration.
mysql_env() {
    cat <<"EOF"
export DB_FLAVOR=${DB_FLAVOR:-"mysql"}
export DB_VOLUMEDIR=/bitnami/$DB_FLAVOR
export DB_DATADIR=$DB_VOLUMEDIR/data
export DB_BASEDIR=/opt/bitnami/$DB_FLAVOR
export DB_CONFDIR=$DB_BASEDIR/conf
export DB_LOGDIR=$DB_BASEDIR/logs
export DB_TMPDIR=$DB_BASEDIR/tmp
export DB_BINDIR=$DB_BASEDIR/bin
export PATH=$DB_BINDIR:$PATH
export DB_DAEMON_USER=mysql
export DB_DAEMON_GROUP=mysql
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
export DB_EXTRA_FLAGS="$(mysql_extra_flags)"
EOF
}

# Validate settings in MYSQL_*/MARIADB_* env vars.
mysql_valid_settings() {
    info "Validating settings in MYSQL_*/MARIADB_* env vars.."

    empty_password_enabled_warn() {
        warn "You set the environment variable ALLOW_EMPTY_PASSWORD=${ALLOW_EMPTY_PASSWORD}. For safety reasons, do not use this flag in a production environment."
    }
    empty_password_error() {
        error "The $1 environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow the container to be started with blank passwords. This is recommended only for development."
        exit 1
    }

    if [ ! -z "$DB_REPLICATION_MODE" ]; then
        if [ "$DB_REPLICATION_MODE" == "master" ]; then
            if is_boolean_yes "$ALLOW_EMPTY_PASSWORD"; then
                empty_password_enabled_warn
            else
                if [ -n "$DB_REPLICATION_USER" ] && [ -z "$DB_REPLICATION_PASSWORD" ]; then
                    empty_password_error "$(get_env_var REPLICATION_PASSWORD)"
                fi
                if [ -z "$DB_ROOT_PASSWORD" ]; then
                    empty_password_error "$(get_env_var ROOT_PASSWORD)"
                fi
                if [ -n "$DB_USER" ] && [ -z "$DB_PASSWORD" ]; then
                    empty_password_error "$(get_env_var PASSWORD)"
                fi
            fi
        elif [ "$DB_REPLICATION_MODE" == "slave" ]; then
            if [ -z "$DB_MASTER_HOST" ]; then
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
            if [ -z "$DB_ROOT_PASSWORD" ]; then
                empty_password_error "$(get_env_var ROOT_PASSWORD)"
            fi
            if [ -n "$DB_USER" ] && [ -z "$DB_PASSWORD" ]; then
                empty_password_error "$(get_env_var PASSWORD)"
            fi
        fi
    fi
}

# Ensure the MySQL/MariaDB volume is initialised.
mysql_initialize() {
    info "Initializing $DB_FLAVOR database..."

    ## Creates MySQL/MariaDB configuration file
    mysql_create_config() {
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

    # Initialise database data
    mysql_install_db() {
        info "Installing database..."
        if [ "$DB_FLAVOR" == "mysql" ]; then
            "$DB_BINDIR/mysqld" \
                --defaults-file="$DB_CONFDIR/my.cnf" \
                --basedir="$DB_BASEDIR" \
                --datadir="$DB_DATADIR" \
                --initialize-insecure >/dev/null 2>&1
        else
            "$DB_BINDIR/mysql_install_db" \
                --defaults-file="$DB_CONFDIR/my.cnf" \
                --basedir="$DB_BASEDIR" \
                --datadir="$DB_DATADIR" >/dev/null 2>&1
        fi
    }

    ## Migrate old custom configuration files
    migrate_old_configuration() {
        local old_custom_conf_file="$DB_VOLUMEDIR/conf/my_custom.cnf"
        local custom_conf_file="$DB_CONFDIR/bitnami/my_custom.cnf"
        warn "Persisted configuration detected. Migrating any existing 'my_custom.cnf' file to new location..."
        warn "Custom configuration files won't be persisted any longer!"
        if [ -f "$old_custom_conf_file" ]; then
            info "Adding old custom configuration to user configuration"
            echo "" >> "$custom_conf_file"
            cat "$old_custom_conf_file" >> "$custom_conf_file"
        fi
        if am_i_root; then
            [ -e "$DB_VOLUMEDIR/.initialized" ] && rm "$DB_VOLUMEDIR/.initialized"
            rm -rf "$DB_VOLUMEDIR/conf"
        else
            warn "Old custom configuration migrated, please manually remove the 'conf' directory from the volume use to persist data"
        fi
    }

    # Configure Replication Mode
    mysql_configure_replication() {
        info "Configuration replication mode..."
        if [ "$DB_REPLICATION_MODE" == "slave" ]; then
            info "Checking if replication master is ready to accept connection ..."
            while ! echo "select 1" | mysql_remote_execute "mysql" "$DB_MASTER_HOST" "$DB_MASTER_PORT_NUMBER" "$DB_MASTER_ROOT_USER" "$DB_MASTER_ROOT_PASSWORD"; do
                sleep 1
            done
            info "Replication master ready!"
            info "Setting the master configuration..."
            mysql_execute "mysql" <<EOF
CHANGE MASTER TO MASTER_HOST='$DB_MASTER_HOST',
MASTER_PORT=$DB_MASTER_PORT_NUMBER,
MASTER_USER='$DB_REPLICATION_USER',
MASTER_PASSWORD='$DB_REPLICATION_PASSWORD',
MASTER_CONNECT_RETRY=10;
EOF
        elif [ "$DB_REPLICATION_MODE" == "master" ]; then
            if [ ! -z "$DB_REPLICATION_USER" ]; then
                mysql_ensure_replication_user_exists "$DB_REPLICATION_USER" "$DB_REPLICATION_PASSWORD"
            fi
        fi
    }

    mysql_upgrade() {
        info "Running mysql upgrade..."
        if is_boolean_yes "${ROOT_AUTH_ENABLED:-false}"; then
            "$DB_BINDIR"/mysql_upgrade --defaults-file="$DB_CONFDIR/my.cnf" -u "$DB_ROOT_USER" -p"$DB_ROOT_PASSWORD" >/dev/null 2>&1
        else
            "$DB_BINDIR"/mysql_upgrade --defaults-file="$DB_CONFDIR/my.cnf" -u "$DB_ROOT_USER" >/dev/null 2>&1
        fi
    }

    # User injected custom configuration
    if [ -f "$DB_CONFDIR/my_custom.cnf" ]; then
        cat "$DB_CONFDIR/my_custom.cnf" > "$DB_CONFDIR/bitnami/my_custom.cnf"
    fi

    if ! dir_is_empty "$DB_VOLUMEDIR"; then
        if [ -d "$DB_VOLUMEDIR/conf" ]; then
            migrate_old_configuration
        fi
    fi

    # Ensure expected directories/files exist
    for dir in "$DB_DATADIR" "$DB_TMPDIR" "$DB_LOGDIR"; do
        ensure_dir_exists "$dir"
        if am_i_root; then
            chown "$DB_DAEMON_USER:$DB_DAEMON_GROUP" "$dir"
        fi
    done
    if [ ! -e "$DB_CONFDIR/my.cnf" ]; then
        mysql_create_config
    fi

    if [ -e "$DB_DATADIR/mysql" ]; then
        info "Persisted data detected. Restoring..."
        return
    else
        # Cleaning data dir to ensure successfully initialization
        rm -rf "${DB_DATADIR:?}"/*
        mysql_install_db

        # Delete all users to avoid issues with master-slave configurations
        mysql_start_bg
        mysql_execute "mysql" <<EOF
DELETE FROM mysql.user WHERE user<>'mysql.sys';
EOF

        # slaves do not need to configure users
        if [ -z "$DB_REPLICATION_MODE" ] || [ "$DB_REPLICATION_MODE" == "master" ]; then
            if  [ "$DB_REPLICATION_MODE" == "master" ]; then
                info "Starting replication..."
                echo "RESET MASTER;" | "$DB_BINDIR/mysql" --defaults-file="$DB_CONFDIR/my.cnf" -N -u root >/dev/null 2>&1
            fi

            mysql_ensure_root_user_exists "$DB_ROOT_USER" "$DB_ROOT_PASSWORD"

            # ensure unknown user does not exist
            mysql_ensure_user_not_exists ""
            # ensure optional application database exists.
            mysql_ensure_optional_database_exists "$DB_DATABASE" "$DB_USER" "$DB_PASSWORD"
        fi

        # configure replication mode
        if [ ! -z "$DB_REPLICATION_MODE" ]; then
            mysql_configure_replication
        fi

        if [ "$DB_FLAVOR" == "mysql" ]; then
            mysql_upgrade
        else
            info "Flushing privileges..."
            mysql_execute "mysql" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD" <<EOF
flush privileges;
EOF
        fi
    fi
}

# Configure database extra start flags
mysql_extra_flags() {
    local randNumber
    local dbExtraFlags
    randNumber=$(head /dev/urandom | tr -dc 0-9 | head -c 3 ; echo '')
    dbExtraFlags="$(get_env_var_value EXTRA_FLAGS)"

    if [ ! -z "$DB_REPLICATION_MODE" ]; then
        dbExtraFlags="$dbExtraFlags --server-id=$randNumber --binlog-format=ROW --log-bin=mysql-bin --sync-binlog=1"
        if [ "$DB_REPLICATION_MODE" == "slave" ]; then
            dbExtraFlags="$dbExtraFlags --relay-log=mysql-relay-bin --log-slave-updates=1 --read-only=1"
            if [ "$DB_FLAVOR" == "mysql" ]; then
                dbExtraFlags="$dbExtraFlags --master-info-repository=TABLE --relay-log-info-repository=TABLE"
            fi
        elif [ "$DB_REPLICATION_MODE" == "master" ]; then
            dbExtraFlags="$dbExtraFlags --innodb_flush_log_at_trx_commit=1"
        fi
        echo "$dbExtraFlags"
    else
        echo ""
    fi
}

# Checks if MySQL/MariaDB is running
is_mysql_running() {
    local pid
    pid="$(get_pid "$DB_TMPDIR/mysqld.pid")"

    if [ -z "$pid" ]; then
        false
    else
        is_service_running "$pid"
    fi
}

# Starts MySQL/MariaDB in the background and waits until it's ready.
mysql_start_bg() {
    info "Starting $DB_FLAVOR in background..."
    local extraFlags=($DB_EXTRA_FLAGS)
    if is_mysql_running ; then
        return
    fi

    [ -z "$DB_EXTRA_FLAGS" ] && extraFlags[0]=" " # Ensure 'extraFlags' array is not empty
    "$DB_BINDIR/mysqld_safe" \
        --defaults-file="$DB_BASEDIR/conf/my.cnf" \
        --basedir="$DB_BASEDIR" \
        --datadir="$DB_DATADIR" \
        ${extraFlags[*]} \
        "$@" >/dev/null 2>&1 &

    # wait until the server is up and answering queries.
    if is_boolean_yes "${ROOT_AUTH_ENABLED:-false}"; then
        while ! echo "select 1" | mysql_execute "mysql" "root" "$DB_ROOT_PASSWORD"; do
            sleep 1
        done
    else
        while ! echo "select 1" | mysql_execute "mysql" "root"; do
            sleep 1
        done
    fi
}

# Starts MySQL/MariaDB in admin mode (no users, no networking). Useful for
# resetting root user, etc.
mysql_start_bg_insecurely() {
    info "Starting $DB_FLAVOR in admin mode..."
    mysql_start_bg --skip-grant-tables --skip-networking
}

# Stop MySQL/Mariadb
mysql_stop() {
    info "Stopping $DB_FLAVOR..."
    stop_service_using_pid "$DB_TMPDIR/mysqld.pid"
}

# Execute an arbitrary query/queries against the running MySQL/MariaDB service as the
# admin user. The queries must be piped using stdin.
mysql_execute() {
    local db="${1:-}"
    local user="${2:-root}"
    local pass="${3:-}"

    if [ -z  "$pass" ]; then
        cat - | "$DB_BINDIR/mysql" --defaults-file="$DB_CONFDIR/my.cnf" -N -u "$user" "$db" >/dev/null 2>&1
    else
        cat - | "$DB_BINDIR/mysql" --defaults-file="$DB_CONFDIR/my.cnf" -N -u "$user" -p"$pass" "$db" >/dev/null 2>&1
    fi
}

# Execute an arbitrary query/queries against the running MySQL/MariaDB service indicated as
# secund argument. The queries must be piped using stdin.
mysql_remote_execute() {
    local db="${1:-}"
    local hostname="${2:?hostname is required}"
    local port="${3:?port is required}"
    local user="${4:?user is required}"
    local pass="${5:-}"

    if [ -z  "$pass" ]; then
        cat - | "$DB_BINDIR/mysql" -N -h "$hostname" -P "$port" -u "$user" "$db" >/dev/null 2>&1
    else
        cat - | "$DB_BINDIR/mysql" -N -h "$hostname" -P "$port" -u "$user" -p"$pass" "$db" >/dev/null 2>&1
    fi
}

# Ensure a db user exists with the given password for the '%' host.
mysql_ensure_user_exists() {
    local user="${1:?user is required}"
    local password="${2:-}"
    local hosts

    mysql_execute "mysql" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD" <<EOF
create $([ "$DB_FLAVOR" == "mariadb" ] && echo "or replace") user '$user'@'%' $([ "$password" != "" ] && echo "identified by '$password'");
EOF

    # remove all other hosts for the user.
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

# Ensure a db user does not exist.
mysql_ensure_user_not_exists() {
    local user="${1}"

    if [ -z "$user" ]; then
        info "removing the unknown user"
    else
        info "removing user $user"
    fi
    # delete all hosts for the user.
    local hosts
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

# Ensure the replication user exists for host '%' and has full access.
mysql_ensure_replication_user_exists() {
    local user="${1:?user is required}"
    local password="${2:-}"

    info "Configure replication user credentials..."
    if [ "$DB_FLAVOR" == "mariadb" ]; then
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

# Ensure the root user exists for host '%' and has full access.
mysql_ensure_root_user_exists() {
    local user="${1:?user is required}"
    local password="${2:-}"

    info "Configure root user credentials..."

    if [ ! -z "$password" ]; then
        export ROOT_AUTH_ENABLED="yes"
    fi

    # ensure there's an admin user and password with all privileges.
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

# Optionally create the given database, and then optionally create a user with
# full privileges on the database.
mysql_ensure_optional_database_exists() {
    local database="${1:-}"
    local user="${2:-}"
    local password="${3:-}"

    if [ "$database" != "" ]; then
        info "Creating database $database..."
        mysql_ensure_database_exists "$database"
        if [ "$user" != "" ]; then
            info "Creating username $user..."
            mysql_ensure_user_exists "$user" "$password"
            info "Providing privileges to username $user on database $database..."
            mysql_ensure_user_has_database_privileges "$user" "$database"
        fi
    fi
}

# Ensure the application database exists.
mysql_ensure_database_exists() {
    local database="${1:?database is required}"

    mysql_execute "mysql" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD" <<EOF
create database if not exists \`$database\`;
EOF
}

# Ensure a user has all privileges to access a database.
mysql_ensure_user_has_database_privileges() {
    local user="${1:?user is required}"
    local database="${2:?db is required}"

    mysql_execute "mysql" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD" <<EOF
grant all on $database.* to '$user'@'%';
EOF
}

# Allow running custom initialization scripts
msyql_custom_init_scripts() {
    if [[ -n $(find /docker-entrypoint-initdb.d/ -type f -regex ".*\.\(sh\|sql\|sql.gz\)") ]] && [[ ! -f "$DB_VOLUMEDIR/.user_scripts_initialized" ]] ; then
        info "Loading user files from /docker-entrypoint-initdb.d ...";
        for f in /docker-entrypoint-initdb.d/*; do
            case "$f" in
                *.sh)
                    if [ -x "$f" ]; then
                        info "Executing $f"; "$f"
                    else
                        info "Sourcing $f"; . "$f"
                    fi
                    ;;
                *.sql)    info "Executing $f"; mysql_execute "$DB_DATABASE" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD" < "$f";;
                *.sql.gz) info "Executing $f"; gunzip -c "$f" | mysql_execute "$DB_DATABASE" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD";;
                *)        info "Ignoring $f" ;;
            esac
        done
        touch "$DB_VOLUMEDIR"/.user_scripts_initialized
        mysql_stop
    fi
}
