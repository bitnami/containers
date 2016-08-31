#!/bin/bash
set -e

# Set default values
export MARIADB_USER=${MARIADB_USER:-"root"}
export MARIADB_HOST=${MARIADB_HOST:-"mariadb"}
export MARIADB_PORT=${MARIADB_PORT:-"3306"}
export SYMFONY_PROJECT_NAME=${SYMFONY_PROJECT_NAME:-"app_template"}

PROJECT_DIRECTORY=/app/$SYMFONY_PROJECT_NAME
DEPLOY="$@"

log () {
    echo -e "\033[0;33m$(date "+%H:%M:%S")\033[0;37m ==> $1."
}

harpoon restart mariadb
echo "Starting application ..."

if [ "$1" == "php" -a "$2" == "-S" ] ; then
    if [ ! -d $PROJECT_DIRECTORY ] ; then
      log "Creating example Symfony application"
      harpoon execute symfony createProject $SYMFONY_PROJECT_NAME
      log "Symfony app created"
      cd $SYMFONY_PROJECT_NAME
    else
      log "App already created"
      cd $PROJECT_DIRECTORY
    fi
  if [ ! -f $PROJECT_DIRECTORY/web/index.php ] ; then
    sudo ln -s $PROJECT_DIRECTORY/web/app.php $PROJECT_DIRECTORY/web/index.php
  fi
  DEPLOY="$@ -t $PROJECT_DIRECTORY/web/"
fi

exec /entrypoint.sh $DEPLOY
