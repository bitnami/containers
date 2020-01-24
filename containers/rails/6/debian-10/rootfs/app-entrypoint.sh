#!/bin/bash

set -o errexit
set -o pipefail
# set -o xtrace
# shellcheck disable=SC1091

# Load libraries
. /opt/bitnami/base/functions

# Constants
INIT_SEM=/tmp/initialized.sem

# Functions

########################
# Ensure gems are up to date
# Arguments:
#   None
# Returns:
#   Boolean
#########################
gems_up_to_date() {
  bundle check 1> /dev/null
}

########################
# Wait for database to be ready
# Globals:
#   DATABASE_HOST
# Arguments:
#   None
# Returns:
#   None
#########################
wait_for_db() {
  local db_host="${DATABASE_HOST:-mariadb}"
  local db_address
  db_address="$(getent hosts "$db_host" | awk '{ print $1 }')"
  counter=0
  log "Connecting to MariaDB at $db_address"
  while ! nc -z "$db_host" 3306; do
    counter=$((counter+1))
    if [ $counter == 30 ]; then
      log "Error: Couldn't connect to MariaDB."
      exit 1
    fi
    log "Trying to connect to mariadb at $db_address. Attempt $counter."
    sleep 5
  done
}

print_welcome_page

if [[ "$1" = "bundle" ]] && [[ "$2" = "exec" ]]; then
  if [[ -f /app/config.ru ]]; then
    log "Rails project found. Skipping creation..."
  else
    log "Creating new Rails project..."
    rails new . --skip-bundle --database mysql
    # Add mini_racer
    sed -i -e "s/# gem 'mini_racer'/gem 'mini_racer'/" Gemfile
    # TODO: substitution using 'yq' once they support anchors
    # Related issue: https://github.com/mikefarah/yq/issues/178
    # E.g: yq w -i /app/config/database.yml default.host '<%= ENV.fetch("DATABASE_HOST") { mariadb } %>'
    # E.g: yq w -i /app/config/database.yml development.database '<%= ENV.fetch("DATABASE_NAME") { mariadb } %>'
    log "Setting default host to \`${DATABASE_HOST:-mariadb}\`..."
    sed -i -e 's/host:.*$/host: <%= ENV.fetch("DATABASE_HOST", "mariadb") %>/g' /app/config/database.yml
    log "Setting development database to \`${DATABASE_NAME:-my_app_development}\`..."
    sed -i -e '1,/test:/ s/database:.*$/database: <%= ENV.fetch("DATABASE_NAME", "my_app_development") %>/g' /app/config/database.yml
  fi

  if ! gems_up_to_date; then
    log "Installing/Updating Rails dependencies (gems)..."
    bundle install
    log "Gems updated!!"
  fi

  if [[ -z $SKIP_DB_WAIT ]]; then
    wait_for_db
  fi

  if [[ -f $INIT_SEM ]]; then
    echo "#########################################################################"
    echo "                                                                       "
    echo " App initialization skipped:"
    echo " Delete the file $INIT_SEM and restart the container to reinitialize"
    echo " You can alternatively run specific commands using docker-compose exec"
    echo " e.g docker-compose exec rails bundle exec rails db:migrate"
    echo "                                                                       "
    echo "#########################################################################"
  else
    if [[ -z $SKIP_DB_SETUP ]]; then
      log "Configuring the database..."
      while ! bundle exec rails db:create; do
        counter=$((counter+1))
        if [ $counter == 30 ]; then
          log "Error: db:create failed"
          exit 1
        fi
        log "Trying to execute db:create. Attempt $counter."
        sleep 5
      done
    fi
    log "Initialization finished!!!"
    touch $INIT_SEM
  fi

  if [[ -z $SKIP_DB_SETUP ]]; then
    log "Applying database migrations (db:migrate)..."
    while ! bundle exec rails db:migrate; do
      counter=$((counter+1))
      if [ $counter == 30 ]; then
        log "Error: db:migrate failed"
        exit 1
      fi
      log "Trying to execute db:migrate. Attempt $counter."
      sleep 5
    done
  fi
fi

exec tini -- "$@"
