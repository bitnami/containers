#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load OpenCart environment
. /opt/bitnami/scripts/opencart-env.sh

# Load libraries
. /opt/bitnami/scripts/libopencart.sh

DOMAIN="${1:?missing host}"

# Set URL store configuration file
opencart_conf_set HTTP_SERVER "http://${DOMAIN}/"
opencart_conf_set HTTPS_SERVER "https://${DOMAIN}/"

# Set URL in admin configuration file
opencart_conf_set HTTP_SERVER "http://${DOMAIN}/admin/" "$OPENCART_ADMIN_CONF_FILE"
opencart_conf_set HTTP_CATALOG "http://${DOMAIN}/" "$OPENCART_ADMIN_CONF_FILE"
opencart_conf_set HTTPS_SERVER "https://${DOMAIN}/admin/" "$OPENCART_ADMIN_CONF_FILE"
opencart_conf_set HTTPS_CATALOG "https://${DOMAIN}/" "$OPENCART_ADMIN_CONF_FILE"
