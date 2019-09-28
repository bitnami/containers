#!/bin/bash

#
# Bitnami MongoDB library

# shellcheck disable=SC1090
# shellcheck disable=SC1091

# Load Generic Libraries
. /libfile.sh
. /liblog.sh
. /libservice.sh
. /libvalidations.sh
. /libos.sh
. /libfs.sh
. /libnet.sh


########################
# Loads global variables used on MongoDB configuration.
# Globals:
#   MONGODB_*
# Arguments:
#   None
# Returns:
#   Series of exports to be used as 'eval' arguments
#########################
mongodb_env() {
    cat <<"EOF"
# Paths
export MONGODB_PERSIST_DIR="/bitnami"
export MONGODB_DATA_DIR="$MONGODB_PERSIST_DIR/mongodb/data"
export MONGODB_BASE_DIR="/opt/bitnami/mongodb"
export MONGODB_CONFIG_DIR="$MONGODB_BASE_DIR/conf"
export MONGODB_LOG_DIR="$MONGODB_BASE_DIR/logs"
export MONGODB_TMP_DIR="$MONGODB_BASE_DIR/tmp"
export MONGODB_BIN_DIR="$MONGODB_BASE_DIR/bin"
export MONGODB_TEMPLATES_DIR="$MONGODB_BASE_DIR/templates"
export MONGODB_TEMPLATES_FILE="$MONGODB_TEMPLATES_DIR/mongodb.conf.tpl"
export MONGODB_CONFIG_FILE="$MONGODB_CONFIG_DIR/mongodb.conf"
export MONGODB_KEY_FILE="$MONGODB_CONFIG_DIR/keyfile"
export MONGODB_PID_FILE="$MONGODB_TMP_DIR/mongodb.pid"
export MONGODB_LOG_FILE="$MONGODB_LOG_DIR/mongodb.log"
export MONGODB_INITSCRIPTS_DIR=/docker-entrypoint-initdb.d
export PATH="$MONGODB_BIN_DIR:$PATH"

# Users
export MONGODB_DAEMON_USER="mongo"
export MONGODB_DAEMON_GROUP="mongo"

# Settings
export MONGODB_HOST="${MONGODB_HOST:-}"
export MONGODB_PORT_NUMBER="${MONGODB_PORT_NUMBER:-27017}"
export MONGODB_PASSWORD="${MONGODB_PASSWORD:-}"
export MONGODB_ROOT_PASSWORD="${MONGODB_ROOT_PASSWORD:-}"
export MONGODB_USERNAME="${MONGODB_USERNAME:-}"
export MONGODB_REPLICA_SET_KEY="${MONGODB_REPLICA_SET_KEY:-}"
export MONGODB_REPLICA_SET_MODE="${MONGODB_REPLICA_SET_MODE:-}"
export MONGODB_REPLICA_SET_NAME="${MONGODB_REPLICA_SET_NAME:-replicaset}"
export MONGODB_ENABLE_MAJORITY_READ="${MONGODB_ENABLE_MAJORITY_READ:-yes}"
export ALLOW_EMPTY_PASSWORD="${ALLOW_EMPTY_PASSWORD:-no}"
export MONGODB_EXTRA_FLAGS="${MONGODB_EXTRA_FLAGS:-}"
export MONGODB_CLIENT_EXTRA_FLAGS="${MONGODB_CLIENT_EXTRA_FLAGS:-}"
export MONGODB_ADVERTISED_HOSTNAME="${MONGODB_ADVERTISED_HOSTNAME:-}"
export MONGODB_DATABASE="${MONGODB_DATABASE:-}"
export MONGODB_DISABLE_SYSTEM_LOG="${MONGODB_DISABLE_SYSTEM_LOG:-no}"
export MONGODB_ENABLE_DIRECTORY_PER_DB="${MONGODB_ENABLE_DIRECTORY_PER_DB:-no}"
export MONGODB_ENABLE_IPV6="${MONGODB_ENABLE_IPV6:-no}"
export MONGODB_PRIMARY_HOST="${MONGODB_PRIMARY_HOST:-}"
export MONGODB_PRIMARY_PORT_NUMBER="${MONGODB_PRIMARY_PORT_NUMBER:-27017}"
export MONGODB_PRIMARY_ROOT_PASSWORD="${MONGODB_PRIMARY_ROOT_PASSWORD:-}"
export MONGODB_PRIMARY_ROOT_USER="${MONGODB_PRIMARY_ROOT_USER:-root}"
export MONGODB_SYSTEM_LOG_VERBOSITY="${MONGODB_SYSTEM_LOG_VERBOSITY:-0}"
EOF
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
in the primary node and MONGODB_PRIMARY_ROOT_PASSWORD in the rest of nodes"
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }

    if [[ -n "$MONGODB_REPLICA_SET_MODE" ]]; then
        if [[ -z "$MONGODB_ADVERTISED_HOSTNAME" ]]; then
            warn "In order to use hostnames instead of IPs your should set MONGODB_ADVERTISED_HOSTNAME"
        fi
        if [[ "$MONGODB_REPLICA_SET_MODE" =~ ^(secondary|arbiter) ]]; then
            if [[ -z "$MONGODB_PRIMARY_HOST" ]]; then
                error_message="In order to configure MongoDB as secondary or arbiter node \
you need to provide the MONGODB_PRIMARY_HOST env var"
                print_validation_error "$error_message"
            fi
            if ([[ -n "$MONGODB_PRIMARY_ROOT_PASSWORD" ]] && [[ -z "$MONGODB_REPLICA_SET_KEY" ]]) || \
               ([[ -z "$MONGODB_PRIMARY_ROOT_PASSWORD" ]] && [[ -n "$MONGODB_REPLICA_SET_KEY" ]]); then
                print_validation_error "$replicaset_error_message"
            fi
            if [[ -n "$MONGODB_ROOT_PASSWORD" ]]; then
                error_message="MONGODB_ROOT_PASSWORD shouldn't be set on a 'non-primary' node!"
                print_validation_error "$error_message"
            fi
        elif [[ "$MONGODB_REPLICA_SET_MODE" = "primary" ]]; then
            if ([[ -n "$MONGODB_ROOT_PASSWORD" ]] && [[ -z "$MONGODB_REPLICA_SET_KEY" ]]) || \
               ([[ -z "$MONGODB_ROOT_PASSWORD" ]] && [[ -n "$MONGODB_REPLICA_SET_KEY" ]]); then
                print_validation_error "$replicaset_error_message"
            fi
            if [[ -n "$MONGODB_PRIMARY_ROOT_PASSWORD" ]]; then
                error_message="MONGODB_PRIMARY_ROOT_PASSWORD shouldn't be set on a 'primary' node!"
                print_validation_error "$error_message"
            fi
            if [[ -z "$MONGODB_ROOT_PASSWORD" ]]; then
                error_message="MONGODB_ROOT_PASSWORD have to be set on a 'primary' node!"
                print_validation_error "$error_message"
            fi
        else
            error_message="You set the environment variable MONGODB_REPLICA_SET_MODE with an invalid value. \
Available options are 'primary/secondary/arbiter'"
            print_validation_error "$error_message"
        fi
    fi

    if [[ -n "$MONGODB_REPLICA_SET_KEY" ]] && (( ${#MONGODB_REPLICA_SET_KEY} < 5 )); then
        error_message="MONGODB_REPLICA_SET_KEY must be, at least, 5 characters long!"
        print_validation_error "$error_message"
    fi

    if is_boolean_yes "$ALLOW_EMPTY_PASSWORD"; then
        warn "You set the environment variable ALLOW_EMPTY_PASSWORD=${ALLOW_EMPTY_PASSWORD}. For safety reasons, do not use this flag in a production environment."
    elif [[ -n "$MONGODB_USERNAME" ]] && [[ -z "$MONGODB_PASSWORD" ]]; then
        error_message="The MONGODB_PASSWORD environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow the container to be started with blank passwords. This is recommended only for development."
        print_validation_error "$error_message"
    fi

    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}


########################
# Creates MongoDB configuration file
# Globals:
#   MONGODB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mongodb_create_config() {
    debug "Creating main configuration file..."

    render-template "$MONGODB_TEMPLATES_FILE" > "$MONGODB_CONFIG_FILE"
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
    local user="${1:-}"
    local password="${2:-}"
    local database="${3:-}"
    local host="${4:-$(get_mongo_hostname)}"
    local port="${5:-$MONGODB_PORT_NUMBER}"
    local extra_args="${6:-$MONGODB_CLIENT_EXTRA_FLAGS}"
    local result

    # If password is empty it means no auth, do not specify user
    [[ -z "$password" ]] && user=""

    local -a args=("--host" "$host" "--port" "$port")
    [[ -n "$user" ]] && args+=("-u" "$user")
    [[ -n "$password" ]] && args+=("-p" "$password")
    [[ -n "$extra_args" ]] && args+=($extra_args)
    [[ -n "$database" ]] && args+=("$database")

    "$MONGODB_BIN_DIR/mongo" "${args[@]}"
}

########################
# Determine the hostname by which to contact the locally running mongo daemon
# Returns:
#   The value of $MONGODB_ADVERTISED_HOSTNAME or the current host address
########################
get_mongo_hostname() {
    [[ -n "$MONGODB_ADVERTISED_HOSTNAME" ]] && echo "$MONGODB_ADVERTISED_HOSTNAME" || echo $(get_machine_ip)
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
    [[ -n "$MONGODB_PASSWORD" ]] && command=("${command[@]}" "$MONGODB_USERNAME" "$MONGODB_PASSWORD")
    "${command[@]}" <<EOF
db.getSiblingDB('local').dropDatabase()
EOF
}

########################
# Checks if MongoDB is running
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
# Checks if MongoDB is not running
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
    mongodb_start_bg
}

########################
# Start MongoDB server in the background and waits until it's ready
# Globals:
#   MONGODB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mongodb_start_bg() {
    # Use '--fork' option to enable daemon mode
    # ref: https://docs.mongodb.com/manual/reference/program/mongod/#cmdoption-mongod-fork
    local flags=("--fork" "--config=$MONGODB_CONFIG_FILE")
    [[ -z "${MONGODB_EXTRA_FLAGS:-}" ]] || flags+=(${MONGODB_EXTRA_FLAGS})

    debug "Starting MongoDB in background..."

    is_mongodb_running && return

    if am_i_root; then
        debug_execute gosu "$MONGODB_DAEMON_USER" "$MONGODB_BIN_DIR/mongod" "${flags[@]}"
    else
       debug_execute "$MONGODB_BIN_DIR/mongod" "${flags[@]}"
    fi

    # wait until the server is up and answering queries
    retry_while "mongodb_is_mongodb_started" 25
}

########################
# Check if mongo is accepting requests
# Globals:
#   MONGODB_DATABASE
# Arguments:
#   None
# Returns:
#   Boolean
#########################
mongodb_is_mongodb_started() {
    local result

    result=$(mongodb_execute 2>/dev/null <<EOF
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
    retry_while "is_mongodb_not_running"
}

########################
# Check if MongoDB configuration file is writable by current user
# Globals:
#   MONGODB_CONFIG_FILE
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_mongodb_config_writable() {
    if [[ -w "$MONGODB_CONFIG_FILE" ]]; then
        true
    else
        warn "\"$MONGODB_CONFIG_FILE\" is not writable by current user. Skipping modifications..."
        false
    fi
}

########################
# Apply regex in MongoDB configuration file
# Globals:
#   MONGODB_CONFIG_FILE
# Arguments:
#   $1 - match regex
#   $2 - substitute regex
# Returns:
#   None
#########################
mongodb_config_apply_regex() {
  local match_regex="${1:?match_regex is required}"
  local substitute_regex="${2:?substitute_regex is required}"
  local mongodb_conf

  if is_mongodb_config_writable; then
      # We cannot use 'sed in-place' feature when the configuration file is mounted as a ConfigMap
      mongodb_conf="$(sed -E "s@$match_regex@$substitute_regex@" "$MONGODB_CONFIG_FILE")"
      echo "$mongodb_conf" > "$MONGODB_CONFIG_FILE"
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
mongodb_enable_auth() {
    local authorization

    if [[ -n "$MONGODB_ROOT_PASSWORD" ]] || [[ -n "$MONGODB_PASSWORD" ]]; then
        authorization="$(yq read "$MONGODB_CONFIG_FILE" security.authorization)"
        if [[ "$authorization" = "disabled" ]]; then

            info "Enabling authentication..."
            # TODO: replace 'sed' calls with 'yq' once 'yq write' does not remove comments
            mongodb_config_apply_regex "#?authorization:.*" "authorization: enabled"
            mongodb_config_apply_regex "#?enableLocalhostAuthBypass:.*" "enableLocalhostAuthBypass: false"
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
mongodb_enable_replicasetmode() {
    mongodb_config_apply_regex "#?replication:.*" "replication:"
    mongodb_config_apply_regex "#?replSetName:.*" "replSetName: $MONGODB_REPLICA_SET_NAME"
    mongodb_config_apply_regex "#?enableMajorityReadConcern:.*" "enableMajorityReadConcern: $(is_boolean_yes "$MONGODB_ENABLE_MAJORITY_READ" && echo 'true' || echo 'false')"
}

########################
# Creates the appropriate users
# Globals:
#   MONGODB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mongodb_create_users() {
    local result

    info "Creating users..."
    if [[ -n "$MONGODB_ROOT_PASSWORD" ]] && ! [[ "$MONGODB_REPLICA_SET_MODE"  =~ ^(secondary|arbiter) ]]; then
        info "Creating root user..."
        result=$(mongodb_execute <<EOF
db.getSiblingDB('admin').createUser({ user: 'root', pwd: '$MONGODB_ROOT_PASSWORD', roles: [{role: 'root', db: 'admin'}] })
EOF
)
    fi

    mongodb_enable_auth

    if [[ -n "$MONGODB_USERNAME" ]] && [[ -n "$MONGODB_PASSWORD" ]] && [[ -n "$MONGODB_DATABASE" ]]; then
        info "Creating '$MONGODB_USERNAME' user..."

        result=$(mongodb_execute 'root' "$MONGODB_ROOT_PASSWORD" <<EOF
db.getSiblingDB('$MONGODB_DATABASE').createUser({ user: '$MONGODB_USERNAME', pwd: '$MONGODB_PASSWORD', roles: [{role: 'readWrite', db: '$MONGODB_DATABASE'}] })
EOF
)
    fi
    info "Users created"
}

########################
# Configures the key file
# Globals:
#   MONGODB_*
# Arguments:
#   $1 - keyfile
#   $2 - key
# Returns:
#   None
#########################
mongodb_configure_key_file() {
    local keyfile="${1:?keyfile is required}"
    local key="${2:?key is required}"

    info "Writing keyfile for replica set authentication: $key $keyfile"
    echo "$key" > "$keyfile"

    chmod 600 "$keyfile"

    if am_i_root; then
        configure_permissions "$keyfile" "$MONGODB_DAEMON_USER" "$MONGODB_DAEMON_GROUP" "" "600"
    else
        chmod 600 "$keyfile"
    fi

    mongodb_config_apply_regex "#?authorization:.*" "authorization: enabled"
    mongodb_config_apply_regex "#?keyFile:.*" "keyFile: $keyfile"
}

########################
# Gets if primary node is initialized
# Globals:
#   MONGODB_*
# Arguments:
#   $1 - node
# Returns:
#   None
#########################
mongodb_is_primary_node_initiated() {
    local node="${1:?node is required}"
    local result

    result=$(mongodb_execute "root" "$MONGODB_ROOT_PASSWORD" "admin" "$node" "$MONGODB_PORT_NUMBER" <<EOF
rs.initiate({"_id":"$MONGODB_REPLICA_SET_NAME","members":[{"_id":0,"host":"$node:$MONGODB_PORT_NUMBER","priority":5}]})
EOF
)

    if grep "\"ok\" : 1" <<< "$result" > /dev/null; then
        true
    else
        false
    fi
}

########################
# Gets if secondary node is pending
# Globals:
#   MONGODB_*
# Arguments:
#   $1 - node
# Returns:
#   Boolean
#########################
mongodb_is_secondary_node_pending() {
    local node="${1:?node is required}"
    local result

    result=$(mongodb_execute "$MONGODB_PRIMARY_ROOT_USER" "$MONGODB_PRIMARY_ROOT_PASSWORD" "admin" "$MONGODB_PRIMARY_HOST" "$MONGODB_PRIMARY_PORT_NUMBER" <<EOF
rs.add('$node:$MONGODB_PORT_NUMBER')
EOF
)
    if grep "\"ok\" : 1" <<< "$result" > /dev/null; then
        true
    else
        false
    fi
}

########################
# Gets if arbiter node is pending
# Globals:
#   MONGODB_*
# Arguments:
#   $1 - node
# Returns:
#   Boolean
#########################
mongodb_is_arbiter_node_pending() {
    local node="${1:?node is required}"
    local result

    result=$(mongodb_execute "$MONGODB_PRIMARY_ROOT_USER" "$MONGODB_PRIMARY_ROOT_PASSWORD" "admin" "$MONGODB_PRIMARY_HOST" "$MONGODB_PRIMARY_PORT_NUMBER" <<EOF
rs.addArb('$node:$MONGODB_PORT_NUMBER')
EOF
)
    if grep "\"ok\" : 1" <<< "$result" > /dev/null; then
        true
    else
        false
    fi
}

########################
# Configure primary node
# Globals:
#   MONGODB_*
# Arguments:
#   $1 - node
# Returns:
#   None
#########################
mongodb_configure_primary() {
    local node="${1:?node is required}"

    info "Configuring MongoDB primary node...: $node"
    wait-for-port --timeout 360 "$MONGODB_PORT_NUMBER"

    retry_while "mongodb_is_primary_node_initiated $node" 15
}

########################
# Is node confirmed
# Globals:
#   None
# Arguments:
#   $1 - node
# Returns:
#   Boolean
#########################
mongodb_is_node_confirmed() {
    local node="${1:?node is required}"

    result=$(mongodb_execute "$MONGODB_PRIMARY_ROOT_USER" "$MONGODB_PRIMARY_ROOT_PASSWORD" "admin" "$MONGODB_PRIMARY_HOST" "$MONGODB_PRIMARY_PORT_NUMBER" <<EOF
rs.status().members
EOF
)
    if grep "$node" <<< "$result" > /dev/null; then
        true
    else
        false
    fi
}

########################
# Wait for Confirmation
# Globals:
#   None
# Arguments:
#   $1 - node
# Returns:
#   Boolean
#########################
mongodb_wait_confirmation() {
    local node="${1:?node is required}"

    debug "Waiting until $node is added to the replica set..."
    if retry_while "mongodb_is_node_confirmed $node" 15; then
        info "Node $node is confirmed!"
    else
        error "Unable to confirm that $node has been added to the replica set!"
        exit 1
    fi
}

########################
# mongodb_is_primary_node_up
# Globals:
#   None
# Returns:
#   None
#########################
mongodb_is_primary_node_up() {
    debug "Validating $MONGODB_PRIMARY_HOST as primary node..."

    result=$(mongodb_execute "$MONGODB_PRIMARY_ROOT_USER" "$MONGODB_PRIMARY_ROOT_PASSWORD" "admin" "$MONGODB_PRIMARY_HOST" "$MONGODB_PRIMARY_PORT_NUMBER" <<EOF
db.isMaster().ismaster
EOF
)
    if grep "true" <<< "$result" > /dev/null; then
        true
    else
        false
    fi
}

########################
# Is primary available
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   Boolean
#########################
mongodb_is_primary_available() {
    local result
    result=$(mongodb_execute "$MONGODB_PRIMARY_ROOT_USER" "$MONGODB_PRIMARY_ROOT_PASSWORD" "admin" "$MONGODB_PRIMARY_HOST" "$MONGODB_PRIMARY_PORT_NUMBER" <<EOF
db.getUsers()
EOF
)
    if grep "\"user\" :" <<< "$result" > /dev/null; then
        true
    else
        false
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
    debug "Waiting for primary node..."

    info "Trying to connect to MongoDB server..."
    wait-for-port --host "$MONGODB_PRIMARY_HOST" --timeout 360 "$MONGODB_PRIMARY_PORT_NUMBER"
    info "Found MongoDB server listening at $MONGODB_PRIMARY_HOST:$MONGODB_PRIMARY_PORT_NUMBER !"

    retry_while "mongodb_is_primary_available" 15
    info "MongoDB server listening and working at $MONGODB_PRIMARY_HOST:$MONGODB_PRIMARY_PORT_NUMBER !"
    debug "Waiting for primary to be ready..."
    if retry_while "mongodb_is_primary_node_up" 35; then
        info "Primary node ready."
    else
        error "Unable to validate $MONGODB_PRIMARY_HOST as primary node in the replica set scenario!"
        exit 1
    fi
}


########################
# Configure secondary node
# Globals:
#   None
# Arguments:
#   $1 - node
# Returns:
#   None
#########################
mongodb_configure_secondary() {
    local node="${1:?node is required}"

    info "Configuring MongoDB secondary node..."
    retry_while "mongodb_is_secondary_node_pending $node" 15
    mongodb_wait_confirmation "$node"
}


########################
# Configure arbiter node
# Globals:
#   None
# Arguments:
#   $1 - node
# Returns:
#   None
#########################
mongodb_configure_arbiter() {
    local node="${1:?node is required}"

    info "Configuring MongoDB arbiter node"
    retry_while "mongodb_is_arbiter_node_pending $node" 15
    mongodb_wait_confirmation "$node"
}

########################
# Gets if the replica set in synced
# Globals:
#   MONGODB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mongodb_is_not_in_sync(){
    local result

    result=$(mongodb_execute "$MONGODB_PRIMARY_ROOT_USER" "$MONGODB_PRIMARY_ROOT_PASSWORD" "admin" "$MONGODB_PRIMARY_HOST" "$MONGODB_PRIMARY_PORT_NUMBER" <<EOF
db.printSlaveReplicationInfo()
EOF
)

    if grep -E "^[[:space:]]*0 secs" <<< "$result" > /dev/null; then
        true
    else
        false
    fi
}

########################
# Waits until initial data sync complete
# Globals:
#   MONGODB_LOG_FILE

# Arguments:
#   None
# Returns:
#   None
#########################
mongodb_wait_until_sync_complete() {
    local -r retries=10

    info "Waiting until initial data sync is complete..."

    if retry_while "mongodb_is_not_in_sync" $retries 1; then
        info "initial data sync completed"
    else
        error "Initial data sync did not finish after $retries seconds"
        exit 1
    fi
}

########################
# Gets current status of the replicaset
# Globals:
#   MONGODB_*
# Arguments:
#   $1 - node
# Returns:
#   None
#########################
mongodb_node_currently_in_cluster() {
    local node="${1:?node is required}"
    local result

    result=$(mongodb_execute "$MONGODB_PRIMARY_ROOT_USER" "$MONGODB_PRIMARY_ROOT_PASSWORD" "admin" "$MONGODB_PRIMARY_HOST" "$MONGODB_PRIMARY_PORT_NUMBER" <<EOF
rs.status()
EOF
)
    if grep "name.*$node" <<< "$result" > /dev/null; then
        true
    else
        false
    fi
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

    info "Configuring MongoDB replica set..."

    node=$(get_mongo_hostname)
    mongodb_enable_replicasetmode
    mongodb_restart

    case "$MONGODB_REPLICA_SET_MODE" in
        "primary" )
            mongodb_configure_primary "$node"
            ;;
        "secondary")
            mongodb_wait_for_primary_node

            if mongodb_node_currently_in_cluster "$node"; then
                info "Node currently in the cluster"
            else
                info "Adding node to the cluster"
                mongodb_configure_secondary "$node"
            fi
            ;;
         "arbiter")
            mongodb_wait_for_primary_node

            if mongodb_node_currently_in_cluster "$node"; then
                info "Node currently in the cluster"
            else
                info "Adding node to the cluster"
                mongodb_configure_arbiter "$node"
            fi
            ;;
        "dynamic")
            # Do nothing
            ;;
        *)
            error "Invalid replica set mode. Available options are 'primary/secondary/arbiter/dynamic'"
            exit 1
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
    local path=${1:?path is required}
    local user=${2:?user is required}
    local group=${3:?group is required}
    local dir_mode=${4:-false}
    local file_mode=${5:-false}

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

########################
# Print properties
# Globals:
#   MONGODB_*
# Arguments:
#   $1 - persited data
# Returns:
#   None
#########################
mongodb_print_properties() {
    local persisted=${1:?persisted is required}
    local contains_passwords=false

    ([[ -n $MONGODB_ROOT_PASSWORD ]] || [[ -n $MONGODB_PRIMARY_ROOT_USER  ]] || [[ -n $MONGODB_PASSWORD ]]) && contains_passwords=true

    info ""
    info "########################################################################"
    info " Installation parameters for MongoDB:"

    if $persisted; then
        info "   Persisted data and properties have been restored."
        info "   Any input specified will not take effect."
    else
        if [[ "$MONGODB_REPLICA_SET_MODE" =~ ^primary$ ]]; then
          [[ -n $MONGODB_ROOT_PASSWORD ]] && info "  Root Password: **********"
        fi

        [[ -n $MONGODB_USERNAME ]] && info "  User Name: $MONGODB_USERNAME"
        [[ -n $MONGODB_PASSWORD ]] && info "  Password: **********"
        [[ -n $MONGODB_DATABASE ]] && info "  Database: $MONGODB_DATABASE"

        if [[ -n "$MONGODB_REPLICA_SET_MODE" ]]; then
            info "  Replication Mode: $MONGODB_REPLICA_SET_MODE"
            if [[ "$MONGODB_REPLICA_SET_MODE" =~ ^(secondary|arbiter)$ ]]; then
                info "  Primary Host: $MONGODB_PRIMARY_HOST"
                info "  Primary Port: $MONGODB_PRIMARY_PORT_NUMBER"
                info "  Primary Root User: $MONGODB_PRIMARY_ROOT_USER"
                info "  Primary Root Password: **********"
            fi
        fi
    fi

    if $contains_passwords; then
        info "(Passwords are not shown for security reasons)"
    else
        info "This installation requires no credentials."
    fi

    info "########################################################################"
    info ""
}

########################
# Initialize MongoDB service
# Globals:
#   MONGODB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mongodb_initialize() {
    local persisted=false

    info "Initializing MongoDB..."

    # This fixes an issue where the trap would kill the entrypoint.sh, if a PID was left over from a previous run
    # Exec replaces the process without creating a new one, and when the container is restarted it may have the same PID
    rm -f "$MONGODB_PID_FILE"

    # Configuring permissions for tmp, logs and data folders
    am_i_root && chown -LR "$MONGODB_DAEMON_USER":"$MONGODB_DAEMON_GROUP" "$MONGODB_TMP_DIR" "$MONGODB_LOG_DIR"
    am_i_root && configure_permissions "$MONGODB_DATA_DIR" "$MONGODB_DAEMON_USER" "$MONGODB_DAEMON_GROUP" "755" "644"

    if is_dir_empty "$MONGODB_DATA_DIR/db"; then
        info "Deploying MongoDB from scratch..."
        ensure_dir_exists "$MONGODB_DATA_DIR/db"
        am_i_root && chown -R "$MONGODB_DAEMON_USER" "$MONGODB_DATA_DIR/db"

        # If conf file not exists, generate the default one.
        if [[ -f "$MONGODB_CONFIG_FILE" ]]; then
            info "Custom configuration $MONGODB_CONFIG_FILE detected!"
        else
            info "No injected configuration files found. Creating default config files..."
            mongodb_create_config
        fi

        mongodb_start_bg
        mongodb_create_users

        if [[ -n "$MONGODB_REPLICA_SET_MODE" ]]; then
            if [[ -n "$MONGODB_REPLICA_SET_KEY" ]]; then
                mongodb_configure_key_file "$MONGODB_KEY_FILE" "$MONGODB_REPLICA_SET_KEY"
            fi
            mongodb_configure_replica_set
        fi

        mongodb_stop
    else
        info "Deploying MongoDB with persisted data..."
        persisted=true

        if [[ -f "$MONGODB_CONFIG_FILE" ]]; then
            info "Custom configuration $MONGODB_CONFIG_FILE detected!"
        else
            info "No injected configuration files found. Creating default config files..."
            mongodb_create_config
        fi
        if [[ -n "$MONGODB_REPLICA_SET_MODE" ]]; then
            if [[ "$MONGODB_REPLICA_SET_MODE" = "dynamic" ]] && \
               grep -E "^[[:space:]]*replSetName: $MONGODB_REPLICA_SET_NAME" "$MONGODB_CONFIG_FILE" >/dev/null; then
                info "ReplicaSetMode set to \"dynamic\" and replSetName different from config file."
                info "Dropping local database ..."
                mongodb_start_bg
                mongodb_drop_local_database
                mongodb_stop
            fi

            if [[ -n "$MONGODB_REPLICA_SET_KEY" ]]; then
                mongodb_configure_key_file "$MONGODB_KEY_FILE" "$MONGODB_REPLICA_SET_KEY"
            fi
            mongodb_enable_replicasetmode
        fi
    fi

    mongodb_print_properties $persisted
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
    info "Loading custom scripts..."
    if [[ -n $(find "$MONGODB_INITSCRIPTS_DIR/" -type f -regex ".*\.\(sh\|js\|js.gz\)") ]] && [[ ! -f "$MONGODB_PERSIST_DIR/.user_scripts_initialized" ]] ; then
        info "Loading user's custom files from $MONGODB_INITSCRIPTS_DIR ...";
        mongodb_start_bg
        local -r tmp_file=/tmp/filelist
        local mongo_user
        local mongo_pass
        if [[ -n "$MONGODB_ROOT_PASSWORD" ]];then
            mongo_user=root
            mongo_pass="$MONGODB_ROOT_PASSWORD"
        else
            mongo_user="$MONGODB_USERNAME"
            mongo_pass="$MONGODB_PASSWORD"
        fi
        find "$MONGODB_INITSCRIPTS_DIR" -type f -regex ".*\.\(sh\|js\|js.gz\)" | sort > $tmp_file
        while read -r f; do
            case "$f" in
                *.sh)
                    if [[ -x "$f" ]]; then
                        debug "Executing $f"; "$f"
                    else
                        debug "Sourcing $f"; . "$f"
                    fi
                    ;;
                *.js)    debug "Executing $f"; mongodb_execute "$mongo_user" "$mongo_pass" < "$f";;
                *.js.gz) debug "Executing $f"; gunzip -c "$f" | mongodb_execute "$mongo_user" "$mongo_pass";;
                *)        debug "Ignoring $f" ;;
            esac
        done < $tmp_file
        touch "$MONGODB_PERSIST_DIR"/.user_scripts_initialized
    fi
}
