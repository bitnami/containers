#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose
# shellcheck disable=SC1091

# Load libraries
. /liblog.sh
. /libkeycloak.sh

# Load Keycloak Gatekeeper environment variables
eval "$(keycloak_env)"

config_yaml="$(basename "$(find "$KEYCLOAK_GATEKEEPER_CONFDIR" -type f -name 'config.yml' -o -name 'config.yaml')")"
config_json="$(basename "$(find "$KEYCLOAK_GATEKEEPER_CONFDIR" -type f -name 'config.json')")"
if [[ -n "${config_yaml}" || -n "${config_json}" ]]; then
    info "==> Custom configuration file detected!!"
    if [[ -n "${config_yaml}" ]]; then
        keycloak_validate_configuration_file "${config_yaml}"
    elif [[ -n "${config_json}" ]]; then
        keycloak_validate_configuration_file "${config_json}"
    fi
else
    info "==> No configuration file detected. Using command line options..."
    keycloak_validate_command_line_options "$@"
fi
