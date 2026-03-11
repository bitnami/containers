#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libschemaregistry.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh

# Load Schema Registry environment variables
. /opt/bitnami/scripts/schema-registry-env.sh

# Ensure Schema Registry environment variables are valid
schema_registry_validate

# Ensure 'daemon' user exists when running as 'root'
am_i_root && ensure_user_exists "$SCHEMA_REGISTRY_DAEMON_USER" --group "$SCHEMA_REGISTRY_DAEMON_GROUP"
for dir in "$SCHEMA_REGISTRY_CONF_DIR" "$SCHEMA_REGISTRY_LOGS_DIR" "$SCHEMA_REGISTRY_CERTS_DIR"; do
    ensure_dir_exists "$dir"
    am_i_root && chown -R "${SCHEMA_REGISTRY_DAEMON_USER}:${SCHEMA_REGISTRY_DAEMON_GROUP}" "$dir"
done

# Ensure Schema Registry is initialized
schema_registry_initialize
