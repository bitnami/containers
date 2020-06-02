#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/libphp.sh
. /opt/bitnami/scripts/libphppgadmin.sh

# Load phpPgAdmin environment
. /opt/bitnami/scripts/phppgadmin-env.sh

# Ensure phpPgAdmin environment variables are valid
phppgadmin_validate

# Ensure phpPgAdmin is initialized
phppgadmin_initialize

# Load additional required libraries
# shellcheck disable=SC1091
. /opt/bitnami/scripts/libwebserver.sh

# Configure web server for phpPgAdmin based on the runtime environment
info "Enabling web server application configuration for phpPgAdmin"
phppgadmin_ensure_web_server_app_configuration_exists
