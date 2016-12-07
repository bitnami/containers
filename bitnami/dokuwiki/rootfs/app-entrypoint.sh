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
export DOKUWIKI_USERNAME=${DOKUWIKI_USERNAME:-"superuser"}
export DOKUWIKI_FULLNAME=${DOKUWIKI_FULLNAME:-"Full Name"}
export DOKUWIKI_PASSWORD=${DOKUWIKI_PASSWORD:-"bitnami1"}
export DOKUWIKI_EMAIL=${DOKUWIKI_EMAIL:-"user@example.com"}
export DOKUWIKI_WIKINAME=${DOKUWIKI_WIKINAME:-"Bitnami DokuWiki"}



if [[ "$1" == "nami" && "$2" == "start" ]] ||  [[ "$1" == "/init.sh" ]]; then
   for module in apache dokuwiki; do
    initialize $module
   done
   echo "Starting application ..."
fi

exec /entrypoint.sh "$@"
