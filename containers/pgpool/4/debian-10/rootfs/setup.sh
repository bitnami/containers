#!/bin/bash
#
# Bitnami Pgpool setup

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# shellcheck disable=SC1091

# Load libraries
. /libpgpool.sh

# Load Pgpool env. variables
eval "$(pgpool_env)"

# Ensure Pgpool environment variables are valid
pgpool_validate
# Ensure 'daemon' user exists when running as 'root'
am_i_root && ensure_user_exists "$PGPOOL_DAEMON_USER" "$PGPOOL_DAEMON_GROUP"
# Ensure Pgpool is initialized
pgpool_initialize
# Allow running custom initialization scripts
pgpool_custom_init_scripts
