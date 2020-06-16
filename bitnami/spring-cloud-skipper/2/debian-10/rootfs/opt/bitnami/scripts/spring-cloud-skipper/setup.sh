#!/bin/bash
#
# Bitnami Spring Cloud Skipper setup

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load Generic Libraries
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libspringcloudskipper.sh

# Load Spring Cloud Skipper environment variables
. /opt/bitnami/scripts/spring-cloud-skipper-env.sh

# Ensure Spring Cloud Skipper environment variables settings are valid
skipper_validate
# Ensure 'daemon' user exists when running as 'root'
am_i_root && ensure_user_exists "$SPRING_CLOUD_DATAFLOW_DAEMON_USER" "$SPRING_CLOUD_DATAFLOW_DAEMON_GROUP"
# Ensure Spring Cloud Skipper is initialized
skipper_initialize
