#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load MediaWiki environment
. /opt/bitnami/scripts/mediawiki-env.sh

# Load libraries
. /opt/bitnami/scripts/libmediawiki.sh
. /opt/bitnami/scripts/libvalidations.sh

info "Updating wgServer option"
MEDIAWIKI_SERVER_HOST="${1:?missing host}"
if is_boolean_yes "$MEDIAWIKI_ENABLE_HTTPS"; then
    MEDIAWIKI_SERVER_URL="https://${MEDIAWIKI_SERVER_HOST}"
    [[ "$MEDIAWIKI_EXTERNAL_HTTPS_PORT_NUMBER" != "443" ]] && MEDIAWIKI_SERVER_URL+=":${MEDIAWIKI_EXTERNAL_HTTPS_PORT_NUMBER}"
else
    MEDIAWIKI_SERVER_URL="http://${MEDIAWIKI_SERVER_HOST}"
    [[ "$MEDIAWIKI_EXTERNAL_HTTP_PORT_NUMBER" != "80" ]] && MEDIAWIKI_SERVER_URL+=":${MEDIAWIKI_EXTERNAL_HTTP_PORT_NUMBER}"
fi
mediawiki_conf_set "\$wgServer" "$MEDIAWIKI_SERVER_URL"

# Reload PHP-FPM configuration to ensure that the home page redirects to the new domain
/opt/bitnami/scripts/php/reload.sh
