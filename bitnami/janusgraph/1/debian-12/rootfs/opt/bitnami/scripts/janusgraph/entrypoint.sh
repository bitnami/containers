#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libjanusgraph.sh
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh

# Load JanusGraph environment variables
. /opt/bitnami/scripts/janusgraph-env.sh

print_welcome_page

# Set nss_wrapper vars only when running as non-root
# Configure libnss_wrapper based on the UID/GID used to run the container
# This container supports arbitrary UIDs, therefore we have do it dynamically
if ! am_i_root; then
    export LNAME="janusgraph"
    export LD_PRELOAD="/opt/bitnami/common/lib/libnss_wrapper.so"
    if ! user_exists "$(id -u)" && [[ -f "$LD_PRELOAD" ]]; then
        info "Configuring libnss_wrapper"
        NSS_WRAPPER_PASSWD="$(mktemp)"
        export NSS_WRAPPER_PASSWD
        NSS_WRAPPER_GROUP="$(mktemp)"
        export NSS_WRAPPER_GROUP
        echo "janusgraph:x:$(id -u):$(id -g):JanusGraph:${JANUSGRAPH_BASE_DIR}:/bin/false" > "$NSS_WRAPPER_PASSWD"
        echo "janusgraph:x:$(id -g):" > "$NSS_WRAPPER_GROUP"
        chmod 400 "$NSS_WRAPPER_PASSWD" "$NSS_WRAPPER_GROUP"
    fi
fi
# We add the copy from default config in the entrypoint to not break users
# bypassing the setup.sh logic. If the file already exists do not overwrite (in
# case someone mounts a configuration file in /opt/bitnami/janusgraph/conf)
debug "Copying files from $JANUSGRAPH_DEFAULT_CONF_DIR to $JANUSGRAPH_CONF_DIR"
cp -nfr "$JANUSGRAPH_DEFAULT_CONF_DIR"/. "$JANUSGRAPH_CONF_DIR"

if [[ "$1" = "/opt/bitnami/scripts/janusgraph/run.sh" ]]; then
    info "** Starting JanusGraph setup **"
    /opt/bitnami/scripts/janusgraph/setup.sh
    info "** JanusGraph setup finished! **"
fi

# Configure remote hosts and ports, useful when using the gremlin.sh as client
janusgraph_configure_remote_hosts "${JANUSGRAPH_CONF_DIR}/remote.yaml"
janusgraph_configure_remote_hosts "${JANUSGRAPH_CONF_DIR}/remote-objects.yaml"
janusgraph_yaml_conf_set "port" "$GREMLIN_REMOTE_PORT" "int" "${JANUSGRAPH_CONF_DIR}/remote.yaml"
janusgraph_yaml_conf_set "port" "$GREMLIN_REMOTE_PORT" "int" "${JANUSGRAPH_CONF_DIR}/remote-objects.yaml"

echo ""
exec "$@"
