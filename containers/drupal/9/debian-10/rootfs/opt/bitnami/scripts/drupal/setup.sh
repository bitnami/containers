#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load Drupal environment
. /opt/bitnami/scripts/drupal-env.sh

# Load environment for web server configuration (after Drupal environment file so MODULE is not set to a wrong value)
. /opt/bitnami/scripts/libwebserver.sh

# Load libraries
. /opt/bitnami/scripts/libdrupal.sh

# Ensure Drupal environment variables are valid
drupal_validate

# Update web server configuration with runtime environment (needs to happen before the initialization)
web_server_update_app_configuration "drupal"

# Ensure Drupal is initialized
drupal_initialize
