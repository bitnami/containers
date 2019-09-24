#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose
# shellcheck disable=SC1091

# Load libraries
. /libfs.sh
. /libos.sh
. /libtomcat.sh

# Load Tomcat environment variables
eval "$(tomcat_env)"

# Ensure tomcat environment variables are valid
tomcat_validate

# Ensure 'daemon' user exists when running as 'root'
am_i_root && ensure_user_exists "$TOMCAT_DAEMON_USER" "$TOMCAT_DAEMON_GROUP"

# Ensure tomcat is initialized
tomcat_initialize
