#!/bin/bash
set -e

INIT_SEM=/tmp/initialized.sem

fresh_container() {
  [ ! -f $INIT_SEM ]
}

app_present() {
  [ -f /app/config/database.php ]
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

if ! app_present; then
  log "Creating laravel application"
  \cp -r /tmp/app/ /
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

exec /entrypoint.sh "$@"
