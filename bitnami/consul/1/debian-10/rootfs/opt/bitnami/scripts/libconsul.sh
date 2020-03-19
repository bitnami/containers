#!/bin/bash

# shellcheck disable=SC1091

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libvalidations.sh

# Bitnami Consul library

########################
# Create alias for environment variable, so both can be used
# Globals:
#   None
# Arguments:
#   $1 - Alias environment variable name
#   $2 - Original environment variable name
# Returns:
#   None
#########################
consul_declare_alias_env() {
    local -r alias="${1:?missing environment variable alias}"
    local -r original="${2:?missing original environment variable}"
    if printenv "${original}" > /dev/null; then
        cat <<EOF
export "$alias"="${!original:-}"
EOF
    fi
}

########################
# Loads global variables used on Consul configuration.
# Globals:
#   CONSUL_*
# Arguments:
#   None
# Returns:
#   Series of exports to be used as 'eval' arguments
#########################
consul_env() {
    [[ -n "${CONSUL_SERVER_MODE:-}" ]] && consul_declare_alias_env "CONSUL_AGENT_MODE" "CONSUL_SERVER_MODE"
    [[ -n "${CONSUL_RETRY_JOIN:-}" ]] && consul_declare_alias_env "CONSUL_RETRY_JOIN_ADDRESS" "CONSUL_RETRY_JOIN"
    [[ -n "${CONSUL_UI:-}" ]] && consul_declare_alias_env "CONSUL_ENABLE_UI" "CONSUL_UI"

    cat <<"EOF"
# Paths
export CONSUL_BASE_DIR="/opt/bitnami/consul"
export CONSUL_CONF_DIR="${CONSUL_BASE_DIR}/conf"
export CONSUL_CONF_FILE="${CONSUL_CONF_DIR}/consul.json"
export CONSUL_ENCRYPT_FILE="${CONSUL_CONF_DIR}/encrypt.json"
export CONSUL_LOCAL_CONF_FILE="${CONSUL_CONF_DIR}/local.json"
export CONSUL_LOG_DIR="${CONSUL_BASE_DIR}/logs"
export CONSUL_LOG_FILE="${CONSUL_LOG_DIR}/consul.log"
export CONSUL_DATA_DIR="/bitnami/consul"
export CONSUL_EXTRA_DIR="${CONSUL_BASE_DIR}/extra"
export CONSUL_MONIT_FILE="${CONSUL_EXTRA_DIR}/monit.conf"
export CONSUL_LOGROTATE_FILE="${CONSUL_EXTRA_DIR}/logrotate.conf"
export CONSUL_SSL_DIR="${CONSUL_BASE_DIR}/certificates"
export CONSUL_TMP_DIR="${CONSUL_BASE_DIR}/tmp"
export CONSUL_PID_FILE="${CONSUL_TMP_DIR}/consul.pid"
export CONSUL_TEMPLATES_DIR="${CONSUL_BASE_DIR}/templates"
export CONSUL_CONFIG_TEMPLATE_FILE="${CONSUL_TEMPLATES_DIR}/consul.json.tpl"
export CONSUL_ENCRYPT_TEMPLATE_FILE="${CONSUL_TEMPLATES_DIR}/encrypt.json.tpl"
export CONSUL_LOCAL_TEMPLATE_FILE="${CONSUL_TEMPLATES_DIR}/local.json.tpl"

# Users
export CONSUL_SYSTEM_USER="consul"
export CONSUL_SYSTEM_GROUP="consul"

# Settings
export CONSUL_RPC_PORT_NUMBER="${CONSUL_RPC_PORT_NUMBER:-8300}"
export CONSUL_HTTP_PORT_NUMBER="${CONSUL_HTTP_PORT_NUMBER:-8500}"
export CONSUL_DNS_PORT_NUMBER="${CONSUL_DNS_PORT_NUMBER:-8600}"
export CONSUL_AGENT_MODE="${CONSUL_AGENT_MODE:-server}"
export CONSUL_DISABLE_KEYRING_FILE="${CONSUL_DISABLE_KEYRING_FILE:-false}"
export CONSUL_SERF_LAN_ADDRESS="${CONSUL_SERF_LAN_ADDRESS:-0.0.0.0}"
export CONSUL_SERF_LAN_PORT_NUMBER="${CONSUL_SERF_LAN_PORT_NUMBER:-8301}"
export CONSUL_CLIENT_LAN_ADDRESS="${CONSUL_CLIENT_LAN_ADDRESS:-0.0.0.0}"
export CONSUL_RETRY_JOIN_ADDRESS="${CONSUL_RETRY_JOIN_ADDRESS:-127.0.0.1}"
export CONSUL_ENABLE_UI="${CONSUL_ENABLE_UI:-true}"
export CONSUL_BOOTSTRAP_EXPECT="${CONSUL_BOOTSTRAP_EXPECT:-1}"
export CONSUL_RAFT_MULTIPLIER="${CONSUL_RAFT_MULTIPLIER:-1}"
export CONSUL_LOCAL_CONFIG="${CONSUL_LOCAL_CONFIG:-}"
export CONSUL_GOSSIP_ENCRYPTION="${CONSUL_GOSSIP_ENCRYPTION:-no}"
export CONSUL_GOSSIP_ENCRYPTION_KEY="${CONSUL_GOSSIP_ENCRYPTION_KEY:-}"
export CONSUL_GOSSIP_ENCRYPTION_KEY_FILE="${CONSUL_GOSSIP_ENCRYPTION_KEY_FILE:-}"
export CONSUL_DATACENTER="${CONSUL_DATACENTER:-dc1}"
export CONSUL_DOMAIN="${CONSUL_DOMAIN:-consul}"
export CONSUL_NODE_NAME="$(get_consul_hostname)"
EOF

    if [[ -n "${CONSUL_GOSSIP_ENCRYPTION_KEY_FILE:-}" ]]; then
            cat <<"EOF"
export CONSUL_GOSSIP_ENCRYPTION_KEY="$(< "${CONSUL_GOSSIP_ENCRYPTION_KEY_FILE}")"
EOF
    fi
}

########################
# Validate settings in CONSUL_* env. variables
# Globals:
#   CONSUL_*
# Arguments:
#   None
# Returns:
#   None
#########################
consul_validate() {
    info "Validating settings in CONSUL_* env vars.."
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }

    check_boolean_value() {
        if ! is_true_false_value "${!1}"; then
            print_validation_error "The allowed values for $1 are [true, false]"
        fi
    }

    check_int_value() {
        if ! is_int "${!1}"; then
            print_validation_error "The value for $1 should be an integer"
        fi
    }

    check_ip_value() {
        if ! validate_ipv4 "${!1}"; then
            if ! is_hostname_resolved "${!1}"; then
                print_validation_error "The value for $1 should be an IPv4 address or it must be a resolvable hostname"
            else
                debug "Hostname resolvable for $1"
            fi
        fi
    }

    check_boolean_value CONSUL_ENABLE_UI
    check_boolean_value CONSUL_DISABLE_KEYRING_FILE
    check_int_value CONSUL_BOOTSTRAP_EXPECT
    check_int_value CONSUL_RAFT_MULTIPLIER
    check_ip_value CONSUL_RETRY_JOIN_ADDRESS
    check_ip_value CONSUL_CLIENT_LAN_ADDRESS
    check_ip_value CONSUL_SERF_LAN_ADDRESS

    for var in "CONSUL_RPC_PORT_NUMBER" "CONSUL_HTTP_PORT_NUMBER" "CONSUL_DNS_PORT_NUMBER" "CONSUL_SERF_LAN_PORT_NUMBER"; do
        if ! err=$(validate_port -unprivileged "${!var}"); then
            print_validation_error "An invalid port was specified in the environment variable $var: $err"
        fi
    done

    if ! [[ "$CONSUL_AGENT_MODE" =~ ^(client|server)$ ]]; then
        print_validation_error "CONSUL_AGENT_MODE must be server or client, provided value: ${CONSUL_AGENT_MODE}"
    fi

    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}

########################
# Create Consul Encryption file
# Globals:
#   CONSUL_*
# Arguments:
#   None
# Returns:
#   None
#########################
consul_configure_encryption() {
    # Configure the gossip encryption key
    if is_boolean_yes "$CONSUL_GOSSIP_ENCRYPTION"; then
        info "Configuring encryption key..."

        if [[ -z ${CONSUL_GOSSIP_ENCRYPTION_KEY} ]]; then
            CONSUL_GOSSIP_ENCRYPTION_KEY=$("${CONSUL_BASE_DIR}/bin/consul" "keygen" )
        else
            CONSUL_GOSSIP_ENCRYPTION_KEY=$(base64 <<< "${CONSUL_GOSSIP_ENCRYPTION_KEY}")
        fi

        render-template "${CONSUL_ENCRYPT_TEMPLATE_FILE}" > "${CONSUL_ENCRYPT_FILE}"
    fi
}

########################
# Initialize Consul service
# Globals:
#   CONSUL_*
# Arguments:
#   None
# Returns:
#   None
#########################
consul_initialize() {

    info "Initializing Consul..."

    if is_dir_empty "${CONSUL_DATA_DIR}"; then
        info "Deploying consul from scratch..."
    else
        info "Deploying consul with persisted data..."
    fi

    if [[ -f "${CONSUL_CONF_FILE}" ]]; then
        info "Configuration files found. Skipping default configuration..."
    else
        info "No injected configuration files found. Creating default config files..."
        debug "Creating main configuration file..."
        render-template "${CONSUL_CONFIG_TEMPLATE_FILE}" > "${CONSUL_CONF_FILE}"
    fi

    # Create an extra config file with the contents of the CONSUL_LOCAL_CONFIG env var
    if [[ -n ${CONSUL_LOCAL_CONFIG} ]]; then
        info "Configuring local config..."
        cat >"${CONSUL_LOCAL_CONF_FILE}" <<<"${CONSUL_LOCAL_CONFIG}"
    fi

    consul_configure_encryption
}

########################
# Determine the hostname by with contact the consul instance
# Globals:
#   CONSUL_NODE_NAME
# Arguments:
#   None
# Returns:
#   The value of $CONSUL_NODE_NAME or the current host address
########################
get_consul_hostname() {
    if [[ -n "${CONSUL_NODE_NAME:-}" ]]; then
        echo "$CONSUL_NODE_NAME"
    else
        get_machine_ip
    fi
}
