#!/bin/bash
#
# Bitnami Spring Cloud Data Flow postunpack

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libspringclouddataflow.sh

# Load Spring Cloud Data Flow environment variables
. /opt/bitnami/scripts/spring-cloud-dataflow-env.sh

# Configure Spring Cloud Data Flow options based on build-time defaults
info "Configuring default Spring Cloud Data Flow options"
ensure_dir_exists "$SPRING_CLOUD_DATAFLOW_CONF_DIR"
dataflow_create_default_config

for dir in "${SPRING_CLOUD_DATAFLOW_VOLUME_DIR}" "${SPRING_CLOUD_DATAFLOW_CONF_DIR}" "${SPRING_CLOUD_DATAFLOW_LOGS_DIR}" "${SPRING_CLOUD_DATAFLOW_TMP_DIR}"; do
    ensure_dir_exists "$dir"
    chmod -R g+rwX "$dir"
done
