#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/libwildfly.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libservice.sh

# Load WildFly environment
. /opt/bitnami/scripts/wildfly-env.sh

# Ensure required directories exist
chmod g+rwX "$WILDFLY_BASE_DIR"
chmod g+rw "${WILDFLY_BIN_DIR}/standalone.conf"
for dir in "$WILDFLY_HOME_DIR" "${WILDFLY_BASE_DIR}/domain" "${WILDFLY_BASE_DIR}/standalone" "$WILDFLY_DATA_DIR"; do
    ensure_dir_exists "$dir"
    configure_permissions_ownership "$dir" -d "775" -f "664"
done

# Create a symlink to standalone deployment directory so users can mount their custom webapps at /app
ln -sf "${WILDFLY_BASE_DIR}/standalone/deployment" /app
