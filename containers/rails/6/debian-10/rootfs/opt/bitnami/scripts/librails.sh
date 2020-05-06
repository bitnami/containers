#!/bin/bash
#
# Bitnami Rails library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libservice.sh

########################
# Load global variables used on Rails configuration.
# Globals:
#   RAILS_ENV
#   SKIP_DB_SETUP
#   SKIP_DB_WAIT
#   RETRY_ATTEMPTS
#   PATH
#   DATABASE_HOST
#   DATABASE_NAME
#   DATABASE_TYPE
#   DATABASE_PORT_NUMBER
# Arguments:
#   None
# Returns:
#   Series of exports to be used as 'eval' arguments
#########################
rails_env() {
    cat <<"EOF"
RAILS_ENV="${RAILS_ENV:-development}"
SKIP_DB_SETUP="${SKIP_DB_SETUP:-no}"
SKIP_DB_WAIT="${SKIP_DB_WAIT:-no}"
RETRY_ATTEMPTS="${RETRY_ATTEMPTS:-30}"
PATH="/opt/bitnami/ruby/bin:/opt/bitnami/mysql/bin:/opt/bitnami/node/bin:/opt/bitnami/git/bin:${PATH}"

# Database configuration
DATABASE_HOST="${DATABASE_HOST:-mariadb}"
DATABASE_TYPE="${DATABASE_TYPE:-mysql}"
DATABASE_NAME="${DATABASE_NAME:-my_app_development}"
DATABASE_PORT_NUMBER="${DATABASE_PORT_NUMBER:-3306}"
EOF
}

########################
# Validate settings in DATABASE_* env vars
# Globals:
#   SKIP_DB_SETUP
#   SKIP_DB_WAIT
#   RETRY_ATTEMPTS
# Arguments:
#   None
# Returns:
#   None
#########################
rails_validate() {
    debug "Validating settings in DATABASE_* environment variables..."
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }

    check_yes_no_value() {
        if ! is_yes_no_value "${!1}" && ! is_true_false_value "${!1}"; then
            print_validation_error "The allowed values for $1 are [yes, no]"
        fi
    }

    check_positive_value() {
        if ! is_positive_int "${!1}"; then
            print_validation_error "The variable $1 must be positive integer"
        fi
    }

    check_yes_no_value SKIP_DB_SETUP
    check_yes_no_value SKIP_DB_WAIT
    check_positive_value RETRY_ATTEMPTS

    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}

########################
# Ensure the Rails app is initialized
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#########################
rails_initialize() {
    # Initialize Rails project
    if [[ -f "config.ru" ]]; then
        info "Rails project found, skipping creation"
        info "Installing dependencies"
        bundle install
    else
        info "Creating new Rails project"
        rails new "." --database "$DATABASE_TYPE"
        # Set up database configuration
        local database_path="$DATABASE_NAME"
        [[ "$DATABASE_TYPE" = "sqlite3" ]] && database_path="db/${DATABASE_NAME}.sqlite3"
        info "Configuring database host to ${DATABASE_HOST}"
        replace_in_file "config/database.yml" "host:.*$" "host: ${DATABASE_HOST}"
        info "Configuring database name to ${DATABASE_NAME}"
        replace_in_file "config/database.yml" "database:.*$" "database: ${database_path}" "1,/test:/ "
    fi

    # Wait for database and initialize
    is_boolean_yes "$SKIP_DB_WAIT" || wait_for_db
    is_boolean_yes "$SKIP_DB_SETUP" || initialize_db
}

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
#   RETRY_ATTEMPTS
#   DATABASE_HOST
#   DATABASE_TYPE
#   DATABASE_PORT_NUMBER
# Arguments:
#   None
# Returns:
#   None
#########################
wait_for_db() {
    [[ "$DATABASE_TYPE" = "sqlite3" ]] && return
    info "Connecting to the database at ${DATABASE_HOST} (type: ${DATABASE_TYPE})"
    if ! retry_while "nc -z ${DATABASE_HOST} ${DATABASE_PORT_NUMBER}" "$RETRY_ATTEMPTS"; then
        error "Failed to connect to the database at ${DATABASE_HOST}"
        return 1
    fi
}

########################
# Initialize database
# Globals:
#   RETRY_ATTEMPTS
# Arguments:
#   None
# Returns:
#   None
#########################
initialize_db() {
    # The db:prepare command performs db:create, db:migrate and db:seed only when needed
    # If the database already exists, only db:migrate is run
    info "Initializing database (db:prepare)"
    if ! retry_while "bundle exec rails db:prepare" "$RETRY_ATTEMPTS"; then
        error "Failed to create database"
        return 1
    fi
    info "Database was successfully initialized"
}
