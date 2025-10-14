#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh

# Load Mastodon environment variables
. /opt/bitnami/scripts/mastodon-env.sh

print_welcome_page

if [[ "$1" = "/opt/bitnami/scripts/mastodon/run.sh" ]]; then
    info "** Starting Mastodon ${MASTODON_MODE} setup **"
    /opt/bitnami/scripts/mastodon/setup.sh
    info "** Mastodon ${MASTODON_MODE} setup finished! **"
fi

echo ""
exec "$@"
