#!/bin/bash -e

function initialize {
    # Package can be "installed" or "unpacked"
    status=`nami inspect $1`
    if [[ "$status" == *'"lifecycle": "unpacked"'* ]]; then
        # Clean up inputs
        inputs=""
        if [[ -f /$1-inputs.json ]]; then
            inputs=--inputs-file=/$1-inputs.json
        fi
        nami initialize $1 $inputs
    fi
}

# Set default values
export MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-}
export MYSQL_USER=${MYSQL_USER:-}
export MYSQL_PASSWORD=${MYSQL_PASSWORD:-}
export MYSQL_DATABASE=${MYSQL_DATABASE:-}
export MYSQL_REPLICATION_MODE=${MYSQL_REPLICATION_MODE:-}
export MYSQL_REPLICATION_USER=${MYSQL_REPLICATION_USER:-}
export MYSQL_REPLICATION_PASSWORD=${MYSQL_REPLICATION_PASSWORD:-}
export MYSQL_MASTER_HOST=${MYSQL_MASTER_HOST:-}
export MYSQL_MASTER_PORT=${MYSQL_MASTER_PORT:-3306}
export MYSQL_MASTER_USER=${MYSQL_MASTER_USER:-root}
export MYSQL_MASTER_PASSWORD=${MYSQL_MASTER_PASSWORD:-}

if [[ "$1" == "nami" && "$2" == "start" ]] ||  [[ "$1" == "/init.sh" ]]; then
    initialize mysql
    chown -R :$BITNAMI_APP_USER /bitnami/mysql || true
    echo "Starting application ..."
fi

exec /entrypoint.sh "$@"
