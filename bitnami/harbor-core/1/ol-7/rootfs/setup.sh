#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace
# shellcheck disable=SC1091

# Load libraries
. /liblog.sh
. /libos.sh
. /libvalidations.sh

# Auxiliar Functions

########################
# Retrieve a configuration setting value
# Arguments:
#   $1 - key
# Returns:
#   None
#########################
harbor_core_conf_get() {
    local key="${1:?missing key}"
    local runmode
    local value
    if [[ -f "/etc/core/app.conf" ]]; then
        runmode="$(ini-file get "/etc/core/app.conf" --key "runmode" --section "")"
        value="$(ini-file get "/etc/core/app.conf" --key "$key" --section "$runmode")"
        echo "$value"
    fi
}

########################
# Ensures a configuration setting is not empty
# Arguments:
#   $1 - config_option
# Returns:
#   None
#########################
not_empty_setting() {
    local config_option="${1:?missing config_option}"
    if [[ -z "$(harbor_core_conf_get "$config_option")" ]]; then
        error "The configuration option \"$config_option\" must be set!"
        exit 1
    fi
}

########################
# Ensures an environment_variable
# Arguments:
#   $1 - env_var
# Returns:
#   None
#########################
not_empty_env_var() {
    local env_var="${1:?missing env_var}"
    if [[ -z "${!env_var:-}" ]]; then
        error "The environment variable \"$env_var\" must be set!"
        exit 1
    fi
}

########################
# Validate Core settings
# Arguments:
#   None
# Returns:
#   None
#########################
harbor_core_validate() {
    info "Validating Core settings..."

    if [[ ! -f "/etc/core/key" ]]; then
        info "The key was not mounted at \"/etc/core/key\". Will use environment variable \"CORE_KEY\" instead."
        not_empty_env_var "CORE_KEY"
        echo "$CORE_KEY" >/etc/core/key
    fi

    if [[ ! -f "/etc/core/app.conf" ]]; then
        error "No configuration file was detected. Please mount your configuration file at \"/etc/core/app.conf\""
        exit 1
    fi

    not_empty_setting "httpport"
    not_empty_env_var "CORE_SECRET"
    not_empty_env_var "JOBSERVICE_SECRET"

    local validate_port_args=()
    ! am_i_root && validate_port_args+=("-unprivileged")
    if ! err=$(validate_port "${validate_port_args[@]}" "$(harbor_core_conf_get "httpport")"); then
        error "An invalid port was specified: $err"
        exit 1
    fi
}

# Ensure Harbor Core settings are valid
harbor_core_validate
