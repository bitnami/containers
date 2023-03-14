#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh

# Load Apache Flink environment variables
. /opt/bitnami/scripts/flink-env.sh

print_welcome_page

if [[ "$1" = "/opt/bitnami/scripts/flink/run.sh" ]]; then
    info "** Starting Apache Flink ${FLINK_MODE} setup **"
    /opt/bitnami/scripts/flink/setup.sh
    info "** FLINK ${FLINK_MODE} setup finished! **"
fi

echo ""
exec "$@"
