#!/bin/bash
#
# Bitnami Chartmuseum setup

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh

chart_museum_validate() {
    info "Validating ChartMuseum parameters"

    if [[ -z ${STORAGE:-} ]]; then
        warn "No storage type provided, a local storage will be used"
    fi

    if is_dir_empty "/bitnami/certs"; then
        warn "No certificates provided, an insecure connection will be used"
    fi
}

chart_museum_validate
