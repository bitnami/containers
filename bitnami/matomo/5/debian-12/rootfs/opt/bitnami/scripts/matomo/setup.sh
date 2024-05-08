#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Matomo environment
. /opt/bitnami/scripts/matomo-env.sh

# Load MySQL Client environment for 'mysql_remote_execute' (after 'matomo-env.sh' so that MODULE is not set to a wrong value)
if [[ -f /opt/bitnami/scripts/mysql-client-env.sh ]]; then
    . /opt/bitnami/scripts/mysql-client-env.sh
elif [[ -f /opt/bitnami/scripts/mysql-env.sh ]]; then
    . /opt/bitnami/scripts/mysql-env.sh
elif [[ -f /opt/bitnami/scripts/mariadb-env.sh ]]; then
    . /opt/bitnami/scripts/mariadb-env.sh
fi

# Load libraries
. /opt/bitnami/scripts/libmatomo.sh
. /opt/bitnami/scripts/libwebserver.sh

# Load web server environment and functions (after Matomo environment file so MODULE is not set to a wrong value)
. "/opt/bitnami/scripts/$(web_server_type)-env.sh"
# Load PHP environment for cron configuration (after 'matomo-env.sh' so that MODULE is not set to a wrong value)
. /opt/bitnami/scripts/php-env.sh

# Ensure Matomo environment variables are valid
matomo_validate

# Update web server configuration with runtime environment (needs to happen before the initialization)
web_server_update_app_configuration "matomo"

# Ensure Matomo is initialized
matomo_initialize
