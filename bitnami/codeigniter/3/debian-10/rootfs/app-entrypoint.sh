#!/bin/bash -e

# shellcheck disable=SC1091

. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

print_welcome_page

PROJECT_DIRECTORY=/app/$CODEIGNITER_PROJECT_NAME
DEPLOY=("$@")

echo "Starting application ..."

if [[ "$1" = "php" && "$2" = "-S" ]]; then
    if [[ ! -d "$PROJECT_DIRECTORY" ]]; then
        log "Creating example Codeigniter application"
        nami execute codeigniter createProject --databaseServerHost "$MARIADB_HOST" --databaseServerPort "$MARIADB_PORT_NUMBER" --databaseAdminUser "$MARIADB_USER" "$CODEIGNITER_PROJECT_NAME" | grep -v undefined
        log "Codeigniter app created"
    else
        log "App already created"
        cd "$PROJECT_DIRECTORY"
    fi
    DEPLOY=("$@" "-t" "$PROJECT_DIRECTORY")
fi

exec tini -- "${DEPLOY[@]}"
