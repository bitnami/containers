#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami Appsmith library

# shellcheck disable=SC1090
# shellcheck disable=SC1091

# Load generic libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libpersistence.sh
. /opt/bitnami/scripts/libservice.sh

########################
# Validate settings in APPSMITH_* env vars
# Globals:
#   APPSMITH_*
# Arguments:
#   None
# Returns:
#   0 if the validation succeeded, 1 otherwise
#########################
appsmith_validate() {
    debug "Validating settings in APPSMITH_* environment variables..."
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }
    check_empty_value() {
        if is_empty_value "${!1}"; then
            print_validation_error "${1} must be set"
        fi
    }

    check_multi_value() {
        if [[ " ${2} " != *" ${!1} "* ]]; then
            print_validation_error "The allowed values for ${1} are: ${2}"
        fi
    }
    check_resolved_hostname() {
        if ! is_hostname_resolved "$1"; then
            warn "Hostname ${1} could not be resolved, this could lead to connection issues"
        fi
    }
    check_valid_port() {
        local port_var="${1:?missing port variable}"
        local err
        if ! err="$(validate_port "${!port_var}")"; then
            print_validation_error "An invalid port was specified in the environment variable ${port_var}: ${err}."
        fi
    }

    # Validate user inputs
    ! is_empty_value "$APPSMITH_API_PORT" && check_valid_port "APPSMITH_API_PORT"
    ! is_empty_value "$APPSMITH_RTS_PORT" && check_valid_port "APPSMITH_RTS_PORT"

    if [[ "$APPSMITH_MODE" == "client" ]]; then
        ! is_empty_value "$APPSMITH_UI_HTTP_PORT" && check_valid_port "APPSMITH_UI_HTTP_PORT"
    fi

    # Validate credentials
    if is_boolean_yes "${ALLOW_EMPTY_PASSWORD:-}"; then
        warn "You set the environment variable ALLOW_EMPTY_PASSWORD=${ALLOW_EMPTY_PASSWORD:-}. For safety reasons, do not use this flag in a production environment."
    else
        if [[ "$APPSMITH_MODE" != "client" ]]; then
            is_empty_value "${APPSMITH_DATABASE_PASSWORD}" && print_validation_error "The APPSMITH_DATABASE_PASSWORD environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow a blank password. This is only recommended for development environments."
        fi
        if [[ "$APPSMITH_MODE" == "backend" ]]; then
            is_empty_value "${APPSMITH_REDIS_PASSWORD}" && print_validation_error "The APPSMITH_REDIS_PASSWORD environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow a blank password. This is only recommended for development environments."
        fi
    fi

    if [[ "$APPSMITH_MODE" == "backend" ]]; then
        for empty_env_var in "APPSMITH_ENCRYPTION_PASSWORD" "APPSMITH_ENCRYPTION_SALT"; do
            is_empty_value "${!empty_env_var}" && print_validation_error "The ${empty_env_var} environment variable is empty or not set."
        done
    fi

    if [[ "$APPSMITH_MODE" != "client" ]]; then
        # Database configuration validations
        check_resolved_hostname "$APPSMITH_DATABASE_HOST"
        check_valid_port "APPSMITH_DATABASE_PORT_NUMBER"

        # Redis configuration validations
        check_resolved_hostname "$APPSMITH_REDIS_HOST"
        check_valid_port "APPSMITH_REDIS_PORT_NUMBER"
    fi
    # Appsmith mode
    check_multi_value "APPSMITH_MODE" "backend rts client"

    if [[ $APPSMITH_MODE == "rts" ]]; then
        is_empty_value "${APPSMITH_API_HOST}" && print_validation_error "For RTS mode, the APPSMITH_API_HOST variable must be set"
    fi

    if [[ $APPSMITH_MODE == "client" ]]; then
        is_empty_value "${APPSMITH_API_HOST}" && print_validation_error "For client mode, the APPSMITH_API_HOST variable must be set"
        is_empty_value "${APPSMITH_RTS_HOST}" && print_validation_error "For client mode, the APPSMITH_API_HOST variable must be set"
    fi

    return "$error_code"
}

########################
# Add or modify an entry in the Appsmith configuration file
# Globals:
#   APPSMITH_*
# Arguments:
#   $1 - XPath expression
#   $2 - Value to assign to the variable
#   $3 - Configuration file
# Returns:
#   None
#########################
appsmith_conf_set() {
    local -r key="${1:?key missing}"
    local -r value="${2:?value missing}"
    local -r is_literal="${3:-no}"
    debug "Setting ${key} to '${value}' in Appsmith configuration (literal: ${is_literal})"
    # Sanitize key (sed does not support fixed string substitutions)
    local sanitized_pattern
    sanitized_pattern="${key}=.*"
    local entry
    is_boolean_yes "$is_literal" && entry="${key}=${value}" || entry="${key}='${value}'"
    # Check if the configuration exists in the file
    debug "$sanitized_pattern"
    if grep -q -E "$sanitized_pattern" "$APPSMITH_CONF_FILE"; then
        # It exists, so replace the line
        replace_in_file "$APPSMITH_CONF_FILE" "$sanitized_pattern" "$entry"
    else
        # The Appsmith configuration file includes all supported keys, but because of its format,
        # we cannot append contents to the end.
        warn "Could not set the Appsmith '${key}' configuration. Check that the file has not been modified externally."
    fi
}

########################
# Check if Appsmith backend daemon is running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_appsmith_backend_running() {
    # appsmith-backend does not create any PID file
    # We regenerate the PID file for each time we query it to avoid getting outdated
    pgrep -f "${APPSMITH_BASE_DIR}/backend/server.jar" | head -n 1 > "$APPSMITH_PID_FILE"

    pid="$(get_pid_from_file "$APPSMITH_PID_FILE")"
    if [[ -n "$pid" ]]; then
        is_service_running "$pid"
    else
        false
    fi
}

########################
# Check if Appsmith backend daemon is not running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_appsmith_backend_not_running() {
    ! is_appsmith_backend_running
}

########################
# Stop Appsmith backend daemon
# Arguments:
#   None
# Returns:
#   None
#########################
appsmith_backend_stop() {
    ! is_appsmith_backend_running && return
    stop_service_using_pid "$APPSMITH_PID_FILE"
}

########################
# Check if Appsmith rts daemon is running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_appsmith_rts_running() {
    # appsmith-rts does not create any PID file
    # We regenerate the PID file for each time we query it to avoid getting outdated
    pgrep -f "${APPSMITH_BASE_DIR}/rts/bundle/server.js" | head -n 1 > "$APPSMITH_RTS_PID_FILE"

    pid="$(get_pid_from_file "$APPSMITH_RTS_PID_FILE")"
    if [[ -n "$pid" ]]; then
        is_service_running "$pid"
    else
        false
    fi
}

########################
# Check if Appsmith rts daemon is not running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_appsmith_rts_not_running() {
    ! is_appsmith_rts_running
}

########################
# Stop Appsmith rts daemon
# Arguments:
#   None
# Returns:
#   None
#########################
appsmith_rts_stop() {
    ! is_appsmith_rts_running && return
    stop_service_using_pid "$APPSMITH_RTS_PID_FILE"
}

########################
# Get a configuration setting value from the configuration file(s)
# Globals:
#   APPSMITH_*
# Arguments:
#   $1 - property key
#   $2 - configuration file (optional)
# Returns:
#   String (empty string if file or key doesn't exist)
#########################
appsmith_conf_get() {
    local -r key="${1:?key missing}"
    local -r file="${2:-"${APPSMITH_CONF_FILE}"}"

    # Sanitize key (sed does not support fixed string substitutions)
    local sanitized_pattern
    sanitized_pattern="^\s*(//\s*)?$(sed 's/[]\[^$.*/]/\\&/g' <<<"$key")=(.*)"
    grep -E "$sanitized_pattern" "$file" | sed -E "s|${sanitized_pattern}|\2|" | tr -d "\"' "
}

########################
# Wait until the database is accessible with the currently-known credentials
# Globals:
#   *
# Arguments:
#   $1 - connection string
# Returns:
#   true if the database connection succeeded, false otherwise
#########################
appsmith_wait_for_mongodb_connection() {
    local -r connection_string="${1:?missing connection string}"
    check_mongodb_connection() {
        local -r mongo_args=("$connection_string" "--eval" "db.stats()")
        local -r res=$(mongosh "${mongo_args[@]}")
        debug "$res"
        echo "$res" | grep -q 'ok: 1'
    }
    if ! retry_while "check_mongodb_connection"; then
        error "Could not connect to the database"
        return 1
    fi
    # HACK: The MongoDB Replica Set initialization requires the MongoDB cluster to be
    # accessible during the initial sync. After that, the secondary nodes shut downs and then
    # starts again (this is how the current Bitnami MongoDB container works). In the case of
    # docker-compose scenarios, we experienced several race conditions, as the cluster is ready
    # (performing the initial sync) but the MongoDB container initialization logic is not finished yet.
    # As a workaround, only in docker-compose we add this extra delay to ensure that Appsmith components
    # do not crash. In the case of helm charts, we have readiness/liveness probes as well as init containers
    # that avoid this unwanted race condition.
    if [[ "$APPSMITH_DATABASE_INIT_DELAY" -ge "0" ]]; then
        info "Sleeping $APPSMITH_DATABASE_INIT_DELAY seconds for the MongoDB cluster to be ready"
        sleep "$APPSMITH_DATABASE_INIT_DELAY"
    fi
}

########################
# Initialize Appsmith
# Arguments:
#   None
# Returns:
#   None
#########################
appsmith_initialize() {
    # The logic is inspired on the upstream Appsmith container. Currently it follows a "fat-container"
    # approach with all the services in the container. In the Bitnami version we want to keep them separate
    # as it works better for the helm chart
    # Appsmith is comprised of three components:
    # - backend: API written in Java. The client (UI) component interacts with it. Connects to MongoDB and Redis
    # - client: Web UI. Point of access for users. Has nginx as the backend. Connects to the API and the RTS.
    # - rts: Component written in Node.js. Creates websockets for editing the applications in real-time. Connects to the API and MongoDB
    # https://github.com/appsmithorg/appsmith/tree/release/deploy/docker

    # The client (UI) only needs to generate the nginx vhost configuration
    if [[ "$APPSMITH_MODE" != "client" ]]; then
        # RTS or API server
        if { [[ "$APPSMITH_MODE" == "rts" ]]; } || { ! is_app_initialized "appsmith"; }; then
            info "Deploying Appsmith $APPSMITH_MODE from scratch"
            # First connect to the database
            # Appsmith (especially the RTS component) requires the MongoDB instance to be a Replica Set.
            # We performed tests with single-node replica sets but didn't work as expected in container
            # re-creation scenarios.
            local connection_string="mongodb://${APPSMITH_DATABASE_USER}:${APPSMITH_DATABASE_PASSWORD}@"
            local add_comma=false
            for host in ${APPSMITH_DATABASE_HOST//,/ }; do
                if is_boolean_yes "$add_comma"; then
                    connection_string+=","
                else
                    add_comma=true
                fi
                connection_string+="${host}:${APPSMITH_DATABASE_PORT_NUMBER}"
            done
            connection_string+="/${APPSMITH_DATABASE_NAME}"
            appsmith_wait_for_mongodb_connection "$connection_string"

            # These parameters are common between RTS and Backend
            # https://github.com/appsmithorg/appsmith/blob/658e369f4fc2f12445af5b238bc4d4a1a34d9a8b/app/rts/.env.example#L1-L3
            appsmith_conf_set "APPSMITH_DB_URL" "$connection_string"
            appsmith_conf_set "APPSMITH_API_BASE_URL" "http://${APPSMITH_API_HOST}:${APPSMITH_API_PORT}/api/v1"

            if [[ "$APPSMITH_MODE" == "backend" ]]; then
                # Necessary configuration for the Backend. As this can be edited via the
                # admin panel, we only edit it the first time
                # https://github.com/appsmithorg/appsmith/blob/release/app/server/appsmith-server/src/main/resources/application.properties
                appsmith_conf_set "APPSMITH_MONGODB_PASSWORD" "$APPSMITH_DATABASE_PASSWORD"
                appsmith_conf_set "APPSMITH_MONGODB_USER" "$APPSMITH_DATABASE_USER"
                appsmith_conf_set "APPSMITH_REDIS_URL" "redis://:${APPSMITH_REDIS_PASSWORD}@${APPSMITH_REDIS_HOST}:${APPSMITH_REDIS_PORT_NUMBER}"
                appsmith_conf_set "APPSMITH_ENCRYPTION_PASSWORD" "$APPSMITH_ENCRYPTION_PASSWORD"
                appsmith_conf_set "APPSMITH_ENCRYPTION_SALT" "$APPSMITH_ENCRYPTION_SALT"
                info "Ensuring Appsmith directories exist"
                ensure_dir_exists "$APPSMITH_VOLUME_DIR"
                info "Persisting Appsmith installation"
                persist_app "appsmith" "$APPSMITH_DATA_TO_PERSIST"

                # Create Appsmith user
                appsmith_backend_start_bg "${APPSMITH_LOG_DIR}/appsmith_first_boot.log"
                info "Creating admin user"
                local -r -a create_user_cmd=("curl")
                # Taken from inspecting Appsmith wizard
                # https://github.com/appsmithorg/appsmith/blob/release/app/server/appsmith-server/src/main/java/com/appsmith/server/dtos/UserSignupRequestDTO.java#L26
                # Necessary for the installer to succeed
                local -r -a create_user_args=("-L" "http://localhost:${APPSMITH_API_PORT}/api/v1/users/super"
                    "-H" "Origin: http://localhost:${APPSMITH_API_PORT}"
                    "-H" "Content-Type: application/x-www-form-urlencoded"
                    "--data-urlencode" "name=${APPSMITH_USERNAME}"
                    "--data-urlencode" "email=${APPSMITH_EMAIL}"
                    "--data-urlencode" "password=${APPSMITH_PASSWORD}"
                    "--data-urlencode" "allowCollectingAnnonymousData=false"
                    "--data-urlencode" "signupForNewsletter=false"
                    "--data-urlencode" "proficiency=advanced"
                    "--data-urlencode" "useCase='personal project'")
                if ! debug_execute "${create_user_cmd[@]}" "${create_user_args[@]}"; then
                    error "Installation failed. User ${APPSMITH_USERNAME} could not be created"
                    exit 1
                fi
                info "User created successfully"
            fi
        else
            # The migration is done by Appsmith itself, not necessary to run
            # any extra script. We just connect to the database
            info "Restoring persisted Appsmith $APPSMITH_MODE installation"
            restore_persisted_app "appsmith" "$APPSMITH_DATA_TO_PERSIST"
            local connection_string
            connection_string="$(appsmith_conf_get APPSMITH_DB_URL)"
            # If APPSMITH_DB_URL is not set, fall back to APPSMITH_MONGODB_URI
            # https://github.com/appsmithorg/appsmith/commit/7e339d419dfffbb9d0178a9e5c54afb85600976f#diff-0359aa9032b425f4bd7785d82ab0684e159a38fcfb5a6036c31a070e21e5952a
            if [[ -z "${connection_string}" ]]; then
                connection_string="$(appsmith_conf_get APPSMITH_MONGODB_URI)"
            fi
            appsmith_wait_for_mongodb_connection "$connection_string"
        fi
    fi

    # Avoid exit code of previous commands to affect the result of this function
    true
}

########################
# Start Appsmith daemon
# Arguments:
#   $1 - Log file to check the startup message
# Returns:
#   None
#########################
appsmith_backend_start_bg() {
    local -r log_file="${1:-"${APPSMITH_LOG_FILE}"}"
    info "Starting Appsmith backend in background"

    is_appsmith_backend_running && return

    # We need to load in the environment the Appsmith configuration file in order
    # for the application to work. Using a similar approach as the upstream container.
    # We also need to load only those environment variables that are not empty, otherwise
    # the Appsmith daemon crashes on startup because of not allowed empty values.
    # https://github.com/appsmithorg/appsmith/blob/v1.9.12/deploy/docker/entrypoint.sh#L58-L63
    set -a
    . "$APPSMITH_CONF_FILE"
    set +a

    appsmith_unset_unused_variables

    cd "${APPSMITH_BASE_DIR}/backend" || exit 1
    local -r cmd=("java")
    local -r args=("-Dserver.port=${APPSMITH_API_PORT}" "-Dappsmith.admin.envfile=${APPSMITH_CONF_FILE}" "-Djava.security.egd=file:/dev/./urandom" "-jar" "${APPSMITH_BASE_DIR}/backend/server.jar")
    if am_i_root; then
        run_as_user "$APPSMITH_DAEMON_USER" "${cmd[@]}" "${args[@]}" >"$log_file" 2>&1 &
    else
        "${cmd[@]}" "${args[@]}" >"$log_file" 2>&1 &
    fi

    echo "$!" >"$APPSMITH_PID_FILE"

    wait_for_log_entry "License verification completed with status: valid" "$log_file" 30 10
    info "Appsmith started successfully"
}

########################
# Unset environment variables that may cause Appsmith to crash during initialization
# https://github.com/appsmithorg/appsmith/blob/v1.9.12/deploy/docker/entrypoint.sh#L83-L109
# Arguments:
#   None
# Returns:
#   None
#########################
appsmith_unset_unused_variables() {
    info "Unsetting unused environment variables"
    if [[ -z "${APPSMITH_MAIL_ENABLED}" ]]; then
        unset APPSMITH_MAIL_ENABLED
    fi

    if [[ -z "${APPSMITH_OAUTH2_GITHUB_CLIENT_ID}" ]] || [[ -z "${APPSMITH_OAUTH2_GITHUB_CLIENT_SECRET}" ]]; then
        unset APPSMITH_OAUTH2_GITHUB_CLIENT_ID
        unset APPSMITH_OAUTH2_GITHUB_CLIENT_SECRET
    fi

    if [[ -z "${APPSMITH_OAUTH2_GOOGLE_CLIENT_ID}" ]] || [[ -z "${APPSMITH_OAUTH2_GOOGLE_CLIENT_SECRET}" ]]; then
        unset APPSMITH_OAUTH2_GOOGLE_CLIENT_ID
        unset APPSMITH_OAUTH2_GOOGLE_CLIENT_SECRET
    fi

    if [[ -z "${APPSMITH_RECAPTCHA_SITE_KEY}" ]] || [[ -z "${APPSMITH_RECAPTCHA_SECRET_KEY}" ]] || [[ -z "${APPSMITH_RECAPTCHA_ENABLED}" ]]; then
        unset APPSMITH_RECAPTCHA_SITE_KEY
        unset APPSMITH_RECAPTCHA_SECRET_KEY
        unset APPSMITH_RECAPTCHA_ENABLED
    fi
}
