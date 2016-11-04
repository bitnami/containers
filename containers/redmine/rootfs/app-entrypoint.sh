#!/bin/bash -e

function initialize {
    # Package can be "installed" or "unpacked"
    status=`nami inspect $1`
    if [[ "$status" == *'"lifecycle": "unpacked"'* ]]; then
        inputs=""
        if [[ -f /$1-inputs.json ]]; then
            inputs=--inputs-file=/$1-inputs.json
        fi
        nami initialize $1 $inputs
    fi
}

# Set default values
export REDMINE_USERNAME=${REDMINE_USERNAME:-"user"}
export REDMINE_PASSWORD=${REDMINE_PASSWORD:-"bitnami"}
export REDMINE_EMAIL=${REDMINE_EMAIL:-"user@example.com"}
export REDMINE_LANGUAGE=${REDMINE_LANGUAGE:-"en"}
export MARIADB_USER=${MARIADB_USER:-"root"}
export MARIADB_HOST=${MARIADB_HOST:-"mariadb"}
export MARIADB_PORT=${MARIADB_PORT:-"3306"}

if [[ "$1" == "nami" && "$2" == "start" ]] ||  [[ "$1" == "/init.sh" ]]; then
   for module in redmine; do
    initialize $module
   done
   echo "Starting application ..."
fi

exec /entrypoint.sh "$@"
