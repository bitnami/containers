#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /liblogstash.sh

# Load Logstash environment variables
eval "$(logstash_env)"

# Ensure Logstash environment variables are valid
logstash_validate

# Ensure 'daemon' user exists when running as 'root'
am_i_root && ensure_user_exists "$LOGSTASH_DAEMON_USER" "$LOGSTASH_DAEMON_GROUP"

# Ensure Logstash is initialized
logstash_initialize
