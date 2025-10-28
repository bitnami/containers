#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libapache.sh
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh

# Load Apache environment
. /opt/bitnami/scripts/apache-env.sh

print_welcome_page

# We add the copy from default config in the entrypoint to not break users
# bypassing the setup.sh logic. If the file already exists do not overwrite (in
# case someone mounts a configuration file in /opt/bitnami/apache/conf)
debug "Copying files from $APACHE_DEFAULT_CONF_DIR to $APACHE_CONF_DIR"
cp -nr "$APACHE_DEFAULT_CONF_DIR"/. "$APACHE_CONF_DIR"

if [[ "$*" == *"/opt/bitnami/scripts/apache/run.sh"* ]]; then
    info "** Starting Apache setup **"
    /opt/bitnami/scripts/apache/setup.sh
    info "** Apache setup finished! **"
fi

echo ""
exec "$@"
