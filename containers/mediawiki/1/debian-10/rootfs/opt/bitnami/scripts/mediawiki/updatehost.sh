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

info "Purging cache"
debug_execute php "${MEDIAWIKI_BASE_DIR}/maintenance/purgeList.php" --purge --all
