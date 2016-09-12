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
export RABBITMQ_VHOST=${RABBITMQ_VHOST:-"/"}
export RABBITMQ_USERNAME=${RABBITMQ_USERNAME:-"user"}
export RABBITMQ_PASSWORD=${RABBITMQ_PASSWORD:-"bitnami"}
export RABBITMQ_NODE_TYPE=${RABBITMQ_NODE_TYPE:-"stats"}
export RABBITMQ_NODE_PORT=${RABBITMQ_NODE_PORT:-"5672"}
export RABBITMQ_NODE_NAME=${RABBITMQ_NODE_NAME:-"rabbit"}
export RABBITMQ_MANAGER_PORT=${RABBITMQ_MANAGER_PORT:-"15672"}

if [[ "$1" == "nami" && "$2" == "start" ]] ||  [[ "$1" == "/init.sh" ]]; then
   initialize rabbitmq
   echo "Starting application ..."
fi

exec /entrypoint.sh "$@"
