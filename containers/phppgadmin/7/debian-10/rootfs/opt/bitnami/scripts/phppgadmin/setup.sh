#!/bin/bash

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load phpPgAdmin environment
. /opt/bitnami/scripts/phppgadmin-env.sh

# Load libraries
. /opt/bitnami/scripts/libphppgadmin.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libwebserver.sh

# Load web server environment and functions (after phpPgAdmin environment file so MODULE is not set to a wrong value)
. "/opt/bitnami/scripts/$(web_server_type)-env.sh"

# Ensure phpPgAdmin environment variables are valid
phppgadmin_validate

# Ensure phpPgAdmin is initialized
phppgadmin_initialize

# Configure web server for phpPgAdmin based on the runtime environment
if is_empty_value "$PHPPGADMIN_URL_PREFIX"; then
    info "Enabling web server application configuration for phpPgAdmin"
    phppgadmin_ensure_web_server_app_configuration_exists
else
    info "Enabling web server application prefix configuration for phpPgAdmin"
    phppgadmin_ensure_web_server_prefix_configuration_exists
fi
