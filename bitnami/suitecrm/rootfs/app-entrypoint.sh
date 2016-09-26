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
export APACHE_HTTP_PORT=${APACHE_HTTP_PORT:-"80"}
export APACHE_HTTPS_PORT=${APACHE_HTTPS_PORT:-"443"}
export SUITECRM_USERNAME=${SUITECRM_USERNAME:-"user"}
export SUITECRM_LAST_NAME=${SUITECRM_LAST_NAME:-"Name"}
export SUITECRM_PASSWORD=${SUITECRM_PASSWORD:-"bitnami"}
export SUITECRM_EMAIL=${SUITECRM_EMAIL:-"user@example.com"}
export MARIADB_USER=${MARIADB_USER:-"root"}
export MARIADB_HOST=${MARIADB_HOST:-"mariadb"}
export MARIADB_PORT=${MARIADB_PORT:-"3306"}

# Adding cron entries
ln -fs /opt/bitnami/suitecrm/conf/cron /etc/cron.d/suitecrm


if [[ "$1" == "harpoon" && "$2" == "start" ]] ||  [[ "$1" == "/init.sh" ]]; then
   for module in apache suitecrm; do
    initialize $module
   done
   echo "Starting application ..."
fi

exec /entrypoint.sh "$@"
