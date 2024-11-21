#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami MongoDB library

# shellcheck disable=SC1090,SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libnet.sh

########################
# Return field separator to use in lists. One of comma or semi-colon, comma
# being preferred.
# Globals:
#   None
# Arguments:
#   A (list) of fields
# Returns:
#   The separator used within that list
#########################
mongodb_field_separator() {
    if printf %s\\n "$1" | grep -q ','; then
        echo ','
    elif printf %s\\n "$1" | grep -q ';'; then
        echo ';'
    fi
}

########################
# Initialise the arrays databases, usernames and passwords to contain the
# fields from their respective environment variables.
# Globals:
#   MONGODB_EXTRA_DATABASES, MONGODB_EXTRA_USERNAMES, MONGODB_EXTRA_PASSWORDS
#   MONGODB_DATABASE, MONGODB_USERNAME, MONGODB_PASSWORD
# Arguments:
#   $1 - single: initialise based on MONGODB_DATABASE, MONGODB_USERNAME, MONGODB_PASSWORD
#   $1 - extra: initialise based on MONGODB_EXTRA_DATABASES, MONGODB_EXTRA_USERNAMES, MONGODB_EXTRA_PASSWORDS
#   $1 - all (or empty): initalise as both of the above
# Returns:
#   None
#########################
mongodb_auth() {
    case "${1:-all}" in
    extra)
        local -a databases_extra
        local -a usernames_extra
        local -a passwords_extra
        # Start by filling in locally scoped databases, usernames and
        # passwords arrays with the content of the _EXTRA_ environment
        # variables.
        IFS="$(mongodb_field_separator "$MONGODB_EXTRA_DATABASES")" read -r -a databases_extra <<<"$MONGODB_EXTRA_DATABASES"
        IFS="$(mongodb_field_separator "$MONGODB_EXTRA_USERNAMES")" read -r -a usernames_extra <<<"$MONGODB_EXTRA_USERNAMES"
        IFS="$(mongodb_field_separator "$MONGODB_EXTRA_PASSWORDS")" read -r -a passwords_extra <<<"$MONGODB_EXTRA_PASSWORDS"
        # Force missing empty passwords/database names (occurs when
        # MONGODB_EXTRA_PASSWORDS/DATABASES ends with a separator, e.g. a
        # comma or semi-colon), then copy into the databases, usernames and
        # passwords arrays (global).
        for ((i = 0; i < ${#usernames_extra[@]}; i++)); do
            if [[ -z "${passwords_extra[i]:-}" ]]; then
                passwords_extra[i]=""
            fi
            if [[ -z "${databases_extra[i]:-}" ]]; then
                databases_extra[i]=""
            fi
            databases+=("${databases_extra[i]}")
            usernames+=("${usernames_extra[i]}")
            passwords+=("${passwords_extra[i]}")
        done
        ;;
    single)
        # Add the content of the "regular" environment variables to the arrays
        databases+=("$MONGODB_DATABASE")
        usernames+=("$MONGODB_USERNAME")
        passwords+=("$MONGODB_PASSWORD")
        ;;
    all)
        # Perform the following in this order to respect the priority of the
        # environment variables.
        mongodb_auth single
        mongodb_auth extra
        ;;
    esac
}

########################
# Validate settings in MONGODB_* env. variables
# Globals:
#   MONGODB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mongodb_validate() {
    info "Validating settings in MONGODB_* env vars..."

    local error_message=""
    local -r replicaset_error_message="In order to configure MongoDB replica set authentication you \
need to provide the MONGODB_REPLICA_SET_KEY on every node, specify MONGODB_ROOT_PASSWORD \
in the primary node and MONGODB_INITIAL_PRIMARY_ROOT_PASSWORD in the rest of nodes"
    local error_code=0
    local usernames databases passwords

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }

    check_yes_no_value() {
        if ! is_yes_no_value "${!1}" && ! is_true_false_value "${!1}"; then
            print_validation_error "The allowed values for ${1} are: yes no"
        fi
    }

    if [[ -n "$MONGODB_REPLICA_SET_MODE" ]]; then
        if [[ "$MONGODB_REPLICA_SET_MODE" =~ ^(secondary|arbiter|hidden) ]]; then
            if [[ -z "$MONGODB_INITIAL_PRIMARY_HOST" ]]; then
                error_message="In order to configure MongoDB as a secondary or arbiter node \
you need to provide the MONGODB_INITIAL_PRIMARY_HOST env var"
                print_validation_error "$error_message"
            fi
            if { [[ -n "$MONGODB_INITIAL_PRIMARY_ROOT_PASSWORD" ]] && [[ -z "$MONGODB_REPLICA_SET_KEY" ]]; } ||
                { [[ -z "$MONGODB_INITIAL_PRIMARY_ROOT_PASSWORD" ]] && [[ -n "$MONGODB_REPLICA_SET_KEY" ]]; }; then
                print_validation_error "$replicaset_error_message"
            fi
            if [[ -n "$MONGODB_ROOT_PASSWORD" ]]; then
                error_message="MONGODB_ROOT_PASSWORD shouldn't be set on a 'non-primary' node"
                print_validation_error "$error_message"
            fi
        elif [[ "$MONGODB_REPLICA_SET_MODE" = "primary" ]]; then
            if { [[ -n "$MONGODB_ROOT_PASSWORD" ]] && [[ -z "$MONGODB_REPLICA_SET_KEY" ]]; } ||
                { [[ -z "$MONGODB_ROOT_PASSWORD" ]] && [[ -n "$MONGODB_REPLICA_SET_KEY" ]]; }; then
                print_validation_error "$replicaset_error_message"
            fi
            if [[ -n "$MONGODB_INITIAL_PRIMARY_ROOT_PASSWORD" ]]; then
                error_message="MONGODB_INITIAL_PRIMARY_ROOT_PASSWORD shouldn't be set on a 'primary' node"
                print_validation_error "$error_message"
            fi
            if [[ -z "$MONGODB_ROOT_PASSWORD" ]] && ! is_boolean_yes "$ALLOW_EMPTY_PASSWORD"; then
                error_message="The MONGODB_ROOT_PASSWORD environment variable is empty or not set. \
Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow the container to be started with blank passwords. \
This is only recommended for development."
                print_validation_error "$error_message"
            fi
        else
            error_message="You set the environment variable MONGODB_REPLICA_SET_MODE with an invalid value. \
Available options are 'primary/secondary/arbiter/hidden'"
            print_validation_error "$error_message"
        fi
    fi

    if [[ -n "$MONGODB_REPLICA_SET_KEY" ]] && ((${#MONGODB_REPLICA_SET_KEY} < 5)); then
        error_message="MONGODB_REPLICA_SET_KEY must be, at least, 5 characters long!"
        print_validation_error "$error_message"
    fi

    if [[ -n "$MONGODB_EXTRA_USERNAMES" ]]; then
        # Capture list of extra (only!) users, passwords and databases in the
        # usernames, passwords and databases arrays.
        mongodb_auth extra

        # Verify there as many usernames as passwords
        if [[ "${#usernames[@]}" -ne "${#passwords[@]}" ]]; then
            print_validation_error "Specify the same number of passwords on MONGODB_EXTRA_PASSWORDS as the number of users in MONGODB_EXTRA_USERNAMES"
        fi
        # When we have a list of databases, there should be as many databases as
        # users (thus as passwords).
        if [[ -n "$MONGODB_EXTRA_DATABASES" ]] && [[ "${#usernames[@]}" -ne "${#databases[@]}" ]]; then
            print_validation_error "Specify the same number of users on MONGODB_EXTRA_USERNAMES as the number of databases in MONGODB_EXTRA_DATABASES"
        fi
        # When the list of database is empty, then all users will be added to
        # default database.
        if [[ -z "$MONGODB_EXTRA_DATABASES" ]]; then
            warn "All users specified in MONGODB_EXTRA_USERNAMES will be added to the default database called 'test'"
        fi
    fi

    if is_boolean_yes "$ALLOW_EMPTY_PASSWORD"; then
        warn "You set the environment variable ALLOW_EMPTY_PASSWORD=${ALLOW_EMPTY_PASSWORD}. For safety reasons, do not use this flag in a production environment."
    elif { [[ -n "$MONGODB_EXTRA_USERNAMES" ]] || [[ -n "$MONGODB_USERNAME" ]]; } && [[ -z "$MONGODB_ROOT_PASSWORD" ]]; then
        # Authorization is turned on as soon as a set of users or a root
        # password are given. If we have a set of users, but an empty root
        # password, validation should fail unless ALLOW_EMPTY_PASSWORD is turned
        # on.
        error_message="The MONGODB_ROOT_PASSWORD environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow the container to be started with a blank root password. This is only recommended for development."
        print_validation_error "$error_message"
    fi

    # Warn for users with empty passwords, as these won't be created. Maybe
    # should we just end with an error here instead?
    if [[ -n "$MONGODB_EXTRA_USERNAMES" ]]; then
        # Here we can access the arrays usernames and passwordsa, as these have
        # been initialised earlier on.
        for ((i = 0; i < ${#passwords[@]}; i++)); do
            if [[ -z "${passwords[i]}" ]]; then
                warn "User ${usernames[i]} will not be created as its password is empty or not set. MongoDB cannot create users with blank passwords."
            fi
        done
    fi
    if [[ -n "$MONGODB_USERNAME" ]] && [[ -z "$MONGODB_PASSWORD" ]]; then
        warn "User $MONGODB_USERNAME will not be created as its password is empty or not set. MongoDB cannot create users with blank passwords."
    fi
    if ! is_boolean_yes "$ALLOW_EMPTY_PASSWORD" && [[ -n "$MONGODB_METRICS_USERNAME" ]] && [[ -z "$MONGODB_METRICS_PASSWORD" ]]; then
        error_message="The MONGODB_METRICS_PASSWORD environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow the container to be started with blank passwords. This is only recommended for development."
        print_validation_error "$error_message"
    fi

    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}

########################
# Copy mounted configuration files
# Globals:
#   MONGODB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mongodb_copy_mounted_config() {
    if ! is_dir_empty "$MONGODB_MOUNTED_CONF_DIR"; then
        if ! cp -Lr "$MONGODB_MOUNTED_CONF_DIR"/* "$MONGODB_CONF_DIR"; then
            error "Issue copying mounted configuration files from $MONGODB_MOUNTED_CONF_DIR to $MONGODB_CONF_DIR. Make sure you are not mounting configuration files in $MONGODB_CONF_DIR and $MONGODB_MOUNTED_CONF_DIR at the same time"
            exit 1
        fi
    fi
}

########################
# Determine the hostname by which to contact the locally running mongo daemon
# Globals:
#   MONGODB_*
# Arguments:
#   None
# Returns:
#   The value of get_machine_ip, $MONGODB_ADVERTISED_HOSTNAME or the current host address
########################
get_mongo_hostname() {
    if is_boolean_yes "$MONGODB_ADVERTISE_IP"; then
        get_machine_ip
    elif [[ -n "$MONGODB_ADVERTISED_HOSTNAME" ]]; then
        echo "$MONGODB_ADVERTISED_HOSTNAME"
    else
        hostname
    fi
}

########################
# Determine the port on which to contact the locally running mongo daemon
# Globals:
#   MONGODB_*
# Arguments:
#   None
# Returns:
#   The value of $MONGODB_ADVERTISED_PORT_NUMBER or $MONGODB_PORT_NUMBER
########################
get_mongo_port() {
    if [[ -n "$MONGODB_ADVERTISED_PORT_NUMBER" ]]; then
        echo "$MONGODB_ADVERTISED_PORT_NUMBER"
    else
        echo "$MONGODB_PORT_NUMBER"
    fi
}

########################
# Drop local Database
# Globals:
#   MONGODB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mongodb_drop_local_database() {
    info "Dropping local database to reset replica set setup..."
    local command=("mongodb_execute")

    if [[ -n "$MONGODB_USERNAME" ]] || [[ -n "$MONGODB_EXTRA_USERNAMES" ]]; then
        local usernames passwords databases
        mongodb_auth
        command=("${command[@]}" "${usernames[0]}" "${passwords[0]}")
    fi
    "${command[@]}" <<EOF
db.getSiblingDB('local').dropDatabase()
EOF
}

########################
# Check if MongoDB is running
# Globals:
#   MONGODB_PID_FILE
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_mongodb_running() {
    local pid
    pid="$(get_pid_from_file "$MONGODB_PID_FILE")"

    if [[ -z "$pid" ]]; then
        false
    else
        is_service_running "$pid"
    fi
}

########################
# Check if MongoDB is not running
# Globals:
#   MONGODB_PID_FILE
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_mongodb_not_running() {
    ! is_mongodb_running
    return "$?"
}

########################
# Retart MongoDB service
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#########################
mongodb_restart() {
    mongodb_stop
    mongodb_start_bg "$MONGODB_CONF_FILE"
}

########################
# Start MongoDB server in the background and waits until it's ready
# Globals:
#   MONGODB_*
# Arguments:
#   $1 - Path to MongoDB configuration file
# Returns:
#   None
#########################
mongodb_start_bg() {
    # Use '--fork' option to enable daemon mode
    # ref: https://docs.mongodb.com/manual/reference/program/mongod/#cmdoption-mongod-fork
    local -r conf_file="${1:-$MONGODB_CONF_FILE}"
    local flags=("--fork" "--config=$conf_file")
    if [[ -n "${MONGODB_EXTRA_FLAGS:-}" ]]; then
        local extra_flags_array=()
        read -r -a extra_flags_array <<<"$MONGODB_EXTRA_FLAGS"
        [[ "${#extra_flags_array[@]}" -gt 0 ]] && flags+=("${extra_flags_array[@]}")
    fi

    debug "Starting MongoDB in background..."

    is_mongodb_running && return

    if am_i_root; then
        if is_boolean_yes "$MONGODB_ENABLE_NUMACTL"; then
            debug_execute run_as_user "$MONGODB_DAEMON_USER" numactl --interleave=all "$MONGODB_BIN_DIR/mongod" "${flags[@]}"
        else
            debug_execute run_as_user "$MONGODB_DAEMON_USER" "$MONGODB_BIN_DIR/mongod" "${flags[@]}"
        fi
    else
        if is_boolean_yes "$MONGODB_ENABLE_NUMACTL"; then
            debug_execute numactl --interleave=all "$MONGODB_BIN_DIR/mongod" "${flags[@]}"
        else
            debug_execute "$MONGODB_BIN_DIR/mongod" "${flags[@]}"
        fi
    fi

    # wait until the server is up and answering queries
    if ! retry_while "mongodb_is_mongodb_started" "$MONGODB_INIT_RETRY_ATTEMPTS" "$MONGODB_INIT_RETRY_DELAY"; then
        error "MongoDB did not start"
        exit 1
    fi
}

########################
# Check if mongo is accepting requests
# Globals:
#   MONGODB_DATABASE and MONGODB_EXTRA_DATABASES
# Arguments:
#   None
# Returns:
#   Boolean
#########################
mongodb_is_mongodb_started() {
    local result

    result=$(
        mongodb_execute_print_output <<EOF
db
EOF
    )
    [[ -n "$result" ]]
}

########################
# Stop MongoDB
# Globals:
#   MONGODB_PID_FILE
# Arguments:
#   None
# Returns:
#   None
#########################
mongodb_stop() {
    ! is_mongodb_running && return
    info "Stopping MongoDB..."

    stop_service_using_pid "$MONGODB_PID_FILE"
    if ! retry_while "is_mongodb_not_running" "$MONGODB_INIT_RETRY_ATTEMPTS" "$MONGODB_INIT_RETRY_DELAY"; then
        error "MongoDB failed to stop"
        exit 1
    fi
}

########################
# Apply regex in MongoDB configuration file
# Globals:
#   MONGODB_CONF_FILE
# Arguments:
#   $1 - match regex
#   $2 - substitute regex
# Returns:
#   None
#########################
mongodb_config_apply_regex() {
    local -r match_regex="${1:?match_regex is required}"
    local -r substitute_regex="${2:?substitute_regex is required}"
    local -r conf_file_path="${3:-$MONGODB_CONF_FILE}"
    local mongodb_conf

    mongodb_conf="$(sed -E "s@$match_regex@$substitute_regex@" "$conf_file_path")"
    echo "$mongodb_conf" >"$conf_file_path"
}

########################
# Change common logging settings
# Globals:
#   MONGODB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mongodb_set_log_conf() {
    local -r conf_file_path="${1:-$MONGODB_CONF_FILE}"
    local -r conf_file_name="${conf_file_path#"$MONGODB_CONF_DIR"}"
    if ! mongodb_is_file_external "$conf_file_name"; then
        if [[ -n "$MONGODB_DISABLE_SYSTEM_LOG" ]]; then
            mongodb_config_apply_regex "quiet:.*" "quiet: $({ is_boolean_yes "$MONGODB_DISABLE_SYSTEM_LOG" && echo 'true'; } || echo 'false')" "$conf_file_path"
        fi
        if [[ -n "$MONGODB_SYSTEM_LOG_VERBOSITY" ]]; then
            mongodb_config_apply_regex "verbosity:.*" "verbosity: $MONGODB_SYSTEM_LOG_VERBOSITY" "$conf_file_path"
        fi
    else
        debug "$conf_file_name mounted. Skipping setting log settings"
    fi
}

########################
# Change journaling setting
# Globals:
#   MONGODB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mongodb_set_journal_conf() {
    local -r conf_file_path="${1:-$MONGODB_CONF_FILE}"
    local -r conf_file_name="${conf_file_path#"$MONGODB_CONF_DIR"}"
    local mongodb_conf

    if ! mongodb_is_file_external "$conf_file_name"; then
        # Disable journal.enabled since it is not supported from 7.0 on
        if [[ "$(mongodb_get_major_version)" -ge 7 ]]; then
            mongodb_conf="$(sed '/journal:/,/enabled: .*/d' "$conf_file_path")"
            echo "$mongodb_conf" >"$conf_file_path"
        else
            if [[ -n "$MONGODB_ENABLE_JOURNAL" ]]; then
                mongodb_conf="$(sed -E "/^ *journal:/,/^ *[^:]*:/s/enabled:.*/enabled: $({ is_boolean_yes "$MONGODB_ENABLE_JOURNAL" && echo 'true'; } || echo 'false')/" "$conf_file_path")"
                echo "$mongodb_conf" >"$conf_file_path"
            fi
        fi
    else
        debug "$conf_file_name mounted. Skipping setting log settings"
    fi
}

########################
# Change common storage settings
# Globals:
#   MONGODB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mongodb_set_storage_conf() {
    local -r conf_file_path="${1:-$MONGODB_CONF_FILE}"
    local -r conf_file_name="${conf_file_path#"$MONGODB_CONF_DIR"}"

    if ! mongodb_is_file_external "$conf_file_name"; then
        if [[ -n "$MONGODB_ENABLE_DIRECTORY_PER_DB" ]]; then
            mongodb_config_apply_regex "directoryPerDB:.*" "directoryPerDB: $({ is_boolean_yes "$MONGODB_ENABLE_DIRECTORY_PER_DB" && echo 'true'; } || echo 'false')" "$conf_file_path"
        fi
    else
        debug "$conf_file_name mounted. Skipping setting storage settings"
    fi
}

########################
# Change common network settings
# Globals:
#   MONGODB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mongodb_set_net_conf() {
    local -r conf_file_path="${1:-$MONGODB_CONF_FILE}"
    local -r conf_file_name="${conf_file_path#"$MONGODB_CONF_DIR"}"

    if ! mongodb_is_file_external "$conf_file_name"; then
        if [[ -n "$MONGODB_PORT_NUMBER" ]]; then
            mongodb_config_apply_regex "port:.*" "port: $MONGODB_PORT_NUMBER" "$conf_file_path"
        fi
        if [[ -n "$MONGODB_ENABLE_IPV6" ]]; then
            mongodb_config_apply_regex "ipv6:.*" "ipv6: $({ is_boolean_yes "$MONGODB_ENABLE_IPV6" && echo 'true'; } || echo 'false')" "$conf_file_path"
        fi
    else
        debug "$conf_file_name mounted. Skipping setting port and IPv6 settings"
    fi
}
########################
# Change bind ip address to 0.0.0.0
# Globals:
#   MONGODB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mongodb_set_listen_all_conf() {
    local -r conf_file_path="${1:-$MONGODB_CONF_FILE}"
    local -r conf_file_name="${conf_file_path#"$MONGODB_CONF_DIR"}"

    if ! mongodb_is_file_external "$conf_file_name"; then
        mongodb_config_apply_regex "#?bindIp:.*" "#bindIp:" "$conf_file_path"
        mongodb_config_apply_regex "#?bindIpAll:.*" "bindIpAll: true" "$conf_file_path"
    else
        debug "$conf_file_name mounted. Skipping IP binding to all addresses"
    fi
}

########################
# Disable javascript
# Globals:
#   MONGODB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mongodb_disable_javascript_conf() {
    local -r conf_file_path="${1:-$MONGODB_CONF_FILE}"
    local -r conf_file_name="${conf_file_path#"$MONGODB_CONF_DIR"}"

    if ! mongodb_is_file_external "$conf_file_name"; then
        if grep -q -E "^[[:space:]]*javascriptEnabled:" "$conf_file_path"; then
            mongodb_config_apply_regex "javascriptEnabled:.*" "javascriptEnabled: false" "$conf_file_path"
        else
            # The 'javascriptEnabled' property will be added to the config file
            mongodb_config_apply_regex "#?security:" "security:\n  javascriptEnabled: false" "$conf_file_path"
        fi
    else
        debug "$conf_file_name mounted. Skipping disabling javascript"
    fi
}

########################
# Enable Auth
# Globals:
#   MONGODB_*
# Arguments:
#   None
# Return
#   None
#########################
mongodb_set_auth_conf() {
    local -r conf_file_path="${1:-$MONGODB_CONF_FILE}"
    local -r conf_file_name="${conf_file_path#"$MONGODB_CONF_DIR"}"

    local authorization
    local localhostBypass

    localhostBypass="$(mongodb_conf_get "setParameter.enableLocalhostAuthBypass")"
    authorization="$(mongodb_conf_get "security.authorization")"
    if ! is_boolean_yes "$MONGODB_DISABLE_ENFORCE_AUTH"; then
        if [[ -n "$MONGODB_ROOT_PASSWORD" ]] || [[ -n "$MONGODB_INITIAL_PRIMARY_ROOT_PASSWORD" ]] || [[ -n "$MONGODB_PASSWORD" ]]; then
            if [[ "$authorization" = "disabled" ]]; then

                info "Enabling authentication..."
                # TODO: replace 'sed' calls with 'yq' once 'yq write' does not remove comments
                mongodb_config_apply_regex "#?authorization:.*" "authorization: enabled" "$conf_file_path"
                mongodb_config_apply_regex "#?enableLocalhostAuthBypass:.*" "enableLocalhostAuthBypass: false" "$conf_file_path"
            fi
        fi
    else
        warn "You have set MONGODB_DISABLE_ENFORCE_AUTH=true, settings enableLocalhostAuthBypass and security.authorization will remain with values '${localhostBypass}' and '${authorization}' respectively."
    fi
}

########################
# Read a configuration setting value
# Globals:
#   MONGODB_CONF_FILE
# Arguments:
#   $1 - key
# Returns:
#   Outputs the key to stdout (Empty response if key is not set)
#########################
mongodb_conf_get() {
    local key="${1:?missing key}"

    if [[ -r "$MONGODB_CONF_FILE" ]]; then
        local -r res="$(yq eval ".${key}" "$MONGODB_CONF_FILE")"
        if [[ ! "$res" = "null" ]]; then
            echo "$res"
        fi
    fi
}

########################
# Enable ReplicaSetMode
# Globals:
#   MONGODB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mongodb_set_replicasetmode_conf() {
    local -r conf_file_path="${1:-$MONGODB_CONF_FILE}"
    local -r conf_file_name="${conf_file_path#"$MONGODB_CONF_DIR"}"

    if ! mongodb_is_file_external "$conf_file_name"; then
        mongodb_config_apply_regex "#?replication:.*" "replication:" "$conf_file_path"
        mongodb_config_apply_regex "#?replSetName:" "replSetName:" "$conf_file_path"
        mongodb_config_apply_regex "#?enableMajorityReadConcern:.*" "enableMajorityReadConcern:" "$conf_file_path"
        if [[ -n "$MONGODB_REPLICA_SET_NAME" ]]; then
            mongodb_config_apply_regex "replSetName:.*" "replSetName: $MONGODB_REPLICA_SET_NAME" "$conf_file_path"
        fi
        if [[ -n "$MONGODB_ENABLE_MAJORITY_READ" ]]; then
            mongodb_config_apply_regex "enableMajorityReadConcern:.*" "enableMajorityReadConcern: $({ (is_boolean_yes "$MONGODB_ENABLE_MAJORITY_READ" || [[ "$(mongodb_get_major_version)" -eq 5 ]]) && echo 'true'; } || echo 'false')" "$conf_file_path"
        fi
    else
        debug "$conf_file_name mounted. Skipping replicaset mode enabling"
    fi
}

########################
# Create a MongoDB user and provide read/write permissions on a database
# Globals:
#   MONGODB_ROOT_PASSWORD
# Arguments:
#   $1 - Name of user
#   $2 - Password for user
#   $3 - Name of database (empty for default database)
# Returns:
#   None
#########################
mongodb_create_user() {
    local -r user="${1:?user is required}"
    local -r password="${2:-}"
    local -r database="${3:-}"
    local query

    if [[ -z "$password" ]]; then
        warn "Cannot create user '$user', no password provided"
        return 0
    fi
    # Build proper query (default database or specific one)
    query="db.getSiblingDB('$database').createUser({ user: '$user', pwd: '$password', roles: [{role: 'readWrite', db: '$database'}] })"
    [[ -z "$database" ]] && query="db.getSiblingDB(db.stats().db).createUser({ user: '$user', pwd: '$password', roles: [{role: 'readWrite', db: db.getSiblingDB(db.stats().db).stats().db }] })"
    # Create user, discarding mongo CLI output for clean logs
    info "Creating user '$user'..."
    mongodb_execute "$MONGODB_ROOT_USER" "$MONGODB_ROOT_PASSWORD" "" "127.0.0.1" "" "${MONGODB_SHELL_EXTRA_FLAGS} --tlsAllowInvalidHostnames" <<<"$query"
}

########################
# Create the appropriate users
# Globals:
#   MONGODB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mongodb_create_users() {
    info "Creating users..."

    if [[ -n "$MONGODB_ROOT_PASSWORD" ]] && ! [[ "$MONGODB_REPLICA_SET_MODE" =~ ^(secondary|arbiter|hidden) ]]; then
        info "Creating $MONGODB_ROOT_USER user..."
        mongodb_execute "" "" "" "127.0.0.1" "" "${MONGODB_SHELL_EXTRA_FLAGS} --tlsAllowInvalidHostnames" <<EOF
db.getSiblingDB('admin').createUser({ user: '$MONGODB_ROOT_USER', pwd: '$MONGODB_ROOT_PASSWORD', roles: [{role: 'root', db: 'admin'}] })
EOF
    fi

    if [[ -n "$MONGODB_USERNAME" ]]; then
        mongodb_create_user "$MONGODB_USERNAME" "$MONGODB_PASSWORD" "$MONGODB_DATABASE"
    fi
    if [[ -n "$MONGODB_EXTRA_USERNAMES" ]]; then
        local databases usernames passwords

        # Fill in arrays called databases, usernames and passwords with
        # information from matching environment variables.
        mongodb_auth extra
        if [[ -n "$MONGODB_EXTRA_DATABASES" ]]; then
            # Loop over the databases, usernames and passwords arrays, creating
            # each user in the database at the same index.
            for ((i = 0; i < ${#databases[@]}; i++)); do
                mongodb_create_user "${usernames[i]}" "${passwords[i]}" "${databases[i]}"
            done
        else
            # Loop over all users and create them within the default database.
            for ((i = 0; i < ${#usernames[@]}; i++)); do
                mongodb_create_user "${usernames[i]}" "${passwords[i]}"
            done
        fi
    fi

    if [[ -n "$MONGODB_METRICS_USERNAME" ]] && [[ -n "$MONGODB_METRICS_PASSWORD" ]]; then
        info "Creating '$MONGODB_METRICS_USERNAME' user..."
        mongodb_execute "$MONGODB_ROOT_USER" "$MONGODB_ROOT_PASSWORD" "" "127.0.0.1" "" "${MONGODB_SHELL_EXTRA_FLAGS} --tlsAllowInvalidHostnames" <<EOF
db.getSiblingDB('admin').createUser({ user: '$MONGODB_METRICS_USERNAME', pwd: '$MONGODB_METRICS_PASSWORD', roles: [{role: 'clusterMonitor', db: 'admin'},{ role: 'read', db: 'local' }] })
EOF
    fi
    info "Users created"
}

########################
# Set the path to the keyfile in mongodb.conf
# Globals:
#   MONGODB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mongodb_set_keyfile_conf() {
    local -r conf_file_path="${1:-$MONGODB_CONF_FILE}"
    local -r conf_file_name="${conf_file_path#"$MONGODB_CONF_DIR"}"

    if ! mongodb_is_file_external "$conf_file_name"; then
        mongodb_config_apply_regex "#?keyFile:.*" "keyFile: $MONGODB_KEY_FILE" "$conf_file_path"
    else
        debug "$conf_file_name mounted. Skipping keyfile location configuration"
    fi
}

########################
# Create the replica set key file
# Globals:
#   MONGODB_*
# Arguments:
#   $1 - key
# Returns:
#   None
#########################
mongodb_create_keyfile() {
    local -r key="${1:?key is required}"

    if ! mongodb_is_file_external "keyfile"; then
        info "Writing keyfile for replica set authentication..."
        echo "$key" >"$MONGODB_KEY_FILE"

        chmod 600 "$MONGODB_KEY_FILE"

        if am_i_root; then
            configure_permissions "$MONGODB_KEY_FILE" "$MONGODB_DAEMON_USER" "$MONGODB_DAEMON_GROUP" "" "600"
        else
            chmod 600 "$MONGODB_KEY_FILE"
        fi
    else
        debug "keyfile mounted. Skipping keyfile generation"
    fi
}

########################
# Get if primary node is initialized
# Globals:
#   MONGODB_*
# Arguments:
#   $1 - node
#   $2 - port
# Returns:
#   None
#########################
mongodb_is_primary_node_initiated() {
    local node="${1:?node is required}"
    local port="${2:?port is required}"
    local result
    result=$(
        mongodb_execute_print_output "$MONGODB_ROOT_USER" "$MONGODB_ROOT_PASSWORD" "admin" "127.0.0.1" "$MONGODB_PORT_NUMBER" "${MONGODB_SHELL_EXTRA_FLAGS} --tlsAllowInvalidHostnames" <<EOF
rs.initiate({"_id":"$MONGODB_REPLICA_SET_NAME", "members":[{"_id":0,"host":"$node:$port","priority":5}]})
EOF
    )

    # Code 23 is considered OK
    # It indicates that the node is already initialized
    if grep -q "already initialized" <<<"$result"; then
        warn "Node already initialized."
        return 0
    fi

    if ! grep -q "ok: 1" <<<"$result"; then
        warn "Problem initiating replica set
            request: rs.initiate({\"_id\":\"$MONGODB_REPLICA_SET_NAME\", \"members\":[{\"_id\":0,\"host\":\"$node:$port\",\"priority\":5}]})
            response: $result"
        return 1
    fi
}

########################
# Set "Default Write Concern"
# https://docs.mongodb.com/manual/reference/command/setDefaultRWConcern/
# Globals:
#   MONGODB_*
# Returns:
#   Boolean
#########################
mongodb_set_dwc() {
    local result

    result=$(
        mongodb_execute_print_output "$MONGODB_INITIAL_PRIMARY_ROOT_USER" "$MONGODB_INITIAL_PRIMARY_ROOT_PASSWORD" "admin" "$MONGODB_INITIAL_PRIMARY_HOST" "$MONGODB_INITIAL_PRIMARY_PORT_NUMBER" <<EOF
db.adminCommand({"setDefaultRWConcern" : 1, "defaultWriteConcern" : {"w" : "majority"}})
EOF
    )
    if grep -q "ok: 1" <<<"$result"; then
        debug 'Setting Default Write Concern to {"setDefaultRWConcern" : 1, "defaultWriteConcern" : {"w" : "majority"}}'
        return 0
    else
        return 1
    fi
}

########################
# Get if secondary node is pending
# Globals:
#   MONGODB_*
# Arguments:
#   $1 - node
#   $2 - port
# Returns:
#   Boolean
#########################
mongodb_is_secondary_node_pending() {
    local node="${1:?node is required}"
    local port="${2:?port is required}"
    local result

    mongodb_set_dwc

    debug "Adding secondary node ${node}:${port}"
    result=$(
        mongodb_execute_print_output "$MONGODB_INITIAL_PRIMARY_ROOT_USER" "$MONGODB_INITIAL_PRIMARY_ROOT_PASSWORD" "admin" "$MONGODB_INITIAL_PRIMARY_HOST" "$MONGODB_INITIAL_PRIMARY_PORT_NUMBER" <<EOF
rs.add({host: '$node:$port', priority: 0, votes: 0})
EOF
    )
    debug "$result"

    # Error code 103 is considered OK
    # It indicates a possibly desynced configuration, which will become resynced when the secondary joins the replicaset
    # Note: Error NewReplicaSetConfigurationIncompatible rejects the node addition so we need to filter it out
    if { grep -q "code: 103" <<<"$result"; } && ! { grep -q "NewReplicaSetConfigurationIncompatible" <<<"$result"; }; then
        warn "The ReplicaSet configuration is not aligned with primary node's configuration. Starting secondary node so it syncs with ReplicaSet..."
        return 0
    fi
    grep -q "ok: 1" <<<"$result"
}

########################
# Get if secondary node is ready to be granted voting rights
# Globals:
#   MONGODB_*
# Arguments:
#   $1 - node
#   $2 - port
# Returns:
#   Boolean
#########################
mongodb_is_secondary_node_ready() {
    local -r node="${1:?node is required}"
    local -r port="${2:?port is required}"

    debug "Waiting for the node to be marked as secondary"
    result=$(
        mongodb_execute_print_output "$MONGODB_INITIAL_PRIMARY_ROOT_USER" "$MONGODB_INITIAL_PRIMARY_ROOT_PASSWORD" "admin" "$MONGODB_INITIAL_PRIMARY_HOST" "$MONGODB_INITIAL_PRIMARY_PORT_NUMBER" <<EOF
rs.status().members.filter(m => m.name === '$node:$port' && m.stateStr === 'SECONDARY').length === 1
EOF
    )
    debug "$result"

    grep -q "true" <<<"$result"
}

########################
# Grant voting rights to secondary node
# Globals:
#   MONGODB_*
# Arguments:
#   $1 - node
#   $2 - port
# Returns:
#   Boolean
#########################
mongodb_configure_secondary_node_voting() {
    local -r node="${1:?node is required}"
    local -r port="${2:?port is required}"

    debug "Granting voting rights to the node"
    local reconfig_cmd="rs.reconfigForPSASet(member, cfg)"
    [[ "$(mongodb_get_version)" =~ ^4\.(0|2)\. ]] && reconfig_cmd="rs.reconfig(cfg)"
    result=$(
        mongodb_execute_print_output "$MONGODB_INITIAL_PRIMARY_ROOT_USER" "$MONGODB_INITIAL_PRIMARY_ROOT_PASSWORD" "admin" "$MONGODB_INITIAL_PRIMARY_HOST" "$MONGODB_INITIAL_PRIMARY_PORT_NUMBER" <<EOF
cfg = rs.conf()
member = cfg.members.findIndex(m => m.host === '$node:$port')
cfg.members[member].priority = 1
cfg.members[member].votes = 1
$reconfig_cmd
EOF
    )
    debug "$result"

    grep -q "ok: 1" <<<"$result"
}

########################
# Get if hidden node is pending
# Globals:
#   MONGODB_*
# Arguments:
#   $1 - node
#   $2 - port
# Returns:
#   Boolean
#########################
mongodb_is_hidden_node_pending() {
    local node="${1:?node is required}"
    local port="${2:?port is required}"
    local result

    mongodb_set_dwc

    debug "Adding hidden node ${node}:${port}"
    result=$(
        mongodb_execute_print_output "$MONGODB_INITIAL_PRIMARY_ROOT_USER" "$MONGODB_INITIAL_PRIMARY_ROOT_PASSWORD" "admin" "$MONGODB_INITIAL_PRIMARY_HOST" "$MONGODB_INITIAL_PRIMARY_PORT_NUMBER" <<EOF
rs.add({host: '$node:$port', hidden: true, priority: 0, votes: 0})
EOF
    )
    # Error code 103 is considered OK.
    # It indicates a possiblely desynced configuration,
    # which will become resynced when the hidden joins the replicaset.
    if grep -q "code: 103" <<<"$result"; then
        warn "The ReplicaSet configuration is not aligned with primary node's configuration. Starting hidden node so it syncs with ReplicaSet..."
        return 0
    fi
    grep -q "ok: 1" <<<"$result"
}

########################
# Get if arbiter node is pending
# Globals:
#   MONGODB_*
# Arguments:
#   $1 - node
#   $2 - port
# Returns:
#   Boolean
#########################
mongodb_is_arbiter_node_pending() {
    local node="${1:?node is required}"
    local port="${2:?port is required}"
    local result

    mongodb_set_dwc

    debug "Adding arbiter node ${node}:${port}"
    result=$(
        mongodb_execute_print_output "$MONGODB_INITIAL_PRIMARY_ROOT_USER" "$MONGODB_INITIAL_PRIMARY_ROOT_PASSWORD" "admin" "$MONGODB_INITIAL_PRIMARY_HOST" "$MONGODB_INITIAL_PRIMARY_PORT_NUMBER" <<EOF
rs.addArb('$node:$port')
EOF
    )
    grep -q "ok: 1" <<<"$result"
}

########################
# Configure primary node
# Globals:
#   MONGODB_*
# Arguments:
#   $1 - node
#   $2 - port
# Returns:
#   None
#########################
mongodb_configure_primary() {
    local -r node="${1:?node is required}"
    local -r port="${2:?port is required}"

    info "Configuring MongoDB primary node"
    wait-for-port --timeout 360 "$MONGODB_PORT_NUMBER"

    if ! retry_while "mongodb_is_primary_node_initiated $node $port" "$MONGODB_INIT_RETRY_ATTEMPTS" "$MONGODB_INIT_RETRY_DELAY"; then
        error "MongoDB primary node failed to get configured"
        exit 1
    fi
}

########################
# Wait for Confirmation
# Globals:
#   None
# Arguments:
#   $1 - node
#   $2 - port
# Returns:
#   Boolean
#########################
mongodb_wait_confirmation() {
    local -r node="${1:?node is required}"
    local -r port="${2:?port is required}"

    debug "Waiting until ${node}:${port} is added to the replica set..."
    if ! retry_while "mongodb_node_currently_in_cluster ${node} ${port}" "$MONGODB_INIT_RETRY_ATTEMPTS" "$MONGODB_INIT_RETRY_DELAY"; then
        error "Unable to confirm that ${node}:${port} has been added to the replica set!"
        exit 1
    else
        info "Node ${node}:${port} is confirmed!"
    fi
}

########################
# Check if primary node is ready
# Globals:
#   None
# Returns:
#   None
#########################
mongodb_is_primary_node_up() {
    local -r host="${1:?node is required}"
    local -r port="${2:?port is required}"
    local -r user="${3:?user is required}"
    local -r password="${4:-}"

    debug "Validating $host as primary node..."

    result=$(
        mongodb_execute_print_output "$user" "$password" "admin" "$host" "$port" <<EOF
db.isMaster().ismaster
EOF
    )
    grep -qE ".*\[direct:\s?\S+\]\s+admin>\s+true" <<<"$result"
}

########################
# Check if a MongoDB node is running
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   Boolean
#########################
mongodb_is_node_available() {
    local -r host="${1:?node is required}"
    local -r port="${2:?port is required}"
    local -r user="${3:?user is required}"
    local -r password="${4:-}"

    local result
    result=$(
        mongodb_execute_print_output "$user" "$password" "admin" "$host" "$port" <<EOF
db.getUsers()
EOF
    )
    if ! grep -q "user:" <<<"$result"; then
        # If no password was provided on first run
        # it may be the case that DB is up but has no users
        [[ -z $password ]] && grep -q "\[\]" <<<"$result"
    fi
}

########################
# Wait for node
# Globals:
#   MONGODB_*
# Returns:
#   Boolean
#########################
mongodb_wait_for_node() {
    local -r host="${1:?node is required}"
    local -r port="${2:?port is required}"
    local -r user="${3:?user is required}"
    local -r password="${4:-}"
    debug "Waiting for primary node..."

    info "Trying to connect to MongoDB server $host..."
    if ! retry_while "wait-for-port --host $host --timeout 10 $port" "$MONGODB_INIT_RETRY_ATTEMPTS" "$MONGODB_INIT_RETRY_DELAY"; then
        error "Unable to connect to host $host"
        exit 1
    else
        info "Found MongoDB server listening at $host:$port !"
    fi

    if ! retry_while "mongodb_is_node_available $host $port $user $password" "$MONGODB_INIT_RETRY_ATTEMPTS" "$MONGODB_INIT_RETRY_DELAY"; then
        error "Node $host did not become available"
        exit 1
    else
        info "MongoDB server listening and working at $host:$port !"
    fi
}

########################
# Wait for primary node
# Globals:
#   MONGODB_*
# Returns:
#   Boolean
#########################
mongodb_wait_for_primary_node() {
    local -r host="${1:?node is required}"
    local -r port="${2:?port is required}"
    local -r user="${3:?user is required}"
    local -r password="${4:-}"
    debug "Waiting for primary node..."

    mongodb_wait_for_node "$host" "$port" "$user" "$password"

    debug "Waiting for primary host $host to be ready..."
    if ! retry_while "mongodb_is_primary_node_up $host $port $user $password" "$MONGODB_INIT_RETRY_ATTEMPTS" "$MONGODB_INIT_RETRY_DELAY"; then
        error "Unable to validate $host as primary node in the replica set scenario!"
        exit 1
    else
        info "Primary node ready."
    fi
}

########################
# Configure secondary node
# Globals:
#   None
# Arguments:
#   $1 - node
#   $2 - port
# Returns:
#   None
#########################
mongodb_configure_secondary() {
    local -r node="${1:?node is required}"
    local -r port="${2:?port is required}"

    mongodb_wait_for_primary_node "$MONGODB_INITIAL_PRIMARY_HOST" "$MONGODB_INITIAL_PRIMARY_PORT_NUMBER" "$MONGODB_INITIAL_PRIMARY_ROOT_USER" "$MONGODB_INITIAL_PRIMARY_ROOT_PASSWORD"

    if mongodb_node_currently_in_cluster "$node" "$port"; then
        info "Node currently in the cluster"
    else
        info "Adding node to the cluster"
        if ! retry_while "mongodb_is_secondary_node_pending $node $port" "$MONGODB_INIT_RETRY_ATTEMPTS" "$MONGODB_INIT_RETRY_DELAY"; then
            error "Secondary node did not get ready"
            exit 1
        fi
        mongodb_wait_confirmation "$node" "$port"

        # Ensure that secondary nodes do not count as voting members until they are fully initialized
        # https://docs.mongodb.com/manual/reference/method/rs.add/#behavior
        if ! retry_while "mongodb_is_secondary_node_ready $node $port" "$MONGODB_INIT_RETRY_ATTEMPTS" "$MONGODB_INIT_RETRY_DELAY"; then
            error "Secondary node did not get marked as secondary"
            exit 1
        fi

        # Grant voting rights to node
        # https://docs.mongodb.com/manual/tutorial/modify-psa-replica-set-safely/
        if ! retry_while "mongodb_configure_secondary_node_voting $node $port" "$MONGODB_INIT_RETRY_ATTEMPTS" "$MONGODB_INIT_RETRY_DELAY"; then
            error "Secondary node did not get marked as secondary"
            exit 1
        fi

        # Mark node as readable. This is necessary in cases where the PVC is lost
        if is_boolean_yes "$MONGODB_SET_SECONDARY_OK"; then
            mongodb_execute_print_output "$MONGODB_INITIAL_PRIMARY_ROOT_USER" "$MONGODB_INITIAL_PRIMARY_ROOT_PASSWORD" "admin" <<EOF
rs.secondaryOk()
EOF
        fi

    fi
}

########################
# Configure hidden node
# Globals:
#   None
# Arguments:
#   $1 - node
#   $2 - port
# Returns:
#   None
#########################
mongodb_configure_hidden() {
    local -r node="${1:?node is required}"
    local -r port="${2:?port is required}"

    mongodb_wait_for_primary_node "$MONGODB_INITIAL_PRIMARY_HOST" "$MONGODB_INITIAL_PRIMARY_PORT_NUMBER" "$MONGODB_INITIAL_PRIMARY_ROOT_USER" "$MONGODB_INITIAL_PRIMARY_ROOT_PASSWORD"

    if mongodb_node_currently_in_cluster "$node" "$port"; then
        info "Node currently in the cluster"
    else
        info "Adding hidden node to the cluster"
        if ! retry_while "mongodb_is_hidden_node_pending $node $port" "$MONGODB_INIT_RETRY_ATTEMPTS" "$MONGODB_INIT_RETRY_DELAY"; then
            error "Hidden node did not get ready"
            exit 1
        fi
        mongodb_wait_confirmation "$node" "$port"
    fi
}

########################
# Configure arbiter node
# Globals:
#   None
# Arguments:
#   $1 - node
#   $2 - port
# Returns:
#   None
#########################
mongodb_configure_arbiter() {
    local -r node="${1:?node is required}"
    local -r port="${2:?port is required}"

    mongodb_wait_for_primary_node "$MONGODB_INITIAL_PRIMARY_HOST" "$MONGODB_INITIAL_PRIMARY_PORT_NUMBER" "$MONGODB_INITIAL_PRIMARY_ROOT_USER" "$MONGODB_INITIAL_PRIMARY_ROOT_PASSWORD"

    if mongodb_node_currently_in_cluster "$node" "$port"; then
        info "Node currently in the cluster"
    else
        info "Configuring MongoDB arbiter node"
        if ! retry_while "mongodb_is_arbiter_node_pending $node $port" "$MONGODB_INIT_RETRY_ATTEMPTS" "$MONGODB_INIT_RETRY_DELAY"; then
            error "Arbiter node did not get ready"
            exit 1
        fi
        mongodb_wait_confirmation "$node" "$port"
    fi
}

########################
# Get if the replica set in synced
# Globals:
#   MONGODB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mongodb_is_not_in_sync() {
    local result

    result=$(
        mongodb_execute_print_output "$MONGODB_INITIAL_PRIMARY_ROOT_USER" "$MONGODB_INITIAL_PRIMARY_ROOT_PASSWORD" "admin" "$MONGODB_INITIAL_PRIMARY_HOST" "$MONGODB_INITIAL_PRIMARY_PORT_NUMBER" <<EOF
db.printSecondaryReplicationInfo()
EOF
    )

    grep -q -E "'0 secs" <<<"$result"
}

########################
# Wait until initial data sync complete
# Globals:
#   MONGODB_LOG_FILE
# Arguments:
#   None
# Returns:
#   None
#########################
mongodb_wait_until_sync_complete() {
    info "Waiting until initial data sync is complete..."

    if ! retry_while "mongodb_is_not_in_sync" "$MONGODB_INIT_RETRY_ATTEMPTS" "$MONGODB_INIT_RETRY_DELAY" 1; then
        error "Initial data sync did not finish after $((MONGODB_INIT_RETRY_ATTEMPTS * MONGODB_INIT_RETRY_DELAY)) seconds"
        exit 1
    else
        info "initial data sync completed"
    fi
}

########################
# Get current status of the replicaset
# Globals:
#   MONGODB_*
# Arguments:
#   $1 - node
#   $2 - port
# Returns:
#   None
#########################
mongodb_node_currently_in_cluster() {
    local -r node="${1:?node is required}"
    local -r port="${2:?port is required}"
    local result

    result=$(
        mongodb_execute "$MONGODB_INITIAL_PRIMARY_ROOT_USER" "$MONGODB_INITIAL_PRIMARY_ROOT_PASSWORD" "admin" "$MONGODB_INITIAL_PRIMARY_HOST" "$MONGODB_INITIAL_PRIMARY_PORT_NUMBER" <<EOF
rs.status().members
EOF
    )
    grep -q -E "'${node}:${port}'" <<<"$result"
}

########################
# Configure Replica Set
# Globals:
#   MONGODB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mongodb_configure_replica_set() {
    local node
    local port

    info "Configuring MongoDB replica set..."

    node=$(get_mongo_hostname)
    port=$(get_mongo_port)
    mongodb_restart

    case "$MONGODB_REPLICA_SET_MODE" in
    "primary")
        mongodb_configure_primary "$node" "$port"
        ;;
    "secondary")
        mongodb_configure_secondary "$node" "$port"
        ;;
    "arbiter")
        mongodb_configure_arbiter "$node" "$port"
        ;;
    "hidden")
        mongodb_configure_hidden "$node" "$port"
        ;;
    "dynamic")
        # Do nothing
        ;;
    esac

    if [[ "$MONGODB_REPLICA_SET_MODE" = "secondary" ]]; then
        mongodb_wait_until_sync_complete
    fi
}

########################
# Configure permisions
# Globals:
#   None
# Arguments:
#   $1 - path array
#   $2 - user
#   $3 - group
#   $4 - mode for directories
#   $5 - mode for files
# Returns:
#   None
#########################
configure_permissions() {
    local -r path=${1:?path is required}
    local -r user=${2:?user is required}
    local -r group=${3:?group is required}
    local -r dir_mode=${4:-false}
    local -r file_mode=${5:-false}

    if [[ -e "$path" ]]; then
        if [[ -n $dir_mode ]] && [[ -n $file_mode ]]; then
            find -L "$path" -type d -exec chmod "$dir_mode" {} \;
        fi
        if [[ -n $file_mode ]]; then
            find -L "$path" -type f -exec chmod "$file_mode" {} \;
        fi
        chown -LR "$user":"$group" "$path"
    else
        warn "$path do not exist."
    fi
}

###############
# Initialize MongoDB service
# Globals:
#   MONGODB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mongodb_initialize() {
    local localhostBypass
    local authorization
    info "Initializing MongoDB..."

    rm -f "$MONGODB_PID_FILE"
    mongodb_copy_mounted_config
    mongodb_set_net_conf "$MONGODB_CONF_FILE"
    mongodb_set_log_conf "$MONGODB_CONF_FILE"
    mongodb_set_journal_conf "$MONGODB_CONF_FILE"
    mongodb_set_storage_conf "$MONGODB_CONF_FILE"
    is_boolean_yes "$MONGODB_DISABLE_JAVASCRIPT" && mongodb_disable_javascript_conf "$MONGODB_CONF_FILE"

    # Create the ReplicaSet keyFile before Mongo starts in case it is referenced in the $MONGODB_CONF_FILE
    if [[ -n "$MONGODB_REPLICA_SET_MODE" ]]; then
        if [[ -n "$MONGODB_REPLICA_SET_KEY" ]]; then
            mongodb_create_keyfile "$MONGODB_REPLICA_SET_KEY"
            mongodb_set_keyfile_conf "$MONGODB_CONF_FILE"
        fi
    fi

    if is_dir_empty "$MONGODB_DATA_DIR/db"; then
        info "Deploying MongoDB from scratch..."
        ensure_dir_exists "$MONGODB_DATA_DIR/db"
        am_i_root && chown -R "$MONGODB_DAEMON_USER" "$MONGODB_DATA_DIR/db"

        mongodb_start_bg "$MONGODB_CONF_FILE"

        localhostBypass="$(mongodb_conf_get "setParameter.enableLocalhostAuthBypass")"
        authorization="$(mongodb_conf_get "security.authorization")"
        if [[ "$localhostBypass" != "true" && "$authorization" == "enabled" ]]; then
            warn "Your mongodb.conf has authentication enforced, users creation will be skipped. If you'd like automatic user creation, you can disable it and it will be enabled after user creation."
        else
            mongodb_create_users
            mongodb_set_auth_conf "$MONGODB_CONF_FILE"
        fi
        if [[ -n "$MONGODB_REPLICA_SET_MODE" ]]; then
            mongodb_set_replicasetmode_conf "$MONGODB_CONF_FILE"
            mongodb_set_listen_all_conf "$MONGODB_CONF_FILE"
            mongodb_configure_replica_set
        fi

        mongodb_stop
    else
        mongodb_set_auth_conf "$MONGODB_CONF_FILE"
        info "Deploying MongoDB with persisted data..."
        if [[ -n "$MONGODB_REPLICA_SET_MODE" ]]; then
            if [[ "$MONGODB_REPLICA_SET_MODE" = "dynamic" ]]; then
                mongodb_ensure_dynamic_mode_consistency
            fi
            mongodb_set_replicasetmode_conf "$MONGODB_CONF_FILE"
        fi
    fi
}

########################
# Check that the dynamic instance configuration is consistent
# Globals:
#   MONGODB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mongodb_ensure_dynamic_mode_consistency() {
    if grep -q -E "^[[:space:]]*replSetName: $MONGODB_REPLICA_SET_NAME" "$MONGODB_CONF_FILE"; then
        info "ReplicaSetMode set to \"dynamic\" and replSetName different from config file."
        info "Dropping local database ..."
        mongodb_start_bg "$MONGODB_CONF_FILE"
        mongodb_drop_local_database
        mongodb_stop
    fi
}

########################
# Check if a given file was mounted externally
# Globals:
#   MONGODB_*
# Arguments:
#   $1 - Filename
# Returns:
#   true if the file was mounted externally, false otherwise
#########################
mongodb_is_file_external() {
    local -r filename="${1:?file_is_missing}"
    if [[ -f "${MONGODB_MOUNTED_CONF_DIR}/${filename}" ]] || { [[ -f "${MONGODB_CONF_DIR}/${filename}" ]] && ! test -w "${MONGODB_CONF_DIR}/${filename}"; }; then
        true
    else
        false
    fi
}

########################
# Get MongoDB version
# Globals:
#   MONGODB_*
# Arguments:
#   None
# Returns:
#   version
#########################
mongodb_get_version() {
    mongod --version 2>/dev/null | awk -F\" '/"version"/ {print $4}'
}

########################
# Get MongoDB major version
# Globals:
#   MONGODB_*
# Arguments:
#   None
# Returns:
#   major version
#########################
mongodb_get_major_version() {
    # shellcheck disable=SC2005
    echo "$(mongodb_get_version)" | cut --delimiter='.' --fields=1
}

########################
# Run custom initialization scripts
# Globals:
#   MONGODB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mongodb_custom_init_scripts() {
    local run_custom_init_scripts="no"
    if [[ -n "$MONGODB_REPLICA_SET_MODE" ]]; then
        if [[ "$MONGODB_REPLICA_SET_MODE" != "primary" ]]; then
            debug "Skipping loading custom scripts on non-primary nodes..."
        elif [[ -n $(find "$MONGODB_INITSCRIPTS_DIR/" -type f -regex ".*\.\(sh\|js\|js.gz\)") ]]; then
            if [[ -f "$MONGODB_VOLUME_DIR/.user_scripts_initialized" ]]; then
                debug "Skipping loading custom scripts on container restarts..."
            else
                run_custom_init_scripts="yes"
            fi
        fi
    elif [[ -n $(find "$MONGODB_INITSCRIPTS_DIR/" -type f -regex ".*\.\(sh\|js\|js.gz\)") ]]; then
        if [[ -f "$MONGODB_VOLUME_DIR/.user_scripts_initialized" ]]; then
            debug "Skipping loading custom scripts on container restarts..."
        else
            run_custom_init_scripts="yes"
        fi
    fi
    if is_boolean_yes "$run_custom_init_scripts"; then
        info "Loading user's custom files from $MONGODB_INITSCRIPTS_DIR ..."
        mongodb_start_bg "$MONGODB_CONF_FILE"
        local -r tmp_file=/tmp/filelist
        local mongo_user
        local mongo_pass
        if [[ -n "$MONGODB_ROOT_PASSWORD" ]]; then
            mongo_user="$MONGODB_ROOT_USER"
            mongo_pass="$MONGODB_ROOT_PASSWORD"
        elif [[ -n "$MONGODB_INITIAL_PRIMARY_ROOT_PASSWORD" ]]; then
            mongo_user="$MONGODB_ROOT_USER"
            mongo_pass="$MONGODB_INITIAL_PRIMARY_ROOT_PASSWORD"
        else
            local databases usernames passwords

            mongodb_auth
            mongo_user="${usernames[0]}"
            mongo_pass="${passwords[0]}"
        fi
        find "$MONGODB_INITSCRIPTS_DIR" -type f -regex ".*\.\(sh\|js\|js.gz\)" | sort >$tmp_file
        while read -r f; do
            case "$f" in
            *.sh)
                if [[ -x "$f" ]]; then
                    debug "Executing $f"
                    "$f"
                else
                    debug "Sourcing $f"
                    . "$f"
                fi
                ;;
            *.js)
                debug "Executing $f"
                mongodb_execute_print_output "$mongo_user" "$mongo_pass" <"$f"
                ;;
            *.js.gz)
                debug "Executing $f"
                gunzip -c "$f" | mongodb_execute_print_output "$mongo_user" "$mongo_pass"
                ;;
            *) debug "Ignoring $f" ;;
            esac
        done <$tmp_file
        touch "$MONGODB_VOLUME_DIR"/.user_scripts_initialized
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
#   $6 - Extra arguments (default $MONGODB_SHELL_EXTRA_FLAGS)
# Returns:
#   output of mongo query
########################
mongodb_execute_print_output() {
    local -r user="${1:-}"
    local -r password="${2:-}"
    local -r database="${3:-}"
    local -r host="${4:-$(get_mongo_hostname)}"
    local -r port="${5:-$MONGODB_PORT_NUMBER}"
    local -r extra_args="${6:-$MONGODB_SHELL_EXTRA_FLAGS}"
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

    "$MONGODB_BIN_DIR/mongosh" "${args[@]}"
}

########################
# Execute an arbitrary query/queries against the running MongoDB service,
# discard its output unless BITNAMI_DEBUG is true
# Stdin:
#   Query/queries to execute
# Globals:
#   BITNAMI_DEBUG
# Arguments:
#   $1 - User to run queries
#   $2 - Password
#   $3 - Database where to run the queries
#   $4 - Host (default to result of get_mongo_hostname function)
#   $5 - Port (default $MONGODB_PORT_NUMBER)
#   $6 - Extra arguments (default $MONGODB_SHELL_EXTRA_FLAGS)
# Returns:
#   None
########################
mongodb_execute() {
    debug_execute mongodb_execute_print_output "$@"
}

# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC2148

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
#   $6 - Extra arguments (default $MONGODB_SHELL_EXTRA_FLAGS)
# Returns:
#   None
########################
mongodb_execute() {
    local -r user="${1:-}"
    local -r password="${2:-}"
    local -r database="${3:-}"
    local -r host="${4:-$(get_mongo_hostname)}"
    local -r port="${5:-$MONGODB_PORT_NUMBER}"
    local -r extra_args="${6:-$MONGODB_SHELL_EXTRA_FLAGS}"
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

    "$MONGODB_BIN_DIR/mongosh" "${args[@]}"
}
