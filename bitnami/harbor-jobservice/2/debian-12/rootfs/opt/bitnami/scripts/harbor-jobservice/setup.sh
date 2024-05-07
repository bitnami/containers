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
. /opt/bitnami/scripts/harbor-jobservice-env.sh

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
        value="$(yq eval ".${key}" "/etc/jobservice/config.yml")"
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
# Validate harbor-jobservice settings
# Arguments:
#   None
# Returns:
#   None
#########################
harbor_jobservice_validate() {
    info "Validating harbor-jobservice settings..."

    if [[ ! -f "/etc/jobservice/config.yml" ]]; then
        error "No configuration file was detected. Please mount your configuration file at \"/etc/jobservice/config.yml\""
        exit 1
    fi

    not_empty_setting "JOB_SERVICE_PROTOCOL" "protocol"
    not_empty_setting "JOB_SERVICE_PORT" "port"
    not_empty_setting "JOB_SERVICE_POOL_WORKERS" "worker_pool.workers"
    not_empty_setting "JOB_SERVICE_POOL_BACKEND" "worker_pool.backend"

    if [[ "${JOB_SERVICE_PROTOCOL:-$(harbor_jobservice_conf_get "protocol")}" != "http" ]] &&
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


########################
# Check if harbor-core API is reported as healthy
# Globals:
#   CORE_URL
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_harbor_core_ready() {
    if [[ -n "${HARBOR_JOBSERVICE_CFG_CORE_URL:-}" && -z "${CORE_URL:-}" ]]; then
        # Hack to support VMs approach to initializing Harbor components
        export CORE_URL="$HARBOR_JOBSERVICE_CFG_CORE_URL"
    fi
    not_empty_env_var "CORE_URL"

    local -r status="$(yq eval '.components[]|select(.name == "core").status' - <<<"$(curl -s "${CORE_URL}/api/v2.0/health")")"
    [[ "$status" = "healthy" ]]
}

########################
# Waits for harbor-core to be ready
# Times out after 60 seconds
# Globals:
#   INFLUXDB_*
# Arguments:
#   None
# Returns:
#   None
########################
wait_for_harbor_core() {
    info "Waiting for harbor-core to be started and ready"
    if ! retry_while "is_harbor_core_ready"; then
        error "Timeout waiting for harbor-core to be available"
        return 1
    fi
}

# Ensure harbor-jobservice settings are valid
harbor_jobservice_validate
install_custom_certs
wait_for_harbor_core
