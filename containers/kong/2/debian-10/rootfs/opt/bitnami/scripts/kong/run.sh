#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libkong.sh

# Load Kong environment variables
eval "$(kong_env)"
if is_boolean_yes "$KONG_EXIT_AFTER_MIGRATE"; then
    info "** Container configured to just perform the database migration (KONG_EXIT_AFTER_MIGRATE=yes). Exiting now **"
    exit 0
else
    info "** Starting Kong **"
    exec kong start
fi
