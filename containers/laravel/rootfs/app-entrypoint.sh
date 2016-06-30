#!/bin/bash
set -e

INIT_SEM=/tmp/initialized.sem
PACKAGE_FILE=/app/composer.json

fresh_container() {
  [ ! -f $INIT_SEM ]
}

app_present() {
  [ -f /app/config/database.php ]
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
  log "Configuring the database"
  php artisan migrate
}

log () {
  echo -e "\033[0;33m$(date "+%H:%M:%S")\033[0;37m ==> $1."
}

if [ "${1}" == "php" -a "$2" == "artisan" -a "$3" == "serve" ]; then
  if ! app_present; then
    log "Creating laravel application"
    \cp -r /tmp/app/ /
  fi

  if ! dependencies_up_to_date; then
    log "Installing/Updating Laravel dependencies (composer)"
    composer update
    log "Dependencies updated"
  fi

  wait_for_db

  if ! fresh_container; then
    echo "#########################################################################"
    echo "                                                                         "
    echo " App initialization skipped:                                             "
    echo " Delete the file $INIT_SEM and restart the container to reinitialize     "
    echo " You can alternatively run specific commands using docker-compose exec   "
    echo " e.g docker-compose exec myapp php artisan make:console FooCommand       "
    echo "                                                                         "
    echo "#########################################################################"
  else
    setup_db
    log "Initialization finished"
    touch $INIT_SEM
  fi
fi

exec /entrypoint.sh "$@"
