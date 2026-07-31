#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libactivemq.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/liblog.sh

# Load ActiveMQ environment
. /opt/bitnami/scripts/activemq-env.sh

info "Creating ActiveMQ daemon user"
ensure_user_exists "$ACTIVEMQ_DAEMON_USER" --group "$ACTIVEMQ_DAEMON_GROUP" --system

# Ensure required directories exist
for dir in "$ACTIVEMQ_VOLUME_DIR" "$ACTIVEMQ_DATA_DIR" "$ACTIVEMQ_CONF_DIR"; do
    ensure_dir_exists "$dir"
    configure_permissions_ownership "$dir" -d "775" -f "664"
done

# Prepare config files
replace_in_file "${ACTIVEMQ_BASE_DIR}/webapps/admin/WEB-INF/webconsole-embedded.xml" "file\:\$\{activemq.conf\}/credentials.properties" "file:\${activemq.conf}/credentials-enc.properties"
replace_in_file "${ACTIVEMQ_CONF_DIR}/credentials-enc.properties" "activemq.username=.*" "activemq.username=admin"
replace_in_file "${ACTIVEMQ_CONF_DIR}/credentials-enc.properties" "guest.*" " "

# Configuring permissions for tmp and logs folders
for dir in "$ACTIVEMQ_TMP_DIR" "$ACTIVEMQ_LOGS_DIR" "$ACTIVEMQ_DEFAULT_CONF_DIR"; do
    ensure_dir_exists "$dir"
    chmod -R g+rwX "$dir"
done

# Set correct owner in installation directory
chown -R "1001:root" "$ACTIVEMQ_BASE_DIR"

# Copy all initially generated configuration files to the default directory
# (this is to avoid breaking when entrypoint is being overridden)
cp -r "${ACTIVEMQ_CONF_DIR}/"* "$ACTIVEMQ_DEFAULT_CONF_DIR"