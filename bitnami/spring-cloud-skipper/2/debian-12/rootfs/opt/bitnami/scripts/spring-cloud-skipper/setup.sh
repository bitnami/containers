#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami Spring Cloud Skipper setup

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Generic Libraries
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libos.sh

# Load Spring Cloud Skipper environment variables
. /opt/bitnami/scripts/spring-cloud-skipper-env.sh

# Ensure 'daemon' user exists when running as 'root'
am_i_root && ensure_user_exists "$SPRING_CLOUD_DATAFLOW_DAEMON_USER" --group "$SPRING_CLOUD_DATAFLOW_DAEMON_GROUP"

# Validations
# Ensure Spring Cloud Skipper environment variables settings are valid
info "Validating settings in SPRING_CLOUD_SKIPPER_* env vars"
error_code=0

print_validation_error() {
    error "$1"
    error_code=1
}

if [[ "$SPRING_CLOUD_KUBERNETES_SECRETS_ENABLE_API" = "true" ]]; then
    if is_empty_value "$SPRING_CLOUD_KUBERNETES_SECRETS_PATHS"; then
        print_validation_error "You set the environment variable SPRING_CLOUD_KUBERNETES_SECRETS_ENABLE_API=true. A Kubernetes secrect is expected to be mounted in SPRING_CLOUD_KUBERNETES_SECRETS_PATHS."
    else
        warn "Using Kubernetes Secrets."
    fi

    is_empty_value "$SPRING_CLOUD_KUBERNETES_CONFIG_NAME" && print_validation_error "If SPRING_CLOUD_KUBERNETES_SECRETS_ENABLE_API=true. You must set a ConfigMap name in SPRING_CLOUD_KUBERNETES_CONFIG_NAME."
fi

! is_empty_value "$SERVER_PORT" && ! validate_port -unprivileged "$SERVER_PORT" && print_validation_error "SERVER_PORT with value = ${SERVER_PORT} is not a valid port."

exit "$error_code"
