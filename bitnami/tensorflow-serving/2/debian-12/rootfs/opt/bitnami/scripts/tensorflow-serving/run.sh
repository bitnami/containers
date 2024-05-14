#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libtensorflow-serving.sh

# Load tensorflow environment variables
. /opt/bitnami/scripts/tensorflowserving-env.sh

info "** Starting Tensorflow **"
start_command=("${TENSORFLOW_SERVING_BASE_DIR}/serving/bazel-bin/tensorflow_serving/model_servers/tensorflow_model_server" \
    "--port=${TENSORFLOW_SERVING_PORT_NUMBER}" \
    "--rest_api_port=${TENSORFLOW_SERVING_REST_API_PORT_NUMBER}" \
    "--model_config_file=${TENSORFLOW_SERVING_CONF_FILE}" \
    "--monitoring_config_file=${TENSORFLOW_SERVING_MONITORING_CONF_FILE}" \
    "--file_system_poll_wait_seconds=5" )

if am_i_root; then
    exec_as_user "$TENSORFLOW_SERVING_DAEMON_USER" "${start_command[@]}"
else
    exec "${start_command[@]}"
fi
