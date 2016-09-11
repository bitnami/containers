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
export MEMCACHED_USERNAME=${MEMCACHED_USERNAME:-root}
export MEMCACHED_PASSWORD=${MEMCACHED_PASSWORD:-}

if [[ "$1" == "nami" && "$2" == "start" ]] ||  [[ "$1" == "/init.sh" ]]; then
    initialize memcached
    chown -R :$BITNAMI_APP_USER /bitnami/memcached || true
    echo "Starting application ..."
fi

exec /entrypoint.sh "$@"
