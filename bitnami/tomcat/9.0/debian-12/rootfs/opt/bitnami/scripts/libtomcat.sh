#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami Tomcat library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libvalidations.sh

########################
# Validate settings in TOMCAT_* environment variables
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
tomcat_validate() {
    debug "Validating settings in TOMCAT_* env vars..."
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }
    check_yes_no_value() {
        if ! is_yes_no_value "${!1}" && ! is_true_false_value "${!1}" && ! is_1_0_value "${!1}"; then
            print_validation_error "The allowed values for ${1} are: yes no"
        fi
    }
    check_conflicting_ports() {
        local -r total="$#"
        for i in $(seq 1 "$((total - 1))"); do
            for j in $(seq "$((i + 1))" "$total"); do
                var_i="${!i}"
                var_j="${!j}"
                if [[ -n "${!var_i:-}" ]] && [[ -n "${!var_j:-}" ]] && [[ "${!var_i:-}" = "${!var_j:-}" ]]; then
                    print_validation_error "${var_i} and ${var_j} are bound to the same port"
                fi
            done
        done
    }
    check_allowed_port() {
        local validate_port_args="-unprivileged"

        if ! err=$(validate_port "${validate_port_args[@]}" "${!1}"); then
            print_validation_error "An invalid port was specified in the environment variable $1: $err"
        fi
    }

    check_yes_no_value TOMCAT_ALLOW_REMOTE_MANAGEMENT
    check_yes_no_value TOMCAT_ENABLE_AUTH
    check_yes_no_value TOMCAT_ENABLE_AJP

    check_allowed_port TOMCAT_HTTP_PORT_NUMBER
    check_allowed_port TOMCAT_AJP_PORT_NUMBER
    check_allowed_port TOMCAT_SHUTDOWN_PORT_NUMBER

    check_conflicting_ports TOMCAT_HTTP_PORT_NUMBER TOMCAT_AJP_PORT_NUMBER TOMCAT_SHUTDOWN_PORT_NUMBER

    # Validate credentials
    if is_boolean_yes "$TOMCAT_ENABLE_AUTH"; then
        if is_boolean_yes "${ALLOW_EMPTY_PASSWORD:-no}"; then
            warn "You set the environment variable ALLOW_EMPTY_PASSWORD=${ALLOW_EMPTY_PASSWORD}. For safety reasons, do not use this flag in a production environment."
        else
            is_empty_value "$TOMCAT_PASSWORD" && print_validation_error "The TOMCAT_PASSWORD environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow a blank password. This is only recommended for development environments."
        fi
    fi

    return "$error_code"
}

########################
# Ensure that a Tomcat user exists
# Globals:
#   TOMCAT_*
# Arguments:
#   $1 - Username
#   $2 - Password
# Returns:
#   None
#########################
tomcat_ensure_user_exists() {
    local username="${1:?username is missing}"
    local password="${2:-}"

    # This command will create a new user in tomcat-users.xml (inside <tomcat-users>) - How it works:
    # 0. Assign the XML namespace 'x' (required because it uses a non-standard namespace)
    # 1. Remove any existing <user> entry for $USERNAME
    # 2. Create a new subnode in <tomcat-users>
    # 3. Store that element in a variable so it can be accessed later
    # 4. Set the "username", "password" and "roles" attributes with their values
    # shellcheck disable=SC2016
    xmlstarlet ed -S --inplace -N x="http://tomcat.apache.org/xml" \
        -d '//x:user[@username="manager"]' \
        --subnode '//x:tomcat-users' --type elem --name 'user' \
        --var new_node '$prev' \
        --insert '$new_node' --type attr --name 'username' --value "$username" \
        --insert '$new_node' --type attr --name 'password' --value "$password" \
        --insert '$new_node' --type attr --name 'roles' --value "manager-gui,admin-gui" \
        "$TOMCAT_USERS_CONF_FILE"
}

########################
# Ensure that the Tomcat AJP connector is enabled
# Globals:
#   TOMCAT_*
# Arguments:
#   $1 - Tomcat AJP connector port number
# Returns:
#   None
#########################
tomcat_enable_ajp() {
    local ajp_port="${1:?missing ajp port}"
    # We want to locate the AJP connector right after the related comment, hence the substitution and not using xmlstarlet
    # Unfortunately the AJP connector is inside a multi-line comment, so the simplest approach is to add a new line in the proper location
    local ajp_protocol="AJP/1.3"
    local ajp_selector="//Connector[@protocol=\"${ajp_protocol}\"]"
    if is_empty_value "$(xmlstarlet sel --template --value-of "${ajp_selector}/@port" "$TOMCAT_CONF_FILE")"; then
        # Ensure that it is only added once
        local ajp_connector="<Connector protocol=\"${ajp_protocol}\" address=\"localhost\" secretRequired=\"false\" port=\"${ajp_port}\" redirectPort=\"8443\"/>"
        replace_in_file "$TOMCAT_CONF_FILE" "^(\s*)(<!-- Define an AJP .* -->)$" "\1\2\n\1${ajp_connector}"
    else
        # If it was already added, update the port number
        xmlstarlet ed -S --inplace --update "${ajp_selector}/@port" --value "$ajp_port" "$TOMCAT_CONF_FILE"
    fi
}

########################
# Enable a specific Tomcat application for public access
# Globals:
#   TOMCAT_*
# Arguments:
#   $1 - Tomcat application to enable
# Returns:
#   None
#########################
tomcat_enable_application() {
    local application="${1:?missing application}"
    # Access control is configured in the application's context.xml with a Valve element
    # context.xml docs: https://tomcat.apache.org/tomcat-9.0-doc/config/context.html
    # Valve docs for Access Control: https://tomcat.apache.org/tomcat-9.0-doc/config/valve.html#Access_Control
    [[ ! -f "${TOMCAT_WEBAPPS_DIR}/${application}/META-INF/context.xml" ]] && return
    xmlstarlet ed -S --inplace --update '//Valve/@allow' --value '\d+\.\d+\.\d+\.\d+' "${TOMCAT_WEBAPPS_DIR}/${application}/META-INF/context.xml"
}

########################
# Ensure Tomcat is initialized
# Globals:
#   TOMCAT_*
# Arguments:
#   None
# Returns:
#   None
#########################
tomcat_initialize() {
    if ! is_empty_value "$TOMCAT_EXTRA_JAVA_OPTS"; then
        cat >>"${TOMCAT_BIN_DIR}/setenv.sh" <<EOF

# Additional configuration
export JAVA_OPTS="\${JAVA_OPTS} ${TOMCAT_EXTRA_JAVA_OPTS}"
EOF
    fi

    # server.xml docs: https://tomcat.apache.org/tomcat-9.0-doc/config/server.html
    info "Configuring port numbers"
    xmlstarlet ed -S --inplace --update '//Server/@port' --value "$TOMCAT_SHUTDOWN_PORT_NUMBER" "$TOMCAT_CONF_FILE"
    xmlstarlet ed -S --inplace --update '//Connector[@protocol="HTTP/1.1"]/@port' --value "$TOMCAT_HTTP_PORT_NUMBER" "$TOMCAT_CONF_FILE"

    if is_boolean_yes "$TOMCAT_ENABLE_AJP"; then
        info "Enabling AJP"
        tomcat_enable_ajp "$TOMCAT_AJP_PORT_NUMBER"
    fi

    if is_boolean_yes "$TOMCAT_ENABLE_AUTH"; then
        info "Creating Tomcat user"
        tomcat_ensure_user_exists "$TOMCAT_USERNAME" "$TOMCAT_PASSWORD"
    fi

    # Fix to make upgrades from old images work
    # Before, we were persisting 'data' dir instead of 'webapps', causing errors when restoring persisted data
    if ! is_dir_empty "$TOMCAT_WEBAPPS_DIR" || ! is_dir_empty "${TOMCAT_VOLUME_DIR}/data"; then
        info "Persisted webapps detected"
        if [[ ! -e "$TOMCAT_WEBAPPS_DIR" && -e "${TOMCAT_VOLUME_DIR}/data" ]]; then
            warn "Detected legacy configuration directory path ${TOMCAT_VOLUME_DIR}/conf in volume"
            warn "Creating ${TOMCAT_BASE_DIR}/webapps symlink pointing to ${TOMCAT_VOLUME_DIR}/data"
            ln -sf "${TOMCAT_VOLUME_DIR}/data" "${TOMCAT_BASE_DIR}/webapps"
        fi
    else
        info "Ensuring Tomcat directories exist"
        ensure_dir_exists "$TOMCAT_WEBAPPS_DIR"
        # Use tomcat:root ownership for compatibility when running as a non-root user
        am_i_root && configure_permissions_ownership "$TOMCAT_WEBAPPS_DIR" -d "775" -f "664" -u "$TOMCAT_DAEMON_USER" -g "root"

        if is_boolean_yes "$TOMCAT_INSTALL_DEFAULT_WEBAPPS"; then
            info "Deploying Tomcat from scratch"
            cp -rp "$TOMCAT_BASE_DIR"/webapps_default/* "$TOMCAT_WEBAPPS_DIR"

            # These applications have been enabled for historical reasons, and do not pose any security threat
            tomcat_enable_application examples
            tomcat_enable_application docs
            if is_boolean_yes "$TOMCAT_ALLOW_REMOTE_MANAGEMENT"; then
                # These applications should not be enabled by default, for security reasons
                info "Enabling remote connections for manager and host-manager applications"
                tomcat_enable_application manager
                tomcat_enable_application host-manager
            fi
        else
            info "Skipping deployment of default webapps"
        fi

    fi
}

########################
# Start Tomcat in background
# Globals:
#   TOMCAT_*
# Arguments:
#   None
# Returns:
#   None
#########################
tomcat_start_bg() {
    is_tomcat_running && return

    info "Starting Tomcat in background"
    local start_error=0
    if am_i_root; then
        debug_execute run_as_user "$TOMCAT_DAEMON_USER" "${TOMCAT_BIN_DIR}/startup.sh" || start_error="$?"
    else
        debug_execute "${TOMCAT_BIN_DIR}/startup.sh" || start_error="$?"
    fi

    if [[ "$start_error" -ne 0 ]]; then
        error "Tomcat failed to start with exit code ${start_error}"
        return "$start_error"
    fi
    wait_for_log_entry "Catalina.start Server startup" "$TOMCAT_LOG_FILE" "$TOMCAT_START_RETRIES" 10
}

########################
# Stop Tomcat daemon
# Globals:
#   TOMCAT_*
# Arguments:
#   None
# Returns:
#   None
#########################
tomcat_stop() {
    is_tomcat_not_running && return

    info "Stopping Tomcat"
    local stop_error=0
    # 'shutdown.sh stop n -force' - Stop Catalina, wait up to n seconds and then use kill -KILL if still running
    # The default timeout is 5 seconds, and some apps require even more, so give double the amount of time
    # In addition, force the shutdown if it did not stop in time to ensure that the shutdown (almost) never fails
    local tomcat_shutdown_timeout=10
    if am_i_root; then
        debug_execute run_as_user "$TOMCAT_DAEMON_USER" "${TOMCAT_BIN_DIR}/shutdown.sh" "$tomcat_shutdown_timeout" -force || stop_error="$?"
    else
        debug_execute "${TOMCAT_BIN_DIR}/shutdown.sh" "$tomcat_shutdown_timeout" -force || stop_error="$?"
    fi

    if [[ "$stop_error" -ne 0 ]]; then
        error "Tomcat failed to stop with exit code ${stop_error}"
        return "$stop_error"
    fi

    retry_while "is_tomcat_not_running"
}

########################
# Check if Tomcat is running
# Globals:
#   TOMCAT_*
# Arguments:
#   None
# Returns:
#   None
#########################
is_tomcat_running() {
    local pid
    pid="$(get_pid_from_file "${TOMCAT_PID_FILE}")"
    if [[ -n "${pid}" ]]; then
        is_service_running "${pid}"
    else
        false
    fi
}

########################
# Check if Tomcat is not running
# Globals:
#   TOMCAT_*
# Arguments:
#   None
# Returns:
#   None
#########################
is_tomcat_not_running() {
    ! is_tomcat_running
}
