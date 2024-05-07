#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091,SC1090

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libvalidations.sh

# Bitnami Consul library

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
    check_ip_value CONSUL_RETRY_JOIN_WAN_ADDRESS
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
# Determine the bind IP address for internal cluster communications from the given interface
# Globals:
#   CONSUL_BIND_INTERFACE
# Arguments:
#   None
# Returns:
#   The ip address of the given interface or "" (will be bound to all addresses)
########################
get_bind_addr() {
    if [[ -n "$CONSUL_BIND_INTERFACE" ]]; then
        local -r bind_address=$(ip -o -4 addr list "$CONSUL_BIND_INTERFACE" | head -n1 | awk '{print $4}' | cut -d/ -f1)
        echo "$bind_address"
    fi
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
            CONSUL_GOSSIP_ENCRYPTION_KEY=$("${CONSUL_BASE_DIR}/bin/consul" "keygen")
        fi

        # In case the node name was not set, we automatically set
        render-template "${CONSUL_ENCRYPT_TEMPLATE_FILE}" >"${CONSUL_ENCRYPT_FILE}"
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

    if [[ -z "${CONSUL_NODE_NAME:-}" ]]; then
        warn "The variable CONSUL_NODE_NAME was not set, defaulting it to the machine ip"
        local -r machine_ip="$(get_machine_ip)"
        export CONSUL_NODE_NAME="$machine_ip"
    fi

    if [[ -n "$CONSUL_BIND_INTERFACE" ]] && [[ -z "${CONSUL_BIND_ADDR:-}" ]]; then
        info "CONSUL_BIND_INTERFACE was set to $CONSUL_BIND_INTERFACE and CONSUL_BIND_ADDR was not set, obtaining bind address"
        local -r bind_address=$(ip -o -4 addr list "$CONSUL_BIND_INTERFACE" | head -n1 | awk '{print $4}' | cut -d/ -f1)
        export CONSUL_BIND_ADDR="$bind_address"
    fi

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
        render-template "${CONSUL_CONFIG_TEMPLATE_FILE}" >"${CONSUL_CONF_FILE}"
    fi

    # Create an extra config file with the contents of the CONSUL_LOCAL_CONFIG env var
    if [[ -n ${CONSUL_LOCAL_CONFIG} ]]; then
        info "Configuring local config..."
        cat >"${CONSUL_LOCAL_FILE}" <<<"${CONSUL_LOCAL_CONFIG}"
    fi

    consul_configure_encryption
}

########################
# Stop Consul
# Globals:
#   CONSUL_PID_FILE
# Arguments:
#   None
# Returns:
#   None
#########################
consul_stop() {
    ! is_consul_running && return
    debug "Stopping Consul..."
    stop_service_using_pid "$CONSUL_PID_FILE"
}

########################
# Check if Consul is running
# Globals:
#   CONSUL_PID_FILE
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_consul_running() {
    local pid
    pid="$(get_pid_from_file "$CONSUL_PID_FILE")"

    if [[ -z "$pid" ]]; then
        false
    else
        is_service_running "$pid"
    fi
}

########################
# Check if Consul is not running
# Globals:
#   CONSUL_PID_FILE
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_consul_not_running() {
    ! is_consul_running
    return "$?"
}

########################
# Run custom initialization scripts
# Globals:
#   CONSUL_*
# Arguments:
#   None
# Returns:
#   None
#########################
consul_custom_init_scripts() {
    if [[ -n $(find "${CONSUL_INITSCRIPTS_DIR}/" -type f -regex ".*\.sh") ]]; then
        info "Loading user's custom files from $CONSUL_INITSCRIPTS_DIR ..."
        local -r tmp_file="/tmp/filelist"
        find "${CONSUL_INITSCRIPTS_DIR}/" -type f -regex ".*\.sh" | sort >"$tmp_file"
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
        consul_stop
        rm -f "$tmp_file"
    else
        info "No custom scripts in $CONSUL_INITSCRIPTS_DIR"
    fi
}
