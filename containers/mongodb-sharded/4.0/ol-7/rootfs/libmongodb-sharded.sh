#!/bin/bash

#
# Bitnami MongoDB library

# shellcheck disable=SC1090
# shellcheck disable=SC1091

# Load Generic Libraries
. /liblog.sh
. /libvalidations.sh
. /libmongodb.sh

########################
# Load global variables used on MongoDB Sharded configuration.
# Globals:
#   MONGODB_*
# Arguments:
#   None
# Returns:
#   Series of exports to be used as 'eval' arguments
#########################
mongodb_sharded_env() {
    cat <<"EOF"
# Paths
export MONGODB_MONGOS_TEMPLATES_FILE="$MONGODB_TEMPLATES_DIR/mongos.conf.tpl"

# Settings
export MONGODB_SHARDING_MODE="${MONGODB_SHARDING_MODE:-}"
export MONGODB_CFG_REPLICA_SET_NAME="${MONGODB_CFG_REPLICA_SET_NAME:-}"
export MONGODB_CFG_PRIMARY_HOST="${MONGODB_CFG_PRIMARY_HOST:-}"
export MONGODB_MONGOS_HOST="${MONGODB_MONGOS_HOST:-}"
export MONGODB_MONGOS_PORT_NUMBER="${MONGODB_MONGOS_PORT_NUMBER:-27017}"
export MONGODB_CFG_PRIMARY_PORT_NUMBER="${MONGODB_CFG_PRIMARY_PORT_NUMBER:-27017}"
EOF
}

########################
# Get current status of the shard in the cluster
# Globals:
#   MONGODB_*
# Arguments:
#   $1 - Name of the replica set
# Returns:
#   None
#########################
mongodb_sharded_shard_currently_in_cluster() {
    local -r replicaset="${1:?node is required}"
    local result

    result=$(mongodb_execute "$MONGODB_PRIMARY_ROOT_USER" "$MONGODB_PRIMARY_ROOT_PASSWORD" "admin" "$MONGODB_MONGOS_HOST" "$MONGODB_MONGOS_PORT_NUMBER" <<EOF
db.adminCommand({ listShards: 1 })
EOF
)
   grep -q "id.*$replicaset" <<< "$result"
}
###############
# Initialize MongoDB (mongod) service with sharded configuration
# Globals:
#   MONGODB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mongodb_sharded_mongod_initialize() {
    local persisted=false

    info "Initializing MongoDB Sharded..."

    mongodb_clean_from_restart

    mongodb_copy_mounted_config
    mongodb_ensure_mongod_config_exists
    mongodb_set_permissions
    mongodb_sharded_set_sharding_conf

    if is_dir_empty "$MONGODB_DATA_DIR/db"; then
        info "Deploying MongoDB Sharded from scratch..."

        ensure_dir_exists "$MONGODB_DATA_DIR/db"
        am_i_root && chown -R "$MONGODB_DAEMON_USER" "$MONGODB_DATA_DIR/db"

        mongodb_start_bg
        mongodb_create_users
        mongodb_create_keyfile "$MONGODB_REPLICA_SET_KEY"
        mongodb_set_keyfile_conf
        mongodb_set_auth_conf
        mongodb_set_replicasetmode_conf
        mongodb_set_listen_all_conf
        mongodb_sharded_configure_replica_set
        mongodb_stop
    else
        persisted=true
        mongodb_create_keyfile "$MONGODB_REPLICA_SET_KEY"
        mongodb_set_keyfile_conf
        mongodb_set_auth_conf
        info "Deploying MongoDB Sharded with persisted data..."
        if [[ "$MONGODB_REPLICA_SET_MODE" = "dynamic" ]]; then
            mongodb_ensure_dynamic_mode_consistency
        fi
        mongodb_set_replicasetmode_conf
    fi

    if [[ "$MONGODB_SHARDING_MODE" = "shardsvr" ]] && [[ "$MONGODB_REPLICA_SET_MODE" = "primary" ]]; then
        mongodb_wait_for_node "$MONGODB_MONGOS_HOST" "$MONGODB_MONGOS_PORT_NUMBER" "root" "$MONGODB_ROOT_PASSWORD"
        if ! mongodb_sharded_shard_currently_in_cluster "$MONGODB_REPLICA_SET_NAME"; then
          mongodb_sharded_join_shard_cluster
        else
          info "Shard already in cluster"
        fi
    fi

    mongodb_sharded_print_properties $persisted
}

########################
# Print properties
# Globals:
#   MONGODB_*
# Arguments:
#   $1 - true if persited data
# Returns:
#   None
#########################
mongodb_sharded_print_properties() {
    local -r persisted=${1:?persisted is required}
    mongodb_print_properties "$persisted"
    info "  Shard Mode: ${MONGODB_SHARDING_MODE}"
    info "########################################################################"
}

########################
# Validate settings in MONGODB_* env. variables (sharded configuration)
# Globals:
#   MONGODB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mongodb_sharded_validate() {
    local error_code=0

    if ! (mongodb_validate); then
      error_code=1
    fi

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }
    if [[ -z "$MONGODB_SHARDING_MODE" ]]; then
        print_validation_error "You need to speficy one of the sharding modes: mongos, shardsvr or configsvr"
    fi
    if [[ "$MONGODB_SHARDING_MODE" = "mongos" ]] || { [[ "$MONGODB_SHARDING_MODE" = "shardsvr" ]] && [[ "$MONGODB_REPLICA_SET_MODE" = "primary" ]] ;}; then
        if [[ -z "$MONGODB_ROOT_PASSWORD" ]]; then
          print_validation_error "Missing root password for the Config Server. Set MONGODB_ROOT_PASSWORD"
        fi
    fi

    if [[ "$MONGODB_SHARDING_MODE" =~ (shardsvr|configsvr) ]]; then
        if [[ -z "$MONGODB_REPLICA_SET_MODE" ]]; then
          print_validation_error "Sharding requires setting replica set mode. Set MONGODB_REPLICA_SET_MODE"
        fi
    fi

    if [[ "$MONGODB_SHARDING_MODE" = "mongos" ]]; then
        if [[ -z "$MONGODB_CFG_PRIMARY_HOST" ]]; then
          print_validation_error "Missing primary host for the Config Server. Set MONGODB_CFG_PRIMARY_HOST"
        fi
        if [[ -z "$MONGODB_CFG_REPLICA_SET_NAME" ]]; then
          print_validation_error "Missing replica set name  for the Config Server. Set MONGODB_CFG_REPLICA_SET_NAME"
        fi
        if [[ -z "$MONGODB_REPLICA_SET_KEY" ]]; then
          print_validation_error "Missing replica set key for the Config Server. Set MONGODB_REPLICA_SET_KEY"
        fi
    fi

    if [[ "$MONGODB_SHARDING_MODE" = "shardsvr" ]] && [[ "$MONGODB_REPLICA_SET_MODE" = "primary" ]]; then
        if [[ -z "$MONGODB_MONGOS_HOST" ]]; then
          print_validation_error "Missing mongos host for registration. Set MONGODB_MONGOS_HOST"
        fi
    fi

    if [[ "$MONGODB_SHARDING_MODE" = "configsvr" ]]; then
        if [[ "$MONGODB_REPLICA_SET_MODE" = "arbiter" ]]; then
          print_validation_error "Arbiters are not allowed in Config Server replicasets"
        fi
    fi

    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}

########################
# Enable Sharding in mongodb.conf
# Globals:
#   MONGODB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mongodb_sharded_set_sharding_conf() {
    if ! mongodb_is_file_external "mongodb.conf"; then
        mongodb_config_apply_regex "#?sharding:.*" "sharding:"
        mongodb_config_apply_regex "#?clusterRole:.*" "clusterRole: $MONGODB_SHARDING_MODE"
    else
        debug "mongodb.conf mounted. Skipping sharding mode enabling"
    fi
}

########################
# Join shard cluster
# Globals:
#   MONGODB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mongodb_sharded_join_shard_cluster() {
    mongodb_start_bg
    info "Joining the shard cluster"
    if ! retry_while "mongodb_sharded_is_join_shard_pending $MONGODB_REPLICA_SET_NAME/$MONGODB_ADVERTISED_HOSTNAME:$MONGODB_PORT_NUMBER $MONGODB_MONGOS_HOST $MONGODB_MONGOS_PORT_NUMBER root $MONGODB_ROOT_PASSWORD" "$MONGODB_MAX_TIMEOUT"; then
        error "Unable to join the sharded cluster"
        exit 1
    fi
    mongodb_stop
}

########################
# Get if secondary node is pending
# Globals:
#   MONGODB_*
# Arguments:
#   $1 - node
# Returns:
#   Boolean
#########################
mongodb_sharded_is_join_shard_pending() {
    local -r shard_connection_string="${1:?shard connection string is required}"
    local -r mongos_host="${2:?node is required}"
    local -r mongos_port="${3:?port is required}"
    local -r user="${4:?user is required}"
    local -r password="${5:?password is required}"
    local result

    result=$(mongodb_execute "$user" "$password" "admin" "$mongos_host" "$mongos_port" <<EOF
sh.addShard("$shard_connection_string")
EOF
)
    grep -q "\"ok\" : 1" <<< "$result"
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
mongodb_sharded_configure_replica_set() {
    local node

    info "Configuring MongoDB Sharded replica set..."

    node=$(get_mongo_hostname)
    mongodb_set_replicasetmode_conf
    mongodb_restart

    case "$MONGODB_REPLICA_SET_MODE" in
        "primary" )
            if [[ "$MONGODB_SHARDING_MODE" = "configsvr" ]]; then
                mongodb_sharded_configure_configsvr_primary "$node"
            else
                mongodb_configure_primary "$node"
            fi
            ;;
        "secondary")
            mongodb_configure_secondary "$node"
            ;;
        "arbiter")
            mongodb_configure_arbiter "$node"
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
# Get if primary node is initialized
# Globals:
#   MONGODB_*
# Arguments:
#   $1 - node
# Returns:
#   None
#########################
mongodb_sharded_is_configsvr_initiated() {
    local -r node="${1:?node is required}"
    local result
    result=$(mongodb_execute "root" "$MONGODB_ROOT_PASSWORD" "admin" "$node" "$MONGODB_PORT_NUMBER" <<EOF
rs.initiate({"_id":"$MONGODB_REPLICA_SET_NAME", "configsvr": true, "members":[{"_id":0,"host":"$node:$MONGODB_PORT_NUMBER","priority":5}]})
EOF
)
    grep -q "\"ok\" : 1" <<< "$result"
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
mongodb_sharded_configure_configsvr_primary() {
    local -r node="${1:?node is required}"

    info "Configuring MongoDB primary node...: $node"
    wait-for-port --timeout 360 "$MONGODB_PORT_NUMBER"

    if ! retry_while "mongodb_sharded_is_configsvr_initiated $node" "$MONGODB_MAX_TIMEOUT"; then
        error "Unable to initialize primary config server"
        exit 1
    fi
}

mongodb_sharded_mongos_initialize() {
    info "Initializing Mongos..."

    mongodb_clean_from_restart
    mongodb_set_permissions
    mongodb_sharded_ensure_mongos_config_exists
    mongodb_create_keyfile "$MONGODB_REPLICA_SET_KEY"
    mongodb_set_keyfile_conf

    mongodb_wait_for_primary_node "$MONGODB_CFG_PRIMARY_HOST" "$MONGODB_CFG_PRIMARY_PORT_NUMBER" "root" "$MONGODB_ROOT_PASSWORD"
}

########################
# Create Mongos configuration (mongodb.conf) file
# Globals:
#   MONGODB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mongodb_sharded_ensure_mongos_config_exists() {
    if [[ -f "$MONGODB_CONF_FILE" ]]; then
        info "Custom configuration $MONGODB_CONF_FILE detected!"
    else
        info "No injected configuration files found. Creating default config files..."
        mongodb_sharded_create_mongos_config
    fi
}

########################
# Create Mongos configuration file
# Globals:
#   MONGODB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mongodb_sharded_create_mongos_config() {
    debug "Creating main configuration file..."

    render-template "$MONGODB_MONGOS_TEMPLATES_FILE" > "$MONGODB_CONF_FILE"
}
