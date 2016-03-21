#!/bin/bash
set -e

# Set default values
export REDMINE_USERNAME=${REDMINE_USERNAME:-"user"}
export REDMINE_PASSWORD=${REDMINE_PASSWORD:-"bitnami"}
export REDMINE_EMAIL=${REDMINE_EMAIL:-"user@example.com"}
export REDMINE_LANG=${REDMINE_LANG:-"en"}
export MARIADB_USER=${MARIADB_USER:-"root"}
export MARIADB_HOST=${MARIADB_HOST:-"mariadb"}
export MARIADB_PORT=${MARIADB_PORT:-"3306"}

# Package can be "installed" or "unpacked"
status=`harpoon inspect redmine`
if [[ "$status" == *'"lifecycle": "unpacked"'* && "$1" == "harpoon" && "$2" == "start" ]]; then
    harpoon initialize redmine --inputs-file=/inputs.json
    echo "Starting application..."
fi

exec /entrypoint.sh "$@"
