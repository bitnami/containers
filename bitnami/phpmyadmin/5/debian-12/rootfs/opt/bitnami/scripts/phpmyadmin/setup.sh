#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load phpMyAdmin environment
. /opt/bitnami/scripts/phpmyadmin-env.sh

# Load libraries
. /opt/bitnami/scripts/libphpmyadmin.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libwebserver.sh

# Load web server environment and functions (after phpMyAdmin environment file so MODULE is not set to a wrong value)
. "/opt/bitnami/scripts/$(web_server_type)-env.sh"

# Ensure phpMyAdmin environment variables are valid
phpmyadmin_validate

# Ensure phpMyAdmin is initialized
phpmyadmin_initialize

# Configure web server for phpMyAdmin based on the runtime environment
info "Enabling web server application configuration for phpMyAdmin"
phpmyadmin_ensure_web_server_app_configuration_exists
