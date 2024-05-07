#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/libconsul.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libfs.sh

# Load Consul env. variables
. /opt/bitnami/scripts/consul-env.sh

print_welcome_page

if ! is_dir_empty "$CONSUL_DEFAULT_CONF_DIR"; then
    # We add the copy from default config in the entrypoint to not break users 
    # bypassing the setup.sh logic. If the file already exists do not overwrite (in
    # case someone mounts a configuration file in /opt/bitnami/consul/conf)
    debug "Copying files from $CONSUL_DEFAULT_CONF_DIR to $CONSUL_CONF_DIR"
    cp -nr "$CONSUL_DEFAULT_CONF_DIR"/. "$CONSUL_CONF_DIR"
fi

if [[ "$*" = "/opt/bitnami/scripts/consul/run.sh" ]]; then
    info "** Starting Consul setup **"
    /opt/bitnami/scripts/consul/setup.sh
    info "** Consul setup finished! **"
fi

echo ""
exec "$@"
