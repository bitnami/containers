#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Drupal environment
. /opt/bitnami/scripts/drupal-env.sh

# Load MySQL Client environment for 'mysql_remote_execute' (after 'drupal-env.sh' so that MODULE is not set to a wrong value)
if [[ -f /opt/bitnami/scripts/mysql-client-env.sh ]]; then
    . /opt/bitnami/scripts/mysql-client-env.sh
elif [[ -f /opt/bitnami/scripts/mysql-env.sh ]]; then
    . /opt/bitnami/scripts/mysql-env.sh
elif [[ -f /opt/bitnami/scripts/mariadb-env.sh ]]; then
    . /opt/bitnami/scripts/mariadb-env.sh
fi

# Load libraries
. /opt/bitnami/scripts/libdrupal.sh
. /opt/bitnami/scripts/libwebserver.sh

# Load web server environment and functions (after Drupal environment file so MODULE is not set to a wrong value)
. "/opt/bitnami/scripts/$(web_server_type)-env.sh"

# Ensure Drupal environment variables are valid
drupal_validate

# Update web server configuration with runtime environment (needs to happen before the initialization)
web_server_update_app_configuration "drupal"

# Ensure Drupal is initialized
drupal_initialize
