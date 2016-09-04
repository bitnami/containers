#!/bin/bash -e

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
export WILDFLY_USER=${WILDFLY_USER:-user}
export WILDFLY_PASSWORD=${WILDFLY_PASSWORD:-password}

if [[ "$1" == "nami" && "$2" == "start" ]] ||  [[ "$1" == "/init.sh" ]]; then
   for module in wildfly; do
    initialize $module
   done
   echo "Starting application ..."
fi

exec /entrypoint.sh "$@"
