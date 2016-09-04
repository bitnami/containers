#!/bin/bash
set -e

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
export DRUPAL_USERNAME=${DRUPAL_USERNAME:-"user"}
export DRUPAL_PASSWORD=${DRUPAL_PASSWORD:-"bitnami"}
export DRUPAL_EMAIL=${DRUPAL_EMAIL:-"user@example.com"}
export MARIADB_USER=${MARIADB_USER:-"root"}
export MARIADB_HOST=${MARIADB_HOST:-"mariadb"}
export MARIADB_PORT=${MARIADB_PORT:-"3306"}

if [[ "$1" == "nami" && "$2" == "start" ]]; then
   for module in apache php drupal; do
    initialize $module
   done
   echo "Starting application ..."
fi

exec /entrypoint.sh "$@"
