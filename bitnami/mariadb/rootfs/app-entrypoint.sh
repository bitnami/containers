#!/bin/bash -e

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

if [[ "$1" == "nami" && "$2" == "start" ]] ||  [[ "$1" == "/init.sh" ]]; then
    initialize mariadb
    echo "Starting application ..."
fi

exec /entrypoint.sh "$@"
