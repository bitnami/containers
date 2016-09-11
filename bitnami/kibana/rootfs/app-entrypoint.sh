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
export KIBANA_PORT=${KIBANA_PORT:-"5601"}
export KIBANA_ELASTICSEARCH_URL=${KIBANA_ELASTICSEARCH_URL:-"elasticsearch"}
export KIBANA_ELASTICSEARCH_PORT=${KIBANA_ELASTICSEARCH_PORT:-"9200"}



if [[ "$1" == "nami" && "$2" == "start" ]] ||  [[ "$1" == "/init.sh" ]]; then
   initialize kibana
   echo "Starting application ..."
fi

exec /entrypoint.sh "$@"
