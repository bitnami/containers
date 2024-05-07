#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami Mastodon library

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
# Validate settings in MASTODON_* env vars
# Globals:
#   MASTODON_*
# Arguments:
#   None
# Returns:
#   0 if the validation succeeded, 1 otherwise
#########################
mastodon_validate() {
    debug "Validating settings in MASTODON_* environment variables..."
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

    check_true_false() {
        if ! is_true_false_value "${!1}"; then
            print_validation_error "The allowed values for ${1} are: true or false"
        fi
    }

    check_integer() {
        if ! is_int "${!1}"; then
            print_validation_error "The value for ${1} is not a valid integer"
        fi
    }

    check_password_length() {
        local password_var="${1:?missing password_var}"
        local length="${2:?missing length}"
        local password="${!1}"
        if [[ "${#password}" -lt "$length" ]]; then
            print_validation_error "${password_var} must be at least ${length} characters"
        fi
    }

    check_true_false "MASTODON_ELASTICSEARCH_ENABLED"
    if is_boolean_yes "$MASTODON_ELASTICSEARCH_ENABLED"; then
        check_true_false "MASTODON_MIGRATE_ELASTICSEARCH"
        check_resolved_hostname "MASTODON_ELASTICSEARCH_HOST"
        check_valid_port "MASTODON_ELASTICSEARCH_PORT_NUMBER"
    fi

    # Validate credentials
    if is_boolean_yes "${ALLOW_EMPTY_PASSWORD:-}"; then
        warn "You set the environment variable ALLOW_EMPTY_PASSWORD=${ALLOW_EMPTY_PASSWORD:-}. For safety reasons, do not use this flag in a production environment."
    else
        if [[ "$MASTODON_MODE" == "web" ]]; then
            is_empty_value "${MASTODON_DATABASE_PASSWORD:-}" && print_validation_error "The MASTODON_DATABASE_PASSWORD environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow a blank password. This is only recommended for development environments."
            is_empty_value "${MASTODON_REDIS_PASSWORD:-}" && print_validation_error "The MASTODON_REDIS_PASSWORD environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow a blank password. This is only recommended for development environments."
            is_boolean_yes "$MASTODON_ELASTICSEARCH_ENABLED" && is_empty_value "${MASTODON_ELASTICSEARCH_PASSWORD:-}" && print_validation_error "The MASTODON_ELASTICSEARCH_PASSWORD environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow a blank password. This is only recommended for development environments."
        fi
    fi

    # Mastodon mode
    check_multi_value "MASTODON_MODE" "web sidekiq streaming"

    check_true_false "MASTODON_CREATE_ADMIN"
    if is_boolean_yes "$MASTODON_CREATE_ADMIN"; then
        check_empty_value "MASTODON_ADMIN_EMAIL"
        check_empty_value "MASTODON_ADMIN_PASSWORD"
        check_empty_value "MASTODON_ADMIN_USERNAME"
    fi

    check_true_false "MASTODON_S3_ENABLED"

    if is_boolean_yes "$MASTODON_S3_ENABLED"; then
        check_empty_value "MASTODON_S3_HOSTNAME"
        check_resolved_hostname "$MASTODON_S3_HOSTNAME"
        check_valid_port "MASTODON_S3_PORT_NUMBER"
        check_empty_value "MASTODON_S3_ALIAS_HOST"
        check_empty_value "MASTODON_S3_ENDPOINT"
        check_empty_value "MASTODON_AWS_ACCESS_KEY_ID"
        check_empty_value "MASTODON_AWS_SECRET_ACCESS_KEY"
        check_multi_value "MASTODON_S3_PROTOCOL" "http https"
    fi

    if [[ $MASTODON_MODE != "web" ]]; then
        is_empty_value "${MASTODON_WEB_HOST}" && print_validation_error "For Sidekiq and Streaming modes, the MASTODON_WEB_HOST variable must be set"
        check_resolved_hostname "MASTODON_WEB_HOST"
    fi

    check_valid_port "MASTODON_WEB_PORT_NUMBER"
    check_valid_port "MASTODON_STREAMING_PORT_NUMBER"

    check_empty_value "MASTODON_SECRET_KEY_BASE"
    check_empty_value "MASTODON_OTP_SECRET"

    check_true_false "MASTODON_MIGRATE_DATABASE"
    check_resolved_hostname "MASTODON_DATABASE_HOST"
    check_valid_port "MASTODON_DATABASE_PORT_NUMBER"
    check_integer "MASTODON_DATABASE_POOL"

    check_resolved_hostname "MASTODON_REDIS_HOST"
    check_valid_port "MASTODON_REDIS_PORT_NUMBER"

    check_true_false "MASTODON_ALLOW_ALL_DOMAINS"
    check_password_length "MASTODON_ADMIN_PASSWORD" "8"
    return "$error_code"
}

########################
# Executes Bundler with the proper environment and the specified arguments and print result to stdout
# Globals:
#   MASTODON_*
# Arguments:
#   $1..$n - Arguments to pass to the CLI call
# Returns:
#   None
#########################
mastodon_bundle_execute_print_output() {
    # Avoid creating unnecessary cache files at initialization time
    local -a cmd=("bundle" "exec" "$@")
    # Run as application user to avoid having to change permissions/ownership afterwards
    am_i_root && cmd=("run_as_user" "$MASTODON_DAEMON_USER" "${cmd[@]}")
    (
        cd "$MASTODON_BASE_DIR" || false
        "${cmd[@]}"
    )
}

########################
# Executes Bundler with the proper environment and the specified arguments
# Globals:
#   MASTODON_*
# Arguments:
#   $1..$n - Arguments to pass to the CLI call
# Returns:
#   None
#########################
mastodon_bundle_execute() {
    debug_execute mastodon_bundle_execute_print_output "$@"
}

########################
# Executes the 'rake' CLI with the proper Bundler environment and the specified arguments and print result to stdout
# Globals:
#   MASTODON_*
# Arguments:
#   $1..$n - Arguments to pass to the CLI call
# Returns:
#   None
#########################
mastodon_rake_execute_print_output() {
    mastodon_bundle_execute_print_output "rake" "$@"
}

########################
# Executes the 'rake' CLI with the proper Bundler environment and the specified arguments
# Globals:
#   MASTODON_*
# Arguments:
#   $1..$n - Arguments to pass to the CLI call
# Returns:
#   None
#########################
mastodon_rake_execute() {
    debug_execute mastodon_rake_execute_print_output "$@"
}

########################
# Executes the commands specified via stdin in the Rails console for Discourse
# Globals:
#   MASTODON_*
# Arguments:
#   None
# Returns:
#   None
#########################
mastodon_console_execute() {
    local rails_cmd
    rails_cmd="$(</dev/stdin)"
    debug "Executing script with console environment:\n${rails_cmd}"
    mastodon_bundle_execute ruby -e "$(
        cat <<EOF
require File.expand_path("/opt/bitnami/mastodon/config/environment", __FILE__)
${rails_cmd}
EOF
    )"
}

########################
# Create admin user
# Globals:
#   * MASTODON_*
# Arguments:
#   None
# Returns: None
#########################
mastodon_ensure_admin_user_exists() {
    info "Creating admin user"
    cd "$MASTODON_BASE_DIR" || exit
    # We use the tootctl tool to create the admin user
    # https://github.com/mastodon/mastodon/blob/main/chart/templates/job-create-admin.yaml#L50
    local -r cmd=("tootctl")
    local -r args=("accounts" "create" "$MASTODON_ADMIN_USERNAME" "--email" "$MASTODON_ADMIN_EMAIL" "--approve" "--confirmed" "--role" "Owner")
    local res=""
    if am_i_root; then
        # Adding true to avoid the logic to exit
        res="$(run_as_user "$MASTODON_DAEMON_USER" "${cmd[@]}" "${args[@]}" || true)"
    else
        # Adding true to avoid the logic to exit
        res="$("${cmd[@]}" "${args[@]}" || true)"
    fi

    if [[ "$res" =~ "OK" ]]; then
        info "Admin created successfully. Setting password"
        # Taken from the User model in Mastodon. First we need to force a reset to have the
        # encrypted_password field set and then we proceed to reset the password
        # https://github.com/mastodon/mastodon/blob/main/app/models/user.rb#L374
        mastodon_console_execute <<EOF
user = User.find(1)
user.reset_password!
user.reset_password('${MASTODON_ADMIN_PASSWORD}', '${MASTODON_ADMIN_PASSWORD}')
EOF

    elif [[ "$res" =~ "taken" ]]; then
        info "Admin user already exists. Skipping"
    else
        error "Error creating admin user"
        debug "$res"
        exit 1
    fi
}

########################
# Wait for PostgreSQL to be ready
# Globals:
#   * MASTODON_*
# Arguments:
#   None
# Returns: None
#########################
mastodon_wait_for_postgresql_connection() {
    local -r connection_string="${1:?missing connection string}"
    info "Waiting for PostgreSQL to be ready at ${connection_string##*@}"
    check_postgresql_connection() {
        local -r psql_args=("$connection_string" "-c" "SELECT 1")
        local -r res=$(psql "${psql_args[@]}" 2>&1)
        debug "$res"
        echo "$res" | grep -q '1 row'
    }
    if ! retry_while "debug_execute check_postgresql_connection" "$MASTODON_STARTUP_ATTEMPTS"; then
        error "Could not connect to the PostgreSQL database"
        return 1
    fi
    info "PostgreSQL instance is ready"
}

########################
# Wait for Elasticsearch to be ready
# Globals:
#   * MASTODON_*
# Arguments:
#   None
# Returns: None
#########################
mastodon_wait_for_elasticsearch_connection() {
    local -r connection_string="${1:?missing connection string}"
    info "Waiting for Elasticsearch to be ready at $connection_string"
    check_elasticsearch_connection() {
        local curl_args=("-k" "$connection_string" "--max-time" "5")
        if ! is_empty_value "${MASTODON_ELASTICSEARCH_PASSWORD:-}"; then
            curl_args+=("-u" "$MASTODON_ELASTICSEARCH_USER:$MASTODON_ELASTICSEARCH_PASSWORD")
        fi
        local -r res=$(curl "${curl_args[@]}" 2>&1)
        debug "$res"
        echo "$res" | grep -q 'You Know'
    }
    if ! retry_while "debug_execute check_elasticsearch_connection" "$MASTODON_STARTUP_ATTEMPTS"; then
        error "Could not connect to Elasticsearch"
        return 1
    fi
    info "Elasticsearch instance is ready"
}

########################
# Wait for S3 connection
# Globals:
#   * MASTODON_*
# Arguments: None
# Returns: None
#########################
mastodon_wait_for_s3_connection() {
    local -r host="${1:?missing host}"
    local -r port="${2:?missing port}"
    info "Waiting for S3 to be ready at ${MASTODON_S3_PROTOCOL}://${host}:${port}"
    if ! retry_while "debug_execute wait-for-port --host ${host} ${port}" "$MASTODON_STARTUP_ATTEMPTS"; then
        error "Could not connect to S3"
        return 1
    fi
    info "S3 instance is ready"
}

########################
# Wait for Redis connection
# Globals:
#   * MASTODON_*
# Arguments:
#   1: Connection string
# Returns: None
#########################
mastodon_wait_for_redis_connection() {
    local -r connection_string="${1:?missing connection string}"
    info "Waiting for Redis to be ready at ${connection_string##*@}"
    check_redis_connection() {
        local -r redis_args=("-u" "$connection_string" "PING")
        local -r res=$(redis-cli "${redis_args[@]}" 2>&1)
        debug "$res"
        echo "$res" | grep -q 'PONG'
    }
    if ! retry_while "debug_execute check_redis_connection" "$MASTODON_STARTUP_ATTEMPTS"; then
        error "Could not connect to Redis"
        return 1
    fi
    info "Redis instance is ready"
}

########################
# Wait for Mastodon Web to be available
# Globals:
#   * MASTODON_*
# Arguments:
#   None
# Returns: None
#########################
mastodon_wait_for_web_connection() {
    local -r connection_string="${1:?missing connection string}"
    info "Checking for web server at $connection_string"
    check_web_connection() {
        # We use the /health endpoint to check if the web server is ready
        # https://github.com/mastodon/mastodon/blob/main/config/initializers/1_hosts.rb#L34
        local -r curl_args=("${connection_string}/health" "--max-time" "5")
        local -r res=$(curl "${curl_args[@]}" 2>&1)
        debug "$res"
        echo "$res" | grep -q 'OK'
    }
    if ! retry_while "debug_execute check_web_connection" "$MASTODON_STARTUP_ATTEMPTS"; then
        error "Could not connect to the Web server"
        return 1
    fi
    info "Web server is ready"
}

########################
# Initialize Mastodon
# Arguments:
#   None
# Returns:
#   None
#########################
mastodon_initialize() {
    # Logic inspired on the official helm chart
    # Source: https://github.com/mastodon/mastodon/tree/main/chart/templates
    # The logic in this function will be used for docker-compose deployments. In the helm
    # chart we will use separate jobs that call the migration and precompilation commands.
    # This will allow better scalability and avoid race condition issues.
    # There is no configuration file in Mastodon, as everything is done via environment variables
    # https://github.com/mastodon/mastodon/blob/main/chart/templates/configmap-env.yaml
    info "Initializing Mastodon"
    local -r app_name="mastodon"

    # All the initialization logic will be performed by the web node, the other nodes
    # will just wait for web to be available
    if [[ "$MASTODON_MODE" == "web" ]]; then
        # If we are using S3, we do not need to enable persistence. Otherwise we need
        # to persist the system and public folders
        # https://github.com/mastodon/mastodon/blob/main/chart/templates/deployment-web.yaml#L89
        if is_boolean_yes "$MASTODON_S3_ENABLED"; then
            info "Waiting for S3 connection"
            mastodon_wait_for_s3_connection "$MASTODON_S3_HOSTNAME" "$MASTODON_S3_PORT_NUMBER"
        fi

        local -r psql_connection_string="postgresql://${MASTODON_DATABASE_USERNAME}:${MASTODON_DATABASE_PASSWORD}@${MASTODON_DATABASE_HOST}:${MASTODON_DATABASE_PORT_NUMBER}/${MASTODON_DATABASE_NAME}"
        mastodon_wait_for_postgresql_connection "$psql_connection_string"
        if is_boolean_yes "$MASTODON_MIGRATE_DATABASE"; then
            info "Migrating database"
            mastodon_rake_execute db:migrate
        fi

        local redis_connection_string="redis://"
        if [[ -n "${MASTODON_REDIS_PASSWORD:-}" ]]; then
            redis_connection_string+="${MASTODON_REDIS_PASSWORD}@"
        fi
        redis_connection_string+="${MASTODON_REDIS_HOST}:${MASTODON_REDIS_PORT_NUMBER}"
        mastodon_wait_for_redis_connection "$redis_connection_string"

        # Elasticsearch is an optional component in Mastodon. It is necessary for enabling
        # text searches
        if is_boolean_yes "$MASTODON_ELASTICSEARCH_ENABLED"; then
            local -r elasticsearch_connection_string="http://${MASTODON_ELASTICSEARCH_HOST}:${MASTODON_ELASTICSEARCH_PORT_NUMBER}"
            mastodon_wait_for_elasticsearch_connection "$elasticsearch_connection_string"
            if is_boolean_yes "$MASTODON_MIGRATE_ELASTICSEARCH"; then
                info "Migrating Elasticsearch"
                mastodon_rake_execute chewy:upgrade
            fi
        fi

        if is_boolean_yes "$MASTODON_CREATE_ADMIN"; then
            mastodon_ensure_admin_user_exists
        fi

        if ! is_boolean_yes "$MASTODON_S3_ENABLED"; then
            if ! is_app_initialized "$app_name"; then
                info "Persisting Mastodon application"
                persist_app "$app_name" "$MASTODON_DATA_TO_PERSIST"
            else
                info "Mastodon application already initialized, restoring..."
                restore_persisted_app "$app_name" "$MASTODON_DATA_TO_PERSIST"
            fi
        fi

        if is_boolean_yes "$MASTODON_ASSETS_PRECOMPILE"; then
            info "Precompiling assets"
            mastodon_rake_execute "assets:precompile"
        fi

    else

        # When the mode is sidekiq or streaming, we want to wait for the web node to be available
        info "Waiting for Mastodon web to be available"
        mastodon_wait_for_web_connection "http://${MASTODON_WEB_HOST}:${MASTODON_WEB_PORT_NUMBER}"
        if ! is_boolean_yes "$MASTODON_S3_ENABLED" && [[ "$MASTODON_MODE" == "sidekiq" ]]; then
            # If the web node is available, we can assume that the shared volume has been initialized so
            # we can safely restore it (we don't need it for the streaming service)
            # https://github.com/mastodon/mastodon/blob/main/chart/templates/deployment-streaming.yaml#L77
            info "Mastodon application already initialized, restoring..."
            restore_persisted_app "$app_name" "$MASTODON_DATA_TO_PERSIST"
        fi
    fi

    # Avoid exit code of previous commands to affect the result of this function
    true
}

########################
# Add or modify an entry in the Mastodon configuration file (.env.production)
# Globals:
#   MASTODON_BASE_DIR
#   MASTODON_CFG_*
# Arguments:
#   $1 - Environment variable name
#   $2 - Value to assign to the environment variable
# Returns:
#   None
#########################
mastodon_conf_set() {
    local -r key="${1:?key missing}"
    local -r value="${2:-}"
    local -r conf_file="${MASTODON_BASE_DIR}/.env.production"
    debug "Setting ${key} to '${value}' in Mastodon .env.production configuration"
    # Sanitize key (sed does not support fixed string substitutions)
    local sanitized_pattern
    sanitized_pattern="^\s*(#\s*)?$(sed 's/[]\[^$.*/]/\\&/g' <<< "$key")\s*=.*"
    local entry="${key}=${value}"
    # Check if the configuration exists in the file
    if grep -q -E "$sanitized_pattern" "$conf_file"; then
        # It exists, so replace the line
        replace_in_file "$conf_file" "$sanitized_pattern" "$entry"
    else
        cat >> "$conf_file" <<< "$entry"
    fi
}

########################
# Obtain Mastodon runtime configuration and environment variables
# Arguments:
#   None
# Returns:
#   Mastodon runtime configuration and environment variables
#########################
mastodon_runtime_env() {
    # Convert the .env.production file so it can be loaded with eval
    sed -E 's/^\s*([^# ])/export \1/' "${MASTODON_BASE_DIR}/.env.production"
}

########################
# Check if mastodon-web is running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
mastodon_is_web_running() {
    # mastodon-web does not create any PID file
    # We regenerate the PID file for each time we query it to avoid getting outdated
    pgrep -f "puma" | head -n 1 > "$MASTODON_WEB_PID_FILE"

    pid="$(get_pid_from_file "$MASTODON_WEB_PID_FILE")"
    if [[ -n "$pid" ]]; then
        is_service_running "$pid"
    else
        false
    fi
}

########################
# Check if mastodon-web is not running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
mastodon_is_web_not_running() {
    ! mastodon_is_web_running
}

########################
# Stop mastodon-web
# Arguments:
#   None
# Returns:
#   None
#########################
mastodon_web_stop() {
    ! mastodon_is_web_running && return
    stop_service_using_pid "$MASTODON_WEB_PID_FILE"
}

########################
# Check if mastodon-streaming is running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
mastodon_is_streaming_running() {
    # mastodon-streaming does not create any PID file
    # We regenerate the PID file for each time we query it to avoid getting outdated
    pgrep -f "^node \./streaming$" | head -n 1 > "$MASTODON_STREAMING_PID_FILE"

    pid="$(get_pid_from_file "$MASTODON_STREAMING_PID_FILE")"
    if [[ -n "$pid" ]]; then
        is_service_running "$pid"
    else
        false
    fi
}

########################
# Check if mastodon-streaming is not running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
mastodon_is_streaming_not_running() {
    ! mastodon_is_streaming_running
}

########################
# Stop mastodon-streaming
# Arguments:
#   None
# Returns:
#   None
#########################
mastodon_streaming_stop() {
    ! mastodon_is_streaming_running && return
    stop_service_using_pid "$MASTODON_STREAMING_PID_FILE"
}

########################
# Check if mastodon-sidekiq is running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
mastodon_is_sidekiq_running() {
    # mastodon-sidekiq does not create any PID file
    # We regenerate the PID file for each time we query it to avoid getting outdated
    pgrep -f "(bin/sidekiq$|^sidekiq )" | head -n 1 > "$MASTODON_SIDEKIQ_PID_FILE"

    pid="$(get_pid_from_file "$MASTODON_SIDEKIQ_PID_FILE")"
    if [[ -n "$pid" ]]; then
        is_service_running "$pid"
    else
        false
    fi
}

########################
# Check if mastodon-sidekiq is not running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
mastodon_is_sidekiq_not_running() {
    ! mastodon_is_sidekiq_running
}

########################
# Stop mastodon-sidekiq
# Arguments:
#   None
# Returns:
#   None
#########################
mastodon_sidekiq_stop() {
    ! mastodon_is_sidekiq_running && return
    stop_service_using_pid "$MASTODON_SIDEKIQ_PID_FILE"
}
