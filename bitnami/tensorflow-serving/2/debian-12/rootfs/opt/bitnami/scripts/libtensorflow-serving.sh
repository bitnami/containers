#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami Solr library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libpersistence.sh
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libvalidations.sh

########################
# Validate parameters
# Globals:
#   TENSORFLOW_SERVING_*
# Arguments:
#   None
# Returns:
#   None
#########################
tensorflow_serving_validate() {
    info "Validating settings in TENSORFLOW_SERVING_* env vars..."
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }

    ! is_yes_no_value "$TENSORFLOW_SERVING_ENABLE_MONITORING" && print_validation_error "TENSORFLOW_SERVING_ENABLE_MONITORING possible values are yes or no"
    is_boolean_yes "$TENSORFLOW_SERVING_ENABLE_MONITORING" && [[ -z "$TENSORFLOW_SERVING_MONITORING_PATH" ]] && print_validation_error "TENSORFLOW_SERVING_MONITORING_PATH could not be empty"

    [[ -z "$TENSORFLOW_SERVING_MODEL_NAME" ]] && print_validation_error "TENSORFLOW_SERVING_MODEL_NAME could not be empty"

    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}

########################
# Generate config files from mounted files, if mounted, or render config templates
# Globals:
#   TENSORFLOW_SERVING_*
# Arguments:
#   None
# Returns:
#   None
#########################
tensorflow_serving_generate_config() {
    local template_dir="${BITNAMI_ROOT_DIR}/scripts/tensorflow-serving/bitnami-templates"

    export tensorflow_monitoring_enable="false"
    is_boolean_yes "$TENSORFLOW_SERVING_ENABLE_MONITORING" && tensorflow_monitoring_enable="true"

    if [[ -f "${TENSORFLOW_SERVING_VOLUME_DIR}/conf/monitoring.config" ]]; then
        info "Detected mounted monitoring.config configuration file"
        cp "${TENSORFLOW_SERVING_VOLUME_DIR}/conf/monitoring.config" "$TENSORFLOW_SERVING_MONITORING_CONF_FILE"
    else
        info "Rendering monitoring.config configuration file from template"
        render-template "${template_dir}/monitoring.config.tpl" > "$TENSORFLOW_SERVING_MONITORING_CONF_FILE"
    fi

    if [[ -f "${TENSORFLOW_SERVING_VOLUME_DIR}/conf/tensorflow-serving.conf" ]]; then
        info "Detected mounted tensorflow-serving.conf configuration file"
        cp "${TENSORFLOW_SERVING_VOLUME_DIR}/conf/tensorflow-serving.conf" "$TENSORFLOW_SERVING_CONF_FILE"
    else
        info "Rendering tensorflow-serving.conf configuration file from template"
        render-template "${template_dir}/tensorflow-serving.conf.tpl" > "$TENSORFLOW_SERVING_CONF_FILE"
    fi
}


########################
# Check if Tensorflow serving is running
# Globals:
#   TENSORFLOW_SERVING_*
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_tensorflow_serving_running() {
    local pid
    pid="$(get_pid_from_file "${TENSORFLOW_SERVING_PID_FILE}")"

    if [[ -z "$pid" ]]; then
        false
    else
        is_service_running "$pid"
    fi
}

########################
# Check if tensorflow serving is not running
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_tensorflow_serving_not_running() {
    ! is_tensorflow_serving_running
}

########################
# Initialize Tensorflow serving
# Globals:
#   TENSORFLOW_SERVING_*
# Arguments:
#   None
# Returns:
#   None
#########################
tensorflow_serving_initialize() {
    info "Initializing Tensorflow Serving ..."

    # Ensure the tensorflow-serving base directory exists and has proper permissions
    info "Configuring file permissions for Tensorflow Serving"
    ensure_dir_exists "$TENSORFLOW_SERVING_VOLUME_DIR"

    rm -f "$TENSORFLOW_SERVING_PID_FILE"

    tensorflow_serving_generate_config
}
