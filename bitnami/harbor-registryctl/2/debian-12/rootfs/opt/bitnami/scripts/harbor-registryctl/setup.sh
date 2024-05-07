#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libharbor.sh

# Load environment
. /opt/bitnami/scripts/harbor-registryctl-env.sh

# Auxiliar Functions

########################
# Retrieve a configuration setting value
# Arguments:
#   $1 - key
# Returns:
#   None
#########################
harbor_registryctl_conf_get() {
    local key="${1:?missing key}"
    local value
    if [[ -f "/etc/registryctl/config.yml" ]]; then
        value="$(yq eval ".${key}" "/etc/registryctl/config.yml")"
        if [[ "$value" != "null" ]]; then
            echo "$value"
        fi
    fi
}

########################
# Ensures a configuration setting is not empty
# Arguments:
#   $1 - config_option
# Returns:
#   None
#########################
not_empty_config_option() {
    local config_option="${1:?missing config_option}"
    if [[ -z "$(harbor_registryctl_conf_get "$config_option")" ]]; then
        error "The configuration option \"$config_option\" must be set!"
        exit 1
    fi
}

########################
# Validate Registryctl settings
# Arguments:
#   None
# Returns:
#   None
#########################
harbor_registryctl_validate() {
    info "Validating harbor-registryctl settings..."

    if [[ ! -f "/etc/registryctl/config.yml" ]]; then
        error "No configuration file was detected. Please mount your configuration file at \"/etc/registryctl/config.yml\""
        exit 1
    fi

    not_empty_config_option "protocol"
    not_empty_config_option "port"

    if [[ "$(harbor_registryctl_conf_get "protocol")" != "http" ]] &&
        [[ "$(harbor_registryctl_conf_get "protocol")" != "https" ]]; then
        error "Protocol must be \"http\" or \"https\"!"
        exit 1
    fi
    local validate_port_args=()
    ! am_i_root && validate_port_args+=("-unprivileged")
    if ! err=$(validate_port "${validate_port_args[@]}" "$(harbor_registryctl_conf_get "port")"); then
        error "An invalid port was specified: $err"
        exit 1
    fi
}

# Ensure harbor-registryctl settings are valid
harbor_registryctl_validate
install_custom_certs
