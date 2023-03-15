#!/bin/bash

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libflink.sh

# Load Apache Flink environment variables
. /opt/bitnami/scripts/flink-env.sh

# Ensure ActiveMQ environment variables are valid
flink_validate

# Ensure ActiveMQ is initialized
flink_initialize
