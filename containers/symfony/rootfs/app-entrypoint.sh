#!/bin/bash
set -e

# Set default values
export MARIADB_USER=${MARIADB_USER:-"root"}
export MARIADB_HOST=${MARIADB_HOST:-"mariadb"}
export MARIADB_PORT=${MARIADB_PORT:-"3306"}
export SYMFONY_PROJECT_NAME=${SYMFONY_PROJECT_NAME:-"app_template"}

PROJECT_DIRECTORY=/app/$SYMFONY_PROJECT_NAME
DEPLOY="$@"
OLDHOME=$HOME
HOME=/root

log () {
    echo -e "\033[0;33m$(date "+%H:%M:%S")\033[0;37m ==> $1."
}

sudo harpoon restart mariadb
echo "Starting application ..."

if [ "$1" == "php" -a "$2" == "-S" ] ; then
    if [ ! -d $PROJECT_DIRECTORY ] ; then
      sudo harpoon initialize symfony --inputs-file=/symfony-inputs.json
      log "Creating example Symfony application"
      cd /app
      sudo harpoon execute symfony createProject $SYMFONY_PROJECT_NAME
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

HOME=$OLDHOME
exec /entrypoint.sh $DEPLOY
