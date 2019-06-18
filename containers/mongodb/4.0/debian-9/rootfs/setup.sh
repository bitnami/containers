#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
# shellcheck disable=SC1091

# Load libraries
. /libfs.sh
. /libos.sh
. /libmongodb.sh

# Load MongoDB env. variables
eval "$(mongodb_env)"

# Ensure MySQL env var settings are valid
info "Validating"
mongodb_validate
# Ensure MongoDB is stopped when this script ends.
trap "mongodb_stop" EXIT
# Ensure 'daemon' user exists when running as 'root'
am_i_root && ensure_user_exists "$MONGODB_DAEMON_USER" "$MONGODB_DAEMON_GROUP"

# Ensure MongoDB is initialized
mongodb_initialize
