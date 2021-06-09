#!/bin/bash

# Bitnami Airflow library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libpersistence.sh

# Load airflow library
. /opt/bitnami/scripts/libairflow.sh

########################
# Validate Airflow Scheduler inputs
# Globals:
#   AIRFLOW_*
# Arguments:
#   None
# Returns:
#   None
#########################
airflow_worker_validate() {
    # Check postgresql host
    [[ -z "$AIRFLOW_WEBSERVER_HOST" ]] && print_validation_error "Missing AIRFLOW_WEBSERVER_HOST"
    [[ -z "$AIRFLOW_WEBSERVER_PORT_NUMBER" ]] && print_validation_error "Missing AIRFLOW_WEBSERVER_PORT_NUMBER"
    # Check postgresql host
    [[ -z "$AIRFLOW_DATABASE_HOST" ]] && print_validation_error "Missing AIRFLOW_DATABASE_HOST"

    # Avoid fail because of the above check
    true
}

########################
# Ensure Airflow Scheduler is initialized
# Globals:
#   AIRFLOW_*
# Arguments:
#   None
# Returns:
#   None
#########################
airflow_worker_initialize() {
    # Change permissions if running as root
    for dir in "$AIRFLOW_TMP_DIR" "$AIRFLOW_LOGS_DIR" "$AIRFLOW_DATA_DIR"; do
        ensure_dir_exists "$dir"
        am_i_root && chown "$AIRFLOW_DAEMON_USER:$AIRFLOW_DAEMON_GROUP" "$dir"
    done

    # The configuration file is not persisted. If it is not provided, generate it based on env vars
    if [[ ! -f "$AIRFLOW_CONF_FILE" ]]; then
        info "No injected configuration file found. Creating default config file"
        airflow_worker_generate_config
    else
        info "Configuration file found, loading configuration"
    fi

    # Check if Airflow has already been initialized and persisted in a previous run
    local -r app_name="airflow"
    if ! is_app_initialized "$app_name"; then
        airflow_wait_for_postgresql "$AIRFLOW_DATABASE_HOST" "$AIRFLOW_DATABASE_PORT_NUMBER"

        info "Persisting Airflow installation"
        persist_app "$app_name" "$AIRFLOW_DATA_TO_PERSIST"
    else
        # Check database connection
        airflow_wait_for_postgresql "$AIRFLOW_DATABASE_HOST" "$AIRFLOW_DATABASE_PORT_NUMBER"

        # Restore persisted data
        info "Restoring persisted Airflow installation"
        restore_persisted_app "$app_name" "$AIRFLOW_DATA_TO_PERSIST"

        # Change the permissions after restoring the persisted data in case we are root
        for dir in "$AIRFLOW_DATA_DIR" "$AIRFLOW_TMP_DIR" "$AIRFLOW_LOGS_DIR"; do
            ensure_dir_exists "$dir"
            am_i_root && chown "$AIRFLOW_DAEMON_USER:$AIRFLOW_DAEMON_GROUP" "$dir"
        done
        true # Avoid return false when I am not root
    fi

    # Wait for airflow webserver to be available
    info "Waiting for Airflow Webserser to be up"
    airflow_worker_wait_for_webserver "$AIRFLOW_WEBSERVER_HOST" "$AIRFLOW_WEBSERVER_PORT_NUMBER"
    [[ "$AIRFLOW_EXECUTOR" == "CeleryExecutor" || "$AIRFLOW_EXECUTOR" == "CeleryKubernetesExecutor"  ]] && wait-for-port --host "$REDIS_HOST" "$REDIS_PORT_NUMBER"

    # Avoid to fail when the executor is not celery
    true
}

########################
# Generate Airflow Scheduler conf file
# Globals:
#   AIRFLOW_*
# Arguments:
#   None
# Returns:
#   None
#########################
airflow_worker_generate_config() {
    # Generate Airflow default files
    airflow_execute_command "version" "version"

    # Configure Airflow Hostname
    [[ -n "$AIRFLOW_HOSTNAME_CALLABLE" ]] && airflow_conf_set "core" "hostname_callable" "$AIRFLOW_HOSTNAME_CALLABLE"

    # Configure Airflow database
    airflow_configure_database

    # Configure the Webserver port
    airflow_conf_set "webserver" "web_server_port" "$AIRFLOW_WEBSERVER_PORT_NUMBER"

    # Setup fernet key
    [[ -n "$AIRFLOW_FERNET_KEY" ]] && airflow_conf_set "core" "fernet_key" "$AIRFLOW_FERNET_KEY"

    # Configure Airflow executor
    airflow_conf_set "core" "executor" "$AIRFLOW_EXECUTOR"
    [[ "$AIRFLOW_EXECUTOR" == "CeleryExecutor" || "$AIRFLOW_EXECUTOR" == "CeleryKubernetesExecutor"  ]] && airflow_configure_celery_executor
    true # Avoid the function to fail due to the check above
}

########################
# Wait Ariflow webserver
# Globals:
#   AIRFLOW_*
# Arguments:
#   None
# Returns:
#   None
#########################
airflow_worker_wait_for_webserver() {
    local -r webserver_host="${1:?missing database host}"
    local -r webserver_port="${2:?missing database port}"
    check_webserver_connection() {
        wait-for-port --host "$webserver_host" "$webserver_port"
    }
    if ! retry_while "check_webserver_connection"; then
        error "Could not connect to the Airflow webserver"
        return 1
    fi
}
