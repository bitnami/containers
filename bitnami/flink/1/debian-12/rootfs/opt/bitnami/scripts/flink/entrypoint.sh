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

# Load Apache Flink environment variables
. /opt/bitnami/scripts/flink-env.sh

print_welcome_page

# We add the copy from default config in the entrypoint to not break users 
# bypassing the setup.sh logic. If the file already exists do not overwrite (in
# case someone mounts a configuration file in /opt/bitnami/flink/conf)
debug "Copying files from $FLINK_DEFAULT_CONF_DIR to $FLINK_CONF_DIR"
cp -nfr "$FLINK_DEFAULT_CONF_DIR"/. "$FLINK_CONF_DIR"

if [[ "$1" = "/opt/bitnami/scripts/flink/run.sh" ]]; then
    info "** Starting Apache Flink ${FLINK_MODE} setup **"
    /opt/bitnami/scripts/flink/setup.sh
    info "** FLINK ${FLINK_MODE} setup finished! **"
fi

echo ""
exec "$@"
