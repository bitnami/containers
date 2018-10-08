#!/bin/bash -e

. /libfile.sh
. /liblog.sh
. /libnet.sh
. /libos.sh
. /libservice.sh
. /libvalidations.sh


# Echo env vars for elasticsearch global configuration.
elasticsearch_env() {
    cat <<"EOF"
export ELASTICSEARCH_BASEDIR=/opt/bitnami/elasticsearch
export ELASTICSEARCH_DATADIR=/bitnami/elasticsearch/data
export ELASTICSEARCH_CONFDIR=$ELASTICSEARCH_BASEDIR/config
export ELASTICSEARCH_CONF_FILE=$ELASTICSEARCH_CONFDIR/elasticsearch.yml
export ELASTICSEARCH_TMPDIR=$ELASTICSEARCH_BASEDIR/tmp
export ELASTICSEARCH_LOGDIR=$ELASTICSEARCH_BASEDIR/logs
export PATH=$ELASTICSEARCH_BASEDIR/bin:$PATH
export ELASTICSEARCH_DAEMON_USER=elasticsearch
export ELASTICSEARCH_DAEMON_GROUP=elasticsearch
EOF
}

# Validate settings in ELASTICSEARCH_* env vars.
elasticsearch_validate() {
    validate_sysctl_key() {
        local key=${1:?key is missing}
        local value=${2:?value is missing}
        local current_value
        current_value=$(sysctl -n "$key")
        if [[ "$current_value" -lt "$value" ]]; then
            error "Invalid kernel settings. Elasticsearch requires at least $key = $value"
            exit 1
        fi
    }
    validate_sysctl_key "vm.max_map_count" 262144
    validate_sysctl_key "fs.file-max" 65536
    for var in ELASTICSEARCH_PORT_NUMBER ELASTICSEARCH_NODE_PORT_NUMBER; do
        local value=${!var}
        if ! err=$(validate_port "$value"); then
            error "The $var environment variable is invalid: $err"
            exit 1
        fi
    done

    validate_node_type() {
        case "$ELASTICSEARCH_NODE_TYPE" in
            coordinating|data|ingest|master)
            ;;
            *)
                error "Invalid node type $ELASTICSEARCH_NODE_TYPE. Supported types are 'coordinating/data/ingest/master'"
                exit 1
                ;;
        esac
    }
    if is_boolean_yes "$ELASTICSEARCH_IS_DEDICATED_NODE"; then
        validate_node_type
    fi
}

# Ensure the elasticsearch volume is initialised.
elasticsearch_initialize() {
    configure_node() {
        local type=${1}
        local is_dedicated_node=${2:-no}
        local is_master="false"
        local is_data="false"
        local is_ingest="false"
        if is_boolean_yes "$is_dedicated_node"; then
            case "$type" in
                coordinating)
                ;;
                data)
                    is_data="true"
                    ;;
                ingest)
                    is_ingest="true"
                    ;;
                master)
                    is_master="true"
                    ;;
                *)
                    error "Invalid node type $type'"
                    exit 1
                    ;;
            esac
        else
            is_master="true"
            is_data="true"
        fi
        elasticsearch_conf_set node.master "$is_master"
        elasticsearch_conf_set node.data "$is_data"
        elasticsearch_conf_set node.ingest "$is_ingest"
    }
    install_plugins() {
        local plugins="${1:-}"
        if [ -n "$plugins" ]; then
            local plugins_list
            plugins_list=$(tr ',;' ' ' <<< "${plugins}")
            for plugin in ${plugins_list[@]}; do
                info "Installing plugin: $plugin"
                elasticsearch-plugin install -b -v "$plugin"
            done
        fi
    }
    set_heap_size() {
        local heap_size="${1:-}"
        if [ -n "$heap_size" ]; then
            info "Using specified values for Xmx and Xms heap options..."
        else
            info "Calculating appropiate Xmx and Xms values..."
            local machine_mem=""
            machine_mem="$(get_total_memory)"
            if [ "$machine_mem" -lt 65536 ]; then
                heap_size="$(("$machine_mem" / 2))m"
            else
                heap_size=32768m
            fi
        fi
        info "Setting '-Xmx${heap_size} -Xms${heap_size}' heap options..."
        sed -r -i "s/-Xmx[0-9]+[mg]+/-Xmx${heap_size}/g" "$ELASTICSEARCH_CONFDIR/jvm.options"
        sed -r -i "s/-Xms[0-9]+[mg]+/-Xms${heap_size}/g" "$ELASTICSEARCH_CONFDIR/jvm.options"
    }

    minimal_config() {
        info "Setting default configuration"
        elasticsearch_conf_set http.port "$ELASTICSEARCH_PORT_NUMBER"
        elasticsearch_conf_set path.data "$ELASTICSEARCH_DATADIR"
        elasticsearch_conf_set transport.tcp.port "$ELASTICSEARCH_NODE_PORT_NUMBER"
        info "Setting cluster configuration"
        cluster_configuration
        configure_node "$ELASTICSEARCH_NODE_TYPE" "$ELASTICSEARCH_IS_DEDICATED_NODE"

        local custom_conf_file="$ELASTICSEARCH_CONFDIR/elasticsearch_custom.yml"
        if [ -f "$custom_conf_file" ]; then
            info "Applying user configuration"
            echo "" >> "$ELASTICSEARCH_CONF_FILE"
            cat "$custom_conf_file" >> "$ELASTICSEARCH_CONF_FILE"
        fi
        set_heap_size "$ELASTICSEARCH_HEAP_SIZE"
    }

    migrate_old_data() {
        warn "Persisted data follows old structure. Migrating to new one..."
        warn "Custom configuration files won't be persisted any longer!"
        local old_data_dir="$ELASTICSEARCH_DATADIR/elasticsearch"
        local old_custom_conf_file="$old_data_dir/conf/elasticsearch_custom.yml"
        local custom_conf_file="$ELASTICSEARCH_CONFDIR/elasticsearch_custom.yml"
        if [ -f "$old_custom_conf_file" ]; then
            info "Adding old custom configuration to user configuration"
            echo "" >> "$custom_conf_file"
            cat "$old_custom_conf_file" >> "$custom_conf_file"
        fi
        info "Adapting data to new file structure"
        find "$old_data_dir/data" -maxdepth 1 -mindepth 1 -exec mv {} "$ELASTICSEARCH_DATADIR" \;
        info "Removing data that is not persisted anymore from persisted directory"
        rm -rf "$old_data_dir" "$ELASTICSEARCH_DATADIR/java"
    }

    if am_i_root; then
        ensure_user_exists "$ELASTICSEARCH_DAEMON_USER" "$ELASTICSEARCH_DAEMON_GROUP"
    fi

    if ! dir_is_empty "$ELASTICSEARCH_DATADIR"; then
        info "Detected persisted data from previous deployments"
        if [ -d "$ELASTICSEARCH_DATADIR/elasticsearch" -a -f "$ELASTICSEARCH_DATADIR/elasticsearch/.initialized" ]; then
            migrate_old_data
        fi
    fi

    for dir in "$ELASTICSEARCH_TMPDIR" "$ELASTICSEARCH_DATADIR" "$ELASTICSEARCH_LOGDIR" "$ELASTICSEARCH_BASEDIR/plugins" "$ELASTICSEARCH_BASEDIR/modules" "$ELASTICSEARCH_CONFDIR/scripts"; do
        ensure_dir_exists "$dir"
        if am_i_root; then
            chown "$ELASTICSEARCH_DAEMON_USER:$ELASTICSEARCH_DAEMON_GROUP" "$dir"
        fi
    done

    minimal_config
    install_plugins "$ELASTICSEARCH_PLUGINS"

}

# Checks if elasticsearch is running
is_elasticsearch_running() {
    local pid
    pid="$(get_pid "$ELASTICSEARCH_TMPDIR/elasticsearch.pid")"

    if [ -z "$pid" ]; then
        false
    else
        is_service_running "$pid"
    fi
}

# Stops elasticsearch
elasticsearch_stop() {
    stop_service_using_pid "$ELASTICSEARCH_TMPDIR/elasticsearch.pid"
}

# Starts elasticsearch
elasticsearch_start() {
    if is_elasticsearch_running ; then
        return
    fi
    if am_i_root; then
        gosu "$ELASTICSEARCH_DAEMON_USER" "$ELASTICSEARCH_BASEDIR/bin/elasticsearch" -d -p "$ELASTICSEARCH_TMPDIR/elasticsearch.pid" -Epath.data="$ELASTICSEARCH_DATADIR" >/dev/null 2>&1 &
    else
        "$ELASTICSEARCH_BASEDIR/bin/elasticsearch" -d -p "$ELASTICSEARCH_TMPDIR/elasticsearch.pid" -Epath.data="$ELASTICSEARCH_DATADIR" >/dev/null 2>&1 &
    fi

    local counter=50
    while ! is_elasticsearch_running ; do
        if [[ "$counter" -ne 0 ]]; then
            break
        fi
        sleep 2;
        counter=$((counter - 1))
    done

    local log_result=""
    local log_counter=30
    local log_file="$ELASTICSEARCH_LOGDIR/elasticsearch.log"

    while [ -z "$log_result" ] && [ "$log_counter" -ne 0 ]; do
        log_counter=$(("$log_counter" - 1))
        log_result=$(tail -7 "$log_file" | grep -i "Node" | grep -i "started")
        sleep 2
    done
}

cluster_configuration() {
    bind_address() {
        if [ -n "$ELASTICSEARCH_BIND_ADDRESS" ]; then
            echo "[$ELASTICSEARCH_BIND_ADDRESS, _local_]"
        else
            echo "0.0.0.0"
        fi
    }

    # Bash math operations cannot handle float or complex math operations
    calc() {
        local expr="${1:?missing expression}"
        perl <<<"use POSIX qw/ceil/;print $expr"
    }
    elasticsearch_conf_set network.host "$(get_machine_ip)"
    elasticsearch_conf_set network.publish_host "$(get_machine_ip)"
    elasticsearch_conf_set network.bind_host "$(bind_address)"
    elasticsearch_conf_set cluster.name "$ELASTICSEARCH_CLUSTER_NAME"
    elasticsearch_conf_set node.name "${ELASTICSEARCH_NODE_NAME:-$(hostname)}"
    if [ -n "$ELASTICSEARCH_CLUSTER_HOSTS" ]; then
        local host_list
        host_list=($(tr ',;' ' ' <<< "$ELASTICSEARCH_CLUSTER_HOSTS"))
        elasticsearch_conf_set discovery.zen.ping.unicast.hosts "${host_list[@]}"
        elasticsearch_conf_set discovery.initial_state_timeout "5m"
        elasticsearch_conf_set gateway.recover_after_nodes "$(calc "ceil(${#host_list[@]}*0.8)")"
        elasticsearch_conf_set gateway.expected_nodes "${#host_list[@]}"

        if [ -n "$ELASTICSEARCH_MINIMUM_MASTER_NODES" ]; then
            info "Setting minimum master nodes for quorum to $ELASTICSEARCH_MINIMUM_MASTER_NODES..."
            elasticsearch_conf_set discovery.zen.minimum_master_nodes "$ELASTICSEARCH_MINIMUM_MASTER_NODES"
        elif [ "${#host_list[@]}" -gt 2 ]; then
            local min_masters=""
            min_masters=$((("${#host_list[@]}" / 2) +1))
            info "Calculating minimum master nodes for quorum: $min_masters..."
            elasticsearch_conf_set discovery.zen.minimum_master_nodes "$min_masters"
        fi
    fi
}

elasticsearch_conf_set() {
    local name="${1:?missing key}"
    shift
    local values=("${@}")
    if [ "${#values[@]}" -eq 0 ]; then
        stderr_print "missing value"
        return 1
    elif [ "${#values[@]}" -eq 1 ]; then
        yq w -i "$ELASTICSEARCH_CONF_FILE" "$name" "${values[0]}"
    else
        for i in "${!values[@]}"; do
            yq w -i "$ELASTICSEARCH_CONF_FILE" "$name[$i]" "${values[$i]}"
        done

    fi
}
