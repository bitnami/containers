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
export ODOO_PASSWORD=${ODOO_PASSWORD:-"bitnami"}
export ODOO_EMAIL=${ODOO_EMAIL:-"user@example.com"}
export POSTGRESQL_USER=${POSTGRESQL_USER:-"postgres"}
export POSTGRESQL_HOST=${POSTGRESQL_HOST:-"postgresql"}
export POSTGRESQL_PORT=${POSTGRESQL_PORT:-"5432"}



if [[ "$1" == "nami" && "$2" == "start" ]] ||  [[ "$1" == "/init.sh" ]]; then
   initialize odoo
   echo "Starting application ..."
fi

exec /entrypoint.sh "$@"
