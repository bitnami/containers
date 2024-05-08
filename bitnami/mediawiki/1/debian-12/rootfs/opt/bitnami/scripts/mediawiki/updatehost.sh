#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load MediaWiki environment
. /opt/bitnami/scripts/mediawiki-env.sh

# Load libraries
. /opt/bitnami/scripts/libmediawiki.sh
. /opt/bitnami/scripts/libvalidations.sh

info "Updating wgServer option"
MEDIAWIKI_SERVER_HOST="${1:?missing host}"
mediawiki_configure_host "$MEDIAWIKI_SERVER_HOST"

# Reload PHP-FPM configuration to ensure that the home page redirects to the new domain
if [[ "${BITNAMI_SERVICE_MANAGER:-}" = "systemd" ]]; then
    systemctl reload bitnami.php-fpm.service
else
    /opt/bitnami/scripts/php/reload.sh
fi
