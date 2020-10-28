#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/libkeycloak.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh

# Load keycloak environment variables
. /opt/bitnami/scripts/keycloak-env.sh

# Merge the keycloak folder with the Wildfly folder just as stated by the documentation
# (we are using the keycloak-overlay distribution)
# https://www.keycloak.org/docs/latest/server_installation/#installing-distribution-files
# As the user can mount themes in the keycloak folder, we prefer creating a symlink wildfly -> keycloak
# rather than the opposite
rsync -a "$KEYCLOAK_BASE_DIR"/ "$WILDFLY_BASE_DIR"/
rm -r "$KEYCLOAK_BASE_DIR" && mv "$WILDFLY_BASE_DIR" "$KEYCLOAK_BASE_DIR" && ln -s "$KEYCLOAK_BASE_DIR" "$WILDFLY_BASE_DIR"

info "Installing Keycloak"
"$KEYCLOAK_BIN_DIR"/jboss-cli.sh --file="${KEYCLOAK_BASE_DIR}/bin/keycloak-install-ha.cli"

for dir in "$KEYCLOAK_LOG_DIR" "$KEYCLOAK_TMP_DIR" "$KEYCLOAK_VOLUME_DIR" "$KEYCLOAK_DATA_DIR" "$KEYCLOAK_CONF_DIR" "$KEYCLOAK_INITSCRIPTS_DIR" "$KEYCLOAK_DEPLOYMENTS_DIR" "$KEYCLOAK_DOMAIN_TMP_DIR" "$KEYCLOAK_DOMAIN_CONF_DIR"; do
    ensure_dir_exists "$dir"
    chmod -R g+rwX "$dir"
done

cp "$KEYCLOAK_CONF_DIR"/"$KEYCLOAK_CONF_FILE" "$KEYCLOAK_CONF_DIR"/"$KEYCLOAK_DEFAULT_CONF_FILE"
keycloak_clean_from_restart
