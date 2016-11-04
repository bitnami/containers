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
export PARSE_SERVER_HOST=${PARSE_SERVER_HOST:-"parse"}
export PARSE_SERVER_PORT=${PARSE_SERVER_PORT:-"1337"}
export PARSE_SERVER_MOUNT_PATH=${PARSE_SERVER_MOUNT_PATH:-"/parse"}
export PARSE_SERVER_MASTER_KEY=${PARSE_SERVER_MASTER_KEY:-"mymasterKey"}
export PARSE_SERVER_APP_ID=${PARSE_SERVER_APP_ID:-"myappID"}
export PARSE_DASHBOARD_APP_NAME=${PARSE_DASHBOARD_APP_NAME:-"MyDashboard"}
export PARSE_DASHBOARD_USER=${PARSE_DASHBOARD_USER:-"user"}
export PARSE_DASHBOARD_PASSWORD=${PARSE_DASHBOARD_PASSWORD:-"bitnami"}



if [[ "$1" == "nami" && "$2" == "start" ]] ||  [[ "$1" == "/init.sh" ]]; then
   initialize parse-dashboard
   echo "Starting application ..."
fi

exec /entrypoint.sh "$@"
