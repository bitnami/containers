#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami Jenkins library

# shellcheck disable=SC1091
# shellcheck disable=SC1090

# Load generic libraries
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libpersistence.sh

########################
# Check if Jenkins is running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_jenkins_running() {
    local pid
    pgrep -f "^java.*-jar ${JENKINS_BASE_DIR}/jenkins.war" >"$JENKINS_PID_FILE"
    pid="$(get_pid_from_file "$JENKINS_PID_FILE")"
    if [[ -n "$pid" ]]; then
        is_service_running "$pid"
    else
        false
    fi
}

########################
# Check if Jenkins is not running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_jenkins_not_running() {
    ! is_jenkins_running
}

########################
# Stop Jenkins
# Arguments:
#   None
# Returns:
#   None
#########################
jenkins_stop() {
    is_jenkins_not_running && return
    info "Stopping Jenkins"
    stop_service_using_pid "$JENKINS_PID_FILE" 15
}

########################
# Start Jenkins in background
# Arguments:
#   None
# Returns:
#   None
#########################
jenkins_start_bg() {
    local -a args
    if [[ -n "${JAVA_OPTS:-}" ]]; then
        read -r -a java_opts <<<"$JAVA_OPTS"
        args+=("${java_opts[@]}")
    fi
    args+=("-Duser.home=${JENKINS_HOME}" "-jar" "${JENKINS_BASE_DIR}/jenkins.war" "--httpListenAddress=127.0.0.1")

    is_jenkins_running && return
    info "Starting Jenkins in background"
    if am_i_root; then
        touch "$JENKINS_LOG_FILE"
        configure_permissions_ownership "$JENKINS_LOG_FILE" -u "$JENKINS_DAEMON_USER" -g "$JENKINS_DAEMON_GROUP"
        run_as_user "$JENKINS_DAEMON_USER" java "${args[@]}" >>"$JENKINS_LOG_FILE" 2>&1 &
    else
        java "${args[@]}" >>"$JENKINS_LOG_FILE" 2>&1 &
    fi
    wait_for_log_entry "Jenkins is fully up and running" "$JENKINS_LOG_FILE" 36 10
}

########################
# Invoke the Jenkins bundled client
# Globals:
#   JENKINS_*
# Arguments:
#   $@ - Command to execute
# Returns:
#   None
#########################
jenkins_cli_execute() {
    local -r cli_jar="$(find "${JENKINS_HOME}/war/WEB-INF/lib" -name "cli-*.jar")"
    local -r http_port="${JENKINS_HTTP_PORT_NUMBER:-"$JENKINS_DEFAULT_HTTP_PORT_NUMBER"}"
    local -r jenkins_url="http://127.0.0.1:${http_port}"
    local -r args=("-jar" "${cli_jar}" "-s" "$jenkins_url" "-auth" "${JENKINS_USERNAME}:${JENKINS_PASSWORD}" "$@")

    debug "Executing command: java ${args[*]}"
    if am_i_root; then
        debug_execute run_as_user "$JENKINS_DAEMON_USER" java "${args[@]}"
    else
        debug_execute java "${args[@]}"
    fi
}

########################
# Validate settings in JENKINS_* env vars
# Globals:
#   JENKINS_*
# Arguments:
#   None
# Returns:
#   0 if the validation succeeded, 1 otherwise
#########################
jenkins_validate() {
    debug "Validating settings in JENKINS_* environment variables..."
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }
    check_conflicting_ports() {
        local -r total="$#"
        for i in $(seq 1 "$((total - 1))"); do
            for j in $(seq "$((i + 1))" "$total"); do
                var_i="${!i}"
                var_j="${!j}"
                if [[ -n "${!var_i:-}" ]] && [[ -n "${!var_j:-}" ]] && [[ "${!var_i:-}" -eq "${!var_j:-}" ]]; then
                    print_validation_error "${var_i} and ${var_j} are bound to the same port"
                fi
            done
        done
    }
    check_resolved_hostname() {
        if ! is_hostname_resolved "$1"; then
            warn "Hostname ${1} could not be resolved, this could lead to connection issues"
        fi
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
    check_valid_port() {
        local port_var="${1:?missing port variable}"
        local err
        if ! err="$(validate_port "${!port_var}")"; then
            print_validation_error "An invalid port was specified in the environment variable ${port_var}: ${err}."
        fi
    }

    check_yes_no_value "JENKINS_SKIP_BOOTSTRAP"

    # Validate ports
    ! is_empty_value "$JENKINS_HTTP_PORT_NUMBER" && check_valid_port "JENKINS_HTTP_PORT_NUMBER"
    ! is_empty_value "$JENKINS_HTTPS_PORT_NUMBER" && check_valid_port "JENKINS_HTTPS_PORT_NUMBER"
    ! is_empty_value "$JENKINS_JNLP_PORT_NUMBER" && check_valid_port "JENKINS_JNLP_PORT_NUMBER"
    check_conflicting_ports "JENKINS_HTTP_PORT_NUMBER" "JENKINS_HTTPS_PORT_NUMBER" "JENKINS_JNLP_PORT_NUMBER"

    # Validate host
    check_yes_no_value "JENKINS_FORCE_HTTPS"
    if ! is_empty_value "$JENKINS_HOST"; then
        check_resolved_hostname "$JENKINS_HOST"
        [[ "$JENKINS_HOST" =~ localhost ]] && print_validation_error "JENKINS_HOST must be set to an actual hostname, localhost values are not allowed."
        validate_ipv4 "$JENKINS_HOST" && print_validation_error "JENKINS_HOST must be set to an actual hostname, IP addresses are not allowed."
    fi

    # Validate credentials
    check_empty_value "JENKINS_PASSWORD"
    if [[ "${#JENKINS_PASSWORD}" -lt 6 ]]; then
        print_validation_error "The admin password must be at least 6 characters long. Set the environment variable JENKINS_PASSWORD with a longer value"
    fi

    # Validate swarm configuration
    check_yes_no_value "JENKINS_ENABLE_SWARM"
    is_boolean_yes "$JENKINS_ENABLE_SWARM" && check_empty_value "JENKINS_SWARM_PASSWORD"

    return "$error_code"
}

########################
# Ensure Jenkins is initialized
# Globals:
#   JENKINS_*
# Arguments:
#   None
# Returns:
#   None
#########################
jenkins_initialize() {
    local -r init_jenkins_groovy_tpl="${JENKINS_TEMPLATES_DIR}/init-jenkins$(is_boolean_yes "$JENKINS_ENABLE_SWARM" && echo "-swarm").groovy.tpl"

    if am_i_root; then
        # Ensure Jenkins daemon user has proper permissions on Jenkins home directory
        info "Configuring file permissions for Jenkins"
        is_mounted_dir_empty "$JENKINS_HOME" && configure_permissions_ownership "$JENKINS_HOME" -d "755" -f "644" -u "$JENKINS_DAEMON_USER" -g "$JENKINS_DAEMON_GROUP"
    fi

    if is_mounted_dir_empty "$JENKINS_HOME"; then
        # Copy files from mounted directory, except for plugins
        if ! is_mounted_dir_empty "$JENKINS_MOUNTED_CONTENT_DIR"; then
            info "Moving custom mounted files to Jenkins home directory"
            echo "--- Copying files at $(date)" >>"${JENKINS_LOGS_DIR}/copy_reference_file.log"
            find "$JENKINS_MOUNTED_CONTENT_DIR" \( -type f -o -type l \) -and -not -path "$JENKINS_MOUNTED_CONTENT_DIR/plugins/*" | xargs -I % -P10 bash -c '. /opt/bitnami/scripts/libjenkins.sh && jenkins_add_custom_file %'
        fi
        # Install Jenkins plugins defined in JENKINS_PLUGINS
        jenkins_install_plugins
        # Initialize Jenkins
        if ! is_boolean_yes "$JENKINS_SKIP_BOOTSTRAP"; then
            # Create init groovy script and initialize Jenkins
            info "Creating init script"
            ensure_dir_exists "${JENKINS_HOME}/init.groovy.d"
            jnlp_port="${JENKINS_JNLP_PORT_NUMBER:-"$JENKINS_DEFAULT_JNLP_PORT_NUMBER"}" render-template "$init_jenkins_groovy_tpl" >"${JENKINS_HOME}/init.groovy.d/init-jenkins.groovy"
            jenkins_start_bg
            # Configure host
            ! is_empty_value "$JENKINS_HOST" && jenkins_configure_host "$JENKINS_HOST"
            # Rotate the logs in Jenkins to clean the Jenkins warnings before actually configuring the app
            jenkins_stop
            # Generate jenkins.jks
            "${JAVA_HOME}/bin/keytool" -genkey -keyalg RSA -keypass "${JENKINS_KEYSTORE_PASSWORD}" -storepass "${JENKINS_KEYSTORE_PASSWORD}" -keystore "${JENKINS_CERTS_DIR}/jenkins.jks" -dname "CN=${JENKINS_HOST}, O=${JENKINS_HOST}" -alias "${JENKINS_HOST}"
            mv "$JENKINS_LOG_FILE" "${JENKINS_LOGS_DIR}/jenkins.firstboot.log"
            rm "${JENKINS_HOME}/init.groovy.d/init-jenkins.groovy"
        else
            info "Skipping Bitnami initialization"
        fi
    else
        info "Detected data from previous deployments"
        jenkins_override_home_paths
        # If JENKINS_OVERRIDE_PLUGINS is enabled, remove plugins from the volume if any and trigger new installation
        if is_boolean_yes "$JENKINS_OVERRIDE_PLUGINS"; then
            [[ -d "${JENKINS_HOME}/plugins" ]] && rm -rf "${JENKINS_HOME}/plugins"
            jenkins_install_plugins
        fi
    fi

    true
}

#########################
# Configure Jenkins host
# Globals:
#   JENKINS_*
# Arguments:
#   $1 - hostname
# Returns:
#   None
#########################
jenkins_configure_host() {
    local -r hostname="${1:?missing hostname}"
    local -r local_port="${JENKINS_HTTP_PORT_NUMBER:-"$JENKINS_DEFAULT_HTTP_PORT_NUMBER"}"
    local -r configure_host_groovy_tpl="${JENKINS_TEMPLATES_DIR}/configure-host.groovy.tpl"
    local -r retries="30"
    local -r interval_time="10"
    local base_url
    local scheme

    is_boolean_yes "$JENKINS_FORCE_HTTPS" && scheme="https" || scheme="http"
    base_url="${scheme}://${hostname}"
    if is_boolean_yes "$JENKINS_FORCE_HTTPS"; then
        [[ "$JENKINS_EXTERNAL_HTTPS_PORT_NUMBER" != "443" ]] && base_url+=":${JENKINS_EXTERNAL_HTTPS_PORT_NUMBER}"
    else
        [[ "$JENKINS_EXTERNAL_HTTP_PORT_NUMBER" != "80" ]] && base_url+=":${JENKINS_EXTERNAL_HTTP_PORT_NUMBER}"
    fi
    info "Configuring Jenkins URL to ${base_url}"

    if ! retry_while "debug_execute curl -sSf http://127.0.0.1:${local_port}/login" "$retries" "$interval_time"; then
        error "Jenkins is not accessible"
        return 1
    else
        configure_host_tmp=$(mktemp)
        url="${base_url}" render-template "$configure_host_groovy_tpl" >"$configure_host_tmp"
        jenkins_cli_execute "groovy" "=" <"$configure_host_tmp"
        rm "$configure_host_tmp"
    fi
}

#########################
# Copy files from JENKINS_MOUNTED_CONTENT_DIR into JENKINS_HOME
# Based on https://github.com/jenkinsci/docker/blob/8e33e547a43d248bbb3cf403fe908dbf11d4ae45/jenkins-support
# Globals:
#   JENKINS_*
# Arguments:
#   $1 - filepath
# Returns:
#   None
#########################
jenkins_add_custom_file() {
    local -r filepath="${1:?filepath is required}"
    local -r filename="$(basename "$filepath")"
    local -r relpath="${filepath#"${JENKINS_MOUNTED_CONTENT_DIR}/"}"
    local action
    local reason

    get_plugin_version() {
        local -r pluginpath="${1:?pluginpath is required}"
        local version
        # Use unzip -p, which is mean to extract files to pipe
        # https://linux.die.net/man/1/unzip
        version=$(unzip -p "$pluginpath" META-INF/MANIFEST.MF | grep "^Plugin-Version: " | sed -e 's#^Plugin-Version: ##')
        version=${version%%[[:space:]]}
        echo "$version"
    }

    if [[ $relpath = plugins/*.jpi ]]; then
        debug "Adding custom plugin ${filename}"
        if [[ -f "${JENKINS_HOME}/${relpath}" ]]; then
            debug "Plugin ${filename} already exists"
            plugin_version=$(get_plugin_version "${JENKINS_HOME}/${relpath}")
            current_version=$(get_plugin_version "$filepath")
            if [[ "$(get_sematic_version "$plugin_version" 1)" -gt "$(get_sematic_version "$current_version" 1)" ]]; then
                action="UPGRADED"
                reason="Installed version ($current_version) is older than installed version ($plugin_version)"
                cp -pr "$(realpath "${filepath}")" "${JENKINS_HOME}/${relpath}"
            else
                action="SKIPPED"
                reason="Installed version ($current_version) is lower or equal than installed version ($plugin_version)"
            fi
        else
            action="INSTALLED"
            mkdir -p "${JENKINS_HOME}/$(dirname "$relpath")"
            cp -pr "$(realpath "${filepath}")" "${JENKINS_HOME}/${relpath}"
        fi
    else
        if [[ ! -f "${JENKINS_HOME}/${relpath}" ]]; then
            action="INSTALLED"
            mkdir -p "${JENKINS_HOME}/$(dirname "$relpath")"
            cp -pr "$(realpath "${filepath}")" "${JENKINS_HOME}/${relpath}"
        else
            action="SKIPPED"
        fi
    fi
    if [[ -z "$reason" ]]; then
        echo "$action $relpath" >>"${JENKINS_LOGS_DIR}/copy_reference_file.log"
    else
        echo "$action $relpath : $reason" >>"${JENKINS_LOGS_DIR}/copy_reference_file.log"
    fi
}

########################
# Run custom initialization scripts
# Globals:
#   JENKINS_*
# Arguments:
#   None
# Returns:
#   None
#########################
jenkins_custom_init_scripts() {
    if [[ -n $(find /docker-entrypoint-initdb.d/ -type f -regex ".*\.\(sh\|groovy\)") ]] && [[ ! -f "${JENKINS_VOLUME_DIR}/.user_scripts_initialized" ]]; then
        info "Loading user's custom files from /docker-entrypoint-initdb.d"
        for f in /docker-entrypoint-initdb.d/*; do
            debug "Executing $f"
            case "$f" in
            *.sh)
                if [[ -x "$f" ]]; then
                    if ! "$f"; then
                        error "Failed executing $f"
                        return 1
                    fi
                else
                    warn "Sourcing $f as it is not executable by the current user, any error may cause initialization to fail"
                    . "$f"
                fi
                ;;
            *.groovy)
                cp "$f" "${JENKINS_HOME}/init.groovy.d"
                jenkins_start_bg
                jenkins_stop
                # Rotate the logs in Jenkins
                mv "$JENKINS_LOG_FILE" "${JENKINS_LOGS_DIR}/jenkins.initscripts.log"
                rm "${JENKINS_HOME}/init.groovy.d/$(basename "$f")"
                ;;
            *)
                warn "Skipping $f, supported formats are: .sh .groovy"
                ;;
            esac
        done
        touch "${JENKINS_VOLUME_DIR}/.user_scripts_initialized"
    fi
}

########################
# Installs/upgrades plugins defined
# Globals:
#   JENKINS_*
# Arguments:
#   None
# Returns:
#   None
#########################
jenkins_install_plugins() {
    read -r -a plugins_list <<<"$(tr ',;' ' ' <<<"$JENKINS_PLUGINS")"
    local -r plugin_manager_jar="${JENKINS_BASE_DIR}/jenkins-plugin-manager.jar"
    local -r jenkins_war="${JENKINS_BASE_DIR}/jenkins.war"
    local -r plugins_dir="${JENKINS_HOME}/plugins"
    local -r tmp_plugins_file="${JENKINS_TMP_DIR}/plugins.txt"
    local -a args=("-jar" "${plugin_manager_jar}" "--war" "$jenkins_war" "--plugin-file" "$tmp_plugins_file" "-d" "$plugins_dir" "--verbose")

    info "Installing Jenkins plugins"
    # Copy built-in plugins included in the image
    if ! is_dir_empty "${JENKINS_BASE_DIR}/plugins" && ! is_boolean_yes "$JENKINS_SKIP_IMAGE_PLUGINS"; then
        debug "Moving image plugins to $JENKINS_HOME"
        ensure_dir_exists "${JENKINS_HOME}/plugins"
        mv "${JENKINS_BASE_DIR}/plugins"/* "${JENKINS_HOME}/plugins"
        am_i_root && configure_permissions_ownership "${JENKINS_HOME}/plugins" -d "755" -f "644" -u "$JENKINS_DAEMON_USER" -g "$JENKINS_DAEMON_GROUP"
    else
        debug "${JENKINS_BASE_DIR}/plugins is empty"
    fi

    # Copy plugins from mounted directory
    if ! is_mounted_dir_empty "$JENKINS_MOUNTED_CONTENT_DIR/plugins"; then
        debug "Moving custom mounted plugins to Jenkins home directory"
        echo "--- Copying files at $(date)" >>"${JENKINS_LOGS_DIR}/copy_reference_file.log"
        find "$JENKINS_MOUNTED_CONTENT_DIR/plugins" \( -type f -o -type l \) | xargs -I % -P10 bash -c '. /opt/bitnami/scripts/libjenkins.sh && jenkins_add_custom_file %'
    else
        debug "${JENKINS_MOUNTED_CONTENT_DIR}/plugins is empty"
    fi

    # Install plugins from JENKINS_PLUGINS environment variable
    if [[ "${#plugins_list[@]}" -gt 0 ]]; then
        # Additional parameters
        args+=("--latest" "$(is_boolean_yes "$JENKINS_PLUGINS_LATEST" && echo "true" || echo "false")")
        if is_boolean_yes "$JENKINS_PLUGINS_LATEST_SPECIFIED"; then
            args+=("--latest-specified")
        fi
        # Install plugins
        debug "Installing plugins: ${plugins_list[*]}"
        for i in "${plugins_list[@]}"; do
            echo "$i" >> "$tmp_plugins_file"
        done
        if am_i_root; then
            debug_execute run_as_user "$JENKINS_DAEMON_USER" java "${args[@]}"
        else
            debug_execute java "${args[@]}"
        fi
        rm "$tmp_plugins_file"
    fi
}

########################
# Remove directories and files from Jenkins home and/or copy them from the mounted content dir
# Globals:
#   JENKINS_*
# Arguments:
#   None
# Returns:
#   None
#########################
jenkins_override_home_paths() {
    read -r -a paths_list <<<"$(tr ',;' ' ' <<<"$JENKINS_OVERRIDE_PATHS")"
     # Skip if JENKINS_OVERRIDE_PATHS is empty
    [[ "${#paths_list[@]}" -gt 0 ]] || return 0

    info "The following relative paths will be removed from Jenkins home directory: ${paths_list[*]}"
    for path in "${paths_list[@]}"; do
        # Ensure no leading slash
        relpath=${path#/}
        # Remove file from Jenkins home
        if [[ -d "${JENKINS_HOME}/${relpath}" ]]; then
            rm -rf "${JENKINS_HOME:?}/${relpath}"
        elif [[ -f "${JENKINS_HOME}/${relpath}" ]]; then
            rm "${JENKINS_HOME}/${relpath}"
        fi
        # Mount relative path from mounted content dir
        if ! is_mounted_dir_empty "$JENKINS_MOUNTED_CONTENT_DIR/${relpath}"; then
            debug "Copying mounted directory ${relpath} to Jenkins home directory"
            find "$JENKINS_MOUNTED_CONTENT_DIR/${relpath}" \( -type f -o -type l \) | xargs -I % -P10 bash -c '. /opt/bitnami/scripts/libjenkins.sh && jenkins_add_custom_file %'
        elif [[ -f "$JENKINS_MOUNTED_CONTENT_DIR/${relpath}" ]]; then
            debug "Copying mounted file ${relpath} to Jenkins home directory"
            jenkins_add_custom_file "$JENKINS_MOUNTED_CONTENT_DIR/${relpath}"
        fi
    done
}
