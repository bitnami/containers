#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami Kong library

# shellcheck disable=SC1090,SC1091

# Load generic libraries
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libversion.sh

########################
# Validate settings in KONG_* environment variables
# Globals:
#   KONG_*
# Arguments:
#   None
# Returns:
#   None
#########################
kong_validate() {
    info "Validating settings in KONG_* env vars"
    local error_code=0

    # Auxiliary functions

    print_validation_error() {
        error "$1"
        error_code="1"
    }

    check_yes_no_value() {
        if ! is_yes_no_value "${!1}"; then
            print_validation_error "The allowed values for ${1} are [yes, no]"
        fi
    }

    check_password_file() {
        if [[ -n "${!1:-}" ]] && ! [[ -f "${!1:-}" ]]; then
            print_validation_error "The variable ${1} is defined but the file ${!1} is not accessible or does not exist"
        fi
    }

    check_resolved_hostname() {
        if ! is_hostname_resolved "$1"; then
            warn "Hostname ${1} could not be resolved, this could lead to connection issues"
        fi
    }

    check_allowed_port() {
        local validate_port_args=()
        ! am_i_root && validate_port_args+=("-unprivileged")
        if ! err="$(validate_port "${validate_port_args[@]}" "${!1}")"; then
            print_validation_error "An invalid port was specified in the environment variable ${1}: ${err}"
        fi
    }

    check_conflicting_ports() {
        local -r total="$#"
        for i in $(seq 1 "$((total - 1))"); do
            for j in $(seq "$((i + 1))" "$total"); do
                if (("${!i}" == "${!j}")); then
                    print_validation_error "${!i} and ${!j} are bound to the same port"
                fi
            done
        done
    }

    check_yes_no_value KONG_MIGRATE

    # Validate some of the supported environment variables used by Kong

    # Database setting validations
    if [[ "${KONG_DATABASE:-postgres}" = "postgres" ]]; then
        # PostgreSQL is the default database type
        check_password_file KONG_POSTGRESQL_PASSWORD_FILE
        [[ -n "${KONG_PG_HOST:-}" ]] && check_resolved_hostname "${KONG_PG_HOST:-}"
    elif [[ "${KONG_DATABASE:-}" = "off" ]]; then
        warn "KONG_DATABASE is set to 'off', Kong will run but data will not be persisted"
    else
        print_validation_error "Wrong value '${KONG_DATABASE}' passed to KONG_DATABASE. Valid values: 'off', 'postgres'"
    fi

    # Listen addresses and port validations
    used_ports=()
    if is_boolean_yes "$KONG_PROXY_LISTEN_OVERRIDE"; then
        warn "KONG_PROXY_LISTEN was set, it will not be validated and the environment variables KONG_PROXY_LISTEN_ADDRESS, KONG_PROXY_HTTP_PORT_NUMBER and KONG_PROXY_HTTPS_PORT_NUMBER will be ignored"
    else
        used_ports+=(KONG_PROXY_HTTP_PORT_NUMBER KONG_PROXY_HTTPS_PORT_NUMBER)
        if [[ "$KONG_PROXY_LISTEN_ADDRESS" != "0.0.0.0" && "$KONG_PROXY_LISTEN_ADDRESS" != "127.0.0.1" ]]; then
            warn "Kong Proxy is set to listen at ${KONG_PROXY_LISTEN_ADDRESS} instead of 0.0.0.0 or 127.0.0.1, this could make Kong inaccessible"
        fi
    fi
    if is_boolean_yes "$KONG_ADMIN_LISTEN_OVERRIDE"; then
        warn "KONG_ADMIN_LISTEN was set, it will not be validated and the environment variables KONG_ADMIN_LISTEN_ADDRESS, KONG_ADMIN_HTTP_PORT_NUMBER and KONG_ADMIN_HTTPS_PORT_NUMBER will be ignored"
    else
        used_ports+=(KONG_ADMIN_HTTP_PORT_NUMBER KONG_ADMIN_HTTPS_PORT_NUMBER)
        if [[ "$KONG_ADMIN_LISTEN_ADDRESS" != "127.0.0.1" ]]; then
            warn "Kong Admin is set to listen at ${KONG_ADMIN_LISTEN_ADDRESS} instead of 127.0.0.1, opening it to the outside could make it insecure"
        fi
    fi
    for port in "${used_ports[@]}"; do
        check_allowed_port "${port}"
    done
    if [[ "${#used_ports[@]}" -ne 0 ]]; then
        check_conflicting_ports "${used_ports[@]}"
    fi

    # Quit if any failures occurred
    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}

########################
# Ensure Kong is initialized
# Globals:
#   KONG_*
# Arguments:
#   None
# Returns:
#   None
#########################
kong_initialize() {
    info "Initializing Kong"

    info "Waiting for database connection to succeed"
    kong_configure_from_environment_variables

    debug "Running kong prepare"
    kong prepare -c "$KONG_CONF_FILE" -p "$KONG_PREFIX"

    while ! kong_migrations_list_output="$(kong migrations list -c "$KONG_CONF_FILE" -p "$KONG_PREFIX" 2>&1)"; do
        if is_boolean_yes "$KONG_MIGRATE" && [[ "$kong_migrations_list_output" =~ "Database needs bootstrapping"* ]] || [[ "$kong_migrations_list_output" =~ "migrations available" ]]; then
            break
        fi
        debug "$kong_migrations_list_output"
        debug "Database is still not ready, will retry"
        sleep 1
    done

    if is_boolean_yes "$KONG_MIGRATE"; then
        info "Migrating database"
        kong migrations bootstrap -c "$KONG_CONF_FILE" -p "$KONG_PREFIX"
        while ! kong migrations list -c "$KONG_CONF_FILE" -p "$KONG_PREFIX"; do
            debug "Error during the initial bootstrap for the database, will retry"
            kong migrations up -c "$KONG_CONF_FILE" -p "$KONG_PREFIX"
            kong migrations finish -c "$KONG_CONF_FILE" -p "$KONG_PREFIX"
        done
    fi

    # Fix server ownership because of running the kong migrate commands as root
    am_i_root && chown -R "$KONG_DAEMON_USER":"$KONG_DAEMON_GROUP" "$KONG_SERVER_DIR" "$KONG_CONF_DIR"

    # Set return code to avoid issues in previous commands
    true
}

########################
# Set a configuration to Kong's configuration file
# Globals:
#   KONG_CONF_FILE
# Arguments:
#   $1 - key
#   $2 - value
# Returns:
#   None
#########################
kong_conf_set() {
    local -r key="${1:?missing key}"
    local -r value="${2:-}"

    # Check if the value was commented or set before
    if grep -q "^#*${key}\s*=[^#]*" "$KONG_CONF_FILE"; then
        debug "Updating entry for property '${key}' in configuration file"
        # Update the existing key (leave trailing space for comments)
        sed -ri "s|^#*(${key}\s*=)[^#]*|\1 ${value} |" "$KONG_CONF_FILE"
    else
        debug "Adding new entry for property '${key}' in configuration file"
        # Add a new key
        printf '%s = %s\n' "$key" "$value" >>"$KONG_CONF_FILE"
    fi
}

########################
# Uncomment non-empty entries in Kong configuration
# Globals:
#   KONG_CONF_FILE
# Arguments:
#   None
# Returns:
#   None
#########################
kong_configure_non_empty_values() {
    # Uncomment all non-empty keys in the main Kong configuration file
    sed -ri 's/^#+([a-z_ ]+)=(\s*[^# ]+)/\1=\2 /' "$KONG_CONF_FILE"

    # Comment read-only postgres connection parameters again, as default values fail to work properly
    sed -ri 's/(^pg_ro_.+)=(\s*[^# ]+)/#\1=\2 /' "$KONG_CONF_FILE"
}

########################
# Configure Kong configuration files from environment variables
# Globals:
#   KONG_*
# Arguments:
#   None
# Returns:
#   None
#########################
kong_configure_from_environment_variables() {
    # Map environment variables to config properties
    for var in "${!KONG_CFG_@}"; do
        key="$(echo "$var" | sed -e 's/^KONG_CFG_//g' | tr '[:upper:]' '[:lower:]')"

        value="${!var}"
        kong_conf_set "$key" "$value"
    done
}

########################
# Return true if kong is running
# Globals:
#   KONG_*
# Arguments:
#   None
# Returns:
#   None
#########################
is_kong_running() {
    if kong health 2>&1 | grep -E "Kong is healthy" >/dev/null; then
        true
    else
        false
    fi
}

########################
# Return true if kong is not running
# Globals:
#   KONG_*
# Arguments:
#   None
# Returns:
#   None
#########################
is_kong_not_running() {
    ! is_kong_running
}

########################
# Stop any background kong instance
# Globals:
#   KONG_*
# Arguments:
#   None
# Returns:
#   None
#########################
kong_stop() {
    local -r retries=5
    local -r sleep_time=5
    kong stop -p "$KONG_PREFIX"
    if ! retry_while is_kong_not_running "$retries" "$sleep_time"; then
        error "Kong failed to shut down"
        exit 1
    fi
}

########################
# Start kong in background
# Globals:
#   KONG_*
# Arguments:
#   None
# Returns:
#   None
#########################
kong_start_bg() {
    local -r retries=5
    local -r sleep_time=5
    info "Starting kong in background"
    kong start -c "$KONG_CONF_FILE" -p "$KONG_PREFIX" &
    if retry_while is_kong_running "$retries" "$sleep_time"; then
        info "Kong started successfully in background"
    fi
}

########################
# Run custom initialization scripts
# Globals:
#   KONG_*
# Arguments:
#   None
# Returns:
#   None
#########################
kong_custom_init_scripts() {
    if [[ -n $(find "${KONG_INITSCRIPTS_DIR}/" -type f -regex ".*\.sh") ]]; then
        info "Loading user's custom files from $KONG_INITSCRIPTS_DIR ..."
        local -r tmp_file="/tmp/filelist"
        kong_start_bg
        find "${KONG_INITSCRIPTS_DIR}/" -type f -regex ".*\.sh" | sort >"$tmp_file"
        while read -r f; do
            case "$f" in
            *.sh)
                if [[ -x "$f" ]]; then
                    debug "Executing $f"
                    "$f"
                else
                    debug "Sourcing $f"
                    . "$f"
                fi
                ;;
            *)
                debug "Ignoring $f"
                ;;
            esac
        done <$tmp_file
        kong_stop
        rm -f "$tmp_file"
    else
        info "No custom scripts in $KONG_INITSCRIPTS_DIR"
    fi
}
########################
# Find the path to the opentelemetry include files
# Globals:
#   KONG_*
# Arguments:
#   None
# Returns:
#   Path to opentelemetry include dir
#########################
find_opentelemetry_source() {
    local path
    path="$(find "$KONG_BASE_DIR" -name "opentelemetry" -print | grep "include" | grep "luajit")"
    echo "$path"
}

########################
# Installs opentelemetry plugin
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#########################
install_opentelemetry() {
    local -r source_dir="$(find_opentelemetry_source)"
    local -r destination_dir="/usr/local/kong/include"
    mkdir -p "$destination_dir"
    ln -sf "$source_dir" "${destination_dir}/opentelemetry"
}

########################
# Configure LUA_PATH and LUA_CPATH in the required files
# Globals:
#   None
# Arguments:
#   List of files to include the configuration
# Returns:
#   None
#########################
configure_lua_paths() {
    local -a dest_files=("${@}")
    local -r lua_paths_file="/tmp/lua-paths.sh"
    # Skip the PATH environment variable. We are already setting it.
    "${KONG_BASE_DIR}/openresty/bin/luarocks" path > "$lua_paths_file"
    remove_in_file "$lua_paths_file" "^export\s+PATH=.*$"
    for dest_file in "${dest_files[@]}"; do
        echo "# 'luarocks path' configuration" >> "$dest_file"
        cat "$lua_paths_file" >> "$dest_file"
    done
    rm --force "$lua_paths_file"
}
