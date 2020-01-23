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
harbor_jobservice_conf_get() {
    local key="${1:?missing key}"
    local value
    if [[ -f "/etc/jobservice/config.yml" ]]; then
        value="$(yq read "/etc/jobservice/config.yml" "$key")"
        if [[ "$value" != "null" ]]; then
            echo "$value"
        fi
    fi
}

########################
# Ensures a configuration setting is not empty
# Arguments:
#   $1 - env_var
#   $2 - config_option
# Returns:
#   None
#########################
not_empty_setting() {
    local env_var="${1:?missing env_var}"
    local config_option="${2:?missing config_option}"
    if [[ -z "${!env_var:-$(harbor_jobservice_conf_get "$config_option")}" ]]; then
        error "The environment variable \"$env_var\" or the configuration option \"$config_option\" must be set!"
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
# Validate Job Service settings
# Arguments:
#   None
# Returns:
#   None
#########################
harbor_jobservice_validate() {
    info "Validating Job Service settings..."

    if [[ ! -f "/etc/jobservice/config.yml" ]]; then
        error "No configuration file was detected. Please mount your configuration file at \"/etc/jobservice/config.yml\""
        exit 1
    fi

    not_empty_setting "JOB_SERVICE_PROTOCOL" "protocol"
    not_empty_setting "JOB_SERVICE_PORT" "port"
    not_empty_setting "JOB_SERVICE_POOL_WORKERS" "worker_pool.workers"
    not_empty_setting "JOB_SERVICE_POOL_BACKEND" "worker_pool.backend"
    not_empty_env_var "JOBSERVICE_SECRET"

    if [[ "${JOB_SERVICE_PROTOCOL:-$(harbor_jobservice_conf_get "protocol")}" != "http" ]] && \
       [[ "${JOB_SERVICE_PROTOCOL:-$(harbor_jobservice_conf_get "protocol")}" != "https" ]]; then
        error "Protocol must be \"http\" or \"https\"!"
        exit 1
    fi
    local validate_port_args=()
    ! am_i_root && validate_port_args+=("-unprivileged")
    if ! err=$(validate_port "${validate_port_args[@]}" "${JOB_SERVICE_PORT:-$(harbor_jobservice_conf_get "port")}"); then
        error "An invalid port was specified: $err"
        exit 1
    fi
}

# Ensure Harbor Job Service settings are valid
harbor_jobservice_validate
