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
export TOMCAT_SHUTDOWN_PORT=${TOMCAT_SHUTDOWN_PORT:-"8005"}
export TOMCAT_HTTP_PORT=${TOMCAT_HTTP_PORT:-"8080"}
export TOMCAT_AJP_PORT=${TOMCAT_AJP_PORT:-"8009"}
export JAVA_OPTS=${JAVA_OPTS:-"-Djava.awt.headless=true -XX:+UseG1GC -Dfile.encoding=UTF-8"}
export TOMCAT_USERNAME=${TOMCAT_USERNAME:-"user"}

if [[ "$1" == "nami" && "$2" == "start" ]] ||  [[ "$1" == "/init.sh" ]]; then
   initialize tomcat
   echo "Starting application ..."
fi

exec /entrypoint.sh "$@"
