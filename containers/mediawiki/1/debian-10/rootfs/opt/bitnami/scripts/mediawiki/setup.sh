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

# Ensure MediaWiki environment variables are valid
mediawiki_validate

# Load web server environment and functions (after MediaWiki environment file so MODULE is not set to a wrong value)
# shellcheck disable=SC1091
. /opt/bitnami/scripts/libwebserver.sh
# Load additional libraries
. /opt/bitnami/scripts/libos.sh

# Ensure proper ownership for MediaWiki directories
if am_i_root; then
    info "Ensuring MediaWiki directories have proper permissions"
    ensure_user_exists "$WEB_SERVER_DAEMON_USER" "$WEB_SERVER_DAEMON_GROUP"
    for dir in "${MEDIAWIKI_BASE_DIR}/images" "${MEDIAWIKI_BASE_DIR}/cache"; do
        ensure_dir_exists "$dir"
        configure_permissions_ownership "$dir" -u "$WEB_SERVER_DAEMON_USER" -g "$WEB_SERVER_DAEMON_GROUP"
    done
fi

# Ensure MediaWiki is initialized
mediawiki_initialize
