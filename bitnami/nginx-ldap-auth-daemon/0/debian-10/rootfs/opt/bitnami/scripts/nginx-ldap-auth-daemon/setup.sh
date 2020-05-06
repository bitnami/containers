#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/libnginxldapauthdaemon.sh

# Load NGINX environment variables
eval "$(nginxldap_env)"

# Ensure NGINX environment variables are valid
nginxldap_validate
