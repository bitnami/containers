#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load WordPress environment
. /opt/bitnami/scripts/wordpress-env.sh

# Load PHP environment for 'wp_execute' (after 'wordpress-env.sh' so that MODULE is not set to a wrong value)
. /opt/bitnami/scripts/php-env.sh

# Load MySQL Client environment for 'mysql_remote_execute' (after 'wordpress-env.sh' so that MODULE is not set to a wrong value)
if [[ -f /opt/bitnami/scripts/mysql-client-env.sh ]]; then
    . /opt/bitnami/scripts/mysql-client-env.sh
elif [[ -f /opt/bitnami/scripts/mysql-env.sh ]]; then
    . /opt/bitnami/scripts/mysql-env.sh
elif [[ -f /opt/bitnami/scripts/mariadb-env.sh ]]; then
    . /opt/bitnami/scripts/mariadb-env.sh
fi

# Load libraries
. /opt/bitnami/scripts/libwordpress.sh
. /opt/bitnami/scripts/libwebserver.sh

# Load web server environment (after WordPress environment file so MODULE is not set to a wrong value)
. "/opt/bitnami/scripts/$(web_server_type)-env.sh"

# Ensure WordPress environment variables are valid
wordpress_validate

# Re-create web server configuration with runtime environment (needs to happen before the initialization)
wordpress_generate_web_server_configuration

# Ensure WordPress is initialized
wordpress_initialize
