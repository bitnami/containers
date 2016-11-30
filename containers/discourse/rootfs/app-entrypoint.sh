#!/bin/bash
set -e

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
export DISCOURSE_USERNAME=${DISCOURSE_USERNAME:-"user"}
export DISCOURSE_PASSWORD=${DISCOURSE_PASSWORD:-"bitnami"}
export DISCOURSE_EMAIL=${DISCOURSE_EMAIL:-"user@example.com"}
export POSTGRES_USER=${POSTGRES_USER:-"postgres"}
export POSTGRES_MASTER_HOST=${POSTGRES_MASTER_HOST:-"postgresql"}
export REDIS_MASTER_HOST=${REDIS_MASTER_HOST:-"redis"}



if [[ "$1" == "nami" && "$2" == "start" ]] ||  [[ "$1" == "/init.sh" ]]; then
   initialize discourse
   echo "Starting application ..."
fi

exec /entrypoint.sh "$@"
