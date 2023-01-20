#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libspark.sh

# Load Spark environment settings
. /opt/bitnami/scripts/spark-env.sh

# Ensure Spark environment variables settings are valid
spark_validate

# Ensure 'spark' user exists when running as 'root'
am_i_root && ensure_user_exists "$SPARK_DAEMON_USER" --group "$SPARK_DAEMON_GROUP"

# Ensure Spark is initialized
spark_initialize

# Run custom initialization scripts
spark_custom_init_scripts