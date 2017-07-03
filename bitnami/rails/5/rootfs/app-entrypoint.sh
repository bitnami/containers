#!/bin/bash -e
. /opt/bitnami/base/functions

print_welcome_page
check_for_updates &

INIT_SEM=/tmp/initialized.sem

fresh_container() {
  [ ! -f $INIT_SEM ]
}

app_present() {
  [ -f /app/config.ru ]
}

gems_up_to_date() {
  bundle check 1> /dev/null
}

wait_for_db() {
  mariadb_address=$(getent hosts mariadb | awk '{ print $1 }')
  counter=0
  log "Connecting to mariadb at $mariadb_address"
  while ! nc -z mariadb 3306; do
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
  bundle exec rails db:create
}

migrate_db() {
  log "Applying database migrations (db:migrate)"
  bundle exec rails db:migrate
}

if [ "$1" == "bundle" -a "$2" == "exec" ]; then
  if ! app_present; then
    log "Creating rails application"
    rails new . --skip-bundle --database mysql
    # Add rubyracer
    sed -i "s/# gem 'therubyracer'/gem 'therubyracer'/" Gemfile
    log "Setting default host to \`mariadb\`"
    sed -i 's/host:.*$/host: mariadb/g' /app/config/database.yml
  fi

  if ! gems_up_to_date; then
    log "Installing/Updating Rails dependencies (gems)"
    bundle install
    log "Gems updated"
  fi

  [[ -z $SKIP_DB_WAIT ]] && wait_for_db

  if ! fresh_container; then
    echo "#########################################################################"
    echo "                                                                       "
    echo " App initialization skipped:"
    echo " Delete the file $INIT_SEM and restart the container to reinitialize"
    echo " You can alternatively run specific commands using docker-compose exec"
    echo " e.g docker-compose exec rails bundle exec rails db:migrate"
    echo "                                                                       "
    echo "#########################################################################"
  else

    [[ -z $SKIP_DB_SETUP ]] && setup_db

    log "Initialization finished"
    touch $INIT_SEM
  fi

  [[ -z $SKIP_DB_SETUP ]] && migrate_db
fi

exec tini -- "$@"
