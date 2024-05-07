#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libharbor.sh

# Load environment
. /opt/bitnami/scripts/harbor-core-env.sh

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
        if [[ -n "${HARBOR_CORE_CFG_CORE_KEY:-}" && -z "${CORE_KEY:-}" ]]; then
            # Hack to support VMs approach to initializing Harbor components
            export CORE_KEY="$HARBOR_CORE_CFG_CORE_KEY"
        fi
        not_empty_env_var "CORE_KEY"
        echo -n "$CORE_KEY" >/etc/core/key
    fi

    if [[ ! -f "/etc/core/app.conf" ]]; then
        error "No configuration file was detected. Please mount your configuration file at \"/etc/core/app.conf\""
        exit 1
    fi

    not_empty_setting "httpport"
    local validate_port_args=()
    ! am_i_root && validate_port_args+=("-unprivileged")
    if ! err=$(validate_port "${validate_port_args[@]}" "$(harbor_core_conf_get "httpport")"); then
        error "An invalid port was specified: $err"
        exit 1
    fi
}

# Ensure harbor-core settings are valid
harbor_core_validate
install_custom_certs
