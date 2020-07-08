#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load MediaWiki environment
. /opt/bitnami/scripts/mediawiki-env.sh

# Load environment for web server configuration (after MediaWiki environment file so MODULE is not set to a wrong value)
. /opt/bitnami/scripts/libwebserver.sh

# Load libraries
. /opt/bitnami/scripts/libmediawiki.sh

# Ensure MediaWiki environment variables are valid
mediawiki_validate

# Update web server configuration with runtime environment (needs to happen before the initialization)
web_server_update_app_configuration "mediawiki"

# Ensure MediaWiki is initialized
mediawiki_initialize
