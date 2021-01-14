#!/bin/bash
#
# Bitnami Spring Cloud Skipper run

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh

# Load Spring Cloud Skipper environment variables
. /opt/bitnami/scripts/spring-cloud-skipper-env.sh

info "** Starting Spring Cloud Skipper **"

__run_cmd="java"
__run_flags=($JAVA_OPTS "-jar" "-Duser.home=${HOME}" "${SPRING_CLOUD_SKIPPER_BASE_DIR}/spring-cloud-skipper.jar" "--spring.config.additional-location=${SPRING_CLOUD_SKIPPER_CONF_FILE}" "$@")

if am_i_root; then
    exec gosu "$SPRING_CLOUD_SKIPPER_DAEMON_USER" "$__run_cmd" "${__run_flags[@]}"
else
    exec "$__run_cmd" "${__run_flags[@]}"
fi
