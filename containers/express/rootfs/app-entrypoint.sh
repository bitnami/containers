#!/bin/bash
set -e

INIT_SEM=/tmp/initialized.sem
PACKAGE_FILE=/app/package.json

fresh_container() {
  [ ! -f $INIT_SEM ]
}

app_present() {
  [ -f package.json ]
}

dependencies_up_to_date() {
  # It it up to date if the package file is older than
  # the last time the container was initialized
  [ ! $PACKAGE_FILE -nt $INIT_SEM ]
}

database_tier_exists() {
  [ -n "$(getent hosts mongodb mariadb)" ]
}

__wait_for_db() {
  local host=$1
  local port=$2
  local ip_address=$(getent hosts $1 | awk '{ print $1 }')

  log "Connecting to at $host server at $ip_address"

  counter=0
  until nc -z $ip_address $port; do
    counter=$((counter+1))
    if [ $counter == 10 ]; then
      log "Error: Couldn't connect to $host server."
      return 1
    fi
    log "Trying to connect to $host server at $ip_address. Attempt $counter."
    sleep 5
  done
  log "Connected to $host server"
}

wait_for_db() {
  if getent hosts mongodb >/dev/null; then
    __wait_for_db mongodb 27017
  fi

  if getent hosts mariadb >/dev/null; then
    __wait_for_db mariadb 3306
  fi
}

add_database_support() {
  if getent hosts mongodb >/dev/null && ! npm ls mongodb >/dev/null; then
    npm install --save mongodb
  fi

  if getent hosts mariadb >/dev/null && ! npm ls mysql >/dev/null; then
    npm install --save mysql
  fi
}

log () {
  echo -e "\033[0;33m$(date "+%H:%M:%S")\033[0;37m ==> $1."
}

if [ "$1" == npm -a "$2" == "start" ]; then
  if database_tier_exists; then
    wait_for_db
  fi

  if ! app_present; then
    log "Creating express application"
    express . -f

    if database_tier_exists; then
      add_database_support
    fi

    log "Adding dist samples"
    cp -r /dist/samples .
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
    # Perform any app initialization tasks here.
    log "Initialization finished"
  fi

  touch $INIT_SEM
fi

exec /entrypoint.sh "$@"
