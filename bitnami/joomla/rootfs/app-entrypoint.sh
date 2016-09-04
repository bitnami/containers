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
export APACHE_HTTP_PORT=${APACHE_HTTP_PORT:-"80"}
export APACHE_HTTPS_PORT=${APACHE_HTTPS_PORT:-"443"}
export JOOMLA_FIRST_NAME=${JOOMLA_FIRST_NAME:-"User"}
export JOOMLA_LAST_NAME=${JOOMLA_LAST_NAME:-"Name"}
export JOOMLA_USERNAME=${JOOMLA_USERNAME:-"user"}
export JOOMLA_PASSWORD=${JOOMLA_PASSWORD:-"bitnami"}
export JOOMLA_EMAIL=${JOOMLA_EMAIL:-"user@example.com"}
export MARIADB_USER=${MARIADB_USER:-"root"}
export MARIADB_HOST=${MARIADB_HOST:-"mariadb"}
export MARIADB_PORT=${MARIADB_PORT:-"3306"}

if [[ "$1" == "nami" && "$2" == "start" ]] ||  [[ "$1" == "/init.sh" ]]; then
   for module in apache php joomla; do
    initialize $module
   done
   echo "Starting application ..."
fi

exec /entrypoint.sh "$@"
