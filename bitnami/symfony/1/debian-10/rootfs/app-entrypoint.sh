#!/bin/bash -e

. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

print_welcome_page

if [[ "$1" == "nami" && "$2" == "start" ]] || [[ "$1" == "/run.sh" ]]; then
    #!/bin/bash

export PROJECT_DIRECTORY="/app/$SYMFONY_PROJECT_NAME"

echo "Starting application ..."

if [ "$1" = "/run.sh" ]; then
  # Create a Symfony app if not found
  if [ ! -d "$PROJECT_DIRECTORY" ] ; then
    log "Creating a project with symfony/skeleton"

    composer create-project symfony/skeleton "$SYMFONY_PROJECT_NAME"

    if [ -z "$SYMFONY_SKIP_DB" ] ; then
      log "Installing symfony/orm-pack"
      composer require symfony/orm-pack -d "$PROJECT_DIRECTORY"

      export DATABASE_URL="mysql://$MARIADB_USER:$MARIADB_PASSWORD@$MARIADB_HOST:$MARIADB_PORT_NUMBER/$MARIADB_DATABASE"

      if [ ! -f "$PROJECT_DIRECTORY/.env.local" ] ; then
        touch "$PROJECT_DIRECTORY/.env.local"
        echo "DATABASE_URL=$DATABASE_URL" >> "$PROJECT_DIRECTORY/.env.local"
        log "Added MariaDB container credentials to .env.local"
      fi
    fi

    log "Symfony app created"
  else
    log "App already created"
  fi

  # Symfony 3.x -> web/
  [ -d "$PROJECT_DIRECTORY/web" ] && export WEB_DIR=$PROJECT_DIRECTORY/web
  # Symfony 4.x -> public/
  [ -d "$PROJECT_DIRECTORY/public" ] && export WEB_DIR=$PROJECT_DIRECTORY/public

  # Link Symfony app to the index
  if [ ! -f "$WEB_DIR/index.php" ] && [ -f "$WEB_DIR/app.php" ]; then
    ln -s "$WEB_DIR/app.php" "$WEB_DIR/index.php"
  fi
fi

echo "symfony successfully initialized"

    nami_initialize php
    info "Starting symfony... "
fi

exec tini -- "$@"
