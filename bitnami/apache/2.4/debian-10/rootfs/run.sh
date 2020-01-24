#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /libapache.sh
. /liblog.sh

# Load Apache environment
eval "$(apache_env)"

info "** Starting apache **"
exec "${APACHE_BIN_DIR}/httpd" -f "$APACHE_CONF_FILE" -D "FOREGROUND"
