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
export POSTGRES_USER=${POSTGRES_USER:-postgres}
export POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-}
export POSTGRES_DB=${POSTGRES_DB:-}
export POSTGRES_MODE=${POSTGRES_MODE:-master}
export POSTGRES_REPLICATION_USER=${POSTGRES_REPLICATION_USER:-}
export POSTGRES_REPLICATION_PASSWORD=${POSTGRES_REPLICATION_PASSWORD:-}
export POSTGRES_MASTER_HOST=${POSTGRES_MASTER_HOST:-}
export POSTGRES_MASTER_PORT=${POSTGRES_MASTER_PORT:-5432}

if [[ "$1" == "nami" && "$2" == "start" ]] ||  [[ "$1" == "/init.sh" ]]; then
    initialize postgresql
    chown -R :$BITNAMI_APP_USER /bitnami/postgresql || true
    echo "Starting application ..."
fi

exec /entrypoint.sh "$@"
