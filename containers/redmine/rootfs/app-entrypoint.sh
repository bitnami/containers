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


if [[ "$1" == "nami" && "$2" == "start" ]]; then
  # Package can be "installed" or "unpacked"
  status=`nami inspect $BITNAMI_APP_NAME`
  if [[ "$status" == *'"lifecycle": "unpacked"'* ]]; then
      nami initialize $BITNAMI_APP_NAME --inputs-file=/inputs.json
      echo "Starting application..."
  fi
fi

exec /entrypoint.sh "$@"
