#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace
# shellcheck disable=SC1091

# Load libraries
. /libos.sh
. /libfs.sh
. /libspark.sh

# Load Spark environment variables
eval "$(spark_env)"

# Ensure Spark environment variables settings are valid
spark_validate

# Ensure 'spark' user exists when running as 'root'
am_i_root && ensure_user_exists "$SPARK_DAEMON_USER" "$SPARK_DAEMON_GROUP"

# Ensure Spark is initialized
spark_initialize
