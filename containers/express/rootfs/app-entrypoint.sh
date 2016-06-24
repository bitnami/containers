#!/bin/bash
set -e

INIT_SEM=/tmp/initialized.sem
PACKAGE_FILE=/app/package.json

fresh_container() {
  [ ! -f $INIT_SEM ]
}

app_present() {
  [ -f /app/app.js ]
}

dependencies_up_to_date() {
  # It it up to date if the package file is older than
  # the last time the container was initialized
  [ ! $PACKAGE_FILE -nt $INIT_SEM ]
}

database_tier_exists() {
  [ ! -z "$(getent hosts mongodb)" ]
}

wait_for_db() {
  mongodb_address=$(getent hosts mongodb | awk '{ print $1 }')
  counter=0

  log "Connecting to MongoDB at $mongodb_address"

  until nc -z $mongodb_address 27017; do
    counter=$((counter+1))
    if [ $counter == 10 ]; then
      log "Error: Couldn't connect to MongoDB."
      exit 1
    fi
    log "Trying to connect to MongoDB at $mongodb_address. Attempt $counter."
    sleep 5
  done
  log "Connected to MongoDB database"
}

setup_db() {
  npm install mongodb@2.1.18 --save
  log "Adding MongoDB example files under /config/mongodb.js"
  cp -rn /app_template/config .
}

log () {
  echo -e "\033[0;33m$(date "+%H:%M:%S")\033[0;37m ==> $1."
}

if [ "$1" == npm -a "$2" == "start" ]; then
  if ! app_present; then
    log "Creating express application"
    express . -f
  fi

  if ! dependencies_up_to_date; then
    log "Installing/Updating Express dependencies (npm)"
    npm install
    log "Dependencies updated"
  fi

  if database_tier_exists; then
    wait_for_db
  fi

  if ! fresh_container; then
    echo "#########################################################################"
    echo "                                                                       "
    echo " App initialization skipped:"
    echo " Delete the file $INIT_SEM and restart the container to reinitialize"
    echo " You can alternatively run specific commands using docker-compose exec"
    echo " e.g docker-compose exec myapp npm install angular"
    echo "                                                                       "
    echo "#########################################################################"
  else
    if database_tier_exists; then
      setup_db
    fi
    log "Initialization finished"
  fi

  touch $INIT_SEM
fi

exec /entrypoint.sh "$@"
