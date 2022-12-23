#!/bin/bash

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load ownCloud environment
. /opt/bitnami/scripts/owncloud-env.sh

# Load libraries
. /opt/bitnami/scripts/libowncloud.sh
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libwebserver.sh

# Load web server environment and functions (after ownCloud environment file so MODULE is not set to a wrong value)
. "/opt/bitnami/scripts/$(web_server_type)-env.sh"

host="${1:?missing host}"

# Update ownCloud domain for file sharing URLs to work properly
# We will not be setting 'web.baseUrl' because it only affects link sharing
owncloud_configure_trusted_domains "$host"
