#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami pg_auto_failover library

# shellcheck disable=SC1090,SC1091

# Load PostgreSQL library
. /opt/bitnami/scripts/libpostgresql.sh

########################
# Change pg_hba.conf so it allows access from replication users
# Globals:
#   POSTGRESQL_*
# Arguments:
#   None
# Returns:
#   None
#########################
autoctl_configure_pghba() {
    local replication_auth="trust"
    if [[ -n "${POSTGRESQL_REPLICATION_PASSWORD}" ]]; then
        replication_auth="md5"
    fi

    cat <<EOF >"${POSTGRESQL_PGHBA_FILE}"
local     all                  all                                           trust
EOF

    if [[ "${POSTGRESQL_AUTOCTL_MODE}" = "monitor"  ]]; then
        cat <<EOF >>"${POSTGRESQL_PGHBA_FILE}"
host      pg_auto_failover     autoctl_node                 0.0.0.0/0        ${replication_auth}
EOF
    elif [[ "${POSTGRESQL_AUTOCTL_MODE}" = "postgres"  ]]; then
        cat <<EOF >>"${POSTGRESQL_PGHBA_FILE}"
host      all                  all                          0.0.0.0/0        ${replication_auth}
host      all                  all                          ::/0             ${replication_auth}
host      replication          pgautofailover_replicator    0.0.0.0/0        ${replication_auth}
EOF
    fi

    cp "${POSTGRESQL_PGHBA_FILE}" "${POSTGRESQL_DATA_DIR}/pg_hba.conf"
}

########################
# Configure the auth parameters
# Globals:
#   POSTGRESQL_*
# Arguments:
#   None
# Returns:
#   None
#########################
autoctl_configure_auth() {
    info "Configuring auth parameters for (${POSTGRESQL_DATA_DIR})..."

    if [[ -f ${POSTGRESQL_DATA_DIR}/.autoctl_initialized ]]; then
        info "Auth parameters are already configured, restoring from existing data"
    else
        postgresql_start_bg

        if [[ -n "${POSTGRESQL_REPLICATION_PASSWORD}" ]]; then
            info "Changing replication passwords"

            local -r escaped_password="${POSTGRESQL_REPLICATION_PASSWORD//\'/\'\'}"
            if [[ "${POSTGRESQL_AUTOCTL_MODE}" = "monitor" ]]; then
                echo "ALTER USER autoctl_node WITH PASSWORD '${escaped_password}';" | postgresql_execute
            elif [[ "${POSTGRESQL_AUTOCTL_MODE}" = "postgres" ]]; then
                echo "ALTER USER pgautofailover_replicator WITH PASSWORD '${escaped_password}';" | postgresql_execute
                pg_autoctl config set --pgdata "${POSTGRESQL_DATA_DIR}" replication.password "${POSTGRESQL_REPLICATION_PASSWORD}"
            fi
        fi

        if [[ "${POSTGRESQL_AUTOCTL_MODE}" = "postgres" ]]; then
            info "Adding users auth configurations..."
            [[ -n "${POSTGRESQL_DATABASE}" ]] && [[ "$POSTGRESQL_DATABASE" != "postgres" ]] && postgresql_create_custom_database
            if [[ "$POSTGRESQL_USERNAME" = "postgres" ]]; then
                postgresql_alter_postgres_user "$POSTGRESQL_PASSWORD"
            else
                if [[ -n "$POSTGRESQL_POSTGRES_PASSWORD" ]]; then
                    postgresql_alter_postgres_user "$POSTGRESQL_POSTGRES_PASSWORD"
                fi
                postgresql_create_admin_user
            fi
        fi

        postgresql_stop
    fi
}

########################
# Create a monitor
# Globals:
#   POSTGRESQL_*
# Arguments:
#   None
# Returns:
#   None
#########################
autoctl_create_monitor() {
    local -r default_hostname=${1:?default_hostname is required}

    "${POSTGRESQL_BIN_DIR}/pg_autoctl" create monitor \
        --auth md5 \
        --pgdata "${POSTGRESQL_DATA_DIR}" \
        --no-ssl \
        --hostname "${POSTGRESQL_AUTOCTL_HOSTNAME:-$default_hostname}"
}

########################
# Build monitor URI
# Globals:
#   POSTGRESQL_*
# Arguments:
#   None
# Returns:
#   None
#########################
monitor_connection_string() {
    echo "postgres://autoctl_node:${POSTGRESQL_REPLICATION_PASSWORD}@${POSTGRESQL_AUTOCTL_MONITOR_HOST}/pg_auto_failover?connect_timeout=2"
}

########################
# Create a postgress node
# Globals:
#   POSTGRESQL_*
# Arguments:
#   None
# Returns:
#   None
#########################
autoctl_create_postgres() {
    local -r default_hostname=${1:?default_hostname is required}

    PGPASSWORD="${POSTGRESQL_REPLICATION_PASSWORD}" "${POSTGRESQL_BIN_DIR}/pg_autoctl" create postgres \
        --auth md5 \
        --pgdata "${POSTGRESQL_DATA_DIR}" \
        --no-ssl \
        --monitor "$(monitor_connection_string)" \
        --name "${POSTGRESQL_AUTOCTL_HOSTNAME:-$default_hostname}" \
        --hostname "${POSTGRESQL_AUTOCTL_HOSTNAME:-$default_hostname}"

    pg_autoctl config set  --pgdata "${POSTGRESQL_DATA_DIR}" pg_autoctl.monitor "$(monitor_connection_string)"
    wait_until_can_connect "$(monitor_connection_string)"
}

########################
# Create postgresql data dir using pg_autoclt
# Globals:
#   POSTGRESQL_*
# Arguments:
#   None
# Returns:
#   None
#########################
autoctl_create_node() {
    info "Creating ${POSTGRESQL_AUTOCTL_MODE} data directory (${POSTGRESQL_DATA_DIR})..."

    if [[ -f ${POSTGRESQL_DATA_DIR}/.autoctl_initialized ]]; then
        info "A ${POSTGRESQL_AUTOCTL_MODE} data directory (${POSTGRESQL_DATA_DIR}) already exists, restoring from existing data"
    else
        info "Cleaning dbinit initialization files ${POSTGRESQL_DATA_DIR}..."
        rm -rf "${POSTGRESQL_DATA_DIR:?}"/*

        local -r default_hostname="$(hostname --fqdn)"
        if [[ "${POSTGRESQL_AUTOCTL_MODE}" = "monitor" ]]; then
            autoctl_create_monitor "${default_hostname}"
        elif [[ "${POSTGRESQL_AUTOCTL_MODE}" = "postgres" ]]; then
            autoctl_create_postgres "${default_hostname}"
        else
            error "autoctl does not support ${POSTGRESQL_AUTOCTL_MODE}"
            exit 1
        fi
    fi
}

########################
# Add pgautofailover extension to shared_preload_libraries property in postgresql.conf
# Globals:
#   POSTGRESQL_*
# Arguments:
#   None
# Returns:
#   None
#########################
autoctl_configure_pgautofailover() {
    info "Load pgautofailover through POSTGRESQL_SHARED_PRELOAD_LIBRARIES env var..."
    if [[ -f ${POSTGRESQL_DATA_DIR}/.autoctl_initialized ]]; then
        info "The pgautofailover is already loaded, restoring from existing config"
    else
        local preload_libraries
        if [[ -n "${POSTGRESQL_SHARED_PRELOAD_LIBRARIES}" ]]; then
            preload_libraries="${POSTGRESQL_SHARED_PRELOAD_LIBRARIES},pgautofailover"
        else
            preload_libraries="pgautofailover"
        fi

        postgresql_set_property "shared_preload_libraries" "${preload_libraries}"
    fi
}

########################
# Add pgbackrest extension's configuration file and directories
# Globals:
#   POSTGRESQL_*
# Arguments:
#   None
# Returns:
#   None
#########################
autoctl_configure_pgbackrest() {
    if [[ -f ${POSTGRESQL_DATA_DIR}/.autoctl_initialized ]]; then
        info "The pgbackrest is already configured"
    else
        info "Configuring pgbackrest..."
        debug "Ensuring pgbackrest expected directories/files exist..."
        for dir in "${POSTGRESQL_PGBACKREST_LOGS_DIR}" "${POSTGRESQL_PGBACKREST_BACKUPS_DIR}" "${POSTGRESQL_PGBACKREST_SPOOL_DIR}"; do
            ensure_dir_exists "${dir}"
            am_i_root && chown "${POSTGRESQL_DAEMON_USER}:${POSTGRESQL_DAEMON_GROUP}" "${dir}"
        done

        cat <<EOF >>"${POSTGRESQL_PGBACKREST_CONF_FILE}"
[global]
repo1-path=${POSTGRESQL_PGBACKREST_BACKUPS_DIR}
repo1-cipher-pass=${POSTGRESQL_REPLICATION_PASSWORD}
repo1-cipher-type=aes-256-cbc
repo1-retention-diff=1
repo1-retention-full=2
process-max=2
log-path=${POSTGRESQL_PGBACKREST_LOGS_DIR}
log-level-console=info
log-level-file=debug
archive-async=y
spool-path=${POSTGRESQL_PGBACKREST_SPOOL_DIR}
start-fast=y
[testdb]
pg1-path=${POSTGRESQL_DATA_DIR}
EOF
    fi
}

########################
# Initialize a monitor or postgress node using pg_autoctl command.
# Globals:
#   POSTGRESQL_*
# Arguments:
#   None
# Returns:
#   None
#########################
autoctl_initialize() {
    info "Initializing ${POSTGRESQL_AUTOCTL_MODE} data directory..."

    postgresql_unrestrict_pghba
    autoctl_create_node
    autoctl_configure_pgautofailover
    autoctl_configure_pgbackrest

    if [[ ! -f ${POSTGRESQL_DATA_DIR}/.autoctl_initialized ]]; then
        info "Moving configuration files to (${POSTGRESQL_DATA_DIR})..."

        cp "${POSTGRESQL_CONF_FILE}" "${POSTGRESQL_DATA_DIR}/postgresql.conf"
        mkdir -p "${POSTGRESQL_DATA_DIR}/conf.d"
    fi

    autoctl_configure_auth
    autoctl_configure_pghba

    touch "${POSTGRESQL_DATA_DIR}/.autoctl_initialized"
    info "Done initializing ${POSTGRESQL_AUTOCTL_MODE} data directory..."
}

########################
# Wait until a node is ready to accepts connection.
# Globals:
#   POSTGRESQL_*
# Arguments:
#   - $1 node hostname
# Returns:
#   None
#########################
wait_until_can_connect() {
    local connection_string="$1"

    check_postgresql_connection() {
        psql "$connection_string" -c 'select version()' > /dev/null 2>&1
    }

    info "Wait until node is available..."
    if ! retry_while "check_postgresql_connection"; then
        error "Could not connect to the postgresql"
        return 1
    fi
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
postgresql_unrestrict_pghba() {
    replace_in_file "$POSTGRESQL_PGHBA_FILE" "md5" "trust" false
}
