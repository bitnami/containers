#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

#
# Bitnami MongoDB library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libmongodb.sh

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

    result=$(
        mongodb_execute_print_output "$MONGODB_ROOT_USER" "$MONGODB_ROOT_PASSWORD" "admin" "$MONGODB_MONGOS_HOST" "$MONGODB_MONGOS_PORT_NUMBER" <<EOF
db.adminCommand({ listShards: 1 })
EOF
    )
    grep -q "id.*$replicaset" <<<"$result"
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
    info "Initializing MongoDB Sharded..."
    rm -f "$MONGODB_PID_FILE"

    mongodb_copy_mounted_config
    mongodb_set_net_conf
    mongodb_set_log_conf
    mongodb_set_storage_conf
    mongodb_set_journal_conf
    mongodb_sharded_set_sharding_conf "$MONGODB_CONF_FILE"

    if is_dir_empty "$MONGODB_DATA_DIR/db"; then
        info "Deploying MongoDB Sharded from scratch..."

        ensure_dir_exists "$MONGODB_DATA_DIR/db"
        am_i_root && chown -R "$MONGODB_DAEMON_USER" "$MONGODB_DATA_DIR/db"

        mongodb_set_replicasetmode_conf

        if [[ "$MONGODB_SHARDING_MODE" =~ ^(configsvr|shardsvr)$ ]] && [[ "$MONGODB_REPLICA_SET_MODE" = "primary" ]]; then
            mongodb_sharded_initiate_svr_primary
        fi

        mongodb_start_bg
        mongodb_create_users
        mongodb_create_keyfile "$MONGODB_REPLICA_SET_KEY"
        mongodb_set_keyfile_conf
        mongodb_set_auth_conf
        mongodb_set_listen_all_conf
        mongodb_sharded_configure_replica_set
        mongodb_stop
    else
        mongodb_create_keyfile "$MONGODB_REPLICA_SET_KEY"
        mongodb_set_keyfile_conf
        mongodb_set_auth_conf
        info "Deploying MongoDB Sharded with persisted data..."
        if [[ "$MONGODB_REPLICA_SET_MODE" = "dynamic" ]]; then
            mongodb_ensure_dynamic_mode_consistency
        fi
        mongodb_set_replicasetmode_conf
    fi

    mongodb_set_listen_all_conf
    if [[ "$MONGODB_SHARDING_MODE" = "shardsvr" ]] && [[ "$MONGODB_REPLICA_SET_MODE" = "primary" ]]; then
        mongodb_wait_for_node "$MONGODB_MONGOS_HOST" "$MONGODB_MONGOS_PORT_NUMBER" "$MONGODB_ROOT_USER" "$MONGODB_ROOT_PASSWORD"
        if ! mongodb_sharded_shard_currently_in_cluster "$MONGODB_REPLICA_SET_NAME"; then
            mongodb_sharded_join_shard_cluster
        else
            info "Shard already in cluster"
        fi
    fi
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
    if [[ "$MONGODB_SHARDING_MODE" = "mongos" ]] || { [[ "$MONGODB_SHARDING_MODE" = "shardsvr" ]] && [[ "$MONGODB_REPLICA_SET_MODE" = "primary" ]]; }; then
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
    local -r conf_file_path="${1:-$MONGODB_CONF_FILE}"
    local -r conf_file_name="${conf_file_path#"$MONGODB_CONF_DIR"}"

    if ! mongodb_is_file_external "$conf_file_name"; then
        mongodb_config_apply_regex "#?sharding:.*" "sharding:" "$conf_file_path"
        mongodb_config_apply_regex "#?clusterRole:.*" "clusterRole: $MONGODB_SHARDING_MODE" "$conf_file_path"
    else
        debug "$conf_file_name mounted. Skipping sharding mode enabling"
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
    if ! retry_while "mongodb_sharded_is_join_shard_pending $MONGODB_REPLICA_SET_NAME/$MONGODB_ADVERTISED_HOSTNAME:$MONGODB_PORT_NUMBER $MONGODB_MONGOS_HOST $MONGODB_MONGOS_PORT_NUMBER root $MONGODB_ROOT_PASSWORD" "$MONGODB_INIT_RETRY_ATTEMPTS" "$MONGODB_INIT_RETRY_DELAY"; then
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

    result=$(
        mongodb_execute_print_output "$user" "$password" "admin" "$mongos_host" "$mongos_port" <<EOF
sh.addShard("$shard_connection_string")
EOF
    )
    grep -q "ok: 1" <<<"$result"
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
    mongodb_restart

    case "$MONGODB_REPLICA_SET_MODE" in
    "primary")
        if [[ "$MONGODB_SHARDING_MODE" =~ ^(configsvr|shardsvr)$ ]]; then
            mongodb_sharded_reconfigure_svr_primary "$node"
        fi
        ;;
    "secondary")
        mongodb_configure_secondary "$node" "$MONGODB_PORT_NUMBER"
        ;;
    "arbiter")
        mongodb_configure_arbiter "$node" "$MONGODB_PORT_NUMBER"
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
# First initialization for the configsvr or shardsvr node
# Globals:
#   MONGODB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mongodb_sharded_initiate_svr_primary() {
    mongodb_sharded_is_svr_initiated() {
        local result
        result=$(
            mongodb_execute_print_output "" "" "" "127.0.0.1" <<EOF
rs.initiate({"_id":"$MONGODB_REPLICA_SET_NAME", "protocolVersion":1, "members":[{"_id":0,"host":"127.0.0.1:$MONGODB_PORT_NUMBER"}]})
EOF
        )
        grep -q "ok: 1" <<<"$result"
    }

    mongodb_start_bg
    if ! retry_while "mongodb_sharded_is_svr_initiated" "$MONGODB_INIT_RETRY_ATTEMPTS" "$MONGODB_INIT_RETRY_DELAY"; then
        error "Unable to initialize primary config server: cannot initiate"
        exit 1
    fi
    if ! retry_while "mongodb_is_primary_node_up 127.0.0.1 $MONGODB_PORT_NUMBER admin" "$MONGODB_INIT_RETRY_ATTEMPTS" "$MONGODB_INIT_RETRY_DELAY"; then
        error "Unable to initialize primary config server: cannot become primary"
        exit 1
    fi
}

########################
# Get if the configsvr or shardsvr primary node is reconfigured
# Globals:
#   MONGODB_*
# Arguments:
#   $1 - node
# Returns:
#   None
#########################
mongodb_sharded_is_svr_primary_reconfigured() {
    local -r node="${1:?node is required}"
    local result

    result=$(
        mongodb_execute_print_output "$MONGODB_ROOT_USER" "$MONGODB_ROOT_PASSWORD" "admin" "$node" "$MONGODB_PORT_NUMBER" <<EOF
rs.reconfig({"_id":"$MONGODB_REPLICA_SET_NAME","configsvr": $([[ "$MONGODB_SHARDING_MODE" = "configsvr" ]] && echo "true" || echo "false"),"protocolVersion":1,"members":[{"_id":0,"host":"$node:$MONGODB_PORT_NUMBER","priority":5}]})
EOF
    )
    grep -q "ok: 1" <<<"$result"
}

########################
# Reconfigure configsvr or shardsvr primary node
# Globals:
#   MONGODB_*
# Arguments:
#   $1 - node
# Returns:
#   None
#########################
mongodb_sharded_reconfigure_svr_primary() {
    local -r node="${1:?node is required}"

    info "Configuring MongoDB primary node...: $node"
    wait-for-port --timeout 360 "$MONGODB_PORT_NUMBER"

    if ! retry_while "mongodb_sharded_is_svr_primary_reconfigured $node" "$MONGODB_INIT_RETRY_ATTEMPTS" "$MONGODB_INIT_RETRY_DELAY"; then
        error "Unable to initialize primary config server"
        exit 1
    fi
}

mongodb_sharded_mongos_conf_compatibility() {
    if mongodb_is_file_external "mongodb.conf" && ! mongodb_is_file_external "mongos.conf"; then
        warn "Mounted mongos configuration file as mongodb.conf. Copying it to mongos.conf"
        cp "$MONGODB_CONF_FILE" "$MONGODB_MONGOS_CONF_FILE"
    fi
}

mongodb_sharded_mongos_initialize() {
    info "Initializing Mongos..."

    rm -f "$MONGODB_PID_FILE"
    mongodb_copy_mounted_config
    mongodb_sharded_mongos_conf_compatibility
    mongodb_create_keyfile "$MONGODB_REPLICA_SET_KEY"
    mongodb_set_keyfile_conf "$MONGODB_MONGOS_CONF_FILE"
    mongodb_set_net_conf "$MONGODB_MONGOS_CONF_FILE"
    mongodb_set_log_conf "$MONGODB_MONGOS_CONF_FILE"
    mongodb_sharded_set_cfg_server_host_conf "$MONGODB_MONGOS_CONF_FILE"
    mongodb_wait_for_primary_node "$MONGODB_CFG_PRIMARY_HOST" "$MONGODB_CFG_PRIMARY_PORT_NUMBER" "$MONGODB_ROOT_USER" "$MONGODB_ROOT_PASSWORD"
    mongodb_set_listen_all_conf "$MONGODB_MONGOS_CONF_FILE"
}

########################
# Set config server in a mongos instance
# Globals:
#   MONGODB_*
# Arguments:
#   None
# Returns:
#   None
#########################
mongodb_sharded_set_cfg_server_host_conf() {
    local -r conf_file_path="${1:-$MONGODB_MONGOS_CONF_FILE}"
    local -r conf_file_name="${conf_file_path#"$MONGODB_CONF_DIR"}"

    if ! mongodb_is_file_external "$conf_file_name"; then
        mongodb_config_apply_regex "configDB:.*" "configDB: $MONGODB_CFG_REPLICA_SET_NAME/$MONGODB_CFG_PRIMARY_HOST:$MONGODB_CFG_PRIMARY_PORT_NUMBER" "$conf_file_path"
    else
        debug "$conf_file_name mounted. Skipping setting config server host"
    fi
}
