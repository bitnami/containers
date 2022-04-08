#!/bin/bash

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load Magento environment
. /opt/bitnami/scripts/magento-env.sh

# Load libraries
. /opt/bitnami/scripts/libmagento.sh
. /opt/bitnami/scripts/libwebserver.sh

# Load web server environment and functions (after Magento environment file so MODULE is not set to a wrong value)
. "/opt/bitnami/scripts/$(web_server_type)-env.sh"

magento_update_hostname "$@"
