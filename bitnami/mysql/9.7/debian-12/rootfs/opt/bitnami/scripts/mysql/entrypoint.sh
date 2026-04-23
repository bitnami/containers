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
. /opt/bitnami/scripts/libmysql.sh

# Load MySQL environment variables
. /opt/bitnami/scripts/mysql-env.sh

print_welcome_page

# We add the copy from default config in the entrypoint to not break users 
# bypassing the setup.sh logic. If the file already exists do not overwrite (in
# case someone mounts a configuration file in /opt/bitnami/mysql/conf)
debug "Copying files from $DB_DEFAULT_CONF_DIR to $DB_CONF_DIR"
cp -nfr "$DB_DEFAULT_CONF_DIR"/. "$DB_CONF_DIR"

if [[ "$1" = "/opt/bitnami/scripts/mysql/run.sh" ]]; then
    info "** Starting MySQL setup **"
    /opt/bitnami/scripts/mysql/setup.sh
    info "** MySQL setup finished! **"
fi

echo ""
exec "$@"
