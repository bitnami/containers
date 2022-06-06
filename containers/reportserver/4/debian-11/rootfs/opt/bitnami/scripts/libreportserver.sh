#!/bin/bash
#
# Bitnami ReportServer library

# shellcheck disable=SC1091

# Load generic libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libpersistence.sh
. /opt/bitnami/scripts/libservice.sh

# Load database library
if [[ -f /opt/bitnami/scripts/libmysqlclient.sh ]]; then
    . /opt/bitnami/scripts/libmysqlclient.sh
elif [[ -f /opt/bitnami/scripts/libmysql.sh ]]; then
    . /opt/bitnami/scripts/libmysql.sh
elif [[ -f /opt/bitnami/scripts/libmariadb.sh ]]; then
    . /opt/bitnami/scripts/libmariadb.sh
fi

########################
# Validate settings in REPORTSERVER_* env vars
# Globals:
#   REPORTSERVER_*
# Arguments:
#   None
# Returns:
#   0 if the validation succeeded, 1 otherwise
#########################
reportserver_validate() {
    debug "Validating settings in REPORTSERVER_* environment variables..."
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
    ! is_empty_value "REPORTSERVER_INSTALL_DEMO_DATA" && check_yes_no_value "REPORTSERVER_INSTALL_DEMO_DATA"

    # Validate user data
    check_empty_value "REPORTSERVER_USERNAME"
    check_empty_value "REPORTSERVER_PASSWORD"
    check_empty_value "REPORTSERVER_EMAIL"
    check_empty_value "REPORTSERVER_FIRST_NAME"
    check_empty_value "REPORTSERVER_LAST_NAME"

    # Validate credentials
    if is_boolean_yes "${ALLOW_EMPTY_PASSWORD:-}"; then
        warn "You set the environment variable ALLOW_EMPTY_PASSWORD=${ALLOW_EMPTY_PASSWORD:-}. For safety reasons, do not use this flag in a production environment."
    else
        for empty_env_var in "REPORTSERVER_DATABASE_PASSWORD" "REPORTSERVER_PASSWORD"; do
            is_empty_value "${!empty_env_var}" && print_validation_error "The ${empty_env_var} environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow a blank password. This is only recommended for development environments."
        done
    fi

    # Validate SMTP credentials
    if ! is_empty_value "$REPORTSERVER_SMTP_HOST"; then
        for empty_env_var in "REPORTSERVER_SMTP_USER" "REPORTSERVER_SMTP_PASSWORD"; do
            is_empty_value "${!empty_env_var}" && warn "The ${empty_env_var} environment variable is empty or not set."
        done
        is_empty_value "$REPORTSERVER_SMTP_PORT_NUMBER" && print_validation_error "The REPORTSERVER_SMTP_PORT_NUMBER environment variable is empty or not set."
        ! is_empty_value "$REPORTSERVER_SMTP_PORT_NUMBER" && check_valid_port "REPORTSERVER_SMTP_PORT_NUMBER"
    fi

    return "$error_code"
}

########################
# Ensure ReportServer is initialized
# Globals:
#   REPORTSERVER_*
# Arguments:
#   None
# Returns:
#   None
#########################
reportserver_initialize() {
    local -a mysql_remote_execute_args=("$REPORTSERVER_DATABASE_HOST" "$REPORTSERVER_DATABASE_PORT_NUMBER" "$REPORTSERVER_DATABASE_NAME" "$REPORTSERVER_DATABASE_USER" "$REPORTSERVER_DATABASE_PASSWORD")
    local -r rsinit_properties="${REPORTSERVER_CONF_DIR}/rsinit.properties"
    local -r persistence_properties="${REPORTSERVER_CONF_DIR}/persistence.properties"
    info "Trying to connect to the database server"
    reportserver_wait_for_mysql_connection "${mysql_remote_execute_args[@]}"

    # ReportServer uses all persistence in the database. So, in order to detect if we are using a persisted installation, we check
    # if there is content in the database (the databases start with RS_, as it can be seen in the schema files in the ddl/ folder)
    local -r num_tables=$(echo "SHOW TABLES" | mysql_remote_execute_print_output "${mysql_remote_execute_args[@]}" | grep -c "RS_")

    # ReportServer database configuration
    # Source: https://reportserver.net/en/guides/config/chapters/configfile-persistenceproperties/
    info "Configuring ReportServer database"
    cat <<EOF >>"$persistence_properties"
hibernate.connection.username=${REPORTSERVER_DATABASE_USER}
hibernate.connection.password=${REPORTSERVER_DATABASE_PASSWORD}
hibernate.dialect=net.datenwerke.rs.utils.hibernate.MySQL5Dialect
hibernate.connection.driver_class=com.mysql.jdbc.Driver
hibernate.connection.url=jdbc:mysql://${REPORTSERVER_DATABASE_HOST}:${REPORTSERVER_DATABASE_PORT_NUMBER}/${REPORTSERVER_DATABASE_NAME}
EOF

    if [[ "$num_tables" == "0" ]]; then
        # Deploy database schema. We only need to do it at first installation as the rs.Environmental validator class will automatically update the schemas on upgrades
        # Source: https://reportserver.net/en/tutorials/installation-best-practice/#database
        info "Deploying ReportServer from scratch"
        info "Creating database schema..."
        local -r schema_file_path=$(realpath "${REPORTSERVER_BASE_DIR}/ddl/reportserver-RS"*"-schema-MySQL5_CREATE.sql")
        echo "SOURCE $schema_file_path" | mysql_remote_execute "${mysql_remote_execute_args[@]}"
        # Mimicking the first boot parameter generation from the wizard, the rsinit.properties
        # is used at first boot and can be seen in the src/net/datenwerke/rs/installation/InitConfigTask.java file
        # inside the ReportServer source code
        # Source: https://github.com/infofabrik/reportserver/blob/main/src/net/datenwerke/rs/installation/InitConfigTask.java
        info "Configuring first boot parameters"

        if is_boolean_yes "$REPORTSERVER_INSTALL_DEMO_DATA"; then
            debug "Enabling demo data"
            cat <<EOF >>"$rsinit_properties"
democontent.install=true
EOF
        fi

        info "Configuring user"
        cat <<EOF >>"$rsinit_properties"
usermanager.root.username=${REPORTSERVER_USERNAME}
usermanager.root.firstname=${REPORTSERVER_FIRST_NAME}
usermanager.root.lastname=${REPORTSERVER_LAST_NAME}
usermanager.root.email=${REPORTSERVER_EMAIL}
usermanager.root.password=${REPORTSERVER_PASSWORD}
EOF

        if ! is_empty_value "$REPORTSERVER_SMTP_HOST"; then
            info "Configuring SMTP"
            cat <<EOF >>"$rsinit_properties"
cfg.mail.mail_cf.smtp.host=${REPORTSERVER_SMTP_HOST}
cfg.mail.mail_cf.smtp.port=${REPORTSERVER_SMTP_PORT_NUMBER}
cfg.mail.mail_cf.smtp.username=${REPORTSERVER_SMTP_USER}
cfg.mail.mail_cf.smtp.password=${REPORTSERVER_SMTP_PASSWORD}
EOF
            case "$REPORTSERVER_SMTP_PROTOCOL" in
            ssl)
                cat <<EOF >>"$rsinit_properties"
cfg.mail.mail_cf.smtp.ssl=true
EOF
                ;;
            tls)
                cat <<EOF >>"$rsinit_properties"
cfg.mail.mail_cf.smtp.tls.enable=true
cfg.mail.mail_cf.smtp.tls.require=true
EOF
                ;;
            esac
        fi

        # Start Tomcat in background to populate the database
        tomcat_start_bg

        info "Waiting for database to be populated"
        reportserver_wait_for_data "${mysql_remote_execute_args[@]}"

        tomcat_stop
    else
        info "Found persisted installation. Skipping initial bootstrap"
    fi

    if ! grep -q 'response.sendRedirect' "${BITNAMI_ROOT_DIR}/tomcat/webapps/ROOT/index.jsp"; then
        # Make Tomcat redirect to /reportserver
        replace_in_file "${BITNAMI_ROOT_DIR}/tomcat/webapps/ROOT/index.jsp" '<%\s*$' '<%\nresponse.sendRedirect("/reportserver");'
    fi
    # Avoid exit code of previous commands to affect the result of this function
    true
}

########################
# Add or modify an entry in the ReportServer configuration file
# Globals:
#   REPORTSERVER_*
# Arguments:
#   $1 - Variable name
#   $2 - Value to assign to the variable
#   $3 - Whether the value is a literal, or if instead it should be quoted (default: no)
# Returns:
#   None
#########################
reportserver_conf_set() {
    local -r key="${1:?key missing}"
    local -r value="${2:?value missing}"
    local -r file="${3:-${REPORTSERVER_CONF_FILE}}"
    debug "Setting ${key} to '${value}' in ReportServer configuration"
    # Sanitize key (sed does not support fixed string substitutions)
    local sanitized_pattern
    sanitized_pattern="^\s*(//\s*)?$(sed 's/[]\[^$.*/]/\\&/g' <<<"$key")\s*=.*"
    local entry="${key} = ${value}"
    # Check if the configuration exists in the file
    if grep -q -E "$sanitized_pattern" "$file"; then
        # It exists, so replace the line
        replace_in_file "$file" "$sanitized_pattern" "$entry"
    else
        # The ReportServer configuration file includes all supported keys, but because of its format,
        # we cannot append contents to the end. We can assume this should never happen.
        warn "Could not set the ReportServer '${key}' configuration. Check that the file has not been modified externally."
    fi
}

########################
# Get an entry from the ReportServer configuration file
# Globals:
#   REPORTSERVER_*
# Arguments:
#   $1 - Variable name
# Returns:
#   None
#########################
reportserver_conf_get() {
    local -r key="${1:?key missing}"
    local -r file="${2:-${REPORTSERVER_CONF_FILE}}"
    debug "Getting ${key} from ReportServer configuration"
    # Sanitize key (sed does not support fixed string substitutions)
    local sanitized_pattern
    sanitized_pattern="^\s*(//\s*)?$(sed 's/[]\[^$.*/]/\\&/g' <<<"$key")\s*=(.*)"
    #sanitized_pattern="^\s*(//\s*)?$(sed 's/[]\[^$.*/]/\\&/g' <<< "$key")\s*=([^;]+);"
    grep -E "$sanitized_pattern" "$file" | sed -E "s|${sanitized_pattern}|\2|" | tr -d "\"' "
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
reportserver_wait_for_mysql_connection() {
    local -r db_host="${1:?missing database host}"
    local -r db_port="${2:?missing database port}"
    local -r db_name="${3:?missing database name}"
    local -r db_user="${4:?missing database user}"
    local -r db_pass="${5:-}"
    check_mysql_connection() {
        echo "SELECT 1" | mysql_remote_execute "$db_host" "$db_port" "$db_name" "$db_user" "$db_pass"
    }
    if ! retry_while "check_mysql_connection"; then
        error "Could not connect to the database"
        return 1
    fi
}

########################
# Wait until the database is populated
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
reportserver_wait_for_data() {
    local -r db_host="${1:?missing database host}"
    local -r db_port="${2:?missing database port}"
    local -r db_name="${3:?missing database name}"
    local -r db_user="${4:?missing database user}"
    local -r db_pass="${5:-}"
    # We check that one of the tables has content. The schema is available in the
    # ddl/ folder inside the ReportServer installation
    check_mysql_data() {
        echo "SELECT email FROM RS_USER WHERE super_user=1" | mysql_remote_execute_print_output "$db_host" "$db_port" "$db_name" "$db_user" "$db_pass"
    }

    if ! retry_while "check_mysql_data"; then
        error "Data initialization failed"
        return 1
    fi
}
