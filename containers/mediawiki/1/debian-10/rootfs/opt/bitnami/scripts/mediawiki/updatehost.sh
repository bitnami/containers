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

info "Updating wgServer option"
mediawiki_conf_set "\$wgServer" "//${1:?missing host}"

# Reload PHP-FPM configuration to ensure that the home page redirects to the new domain
/opt/bitnami/scripts/php/reload.sh
