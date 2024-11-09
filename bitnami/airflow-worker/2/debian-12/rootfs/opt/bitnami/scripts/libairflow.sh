#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# Bitnami Airflow library

# shellcheck disable=SC1091,SC2153

# Load Generic Libraries
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libpersistence.sh

# Load database library
if [[ -f /opt/bitnami/scripts/libpostgresqlclient.sh ]]; then
    . /opt/bitnami/scripts/libpostgresqlclient.sh
elif [[ -f /opt/bitnami/scripts/libpostgresql.sh ]]; then
    . /opt/bitnami/scripts/libpostgresql.sh
fi

# Functions

########################
# Validate Airflow inputs
# Globals:
#   AIRFLOW_*
# Arguments:
#   None
# Returns:
#   0 if the validation succeeded, 1 otherwise
#########################
airflow_validate() {
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }

    check_multi_value() {
        if [[ " ${2} " != *" ${!1} "* ]]; then
            print_validation_error "The allowed values for ${1} are: ${2}"
        fi
    }

    # Check postgresql host
    [[ -z "$AIRFLOW_DATABASE_HOST" ]] && print_validation_error "Missing AIRFLOW_DATABASE_HOST"

    # Check LDAP parameters
    if is_boolean_yes "$AIRFLOW_LDAP_ENABLE"; then
        [[ -z "$AIRFLOW_LDAP_URI" ]] && print_validation_error "Missing AIRFLOW_LDAP_URI"
        [[ -z "$AIRFLOW_LDAP_SEARCH" ]] && print_validation_error "Missing AIRFLOW_LDAP_SEARCH"
        [[ -z "$AIRFLOW_LDAP_UID_FIELD" ]] && print_validation_error "Missing AIRFLOW_LDAP_UID_FIELD"
        [[ -z "$AIRFLOW_LDAP_BIND_USER" ]] && print_validation_error "Missing AIRFLOW_LDAP_BIND_USER"
        [[ -z "$AIRFLOW_LDAP_BIND_PASSWORD" ]] && print_validation_error "Missing AIRFLOW_LDAP_BIND_PASSWORD"
        [[ -z "$AIRFLOW_LDAP_ROLES_MAPPING" ]] && print_validation_error "Missing AIRFLOW_LDAP_ROLES_MAPPING"
        [[ -z "$AIRFLOW_LDAP_ROLES_SYNC_AT_LOGIN" ]] && print_validation_error "Missing AIRFLOW_LDAP_ROLES_SYNC_AT_LOGIN"
        [[ -z "$AIRFLOW_LDAP_USER_REGISTRATION" ]] && print_validation_error "Missing AIRFLOW_LDAP_USER_REGISTRATION"
        [[ -z "$AIRFLOW_LDAP_USER_REGISTRATION_ROLE" ]] && print_validation_error "Missing AIRFLOW_LDAP_USER_REGISTRATION_ROLE"

        # Chack boolean env vars contain valid values
        for var in "AIRFLOW_LDAP_USER_REGISTRATION" "AIRFLOW_LDAP_ROLES_SYNC_AT_LOGIN" "AIRFLOW_LDAP_USE_TLS"; do
            check_multi_value "$var" "True False"
        done

        if [[ "$AIRFLOW_LDAP_USE_TLS" == "True" ]]; then
            [[ -z "$AIRFLOW_LDAP_ALLOW_SELF_SIGNED" ]] && print_validation_error "Missing AIRFLOW_LDAP_ALLOW_SELF_SIGNED"
            [[ -z "$AIRFLOW_LDAP_TLS_CA_CERTIFICATE" ]] && print_validation_error "Missing AIRFLOW_LDAP_TLS_CA_CERTIFICATE"
        fi

    fi

    # Check pool parameters
    if [[ -n "$AIRFLOW_POOL_NAME" ]]; then
        [[ -z "$AIRFLOW_POOL_DESC" ]] && print_validation_error "Provided AIRFLOW_POOL_NAME but missing AIRFLOW_POOL_DESC"
        [[ -z "$AIRFLOW_POOL_SIZE" ]] && print_validation_error "Provided AIRFLOW_POOL_NAME but missing AIRFLOW_POOL_SIZE"
    fi

    # Check cryptography parameters
    if [[ -n "$AIRFLOW_RAW_FERNET_KEY" && -z "$AIRFLOW_FERNET_KEY" ]]; then
        local fernet_char_count
        fernet_char_count="$(echo -n "$AIRFLOW_RAW_FERNET_KEY")"
        if [[ "$fernet_char_count" -lt 32 ]]; then
            print_validation_error "AIRFLOW_RAW_FERNET_KEY must have at least 32 characters"
        elif [[ "$fernet_char_count" -gt 32 ]]; then
            warn "AIRFLOW_RAW_FERNET_KEY has more than 32 characters, the rest will be ignored"
        fi
        AIRFLOW_FERNET_KEY="$(echo -n "${AIRFLOW_RAW_FERNET_KEY:0:32}" | base64)"
    fi

    return "$error_code"
}

########################
# Ensure Airflow is initialized
# Globals:
#   AIRFLOW_*
# Arguments:
#   None
# Returns:
#   None
#########################
airflow_initialize() {
    info "Initializing Airflow ..."

    # Change permissions if running as root
    for dir in "$AIRFLOW_TMP_DIR" "$AIRFLOW_LOGS_DIR" "$AIRFLOW_DAGS_DIR"; do
        ensure_dir_exists "$dir"
        am_i_root && chown "$AIRFLOW_DAEMON_USER:$AIRFLOW_DAEMON_GROUP" "$dir"
    done

    # The configuration file is not persisted. If it is not provided, generate it based on env vars
    if [[ ! -f "$AIRFLOW_CONF_FILE" ]] || is_boolean_yes "$AIRFLOW_FORCE_OVERWRITE_CONF_FILE"; then
        info "No injected configuration file found. Creating default config file"
        airflow_generate_config
    else
        info "Configuration file found, loading configuration"
    fi

    info "Trying to connect to the database server"
    airflow_wait_for_postgresql_connection
    # Check if the Airflow database has been already initialized
    if ! airflow_execute db check-migrations; then
        # Delete pid file
        rm -f "$AIRFLOW_PID_FILE"

        # Initialize database
        info "Populating database"
        airflow_execute db init

        airflow_create_admin_user
        airflow_create_pool
    else
        # Upgrade database
        info "Upgrading database schema"
        airflow_execute db upgrade
        true # Avoid return false when I am not root
    fi
}

########################
# Executes the 'airflow' CLI with the specified arguments and print result to stdout/stderr
# Globals:
#   AIRFLOW_*
# Arguments:
#   $1..$n - Arguments to pass to the CLI call
# Returns:
#   None
#########################
airflow_execute_print_output() {
    # Run as web server user to avoid having to change permissions/ownership afterwards
    if am_i_root; then
        run_as_user "$AIRFLOW_DAEMON_USER" airflow "$@"
    else
        airflow "$@"
    fi
}

########################
# Executes the 'airflow' CLI with the specified arguments
# Globals:
#   AIRFLOW_*
# Arguments:
#   $1..$n - Arguments to pass to the CLI call
# Returns:
#   None
#########################
airflow_execute() {
    debug_execute airflow_execute_print_output "$@"
}

########################
# Generate Airflow conf file
# Globals:
#   AIRFLOW_*
# Arguments:
#   None
# Returns:
#   None
#########################
airflow_generate_config() {
    # Create Airflow confirguration from default files
    [[ ! -f "$AIRFLOW_CONF_FILE" ]] && cp "$(find "$AIRFLOW_BASE_DIR" -name default_airflow.cfg)" "$AIRFLOW_CONF_FILE"
    [[ -n "$AIRFLOW_WEBSERVER_CONF_FILE" ]] && [[ ! -f "$AIRFLOW_WEBSERVER_CONF_FILE" ]] && cp "$(find "$AIRFLOW_BASE_DIR" -name default_webserver_config.py)" "$AIRFLOW_WEBSERVER_CONF_FILE"

    # Setup Airflow base URL
    airflow_configure_base_url
    # Configure Airflow Hostname
    [[ -n "$AIRFLOW_HOSTNAME_CALLABLE" ]] && airflow_conf_set "core" "hostname_callable" "$AIRFLOW_HOSTNAME_CALLABLE"
    # Configure Airflow webserver authentication
    airflow_configure_webserver_authentication
    # Configure Airflow to load examples
    if is_boolean_yes "$AIRFLOW_LOAD_EXAMPLES"; then
        airflow_conf_set "core" "load_examples" "True"
    else
        airflow_conf_set "core" "load_examples" "False"
    fi
    # Configure Airflow database
    airflow_configure_database

    # Configure the Webserver port
    airflow_conf_set "webserver" "web_server_port" "$AIRFLOW_WEBSERVER_PORT_NUMBER"

    # Setup the secret keys for database connection and flask application (fernet key and secret key)
    # ref: https://airflow.apache.org/docs/apache-airflow/stable/configurations-ref.html#fernet-key
    # ref: https://airflow.apache.org/docs/apache-airflow/stable/configurations-ref.html#secret-key
    [[ -n "$AIRFLOW_FERNET_KEY" ]] && airflow_conf_set "core" "fernet_key" "$AIRFLOW_FERNET_KEY"
    [[ -n "$AIRFLOW_SECRET_KEY" ]] && airflow_conf_set "webserver" "secret_key" "$AIRFLOW_SECRET_KEY"

    # Configure Airflow executor
    airflow_conf_set "core" "executor" "$AIRFLOW_EXECUTOR"
    [[ "$AIRFLOW_EXECUTOR" == "CeleryExecutor" || "$AIRFLOW_EXECUTOR" == "CeleryKubernetesExecutor" ]] && airflow_configure_celery_executor
    true # Avoid the function to fail due to the check above
}

########################
# Set property on the Airflow configuration file
# Globals:
#   AIRFLOW_*
# Arguments:
#   None
# Returns:
#   None
#########################
airflow_conf_set() {
    local -r section="${1:?section is required}"
    local -r key="${2:?key is required}"
    local -r value="${3:?value is required}"
    local -r file="${4:-${AIRFLOW_CONF_FILE}}"

    ini-file set "--section=$section" "--key=$key" "--value=$value" -- "$file"
}

########################
# Configure Airflow base url
# Globals:
#   AIRFLOW_*
# Arguments:
#   None
# Returns:
#   None
#########################
airflow_configure_base_url() {
    if [[ -z "$AIRFLOW_BASE_URL" ]]; then
        airflow_conf_set "webserver" "base_url" "http://${AIRFLOW_WEBSERVER_HOST}:${AIRFLOW_WEBSERVER_PORT_NUMBER}"
    else
        airflow_conf_set "webserver" "base_url" "$AIRFLOW_BASE_URL"
    fi
}

########################
# Configure Airflow webserver authentication
# Globals:
#   AIRFLOW_*
# Arguments:
#   None
# Returns:
#   None
#########################
airflow_configure_webserver_authentication() {
    info "Configuring Airflow webserver authentication"
    airflow_conf_set "webserver" "rbac" "true"

    if is_boolean_yes "$AIRFLOW_LDAP_ENABLE"; then
        info "Enabling LDAP authentication"
        # Based on PR https://github.com/apache/airflow/pull/16647
        replace_in_file "$AIRFLOW_WEBSERVER_CONF_FILE" "# from airflow.www.fab_security.manager import AUTH_LDAP" "from airflow.www.fab_security.manager import AUTH_LDAP"
        replace_in_file "$AIRFLOW_WEBSERVER_CONF_FILE" "from airflow.www.fab_security.manager import AUTH_DB" "# from airflow.www.fab_security.manager import AUTH_DB"

        # webserver config
        airflow_webserver_conf_set "AUTH_TYPE" "AUTH_LDAP"
        airflow_webserver_conf_set "AUTH_LDAP_SERVER" "$AIRFLOW_LDAP_URI" "yes"

        # searches
        airflow_webserver_conf_set "AUTH_LDAP_SEARCH" "$AIRFLOW_LDAP_SEARCH" "yes"
        airflow_webserver_conf_set "AUTH_LDAP_UID_FIELD" "$AIRFLOW_LDAP_UID_FIELD" "yes"

        # Special account for searches
        airflow_webserver_conf_set "AUTH_LDAP_BIND_USER" "$AIRFLOW_LDAP_BIND_USER" "yes"
        airflow_webserver_conf_set "AUTH_LDAP_BIND_PASSWORD" "$AIRFLOW_LDAP_BIND_PASSWORD" "yes"

        # User self registration
        airflow_webserver_conf_set "AUTH_USER_REGISTRATION" "$AIRFLOW_LDAP_USER_REGISTRATION"
        airflow_webserver_conf_set "AUTH_USER_REGISTRATION_ROLE" "$AIRFLOW_LDAP_USER_REGISTRATION_ROLE" "yes"

        # Mapping from LDAP DN to list of FAB roles
        airflow_webserver_conf_set "AUTH_ROLES_MAPPING" "$AIRFLOW_LDAP_ROLES_MAPPING"

        # Replace user's roles at login
        airflow_webserver_conf_set "AUTH_ROLES_SYNC_AT_LOGIN" "$AIRFLOW_LDAP_ROLES_SYNC_AT_LOGIN"

        # Allowing/Denying of self signed certs for StartTLS OR SSL ldaps:// connections
        airflow_webserver_conf_set "AUTH_LDAP_ALLOW_SELF_SIGNED" "$AIRFLOW_LDAP_ALLOW_SELF_SIGNED"

        # If StartTLS supply cert
        if [[ "$AIRFLOW_LDAP_USE_TLS" == "True" ]]; then
            airflow_webserver_conf_set "AUTH_LDAP_TLS_CACERTFILE" "$AIRFLOW_LDAP_TLS_CA_CERTIFICATE" "yes"
        fi
    fi
}

########################
# Set properties in Airflow's webserver_config.py
# Globals:
#   AIRFLOW_*
# Arguments:
#   None
# Returns:
#   None
#########################
airflow_webserver_conf_set() {
    local -r key="${1:?missing key}"
    local -r value="${2:?missing key}"
    local -r is_literal="${3:-no}"
    shift 2

    local -r file="$AIRFLOW_WEBSERVER_CONF_FILE"
    # Check if the value was set before
    if grep -q "^#*\\s*${key} =.*$" "$file"; then
        local entry
        if is_boolean_yes "$is_literal"; then
            # Replace every single backslash (\) with two backslashes (\\)
            local new_value="${value//\\/\\\\}"
            # Wrap the value in single quotes (') and escape every single quote with a backslash (\)
            entry="${key} = '${new_value//"'"/\\\'}'"
        else
            entry="${key} = ${value}"
        fi
        # Update the existing key
        replace_in_file "$file" "^#*\\s*${key} =.*$" "$entry" false
    else
        # Add a new key
        local new_value="$value"
        if is_boolean_yes "$is_literal"; then
            # Replace every single backslash (\) with two backslashes (\\)
            new_value="${new_value//\\/\\\\}"
            # Wrap the value in single quotes (') and escape every single quote with a backslash (\)
            new_value="'${new_value//"'"/\\\'}'"
        fi
        printf '\n%s = %s' "$key" "$new_value" >>"$file"
    fi
}

########################
# Configure Airflow database
# Globals:
#   AIRFLOW_*
# Arguments:
#   None
# Returns:
#   None
#########################
airflow_configure_database() {
    local -r user=$(airflow_encode_url "$AIRFLOW_DATABASE_USERNAME")
    local -r password=$(airflow_encode_url "$AIRFLOW_DATABASE_PASSWORD")
    local extra_options
    is_boolean_yes "$AIRFLOW_DATABASE_USE_SSL" && extra_options="?sslmode=require"

    info "Configuring Airflow database"
    airflow_conf_set "database" "sql_alchemy_conn" "postgresql+psycopg2://${user}:${password}@${AIRFLOW_DATABASE_HOST}:${AIRFLOW_DATABASE_PORT_NUMBER}/${AIRFLOW_DATABASE_NAME}${extra_options:-}"
}

########################
# Return URL encoded string in the airflow conf format
# Globals:
#   AIRFLOW_*
# Arguments:
#   None
# Returns:
#   None
#########################
airflow_encode_url() {
    local -r url="${1?Missing url}"

    urlencode() {
        old_lc_collate="${LC_COLLATE:-}"
        LC_COLLATE=C

        local length="${#1}"
        for ((i = 0; i < length; i++)); do
            local c="${1:$i:1}"
            case $c in
            [a-zA-Z0-9.~_-]) printf '%s' "$c" ;;
            *) printf '%%%02X' "'$c" ;;
            esac
        done

        LC_COLLATE="$old_lc_collate"
    }

    local -r url_encoded=$(urlencode "$url")
    # Replace % by %%
    echo "${url_encoded//\%/\%\%}"
}

########################
# Configure Airflow celery executor
# Globals:
#   AIRFLOW_*
# Arguments:
#   None
# Returns:
#   None
#########################
airflow_configure_celery_executor() {
    info "Configuring Celery Executor"

    # Configure celery Redis url
    local -r redis_user=$(airflow_encode_url "$REDIS_USER")
    local -r redis_password=$(airflow_encode_url "$REDIS_PASSWORD")
    airflow_conf_set "celery" "broker_url" "redis://${redis_user}:${redis_password}@${REDIS_HOST}:${REDIS_PORT_NUMBER}/${REDIS_DATABASE}"
    is_boolean_yes "$AIRFLOW_REDIS_USE_SSL" && airflow_conf_set "celery" "broker_url" "rediss://${redis_user}:${redis_password}@${REDIS_HOST}:${REDIS_PORT_NUMBER}/${REDIS_DATABASE}"
    is_boolean_yes "$AIRFLOW_REDIS_USE_SSL" && airflow_conf_set "celery" "redis_backend_use_ssl" "true"

    # Configure celery backend
    local -r database_user=$(airflow_encode_url "$AIRFLOW_DATABASE_USERNAME")
    local -r database_password=$(airflow_encode_url "$AIRFLOW_DATABASE_PASSWORD")
    local database_extra_options
    is_boolean_yes "$AIRFLOW_DATABASE_USE_SSL" && database_extra_options="?sslmode=require"
    airflow_conf_set "celery" "result_backend" "db+postgresql://${database_user}:${database_password}@${AIRFLOW_DATABASE_HOST}:${AIRFLOW_DATABASE_PORT_NUMBER}/${AIRFLOW_DATABASE_NAME}${database_extra_options:-}"
}

########################
# Wait until the database is accessible
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   true if the database connection succeeded, false otherwise
#########################
airflow_wait_for_postgresql_connection() {
    if ! retry_while "airflow_execute db check"; then
        error "Could not connect to the database"
        return 1
    fi
}

########################
# Airflow create admin user
# Arguments:
#   None
# Returns:
#   None
#########################
airflow_create_admin_user() {
    info "Creating Airflow admin user"
    airflow_execute users create -r "Admin" -u "$AIRFLOW_USERNAME" -e "$AIRFLOW_EMAIL" -p "$AIRFLOW_PASSWORD" -f "$AIRFLOW_FIRSTNAME" -l "$AIRFLOW_LASTNAME"
}

########################
# Airflow create pool
# Arguments:
#   None
# Returns:
#   None
#########################
airflow_create_pool() {
    if [[ -n "$AIRFLOW_POOL_NAME" ]] && [[ -n "$AIRFLOW_POOL_SIZE" ]] && [[ -n "$AIRFLOW_POOL_DESC" ]]; then
        info "Creating Airflow pool"
        airflow_execute pool -s "$AIRFLOW_POOL_NAME" "$AIRFLOW_POOL_SIZE" "$AIRFLOW_POOL_DESC"
    fi
}

########################
# Check if Airflow is running
# Globals:
#   AIRFLOW_PID_FILE
# Arguments:
#   None
# Returns:
#   Whether Airflow is running
########################
is_airflow_running() {
    local pid
    pid="$(get_pid_from_file "$AIRFLOW_PID_FILE")"
    if [[ -n "$pid" ]]; then
        is_service_running "$pid"
    else
        false
    fi
}

########################
# Check if Airflow is not running
# Globals:
#   AIRFLOW_PID_FILE
# Arguments:
#   None
# Returns:
#   Whether Airflow is not running
########################
is_airflow_not_running() {
    ! is_airflow_running
}

########################
# Stop Airflow
# Globals:
#   AIRFLOW*
# Arguments:
#   None
# Returns:
#   None
#########################
airflow_stop() {
    info "Stopping Airflow..."
    stop_service_using_pid "$AIRFLOW_PID_FILE"
}

########################
# Check if airflow-exporter is running
# Globals:
#   AIRFLOW_EXPORTER_PID_FILE
# Arguments:
#   None
# Returns:
#   Whether airflow-exporter is running
########################
is_airflow_exporter_running() {
    # airflow-exporter does not create any PID file
    # We regenerate the PID file for each time we query it to avoid getting outdated
    pgrep -f "airflow-prometheus-exporter" | head -n 1 > "$AIRFLOW_EXPORTER_PID_FILE"

    local pid
    pid="$(get_pid_from_file "$AIRFLOW_EXPORTER_PID_FILE")"
    if [[ -n "$pid" ]]; then
        is_service_running "$pid"
    else
        false
    fi
}

########################
# Check if airflow-exporter is not running
# Globals:
#   AIRFLOW_EXPORTER_PID_FILE
# Arguments:
#   None
# Returns:
#   Whether airflow-exporter is not running
########################
is_airflow_exporter_not_running() {
    ! is_airflow_exporter_running
}

########################
# Stop airflow-exporter
# Globals:
#   AIRFLOW*
# Arguments:
#   None
# Returns:
#   None
#########################
airflow_exporter_stop() {
    info "Stopping airflow-exporter..."
    stop_service_using_pid "$AIRFLOW_EXPORTER_PID_FILE"
}
