#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami Odoo library

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
# Validate settings in ODOO_* env vars
# Globals:
#   ODOO_*
# Arguments:
#   None
# Returns:
#   0 if the validation succeeded, 1 otherwise
#########################
odoo_validate() {
    debug "Validating settings in ODOO_* environment variables..."
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
    check_yes_no_value "ODOO_SKIP_BOOTSTRAP"
    check_yes_no_value "ODOO_SKIP_MODULES_UPDATE"
    check_yes_no_value "ODOO_LOAD_DEMO_DATA"
    check_yes_no_value "ODOO_LIST_DB"
    check_valid_port "ODOO_PORT_NUMBER"
    check_valid_port "ODOO_LONGPOLLING_PORT_NUMBER"
    ! is_empty_value "$ODOO_DATABASE_HOST" && check_resolved_hostname "$ODOO_DATABASE_HOST"
    ! is_empty_value "$ODOO_DATABASE_PORT_NUMBER" && check_valid_port "ODOO_DATABASE_PORT_NUMBER"
    [[ -n "${WITHOUT_DEMO:-}" ]] && warn "The WITHOUT_DEMO environment variable has been deprecated in favor of ODOO_LOAD_DEMO_DATA=yes. Support for it may be removed in a future release."

    # Validate credentials
    if is_boolean_yes "${ALLOW_EMPTY_PASSWORD:-}"; then
        warn "You set the environment variable ALLOW_EMPTY_PASSWORD=${ALLOW_EMPTY_PASSWORD:-}. For safety reasons, do not use this flag in a production environment."
    else
        for empty_env_var in "ODOO_DATABASE_PASSWORD" "ODOO_PASSWORD"; do
            is_empty_value "${!empty_env_var}" && print_validation_error "The ${empty_env_var} environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow a blank password. This is only recommended for development environments."
        done
    fi

    # Validate SMTP credentials
    if ! is_empty_value "$ODOO_SMTP_HOST"; then
        for empty_env_var in "ODOO_SMTP_USER" "ODOO_SMTP_PASSWORD"; do
            is_empty_value "${!empty_env_var}" && warn "The ${empty_env_var} environment variable is empty or not set."
        done
        is_empty_value "$ODOO_SMTP_PORT_NUMBER" && print_validation_error "The ODOO_SMTP_PORT_NUMBER environment variable is empty or not set."
        ! is_empty_value "$ODOO_SMTP_PORT_NUMBER" && check_valid_port "ODOO_SMTP_PORT_NUMBER"
        ! is_empty_value "$ODOO_SMTP_PROTOCOL" && check_multi_value "ODOO_SMTP_PROTOCOL" "ssl tls"
    fi

    return "$error_code"
}

########################
# Ensure Odoo is initialized
# Globals:
#   ODOO_*
# Arguments:
#   None
# Returns:
#   None
#########################
odoo_initialize() {
    # Check if Odoo has already been initialized and persisted in a previous run
    local -r app_name="odoo"
    if ! is_app_initialized "$app_name"; then
        local -a db_execute_args=("$ODOO_DATABASE_HOST" "$ODOO_DATABASE_PORT_NUMBER" "$ODOO_DATABASE_NAME" "$ODOO_DATABASE_USER" "$ODOO_DATABASE_PASSWORD")

        # Ensure Odoo persisted directories exist (i.e. when a volume has been mounted to /bitnami)
        info "Ensuring Odoo directories exist"
        ensure_dir_exists "$ODOO_VOLUME_DIR"
        # Use daemon:root ownership for compatibility when running as a non-root user
        am_i_root && configure_permissions_ownership "$ODOO_VOLUME_DIR" -d "775" -f "664" -u "$ODOO_DAEMON_USER" -g "root"
        info "Trying to connect to the database server"
        odoo_wait_for_postgresql_connection "${db_execute_args[@]}"

        # Odoo requires the database to be owned by the same database user used by the application
        # If not, the DB will simply not appear in the list of DBs and Odoo will force you to create a new one
        # Refer to function 'list_dbs' in 'service/db.py'
        info "Validating database owner"
        local db_owner_result
        db_owner_result="$(postgresql_remote_execute_print_output "${db_execute_args[@]}" <<< "SELECT u.usename FROM pg_database d JOIN pg_user u ON (d.datdba = u.usesysid) WHERE d.datname = '${ODOO_DATABASE_NAME}' AND u.usename = '${ODOO_DATABASE_USER}';")"
        if [[ "$db_owner_result" = *"(0 rows)"* ]]; then
            error "The database '${ODOO_DATABASE_NAME}' is not owned by database user '${ODOO_DATABASE_USER}'. This is required for the Odoo application to be able to use this database."
            return 1
        fi

        info "Generating configuration file"
        local template_dir="${BITNAMI_ROOT_DIR}/scripts/odoo/bitnami-templates"
        # Configure polling port parameter depending on Odoo version
        event_port_parameter="gevent_port"
        list_db="$(is_boolean_yes "$ODOO_LIST_DB" && echo 'True' || echo 'False')" \
            odoo_debug="$(is_boolean_yes "$BITNAMI_DEBUG" && echo 'True' || echo 'False')" \
            event_port_parameter="$event_port_parameter" \
            render-template "${template_dir}/odoo.conf.tpl" > "$ODOO_CONF_FILE"

        if ! is_empty_value "$ODOO_SMTP_HOST"; then
            info "Configuring SMTP"
            odoo_conf_set "smtp_server" "$ODOO_SMTP_HOST"
            odoo_conf_set "smtp_port" "$ODOO_SMTP_PORT_NUMBER"
            [[ "$ODOO_SMTP_PROTOCOL" = "ssl" || "$ODOO_SMTP_PROTOCOL" = "tls" ]] && odoo_conf_set "smtp_ssl" "True"
            odoo_conf_set "smtp_user" "$ODOO_SMTP_USER"
            odoo_conf_set "smtp_password" "$ODOO_SMTP_PASSWORD"
        fi

        if ! is_boolean_yes "$ODOO_SKIP_BOOTSTRAP"; then
            info "Installing modules"
            local -a init_args=("--init=all")
            # Disable demo data import if specified by the user
            if [[ -n "${WITHOUT_DEMO:-}" ]]; then
                # Support for legacy WITHOUT_DEMO environment variable, this may be removed in the future
                init_args+=("--without-demo=${WITHOUT_DEMO}")
            elif ! is_boolean_yes "$ODOO_LOAD_DEMO_DATA"; then
                init_args+=("--without-demo=all")
            fi
            odoo_execute "${init_args[@]}"

            info "Updating admin user credentials"
            postgresql_remote_execute "${db_execute_args[@]}" <<< "UPDATE res_users SET login = '${ODOO_EMAIL}', password = '${ODOO_PASSWORD}' WHERE login = 'admin'"
        else
            info "An already initialized Odoo database was provided, configuration will be skipped"
            # Odoo stores a cache of the full path to cached .css/.js files in the filesystem
            # However when reinstalling with ODOO_SKIP_BOOTSTRAP, no filesystem is mounted
            # So we need to clear the assets or if none of the .css/.js will load properly
            info "Clearing assets cache from the database"
            postgresql_remote_execute "${db_execute_args[@]}" <<< "DELETE FROM ir_attachment WHERE url LIKE '/web/content/%';"
            if ! is_boolean_yes "$ODOO_SKIP_MODULES_UPDATE"; then
                info "Updating modules"
                odoo_execute --update=all
            fi
        fi

        info "Persisting Odoo installation"
        persist_app "$app_name" "$ODOO_DATA_TO_PERSIST"
    else
        # Fix to make upgrades from old images work
        # Before, we were persisting 'odoo-server.conf' dir instead of 'conf/odoo.conf', causing errors when restoring persisted data
        # TODO: Remove this block in a future release
        if [[ ! -e "${ODOO_VOLUME_DIR}/conf" && -e "${ODOO_VOLUME_DIR}/odoo-server.conf" ]]; then
            warn "Detected legacy configuration file ${ODOO_VOLUME_DIR}/odoo-server.conf in volume"
            warn "Creating ${ODOO_VOLUME_DIR}/conf/odoo.conf symlink pointing to ${ODOO_VOLUME_DIR}/odoo-server.conf"
            mkdir -p "${ODOO_VOLUME_DIR}/conf"
            ln -s "${ODOO_VOLUME_DIR}/odoo-server.conf" "${ODOO_VOLUME_DIR}/conf/odoo.conf"
        fi

        info "Restoring persisted Odoo installation"
        restore_persisted_app "$app_name" "$ODOO_DATA_TO_PERSIST"
        info "Trying to connect to the database server"
        local db_host db_port db_name db_user db_pass
        db_host="$(odoo_conf_get "db_host")"
        db_port="$(odoo_conf_get "db_port")"
        db_name="$(odoo_conf_get "db_name")"
        db_user="$(odoo_conf_get "db_user")"
        db_pass="$(odoo_conf_get "db_password")"
        odoo_wait_for_postgresql_connection "$db_host" "$db_port" "$db_name" "$db_user" "$db_pass"
        if ! is_boolean_yes "$ODOO_SKIP_MODULES_UPDATE"; then
            info "Updating modules"
            odoo_execute --update=all
        fi
    fi

    # Avoid exit code of previous commands to affect the result of this function
    true
}

########################
# Add or modify an entry in the Odoo configuration file
# Globals:
#   ODOO_*
# Arguments:
#   $1 - Variable name
#   $2 - Value to assign to the variable
# Returns:
#   None
#########################
odoo_conf_set() {
    local -r key="${1:?key missing}"
    local -r value="${2:?value missing}"
    debug "Setting ${key} to '${value}' in Odoo configuration"
    # Sanitize key (sed does not support fixed string substitutions)
    local sanitized_pattern
    sanitized_pattern="^\s*(;\s*)?$(sed 's/[]\[^$.*/]/\\&/g' <<< "$key")\s*=.*"
    local entry="${key} = ${value}"
    # Check if the configuration exists in the file
    if grep -q -E "$sanitized_pattern" "$ODOO_CONF_FILE"; then
        # It exists, so replace the line
        replace_in_file "$ODOO_CONF_FILE" "$sanitized_pattern" "$entry"
    else
        # It doesn't exist, so append to the end of the file
        cat >> "$ODOO_CONF_FILE" <<< "$entry"
    fi
}

########################
# Get an entry from the Odoo configuration file
# Globals:
#   ODOO_*
# Arguments:
#   $1 - Variable name
# Returns:
#   None
#########################
odoo_conf_get() {
    local -r key="${1:?key missing}"
    debug "Getting ${key} from Odoo configuration"
    # Sanitize key (sed does not support fixed string substitutions)
    local sanitized_pattern
    sanitized_pattern="^\s*(;\s*)?$(sed 's/[]\[^$.*/]/\\&/g' <<< "$key")\s*=(.*)"
    grep -E "$sanitized_pattern" "$ODOO_CONF_FILE" | sed -E "s|${sanitized_pattern}|\2|" | tr -d "\"' "
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
odoo_wait_for_postgresql_connection() {
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
# Execute a command using the 'odoo' CLI
# Globals:
#   ODOO_*
# Arguments:
#   $1 - log file
# Returns:
#   None
#########################
odoo_execute() {
    # Define 'odoo' cmdline arguments
    local -a cmd=("${ODOO_BIN_DIR}/odoo")
    am_i_root && cmd=("run_as_user" "$ODOO_DAEMON_USER" "${cmd[@]}")

    # Ensure the logfile is not populated with init info and no service is left running
    debug_execute "${cmd[@]}" --config="$ODOO_CONF_FILE" --logfile= --pidfile= --stop-after-init "$@"
}

########################
# Check if Odoo is running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_odoo_running() {
    pid="$(get_pid_from_file "$ODOO_PID_FILE")"
    if [[ -n "$pid" ]]; then
        is_service_running "$pid"
    else
        false
    fi
}

########################
# Check if Odoo is not running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_odoo_not_running() {
    ! is_odoo_running
}

########################
# Stop Odoo
# Arguments:
#   None
# Returns:
#   None
#########################
odoo_stop() {
    ! is_odoo_running && return
    stop_service_using_pid "$ODOO_PID_FILE"
}

########################
# Get Odoo major version
# Globals:
#   ODOO_BASE_DIR
# Arguments:
#   None
# Returns:
#   odoo major version
#########################
odoo_major_version() {
    "${ODOO_BASE_DIR}/bin/odoo" --version 2>/dev/null | grep -E -o "[0-9]+.[0-9]+.[0-9]+" | cut -d'.' -f 1
}
