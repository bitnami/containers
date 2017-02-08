#!/bin/bash -e
. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

print_welcome_page
check_for_updates &

# Set default values
export REDMINE_USERNAME=${REDMINE_USERNAME:-"user"}
export REDMINE_PASSWORD=${REDMINE_PASSWORD:-"bitnami1"}
export REDMINE_EMAIL=${REDMINE_EMAIL:-"user@example.com"}
export REDMINE_LANGUAGE=${REDMINE_LANGUAGE:-"en"}
export MARIADB_USER=${MARIADB_USER:-"root"}
export MARIADB_HOST=${MARIADB_HOST:-"mariadb"}
export MARIADB_PORT=${MARIADB_PORT:-"3306"}

if [[ "$1" == "nami" && "$2" == "start" ]] || [[ "$1" == "/init.sh" ]]; then
  nami_initialize redmine
  info "Starting redmine..."
fi

exec tini -- "$@"
