#!/bin/bash
#
# Bitnami PostgreSQL library

# shellcheck disable=SC1090
# shellcheck disable=SC1091

# Load Generic Libraries
. /libfile.sh
. /liblog.sh
. /libservice.sh
. /libvalidations.sh


########################
# Overwrite info, debug, warn and error functions (liblog.sh)
########################
postgresql_info() {
    MODULE=postgresql info "${*}"
}
postgresql_debug() {
    MODULE=postgresql debug "${*}"
}
postgresql_warn() {
    MODULE=postgresql warn "${*}"
}
postgresql_error() {
    MODULE=postgresql error "${*}"
}

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
  if ! getent passwd "$(id -u)" &> /dev/null && [ -e "$NSS_WRAPPER_LIB" ]; then
    postgresql_debug "Configuring libnss_wrapper..."
    export LD_PRELOAD="$NSS_WRAPPER_LIB"
    # shellcheck disable=SC2155
    export NSS_WRAPPER_PASSWD="$(mktemp)"
    # shellcheck disable=SC2155
    export NSS_WRAPPER_GROUP="$(mktemp)"
    echo "postgres:x:$(id -u):$(id -g):PostgreSQL:$POSTGRESQL_DATA_DIR:/bin/false" > "$NSS_WRAPPER_PASSWD"
    echo "postgres:x:$(id -g):" > "$NSS_WRAPPER_GROUP"
  fi
}

########################
# Load global variables used on PostgreSQL configuration.
# Globals:
#   POSTGRESQL_*
# Arguments:
#   None
# Returns:
#   Series of exports to be used as 'eval' arguments
#########################
postgresql_env() {
    declare_env_alias() {
      local -r alias="${1:?missing environment variable alias}"
      local -r original="${2:?missing original environment variable}"

      if printenv "${original}" > /dev/null; then
          cat << EOF
export $alias="${!original}"
EOF
      fi
    }

    # Alias created for official PostgreSQL image compatibility
    [[ -z "${POSTGRESQL_DATABASE:-}" ]] && declare_env_alias POSTGRESQL_DATABASE POSTGRES_DB
    [[ -z "${POSTGRESQL_USERNAME:-}" ]] && declare_env_alias POSTGRESQL_USERNAME POSTGRES_USER
    [[ -z "${POSTGRESQL_DATA_DIR:-}" ]] && declare_env_alias POSTGRESQL_DATA_DIR PGDATA

    local -r suffixes=(
      "PASSWORD" "POSTGRES_PASSWORD" "INITDB_WAL_DIR" "INITDB_ARGS" "CLUSTER_APP_NAME"
      "MASTER_HOST" "MASTER_PORT_NUMBER" "NUM_SYNCHRONOUS_REPLICAS"
      "PORT_NUMBER" "REPLICATION_MODE" "REPLICATION_PASSWORD" "REPLICATION_USER" "FSYNC"
      "SYNCHRONOUS_COMMIT_MODE" "PASSWORD_FILE" "POSTGRES_PASSWORD_FILE"
      "REPLICATION_PASSWORD_FILE" "INIT_MAX_TIMEOUT"
    )
    for s in "${suffixes[@]}"; do
      declare_env_alias "POSTGRESQL_${s}" "POSTGRES_${s}"
    done

    # Ensure the image is compatible with Helm chart 3.x.x series
    local -r postgresql_data="${POSTGRESQL_DATA_DIR:-${PGDATA:-}}"
    if [[ -n "${postgresql_data:-}" ]]; then
        if [[ -d "${postgresql_data}/data" ]] || [[ "${postgresql_data}" = "/bitnami/postgresql" ]]; then
            postgresql_warn "Data directory is set with a legacy value, adapting POSTGRESQL_DATA_DIR..."
            postgresql_warn "POSTGRESQL_DATA_DIR set to \"${postgresql_data}/data\"!!"
            cat << EOF
export POSTGRESQL_DATA_DIR="${postgresql_data}/data"
EOF
        fi
    fi

    cat <<"EOF"
# Paths
export POSTGRESQL_VOLUME_DIR="${POSTGRESQL_VOLUME_DIR:-/bitnami/postgresql}"
export POSTGRESQL_DATA_DIR="${POSTGRESQL_DATA_DIR:-$POSTGRESQL_VOLUME_DIR/data}"
export POSTGRESQL_BASE_DIR="/opt/bitnami/postgresql"
export POSTGRESQL_CONF_DIR="$POSTGRESQL_BASE_DIR/conf"
export POSTGRESQL_MOUNTED_CONF_DIR="/bitnami/postgresql/conf"
export POSTGRESQL_CONF_FILE="$POSTGRESQL_CONF_DIR/postgresql.conf"
export POSTGRESQL_PGHBA_FILE="$POSTGRESQL_CONF_DIR/pg_hba.conf"
export POSTGRESQL_RECOVERY_FILE="$POSTGRESQL_DATA_DIR/recovery.conf"
export POSTGRESQL_LOG_DIR="$POSTGRESQL_BASE_DIR/logs"
export POSTGRESQL_LOG_FILE="$POSTGRESQL_LOG_DIR/postgresql.log"
export POSTGRESQL_TMP_DIR="$POSTGRESQL_BASE_DIR/tmp"
export POSTGRESQL_PID_FILE="$POSTGRESQL_TMP_DIR/postgresql.pid"
export POSTGRESQL_BIN_DIR="$POSTGRESQL_BASE_DIR/bin"
export POSTGRESQL_INITSCRIPTS_DIR=/docker-entrypoint-initdb.d
export POSTGRESQL_PREINITSCRIPTS_DIR=/docker-entrypoint-preinitdb.d
export PATH="$POSTGRESQL_BIN_DIR:$PATH"

# Users
export POSTGRESQL_DAEMON_USER="postgresql"
export POSTGRESQL_DAEMON_GROUP="postgresql"

# Version
export POSTGRESQL_VERSION="$(echo "$BITNAMI_IMAGE_VERSION" | grep -oE "^[0-9]+\.[0-9]+\.[0-9]+")"
export POSTGRESQL_MAJOR_VERSION="$(echo "$BITNAMI_IMAGE_VERSION" | grep -oE "^[0-9]+")"

# Settings
export POSTGRESQL_INIT_MAX_TIMEOUT=${POSTGRESQL_INIT_MAX_TIMEOUT:-60}
export POSTGRESQL_CLUSTER_APP_NAME=${POSTGRESQL_CLUSTER_APP_NAME:-walreceiver}
export POSTGRESQL_DATABASE="${POSTGRESQL_DATABASE:-postgres}"
export POSTGRESQL_INITDB_ARGS="${POSTGRESQL_INITDB_ARGS:-}"
export ALLOW_EMPTY_PASSWORD="${ALLOW_EMPTY_PASSWORD:-no}"
export POSTGRESQL_INITDB_WAL_DIR="${POSTGRESQL_INITDB_WAL_DIR:-}"
export POSTGRESQL_MASTER_HOST="${POSTGRESQL_MASTER_HOST:-}"
export POSTGRESQL_MASTER_PORT_NUMBER="${POSTGRESQL_MASTER_PORT_NUMBER:-5432}"
export POSTGRESQL_NUM_SYNCHRONOUS_REPLICAS="${POSTGRESQL_NUM_SYNCHRONOUS_REPLICAS:-0}"
export POSTGRESQL_PORT_NUMBER="${POSTGRESQL_PORT_NUMBER:-5432}"
export POSTGRESQL_REPLICATION_MODE="${POSTGRESQL_REPLICATION_MODE:-master}"
export POSTGRESQL_REPLICATION_USER="${POSTGRESQL_REPLICATION_USER:-}"
export POSTGRESQL_SYNCHRONOUS_COMMIT_MODE="${POSTGRESQL_SYNCHRONOUS_COMMIT_MODE:-on}"
export POSTGRESQL_FSYNC="${POSTGRESQL_FSYNC:-on}"
export POSTGRESQL_USERNAME="${POSTGRESQL_USERNAME:-postgres}"
export POSTGRESQL_ENABLE_LDAP="${POSTGRESQL_ENABLE_LDAP:-no}"
export POSTGRESQL_LDAP_URL="${POSTGRESQL_LDAP_URL:-}"
export POSTGRESQL_LDAP_PREFIX="${POSTGRESQL_LDAP_PREFIX:-}"
export POSTGRESQL_LDAP_SUFFIX="${POSTGRESQL_LDAP_SUFFIX:-}"
export POSTGRESQL_LDAP_SERVER="${POSTGRESQL_LDAP_SERVER:-}"
export POSTGRESQL_LDAP_PORT="${POSTGRESQL_LDAP_PORT:-}"
export POSTGRESQL_LDAP_SCHEME="${POSTGRESQL_LDAP_SCHEME:-}"
export POSTGRESQL_LDAP_TLS="${POSTGRESQL_LDAP_TLS:-}"
export POSTGRESQL_LDAP_BASE_DN="${POSTGRESQL_LDAP_BASE_DN:-}"
export POSTGRESQL_LDAP_BIND_DN="${POSTGRESQL_LDAP_BIND_DN:-}"
export POSTGRESQL_LDAP_BIND_PASSWORD="${POSTGRESQL_LDAP_BIND_PASSWORD:-}"
export POSTGRESQL_LDAP_SEARCH_ATTR="${POSTGRESQL_LDAP_SEARCH_ATTR:-}"
export POSTGRESQL_LDAP_SEARCH_FILTER="${POSTGRESQL_LDAP_SEARCH_FILTER:-}"

# Internal
export POSTGRESQL_FIRST_BOOT="yes"
EOF
    if [[ -z "${POSTGRESQL_INITSCRIPTS_USERNAME:-}" ]]; then
        cat <<"EOF"
export POSTGRESQL_INITSCRIPTS_USERNAME="${POSTGRESQL_USERNAME}"
EOF
    else
        cat <<"EOF"
export POSTGRESQL_INITSCRIPTS_USERNAME="${POSTGRESQL_INITSCRIPTS_USERNAME}"
EOF
    fi
    if [[ -f "${POSTGRESQL_PASSWORD_FILE:-}" ]]; then
        cat <<"EOF"
export POSTGRESQL_PASSWORD="$(< "${POSTGRESQL_PASSWORD_FILE}")"
EOF
    else
        cat <<"EOF"
export POSTGRESQL_PASSWORD="${POSTGRESQL_PASSWORD:-}"
EOF
    fi
    if [[ -f "${POSTGRESQL_REPLICATION_PASSWORD_FILE:-}" ]]; then
        cat <<"EOF"
export POSTGRESQL_REPLICATION_PASSWORD="$(< "${POSTGRESQL_REPLICATION_PASSWORD_FILE}")"
EOF
    else
        cat <<"EOF"
export POSTGRESQL_REPLICATION_PASSWORD="${POSTGRESQL_REPLICATION_PASSWORD:-}"
EOF
    fi
    if [[ -f "${POSTGRESQL_POSTGRES_PASSWORD_FILE:-}" ]]; then
        cat <<"EOF"
export POSTGRESQL_POSTGRES_PASSWORD="$(< "${POSTGRESQL_POSTGRES_PASSWORD_FILE}")"
EOF
    else
        cat <<"EOF"
export POSTGRESQL_POSTGRES_PASSWORD="${POSTGRESQL_POSTGRES_PASSWORD:-}"
EOF
    fi
    if [[ -z "${POSTGRESQL_INITSCRIPTS_PASSWORD:-}" ]]; then
        cat <<"EOF"
export POSTGRESQL_INITSCRIPTS_PASSWORD="${POSTGRESQL_PASSWORD:-}"
EOF
    else
        cat <<"EOF"
export POSTGRESQL_INITSCRIPTS_PASSWORD="${POSTGRESQL_INITSCRIPTS_PASSWORD:-}"
EOF
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
    postgresql_info "Validating settings in POSTGRESQL_* env vars.."
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        postgresql_error "$1"
        error_code=1
    }

    empty_password_enabled_warn() {
        postgresql_warn "You set the environment variable ALLOW_EMPTY_PASSWORD=${ALLOW_EMPTY_PASSWORD}. For safety reasons, do not use this flag in a production environment."
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
        if (( ${#POSTGRESQL_PASSWORD} > 100 )); then
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
            if (( POSTGRESQL_NUM_SYNCHRONOUS_REPLICAS < 0 )); then
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
    postgresql_info "postgresql.conf file not detected. Generating it..."
    cp "$POSTGRESQL_BASE_DIR/share/postgresql.conf.sample" "$POSTGRESQL_CONF_FILE"
    # Update default value for 'include_dir' directive
    # ref: https://github.com/postgres/postgres/commit/fb9c475597c245562a28d1e916b575ac4ec5c19f#diff-f5544d9b6d218cc9677524b454b41c60
    if ! grep include_dir "$POSTGRESQL_CONF_FILE" > /dev/null; then
        postgresql_error "include_dir line is not present in $POSTGRESQL_CONF_FILE. This may be due to a changes in a new version of PostgreSQL. Please check"
        exit 1
    fi
    local psql_conf
    psql_conf="$(sed -E "/#include_dir/i include_dir = 'conf.d'" "$POSTGRESQL_CONF_FILE")"
    echo "$psql_conf" > "$POSTGRESQL_CONF_FILE"
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
    postgresql_info "Generating LDAP authentication configuration"
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

    cat << EOF > "$POSTGRESQL_PGHBA_FILE"
host     all             postgres        0.0.0.0/0               trust
host     all             postgres        ::1/128                 trust
host     all             all             0.0.0.0/0               ldap $ldap_configuration
host     all             all             ::1/128                 ldap $ldap_configuration
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
    postgresql_info "Generating local authentication configuration"
    cat << EOF > "$POSTGRESQL_PGHBA_FILE"
host     all             all             0.0.0.0/0               trust
host     all             all             ::1/128                 trust
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
    postgresql_info "pg_hba.conf file not detected. Generating it..."

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
    cat << EOF >> "$POSTGRESQL_PGHBA_FILE"
local    all             all                                     trust
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
        local pghba_file
        pghba_file="$(sed 's/trust/md5/g' "$POSTGRESQL_PGHBA_FILE")"
        echo "$pghba_file" > "$POSTGRESQL_PGHBA_FILE"
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
    cat << EOF >> "$POSTGRESQL_PGHBA_FILE"
host      replication     all             0.0.0.0/0               ${replication_auth}
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
    psql_conf="$(sed "s?^#*\s*${property}\s*=.*?${property} = '${value}'?g" "$conf_file")"
    echo "$psql_conf" > "$conf_file"
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
    postgresql_info "Creating replication user $POSTGRESQL_REPLICATION_USER"
    echo "CREATE ROLE \"$POSTGRESQL_REPLICATION_USER\" REPLICATION LOGIN ENCRYPTED PASSWORD '$escaped_password'" | postgresql_execute
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
    postgresql_info "Configuring replication parameters"
    postgresql_set_property "wal_level" "hot_standby"
    postgresql_set_property "max_wal_size" "400MB"
    postgresql_set_property "max_wal_senders" "16"
    postgresql_set_property "wal_keep_segments" "12"
    postgresql_set_property "hot_standby" "on"
    if (( POSTGRESQL_NUM_SYNCHRONOUS_REPLICAS > 0 )); then
        postgresql_set_property "synchronous_commit" "$POSTGRESQL_SYNCHRONOUS_COMMIT_MODE"
        postgresql_set_property "synchronous_standby_names" "${POSTGRESQL_NUM_SYNCHRONOUS_REPLICAS} (\"${POSTGRESQL_CLUSTER_APP_NAME}\")"
    fi
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
    postgresql_info "Configuring fsync"
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
    postgresql_info "Changing password of postgres"
    echo "ALTER ROLE postgres WITH PASSWORD '$escaped_password';" | postgresql_execute
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
    postgresql_info "Creating user ${POSTGRESQL_USERNAME}"
    echo "CREATE ROLE \"${POSTGRESQL_USERNAME}\" WITH LOGIN CREATEDB PASSWORD '${escaped_password}';" | postgresql_execute
    postgresql_info "Grating access to \"${POSTGRESQL_USERNAME}\" to the database \"${POSTGRESQL_DATABASE}\""
    echo "GRANT ALL PRIVILEGES ON DATABASE \"${POSTGRESQL_DATABASE}\" TO \"${POSTGRESQL_USERNAME}\"\;" | postgresql_execute "" "postgres" "$POSTGRESQL_PASSWORD"
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
    echo "CREATE DATABASE \"$POSTGRESQL_DATABASE\"" | postgresql_execute "" "postgres" "" "localhost"
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
    local -r -a files=(
        "$POSTGRESQL_DATA_DIR"/postmaster.pid
        "$POSTGRESQL_DATA_DIR"/standby.signal
        "$POSTGRESQL_DATA_DIR"/recovery.signal
    )

    for file in "${files[@]}"; do
        if [[ -f "$file" ]]; then
            postgresql_info "Cleaning stale $file file"
            rm "$file"
        fi
    done
}

########################
# Ensure PostgreSQL is initialized
# Globals:
#   POSTGRESQL_*
# Arguments:
#   None
# Returns:
#   None
#########################
postgresql_initialize() {
    postgresql_info "Initializing PostgreSQL database..."
    postgresql_clean_from_restart
    # This fixes an issue where the trap would kill the entrypoint.sh, if a PID was left over from a previous run
    # Exec replaces the process without creating a new one, and when the container is restarted it may have the same PID
    rm -f "$POSTGRESQL_PID_FILE"

    # User injected custom configuration
    if [[ -d "$POSTGRESQL_MOUNTED_CONF_DIR" ]] && compgen -G "$POSTGRESQL_MOUNTED_CONF_DIR"/* > /dev/null; then
        postgresql_debug "Copying files from $POSTGRESQL_MOUNTED_CONF_DIR to $POSTGRESQL_CONF_DIR"
        cp -fr "$POSTGRESQL_MOUNTED_CONF_DIR"/. "$POSTGRESQL_CONF_DIR"
    fi
    local create_conf_file=yes
    local create_pghba_file=yes

    if postgresql_is_file_external "postgresql.conf"; then
        postgresql_info "Custom configuration $POSTGRESQL_CONF_FILE detected"
        create_conf_file=no
    fi

    if postgresql_is_file_external "pg_hba.conf"; then
        postgresql_info "Custom configuration $POSTGRESQL_PGHBA_FILE detected"
        create_pghba_file=no
    fi

    postgresql_debug "Ensuring expected directories/files exist..."
    for dir in "$POSTGRESQL_TMP_DIR" "$POSTGRESQL_LOG_DIR"; do
        ensure_dir_exists "$dir"
        am_i_root && chown "$POSTGRESQL_DAEMON_USER:$POSTGRESQL_DAEMON_GROUP" "$dir"
    done
    is_boolean_yes "$create_conf_file" && postgresql_create_config
    is_boolean_yes "$create_pghba_file" && postgresql_create_pghba && postgresql_allow_local_connection

    if ! is_dir_empty "$POSTGRESQL_DATA_DIR"; then
        postgresql_info "Deploying PostgreSQL with persisted data..."
        export POSTGRESQL_FIRST_BOOT="no"
        is_boolean_yes "$create_pghba_file" && postgresql_restrict_pghba
        is_boolean_yes "$create_conf_file" && postgresql_configure_replication_parameters
        is_boolean_yes "$create_conf_file" && postgresql_configure_fsync
        [[ "$POSTGRESQL_REPLICATION_MODE" = "master" ]] && [[ -n "$POSTGRESQL_REPLICATION_USER" ]] && is_boolean_yes "$create_pghba_file" && postgresql_add_replication_to_pghba
        [[ "$POSTGRESQL_REPLICATION_MODE" = "slave" ]] && postgresql_configure_recovery
    else
        ensure_dir_exists "$POSTGRESQL_DATA_DIR"
        am_i_root && chown "$POSTGRESQL_DAEMON_USER:$POSTGRESQL_DAEMON_GROUP" "$POSTGRESQL_DATA_DIR"
        if [[ "$POSTGRESQL_REPLICATION_MODE" = "master" ]]; then
            postgresql_master_init_db
            postgresql_start_bg
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
            [[ -n "$POSTGRESQL_REPLICATION_USER" ]] && postgresql_create_replication_user
            is_boolean_yes "$create_conf_file" && postgresql_configure_replication_parameters
            is_boolean_yes "$create_conf_file" && postgresql_configure_fsync
            [[ -n "$POSTGRESQL_REPLICATION_USER" ]] && is_boolean_yes "$create_pghba_file" && postgresql_add_replication_to_pghba
        else
            postgresql_slave_init_db
            is_boolean_yes "$create_pghba_file" && postgresql_restrict_pghba
            is_boolean_yes "$create_conf_file" && postgresql_configure_replication_parameters
            is_boolean_yes "$create_conf_file" && postgresql_configure_fsync
            postgresql_configure_recovery
        fi
    fi

    # Delete conf files generated on first run
    rm -f "$POSTGRESQL_DATA_DIR"/postgresql.conf "$POSTGRESQL_DATA_DIR"/pg_hba.conf
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
    if [[ -n $(find "$POSTGRESQL_PREINITSCRIPTS_DIR/" -type f -name "*.sh") ]]; then
        info "Loading user's custom files from $POSTGRESQL_PREINITSCRIPTS_DIR ...";
        find "$POSTGRESQL_PREINITSCRIPTS_DIR/" -type f -name "*.sh" | sort | while read -r f; do
            if [[ -x "$f" ]]; then
                debug "Executing $f"; "$f"
            else
                debug "Sourcing $f"; . "$f"
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
    postgresql_info "Loading custom scripts..."
    if [[ -n $(find "$POSTGRESQL_INITSCRIPTS_DIR/" -type f -regex ".*\.\(sh\|sql\|sql.gz\)") ]] && [[ ! -f "$POSTGRESQL_VOLUME_DIR/.user_scripts_initialized" ]] ; then
        postgresql_info "Loading user's custom files from $POSTGRESQL_INITSCRIPTS_DIR ...";
        postgresql_start_bg
        find "$POSTGRESQL_INITSCRIPTS_DIR/" -type f -regex ".*\.\(sh\|sql\|sql.gz\)" | sort | while read -r f; do
            case "$f" in
                *.sh)
                    if [[ -x "$f" ]]; then
                        postgresql_debug "Executing $f"; "$f"
                    else
                        postgresql_debug "Sourcing $f"; . "$f"
                    fi
                    ;;
                *.sql)    postgresql_debug "Executing $f"; postgresql_execute "$POSTGRESQL_DATABASE" "$POSTGRESQL_INITSCRIPTS_USERNAME" "$POSTGRESQL_INITSCRIPTS_PASSWORD" < "$f";;
                *.sql.gz) postgresql_debug "Executing $f"; gunzip -c "$f" | postgresql_execute "$POSTGRESQL_DATABASE" "$POSTGRESQL_INITSCRIPTS_USERNAME" "$POSTGRESQL_INITSCRIPTS_PASSWORD";;
                *)        postgresql_debug "Ignoring $f" ;;
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
    postgresql_info "Stopping PostgreSQL..."
    stop_service_using_pid "$POSTGRESQL_PID_FILE"
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
#   $4 - Host
#   $5 - Port
#   $6 - Extra options (eg. -tA)
# Returns:
#   None
postgresql_execute() {
    local -r db="${1:-}"
    local -r user="${2:-postgres}"
    local -r pass="${3:-}"
    local -r host="${4:-localhost}"
    local -r port="${5:-5432}"
    local -r opts="${6:-}"

    local args=( "-h" "$host" "-p" "$port" "-U" "$user" )
    local cmd=("$POSTGRESQL_BIN_DIR/psql")
    [[ -n "$db" ]] && args+=( "-d" "$db" )
    [[ -n "$opts" ]] && args+=( "$opts" )
    if [[ "${BITNAMI_DEBUG:-false}" = true ]]; then
        PGPASSWORD=$pass "${cmd[@]}" "${args[@]}"
    elif [[ "${NO_ERRORS:-false}" = true ]]; then
        PGPASSWORD=$pass "${cmd[@]}" "${args[@]}" 2>/dev/null
    else
        PGPASSWORD=$pass "${cmd[@]}" "${args[@]}" >/dev/null 2>&1
    fi
}

########################
# Start PostgreSQL and wait until it is ready
# Globals:
#   POSTGRESQL_*
# Arguments:
#   None
# Returns:
#   None
#########################
postgresql_start_bg() {
    local -r pg_ctl_flags=("-w" "-D" "$POSTGRESQL_DATA_DIR" "-l" "$POSTGRESQL_LOG_FILE" "-o" "--config-file=$POSTGRESQL_CONF_FILE --external_pid_file=$POSTGRESQL_PID_FILE --hba_file=$POSTGRESQL_PGHBA_FILE")
    postgresql_info "Starting PostgreSQL in background..."
    is_postgresql_running && return
    if [[ "${BITNAMI_DEBUG:-false}" = true ]]; then
       "$POSTGRESQL_BIN_DIR"/pg_ctl "start" "${pg_ctl_flags[@]}"
    else
       "$POSTGRESQL_BIN_DIR"/pg_ctl "start" "${pg_ctl_flags[@]}" >/dev/null 2>&1
    fi
    local -r pg_isready_args=("-U" "postgres")
    local counter=$POSTGRESQL_INIT_MAX_TIMEOUT
    while ! "$POSTGRESQL_BIN_DIR"/pg_isready "${pg_isready_args[@]}" >/dev/null 2>&1; do
        sleep 1
        counter=$((counter - 1 ))
        if (( counter <= 0 )); then
            postgresql_error "PostgreSQL is not ready after $POSTGRESQL_INIT_MAX_TIMEOUT seconds"
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
        read -r -a envExtraFlags <<< "$POSTGRESQL_INITDB_ARGS"
        initdb_args+=("${envExtraFlags[@]}")
    fi
    if [[ -n "$POSTGRESQL_INITDB_WAL_DIR" ]]; then
        ensure_dir_exists "$POSTGRESQL_INITDB_WAL_DIR"
        am_i_root && chown "$POSTGRESQL_DAEMON_USER:$POSTGRESQL_DAEMON_GROUP" "$POSTGRESQL_INITDB_WAL_DIR"
        initdb_args+=("--waldir" "$POSTGRESQL_INITDB_WAL_DIR")
    fi
    if [[ -n "${initdb_args[*]:-}" ]]; then
        postgresql_info "Initializing PostgreSQL with ${initdb_args[*]} extra initdb arguments"
        if [[ "${BITNAMI_DEBUG:-false}" = true ]]; then
            "$POSTGRESQL_BIN_DIR/initdb" -E UTF8 -D "$POSTGRESQL_DATA_DIR" -U "postgres" "${initdb_args[@]}"
        else
            "$POSTGRESQL_BIN_DIR/initdb" -E UTF8 -D "$POSTGRESQL_DATA_DIR" -U "postgres" "${initdb_args[@]}" >/dev/null 2>&1
        fi
    elif [[ "${BITNAMI_DEBUG:-false}" = true ]]; then
        "$POSTGRESQL_BIN_DIR/initdb" -E UTF8 -D "$POSTGRESQL_DATA_DIR" -U "postgres"
    else
        "$POSTGRESQL_BIN_DIR/initdb" -E UTF8 -D "$POSTGRESQL_DATA_DIR" -U "postgres" >/dev/null 2>&1
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
    postgresql_info "Waiting for replication master to accept connections (${POSTGRESQL_INIT_MAX_TIMEOUT} timeout)..."
    local -r check_args=("-U" "$POSTGRESQL_REPLICATION_USER" "-h" "$POSTGRESQL_MASTER_HOST" "-p" "$POSTGRESQL_MASTER_PORT_NUMBER" "-d" "postgres")
    local -r check_cmd=("$POSTGRESQL_BIN_DIR"/pg_isready)
    local ready_counter=$POSTGRESQL_INIT_MAX_TIMEOUT

    while ! PGPASSWORD=$POSTGRESQL_REPLICATION_PASSWORD "${check_cmd[@]}" "${check_args[@]}";do
        sleep 1
        ready_counter=$(( ready_counter - 1 ))
        if (( ready_counter <= 0 )); then
            postgresql_error "PostgreSQL master is not ready after $POSTGRESQL_INIT_MAX_TIMEOUT seconds"
            exit 1
        fi

    done
    postgresql_info "Replicating the initial database"
    local -r backup_args=("-D" "$POSTGRESQL_DATA_DIR" "-U" "$POSTGRESQL_REPLICATION_USER" "-h" "$POSTGRESQL_MASTER_HOST" "-p" "$POSTGRESQL_MASTER_PORT_NUMBER" "-X" "stream" "-w" "-v" "-P")
    local -r backup_cmd=("$POSTGRESQL_BIN_DIR"/pg_basebackup)
    local replication_counter=$POSTGRESQL_INIT_MAX_TIMEOUT
    while ! PGPASSWORD=$POSTGRESQL_REPLICATION_PASSWORD "${backup_cmd[@]}" "${backup_args[@]}";do
        postgresql_debug "Backup command failed. Sleeping and trying again"
        sleep 1
        replication_counter=$(( replication_counter - 1 ))
        if (( replication_counter <= 0 )); then
            postgresql_error "Slave replication failed after trying for $POSTGRESQL_INIT_MAX_TIMEOUT seconds"
            exit 1
        fi
    done
    chmod 0700 "$POSTGRESQL_DATA_DIR"
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
    postgresql_info "Setting up streaming replication slave..."
    if (( POSTGRESQL_MAJOR_VERSION >= 12 )); then
        postgresql_set_property "primary_conninfo" "host=${POSTGRESQL_MASTER_HOST} port=${POSTGRESQL_MASTER_PORT_NUMBER} user=${POSTGRESQL_REPLICATION_USER} password=${POSTGRESQL_REPLICATION_PASSWORD} application_name=${POSTGRESQL_CLUSTER_APP_NAME}" "$POSTGRESQL_CONF_FILE"
        postgresql_set_property "promote_trigger_file" "/tmp/postgresql.trigger.${POSTGRESQL_MASTER_PORT_NUMBER}" "$POSTGRESQL_CONF_FILE"
        touch "$POSTGRESQL_DATA_DIR"/standby.signal
    else
        cp -f "$POSTGRESQL_BASE_DIR/share/recovery.conf.sample" "$POSTGRESQL_RECOVERY_FILE"
        chmod 600 "$POSTGRESQL_RECOVERY_FILE"
        postgresql_set_property "standby_mode" "on" "$POSTGRESQL_RECOVERY_FILE"
        postgresql_set_property "primary_conninfo" "host=${POSTGRESQL_MASTER_HOST} port=${POSTGRESQL_MASTER_PORT_NUMBER} user=${POSTGRESQL_REPLICATION_USER} password=${POSTGRESQL_REPLICATION_PASSWORD} application_name=${POSTGRESQL_CLUSTER_APP_NAME}" "$POSTGRESQL_RECOVERY_FILE"
        postgresql_set_property "trigger_file" "/tmp/postgresql.trigger.${POSTGRESQL_MASTER_PORT_NUMBER}" "$POSTGRESQL_RECOVERY_FILE"
    fi
}
