#!/bin/bash
#
# Bitnami Chartmuseum postunpack

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/libfs.sh

for dir in "/bitnami/data" "/bitnami/certs"; do
    ensure_dir_exists "$dir"
    chmod -R g+rwX "$dir"
done
