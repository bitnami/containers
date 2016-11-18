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
export REDIS_PASSWORD=${REDIS_PASSWORD:-}
export REDIS_REPLICATION_MODE=${REDIS_REPLICATION_MODE:-}
export REDIS_MASTER_HOST=${REDIS_MASTER_HOST:-}
export REDIS_MASTER_PORT=${REDIS_MASTER_PORT:-6379}
export REDIS_MASTER_PASSWORD=${REDIS_MASTER_PASSWORD:-}

if [[ "$1" == "nami" && "$2" == "start" ]] ||  [[ "$1" == "/init.sh" ]]; then
    initialize redis
    echo "Starting application ..."
fi

exec /entrypoint.sh "$@"
