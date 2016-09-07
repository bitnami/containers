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

# Set default values
export NGINX_HTTP_PORT=${NGINX_HTTP_PORT:-80}
export NGINX_HTTPS_PORT=${NGINX_HTTPS_PORT:-443}

if [[ "$1" == "nami" && "$2" == "start" ]] ||  [[ "$1" == "/init.sh" ]]; then
    initialize nginx
    chown -R :$BITNAMI_APP_USER /bitnami/nginx || true
    echo "Starting application ..."
fi

exec /entrypoint.sh "$@"
