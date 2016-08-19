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
export GHOST_PORT=${GHOST_PORT:-"80"}
export GHOST_USERNAME=${GHOST_USERNAME:-"user"}
export GHOST_PASSWORD=${GHOST_PASSWORD:-"bitnami1"}
export GHOST_EMAIL=${GHOST_EMAIL:-"user@example.com"}
export BLOG_TITLE=${BLOG_TITLE:-"User's Blog"}
export MARIADB_USER=${MARIADB_USER:-"root"}
export MARIADB_HOST=${MARIADB_HOST:-"mariadb"}
export MARIADB_PORT=${MARIADB_PORT:-"3306"}


if [[ "$1" == "harpoon" && "$2" == "start" ]] ||  [[ "$1" == "/init.sh" ]]; then
   initialize ghost
   echo "Starting application ..."
fi

exec /entrypoint.sh "$@"
