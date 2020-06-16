#!/bin/bash
#
# Bitnami Spring Cloud Skipper postunpack

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libspringcloudskipper.sh

# Load Spring Cloud Skipper environment variables
. /opt/bitnami/scripts/spring-cloud-skipper-env.sh

# Configure Spring Cloud Skipper options based on build-time defaults
info "Configuring default Spring Cloud Skipper options"
ensure_dir_exists "$SPRING_CLOUD_SKIPPER_CONF_DIR"
skipper_create_default_config

for dir in "${SPRING_CLOUD_SKIPPER_VOLUME_DIR}" "${SPRING_CLOUD_SKIPPER_CONF_DIR}" "${SPRING_CLOUD_SKIPPER_LOGS_DIR}" "${SPRING_CLOUD_SKIPPER_TMP_DIR}"; do
    ensure_dir_exists "$dir"
    chmod -R g+rwX "$dir"
done
