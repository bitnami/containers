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

wait_for_db() {
  mariadb_address=$(getent hosts mariadb | awk '{ print $1 }')
  counter=0
  log "Connecting to mariadb at $mariadb_address"
  while ! curl --silent mariadb:3306 >/dev/null; do
    counter=$((counter+1))
    if [ $counter == 30 ]; then
      log "Error: Couldn't connect to mariadb."
      exit 1
    fi
    log "Trying to connect to mariadb at $mariadb_address. Attempt $counter."
    sleep 5
  done
}

setup_db() {
  wait_for_db
  # log "Configuring the database"
  # TODO
  # bundle exec rake db:create
  # bundle exec rake db:migrate
}

log () {
  echo -e "\033[0;33m$(date "+%H:%M:%S")\033[0;37m ==> $1."
}

if ! app_present; then
  log "Creating express application"
  express . -f
fi

if ! dependencies_up_to_date; then
  log "Installing/Updating Express dependencies (npm)"
  npm install
  log "Dependencies updated"
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
  setup_db
  log "Initialization finished"
fi

touch $INIT_SEM
exec /entrypoint.sh "$@"
