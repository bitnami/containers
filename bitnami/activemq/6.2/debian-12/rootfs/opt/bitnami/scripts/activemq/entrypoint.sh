#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh

# Load environment
. /opt/bitnami/scripts/activemq-env.sh

print_welcome_page

# We add the copy from default config in the entrypoint to not break users 
# bypassing the setup.sh logic. If the file already exists do not overwrite (in
# case someone mounts a configuration file in /opt/bitnami/activemq/conf)
debug "Copying files from $ACTIVEMQ_DEFAULT_CONF_DIR to $ACTIVEMQ_CONF_DIR"
cp -nr "$ACTIVEMQ_DEFAULT_CONF_DIR"/. "$ACTIVEMQ_CONF_DIR"

if [[ "$1" = "/opt/bitnami/scripts/activemq/run.sh" ]]; then
    info "** Starting ActiveMQ setup **"
    /opt/bitnami/scripts/activemq/setup.sh
    info "** ActiveMQ setup finished! **"
fi

echo ""
exec "$@"