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
export MOODLE_USERNAME=${MOODLE_USERNAME:-"user"}
export MOODLE_PASSWORD=${MOODLE_PASSWORD:-"bitnami"}
export MOODLE_EMAIL=${MOODLE_EMAIL:-"user@example.com"}
export MOODLE_LANGUAGE=${MOODLE_LANGUAGE:-"en"}
export MARIADB_USER=${MARIADB_USER:-"root"}
export MARIADB_HOST=${MARIADB_HOST:-"mariadb"}
export MARIADB_PORT=${MARIADB_PORT:-"3306"}
export MOODLE_SITENAME=${MOODLE_SITENAME:-"New Site"}


# Adding cron entries
test -f /opt/bitnami/moodle/conf/cron && ln -fs /opt/bitnami/moodle/conf/cron /etc/cron.d/moodle

if [[ "$1" == "nami" && "$2" == "start" ]] ||  [[ "$1" == "/init.sh" ]]; then
   for module in apache php moodle; do
    initialize $module
   done
   echo "Starting application ..."
fi

exec /entrypoint.sh "$@"
