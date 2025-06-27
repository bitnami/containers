#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libtomcat.sh
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh

# Load Tomcat environment variables
. /opt/bitnami/scripts/tomcat-env.sh

print_welcome_page

# We add the copy from default config in the entrypoint to not break users
# bypassing the setup.sh logic. If the file already exists do not overwrite (in
# case someone mounts a configuration file in /opt/bitnami/tomcat/conf)
debug "Copying files from $TOMCAT_DEFAULT_CONF_DIR to $TOMCAT_CONF_DIR"
cp -nr "$TOMCAT_DEFAULT_CONF_DIR"/. "$TOMCAT_CONF_DIR"

if [[ "$*" = *"/opt/bitnami/scripts/tomcat/run.sh"* ]]; then
    info "** Starting tomcat setup **"
    /opt/bitnami/scripts/tomcat/setup.sh
    info "** tomcat setup finished! **"
fi

echo ""
exec "$@"
