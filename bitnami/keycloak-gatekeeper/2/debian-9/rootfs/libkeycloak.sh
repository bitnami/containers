#!/bin/bash
#
# Bitnami Keycloak Gatekeeper library

# shellcheck disable=SC1091

# Load libraries
. /liblog.sh
. /libos.sh
. /libvalidations.sh

# Functions

########################
# Retrieve a configuration setting value
# Globals:
#   KEYCLOAK_GATEKEEPER_CONFDIR
# Arguments:
#   $1 - config_file
#   $2 - key
# Returns:
#   None
#########################
keycloak_conf_get() {
    local config_file="${1:?missing config_file}"
    local key="${2:?missing key}"
    if [[ $config_file == *.json ]]; then
        jq -r ".$key" < "${KEYCLOAK_GATEKEEPER_CONFDIR}/${config_file}"
    else
        yq read "${KEYCLOAK_GATEKEEPER_CONFDIR}/${config_file}" "$key"
    fi
}

########################
# Load global variables used on Keycloak Gatekeeper configuration.
# Globals:
#   KEYCLOAK_GATEKEEPER_*
# Arguments:
#   None
# Returns:
#   Series of exports to be used as 'eval' arguments
#########################
keycloak_env() {
    cat <<"EOF"
export KEYCLOAK_GATEKEEPER_BASEDIR="/opt/bitnami/keycloak-gatekeeper"
export KEYCLOAK_GATEKEEPER_BINDIR="${KEYCLOAK_GATEKEEPER_BASEDIR}/bin"
export KEYCLOAK_GATEKEEPER_CONFDIR="${KEYCLOAK_GATEKEEPER_BASEDIR}/conf"
export KEYCLOAK_GATEKEEPER_DAEMON_USER="keycloak"
export KEYCLOAK_GATEKEEPER_DAEMON_GROUP="keycloak"
EOF
}

########################
# Validate settings Keycloak Gatekeeper configuration file
# Arguments:
#   $1 - config_file
# Returns:
#   None
#########################
keycloak_validate_configuration_file() {
    local config_file="${1:?missing config_file}"
    local listen_port
    debug "Validating settings in ${config_file}..."
    listen_port="$(keycloak_conf_get "${config_file}" "listen" | awk -F ':' '{print $2}')"
    debug "Listen Port: $listen_port"
    if ! am_i_root && ! validate_port -unprivileged "$listen_port"; then
      error "You are running this container as non_root and you set a privileged port at the 'listen' configuration option. Please choose a port > 1024"
      exit 1
    fi
}

########################
# Validate settings Keycloak Gatekeeper cmmand line options
# Globals:
#   KEYCLOAK_GATEKEEPER_CONFDIR
# Arguments:
#   None
# Returns:
#   None
#########################
keycloak_validate_command_line_options() {
    if [[ $# -eq 0 ]]; then
        error "No command line options passed. You need to set (at least) the options: '--listen', '--upstream-url', '--discovery-url' and '--client-id'"
        exit 1
    else
        local mandatory_options=("--listen" "--upstream-url" "--discovery-url" "--client-id")
        for option in "${mandatory_options[@]}"; do
            if [[ "$*" != *"$option"* ]]; then
                error "The command line option \"$option\" was not passed. Please note this option is mandatory when you don't specify a configuration file!"
                exit 1
            fi
        done
    fi
}
