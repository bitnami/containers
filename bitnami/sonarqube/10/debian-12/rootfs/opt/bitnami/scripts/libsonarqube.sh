#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami SonarQube library

# shellcheck disable=SC1091

# Load generic libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libpersistence.sh
. /opt/bitnami/scripts/libservice.sh

# Load database library
if [[ -f /opt/bitnami/scripts/libpostgresqlclient.sh ]]; then
    . /opt/bitnami/scripts/libpostgresqlclient.sh
elif [[ -f /opt/bitnami/scripts/libpostgresql.sh ]]; then
    . /opt/bitnami/scripts/libpostgresql.sh
fi

########################
# Validate settings in SONARQUBE_* env vars
# Globals:
#   SONARQUBE_*
# Arguments:
#   None
# Returns:
#   0 if the validation succeeded, 1 otherwise
#########################
sonarqube_validate() {
    debug "Validating settings in SONARQUBE_* environment variables..."
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
    check_yes_no_value() {
        if ! is_yes_no_value "${!1}" && ! is_true_false_value "${!1}"; then
            print_validation_error "The allowed values for ${1} are: yes no"
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
    check_yes_no_value "SONARQUBE_SKIP_BOOTSTRAP"
    check_valid_port "SONARQUBE_PORT_NUMBER"
    check_valid_port "SONARQUBE_ELASTICSEARCH_PORT_NUMBER"
    ! is_empty_value "$SONARQUBE_DATABASE_HOST" && check_resolved_hostname "$SONARQUBE_DATABASE_HOST"
    ! is_empty_value "$SONARQUBE_DATABASE_PORT_NUMBER" && check_valid_port "SONARQUBE_DATABASE_PORT_NUMBER"

    # Validate credentials
    if is_boolean_yes "${ALLOW_EMPTY_PASSWORD:-}"; then
        warn "You set the environment variable ALLOW_EMPTY_PASSWORD=${ALLOW_EMPTY_PASSWORD:-}. For safety reasons, do not use this flag in a production environment."
    else
        for empty_env_var in "SONARQUBE_DATABASE_PASSWORD" "SONARQUBE_PASSWORD"; do
            is_empty_value "${!empty_env_var}" && print_validation_error "The ${empty_env_var} environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow a blank password. This is only recommended for development environments."
        done
    fi

    # Validate SMTP credentials
    if ! is_empty_value "$SONARQUBE_SMTP_HOST"; then
        for empty_env_var in "SONARQUBE_SMTP_USER" "SONARQUBE_SMTP_PASSWORD"; do
            is_empty_value "${!empty_env_var}" && warn "The ${empty_env_var} environment variable is empty or not set."
        done
        is_empty_value "$SONARQUBE_SMTP_PORT_NUMBER" && print_validation_error "The SONARQUBE_SMTP_PORT_NUMBER environment variable is empty or not set."
        ! is_empty_value "$SONARQUBE_SMTP_PORT_NUMBER" && check_valid_port "SONARQUBE_SMTP_PORT_NUMBER"
        ! is_empty_value "$SONARQUBE_SMTP_PROTOCOL" && check_multi_value "SONARQUBE_SMTP_PROTOCOL" "ssl tls"
    fi

    return "$error_code"
}

########################
# Ensure SonarQube is initialized
# Globals:
#   SONARQUBE_*
# Arguments:
#   None
# Returns:
#   None
#########################
sonarqube_initialize() {
    local -a postgresql_execute_args=("$SONARQUBE_DATABASE_HOST" "$SONARQUBE_DATABASE_PORT_NUMBER" "$SONARQUBE_DATABASE_NAME" "$SONARQUBE_DATABASE_USER" "$SONARQUBE_DATABASE_PASSWORD")

    # Based on https://github.com/SonarSource/sonarqube/blob/master/sonar-application/src/main/assembly/conf/sonar.properties
    info "Creating SonarQube configuration"
    # Database configuration
    sonarqube_conf_set "sonar.jdbc.username" "$SONARQUBE_DATABASE_USER"
    sonarqube_conf_set "sonar.jdbc.password" "$SONARQUBE_DATABASE_PASSWORD"
    # SonarQube includes multiple examples of JDBC configuration, but we want to set it in the PostgreSQL section
    local jdbc_url="jdbc:postgresql://${SONARQUBE_DATABASE_HOST}:${SONARQUBE_DATABASE_PORT_NUMBER}/${SONARQUBE_DATABASE_NAME}"
    replace_in_file "$SONARQUBE_CONF_FILE" "^#sonar.jdbc.url=jdbc:postgresql.*" "sonar.jdbc.url=${jdbc_url}"
    # Web server parameters (NOTE: Avoid exposing SonarQube)
    sonarqube_conf_set "sonar.web.port" "$SONARQUBE_PORT_NUMBER"
    sonarqube_conf_set "sonar.web.host" "127.0.0.1"
    # Search server parameters (NOTE: Elasticsearch is bundled within SonarQube)
    sonarqube_conf_set "sonar.search.port" "$SONARQUBE_ELASTICSEARCH_PORT_NUMBER"
    sonarqube_conf_set "sonar.search.host" "127.0.0.1"
    # Java additional opts
    ! is_empty_value "$SONARQUBE_CE_JAVA_ADD_OPTS" && sonarqube_conf_set "sonar.ce.javaAdditionalOpts" "$SONARQUBE_CE_JAVA_ADD_OPTS"
    ! is_empty_value "$SONARQUBE_ELASTICSEARCH_JAVA_ADD_OPTS" && sonarqube_conf_set "sonar.search.javaAdditionalOpts" "$SONARQUBE_ELASTICSEARCH_JAVA_ADD_OPTS"
    ! is_empty_value "$SONARQUBE_WEB_JAVA_ADD_OPTS" && sonarqube_conf_set "sonar.web.javaAdditionalOpts" "$SONARQUBE_WEB_JAVA_ADD_OPTS"
    # Disable log rotation (to be handled externally)
    sonarqube_conf_set "sonar.log.rollingPolicy" "none"
    # Additional properties
    local -a additional_properties
    IFS=',' read -r -a additional_properties <<< "$SONARQUBE_EXTRA_PROPERTIES"
    if [[ "${#additional_properties[@]}" -gt 0 ]]; then
        info "Adding properties provided via SONARQUBE_EXTRA_PROPERTIES to sonar.properties"
        for property in "${additional_properties[@]}"; do
            sonarqube_conf_set "${property%%=*}" "${property#*=}"
        done
    fi

    info "Trying to connect to the database server"
    sonarqube_wait_for_postgresql_connection "${postgresql_execute_args[@]}"

    # Check if SonarQube has already been initialized and persisted in a previous run
    local -r app_name="sonarqube"
    if ! is_app_initialized "$app_name"; then
        # Ensure SonarQube persisted directories exist (i.e. when a volume has been mounted to /bitnami)
        info "Ensuring SonarQube directories exist"
        ensure_dir_exists "$SONARQUBE_VOLUME_DIR"
        # Use daemon:root ownership for compatibility when running as a non-root user
        am_i_root && configure_permissions_ownership "$SONARQUBE_VOLUME_DIR" -d "775" -f "664" -u "$SONARQUBE_DAEMON_USER" -g "root"

        # Start SonarQube to initialize database, in order to be able to update users
        sonarqube_start_bg

        if ! is_boolean_yes "$SONARQUBE_SKIP_BOOTSTRAP"; then
            # Unfortunately SonarQube does not provide a CLI to perform actions like enabling authentication or to reset credentials
            info "Configuring user credentials"
            local sonarqube_default_username="admin"
            local sonarqube_default_password="admin"
            local sonarqube_api_url="http://127.0.0.1:${SONARQUBE_PORT_NUMBER}/api"
            local -a curl_opts=(
                "--silent"
                "--request" "POST"
                "--user" "${sonarqube_default_username}:${sonarqube_default_password}"
                "--data-urlencode" "login=${sonarqube_default_username}"
                "--data-urlencode" "previousPassword=${sonarqube_default_password}"
                "--data-urlencode" "password=${SONARQUBE_PASSWORD}"
            )
            debug_execute curl "${curl_opts[@]}" "${sonarqube_api_url}/users/change_password"

            # Update the username and email as well
            postgresql_remote_execute "${postgresql_execute_args[@]}" <<EOF
UPDATE users SET login = '${SONARQUBE_USERNAME}', email = '${SONARQUBE_EMAIL}' WHERE login = '${sonarqube_default_username}';
EOF

            # SMTP configuration
            # Based on https://github.com/SonarSource/sonarqube/blob/master/sonar-plugin-api/src/main/java/org/sonar/api/config/EmailSettings.java#L39
            if ! is_empty_value "$SONARQUBE_SMTP_HOST"; then
                info "Configuring SMTP"
                local -a settings_to_update=("email.smtp_host.secured=${SONARQUBE_SMTP_HOST}")
                ! is_empty_value "$SONARQUBE_SMTP_PORT_NUMBER" && settings_to_update+=("email.smtp_port.secured=${SONARQUBE_SMTP_PORT_NUMBER}")
                ! is_empty_value "$SONARQUBE_SMTP_USER" && settings_to_update+=("email.smtp_username.secured=${SONARQUBE_SMTP_USER}")
                ! is_empty_value "$SONARQUBE_SMTP_PASSWORD" && settings_to_update+=("email.smtp_password.secured=${SONARQUBE_SMTP_PASSWORD}")
                [[ "$SONARQUBE_SMTP_PROTOCOL" = "ssl" || "$SONARQUBE_SMTP_PROTOCOL" = "tls" ]] && settings_to_update+=("email.smtp_secure_connection.secured=starttls")
                local unix_timestamp_ms
                unix_timestamp_ms="$(date '+%s%N' | cut -b1-13)"
                for setting in "${settings_to_update[@]}"; do
                    postgresql_remote_execute "${postgresql_execute_args[@]}" <<EOF
INSERT INTO properties (uuid, prop_key, is_empty, text_value, created_at) VALUES ('$(generate_random_string -t alphanumeric -c 20)', '${setting%=*}', '0', '${setting#*=}', '${unix_timestamp_ms}');
EOF
                done
            fi
        else
            info "An already initialized SonarQube database was provided, configuration will be skipped"
        fi

        info "Stopping SonarQube"
        sonarqube_stop

        info "Persisting SonarQube installation"
        persist_app "$app_name" "$SONARQUBE_DATA_TO_PERSIST"
    else
        info "Restoring persisted SonarQube installation"
        restore_persisted_app "$app_name" "$SONARQUBE_DATA_TO_PERSIST"
    fi

    # Check and move provisioned content from mounted provisioning directory to application directory
    if ! is_mounted_dir_empty "$SONARQUBE_MOUNTED_PROVISIONING_DIR"; then
                info "Found mounted provisioning directory"
                sonarqube_copy_mounted_config
    fi

    # At this point it is safe to expose SonarQube publicly
    sonarqube_conf_set "sonar.web.host" "0.0.0.0"
    sonarqube_conf_set "sonar.web.context" "$SONARQUBE_WEB_CONTEXT"

    # Also configure memory options at this point, to avoid any possible issues during initialization
    if ! is_empty_value "$SONARQUBE_MAX_HEAP_SIZE" && ! is_empty_value "$SONARQUBE_MIN_HEAP_SIZE"; then
        sonarqube_set_heap_size "$SONARQUBE_MAX_HEAP_SIZE" "$SONARQUBE_MIN_HEAP_SIZE"
    fi

    # Avoid exit code of previous commands to affect the result of this function
    true
}

########################
# Start SonarQube in background
# Arguments:
#   None
# Returns:
#   None
#########################
sonarqube_start_bg() {
    is_sonarqube_running && return

    info "Starting SonarQube in background"
    (
        cd "$SONARQUBE_BASE_DIR" || return 1
        if am_i_root; then
            debug_execute run_as_user "$SONARQUBE_DAEMON_USER" "${SONARQUBE_BIN_DIR}/sonar.sh" "start"
        else
            debug_execute "${SONARQUBE_BIN_DIR}/sonar.sh" "start"
        fi
        info "Waiting for SonarQube to start..."
        # Use a RegEx to support both SonarQube 8 & 9 formats
        wait_for_log_entry "SonarQube is (up|operational)" "$SONARQUBE_LOG_FILE" "$SONARQUBE_START_TIMEOUT" "1"
    )
}

########################
# Add or modify an entry in the SonarQube configuration file
# Globals:
#   SONARQUBE_*
# Arguments:
#   $1 - Variable name
#   $2 - Value to assign to the variable
# Returns:
#   None
#########################
sonarqube_conf_set() {
    local -r key="${1:?key missing}"
    local -r value="${2:-}"
    debug "Setting ${key} to '${value}' in SonarQube configuration"
    # Sanitize key (sed does not support fixed string substitutions)
    local sanitized_pattern
    sanitized_pattern="^\s*(#\s*)?$(sed 's/[]\[^$.*/]/\\&/g' <<< "$key")\s*=.*"
    local entry="${key}=${value}"
    # Check if the configuration exists in the file
    if grep -q -E "$sanitized_pattern" "$SONARQUBE_CONF_FILE"; then
        # It exists, so replace the line
        replace_in_file "$SONARQUBE_CONF_FILE" "$sanitized_pattern" "$entry"
    else
        # It doesn't exist, so append to the end of the file
        cat >> "$SONARQUBE_CONF_FILE" <<< "$entry"
    fi
}

########################
# Configure SonarQube heap size
# Globals:
#   SONARQUBE_*
# Arguments:
#   None
# Returns:
#   None
#########################
sonarqube_set_heap_size() {
    local max="${1:?max heap size value missing}"
    local min="${2:?min heap size value missing}"
    info "Setting heap size to -Xmx${max} -Xms${min}"
    sonarqube_conf_set "sonar.ce.javaOpts" "-Xmx${max} -Xms${min} -XX:+HeapDumpOnOutOfMemoryError"
    sonarqube_conf_set "sonar.web.javaOpts" "-Xmx${max} -Xms${min} -XX:+HeapDumpOnOutOfMemoryError"
    # It is recommended to configure the heap size for Elasticsearch to the same value (in this case, to the max value)
    sonarqube_conf_set "sonar.search.javaOpts" "-Xmx${max} -Xms${max} -XX:+HeapDumpOnOutOfMemoryError"
}

########################
# Get an entry from the SonarQube configuration file
# Globals:
#   SONARQUBE_*
# Arguments:
#   $1 - Variable name
# Returns:
#   None
#########################
sonarqube_conf_get() {
    local -r key="${1:?key missing}"
    debug "Getting ${key} from SonarQube configuration"
    # Sanitize key (sed does not support fixed string substitutions)
    local sanitized_pattern
    sanitized_pattern="^\s*(#\s*)?$(sed 's/[]\[^$.*/]/\\&/g' <<< "$key")\s*=([^;]+);"
    grep -E "$sanitized_pattern" "$SONARQUBE_CONF_FILE" | sed -E "s|${sanitized_pattern}|\2|" | tr -d "\"' "
}

########################
# Wait until the database is accessible with the currently-known credentials
# Globals:
#   *
# Arguments:
#   $1 - database host
#   $2 - database port
#   $3 - database name
#   $4 - database username
#   $5 - database user password (optional)
# Returns:
#   true if the database connection succeeded, false otherwise
#########################
sonarqube_wait_for_postgresql_connection() {
    local -r db_host="${1:?missing database host}"
    local -r db_port="${2:?missing database port}"
    local -r db_name="${3:?missing database name}"
    local -r db_user="${4:?missing database user}"
    local -r db_pass="${5:-}"
    check_postgresql_connection() {
        echo "SELECT 1" | postgresql_remote_execute "$db_host" "$db_port" "$db_name" "$db_user" "$db_pass"
    }
    if ! retry_while "check_postgresql_connection"; then
        error "Could not connect to the database"
        return 1
    fi
}

########################
# Check if SonarQube is running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_sonarqube_running() {
    # The 'sonar.sh status' command checks whether the PID file exists, and a process exists with that PID
    # That way we do not need to re-implement such logic
    if am_i_root; then
        debug_execute run_as_user "$SONARQUBE_DAEMON_USER" "${SONARQUBE_BIN_DIR}/sonar.sh" "status"
    else
        debug_execute "${SONARQUBE_BIN_DIR}/sonar.sh" "status"
    fi
}

########################
# Check if SonarQube is not running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_sonarqube_not_running() {
    ! is_sonarqube_running
}

########################
# Stop SonarQube
# Arguments:
#   None
# Returns:
#   None
#########################
sonarqube_stop() {
    ! is_sonarqube_running && return
    if am_i_root; then
        debug_execute run_as_user "$SONARQUBE_DAEMON_USER" "${SONARQUBE_BIN_DIR}/sonar.sh" "stop"
    else
        debug_execute "${SONARQUBE_BIN_DIR}/sonar.sh" "stop"
    fi
}

########################
# Copy mounted configuration files
# Globals:
#   SONARQUBE_*
# Arguments:
#   None
# Returns:
#   None
#########################
sonarqube_copy_mounted_config() {
    if ! is_dir_empty "$SONARQUBE_MOUNTED_PROVISIONING_DIR"; then
        if ! cp -Lr "${SONARQUBE_MOUNTED_PROVISIONING_DIR}"/* "${SONARQUBE_VOLUME_DIR}"; then
            error "Issue copying mounted configuration files from $SONARQUBE_MOUNTED_PROVISIONING_DIR to $SONARQUBE_VOLUME_DIR. Make sure you are not mounting configuration files in $SONARQUBE_MOUNTED_PROVISIONING_DIR and $SONARQUBE_VOLUME_DIR at the same time"
            exit 1
        fi
    fi
}
