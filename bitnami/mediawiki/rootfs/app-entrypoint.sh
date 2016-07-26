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
export APACHE_HTTP_PORT=${APACHE_HTTP_PORT:-"80"}
export APACHE_HTTPS_PORT=${APACHE_HTTPS_PORT:-"443"}
export MEDIAWIKI_USERNAME=${MEDIAWIKI_USERNAME:-"user"}
export MEDIAWIKI_PASSWORD=${MEDIAWIKI_PASSWORD:-"bitnami1"}
export MEDIAWIKI_EMAIL=${MEDIAWIKI_EMAIL:-"user@example.com"}
export MEDIAWIKI_WIKI_NAME=${MEDIAWIKI_WIKI_NAME:-"Bitnami MediaWiki"}
export MARIADB_USER=${MARIADB_USER:-"root"}
export MARIADB_HOST=${MARIADB_HOST:-"mariadb"}
export MARIADB_PORT=${MARIADB_PORT:-"3306"}



if [[ "$1" == "harpoon" && "$2" == "start" ]] ||  [[ "$1" == "/init.sh" ]]; then
   for module in apache mediawiki; do
    initialize $module
   done
   echo "Starting application ..."
fi

exec /entrypoint.sh "$@"
