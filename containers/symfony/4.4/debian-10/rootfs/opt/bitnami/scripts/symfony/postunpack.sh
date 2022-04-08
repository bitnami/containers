#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/libsymfony.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh

# Load Symfony environment
. /opt/bitnami/scripts/symfony-env.sh

# Ensure required directories exist
chmod g+rwX "$SYMFONY_BASE_DIR"
for dir in "/app" "$SYMFONY_SKELETON_DIR" "$SYMFONY_WEB_SKELETON_DIR"; do
    ensure_dir_exists "$dir"
    configure_permissions_ownership "$dir" -d "775" -f "664"
done
