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
export MAGENTO_USERNAME=${MAGENTO_USERNAME:-"user"}
export MAGENTO_PASSWORD=${MAGENTO_PASSWORD:-"bitnami1"}
export MAGENTO_EMAIL=${MAGENTO_EMAIL:-"user@example.com"}
export MAGENTO_ADMINURI=${MAGENTO_ADMINURI:-"admin"}
export MAGENTO_FIRSTNAME=${MAGENTO_FIRSTNAME:-"FirstName"}
export MAGENTO_LASTNAME=${MAGENTO_LASTNAME:-"LastName"}
export MAGENTO_MODE=${MAGENTO_MODE:-"developer"}
export MARIADB_USER=${MARIADB_USER:-"root"}
export MARIADB_HOST=${MARIADB_HOST:-"mariadb"}
export MARIADB_PORT=${MARIADB_PORT:-"3306"}

# Adding cron entries
ln -fs /opt/bitnami/magento/conf/cron /etc/cron.d/magento


if [[ "$1" == "harpoon" && "$2" == "start" ]] ||  [[ "$1" == "/init.sh" ]]; then
   for module in apache magento; do
    initialize $module
   done
   echo "Starting application ..."
fi

exec /entrypoint.sh "$@"
