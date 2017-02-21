#!/bin/bash -e
. /opt/bitnami/base/functions

print_welcome_page
check_for_updates &

PROJECT_DIRECTORY=/app/$CODEIGNITER_PROJECT_NAME
DEPLOY="$@"

nami restart mariadb
echo "Starting application ..."

if [ "$1" == "php" -a "$2" == "-S" ] ; then
    if [ ! -d $PROJECT_DIRECTORY ] ; then
      log "Creating example Codeigniter application"
      nami execute codeigniter createProject $CODEIGNITER_PROJECT_NAME
      log "Codeigniter app created"
    else
      log "App already created"
      cd $PROJECT_DIRECTORY
    fi
  DEPLOY="$@ -t $PROJECT_DIRECTORY"
fi

exec tini -- $DEPLOY
