#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/libejbca.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh


# Load ejbca environment variables
. /opt/bitnami/scripts/ejbca-env.sh

for dir in "$EJBCA_BASE_DIR" "$EJBCA_WILDFLY_BASE_DIR"  "$EJBCA_TMP_DIR" "$EJBCA_VOLUME_DIR" \
           "$EJBCA_WILDFLY_VOLUME_DIR" "${EJBCA_WILDFLY_BASE_DIR}/standalone" \
           "${EJBCA_WILDFLY_BASE_DIR}/domain" "$EJBCA_WILDFLY_TMP_DIR"; do
    ensure_dir_exists "$dir"
    chmod -R g+rwX "$dir"
done

chmod g+rw "$EJBCA_WILDFLY_STANDALONE_CONF_FILE"
