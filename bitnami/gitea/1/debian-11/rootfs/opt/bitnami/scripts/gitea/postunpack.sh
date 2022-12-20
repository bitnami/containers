#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libfs.sh

# Load Gitea environment variables
. /opt/bitnami/scripts/gitea-env.sh

# System User
ensure_user_exists "$GITEA_DAEMON_USER" --group "$GITEA_DAEMON_GROUP" --system

# Create directories
dirs=(
    "${GITEA_WORK_DIR}"
    "${GITEA_CUSTOM_DIR}"
    "${GITEA_DATA_DIR}"
    "${GITEA_TMP_DIR}"
    "${GITEA_VOLUME_DIR}"
)

for dir in "${dirs[@]}"; do
    ensure_dir_exists "$dir"
    chmod -R g+rwX "$dir"
done

render-template "$GITEA_CONF_DIR/app.ini.template" >"$GITEA_CONF_FILE"
chmod g+rw "$GITEA_CONF_FILE"
