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
export PARSE_PORT=${PARSE_PORT:-"1337"}
export PARSE_HOST=${PARSE_HOST:-"127.0.0.1"}
export PARSE_MOUNT_PATH=${PARSE_MOUNT_PATH:-"/parse"}
export PARSE_APP_ID=${PARSE_APP_ID:-"myappID"}
export PARSE_MASTER_KEY=${PARSE_MASTER_KEY:-"mymasterKey"}
export MONGODB_HOST=${MONGODB_HOST:-"mongodb"}
export MONGODB_PORT=${MONGODB_PORT:-"27017"}



if [[ "$1" == "nami" && "$2" == "start" ]] ||  [[ "$1" == "/init.sh" ]]; then
   initialize parse
   echo "Starting application ..."
fi

exec /entrypoint.sh "$@"
