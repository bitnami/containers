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
export MONGODB_ROOT_PASSWORD=${MONGODB_ROOT_PASSWORD:-}
export MONGODB_USER=${MONGODB_USER:-}
export MONGODB_PASSWORD=${MONGODB_PASSWORD:-}
export MONGODB_DATABASE=${MONGODB_DATABASE:-}
export MONGODB_REPLICA_SET_MODE=${MONGODB_REPLICA_SET_MODE:-}
export MONGODB_REPLICA_SET_NAME=${MONGODB_REPLICA_SET_NAME:-}
export MONGODB_PRIMARY_HOST=${MONGODB_PRIMARY_HOST:-}
export MONGODB_PRIMARY_PORT=${MONGODB_PRIMARY_PORT:-27017}
export MONGODB_PRIMARY_USER=${MONGODB_PRIMARY_USER:-root}
export MONGODB_PRIMARY_PASSWORD=${MONGODB_PRIMARY_PASSWORD:-}

if [[ "$1" == "nami" && "$2" == "start" ]] ||  [[ "$1" == "/init.sh" ]]; then
    initialize mongodb
    chown -R :$BITNAMI_APP_USER /bitnami/mongodb || true
    echo "Starting application ..."
fi

exec /entrypoint.sh "$@"
