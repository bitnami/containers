#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/libphp.sh
. /opt/bitnami/scripts/libphpmyadmin.sh

# Load phpMyAdmin environment
. /opt/bitnami/scripts/phpmyadmin-env.sh

# Ensure phpMyAdmin environment variables are valid
phpmyadmin_validate

# Ensure phpMyAdmin is initialized
phpmyadmin_initialize

# Load additional required libraries
# shellcheck disable=SC1091
. /opt/bitnami/scripts/libwebserver.sh

# Configure web server for phpMyAdmin based on the runtime environment
info "Enabling web server application configuration for phpMyAdmin"
phpmyadmin_ensure_web_server_app_configuration_exists
