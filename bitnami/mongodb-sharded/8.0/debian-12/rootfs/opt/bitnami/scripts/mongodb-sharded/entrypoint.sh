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
. /opt/bitnami/scripts/libmongodb.sh
. /opt/bitnami/scripts/libmongodb-sharded.sh

# Load MongoDB env. variables
. /opt/bitnami/scripts/mongodb-env.sh

print_welcome_page

# We add the copy from default config in the entrypoint to not break users 
# bypassing the setup.sh logic. If the file already exists do not overwrite (in
# case someone mounts a configuration file in /opt/bitnami/mongodb/conf)
debug "Copying files from $MONGODB_DEFAULT_CONF_DIR to $MONGODB_CONF_DIR"
cp -nr "$MONGODB_DEFAULT_CONF_DIR"/. "$MONGODB_CONF_DIR"

if [[ "$*" = *"/opt/bitnami/scripts/mongodb-sharded/run.sh"* || "$*" = *"/run.sh"* ]]; then
    info "** Starting MongoDB Sharded setup **"
    /opt/bitnami/scripts/mongodb-sharded/setup.sh
    info "** MongoDB Sharded setup finished! **"
fi

echo ""
exec "$@"

