#!/bin/bash
#
# Bitnami Spring Cloud Data Flow setup

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load Generic Libraries
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libspringclouddataflow.sh

# Load Spring Cloud Data Flow environment variables
. /opt/bitnami/scripts/spring-cloud-dataflow-env.sh

# Ensure Spring Cloud Data Flow environment variables settings are valid
dataflow_validate
# Ensure 'daemon' user exists when running as 'root'
am_i_root && ensure_user_exists "$SPRING_CLOUD_DATAFLOW_DAEMON_USER" "$SPRING_CLOUD_DATAFLOW_DAEMON_GROUP"
# Ensure Spring Cloud Data Flow is initialized
dataflow_initialize
