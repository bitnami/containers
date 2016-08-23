#!/bin/bash
set -e

function initialize {
    # Package can be "installed" or "unpacked"
    status=`harpoon inspect $1`
    if [[ "$status" == *'"lifecycle": "unpacked"'* ]]; then
        # Clean up inputs
        inputs=""
        if [[ -f /$1-inputs.json ]]; then
            inputs=--inputs-file=/$1-inputs.json
        fi
        harpoon initialize $1 $inputs
    fi
}

# Set default values
export JASPERSERVER_USERNAME=${JASPERSERVER_USERNAME:-"user"}
export JASPERSERVER_PASSWORD=${JASPERSERVER_PASSWORD:-"bitnami"}
export MARIADB_USER=${MARIADB_USER:-"root"}
export MARIADB_HOST=${MARIADB_HOST:-"mariadb"}
export MARIADB_PORT=${MARIADB_PORT:-"3306"}



if [[ "$1" == "harpoon" && "$2" == "start" ]] ||  [[ "$1" == "/init.sh" ]]; then
   initialize jasperserver
   echo "Starting application ..."
fi

exec /entrypoint.sh "$@"
