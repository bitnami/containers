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
export SOLR_PORT=${SOLR_PORT:-"8983"}
export SOLR_SERVER_DIRECTORY=${SOLR_SERVER_DIRECTORY:-"server"}
export SOLR_CORE_CONF_DIR=${SOLR_CORE_CONF_DIR:-"data_driven_schema_configs"}



if [[ "$1" == "nami" && "$2" == "start" ]] ||  [[ "$1" == "/init.sh" ]]; then
   initialize solr
   echo "Starting application ..."
fi

exec /entrypoint.sh "$@"
