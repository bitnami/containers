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
export MARIADB_ROOT_PASSWORD=${MARIADB_ROOT_PASSWORD:-}
export MARIADB_USER=${MARIADB_USER:-}
export MARIADB_PASSWORD=${MARIADB_PASSWORD:-}
export MARIADB_DATABASE=${MARIADB_DATABASE:-}
export MARIADB_PORT=${MARIADB_PORT:-}
export MARIADB_REPLICATION_MODE=${MARIADB_REPLICATION_MODE:-}
export MARIADB_REPLICATION_USER=${MARIADB_REPLICATION_USER:-}
export MARIADB_REPLICATION_PASSWORD=${MARIADB_REPLICATION_PASSWORD:-}
export MARIADB_MASTER_HOST=${MARIADB_MASTER_HOST:-}
export MARIADB_MASTER_PORT=${MARIADB_MASTER_PORT:-3306}
export MARIADB_MASTER_USER=${MARIADB_MASTER_USER:-root}
export MARIADB_MASTER_PASSWORD=${MARIADB_MASTER_PASSWORD:-}

if [[ "$1" == "nami" && "$2" == "start" ]] ||  [[ "$1" == "/init.sh" ]]; then
    initialize mariadb
    echo "Starting application ..."
fi

exec /entrypoint.sh "$@"
