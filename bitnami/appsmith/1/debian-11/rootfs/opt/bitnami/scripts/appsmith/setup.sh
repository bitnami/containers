#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libappsmith.sh

# Load Appsmith environment settings
. /opt/bitnami/scripts/appsmith-env.sh

# Load NGINX environment variables
. /opt/bitnami/scripts/nginx-env.sh

# Ensure Appsmith environment settings are valid
appsmith_validate
# Ensure Appsmith is stopped when this script ends.
trap "appsmith_backend_stop" EXIT
# Ensure 'appsmith' user exists when running as 'root'
am_i_root && ensure_user_exists "$APPSMITH_DAEMON_USER" --group "$APPSMITH_DAEMON_GROUP"

appsmith_initialize
