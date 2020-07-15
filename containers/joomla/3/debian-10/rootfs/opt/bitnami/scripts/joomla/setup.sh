#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load Joomla! environment
. /opt/bitnami/scripts/joomla-env.sh

  # Load environment for web server configuration (after Joomla! environment file so MODULE is not set to a wrong value)
. /opt/bitnami/scripts/libwebserver.sh

# Load libraries
. /opt/bitnami/scripts/libjoomla.sh

# Ensure Joomla! environment variables are valid
joomla_validate

# Update web server configuration with runtime environment (needs to happen before the initialization)
web_server_update_app_configuration "joomla"

joomla_initialize
