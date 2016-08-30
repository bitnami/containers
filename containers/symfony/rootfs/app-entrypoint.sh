#!/bin/bash
set -e

# Set default values
export MARIADB_USER=${MARIADB_USER:-"root"}
export MARIADB_HOST=${MARIADB_HOST:-"mariadb"}
export MARIADB_PORT=${MARIADB_PORT:-"3306"}
export SYMFONY_PROJECT_NAME=${SYMFONY_PROJECT_NAME:-"appasd_template"}

PROJECT_DIRECTORY=/app/$SYMFONY_PROJECT_NAME

log () {
    echo -e "\033[0;33m$(date "+%H:%M:%S")\033[0;37m ==> $1."
}

sudo -i harpoon restart mariadb
echo "Starting application ..."

if [ "$1" == "php" -a "$2" == "-S" ] ; then
    if [ ! -d $PROJECT_DIRECTORY ] ; then
      harpoon initialize symfony --inputs-file=/symfony-inputs.json
      log "Creating example Symfony application"
      cd /app
      harpoon execute symfony createProject $SYMFONY_PROJECT_NAME
      log "Symfony app created"
      cd $SYMFONY_PROJECT_NAME
    else
      log "App already created"
      cd $PROJECT_DIRECTORY
    fi
  if [ ! -f $PROJECT_DIRECTORY/web/index.php ] ; then
    ln -s $PROJECT_DIRECTORY/web/app.php $PROJECT_DIRECTORY/web/index.php
  fi
  exec /entrypoint.sh "$@" -t $PROJECT_DIRECTORY/web
fi


exec "$@"
