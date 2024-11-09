#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami MySQL library

# shellcheck disable=SC1090,SC1091,SC2119,SC2120

# Load Generic Libraries
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libfs.sh
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
    local -a dbExtraFlags=()
    # shellcheck disable=SC2153
    read -r -a userExtraFlags <<< "$DB_EXTRA_FLAGS"

    if [[ -n "$DB_REPLICATION_MODE" ]]; then
        randNumber="$(head /dev/urandom | tr -dc 0-9 | head -c 3 ; echo '')"
        dbExtraFlags+=("--server-id=$randNumber" "--binlog-format=ROW" "--log-bin=mysql-bin" "--sync-binlog=1")
        if [[ "$DB_REPLICATION_MODE" = "slave" ]]; then
            dbExtraFlags+=("--relay-log=mysql-relay-bin" "--log-slave-updates=1" "--read-only=1")
        elif [[ "$DB_REPLICATION_MODE" = "master" ]]; then
            dbExtraFlags+=("--innodb_flush_log_at_trx_commit=1")
        fi
    fi

    [[ "${#userExtraFlags[@]}" -eq 0 ]] || dbExtraFlags+=("${userExtraFlags[@]}")

    echo "${dbExtraFlags[@]:-}"
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
    if [[ -n "$DB_USER" ]] && [[ "$DB_USER" = "root" ]]; then
        print_validation_error "root user is already created in the database and you can't use it as username for user creation."
    fi
    if [[ "${DB_PASSWORD:-}" = *\\* ]]; then
        backslash_password_error "$(get_env_var PASSWORD)"
    fi
    if [[ "${DB_REPLICATION_PASSWORD:-}" = *\\* ]]; then
        backslash_password_error "$(get_env_var REPLICATION_PASSWORD)"
    fi

    collation_env_var="$(get_env_var COLLATION)"
    is_empty_value "${!collation_env_var:-}" || warn "The usage of '$(get_env_var COLLATION)' is deprecated and will soon be removed. Use '$(get_env_var COLLATE)' instead."

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
mysql_create_default_config() {
    debug "Creating main configuration file"
    cat > "$DB_CONF_FILE" <<EOF
[mysqladmin]
user=${DB_USER}

[mysqld]
skip_name_resolve
explicit_defaults_for_timestamp
basedir=${DB_BASE_DIR}
port=${DB_DEFAULT_PORT_NUMBER}
tmpdir=${DB_TMP_DIR}
socket=${DB_SOCKET_FILE}
pid_file=${DB_PID_FILE}
max_allowed_packet=16M
bind_address=${DB_DEFAULT_BIND_ADDRESS}
log_error=${DB_LOGS_DIR}/mysqld.log
slow_query_log=${DB_ENABLE_SLOW_QUERY}
long_query_time=${DB_LONG_QUERY_TIME}
character_set_server=${DB_DEFAULT_CHARACTER_SET}
plugin_dir=${DB_BASE_DIR}/lib/plugin
datadir=${DB_DATA_DIR}

[client]
port=${DB_DEFAULT_PORT_NUMBER}
socket=${DB_SOCKET_FILE}
default_character_set=${DB_DEFAULT_CHARACTER_SET}
plugin_dir=${DB_BASE_DIR}/lib/plugin

[manager]
port=${DB_DEFAULT_PORT_NUMBER}
socket=${DB_SOCKET_FILE}
pid_file=${DB_PID_FILE}
EOF
}

########################
# Make a dump on master database and update slave database
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mysql_exec_initial_dump() {
    local -r dump_file="${DB_DATA_DIR}/dump_all_databases.sql"

    info "MariaDB dump master data start..."
    debug "Lock master databases for write operations"
    echo "FLUSH TABLES WITH READ LOCK;" | mysql_remote_execute "$DB_MASTER_HOST" "$DB_MASTER_PORT_NUMBER" "mysql" "$DB_MASTER_ROOT_USER" "$DB_MASTER_ROOT_PASSWORD"

    read -r log_file log_position <<< "$(echo "SHOW MASTER STATUS;" | mysql_remote_execute_print_output "$DB_MASTER_HOST" "$DB_MASTER_PORT_NUMBER" "mysql" "$DB_MASTER_ROOT_USER" "$DB_MASTER_ROOT_PASSWORD" | awk 'NR==1 {print $1, $2}')"
    debug "File: $log_file and Position: $log_position"

    debug "Start dump process databases"
    mysqldump --verbose --all-databases -h "$DB_MASTER_HOST" -P "$DB_MASTER_PORT_NUMBER" -u "$DB_MASTER_ROOT_USER" -p"$DB_MASTER_ROOT_PASSWORD" > "$dump_file"
    debug "Finish dump databases"

    debug "Unlock master databases for write operations"
    echo "UNLOCK TABLES;" | mysql_remote_execute "$DB_MASTER_HOST" "$DB_MASTER_PORT_NUMBER" "mysql" "$DB_MASTER_ROOT_USER" "$DB_MASTER_ROOT_PASSWORD"

    debug "Start import dump databases"
    mysql_execute < "$dump_file"
    mysql_execute "mysql" <<EOF
CHANGE MASTER TO MASTER_HOST='$DB_MASTER_HOST',
MASTER_PORT=$DB_MASTER_PORT_NUMBER,
MASTER_USER='$DB_REPLICATION_USER',
MASTER_PASSWORD='$DB_REPLICATION_PASSWORD',
MASTER_DELAY=$DB_MASTER_DELAY,
MASTER_LOG_FILE='$log_file',
MASTER_LOG_POS=$log_position,
MASTER_CONNECT_RETRY=10;
EOF
    debug "Finish import dump databases"

    rm -f "$dump_file"
    info "MariaDB dump master data finish..."
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
        while ! echo "select 1" | mysql_remote_execute "$DB_MASTER_HOST" "$DB_MASTER_PORT_NUMBER" "mysql" "$DB_MASTER_ROOT_USER" "$DB_MASTER_ROOT_PASSWORD"; do
            sleep 1
        done

        if [[ "$DB_REPLICATION_SLAVE_DUMP" = "true" ]]; then
            mysql_exec_initial_dump
        else
            debug "Replication master ready!"
            debug "Setting the master configuration"
            mysql_execute "mysql" <<EOF
CHANGE MASTER TO MASTER_HOST='$DB_MASTER_HOST',
MASTER_PORT=$DB_MASTER_PORT_NUMBER,
MASTER_USER='$DB_REPLICATION_USER',
MASTER_PASSWORD='$DB_REPLICATION_PASSWORD',
MASTER_DELAY=$DB_MASTER_DELAY,
MASTER_CONNECT_RETRY=10;
EOF

        fi
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
create or replace user '$user'@'%' $([ "$password" != "" ] && echo "identified by \"$password\"");
EOF
    else
        mysql_execute "mysql" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD" <<EOF
create user '$user'@'%' $([ "$password" != "" ] && echo "identified with 'mysql_native_password' by \"$password\"");
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
    rm -f "$DB_PID_FILE"

    debug "Ensuring expected directories/files exist"
    for dir in "$DB_DATA_DIR" "$DB_TMP_DIR" "$DB_LOGS_DIR"; do
        ensure_dir_exists "$dir"
        am_i_root && chown "$DB_DAEMON_USER":"$DB_DAEMON_GROUP" "$dir"
    done

    if is_file_writable "$DB_CONF_FILE"; then
        info "Updating 'my.cnf' with custom configuration"
        mysql_update_custom_config
    else
        warn "The ${DB_FLAVOR} configuration file '${DB_CONF_FILE}' is not writable. Configurations based on environment variables will not be applied for this file."
    fi

    if [[ -f "${DB_CONF_DIR}/my_custom.cnf" ]]; then
        if is_file_writable "${DB_CONF_DIR}/bitnami/my_custom.cnf"; then
            info "Injecting custom configuration 'my_custom.cnf'"
            cat "${DB_CONF_DIR}/my_custom.cnf" > "${DB_CONF_DIR}/bitnami/my_custom.cnf"
            if ! grep --silent "!include ${DB_CONF_DIR}/bitnami/my_custom.cnf" "${DB_CONF_FILE}"; then
                echo "!include ${DB_CONF_DIR}/bitnami/my_custom.cnf" >> "${DB_CONF_FILE}"
            fi
        else
            warn "Could not inject custom configuration for the ${DB_FLAVOR} configuration file '$DB_CONF_DIR/bitnami/my_custom.cnf' because it is not writable."
        fi
    fi

    if [[ -e "$DB_DATA_DIR/mysql" ]]; then
        info "Using persisted data"
        # mysql_upgrade requires the server to be running
        [[ -n "$(get_master_env_var_value ROOT_PASSWORD)" ]] && export ROOT_AUTH_ENABLED="yes"
        # https://dev.mysql.com/doc/refman/8.0/en/replication-upgrade.html
        mariadb_upgrade
    else
        debug "Cleaning data directory to ensure successfully initialization"
        rm -rf "${DB_DATA_DIR:?}"/*
        info "Installing database"
        mariadb_install_db
        mysql_start_bg
        wait_for_mysql_access
        # we delete existing users and create new ones with stricter access
        # commands can still be executed until we restart or run 'flush privileges'
        info "Configuring authentication"
        mysql_execute "mysql" <<EOF
DELETE FROM mysql.user WHERE user not in ('mysql.sys','mysql.infoschema','mysql.session','mariadb.sys');
EOF
        # slaves do not need to configure users
        if [[ -z "$DB_REPLICATION_MODE" ]] || [[ "$DB_REPLICATION_MODE" = "master" ]]; then
            if [[ "$DB_REPLICATION_MODE" = "master" ]]; then
                debug "Starting replication"
                echo "RESET MASTER;" | debug_execute "$DB_BIN_DIR/mysql" --defaults-file="$DB_CONF_FILE" -N -u root
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
                local -a createdb_args=("$DB_DATABASE")
                [[ -n "$DB_USER" ]] && createdb_args+=("-u" "$DB_USER")
                [[ -n "$DB_CHARACTER_SET" ]] && createdb_args+=("--character-set" "$DB_CHARACTER_SET")
                [[ -n "$DB_COLLATE" ]] && createdb_args+=("--collate" "$DB_COLLATE")
                mysql_ensure_optional_database_exists "${createdb_args[@]}"
            fi
            [[ -n "$DB_ROOT_PASSWORD" ]] && export ROOT_AUTH_ENABLED="yes"
        fi
        [[ -n "$DB_REPLICATION_MODE" ]] && mysql_configure_replication
        # we run mysql_upgrade in order to recreate necessary database users and flush privileges
        mariadb_upgrade
    fi
}

########################
# Run custom scripts
# Globals:
#   DB_*
# Arguments:
#   $1 - 'init' or 'start' ('init' runs on first container start, 'start' runs everytime the container starts)
# Returns:
#   None
#########################
mysql_custom_scripts() {
    if [[ -n $(find /docker-entrypoint-"$1"db.d/ -type f -regex ".*\.\(sh\|sql\|sql.gz\)") ]] && { [[ ! -f "$DB_DATA_DIR/.user_scripts_initialized" ]] || [[ $1 == start ]]; } then
        info "Loading user's custom files from /docker-entrypoint-$1db.d";
        for f in /docker-entrypoint-"$1"db.d/*; do
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
                    [[ "$DB_REPLICATION_MODE" = "slave" ]] && warn "Custom SQL $1db is not supported on slave nodes, ignoring $f" && continue
                    wait_for_mysql_access "$DB_ROOT_USER"
                    # Temporarily disabling autocommit to increase performance when importing huge files
                    if ! mysql_execute_print_output "$DB_DATABASE" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD" <<< "SET autocommit=0; source ${f}; COMMIT;"; then
                        error "Failed executing $f"
                        return 1
                    fi
                    ;;
                *.sql.gz)
                    [[ "$DB_REPLICATION_MODE" = "slave" ]] && warn "Custom SQL $1db is not supported on slave nodes, ignoring $f" && continue
                    wait_for_mysql_access "$DB_ROOT_USER"
                    # In this case, it is best to pipe the uncompressed SQL commands directly to the 'mysql' command as extraction may cause problems
                    # e.g. lack of disk space, permission issues...
                    if ! gunzip -c "$f" | mysql_execute_print_output "$DB_DATABASE" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD"; then
                        error "Failed executing $f"
                        return 1
                    fi
                    ;;
                *)
                    warn "Skipping $f, supported formats are: .sh .sql .sql.gz"
                    ;;
            esac
        done
        touch "$DB_DATA_DIR"/.user_scripts_initialized
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
# Initialize database data
# Globals:
#   BITNAMI_DEBUG
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mariadb_install_db() {
    local command="${DB_BIN_DIR}/mysql_install_db"
    local -a args=("--defaults-file=${DB_CONF_FILE}" "--basedir=${DB_BASE_DIR}" "--datadir=${DB_DATA_DIR}")

    # Add flags specified via the 'DB_EXTRA_FLAGS' environment variable
    read -r -a db_extra_flags <<< "$(mysql_extra_flags)"
    [[ "${#db_extra_flags[@]}" -gt 0 ]] && args+=("${db_extra_flags[@]}")

    am_i_root && args=("${args[@]}" "--user=$DB_DAEMON_USER")
    args+=("--auth-root-authentication-method=normal")
    # Feature available only in MariaDB 10.5+
    # ref: https://mariadb.com/kb/en/mysql_install_db/#not-creating-the-test-database-and-anonymous-user
    if [[ ! "$(mysql_get_version)" =~ ^10\.[01234]\. ]]; then
        is_boolean_yes "$DB_SKIP_TEST_DB" && args+=("--skip-test-db")
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
mariadb_upgrade() {
    local -a args=("--defaults-file=${DB_CONF_FILE}" "-u" "$DB_ROOT_USER")
    info "Running mysql_upgrade"
    mysql_start_bg
    is_boolean_yes "${ROOT_AUTH_ENABLED:-false}" && args+=("-p$(get_master_env_var_value ROOT_PASSWORD)")
    [[ "${DB_UPGRADE}" == "FORCE" ]] && args+=("--force")
    debug_execute "${DB_BIN_DIR}/mysql_upgrade" "${args[@]}" || echo "This installation is already upgraded"
}

#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami MySQL Galera library

# shellcheck disable=SC1090,SC1091,SC2119,SC2120

. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libversion.sh
. /opt/bitnami/scripts/libfile.sh

########################
# Check if a previous boot exists
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   Yes or no
#########################
get_previous_boot() {
    [[ -e "$DB_GALERA_BOOTSTRAP_FILE" ]] && echo "yes" || echo "no"
}

########################
# Create a flag file to indicate previous boot
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
set_previous_boot() {
    info "Setting previous boot"
    touch "$DB_GALERA_BOOTSTRAP_FILE"
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
    local -a dbExtraFlags=()
    read -r -a userExtraFlags <<< "${DB_EXTRA_FLAGS?}"

    # This avoids a non-writable configuration file break a Galera Cluster, due to lack of proper Galera clustering configuration
    # This is especially important for the MariaDB Galera chart, in which the 'my.cnf' configuration file is mounted by default
    if ! is_file_writable "$DB_CONF_FILE"; then
        dbExtraFlags+=(
            "--wsrep-node-name=$(get_node_name)"
            "--wsrep-node-address=$(get_node_address)"
            "--wsrep-cluster-name=${DB_GALERA_CLUSTER_NAME}"
            "--wsrep-cluster-address=$(get_galera_cluster_address_value)"
            "--wsrep-sst-method=${DB_GALERA_SST_METHOD}"
            "--wsrep-sst-auth=${DB_GALERA_MARIABACKUP_USER}:${DB_GALERA_MARIABACKUP_PASSWORD}"
        )
    fi

    [[ ${#userExtraFlags[@]} -eq 0 ]] || dbExtraFlags+=("${userExtraFlags[@]}")

    echo "${dbExtraFlags[@]}"
}

########################
# Whether the Galera node will perform bootstrapping of a new cluster, or join an existing one
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   Yes or no
#########################
get_galera_cluster_bootstrap_value() {
    local cluster_bootstrap

    # This block evaluate if the cluster needs to be boostraped or not.
    # When the node is marked to bootstrap:
    #  - When it is force by setting DB_GALERA_CLUSTER_BOOTSTRAP
    #  - When there is not previous boot and not other nodes has been found
    # When the node is not marked to bootstrap, the node will join an existing cluster.
    cluster_bootstrap="no" # initial value
    if is_boolean_yes "$DB_GALERA_CLUSTER_BOOTSTRAP"; then
        cluster_bootstrap="yes"
    elif ! is_boolean_yes "$(get_previous_boot)" && ! is_boolean_yes "$(has_galera_cluster_other_nodes)"; then
        cluster_bootstrap="yes"
    fi
    echo "$cluster_bootstrap"
}

########################
# Whether the Galera cluster has other running nodes
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
has_galera_cluster_other_nodes() {
    local node_ip cluster_address address has_nodes

    hostname_has_ips() {
       local hostname="${1:?hostname is required}"
       [[ "$(getent ahosts "$hostname")" != "" ]] && return 0
       return 1
    }

    has_nodes="yes"
    cluster_address="$DB_GALERA_CLUSTER_ADDRESS"
    if [[ -z "$cluster_address" ]]; then
        has_nodes="no"
    elif [[ -n "$cluster_address" ]]; then
        has_nodes="no"
        read -r -a local_ips <<< "$(hostname -i)"
        read -r -a addresses <<< "$(tr ',' ' ' <<< "${cluster_address#*://}")"
        if [[ "${#addresses[@]}" -eq "1" ]]; then
            if validate_ipv4 "$(echo "${addresses[0]}" | cut -d':' -f1)"; then
                has_nodes="yes"
            else
                address="$(echo "${addresses[0]}" | cut -d':' -f1)"
                if retry_while "hostname_has_ips $address" 2 2; then
                    for ip in $(getent ahosts "$address" | awk '{print $1}' | uniq); do
                        for local_ip in "${local_ips[@]}"; do
                            if [[ "$ip" != "$local_ip" ]]; then
                                has_nodes="yes"
                                break
                            fi
                        done
                    done
                fi
            fi
        else
            for a in "${addresses[@]}"; do
                address="$(echo "$a" | cut -d':' -f1)"
                node_ip=""
                if validate_ipv4 "$address"; then
                    node_ip="$address"
                else
                    if retry_while "hostname_has_ips $address" 2 2; then
                        node_ip="$(dns_lookup "$address")"
                    fi
                fi
                if [[ -n "$node_ip" ]]; then
                    has_nodes="yes"
                    # we now check if *any* of our IPs matches the node IP. In that case, we have to revert has_nodes to no, because it's not in fact a foreign node and check the next.
                    for local_ip in "${local_ips[@]}"; do
                        if [[ "$node_ip" == "$local_ip" ]]; then
                            has_nodes="no"
                            break
                        fi
                    done
                    # The foreign IP did not match our local IP, so we know that another node exists.
                    if [[ "$has_nodes" == 'yes' ]]; then
                        break
                    fi
                fi
            done
        fi
    fi
    echo "$has_nodes"
}

########################
# Build Galera cluster address string from the bootstrap string
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
get_galera_cluster_address_value() {
    local cluster_address

    if ! is_boolean_yes "$(get_galera_cluster_bootstrap_value)" && is_boolean_yes "$(has_galera_cluster_other_nodes)"; then
        cluster_address="$DB_GALERA_CLUSTER_ADDRESS"
    else
        cluster_address="gcomm://"
    fi

    debug "Set Galera cluster address to ${cluster_address}"
    echo "$cluster_address"
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

    if is_boolean_yes "$ALLOW_EMPTY_PASSWORD"; then
        empty_password_enabled_warn
    else
        if [[ -n "$DB_GALERA_MARIABACKUP_USER" ]] && [[ -z "$DB_GALERA_MARIABACKUP_PASSWORD" ]]; then
            empty_password_error "$(get_env_var GALERA_MARIABACKUP_PASSWORD)"
        fi

        if is_boolean_yes "$(get_galera_cluster_bootstrap_value)"; then
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

    if [[ -n "$DB_GALERA_FORCE_SAFETOBOOTSTRAP" ]] && ! is_yes_no_value "$DB_GALERA_FORCE_SAFETOBOOTSTRAP"; then
        print_validation_error "The allowed values for $(get_env_var GALERA_FORCE_SAFETOBOOTSTRAP) are yes or no."
    fi

    if [[ -z "$DB_GALERA_CLUSTER_NAME" ]]; then
        print_validation_error "Galera cluster cannot be created without setting the environment variable $(get_env_var GALERA_CLUSTER_NAME)."
    fi

    if [[ -z "$(get_galera_cluster_address_value)" ]]; then
        print_validation_error "Galera cluster cannot be created without setting the environment variable $(get_env_var GALERA_CLUSTER_ADDRESS). If you are bootstrapping a new Galera cluster, set the environment variable $(get_env_var GALERA_CLUSTER_ADDRESS)=yes."
    fi

    if [[ "${DB_ROOT_PASSWORD:-}" = *\\* ]]; then
        backslash_password_error "$(get_env_var ROOT_PASSWORD)"
    fi
    if [[ "${DB_PASSWORD:-}" = *\\* ]]; then
        backslash_password_error "$(get_env_var PASSWORD)"
    fi

    if is_boolean_yes "$DB_ENABLE_LDAP" && { [[ -z "${LDAP_URI}" ]] || [[ -z "${LDAP_BASE}" ]] || [[ -z "${LDAP_BIND_DN}" ]] || [[ -z "${LDAP_BIND_PASSWORD}" ]]; }; then
        print_validation_error "The LDAP configuration is required when LDAP authentication is enabled. Set the environment variables LDAP_URI, LDAP_BASE, LDAP_BIND_DN and LDAP_BIND_PASSWORD with the LDAP configuration."
    fi

    if is_boolean_yes "$DB_ENABLE_TLS"; then
        if [[ -z "${DB_TLS_CERT_FILE}" ]] || [[ -z "${DB_TLS_KEY_FILE}" ]] || [[ -z "${DB_TLS_CA_FILE}" ]]; then
            print_validation_error "The TLS cert file, key and CA are required when TLS is enabled. Set the environment variables TLS_CERT_FILE, TLS_KEY_FILE and TLS_CA_FILE with the path to each file."
        fi
        if [[ ! -f "${DB_TLS_CERT_FILE}" ]]; then
            print_validation_error "The TLS_CERT file ${DB_TLS_CERT_FILE} must exist."
        fi
        if [[ ! -f "${DB_TLS_KEY_FILE}" ]]; then
            print_validation_error "The TLS_KEY file ${DB_TLS_KEY_FILE} must exist."
        fi
        if [[ ! -f "${DB_TLS_CA_FILE}" ]]; then
            print_validation_error "The TLS_CA file ${DB_TLS_CA_FILE} must exist."
        fi
    fi

    collation_env_var="$(get_env_var COLLATION)"
    is_empty_value "${!collation_env_var:-}" || warn "The usage of '$(get_env_var COLLATION)' is deprecated and will soon be removed. Use '$(get_env_var COLLATE)' instead."

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
mysql_create_default_config() {
    debug "Creating main configuration file"
    cat > "$DB_CONF_FILE" <<EOF
[mysqladmin]
user=${DB_USER}

[mysqld]
skip_host_cache
skip_name_resolve
explicit_defaults_for_timestamp
basedir=${DB_BASE_DIR}
datadir=${DB_DATA_DIR}
port=${DB_DEFAULT_PORT_NUMBER}
tmpdir=${DB_TMP_DIR}
socket=${DB_SOCKET_FILE}
pid_file=${DB_PID_FILE}
max_allowed_packet=16M
bind_address=${DB_DEFAULT_BIND_ADDRESS}
log_error=${DB_LOGS_DIR}/mysqld.log
character_set_server=${DB_DEFAULT_CHARACTER_SET}
plugin_dir=${DB_BASE_DIR}/plugin
binlog_format=row
log_bin=mysql-bin

[client]
port=${DB_DEFAULT_PORT_NUMBER}
socket=${DB_SOCKET_FILE}
default_character_set=${DB_DEFAULT_CHARACTER_SET}
plugin_dir=${DB_BASE_DIR}/plugin

[manager]
port=${DB_DEFAULT_PORT_NUMBER}
socket=${DB_SOCKET_FILE}
pid_file=${DB_PID_FILE}

[galera]
wsrep_on=ON
wsrep_provider=${DB_BASE_DIR}/lib/libgalera_smm.so
wsrep_sst_method=mariabackup
wsrep_slave_threads=4
wsrep_cluster_address=${DB_GALERA_DEFAULT_CLUSTER_ADDRESS}
wsrep_sst_auth=${DB_GALERA_DEFAULT_MARIABACKUP_USER}:${DB_GALERA_DEFAULT_MARIABACKUP_PASSWORD}
wsrep_cluster_name=${DB_GALERA_DEFAULT_CLUSTER_NAME}
wsrep_node_name=${DB_GALERA_DEFAULT_NODE_NAME}
wsrep_node_address=${DB_GALERA_DEFAULT_NODE_ADDRESS}
innodb_autoinc_lock_mode=2

[mariadb]
plugin_load_add = auth_pam

!include ${DB_CONF_DIR}/bitnami/my_custom.cnf
EOF
}

########################
# Update MySQL/MariaDB Galera-specific ssl configuration with user custom inputs
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mysql_galera_configure_ssl() {
    if is_boolean_yes "$DB_ENABLE_TLS" && ! grep -q "socket.ssl_cert=" "$DB_TLS_CERT_FILE"; then
        info "Setting ENABLE_TLS"
        mysql_conf_set "ssl_cert" "${DB_TLS_CERT_FILE}" "mariadb"
        mysql_conf_set "ssl_key" "${DB_TLS_KEY_FILE}" "mariadb"
        mysql_conf_set "ssl_ca" "${DB_TLS_CA_FILE}" "mariadb"
        mysql_conf_set "wsrep_provider_options" "'socket.ssl_cert=${DB_TLS_CERT_FILE};socket.ssl_key=${DB_TLS_KEY_FILE};socket.ssl_ca=${DB_TLS_CA_FILE}'" "mariadb" "yes"
    fi

    # Avoid exit code of previous commands to affect the result of this function
    true
}

########################
# Update MySQL/MariaDB Galera-specific configuration file with user custom inputs
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mysql_galera_update_custom_config() {
    local galera_node_name
    galera_node_name="$(get_node_name)"
    [[ "$galera_node_name" != "$DB_GALERA_DEFAULT_NODE_NAME" ]] && mysql_conf_set "wsrep_node_name" "$galera_node_name" "galera"

    local galera_node_address
    galera_node_address="$(get_node_address)"
    [[ "$galera_node_address" != "$DB_GALERA_DEFAULT_NODE_ADDRESS" ]] && mysql_conf_set "wsrep_node_address" "$galera_node_address" "galera"

    [[ "$DB_GALERA_CLUSTER_NAME" != "$DB_GALERA_DEFAULT_CLUSTER_NAME" ]] && mysql_conf_set "wsrep_cluster_name" "$DB_GALERA_CLUSTER_NAME" "galera"

    local galera_cluster_address
    galera_cluster_address="$(get_galera_cluster_address_value)"
    [[ "$galera_cluster_address" != "$DB_GALERA_DEFAULT_CLUSTER_ADDRESS" ]] && mysql_conf_set "wsrep_cluster_address" "$galera_cluster_address" "galera"

    [[ "$DB_GALERA_SST_METHOD" != "$DB_GALERA_DEFAULT_SST_METHOD" ]] && mysql_conf_set "wsrep_sst_method" "$DB_GALERA_SST_METHOD" "galera"

    local galera_auth_string="${DB_GALERA_MARIABACKUP_USER}:${DB_GALERA_MARIABACKUP_PASSWORD}"
    local default_auth_string="${DB_GALERA_DEFAULT_MARIABACKUP_USER}:${DB_GALERA_DEFAULT_MARIABACKUP_PASSWORD}"
    [[ "$galera_auth_string" != "$default_auth_string" ]] && mysql_conf_set "wsrep_sst_auth" "$galera_auth_string" "galera"

    # Sanitize triple quotes produced by ini-file when using special characters like "`"
    # https://github.com/bitnami/charts/issues/10880
    replace_in_file "$DB_CONF_FILE" "=\"\"\"(.*)\"\"\"" "=\1"

    # Avoid exit code of previous commands to affect the result of this function
    true
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
    local -r user="${1:?user is required}"
    local -r password="${2:-}"

    debug "Configure mariabackup user credentials"
    mysql_execute "mysql" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD" <<EOF
create or replace user '$user'@'localhost' $([ "$password" != "" ] && echo "identified by \"$password\"");
EOF
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
    local -r user="${1:?user is required}"
    local -r password="${2:-}"

    debug "Configure replication user"

    mysql_execute "mysql" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD" <<EOF
grant REPLICATION CLIENT ON *.* to '$user'@'%' identified by "$password";
grant PROCESS ON *.* to '$user'@'localhost' identified by "$password";
flush privileges;
EOF

}

########################
# Force safe_to_bootstrap in grastate file
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
set_safe_to_bootstrap() {
    info "Forcing safe_to_bootstrap."
    replace_in_file "$DB_GALERA_GRASTATE_FILE" "safe_to_bootstrap: 0" "safe_to_bootstrap: 1"
}

########################
# Check if it is safe to bootstrap from this node
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
is_safe_to_bootstrap() {
    is_boolean_yes "$(grep safe_to_bootstrap "$DB_GALERA_GRASTATE_FILE" | cut -d' ' -f 2)"
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
    rm -f "$DB_PID_FILE"

    debug "Ensuring expected directories/files exist"
    for dir in "$DB_DATA_DIR" "$DB_TMP_DIR" "$DB_LOGS_DIR" "$DB_GALERA_BOOTSTRAP_DIR"; do
        ensure_dir_exists "$dir"
        am_i_root && chown "$DB_DAEMON_USER:$DB_DAEMON_GROUP" "$dir"
    done

    if is_boolean_yes "$(get_previous_boot)" && ! is_boolean_yes "$DB_GALERA_CLUSTER_BOOTSTRAP"; then
        warn "This node was previouly booted, you may need to force bootstrapping in one of the nodes."
    fi

    if is_file_writable "$DB_CONF_FILE"; then
        if ! is_mounted_dir_empty "$DB_GALERA_MOUNTED_CONF_DIR"; then
            info "Found mounted configuration directory"
            mysql_copy_mounted_config
        fi
        info "Updating 'my.cnf' with custom configuration"
        mysql_update_custom_config
        mysql_galera_update_custom_config
        mysql_galera_configure_ssl
    else
        warn "The ${DB_FLAVOR} configuration file '${DB_CONF_FILE}' is not writable or does not exist. Configurations based on environment variables will not be applied for this file."
    fi

    if [[ -f "${DB_CONF_DIR}/my_custom.cnf" ]]; then
        if is_file_writable "${DB_CONF_DIR}/bitnami/my_custom.cnf"; then
            info "Injecting custom configuration 'my_custom.cnf'"
            cat "${DB_CONF_DIR}/my_custom.cnf" > "${DB_CONF_DIR}/bitnami/my_custom.cnf"
        else
            warn "Could not inject custom configuration for the ${DB_FLAVOR} configuration file '$DB_CONF_DIR/bitnami/my_custom.cnf' because it is not writable."
        fi
    fi

    if [[ -e "$DB_DATA_DIR/mysql" ]]; then
        info "Persisted data detected. Restoring"

        if is_boolean_yes "$(get_galera_cluster_bootstrap_value)"; then
            if is_boolean_yes "$DB_GALERA_FORCE_SAFETOBOOTSTRAP"; then
                set_safe_to_bootstrap
            fi
            if ! is_safe_to_bootstrap; then
                error "It is not safe to bootstrap form this node ('safe_to_bootstrap=0' is set in 'grastate.dat'). If you want to force bootstrap, set the environment variable MARIADB_GALERA_FORCE_SAFETOBOOTSTRAP=yes"
                exit 1
            fi
        fi

        return
    else
        # initialization should not be performed on non-primary nodes of a galera cluster
        if is_boolean_yes "$(get_galera_cluster_bootstrap_value)"; then
            debug "Cleaning data directory to ensure successfully initialization"
            rm -rf "${DB_DATA_DIR:?}"/*
            mariadb_install_db
            mysql_start_bg
            debug "Deleting all users to avoid issues with galera configuration"
            mysql_execute "mysql" <<EOF
DELETE FROM mysql.user WHERE user not in ('mysql.sys','mysql.infoschema','mysql.session','mariadb.sys');
EOF

            mysql_ensure_root_user_exists "$DB_ROOT_USER" "$DB_ROOT_PASSWORD"
            mysql_ensure_user_not_exists "" # ensure unknown user does not exist
            if [[ -n "$DB_USER" ]]; then
                local -a args=("$DB_USER")
                if is_boolean_yes "$DB_ENABLE_LDAP"; then
                    args+=("--use-ldap")
                elif [[ -n "$DB_PASSWORD" ]]; then
                    args+=("-p" "$DB_PASSWORD")
                fi
                mysql_ensure_optional_user_exists "${args[@]}"
            fi
            if [[ -n "$DB_DATABASE" ]]; then
                local -a createdb_args=("$DB_DATABASE")
                [[ -n "$DB_USER" ]] && createdb_args+=("-u" "$DB_USER")
                [[ -n "$DB_CHARACTER_SET" ]] && createdb_args+=("--character-set" "$DB_CHARACTER_SET")
                [[ -n "$DB_COLLATE" ]] && createdb_args+=("--collate" "$DB_COLLATE")
                mysql_ensure_optional_database_exists "${createdb_args[@]}"
            fi
            mysql_ensure_galera_mariabackup_user_exists "$DB_GALERA_MARIABACKUP_USER" "$DB_GALERA_MARIABACKUP_PASSWORD"
            mysql_ensure_replication_user_exists "$MARIADB_REPLICATION_USER" "$MARIADB_REPLICATION_PASSWORD"

            [[ -n "$(get_master_env_var_value ROOT_PASSWORD)" ]] && export ROOT_AUTH_ENABLED="yes"

            local -a args=(mysql)
            args+=("$DB_ROOT_USER" "$DB_ROOT_PASSWORD")
            debug "Flushing privileges"
            mysql_execute "${args[@]}" <<EOF
flush privileges;
EOF
        fi
    fi
}

########################
# Copy mounted configuration files
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mysql_copy_mounted_config() {
    if ! is_dir_empty "$DB_GALERA_MOUNTED_CONF_DIR"; then
        if ! cp -Lr "$DB_GALERA_MOUNTED_CONF_DIR"/* "$DB_GALERA_CONF_DIR"; then
            error "Issue copying mounted configuration files from $DB_GALERA_MOUNTED_CONF_DIR to $DB_GALERA_CONF_DIR. Make sure you are not mounting configuration files in $DB_GALERA_CONF_DIR and $DB_GALERA_MOUNTED_CONF_DIR at the same time"
            exit 1
        fi
    fi
}

########################
# Run custom scripts
# Globals:
#   DB_*
# Arguments:
#   $1 - 'init' or 'start' ('init' runs on first container start, 'start' runs everytime the container starts)
# Returns:
#   None
#########################
mysql_custom_scripts() {
    if [[ -n $(find /docker-entrypoint-"$1"db.d/ -type f -regex ".*\.\(sh\|sql\|sql.gz\)") ]] && { [[ ! -f "$DB_VOLUME_DIR/.user_scripts_initialized" ]] || [[ $1 == 'start' ]]; } then
        info "Loading user's custom files from /docker-entrypoint-$1db.d";
        for f in /docker-entrypoint-"$1"db.d/*; do
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
                    if is_boolean_yes "$(get_galera_cluster_bootstrap_value)"; then
                        wait_for_mysql_access "$DB_ROOT_USER"
                        debug "Executing $f"; mysql_execute "$DB_DATABASE" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD" < "$f"
                    else
                        warn "Custom SQL $1db is not supported on non-primary nodes, ignoring $f"
                    fi
                    ;;
                *.sql.gz)
                    # sql initialization should not be executed on non-primary nodes of a galera cluster
                    if is_boolean_yes "$(get_galera_cluster_bootstrap_value)"; then
                        wait_for_mysql_access "$DB_ROOT_USER"
                        debug "Executing $f"; gunzip -c "$f" | mysql_execute "$DB_DATABASE" "$DB_ROOT_USER" "$DB_ROOT_PASSWORD"
                    else
                        warn "Custom SQL $1db is not supported on non-primary nodes, ignoring $f"
                    fi
                    ;;
                *)
                    warn "Skipping $f, supported formats are: .sh, .sql, and .sql.gz"
                    ;;
            esac
        done
        touch "$DB_VOLUME_DIR"/.user_scripts_initialized
    fi
}

########################
# Check for user override of wsrep_node_name
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   String with node name
#########################
get_node_name() {
    if [[ -n "$DB_GALERA_NODE_NAME" ]]; then
        echo "$DB_GALERA_NODE_NAME"
    else
        # In some environments, the network may not be fully set up when starting the initialization
        # So, to avoid issues, we retry the 'hostname' command until it succeeds (for a few minutes)
        local -r retries="60"
        local -r seconds="5"
        retry_while "hostname" "$retries" "$seconds" >/dev/null
        hostname
    fi
}

########################
# Check for user override of wsrep_node_address
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
        # In some environments, the network may not be fully set up when starting the initialization
        # So, to avoid issues, we retry the 'hostname' command until it succeeds (for a few minutes)
        local -r retries="60"
        local -r seconds="5"
        retry_while "hostname -i" "$retries" "$seconds" >/dev/null
        # prefer IPv6 over IPv4 if available
        # This works by pulling any IPv4 addresses encountered into hold space and emitting it only when the EOF line is encountered
        printf '%s\nEOF' "$(hostname -i | tr ' ' '\n')" | sed '/:/{;q;};/^EOF$/{;g;q;};h;d'
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

    # Wait for WSREP to be ready. If WSREP is not ready, we cannot do any transactions, thus cannot
    # create any users, and WSREP instantly kills MariaDB if doing so
    wait_for_wsrep

    # Special configuration flag for system with slow disks that could take more time
    # in initializing
    if [[ -n "${DB_INIT_SLEEP_TIME}" ]]; then
        debug "Sleeping ${DB_INIT_SLEEP_TIME} seconds before continuing with initialization"
        sleep "${DB_INIT_SLEEP_TIME}"
    fi
}

########################
# Wait for WSREP to be ready to do transactions
# Arguments:
#   None
# Returns:
#   None
########################
wait_for_wsrep() {
    local -r retries=300
    local -r sleep_time=2
    if ! retry_while is_wsrep_ready "$retries" "$sleep_time"; then
        error "WSREP did not become ready"
        return 1
    fi
}

########################
# Checks for WSREP to be ready to do transactions
# Arguments:
#   None
# Returns:
#   Boolean
########################
is_wsrep_ready() {
    debug "Checking if WSREP is ready"
    is_ready="$(mysql_execute_print_output "mysql" "root" <<EOF
select VARIABLE_VALUE from information_schema.GLOBAL_STATUS where VARIABLE_NAME = 'wsrep_ready';
EOF
)"
    debug "WSREP status $is_ready"
    if [[ $is_ready == 'ON' ]]; then
        true
    else
        false
    fi
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
