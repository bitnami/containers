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
export PHPBB_FIRST_NAME=${PHPBB_FIRST_NAME:-"User"}
export PHPBB_LAST_NAME=${PHPBB_LAST_NAME:-"Name"}
export PHPBB_USERNAME=${PHPBB_USERNAME:-"user"}
export PHPBB_PASSWORD=${PHPBB_PASSWORD:-"bitnami"}
export PHPBB_EMAIL=${PHPBB_EMAIL:-"user@example.com"}
export MARIADB_USER=${MARIADB_USER:-"root"}
export MARIADB_HOST=${MARIADB_HOST:-"mariadb"}
export MARIADB_PORT=${MARIADB_PORT:-"3306"}

if [[ "$1" == "nami" && "$2" == "start" ]] ||  [[ "$1" == "/init.sh" ]]; then
   for module in apache php phpbb; do
    initialize $module
   done
   echo "Starting application ..."
fi

exec /entrypoint.sh "$@"
