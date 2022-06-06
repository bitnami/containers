#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/libgeode.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh

# Load Apache Geode environment
. /opt/bitnami/scripts/geode-env.sh

# Ensure Apache Geode environment variables are valid
geode_validate

if am_i_root; then
    info "Creating Apache Geode daemon user"
    ensure_user_exists "$GEODE_DAEMON_USER" --group "$GEODE_DAEMON_GROUP" --system
fi

# Ensure Apache Geode is initialized
geode_initialize

# Apache Geode init scripts
geode_custom_init_scripts
