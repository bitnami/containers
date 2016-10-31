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
export APACHE_HTTP_PORT=${APACHE_HTTP_PORT:-"80"}
export APACHE_HTTPS_PORT=${APACHE_HTTPS_PORT:-"443"}
export OSCLASS_PING_ENGINES=${OSCLASS_PING_ENGINES:-"1"}
export OSCLASS_SAVE_STATS=${OSCLASS_SAVE_STATS:-"1"}
export OSCLASS_USERNAME=${OSCLASS_USERNAME:-"user"}
export OSCLASS_PASSWORD=${OSCLASS_PASSWORD:-"bitnami1"}
export OSCLASS_WEB_TITLE=${OSCLASS_WEB_TITLE:-"Sample Web Page"}
export OSCLASS_EMAIL=${OSCLASS_EMAIL:-"user@example.com"}
export MARIADB_USER=${MARIADB_USER:-"root"}
export MARIADB_HOST=${MARIADB_HOST:-"mariadb"}
export MARIADB_PORT=${MARIADB_PORT:-"3306"}



if [[ "$1" == "nami" && "$2" == "start" ]] ||  [[ "$1" == "/init.sh" ]]; then
   for module in apache osclass; do
    initialize $module
   done
   echo "Starting application ..."
fi

exec /entrypoint.sh "$@"
