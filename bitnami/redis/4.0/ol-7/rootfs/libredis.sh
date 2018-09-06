#!/bin/bash -e

. /libfile.sh
. /liblog.sh
. /libos.sh
. /libservice.sh
. /libvalidations.sh

# Echo env vars for redis global configuration.
redis_env() {
    cat <<"EOF"
export REDIS_EXTRAS_DIR=/opt/bitnami/extra/redis
export REDIS_TEMPLATES_DIR=$REDIS_EXTRAS_DIR/templates
export REDIS_BASEDIR=/opt/bitnami/redis
export REDIS_VOLUME=/bitnami/redis
export REDIS_TMPDIR=$REDIS_BASEDIR/tmp
export REDIS_LOGDIR=$REDIS_BASEDIR/logs
export PATH=$REDIS_BASEDIR/bin:$PATH
export REDIS_DAEMON_USER=redis
export REDIS_DAEMON_GROUP=redis
EOF
}

# Validate settings in REDIS_* env vars.
redis_validate() {
    empty_password_enabled_warn() {
        warn "You set the environment variable ALLOW_EMPTY_PASSWORD=${ALLOW_EMPTY_PASSWORD}. For safety reasons, do not use this flag in a production environment."
    }
    empty_password_error() {
        error "The $1 environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow the container to be started with blank passwords. This is recommended only for development."
        exit 1
    }

    for var in REDIS_MASTER_PORT_NUMBER; do
        local value=${!var}
        if ! err=$(validate_port "$value"); then
            error "The $var environment variable is invalid: $err"
            exit 1
        fi
    done
    if is_boolean_yes "$ALLOW_EMPTY_PASSWORD"; then
        empty_password_enabled_warn
    else
        # Root user
        if [[ -z "$REDIS_PASSWORD" ]]; then
            empty_password_error REDIS_PASSWORD
        fi
        # Replication user
        if [[ "$REDIS_REPLICATION_MODE" == "slave"  && -z "$REDIS_MASTER_PASSWORD" ]]; then
            empty_password_error REDIS_MASTER_PASSWORD
        fi
    fi
}

# Ensure the redis volume is initialised.
redis_initialize() {
    if [ -e "$REDIS_BASEDIR/etc/redis.conf" ]; then
	if [ -e "$REDIS_BASEDIR/etc/redis-default.conf" ]; then
	    rm "$REDIS_BASEDIR/etc/redis-default.conf"
	fi
	return
    fi

    for dir in "$REDIS_VOLUME/data" "$REDIS_BASEDIR/tmp" "$REDIS_LOGDIR"; do
        ensure_dir_exists "$dir"
        if am_i_root; then
            chown "$REDIS_DAEMON_USER:$REDIS_DAEMON_GROUP" "$dir"
        fi
    done

    mv "$REDIS_BASEDIR/etc/redis-default.conf" "$REDIS_BASEDIR/etc/redis.conf"

    # Redis config
    redis_conf_set dir "$REDIS_VOLUME/data"
    # Log to stdout
    redis_conf_set logfile ""
    redis_conf_set pidfile "$REDIS_BASEDIR/tmp/redis.pid"
    redis_conf_set daemonize yes

    # Allow remote connections
    redis_conf_set bind 0.0.0.0

    # Enable AOF https://redis.io/topics/persistence#append-only-file
    # Leave default fsync (every second)
    redis_conf_set appendonly yes

    if [ -n "$REDIS_PASSWORD" ]; then
        redis_conf_set requirepass "$REDIS_PASSWORD"
    else
        redis_conf_unset requirepass
    fi
    if [ -n "$REDIS_DISABLE_COMMANDS" ]; then
        # The current syntax gets a comma separated list of commands, we split them
        # before passing to redis_disable_unsafe_commands
        redis_disable_unsafe_commands $(tr ',' ' ' <<<"$REDIS_DISABLE_COMMANDS")
    fi

    if [ -n "$REDIS_REPLICATION_MODE" ]; then
        redis_configure_replication "$REDIS_REPLICATION_MODE"
    fi
}

redis_disable_unsafe_commands() {
    info "Disabling commands: $*"
    for cmd in "$@"; do
        if egrep -q "^\s*rename-command\s+$cmd\s+\"\"\s*$" "$REDIS_BASEDIR/etc/redis.conf" ; then
            info "$cmd was already disabled"
            continue
        fi
        cat >> "$REDIS_BASEDIR/etc/redis.conf" <<EOF
rename-command $cmd ""
EOF
    done
}

redis_configure_replication() {
    local mode="${1:?empty replication mode}"
    # We should just add REDIS_REPLICATION_MODE to validations
    # and assume is correct
    if [ "$mode" == "master" ]; then
        if [ -n "$REDIS_PASSWORD" ]; then
            redis_conf_set masterauth "$REDIS_PASSWORD"
        fi
    elif [ "$mode" == "slave" ]; then
        wait-for-port --host "$REDIS_MASTER_HOST" "$REDIS_MASTER_PORT_NUMBER"
        if [ -n "$REDIS_MASTER_PASSWORD" ]; then
            redis_conf_set masterauth "$REDIS_MASTER_PASSWORD"
        fi
        redis_conf_set slaveof "$REDIS_MASTER_HOST $REDIS_MASTER_PORT_NUMBER"
    fi
}

# Sets a configuration setting
redis_conf_set() {
    # TODO: improve this. Substitute action?
    local name="${1:?missing key}"
    local value="${2:-}"

    # Sanitize inputs
    value=${value//\\/\\\\}
    value=${value//&/\\&}
    value=${value//\?/\\?}
    if [ "$value" == "" ]; then
        value="\"$value\""
    fi
    sed -i "s?^#*\s*$name .*?$name $value?g" "$REDIS_BASEDIR/etc/redis.conf"
}

# Retrieves a configuration setting value
redis_conf_get() {
    local name="${1:?missing key}"
    local value=$(grep -E "^\s*$name " "$REDIS_BASEDIR/etc/redis.conf" | awk '{print $2}')
    echo "$value"
}


# Unsets a configuration directive
redis_conf_unset() {
    # TODO: improve this. Substitute action?
    local name="${1:?missing key}"
    sed -i "s?^\s*$name .*??g" "$REDIS_BASEDIR/etc/redis.conf"
}


# Checks if redis is running
is_redis_running() {
    local pid
    pid="$(get_pid "$REDIS_BASEDIR/tmp/redis.pid")"

    if [ -z "$pid" ]; then
        false
    else
        is_service_running "$pid"
    fi
}

# Stops redis
redis_stop() {
    if ! is_redis_running ; then
        return
    fi

    local pass=""
    local port=""

    pass=$(redis_conf_get "requirepass")
    port=$(redis_conf_get "port")

    local args=""
    if [ -n "$pass" ]; then
        args="-a \"$pass\""
    fi

    if [ "$port" != "0" ]; then
        args="$args -p $port"
    fi

    if am_i_root; then
        gosu "$REDIS_DAEMON_USER" "$REDIS_BASEDIR/bin/redis-cli" $args shutdown
    else
        "$REDIS_BASEDIR/bin/redis-cli" $args shutdown
    fi

    local counter=5
    while is_redis_running ; do
        if [[ "$counter" -ne 0 ]]; then
            break
        fi
        sleep 1;
        counter=$((counter - 1))
    done
}

# Starts redis
redis_start() {
    if is_redis_running ; then
        return
    fi
    if am_i_root; then
        gosu "$REDIS_DAEMON_USER" "$REDIS_BASEDIR/bin/redis-server" "$REDIS_BASEDIR/etc/redis.conf"
    else
        "$REDIS_BASEDIR/bin/redis-server" "$REDIS_BASEDIR/etc/redis.conf"
    fi
    local counter=3
    while ! is_redis_running ; do
        if [[ "$counter" -ne 0 ]]; then
            break
        fi
        sleep 1;
        counter=$((counter - 1))
    done
}
