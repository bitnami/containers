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
export APACHE_HTTP_PORT=${APACHE_HTTP_PORT:-"80"}
export APACHE_HTTPS_PORT=${APACHE_HTTPS_PORT:-"443"}
export WORDPRESS_USERNAME=${WORDPRESS_USERNAME:-"user"}
export WORDPRESS_PASSWORD=${WORDPRESS_PASSWORD:-"bitnami"}
export WORDPRESS_EMAIL=${WORDPRESS_EMAIL:-"user@example.com"}
export WORDPRESS_FIRST_NAME=${WORDPRESS_FIRST_NAME:-"FirstName"}
export WORDPRESS_LAST_NAME=${WORDPRESS_LAST_NAME:-"LastName"}
export WORDPRESS_BLOG_NAME=${WORDPRESS_BLOG_NAME:-"User's Blog!"}
export MARIADB_USER=${MARIADB_USER:-"root"}
export MARIADB_HOST=${MARIADB_HOST:-"mariadb"}
export MARIADB_PORT=${MARIADB_PORT:-"3306"}



if [[ "$1" == "nami" && "$2" == "start" ]] ||  [[ "$1" == "/init.sh" ]]; then
   for module in apache php wordpress; do
    initialize $module
   done
   echo "Starting application ..."
fi

exec /entrypoint.sh "$@"
