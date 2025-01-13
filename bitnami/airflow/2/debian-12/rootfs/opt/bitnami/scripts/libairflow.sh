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

    check_allowed_port() {
        local validate_port_args=()
        ! am_i_root && validate_port_args+=("-unprivileged")
        validate_port_args+=("${!1}")
        if ! err=$(validate_port "${validate_port_args[@]}"); then
            print_validation_error "An invalid port was specified in the environment variable $1: $err"
        fi
    }

    check_resolved_hostname() {
        if ! is_hostname_resolved "$1"; then
            warn "Hostname $1 could not be resolved. This could lead to connection issues"
        fi
    }

    check_multi_value() {
        if [[ " ${2} " != *" ${!1} "* ]]; then
            print_validation_error "The allowed values for ${1} are: ${2}"
        fi
    }

    check_positive_value() {
        if ! is_positive_int "${!1}"; then
            print_validation_error "The variable $1 must be positive integer"
        fi
    }

    check_yes_no_value() {
        if ! is_yes_no_value "${!1}"; then
            print_validation_error "The allowed values for $1 are [yes, no]"
        fi
    }

    check_empty_value() {
        if is_empty_value "${!1}"; then
            print_validation_error "The $1 environment variable is empty or not set."
        fi
    }

    # Check component type & executor
    check_empty_value "AIRFLOW_COMPONENT_TYPE"
    check_multi_value "AIRFLOW_COMPONENT_TYPE" "webserver scheduler worker triggerer dag-processor"
    check_empty_value "AIRFLOW_EXECUTOR"
    check_yes_no_value "AIRFLOW_STANDALONE_DAG_PROCESSOR"
    check_yes_no_value "AIRFLOW_SKIP_DB_SETUP"

    # Check cryptography parameters
    if [[ -n "$AIRFLOW_RAW_FERNET_KEY" && -z "$AIRFLOW_FERNET_KEY" ]]; then
        if validate_string "$AIRFLOW_RAW_FERNET_KEY" -min-length 32; then
            print_validation_error "AIRFLOW_RAW_FERNET_KEY must have at least 32 characters"
        elif validate_string "$AIRFLOW_RAW_FERNET_KEY" -max-length 32; then
            warn "AIRFLOW_RAW_FERNET_KEY has more than 32 characters, the rest will be ignored"
        fi
        AIRFLOW_FERNET_KEY="$(echo -n "${AIRFLOW_RAW_FERNET_KEY:0:32}" | base64)"
    fi

    # Check database host and port number
    check_empty_value "AIRFLOW_DATABASE_HOST"
    check_resolved_hostname "$AIRFLOW_DATABASE_HOST"
    check_positive_value AIRFLOW_DATABASE_PORT_NUMBER
    check_positive_value REDIS_PORT_NUMBER
    if [[ "$AIRFLOW_EXECUTOR" == "CeleryExecutor" || "$AIRFLOW_EXECUTOR" == "CeleryKubernetesExecutor"  ]]; then
        check_empty_value "REDIS_HOST"
        check_resolved_hostname "$REDIS_HOST"
    fi

    case "$AIRFLOW_COMPONENT_TYPE" in
    webserver)
        # Check webserver port number
        check_allowed_port AIRFLOW_WEBSERVER_PORT_NUMBER

        # Check LDAP parameters
        check_yes_no_value "AIRFLOW_LDAP_ENABLE"
        if is_boolean_yes "$AIRFLOW_LDAP_ENABLE"; then
            for var in "AIRFLOW_LDAP_URI" "AIRFLOW_LDAP_SEARCH" "AIRFLOW_LDAP_UID_FIELD" "AIRFLOW_LDAP_BIND_USER" "AIRFLOW_LDAP_BIND_PASSWORD" "AIRFLOW_LDAP_ROLES_MAPPING" "AIRFLOW_LDAP_ROLES_SYNC_AT_LOGIN" "AIRFLOW_LDAP_USER_REGISTRATION" "AIRFLOW_LDAP_USER_REGISTRATION_ROLE"; do
                check_empty_value "$var"
            done
            for var in "AIRFLOW_LDAP_USER_REGISTRATION" "AIRFLOW_LDAP_ROLES_SYNC_AT_LOGIN" "AIRFLOW_LDAP_USE_TLS"; do
                check_yes_no_value "$var"
            done
            if is_boolean_yes "$AIRFLOW_LDAP_USE_TLS"; then
                for var in "AIRFLOW_LDAP_ALLOW_SELF_SIGNED" "AIRFLOW_LDAP_TLS_CA_CERTIFICATE"; do
                    check_empty_value "$var"
                done
            fi
        fi

        # Check pool parameters
        if [[ -n "$AIRFLOW_POOL_NAME" ]]; then
            for var in "AIRFLOW_POOL_DESC" "AIRFLOW_POOL_SIZE"; do
                check_empty_value "$var"
            done
        fi
        ;;
    *)
        # Check webserver host and port number
        check_empty_value "AIRFLOW_WEBSERVER_HOST"
        check_resolved_hostname "$AIRFLOW_WEBSERVER_HOST"
        check_positive_value AIRFLOW_WEBSERVER_PORT_NUMBER
        ;;
    esac

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
    for dir in "$AIRFLOW_TMP_DIR" "$AIRFLOW_LOGS_DIR" "$AIRFLOW_SCHEDULER_LOGS_DIR" "$AIRFLOW_DAGS_DIR"; do
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
    airflow_wait_for_db_connection

    case "$AIRFLOW_COMPONENT_TYPE" in
    webserver)
        # Remove pid file if exists to prevent error after WSL restarts
        if [[ -f "${AIRFLOW_TMP_DIR}/airflow-webserver.pid" ]]; then
            rm "${AIRFLOW_TMP_DIR}/airflow-webserver.pid"
        fi
        if is_boolean_yes "$AIRFLOW_SKIP_DB_SETUP"; then
            info "Skipping database setup, waiting for db migrations to be completed"
            airflow_wait_for_db_migrations
        # Check if the Airflow database has been already initialized
        elif ! airflow_execute db check-migrations; then
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
        ;;
    *)
        info "Waiting for db migrations to be completed"
        airflow_wait_for_db_migrations
        if [[ "$AIRFLOW_EXECUTOR" == "CeleryExecutor" || "$AIRFLOW_EXECUTOR" == "CeleryKubernetesExecutor"  ]]; then
            wait-for-port --host "$REDIS_HOST" "$REDIS_PORT_NUMBER"
        fi
        ;;
    esac
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
    case "$AIRFLOW_COMPONENT_TYPE" in
    webserver)
        # Create Airflow configuration from default files
        [[ ! -f "$AIRFLOW_CONF_FILE" ]] && cp "$(find "$AIRFLOW_BASE_DIR" -name default_airflow.cfg)" "$AIRFLOW_CONF_FILE"
        [[ ! -f "$AIRFLOW_WEBSERVER_CONF_FILE" ]] && cp "$(find "$AIRFLOW_BASE_DIR" -name default_webserver_config.py)" "$AIRFLOW_WEBSERVER_CONF_FILE"
        # Setup Airflow webserver base URL
        airflow_configure_webserver_base_url
        # Configure Airflow webserver authentication
        airflow_configure_webserver_authentication
        ;;
    *)
        # Generate Airflow default files
        debug_execute airflow version
        ;;
    esac

    # Configure the Webserver port
    airflow_conf_set "webserver" "web_server_port" "$AIRFLOW_WEBSERVER_PORT_NUMBER"
    # Configure Airflow Hostname
    [[ -n "$AIRFLOW_HOSTNAME_CALLABLE" ]] && airflow_conf_set "core" "hostname_callable" "$AIRFLOW_HOSTNAME_CALLABLE"
    # Configure Airflow database
    airflow_configure_database

    # Setup the secret keys for database connection and flask application (fernet key and secret key)
    # ref: https://airflow.apache.org/docs/apache-airflow/stable/configurations-ref.html#fernet-key
    # ref: https://airflow.apache.org/docs/apache-airflow/stable/configurations-ref.html#secret-key
    [[ -n "$AIRFLOW_FERNET_KEY" ]] && airflow_conf_set "core" "fernet_key" "$AIRFLOW_FERNET_KEY"
    [[ -n "$AIRFLOW_SECRET_KEY" ]] && airflow_conf_set "webserver" "secret_key" "$AIRFLOW_SECRET_KEY"

    [[ "$AIRFLOW_COMPONENT_TYPE" = "triggerer" && -n "$AIRFLOW_TRIGGERER_DEFAULT_CAPACITY" ]] && airflow_conf_set "triggerer" "default_capacity" "$AIRFLOW_TRIGGERER_DEFAULT_CAPACITY"
    if [[ "$AIRFLOW_COMPONENT_TYPE" != "worker" ]]; then
        # Configure Airflow to load examples
        if is_boolean_yes "$AIRFLOW_LOAD_EXAMPLES"; then
            airflow_conf_set "core" "load_examples" "True"
        else
            airflow_conf_set "core" "load_examples" "False"
        fi
        # Configure Dag Processor mode
        if is_boolean_yes "$AIRFLOW_STANDALONE_DAG_PROCESSOR"; then
            airflow_conf_set "scheduler" "standalone_dag_processor" "True"
        else
            airflow_conf_set "scheduler" "standalone_dag_processor" "False"
        fi
    fi

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
# Configure Airflow webserver base url
# Globals:
#   AIRFLOW_*
# Arguments:
#   None
# Returns:
#   None
#########################
airflow_configure_webserver_base_url() {
    if [[ -z "$AIRFLOW_WEBSERVER_BASE_URL" ]]; then
        airflow_conf_set "webserver" "base_url" "http://${AIRFLOW_WEBSERVER_HOST}:${AIRFLOW_WEBSERVER_PORT_NUMBER}"
    else
        airflow_conf_set "webserver" "base_url" "$AIRFLOW_WEBSERVER_BASE_URL"
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
# Return URL encoded string in the airflow conf format.
# This function is used to encode users and passwords following airflow format. Please note that Redis user and password can be empty.
# Globals:
#   AIRFLOW_*
# Arguments:
#   None
# Returns:
#   None
#########################
airflow_encode_url() {
    local -r url="${1}"

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
airflow_wait_for_db_connection() {
    if ! retry_while "airflow_execute db check"; then
        error "Could not connect to the database"
        return 1
    fi
}

########################
# Wait until db migrations are done
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   true if the db migrations are ready, false otherwise
#########################
airflow_wait_for_db_migrations() {
    if ! retry_while "airflow_execute db check-migrations"; then
        error "DB migrations are not ready yet"
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
#   AIRFLOW_TMP_DIR
# Arguments:
#   1 - PID file
# Returns:
#   Whether Airflow is running
########################
is_airflow_running() {
    local -r pid_file="${1:?Missing pid file}"

    local pid
    pid="$(get_pid_from_file "${AIRFLOW_TMP_DIR}/${pid_file}")"
    if [[ -n "$pid" ]]; then
        is_service_running "$pid"
    else
        false
    fi
}

########################
# Check if Airflow is not running
# Globals:
#   AIRFLOW_TMP_DIR
# Arguments:
#   1 - PID file
# Returns:
#   Whether Airflow is not running
########################
is_airflow_not_running() {
    ! is_airflow_running "$@"
}

########################
# Stop Airflow
# Globals:
#   AIRFLOW_TMP_DIR
# Arguments:
#   1 - PID file
# Returns:
#   None
#########################
airflow_stop() {
    local -r pid_file="${1:?Missing pid file}"

    info "Stopping Airflow..."
    stop_service_using_pid "${AIRFLOW_TMP_DIR}/${pid_file}"
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
