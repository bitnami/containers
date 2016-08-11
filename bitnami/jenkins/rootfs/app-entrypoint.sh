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
export JENKINS_USERNAME=${JENKINS_USERNAME:-"user"}
export JENKINS_PASSWORD=${JENKINS_PASSWORD:-"bitnami"}



if [[ "$1" == "harpoon" && "$2" == "start" ]] ||  [[ "$1" == "/init.sh" ]]; then
   initialize jenkins
   echo "Starting application ..."
fi

exec /entrypoint.sh "$@"
