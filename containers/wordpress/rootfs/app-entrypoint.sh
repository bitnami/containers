#!/bin/bash
set -e

function initialize {
    # Package can be "installed" or "unpacked"
    status=`harpoon inspect $1`
    if [[ "$status" == *'"lifecycle": "unpacked"'* ]]; then
        if [[ -f /$1-inputs.json ]]; then
            inputs=--inputs-file=/$1-inputs.json
        fi
        harpoon initialize $1 $inputs
    fi
}

# Set default values
export WORDPRESS_USERNAME=${WORDPRESS_USERNAME:-"user"}
export WORDPRESS_PASSWORD=${WORDPRESS_PASSWORD:-"bitnami"}
export WORDPRESS_EMAIL=${WORDPRESS_EMAIL:-"user@example.com"}
export MARIADB_USER=${MARIADB_USER:-"root"}
export MARIADB_HOST=${MARIADB_HOST:-"mariadb"}
export MARIADB_PORT=${MARIADB_PORT:-"3306"}

if [[ "$1" == "harpoon" && "$2" == "start" ]]; then
   for module in apache wordpress; do
    initialize $module
   done
   echo "Starting application ..."
fi

exec /entrypoint.sh "$@"
