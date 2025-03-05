#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami PostgreSQL library

# shellcheck disable=SC1090,SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libnet.sh

########################
# Configure libnss_wrapper so PostgreSQL commands work with a random user.
# Globals:
#   POSTGRESQL_*
# Arguments:
#   None
# Returns:
#   None
#########################
postgresql_enable_nss_wrapper() {
    if ! getent passwd "$(id -u)" &>/dev/null && [ -e "$NSS_WRAPPER_LIB" ]; then
        debug "Configuring libnss_wrapper..."
        export LD_PRELOAD="$NSS_WRAPPER_LIB"
        # shellcheck disable=SC2155
        export NSS_WRAPPER_PASSWD="$(mktemp)"
        # shellcheck disable=SC2155
        export NSS_WRAPPER_GROUP="$(mktemp)"
        echo "postgres:x:$(id -u):$(id -g):PostgreSQL:$POSTGRESQL_DATA_DIR:/bin/false" >"$NSS_WRAPPER_PASSWD"
        echo "postgres:x:$(id -g):" >"$NSS_WRAPPER_GROUP"
    fi
}

########################
# Validate settings in POSTGRESQL_* environment variables
# Globals:
#   POSTGRESQL_*
# Arguments:
#   None
# Returns:
#   None
#########################
postgresql_validate() {
    info "Validating settings in POSTGRESQL_* env vars.."
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }

    check_multi_value() {
        if [[ " ${2} " != *" ${!1} "* ]]; then
            print_validation_error "The allowed values for ${1} are: ${2}"
        fi
    }

    empty_password_enabled_warn() {
        warn "You set the environment variable ALLOW_EMPTY_PASSWORD=${ALLOW_EMPTY_PASSWORD}. For safety reasons, do not use this flag in a production environment."
    }
    empty_password_error() {
        print_validation_error "The $1 environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow the container to be started with blank passwords. This is recommended only for development."
    }
    if is_boolean_yes "$ALLOW_EMPTY_PASSWORD"; then
        empty_password_enabled_warn
    else
        if [[ -z "$POSTGRESQL_PASSWORD" ]]; then
            empty_password_error "POSTGRESQL_PASSWORD"
        fi
        if ((${#POSTGRESQL_PASSWORD} > 100)); then
            print_validation_error "The password cannot be longer than 100 characters. Set the environment variable POSTGRESQL_PASSWORD with a shorter value"
        fi
        if [[ -n "$POSTGRESQL_USERNAME" ]] && [[ -z "$POSTGRESQL_PASSWORD" ]]; then
            empty_password_error "POSTGRESQL_PASSWORD"
        fi
        if [[ -n "$POSTGRESQL_USERNAME" ]] && [[ "$POSTGRESQL_USERNAME" != "postgres" ]] && [[ -n "$POSTGRESQL_PASSWORD" ]] && [[ -z "$POSTGRESQL_DATABASE" ]]; then
            print_validation_error "In order to use a custom PostgreSQL user you need to set the environment variable POSTGRESQL_DATABASE as well"
        fi
    fi
    if [[ -n "$POSTGRESQL_REPLICATION_MODE" ]]; then
        if [[ "$POSTGRESQL_REPLICATION_MODE" = "master" ]]; then
            if ((POSTGRESQL_NUM_SYNCHRONOUS_REPLICAS < 0)); then
                print_validation_error "The number of synchronous replicas cannot be less than 0. Set the environment variable POSTGRESQL_NUM_SYNCHRONOUS_REPLICAS"
            fi
        elif [[ "$POSTGRESQL_REPLICATION_MODE" = "slave" ]]; then
            if [[ -z "$POSTGRESQL_MASTER_HOST" ]]; then
                print_validation_error "Slave replication mode chosen without setting the environment variable POSTGRESQL_MASTER_HOST. Use it to indicate where the Master node is running"
            fi
            if [[ -z "$POSTGRESQL_REPLICATION_USER" ]]; then
                print_validation_error "Slave replication mode chosen without setting the environment variable POSTGRESQL_REPLICATION_USER. Make sure that the master also has this parameter set"
            fi
        else
            print_validation_error "Invalid replication mode. Available options are 'master/slave'"
        fi
        # Common replication checks
        if [[ -n "$POSTGRESQL_REPLICATION_USER" ]] && [[ -z "$POSTGRESQL_REPLICATION_PASSWORD" ]]; then
            empty_password_error "POSTGRESQL_REPLICATION_PASSWORD"
        fi
    else
        if is_boolean_yes "$ALLOW_EMPTY_PASSWORD"; then
            empty_password_enabled_warn
        else
            if [[ -z "$POSTGRESQL_PASSWORD" ]]; then
                empty_password_error "POSTGRESQL_PASSWORD"
            fi
            if [[ -n "$POSTGRESQL_USERNAME" ]] && [[ -z "$POSTGRESQL_PASSWORD" ]]; then
                empty_password_error "POSTGRESQL_PASSWORD"
            fi
        fi
    fi

    if ! is_yes_no_value "$POSTGRESQL_ENABLE_LDAP"; then
        empty_password_error "The values allowed for POSTGRESQL_ENABLE_LDAP are: yes or no"
    fi

    if is_boolean_yes "$POSTGRESQL_ENABLE_LDAP" && [[ -n "$POSTGRESQL_LDAP_URL" ]] && [[ -n "$POSTGRESQL_LDAP_SERVER" ]]; then
        empty_password_error "You can not set POSTGRESQL_LDAP_URL and POSTGRESQL_LDAP_SERVER at the same time. Check your LDAP configuration."
    fi

    if ! is_yes_no_value "$POSTGRESQL_ENABLE_TLS"; then
        print_validation_error "The values allowed for POSTGRESQL_ENABLE_TLS are: yes or no"
    elif is_boolean_yes "$POSTGRESQL_ENABLE_TLS"; then
        # TLS Checks
        if [[ -z "$POSTGRESQL_TLS_CERT_FILE" ]]; then
            print_validation_error "You must provide a X.509 certificate in order to use TLS"
        elif [[ ! -f "$POSTGRESQL_TLS_CERT_FILE" ]]; then
            print_validation_error "The X.509 certificate file in the specified path ${POSTGRESQL_TLS_CERT_FILE} does not exist"
        fi
        if [[ -z "$POSTGRESQL_TLS_KEY_FILE" ]]; then
            print_validation_error "You must provide a private key in order to use TLS"
        elif [[ ! -f "$POSTGRESQL_TLS_KEY_FILE" ]]; then
            print_validation_error "The private key file in the specified path ${POSTGRESQL_TLS_KEY_FILE} does not exist"
        fi
        if [[ -z "$POSTGRESQL_TLS_CA_FILE" ]]; then
            warn "A CA X.509 certificate was not provided. Client verification will not be performed in TLS connections"
        elif [[ ! -f "$POSTGRESQL_TLS_CA_FILE" ]]; then
            print_validation_error "The CA X.509 certificate file in the specified path ${POSTGRESQL_TLS_CA_FILE} does not exist"
        fi
        if [[ -n "$POSTGRESQL_TLS_CRL_FILE" ]] && [[ ! -f "$POSTGRESQL_TLS_CRL_FILE" ]]; then
            print_validation_error "The CRL file in the specified path ${POSTGRESQL_TLS_CRL_FILE} does not exist"
        fi
        if ! is_yes_no_value "$POSTGRESQL_TLS_PREFER_SERVER_CIPHERS"; then
            print_validation_error "The values allowed for POSTGRESQL_TLS_PREFER_SERVER_CIPHERS are: yes or no"
        fi
    fi

    if [[ -n "$POSTGRESQL_SYNCHRONOUS_REPLICAS_MODE" ]]; then
        check_multi_value "POSTGRESQL_SYNCHRONOUS_REPLICAS_MODE" "FIRST ANY"
    fi

    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}

########################
# Create basic postgresql.conf file using the example provided in the share/ folder
# Globals:
#   POSTGRESQL_*
# Arguments:
#   None
# Returns:
#   None
#########################
postgresql_create_config() {
    info "postgresql.conf file not detected. Generating it..."
    cp "$POSTGRESQL_BASE_DIR/share/postgresql.conf.sample" "$POSTGRESQL_CONF_FILE"
    # Update default value for 'include_dir' directive
    # ref: https://github.com/postgres/postgres/commit/fb9c475597c245562a28d1e916b575ac4ec5c19f#diff-f5544d9b6d218cc9677524b454b41c60
    if ! grep include_dir "$POSTGRESQL_CONF_FILE" >/dev/null; then
        error "include_dir line is not present in $POSTGRESQL_CONF_FILE. This may be due to a changes in a new version of PostgreSQL. Please check"
        exit 1
    fi
    local psql_conf
    psql_conf="$(sed -E "/#include_dir/i include_dir = 'conf.d'" "$POSTGRESQL_CONF_FILE")"
    echo "$psql_conf" >"$POSTGRESQL_CONF_FILE"
}

########################
# Create ldap auth configuration in pg_hba,
# but keeps postgres user to authenticate locally
# Globals:
#   POSTGRESQL_*
# Arguments:
#   None
# Returns:
#   None
#########################
postgresql_ldap_auth_configuration() {
    info "Generating LDAP authentication configuration"
    local ldap_configuration=""

    if [[ -n "$POSTGRESQL_LDAP_URL" ]]; then
        ldap_configuration="ldapurl=\"$POSTGRESQL_LDAP_URL\""
    else
        ldap_configuration="ldapserver=${POSTGRESQL_LDAP_SERVER}"

        [[ -n "$POSTGRESQL_LDAP_PREFIX" ]] && ldap_configuration+=" ldapprefix=\"${POSTGRESQL_LDAP_PREFIX}\""
        [[ -n "$POSTGRESQL_LDAP_SUFFIX" ]] && ldap_configuration+=" ldapsuffix=\"${POSTGRESQL_LDAP_SUFFIX}\""
        [[ -n "$POSTGRESQL_LDAP_PORT" ]] && ldap_configuration+=" ldapport=${POSTGRESQL_LDAP_PORT}"
        [[ -n "$POSTGRESQL_LDAP_BASE_DN" ]] && ldap_configuration+=" ldapbasedn=\"${POSTGRESQL_LDAP_BASE_DN}\""
        [[ -n "$POSTGRESQL_LDAP_BIND_DN" ]] && ldap_configuration+=" ldapbinddn=\"${POSTGRESQL_LDAP_BIND_DN}\""
        [[ -n "$POSTGRESQL_LDAP_BIND_PASSWORD" ]] && ldap_configuration+=" ldapbindpasswd=${POSTGRESQL_LDAP_BIND_PASSWORD}"
        [[ -n "$POSTGRESQL_LDAP_SEARCH_ATTR" ]] && ldap_configuration+=" ldapsearchattribute=${POSTGRESQL_LDAP_SEARCH_ATTR}"
        [[ -n "$POSTGRESQL_LDAP_SEARCH_FILTER" ]] && ldap_configuration+=" ldapsearchfilter=\"${POSTGRESQL_LDAP_SEARCH_FILTER}\""
        [[ -n "$POSTGRESQL_LDAP_TLS" ]] && ldap_configuration+=" ldaptls=${POSTGRESQL_LDAP_TLS}"
        [[ -n "$POSTGRESQL_LDAP_SCHEME" ]] && ldap_configuration+=" ldapscheme=${POSTGRESQL_LDAP_SCHEME}"
    fi

    cat <<EOF >"$POSTGRESQL_PGHBA_FILE"
host     all             postgres        0.0.0.0/0               trust
host     all             postgres        ::/0                    trust
host     all             all             0.0.0.0/0               ldap $ldap_configuration
host     all             all             ::/0                    ldap $ldap_configuration
EOF
}

########################
# Create local auth configuration in pg_hba
# Globals:
#   POSTGRESQL_*
# Arguments:
#   None
# Returns:
#   None
#########################
postgresql_password_auth_configuration() {
    info "Generating local authentication configuration"
    cat <<EOF >"$POSTGRESQL_PGHBA_FILE"
host     all             all             0.0.0.0/0               trust
host     all             all             ::/0                    trust
EOF
}

########################
# Enforce Certificate client authentication
# for TLS connections in pg_hba
# Globals:
#   POSTGRESQL_*
# Arguments:
#   None
# Returns:
#   None
#########################
postgresql_tls_auth_configuration() {
    info "Enabling TLS Client authentication"
    local previous_content
    [[ -f "$POSTGRESQL_PGHBA_FILE" ]] && previous_content=$(<"$POSTGRESQL_PGHBA_FILE")

    cat <<EOF >"$POSTGRESQL_PGHBA_FILE"
hostssl     all             all             0.0.0.0/0               cert
hostssl     all             all             ::/0                    cert
${previous_content:-}
EOF
}

########################
# Create basic pg_hba.conf file
# Globals:
#   POSTGRESQL_*
# Arguments:
#   None
# Returns:
#   None
#########################
postgresql_create_pghba() {
    info "pg_hba.conf file not detected. Generating it..."

    if is_boolean_yes "$POSTGRESQL_ENABLE_LDAP"; then
        postgresql_ldap_auth_configuration
    else
        postgresql_password_auth_configuration
    fi
}

########################
# Change pg_hba.conf so it allows local UNIX socket-based connections
# Globals:
#   POSTGRESQL_*
# Arguments:
#   None
# Returns:
#   None
#########################
postgresql_allow_local_connection() {
    cat <<EOF >>"$POSTGRESQL_PGHBA_FILE"
local    all             all                                     trust
host     all             all        127.0.0.1/32                 trust
host     all             all        ::1/128                      trust
EOF
}

########################
# Change pg_hba.conf so only password-based authentication is allowed
# Globals:
#   POSTGRESQL_*
# Arguments:
#   None
# Returns:
#   None
#########################
postgresql_restrict_pghba() {
    if [[ -n "$POSTGRESQL_PASSWORD" ]]; then
        replace_in_file "$POSTGRESQL_PGHBA_FILE" "trust" "md5" false
    fi
}

########################
# Change pg_hba.conf so it allows access from replication users
# Globals:
#   POSTGRESQL_*
# Arguments:
#   None
# Returns:
#   None
#########################
postgresql_add_replication_to_pghba() {
    local replication_auth="trust"
    if [[ -n "$POSTGRESQL_REPLICATION_PASSWORD" ]]; then
        replication_auth="md5"
    fi
    cat <<EOF >>"$POSTGRESQL_PGHBA_FILE"
host      replication     all             0.0.0.0/0               ${replication_auth}
host      replication     all             ::/0                    ${replication_auth}
EOF
}

########################
# Change a PostgreSQL configuration file by setting a property
# Globals:
#   POSTGRESQL_*
# Arguments:
#   $1 - property
#   $2 - value
#   $3 - Path to configuration file (default: $POSTGRESQL_CONF_FILE)
# Returns:
#   None
#########################
postgresql_set_property() {
    local -r property="${1:?missing property}"
    local -r value="${2:?missing value}"
    local -r conf_file="${3:-$POSTGRESQL_CONF_FILE}"
    local psql_conf
    if grep -qE "^#*\s*${property}" "$conf_file" >/dev/null; then
        replace_in_file "$conf_file" "^#*\s*${property}\s*=.*" "${property} = '${value}'" false
    else
        echo "${property} = '${value}'" >>"$conf_file"
    fi
}

########################
# Create a user for master-slave replication
# Globals:
#   POSTGRESQL_*
# Arguments:
#   None
# Returns:
#   None
#########################
postgresql_create_replication_user() {
    local -r escaped_password="${POSTGRESQL_REPLICATION_PASSWORD//\'/\'\'}"
    local -r postgres_password="${POSTGRESQL_POSTGRES_PASSWORD:-$POSTGRESQL_PASSWORD}"

    info "Creating replication user $POSTGRESQL_REPLICATION_USER"
    echo "CREATE ROLE \"$POSTGRESQL_REPLICATION_USER\" REPLICATION LOGIN ENCRYPTED PASSWORD '$escaped_password'" | postgresql_execute "" "postgres" "$postgres_password"
}

########################
# Change postgresql.conf by setting replication parameters
# Globals:
#   POSTGRESQL_*
# Arguments:
#   None
# Returns:
#   None
#########################
postgresql_configure_replication_parameters() {
    local -r psql_major_version="$(postgresql_get_major_version)"
    info "Configuring replication parameters"
    postgresql_set_property "wal_level" "$POSTGRESQL_WAL_LEVEL"
    postgresql_set_property "max_wal_size" "400MB"
    postgresql_set_property "max_wal_senders" "16"
    if ((psql_major_version >= 13)); then
        postgresql_set_property "wal_keep_size" "128MB"
    else
        postgresql_set_property "wal_keep_segments" "12"
    fi
    postgresql_set_property "hot_standby" "on"

    if is_boolean_yes "$POSTGRESQL_REPLICATION_USE_PASSFILE" && [[ ! -f "${POSTGRESQL_REPLICATION_PASSFILE_PATH}" ]]; then
        echo "*:*:*:${POSTGRESQL_REPLICATION_USER}:${POSTGRESQL_REPLICATION_PASSWORD}" >"${POSTGRESQL_REPLICATION_PASSFILE_PATH}"
        chmod 600 "${POSTGRESQL_REPLICATION_PASSFILE_PATH}"
    fi
}

########################
# Change postgresql.conf by setting parameters for synchronous replication
# Globals:
#   POSTGRESQL_*
# Arguments:
#   None
# Returns:
#   None
#########################
postgresql_configure_synchronous_replication() {
    local replication_nodes=""
    local synchronous_standby_names=""
    info "Configuring synchronous_replication"

    # Check for comma separate values
    # When using repmgr, POSTGRESQL_CLUSTER_APP_NAME will contain the list of nodes to be synchronous
    # This list need to cleaned from other things but node names.
    if [[ "$POSTGRESQL_CLUSTER_APP_NAME" == *","* ]]; then
        read -r -a nodes <<<"$(tr ',;' ' ' <<<"${POSTGRESQL_CLUSTER_APP_NAME}")"
        for node in "${nodes[@]}"; do
            [[ "$node" =~ ^(([^:/?#]+):)?// ]] || node="tcp://${node}"

            # repmgr is only using the first segment of the FQDN as the application name
            host="$(parse_uri "$node" 'host' | awk -F. '{print $1}')"
            replication_nodes="${replication_nodes}${replication_nodes:+,}\"${host}\""
        done
    else
        replication_nodes="\"${POSTGRESQL_CLUSTER_APP_NAME}\""
    fi

    if ((POSTGRESQL_NUM_SYNCHRONOUS_REPLICAS > 0)); then
        synchronous_standby_names="${POSTGRESQL_NUM_SYNCHRONOUS_REPLICAS} (${replication_nodes})"
        if [[ -n "$POSTGRESQL_SYNCHRONOUS_REPLICAS_MODE" ]]; then
            synchronous_standby_names="${POSTGRESQL_SYNCHRONOUS_REPLICAS_MODE} ${synchronous_standby_names}"
        fi

        postgresql_set_property "synchronous_commit" "$POSTGRESQL_SYNCHRONOUS_COMMIT_MODE"
        postgresql_set_property "synchronous_standby_names" "$synchronous_standby_names"
    fi
}

########################
# Change postgresql.conf by setting TLS properies
# Globals:
#   POSTGRESQL_*
# Arguments:
#   None
# Returns:
#   None
#########################
postgresql_configure_tls() {
    info "Configuring TLS"
    chmod 600 "$POSTGRESQL_TLS_KEY_FILE" || warn "Could not set compulsory permissions (600) on file ${POSTGRESQL_TLS_KEY_FILE}"
    postgresql_set_property "ssl" "on"
    # Server ciphers are preferred by default
    ! is_boolean_yes "$POSTGRESQL_TLS_PREFER_SERVER_CIPHERS" && postgresql_set_property "ssl_prefer_server_ciphers" "off"
    [[ -n $POSTGRESQL_TLS_CA_FILE ]] && postgresql_set_property "ssl_ca_file" "$POSTGRESQL_TLS_CA_FILE"
    [[ -n $POSTGRESQL_TLS_CRL_FILE ]] && postgresql_set_property "ssl_crl_file" "$POSTGRESQL_TLS_CRL_FILE"
    postgresql_set_property "ssl_cert_file" "$POSTGRESQL_TLS_CERT_FILE"
    postgresql_set_property "ssl_key_file" "$POSTGRESQL_TLS_KEY_FILE"
}

########################
# Change postgresql.conf by setting fsync
# Globals:
#   POSTGRESQL_*
# Arguments:
#   None
# Returns:
#   None
#########################
postgresql_configure_fsync() {
    info "Configuring fsync"
    postgresql_set_property "fsync" "$POSTGRESQL_FSYNC"
}

########################
# Alter password of the postgres user
# Globals:
#   POSTGRESQL_*
# Arguments:
#   Password
# Returns:
#   None
#########################
postgresql_alter_postgres_user() {
    local -r escaped_password="${1//\'/\'\'}"
    info "Changing password of postgres"
    echo "ALTER ROLE postgres WITH PASSWORD '$escaped_password';" | postgresql_execute
    if [[ -n "$POSTGRESQL_POSTGRES_CONNECTION_LIMIT" ]]; then
        echo "ALTER ROLE postgres WITH CONNECTION LIMIT ${POSTGRESQL_POSTGRES_CONNECTION_LIMIT};" | postgresql_execute
    fi
}

########################
# Create an admin user with all privileges in POSTGRESQL_DATABASE
# Globals:
#   POSTGRESQL_*
# Arguments:
#   None
# Returns:
#   None
#########################
postgresql_create_admin_user() {
    local -r escaped_password="${POSTGRESQL_PASSWORD//\'/\'\'}"
    local -r postgres_password="${POSTGRESQL_POSTGRES_PASSWORD:-$POSTGRESQL_PASSWORD}"
    info "Creating user ${POSTGRESQL_USERNAME}"
    local connlimit_string=""
    if [[ -n "$POSTGRESQL_USERNAME_CONNECTION_LIMIT" ]]; then
        connlimit_string="CONNECTION LIMIT ${POSTGRESQL_USERNAME_CONNECTION_LIMIT}"
    fi
    echo "CREATE ROLE \"${POSTGRESQL_USERNAME}\" WITH LOGIN ${connlimit_string} CREATEDB PASSWORD '${escaped_password}';" | postgresql_execute "" "postgres" "$postgres_password"
    info "Granting access to \"${POSTGRESQL_USERNAME}\" to the database \"${POSTGRESQL_DATABASE}\""
    echo "GRANT ALL PRIVILEGES ON DATABASE \"${POSTGRESQL_DATABASE}\" TO \"${POSTGRESQL_USERNAME}\"\;" | postgresql_execute "" "postgres" "$postgres_password"
    echo "ALTER DATABASE \"${POSTGRESQL_DATABASE}\" OWNER TO \"${POSTGRESQL_USERNAME}\"\;" | postgresql_execute "" "postgres" "$postgres_password"
    info "Setting ownership for the 'public' schema database \"${POSTGRESQL_DATABASE}\" to \"${POSTGRESQL_USERNAME}\""
    echo "ALTER SCHEMA public OWNER TO \"${POSTGRESQL_USERNAME}\"\;" | postgresql_execute "$POSTGRESQL_DATABASE" "postgres" "$postgres_password"
}

########################
# Create a database with name $POSTGRESQL_DATABASE
# Globals:
#   POSTGRESQL_*
# Arguments:
#   None
# Returns:
#   None
#########################
postgresql_create_custom_database() {
    echo "CREATE DATABASE \"$POSTGRESQL_DATABASE\"" | postgresql_execute "" "postgres" ""
}

########################
# Change postgresql.conf to listen in 0.0.0.0
# Arguments:
#   None
# Returns:
#   None
#########################
postgresql_enable_remote_connections() {
    postgresql_set_property "listen_addresses" "*"
}

########################
# Check if a given configuration file was mounted externally
# Globals:
#   POSTGRESQL_*
# Arguments:
#   $1 - Filename
# Returns:
#   1 if the file was mounted externally, 0 otherwise
#########################
postgresql_is_file_external() {
    local -r filename=$1
    if [[ -d "$POSTGRESQL_MOUNTED_CONF_DIR" ]] && [[ -f "$POSTGRESQL_MOUNTED_CONF_DIR"/"$filename" ]]; then
        return 0
    else
        return 1
    fi
}

########################
# Remove flags and postmaster files from a previous run (case of container restart)
# Globals:
#   POSTGRESQL_*
# Arguments:
#   None
# Returns:
#   None
#########################
postgresql_clean_from_restart() {

    local -a files=(
        "$POSTGRESQL_DATA_DIR"/postmaster.pid
        "$POSTGRESQL_DATA_DIR"/standby.signal
    )

    # Enable recovery only when POSTGRESQL_PERFORM_RESTORE feature flag is set
    if ! is_boolean_yes "$POSTGRESQL_PERFORM_RESTORE" ; then
        files+=("$POSTGRESQL_DATA_DIR"/recovery.signal)
    fi

    for file in "${files[@]}"; do
        if [[ -f "$file" ]]; then
            info "Cleaning stale $file file"
            rm "$file"
        fi
    done
}

########################
# Ensure PostgreSQL is initialized
# Globals:
#   POSTGRESQL_*
# Arguments:
#   $1 - skip_replication configuration. Boolean, default false
# Returns:
#   None
#########################
postgresql_initialize() {
    local -r skip_replication=${1:-false}
    info "Initializing PostgreSQL database..."

    # This fixes an issue where the trap would kill the entrypoint.sh, if a PID was left over from a previous run
    # Exec replaces the process without creating a new one, and when the container is restarted it may have the same PID
    rm -f "$POSTGRESQL_PID_FILE"

    # User injected custom configuration
    if [[ -d "$POSTGRESQL_MOUNTED_CONF_DIR" ]] && compgen -G "$POSTGRESQL_MOUNTED_CONF_DIR"/* >/dev/null; then
        debug "Copying files from $POSTGRESQL_MOUNTED_CONF_DIR to $POSTGRESQL_CONF_DIR"
        cp -fr "$POSTGRESQL_MOUNTED_CONF_DIR"/. "$POSTGRESQL_CONF_DIR"
    fi
    local create_conf_file=yes
    local create_pghba_file=yes

    if postgresql_is_file_external "postgresql.conf"; then
        info "Custom configuration $POSTGRESQL_CONF_FILE detected"
        create_conf_file=no
    fi

    if postgresql_is_file_external "pg_hba.conf" && is_boolean_yes "$POSTGRESQL_USE_CUSTOM_PGHBA_INITIALIZATION"; then
        info "Custom configuration $POSTGRESQL_PGHBA_FILE detected"
        create_pghba_file=no
    fi

    debug "Ensuring expected directories/files exist..."
    for dir in "$POSTGRESQL_TMP_DIR" "$POSTGRESQL_LOG_DIR" "$POSTGRESQL_DATA_DIR"; do
        ensure_dir_exists "$dir"
        am_i_root && chown "$POSTGRESQL_DAEMON_USER:$POSTGRESQL_DAEMON_GROUP" "$dir"
    done
    am_i_root && find "$POSTGRESQL_DATA_DIR" -mindepth 1 -maxdepth 1 -not -name ".snapshot" -not -name "lost+found" -exec chown -R "$POSTGRESQL_DAEMON_USER:$POSTGRESQL_DAEMON_GROUP" {} \;
    chmod u+rwx "$POSTGRESQL_DATA_DIR" || warn "Lack of permissions on data directory!"
    chmod go-rwx "$POSTGRESQL_DATA_DIR" || warn "Lack of permissions on data directory!"

    is_boolean_yes "$POSTGRESQL_ALLOW_REMOTE_CONNECTIONS" && is_boolean_yes "$create_pghba_file" && postgresql_create_pghba && postgresql_allow_local_connection
    # Configure port
    postgresql_set_property "port" "$POSTGRESQL_PORT_NUMBER"
    is_empty_value "$POSTGRESQL_DEFAULT_TOAST_COMPRESSION" || postgresql_set_property "default_toast_compression" "$POSTGRESQL_DEFAULT_TOAST_COMPRESSION"
    is_empty_value "$POSTGRESQL_PASSWORD_ENCRYPTION" || postgresql_set_property "password_encryption" "$POSTGRESQL_PASSWORD_ENCRYPTION"
    if ! is_dir_empty "$POSTGRESQL_DATA_DIR"; then
        info "Deploying PostgreSQL with persisted data..."
        export POSTGRESQL_FIRST_BOOT="no"
        is_boolean_yes "$create_pghba_file" && postgresql_restrict_pghba
        is_boolean_yes "$create_conf_file" && postgresql_configure_replication_parameters
        is_boolean_yes "$create_conf_file" && postgresql_configure_fsync
        is_boolean_yes "$create_conf_file" && is_boolean_yes "$POSTGRESQL_ENABLE_TLS" && postgresql_configure_tls
        [[ "$POSTGRESQL_REPLICATION_MODE" = "master" ]] && [[ -n "$POSTGRESQL_REPLICATION_USER" ]] && is_boolean_yes "$create_pghba_file" && ! $skip_replication && postgresql_add_replication_to_pghba
        [[ "$POSTGRESQL_REPLICATION_MODE" = "master" ]] && is_boolean_yes "$create_pghba_file" && ! $skip_replication && postgresql_configure_synchronous_replication
        [[ "$POSTGRESQL_REPLICATION_MODE" = "slave" ]] && ! $skip_replication && postgresql_configure_recovery
    else
        if [[ "$POSTGRESQL_REPLICATION_MODE" = "master" ]]; then
            postgresql_master_init_db
            postgresql_start_bg "false"
            [[ -n "${POSTGRESQL_DATABASE}" ]] && [[ "$POSTGRESQL_DATABASE" != "postgres" ]] && postgresql_create_custom_database
            if [[ "$POSTGRESQL_USERNAME" = "postgres" ]]; then
                postgresql_alter_postgres_user "$POSTGRESQL_PASSWORD"
            else
                if [[ -n "$POSTGRESQL_POSTGRES_PASSWORD" ]]; then
                    postgresql_alter_postgres_user "$POSTGRESQL_POSTGRES_PASSWORD"
                fi
                postgresql_create_admin_user
            fi
            is_boolean_yes "$create_pghba_file" && postgresql_restrict_pghba
            [[ -n "$POSTGRESQL_REPLICATION_USER" ]] && ! $skip_replication && postgresql_create_replication_user
            is_boolean_yes "$create_conf_file" && ! $skip_replication && postgresql_configure_replication_parameters
            is_boolean_yes "$create_pghba_file" && ! $skip_replication &&  postgresql_configure_synchronous_replication
            is_boolean_yes "$create_conf_file" && postgresql_configure_fsync
            is_boolean_yes "$create_conf_file" && is_boolean_yes "$POSTGRESQL_ENABLE_TLS" && postgresql_configure_tls
            [[ -n "$POSTGRESQL_REPLICATION_USER" ]] && is_boolean_yes "$create_pghba_file" && ! $skip_replication &&  postgresql_add_replication_to_pghba
        else
            postgresql_slave_init_db
            is_boolean_yes "$create_pghba_file" && postgresql_restrict_pghba
            is_boolean_yes "$create_conf_file" && ! $skip_replication &&  postgresql_configure_replication_parameters
            is_boolean_yes "$create_conf_file" && postgresql_configure_fsync
            is_boolean_yes "$create_conf_file" && is_boolean_yes "$POSTGRESQL_ENABLE_TLS" && postgresql_configure_tls
            ! $skip_replication && postgresql_configure_recovery
        fi
    fi
    # TLS Modifications on pghba need to be performed after properly configuring postgresql.conf file
    is_boolean_yes "$create_pghba_file" && is_boolean_yes "$POSTGRESQL_ENABLE_TLS" && [[ -n $POSTGRESQL_TLS_CA_FILE ]] && postgresql_tls_auth_configuration

    is_boolean_yes "$create_conf_file" && [[ -n "$POSTGRESQL_SHARED_PRELOAD_LIBRARIES" ]] && postgresql_set_property "shared_preload_libraries" "$POSTGRESQL_SHARED_PRELOAD_LIBRARIES"
    is_boolean_yes "$create_conf_file" && postgresql_configure_logging
    is_boolean_yes "$create_conf_file" && postgresql_configure_connections
    is_boolean_yes "$create_conf_file" && postgresql_configure_timezone

    # Delete conf files generated on first run
    rm -f "$POSTGRESQL_DATA_DIR"/postgresql.conf "$POSTGRESQL_DATA_DIR"/pg_hba.conf

    # Stop postgresql
    postgresql_stop
}

########################
# Run custom pre-initialization scripts
# Globals:
#   POSTGRESQL_*
# Arguments:
#   None
# Returns:
#   None
#########################
postgresql_custom_pre_init_scripts() {
    info "Loading custom pre-init scripts..."
    if [[ -d "$POSTGRESQL_PREINITSCRIPTS_DIR" ]] && [[ -n $(find "$POSTGRESQL_PREINITSCRIPTS_DIR/" -type f -name "*.sh") ]]; then
        info "Loading user's custom files from $POSTGRESQL_PREINITSCRIPTS_DIR ..."
        find "$POSTGRESQL_PREINITSCRIPTS_DIR/" -type f -name "*.sh" | sort | while read -r f; do
            if [[ -x "$f" ]]; then
                debug "Executing $f"
                "$f"
            else
                debug "Sourcing $f"
                . "$f"
            fi
        done
    fi
}

########################
# Run custom initialization scripts
# Globals:
#   POSTGRESQL_*
# Arguments:
#   None
# Returns:
#   None
#########################
postgresql_custom_init_scripts() {
    info "Loading custom scripts..."
    if [[ -d "$POSTGRESQL_INITSCRIPTS_DIR" ]] && [[ -n $(find "$POSTGRESQL_INITSCRIPTS_DIR/" -type f -regex ".*\.\(sh\|sql\|sql.gz\)") ]] && [[ ! -f "$POSTGRESQL_VOLUME_DIR/.user_scripts_initialized" ]]; then
        info "Loading user's custom files from $POSTGRESQL_INITSCRIPTS_DIR ..."
        postgresql_start_bg "false"
        find "$POSTGRESQL_INITSCRIPTS_DIR/" -type f -regex ".*\.\(sh\|sql\|sql.gz\)" | sort | while read -r f; do
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
            *.sql)
                debug "Executing $f"
                postgresql_execute "$POSTGRESQL_DATABASE" "$POSTGRESQL_INITSCRIPTS_USERNAME" "$POSTGRESQL_INITSCRIPTS_PASSWORD" <"$f"
                ;;
            *.sql.gz)
                debug "Executing $f"
                gunzip -c "$f" | postgresql_execute "$POSTGRESQL_DATABASE" "$POSTGRESQL_INITSCRIPTS_USERNAME" "$POSTGRESQL_INITSCRIPTS_PASSWORD"
                ;;
            *) debug "Ignoring $f" ;;
            esac
        done
        touch "$POSTGRESQL_VOLUME_DIR"/.user_scripts_initialized
    fi
}

########################
# Stop PostgreSQL
# Globals:
#   POSTGRESQL_*
# Arguments:
#   None
# Returns:
#   None
#########################
postgresql_stop() {
    local -r -a cmd=("pg_ctl" "stop" "-w" "-D" "$POSTGRESQL_DATA_DIR" "-m" "$POSTGRESQL_SHUTDOWN_MODE" "-t" "$POSTGRESQL_PGCTLTIMEOUT")
    if [[ -f "$POSTGRESQL_PID_FILE" ]]; then
        info "Stopping PostgreSQL..."
        if am_i_root; then
            run_as_user "$POSTGRESQL_DAEMON_USER" "${cmd[@]}"
        else
            "${cmd[@]}"
        fi
    fi
}

########################
# Start PostgreSQL and wait until it is ready
# Globals:
#   POSTGRESQL_*
# Arguments:
#   $1 - Enable logs for PostgreSQL. Default: false
# Returns:
#   None
#########################
postgresql_start_bg() {
    local -r pg_logs=${1:-false}
    local -r pg_ctl_flags=("-W" "-D" "$POSTGRESQL_DATA_DIR" "-l" "$POSTGRESQL_LOG_FILE" "-o" "--config-file=$POSTGRESQL_CONF_FILE --external_pid_file=$POSTGRESQL_PID_FILE --hba_file=$POSTGRESQL_PGHBA_FILE")
    info "Starting PostgreSQL in background..."
    if is_postgresql_running; then
        return 0
    fi
    local pg_ctl_cmd=()
    if am_i_root; then
        pg_ctl_cmd+=("run_as_user" "$POSTGRESQL_DAEMON_USER")
    fi
    pg_ctl_cmd+=("$POSTGRESQL_BIN_DIR"/pg_ctl)
    if [[ "${BITNAMI_DEBUG:-false}" = true ]] || [[ $pg_logs = true ]]; then
        "${pg_ctl_cmd[@]}" "start" "${pg_ctl_flags[@]}"
    else
        "${pg_ctl_cmd[@]}" "start" "${pg_ctl_flags[@]}" >/dev/null 2>&1
    fi
    local pg_isready_args=("-U" "postgres" "-p" "$POSTGRESQL_PORT_NUMBER" "-h" "127.0.0.1")
    local counter=$POSTGRESQL_INIT_MAX_TIMEOUT
    while ! "$POSTGRESQL_BIN_DIR"/pg_isready "${pg_isready_args[@]}" >/dev/null 2>&1; do
        sleep 1
        counter=$((counter - 1))
        if ((counter <= 0)); then
            error "PostgreSQL is not ready after $POSTGRESQL_INIT_MAX_TIMEOUT seconds"
            exit 1
        fi
    done
}

########################
# Check if PostgreSQL is running
# Globals:
#   POSTGRESQL_*
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_postgresql_running() {
    local pid
    pid="$(get_pid_from_file "$POSTGRESQL_PID_FILE")"

    if [[ -z "$pid" ]]; then
        false
    else
        is_service_running "$pid"
    fi
}

########################
# Check if PostgreSQL is not running
# Globals:
#   POSTGRESQL_*
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_postgresql_not_running() {
    ! is_postgresql_running
}

########################
# Initialize master node database by running initdb
# Globals:
#   POSTGRESQL_*
# Arguments:
#   None
# Returns:
#   Boolean
#########################
postgresql_master_init_db() {
    local envExtraFlags=()
    local initdb_args=()
    if [[ -n "${POSTGRESQL_INITDB_ARGS}" ]]; then
        read -r -a envExtraFlags <<<"$POSTGRESQL_INITDB_ARGS"
        initdb_args+=("${envExtraFlags[@]}")
    fi
    if [[ -n "$POSTGRESQL_INITDB_WAL_DIR" ]]; then
        ensure_dir_exists "$POSTGRESQL_INITDB_WAL_DIR"
        am_i_root && chown "$POSTGRESQL_DAEMON_USER:$POSTGRESQL_DAEMON_GROUP" "$POSTGRESQL_INITDB_WAL_DIR"
        initdb_args+=("--waldir" "$POSTGRESQL_INITDB_WAL_DIR")
    fi
    local initdb_cmd=()
    if am_i_root; then
        initdb_cmd+=("run_as_user" "$POSTGRESQL_DAEMON_USER")
    fi
    initdb_cmd+=("$POSTGRESQL_BIN_DIR/initdb")
    if [[ -n "${initdb_args[*]:-}" ]]; then
        info "Initializing PostgreSQL with ${initdb_args[*]} extra initdb arguments"
        if [[ "${BITNAMI_DEBUG:-false}" = true ]]; then
            "${initdb_cmd[@]}" -E UTF8 -D "$POSTGRESQL_DATA_DIR" -U "postgres" "${initdb_args[@]}"
        else
            "${initdb_cmd[@]}" -E UTF8 -D "$POSTGRESQL_DATA_DIR" -U "postgres" "${initdb_args[@]}" >/dev/null 2>&1
        fi
    elif [[ "${BITNAMI_DEBUG:-false}" = true ]]; then
        "${initdb_cmd[@]}" -E UTF8 -D "$POSTGRESQL_DATA_DIR" -U "postgres"
    else
        "${initdb_cmd[@]}" -E UTF8 -D "$POSTGRESQL_DATA_DIR" -U "postgres" >/dev/null 2>&1
    fi
}

########################
# Initialize slave node by running pg_basebackup
# Globals:
#   POSTGRESQL_*
# Arguments:
#   None
# Returns:
#   Boolean
#########################
postgresql_slave_init_db() {
    info "Waiting for replication master to accept connections (${POSTGRESQL_INIT_MAX_TIMEOUT} timeout)..."
    local -r check_args=("-U" "$POSTGRESQL_REPLICATION_USER" "-h" "$POSTGRESQL_MASTER_HOST" "-p" "$POSTGRESQL_MASTER_PORT_NUMBER" "-d" "postgres")
    local check_cmd=()
    if am_i_root; then
        check_cmd=("run_as_user" "$POSTGRESQL_DAEMON_USER")
    fi
    check_cmd+=("$POSTGRESQL_BIN_DIR"/pg_isready)
    local ready_counter=$POSTGRESQL_INIT_MAX_TIMEOUT

    while ! PGPASSWORD=$POSTGRESQL_REPLICATION_PASSWORD "${check_cmd[@]}" "${check_args[@]}"; do
        sleep 1
        ready_counter=$((ready_counter - 1))
        if ((ready_counter <= 0)); then
            error "PostgreSQL master is not ready after $POSTGRESQL_INIT_MAX_TIMEOUT seconds"
            exit 1
        fi

    done
    info "Replicating the initial database"
    local -r backup_args=("-D" "$POSTGRESQL_DATA_DIR" "-U" "$POSTGRESQL_REPLICATION_USER" "-h" "$POSTGRESQL_MASTER_HOST" "-p" "$POSTGRESQL_MASTER_PORT_NUMBER" "-X" "stream" "-w" "-v" "-P")
    local backup_cmd=()
    if am_i_root; then
        backup_cmd+=("run_as_user" "$POSTGRESQL_DAEMON_USER")
    fi
    backup_cmd+=("$POSTGRESQL_BIN_DIR"/pg_basebackup)
    local replication_counter=$POSTGRESQL_INIT_MAX_TIMEOUT
    while ! PGPASSWORD=$POSTGRESQL_REPLICATION_PASSWORD "${backup_cmd[@]}" "${backup_args[@]}"; do
        debug "Backup command failed. Sleeping and trying again"
        sleep 1
        replication_counter=$((replication_counter - 1))
        if ((replication_counter <= 0)); then
            error "Slave replication failed after trying for $POSTGRESQL_INIT_MAX_TIMEOUT seconds"
            exit 1
        fi
    done
}

########################
# Get postgresql replication user conninfo password method
# Globals:
#   POSTGRESQL_*
# Arguments:
#   None
# Returns:
#   String
#########################
postgresql_replication_get_conninfo_password() {
    if is_boolean_yes "$POSTGRESQL_REPLICATION_USE_PASSFILE"; then
        echo "passfile=${POSTGRESQL_REPLICATION_PASSFILE_PATH}"
    else
        echo "password=${POSTGRESQL_REPLICATION_PASSWORD//\&/\\&}"
    fi
}

########################
# Create recovery.conf in slave node
# Globals:
#   POSTGRESQL_*
# Arguments:
#   None
# Returns:
#   Boolean
#########################
postgresql_configure_recovery() {
    info "Setting up streaming replication slave..."

    local -r psql_major_version="$(postgresql_get_major_version)"
    postgresql_set_property "primary_conninfo" "host=${POSTGRESQL_MASTER_HOST} port=${POSTGRESQL_MASTER_PORT_NUMBER} user=${POSTGRESQL_REPLICATION_USER} $(postgresql_replication_get_conninfo_password) application_name=${POSTGRESQL_CLUSTER_APP_NAME}" "$POSTGRESQL_CONF_FILE"
    ((psql_major_version < 16)) && postgresql_set_property "promote_trigger_file" "/tmp/postgresql.trigger.${POSTGRESQL_MASTER_PORT_NUMBER}" "$POSTGRESQL_CONF_FILE"
    touch "$POSTGRESQL_DATA_DIR"/standby.signal
}

########################
# Configure logging parameters
# Globals:
#   POSTGRESQL_*
# Arguments:
#   None
# Returns:
#   Boolean
#########################
postgresql_configure_logging() {
    [[ -n "$POSTGRESQL_PGAUDIT_LOG" ]] && postgresql_set_property "pgaudit.log" "$POSTGRESQL_PGAUDIT_LOG"
    [[ -n "$POSTGRESQL_PGAUDIT_LOG_CATALOG" ]] && postgresql_set_property "pgaudit.log_catalog" "$POSTGRESQL_PGAUDIT_LOG_CATALOG"
    [[ -n "$POSTGRESQL_PGAUDIT_LOG_PARAMETER" ]] && postgresql_set_property "pgaudit.log_parameter" "$POSTGRESQL_PGAUDIT_LOG_PARAMETER"
    [[ -n "$POSTGRESQL_LOG_CONNECTIONS" ]] && postgresql_set_property "log_connections" "$POSTGRESQL_LOG_CONNECTIONS"
    [[ -n "$POSTGRESQL_LOG_DISCONNECTIONS" ]] && postgresql_set_property "log_disconnections" "$POSTGRESQL_LOG_DISCONNECTIONS"
    [[ -n "$POSTGRESQL_LOG_HOSTNAME" ]] && postgresql_set_property "log_hostname" "$POSTGRESQL_LOG_HOSTNAME"
    [[ -n "$POSTGRESQL_CLIENT_MIN_MESSAGES" ]] && postgresql_set_property "client_min_messages" "$POSTGRESQL_CLIENT_MIN_MESSAGES"
    [[ -n "$POSTGRESQL_LOG_LINE_PREFIX" ]] && postgresql_set_property "log_line_prefix" "$POSTGRESQL_LOG_LINE_PREFIX"
    ([[ -n "$POSTGRESQL_LOG_TIMEZONE" ]] && postgresql_set_property "log_timezone" "$POSTGRESQL_LOG_TIMEZONE") || true
}

########################
# Configure connection parameters
# Globals:
#   POSTGRESQL_*
# Arguments:
#   None
# Returns:
#   Boolean
#########################
postgresql_configure_connections() {
    [[ -n "$POSTGRESQL_MAX_CONNECTIONS" ]] && postgresql_set_property "max_connections" "$POSTGRESQL_MAX_CONNECTIONS"
    [[ -n "$POSTGRESQL_TCP_KEEPALIVES_IDLE" ]] && postgresql_set_property "tcp_keepalives_idle" "$POSTGRESQL_TCP_KEEPALIVES_IDLE"
    [[ -n "$POSTGRESQL_TCP_KEEPALIVES_INTERVAL" ]] && postgresql_set_property "tcp_keepalives_interval" "$POSTGRESQL_TCP_KEEPALIVES_INTERVAL"
    [[ -n "$POSTGRESQL_TCP_KEEPALIVES_COUNT" ]] && postgresql_set_property "tcp_keepalives_count" "$POSTGRESQL_TCP_KEEPALIVES_COUNT"
    ([[ -n "$POSTGRESQL_STATEMENT_TIMEOUT" ]] && postgresql_set_property "statement_timeout" "$POSTGRESQL_STATEMENT_TIMEOUT") || true
}

########################
# Configure timezone
# Globals:
#   POSTGRESQL_*
# Arguments:
#   None
# Returns:
#   Boolean
#########################
postgresql_configure_timezone() {
    ([[ -n "$POSTGRESQL_TIMEZONE" ]] && postgresql_set_property "timezone" "$POSTGRESQL_TIMEZONE") || true
}

########################
# Remove pg_hba.conf lines based on filter
# Globals:
#   POSTGRESQL_*
# Arguments:
#   None
# Returns:
#   Boolean
#########################
postgresql_remove_pghba_lines() {
    for filter in ${POSTGRESQL_PGHBA_REMOVE_FILTERS//,/ }; do
        result="$(sed -E "/${filter}/d" "$POSTGRESQL_PGHBA_FILE")"
        echo "$result" >"$POSTGRESQL_PGHBA_FILE"
    done
}

# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC2148

########################
# Return PostgreSQL major version
# Globals:
#   POSTGRESQL_*
# Arguments:
#   None
# Returns:
#   String
#########################
postgresql_get_major_version() {
    psql --version | grep -oE "[0-9]+\.[0-9]+" | grep -oE "^[0-9]+"
}

########################
# Gets an environment variable name based on the suffix
# Arguments:
#   $1 - environment variable suffix
# Returns:
#   environment variable name
#########################
get_env_var_value() {
    local env_var_suffix="${1:?missing suffix}"
    local env_var_name
    for env_var_prefix in POSTGRESQL POSTGRESQL_CLIENT; do
        env_var_name="${env_var_prefix}_${env_var_suffix}"
        if [[ -n "${!env_var_name:-}" ]]; then
            echo "${!env_var_name}"
            break
        fi
    done
}

########################
# Execute an arbitrary query/queries against the running PostgreSQL service and print the output
# Stdin:
#   Query/queries to execute
# Globals:
#   BITNAMI_DEBUG
#   POSTGRESQL_*
# Arguments:
#   $1 - Database where to run the queries
#   $2 - User to run queries
#   $3 - Password
#   $4 - Extra options (eg. -tA)
# Returns:
#   None
#########################
postgresql_execute_print_output() {
    local -r db="${1:-}"
    local -r user="${2:-postgres}"
    local -r pass="${3:-}"
    local opts
    read -r -a opts <<<"${@:4}"

    local args=("-U" "$user" "-p" "${POSTGRESQL_PORT_NUMBER:-5432}" "-h" "127.0.0.1")
    [[ -n "$db" ]] && args+=("-d" "$db")
    [[ "${#opts[@]}" -gt 0 ]] && args+=("${opts[@]}")

    # Execute the Query/queries from stdin
    PGPASSWORD=$pass psql "${args[@]}"
}

########################
# Execute an arbitrary query/queries against the running PostgreSQL service
# Stdin:
#   Query/queries to execute
# Globals:
#   BITNAMI_DEBUG
#   POSTGRESQL_*
# Arguments:
#   $1 - Database where to run the queries
#   $2 - User to run queries
#   $3 - Password
#   $4 - Extra options (eg. -tA)
# Returns:
#   None
#########################
postgresql_execute() {
    if [[ "${BITNAMI_DEBUG:-false}" = true ]]; then
        "postgresql_execute_print_output" "$@"
    elif [[ "${NO_ERRORS:-false}" = true ]]; then
        "postgresql_execute_print_output" "$@" 2>/dev/null
    else
        "postgresql_execute_print_output" "$@" >/dev/null 2>&1
    fi
}

########################
# Execute an arbitrary query/queries against a remote PostgreSQL service and print to stdout
# Stdin:
#   Query/queries to execute
# Globals:
#   BITNAMI_DEBUG
#   DB_*
# Arguments:
#   $1 - Remote PostgreSQL service hostname
#   $2 - Remote PostgreSQL service port
#   $3 - Database where to run the queries
#   $4 - User to run queries
#   $5 - Password
#   $6 - Extra options (eg. -tA)
# Returns:
#   None
postgresql_remote_execute_print_output() {
    local -r hostname="${1:?hostname is required}"
    local -r port="${2:?port is required}"
    local -a args=("-h" "$hostname" "-p" "$port")
    shift 2
    "postgresql_execute_print_output" "$@" "${args[@]}"
}

########################
# Execute an arbitrary query/queries against a remote PostgreSQL service
# Stdin:
#   Query/queries to execute
# Globals:
#   BITNAMI_DEBUG
#   DB_*
# Arguments:
#   $1 - Remote PostgreSQL service hostname
#   $2 - Remote PostgreSQL service port
#   $3 - Database where to run the queries
#   $4 - User to run queries
#   $5 - Password
#   $6 - Extra options (eg. -tA)
# Returns:
#   None
postgresql_remote_execute() {
    if [[ "${BITNAMI_DEBUG:-false}" = true ]]; then
        "postgresql_remote_execute_print_output" "$@"
    elif [[ "${NO_ERRORS:-false}" = true ]]; then
        "postgresql_remote_execute_print_output" "$@" 2>/dev/null
    else
        "postgresql_remote_execute_print_output" "$@" >/dev/null 2>&1
    fi
}

########################
# Optionally create the given database user
# Flags:
#   -p|--password - database password
#   --host - database host
#   --port - database port
# Arguments:
#   $1 - user
# Returns:
#   None
#########################
postgresql_ensure_user_exists() {
    local -r user="${1:?user is missing}"
    local password=""
    # For accessing an external database
    local db_host=""
    local db_port=""

    # Validate arguments
    shift 1
    while [ "$#" -gt 0 ]; do
        case "$1" in
        -p | --password)
            shift
            password="${1:?missing password}"
            ;;
        --host)
            shift
            db_host="${1:?missing database host}"
            ;;
        --port)
            shift
            db_port="${1:?missing database port}"
            ;;
        *)
            echo "Invalid command line flag $1" >&2
            return 1
            ;;
        esac
        shift
    done

    local -a postgresql_execute_cmd=("postgresql_execute")
    [[ -n "$db_host" && -n "$db_port" ]] && postgresql_execute_cmd=("postgresql_remote_execute" "$db_host" "$db_port")
    local -a postgresql_execute_flags=("postgres" "$(get_env_var_value POSTGRES_USER)" "$(get_env_var_value POSTGRES_PASSWORD)")

    "${postgresql_execute_cmd[@]}" "${postgresql_execute_flags[@]}" <<EOF
DO
\$do\$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_catalog.pg_roles WHERE rolname = '${user}'
   ) THEN
      CREATE ROLE "${user}" LOGIN PASSWORD '${password}';
   END IF;
END
\$do\$;
EOF
}

########################
# Ensure a user has all privileges to access a database
# Arguments:
#   $1 - database name
#   $2 - database user
#   $3 - database host (optional)
#   $4 - database port (optional)
# Returns:
#   None
#########################
postgresql_ensure_user_has_database_privileges() {
    local -r user="${1:?user is required}"
    local -r database="${2:?db is required}"
    local -r db_host="${3:-}"
    local -r db_port="${4:-}"

    local -a postgresql_execute_cmd=("postgresql_execute")
    [[ -n "$db_host" && -n "$db_port" ]] && postgresql_execute_cmd=("postgresql_remote_execute" "$db_host" "$db_port")
    local -a postgresql_execute_flags=("postgres" "$(get_env_var_value POSTGRES_USER)" "$(get_env_var_value POSTGRES_PASSWORD)")

    debug "Providing privileges to username ${user} on database ${database}"
    "${postgresql_execute_cmd[@]}" "${postgresql_execute_flags[@]}" <<EOF
GRANT ALL PRIVILEGES ON DATABASE "${database}" TO "${user}";
ALTER DATABASE "${database}" OWNER TO "${user}";
EOF
}

########################
# Optionally create the given database, and then optionally give a user
# full privileges on the database.
# Flags:
#   -u|--user - database user
#   --host - database host
#   --port - database port
# Arguments:
#   $1 - database name
# Returns:
#   None
#########################
postgresql_ensure_database_exists() {
    local -r database="${1:?database is missing}"
    local user=""
    # For accessing an external database
    local db_host=""
    local db_port=""

    # Validate arguments
    shift 1
    while [ "$#" -gt 0 ]; do
        case "$1" in
        -u | --user)
            shift
            user="${1:?missing database user}"
            ;;
        --host)
            shift
            db_host="${1:?missing database host}"
            ;;
        --port)
            shift
            db_port="${1:?missing database port}"
            ;;
        *)
            echo "Invalid command line flag $1" >&2
            return 1
            ;;
        esac
        shift
    done

    local -a postgresql_execute_cmd=("postgresql_execute")
    [[ -n "$db_host" && -n "$db_port" ]] && postgresql_execute_cmd=("postgresql_remote_execute" "$db_host" "$db_port")
    local -a postgresql_execute_flags=("postgres" "$(get_env_var_value POSTGRES_USER)" "$(get_env_var_value POSTGRES_PASSWORD)")

    "${postgresql_execute_cmd[@]}" "${postgresql_execute_flags[@]}" <<EOF
SELECT 'CREATE DATABASE "${database}"'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '${database}')\gexec
EOF
    if [[ -n "$user" ]]; then
        local -a grant_flags=("$user" "$database")
        [[ -n "$db_host" ]] && grant_flags+=("$db_host")
        [[ -n "$db_port" ]] && grant_flags+=("$db_port")
        postgresql_ensure_user_has_database_privileges "${grant_flags[@]}"
    fi
}

########################
# Retrieves the WAL directory in use by PostgreSQL / to use if not initialized yet
# Globals:
#   REPMGR_*
# Arguments:
#   None
# Returns:
#   the path to the WAL directory, or empty if not set
#########################
postgresql_get_waldir() {
    if [[ -L "${POSTGRESQL_DATA_DIR}/pg_wal" && -d "${POSTGRESQL_DATA_DIR}/pg_wal" ]]; then
        readlink -f "${POSTGRESQL_DATA_DIR}/pg_wal"
    else
        # Uninitialized - using value from $POSTGRESQL_INITDB_WAL_DIR if set
        echo "$POSTGRESQL_INITDB_WAL_DIR"
    fi
}
