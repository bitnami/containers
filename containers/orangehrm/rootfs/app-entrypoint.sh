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
export ORANGEHRM_USERNAME=${ORANGEHRM_USERNAME:-"admin"}
export ORANGEHRM_PASSWORD=${ORANGEHRM_PASSWORD:-"bitnami"}
export SMTP_PROTOCOL=${SMTP_PROTOCOL:-"none"}
export MARIADB_USER=${MARIADB_USER:-"root"}
export MARIADB_HOST=${MARIADB_HOST:-"mariadb"}
export MARIADB_PORT=${MARIADB_PORT:-"3306"}



if [[ "$1" == "nami" && "$2" == "start" ]] ||  [[ "$1" == "/init.sh" ]]; then
   initialize orangehrm
   echo "Starting application ..."
fi

exec /entrypoint.sh "$@"
