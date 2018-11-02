#!/bin/bash -e

. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

print_welcome_page

#!/bin/bash

export PROJECT_DIRECTORY="/app/$SYMFONY_PROJECT_NAME"

echo "Starting application ..."

if [ "$1" = "/run.sh" ]; then
  # Create a Symfony app if not found
  if [ ! -d "$PROJECT_DIRECTORY" ] ; then
    log "Creating example Symfony application"
    nami execute symfony createProject --databaseServerHost "$MARIADB_HOST" --databaseServerPort "$MARIADB_PORT_NUMBER" --databaseAdminUser "$MARIADB_USER" "$SYMFONY_PROJECT_NAME" | grep -v undefined
    log "Symfony app created"
  else
    log "App already created"
  fi

  # Link Symfony app to the index
  if [ ! -f "$PROJECT_DIRECTORY/web/index.php" ]; then
    sudo ln -s "$PROJECT_DIRECTORY/web/app.php" "$PROJECT_DIRECTORY/web/index.php"
  fi
fi

echo "symfony successfully initialized"


exec tini -- "$@"
