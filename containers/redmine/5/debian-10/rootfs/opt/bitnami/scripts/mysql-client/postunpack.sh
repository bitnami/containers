#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libfs.sh

# Load MySQL Client environment variables
. /opt/bitnami/scripts/mysql-client-env.sh

for dir in "$DB_BIN_DIR" "${DB_BASE_DIR}/.bin"; do
    ensure_dir_exists "$dir"
    chmod g+rwX "$dir"
done
