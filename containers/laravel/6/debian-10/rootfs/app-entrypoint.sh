#!/bin/bash

set -o errexit
set -o pipefail
# set -o xtrace

# Load libraries
# shellcheck disable=SC1091
. /opt/bitnami/base/functions

# Constants
INIT_SEM=/tmp/initialized.sem

# Functions

########################
# Replace a regex in a file
# Arguments:
#   $1 - filename
#   $2 - match regex
#   $3 - substitute regex
#   $4 - regex modifier
# Returns: none
#########################
replace_in_file() {
    local filename="${1:?filename is required}"
    local match_regex="${2:?match regex is required}"
    local substitute_regex="${3:?substitute regex is required}"
    local regex_modifier="${4:-}"
    local result

    # We should avoid using 'sed in-place' substitutions
    # 1) They are not compatible with files mounted from ConfigMap(s)
    # 2) We found incompatibility issues with Debian10 and "in-place" substitutions
    result="$(sed "${regex_modifier}s@${match_regex}@${substitute_regex}@g" "$filename")"
    echo "$result" > "$filename"
}

########################
# Wait for database to be ready
# Globals:
#   DATABASE_HOST
#   DB_PORT
# Arguments: none
# Returns: none
#########################
wait_for_db() {
  local db_host="${DB_HOST:-mariadb}"
  local db_port="${DB_PORT:-3306}"
  local db_address=$(getent hosts "$db_host" | awk '{ print $1 }')
  counter=0
  log "Connecting to mariadb at $db_address"
  while ! curl --silent "$db_address:$db_port" >/dev/null; do
    counter=$((counter+1))
    if [ $counter == 30 ]; then
      log "Error: Couldn't connect to mariadb."
      exit 1
    fi
    log "Trying to connect to mariadb at $db_address. Attempt $counter."
    sleep 5
  done
}

########################
# Setup the database configuration
# Arguments: none
# Returns: none
#########################
setup_db() {
  log "Configuring the database"
  replace_in_file "/app/config/database.php" "utf8mb4" "utf8"
  php artisan migrate --force
}

print_welcome_page

if [ "${1}" == "php" -a "$2" == "artisan" -a "$3" == "serve" ]; then
  if [[ ! -f /app/config/database.php ]]; then
    log "Creating laravel application"
    cp -a /tmp/app/. /app/
  fi

  log "Installing/Updating Laravel dependencies (composer)"
  if [[ ! -f /app/vendor ]]; then
    composer install
    log "Dependencies installed"
  else
    composer update
    log "Dependencies updated"
  fi

  wait_for_db

  if [[ -f $INIT_SEM ]]; then
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

exec tini -- "$@"
