#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/harboradaptertrivy-env.sh

# Create directories
for dir in "${SCANNER_TRIVY_CACHE_DIR}" "${SCANNER_TRIVY_REPORTS_DIR}"; do
    ensure_dir_exists "${dir}"
    chmod -R g+rwX "${dir}"
done

