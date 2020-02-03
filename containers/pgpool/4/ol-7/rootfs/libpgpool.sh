#!/bin/bash
#
# Bitnami Pgpool library

# shellcheck disable=SC1090
# shellcheck disable=SC1091

# Load Generic Libraries
. /libfile.sh
. /libfs.sh
. /liblog.sh
. /libnet.sh
. /libos.sh
. /libservice.sh
. /libvalidations.sh

########################
# Loads global variables used on pgpool configuration.
# Globals:
#   PGPOOL_*
# Arguments:
#   None
# Returns:
#   Series of exports to be used as 'eval' arguments
#########################
pgpool_env() {
    cat <<"EOF"
# Format log messages
MODULE=pgpool

# Paths
export PGPOOL_BASE_DIR="/opt/bitnami/pgpool"
export PGPOOL_DATA_DIR="${PGPOOL_BASE_DIR}/data"
export PGPOOL_CONF_DIR="${PGPOOL_BASE_DIR}/conf"
export PGPOOL_ETC_DIR="${PGPOOL_BASE_DIR}/etc"
export PGPOOL_LOG_DIR="${PGPOOL_BASE_DIR}/logs"
export PGPOOL_TMP_DIR="${PGPOOL_BASE_DIR}/tmp"
export PGPOOL_BIN_DIR="${PGPOOL_BASE_DIR}/bin"
export PGPOOL_INITSCRIPTS_DIR=/docker-entrypoint-initdb.d
export PGPOOL_CONF_FILE="${PGPOOL_CONF_DIR}/pgpool.conf"
export PGPOOL_PCP_CONF_FILE="${PGPOOL_ETC_DIR}/pcp.conf"
export PGPOOL_PGHBA_FILE="${PGPOOL_CONF_DIR}/pool_hba.conf"
export PGPOOL_PID_FILE="${PGPOOL_TMP_DIR}/pgpool.pid"
export PGPOOL_LOG_FILE="${PGPOOL_LOG_DIR}/pgpool.log"
export PGPOOL_PWD_FILE="pool_passwd"
export PATH="${PGPOOL_BIN_DIR}:$PATH"

# Users
export PGPOOL_DAEMON_USER="pgpool"
export PGPOOL_DAEMON_GROUP="pgpool"

# Settings
export PGPOOL_PORT_NUMBER="${PGPOOL_PORT_NUMBER:-5432}"
export PGPOOL_BACKEND_NODES="${PGPOOL_BACKEND_NODES:-}"
export PGPOOL_SR_CHECK_USER="${PGPOOL_SR_CHECK_USER:-}"
export PGPOOL_POSTGRES_USERNAME="${PGPOOL_POSTGRES_USERNAME:-postgres}"
export PGPOOL_ADMIN_USERNAME="${PGPOOL_ADMIN_USERNAME:-}"
export PGPOOL_ENABLE_LDAP="${PGPOOL_ENABLE_LDAP:-no}"
export PGPOOL_TIMEOUT="360"
export PGPOOL_ENABLE_LOAD_BALANCING="${PGPOOL_ENABLE_LOAD_BALANCING:-yes}"

# LDAP
export PGPOOL_LDAP_URI="${PGPOOL_LDAP_URI:-}"
export PGPOOL_LDAP_BASE="${PGPOOL_LDAP_BASE:-}"
export PGPOOL_LDAP_BIND_DN="${PGPOOL_LDAP_BIND_DN:-}"
export PGPOOL_LDAP_BIND_PASSWORD="${PGPOOL_LDAP_BIND_PASSWORD:-}"
export PGPOOL_LDAP_BASE_LOOKUP="${PGPOOL_LDAP_BASE_LOOKUP:-}"
export PGPOOL_LDAP_NSS_INITGROUPS_IGNOREUSERS="${PGPOOL_LDAP_NSS_INITGROUPS_IGNOREUSERS:-root,nslcd}"
export PGPOOL_LDAP_SCOPE="${PGPOOL_LDAP_SCOPE:-}"
export PGPOOL_LDAP_TLS_REQCERT="${PGPOOL_LDAP_TLS_REQCERT:-}"

EOF
    if [[ -f "${PGPOOL_ADMIN_PASSWORD_FILE:-}" ]]; then
        cat << "EOF"
export PGPOOL_ADMIN_PASSWORD="$(< "${PGPOOL_ADMIN_PASSWORD_FILE}")"
EOF
    else
        cat << "EOF"
export PGPOOL_ADMIN_PASSWORD="${PGPOOL_ADMIN_PASSWORD:-}"
EOF
    fi
    if [[ -f "${PGPOOL_POSTGRES_PASSWORD_FILE:-}" ]]; then
        cat << "EOF"
export PGPOOL_POSTGRES_PASSWORD="$(< "${PGPOOL_POSTGRES_PASSWORD_FILE}")"
EOF
    else
        cat << "EOF"
export PGPOOL_POSTGRES_PASSWORD="${PGPOOL_POSTGRES_PASSWORD:-}"
EOF
    fi
    if [[ -f "${PGPOOL_SR_CHECK_PASSWORD_FILE:-}" ]]; then
        cat << "EOF"
export PGPOOL_SR_CHECK_PASSWORD="$(< "${PGPOOL_SR_CHECK_PASSWORD_FILE}")"
EOF
    else
        cat << "EOF"
export PGPOOL_SR_CHECK_PASSWORD="${PGPOOL_SR_CHECK_PASSWORD:-}"
EOF
    fi
}

########################
# Validate settings in PGPOOL_* env. variables
# Globals:
#   PGPOOL_*
# Arguments:
#   None
# Returns:
#   None
#########################
pgpool_validate() {
    info "Validating settings in PGPOOL_* env vars..."
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }

    if [[ -z "$PGPOOL_ADMIN_USERNAME" ]] || [[ -z "$PGPOOL_ADMIN_PASSWORD" ]]; then
        print_validation_error "The Pgpool administrator user's credentials are mandatory. Set the environment variables PGPOOL_ADMIN_USERNAME and PGPOOL_ADMIN_PASSWORD with the Pgpool administrator user's credentials."
    fi
    if [[ -z "$PGPOOL_SR_CHECK_USER" ]] || [[ -z "$PGPOOL_SR_CHECK_PASSWORD" ]]; then
        print_validation_error "The PostrgreSQL replication credentials are mandatory. Set the environment variables PGPOOL_SR_CHECK_USER and PGPOOL_SR_CHECK_PASSWORD with the PostrgreSQL replication credentials."
    fi
    if is_boolean_yes "$PGPOOL_ENABLE_LDAP" && ( [[ -z "${PGPOOL_LDAP_URI}" ]] || [[ -z "${PGPOOL_LDAP_BASE}" ]] || [[ -z "${PGPOOL_LDAP_BIND_DN}" ]] || [[ -z "${PGPOOL_LDAP_BIND_PASSWORD}" ]] ); then
        print_validation_error "The LDAP configuration is required when LDAP authentication is enabled. Set the environment variables PGPOOL_LDAP_URI, PGPOOL_LDAP_BASE, PGPOOL_LDAP_BIND_DN and PGPOOL_LDAP_BIND_PASSWORD with the LDAP configuration."
    fi
    if [[ -z "$PGPOOL_POSTGRES_USERNAME" ]] || [[ -z "$PGPOOL_POSTGRES_PASSWORD" ]]; then
        print_validation_error "The administrator's database credentials are required. Set the environment variables PGPOOL_POSTGRES_USERNAME and PGPOOL_POSTGRES_PASSWORD with the administrator's database credentials."
    fi
    if [[ -z "$PGPOOL_BACKEND_NODES" ]]; then
        print_validation_error "The list of backend nodes cannot be empty. Set the environment variable PGPOOL_BACKEND_NODES with a comma separated list of backend nodes."
    else
        read -r -a nodes <<< "$(tr ',;' ' ' <<< "${PGPOOL_BACKEND_NODES}")"
        for node in "${nodes[@]}"; do
            read -r -a fields <<< "$(tr ':' ' ' <<< "${node}")"
            if [[ -z "${fields[0]:-}" ]]; then
                print_validation_error "Error checking entry '$node', the field 'backend number' must be set!"
            fi
            if [[ -z "${fields[1]:-}" ]]; then
                print_validation_error "Error checking entry '$node', the field 'host' must be set!"
            fi
        done
    fi
    if ! is_yes_no_value "$PGPOOL_ENABLE_LOAD_BALANCING"; then
        print_validation_error "The values allowed for PGPOOL_ENABLE_LOAD_BALANCING are: yes or no"
    fi

    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}

pgpool_attach_node() {
    local -r node_id=${1:?node id is missing}

    info "Attaching backend node..."
    export PCPPASSFILE=$(mktemp /tmp/pcppass-XXXXX)
    echo "localhost:9898:${PGPOOL_ADMIN_USERNAME}:${PGPOOL_ADMIN_PASSWORD}" > "${PCPPASSFILE}"
    pcp_attach_node -h localhost  -U "${PGPOOL_ADMIN_USERNAME}" -p 9898 -n "${node_id}" -w
    rm -rf "${PCPPASSFILE}"
}

########################
# Check pgpool health and attached offline backends when they are online
# Globals:
#   PGPOOL_*
# Arguments:
#   None
# Returns:
#   0 when healthy
#   1 when unhealthy
#########################
pgpool_healthcheck() {
    info "Checking pgpool health..."
    # look up backends that are marked offline
    for node in $(PGPASSWORD="${PGPOOL_POSTGRES_PASSWORD}" psql -U "${PGPOOL_POSTGRES_USERNAME}" -h localhost -tA -c "SHOW pool_nodes;" | grep "down")
    do
        node_id=$(echo ${node} | cut -d'|' -f1)
        node_host=$(echo ${node} | cut -d'|' -f2)
        if PGPASSWORD="${PGPOOL_POSTGRES_PASSWORD}" psql -U "${PGPOOL_POSTGRES_USERNAME}" -h "${node_host}" -tA -c "SELECT 1" >/dev/null; then
            # attach backend if it has come back online
            pgpool_attach_node "${node_id}"
        fi
    done
}

########################
# Start nslcd in background
# Arguments:
#   None
# Returns:
#   None
#########################
pgpool_start_nslcd_bg() {
    info "Starting nslcd service in background..."
    nslcd -d &
}

########################
# Create basic pg_hba.conf file
# Globals:
#   PGPOOL_*
# Arguments:
#   None
# Returns:
#   None
#########################
pgpool_create_pghba() {
    local authentication="md5"
    info "Generating pg_hba.conf file..."

    is_boolean_yes "$PGPOOL_ENABLE_LDAP" && authentication="pam pamservice=pgpool.pam"
    cat > "$PGPOOL_PGHBA_FILE" << EOF
local    all             all                            trust
host     all             $PGPOOL_SR_CHECK_USER       all         trust
host     all             $PGPOOL_POSTGRES_USERNAME       all         md5
host     all             wide               all         trust
host     all             pop_user           all         trust
host     all             all                all         $authentication
EOF
}

########################
# Modify the pgpool.conf file by setting a property
# Globals:
#   PGPOOL_*
# Arguments:
#   $1 - property
#   $2 - value
#   $3 - Path to configuration file (default: $PGPOOL_CONF_FILE)
# Returns:
#   None
#########################
pgpool_set_property() {
    local -r property="${1:?missing property}"
    local -r value="${2:-}"
    local -r conf_file="${3:-$PGPOOL_CONF_FILE}"
    replace_in_file "$conf_file" "^#*\s*${property}\s*=.*" "${property} = '${value}'" false
}

########################
# Add a backend configuration to pgpool.conf file
# Globals:
#   PGPOOL_*
# Arguments:
#   None
# Returns:
#   None
#########################
pgpool_create_backend_config() {
    local -r node=${1:?node is missing}
    local -r retries=5
    local -r sleep_time=3

    # default values
    read -r -a fields <<< "$(tr ':' ' ' <<< "${node}")"
    local -r num="${fields[0]:?field num is needed}"
    local -r host="${fields[1]:?field host is needed}"
    local -r port="${fields[2]:-5432}"
    local -r weight="${fields[3]:-1}"
    local -r dir="${fields[4]:-$PGPOOL_DATA_DIR}"
    local -r flag="${fields[5]:-ALLOW_TO_FAILOVER}"

    debug "Adding '$host' information to the configuration..."
    cat >> "$PGPOOL_CONF_FILE" << EOF
backend_hostname$num = '$host'
backend_port$num = $port
backend_weight$num = $weight
backend_data_directory$num = '$dir'
backend_flag$num = '$flag'
EOF
}

########################
#  Create basic pgpool.conf file using the example provided in the etc/ folder
# Globals:
#   PGPOOL_*
# Arguments:
#   None
# Returns:
#   None
#########################
pgpool_create_config() {
    local -i node_counter=0
    local load_balance_mode=""

    if is_boolean_yes "$PGPOOL_ENABLE_LOAD_BALANCING"; then
        load_balance_mode="on"
    else
        load_balance_mode="off"
    fi

    info "Generating pgpool.conf file..."
    # Configuring Pgpool-II to use the streaming replication mode since it's the recommended way
    # ref: http://www.pgpool.net/docs/latest/en/html/configuring-pgpool.html
    cp "${PGPOOL_BASE_DIR}/etc/pgpool.conf.sample-stream" "$PGPOOL_CONF_FILE"

    # Connection settings
    # ref: http://www.pgpool.net/docs/latest/en/html/runtime-config-connection.html#RUNTIME-CONFIG-CONNECTION-SETTINGS
    pgpool_set_property "listen_addresses" "*"
    pgpool_set_property "port" "$PGPOOL_PORT_NUMBER"
    pgpool_set_property "socket_dir" "$PGPOOL_TMP_DIR"
    # Communication Manager Connection settings
    pgpool_set_property "pcp_socket_dir" "$PGPOOL_TMP_DIR"
    # Authentication settings
    # ref: http://www.pgpool.net/docs/latest/en/html/runtime-config-connection.html#RUNTIME-CONFIG-AUTHENTICATION-SETTINGS
    pgpool_set_property "enable_pool_hba" "on"
    pgpool_set_property "pool_passwd" "$PGPOOL_PWD_FILE"
    pgpool_set_property "authentication_timeout" "30"
    # Connection Pooling settings
    # http://www.pgpool.net/docs/latest/en/html/runtime-config-connection-pooling.html
    pgpool_set_property "max_pool" "15"
    # File Locations settings
    pgpool_set_property "pid_file_name" "$PGPOOL_PID_FILE"
    pgpool_set_property "logdir" "$PGPOOL_LOG_DIR"
    # Load Balancing settings
    pgpool_set_property "load_balance_mode" "$load_balance_mode"
    pgpool_set_property "black_function_list" "nextval,setval"
    # Streaming settings
    pgpool_set_property "sr_check_user" "$PGPOOL_SR_CHECK_USER"
    pgpool_set_property "sr_check_password" "$PGPOOL_SR_CHECK_PASSWORD"
    pgpool_set_property "sr_check_period" "30"
    # Healthcheck per node settings
    pgpool_set_property "health_check_period" "30"
    pgpool_set_property "health_check_timeout" "10"
    pgpool_set_property "health_check_user" "$PGPOOL_SR_CHECK_USER"
    pgpool_set_property "health_check_password" "$PGPOOL_SR_CHECK_PASSWORD"
    pgpool_set_property "health_check_max_retries" "5"
    pgpool_set_property "health_check_retry_delay" "5"
    # Failover settings
    pgpool_set_property "failover_command" "echo \">>> Failover - that will initialize new primary node search!\""
    pgpool_set_property "failover_on_backend_error" "off"
    # Keeps searching for a primary node forever when a failover occurs
    pgpool_set_property "search_primary_node_timeout" "0"

    # Backend settings
    read -r -a nodes <<< "$(tr ',;' ' ' <<< "${PGPOOL_BACKEND_NODES}")"
    for node in "${nodes[@]}"; do
        pgpool_create_backend_config "$node"
    done
}

########################
# Configure LDAP connections
# Globals:
#   PGPOOL_*
# Arguments:
#   None
# Returns:
#   None
#########################
pgpool_ldap_config() {
    local openldap_conf
    info "Configuring LDAP connection..."

    cat > "/etc/pam.d/pgpool.pam" << EOF
auth     required  pam_ldap.so  try_first_pass debug
account  required  pam_ldap.so  debug
EOF
    cat >> "/etc/nslcd.conf" << EOF
# Configuration added for pgpool
nss_initgroups_ignoreusers $PGPOOL_LDAP_NSS_INITGROUPS_IGNOREUSERS
uri $PGPOOL_LDAP_URI
base $PGPOOL_LDAP_BASE
binddn $PGPOOL_LDAP_BIND_DN
bindpw $PGPOOL_LDAP_BIND_PASSWORD
EOF
    if [[ -n "${PGPOOL_LDAP_BASE_LOOKUP}" ]]; then
        cat >> "/etc/nslcd.conf" << EOF
base passwd $PGPOOL_LDAP_BASE_LOOKUP
EOF
    fi
    if [[ -n "${PGPOOL_LDAP_SCOPE}" ]]; then
        cat >> "/etc/nslcd.conf" << EOF
scope $PGPOOL_LDAP_SCOPE
EOF
    fi
    if [[ -n "${PGPOOL_LDAP_TLS_REQCERT}" ]]; then
            cat >> "/etc/nslcd.conf" << EOF
tls_reqcert $PGPOOL_LDAP_TLS_REQCERT
EOF
    fi
    chmod 600 /etc/nslcd.conf

    case "$OS_FLAVOUR" in
        debian-*) openldap_conf=/etc/ldap/ldap.conf ;;
        centos-*|rhel-*|ol-*|photon-*) openldap_conf=/etc/openldap/ldap.conf ;;
        *) ;;
    esac
    cat >>"${openldap_conf}"<<EOF
BASE $PGPOOL_LDAP_BASE
URI $PGPOOL_LDAP_URI
EOF
}

########################
# Generates a password file for local authentication
# Globals:
#   PGPOOL_*
# Arguments:
#   None
# Returns:
#   None
#########################
pgpool_generate_password_file() {
    info "Generating password file for local authentication..."

    pg_md5 -m --config-file="$PGPOOL_CONF_FILE" -u "$PGPOOL_POSTGRES_USERNAME" "$PGPOOL_POSTGRES_PASSWORD"
}

########################
# Run custom initialization scripts
# Globals:
#   PGPOOL_*
# Arguments:
#   None
# Returns:
#   None
#########################
pgpool_custom_init_scripts() {
    if [[ -n $(find "$PGPOOL_INITSCRIPTS_DIR/" -type f -name "*.sh") ]]; then
        info "Loading user's custom files from $PGPOOL_INITSCRIPTS_DIR ...";
        find "$PGPOOL_INITSCRIPTS_DIR/" -type f -name "*.sh" | sort | while read -r f; do
            if [[ -x "$f" ]]; then
                debug "Executing $f"; "$f"
            else
                debug "Sourcing $f"; . "$f"
            fi
        done
    fi
}

########################
# Generate a password file for pgpool admin user
# Globals:
#   PGPOOL_*
# Arguments:
#   None
# Returns:
#   None
#########################
pgpool_generate_admin_password_file() {
    info "Generating password file for pgpool admin user..."
    local passwd

    passwd=$(pg_md5 "$PGPOOL_ADMIN_PASSWORD")
    cat >>"$PGPOOL_PCP_CONF_FILE"<<EOF
$PGPOOL_ADMIN_USERNAME:$passwd
EOF
}

########################
# Ensure Pgpool is initialized
# Globals:
#   PGPOOL_*
# Arguments:
#   None
# Returns:
#   None
#########################
pgpool_initialize() {
    info "Initializing Pgpool-II..."

    # This fixes an issue where the trap would kill the entrypoint.sh, if a PID was left over from a previous run
    # Exec replaces the process without creating a new one, and when the container is restarted it may have the same PID
    rm -f "$PGPOOL_PID_FILE"

    # Configuring permissions for tmp, logs and data folders
    am_i_root && configure_permissions_ownership "$PGPOOL_TMP_DIR $PGPOOL_LOG_DIR" -u "$PGPOOL_DAEMON_USER" -g "$PGPOOL_DAEMON_GROUP"
    am_i_root && configure_permissions_ownership "$PGPOOL_DATA_DIR" -u "$PGPOOL_DAEMON_USER" -g "$PGPOOL_DAEMON_GROUP" -d "755" -f "644"

    if [[ -f "$PGPOOL_CONF_FILE" ]]; then
        info "Custom configuration $PGPOOL_CONF_FILE detected!"
    else
        info "No injected configuration files found. Creating default config files..."
        pgpool_create_pghba
        pgpool_create_config
        if is_boolean_yes "$PGPOOL_ENABLE_LDAP"; then
            pgpool_ldap_config
        fi
        pgpool_generate_password_file
        pgpool_generate_admin_password_file
    fi
}
