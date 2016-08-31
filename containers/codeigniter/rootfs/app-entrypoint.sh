#!/bin/bash
set -e

# Set default values
export MARIADB_USER=${MARIADB_USER:-"root"}
export MARIADB_HOST=${MARIADB_HOST:-"mariadb"}
export MARIADB_PORT=${MARIADB_PORT:-"3306"}
export CODEIGNITER_PROJECT_NAME=${CODEIGNITER_PROJECT_NAME:-"appasd_template"}

PROJECT_DIRECTORY=/app/$CODEIGNITER_PROJECT_NAME
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
      log "Creating example Codeigniter application"
      cd /app
      sudo harpoon execute codeigniter createProject $CODEIGNITER_PROJECT_NAME
      log "Codeigniter app created"
      cd $CODEIGNITER_PROJECT_NAME
    else
      log "App already created"
      cd $PROJECT_DIRECTORY
    fi
  DEPLOY="$@ -t $PROJECT_DIRECTORY"
fi

HOME=$OLDHOME
exec /entrypoint.sh $DEPLOY
