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
export POSTGRESQL_USERNAME=${POSTGRESQL_USERNAME:-postgres}
export POSTGRESQL_PASSWORD=${POSTGRESQL_PASSWORD:-}
export POSTGRESQL_DATABASE=${POSTGRESQL_DATABASE:-}
export POSTGRESQL_REPLICATION_MODE=${POSTGRESQL_REPLICATION_MODE:-master}
export POSTGRESQL_REPLICATION_USER=${POSTGRESQL_REPLICATION_USER:-}
export POSTGRESQL_REPLICATION_PASSWORD=${POSTGRESQL_REPLICATION_PASSWORD:-}
export POSTGRESQL_MASTER_HOST=${POSTGRESQL_MASTER_HOST:-}
export POSTGRESQL_MASTER_PORT=${POSTGRESQL_MASTER_PORT:-5432}

if [[ "$1" == "nami" && "$2" == "start" ]] ||  [[ "$1" == "/init.sh" ]]; then
    initialize postgresql
    chown -R :$BITNAMI_APP_USER /bitnami/postgresql || true
    echo "Starting application ..."
fi

exec /entrypoint.sh "$@"
