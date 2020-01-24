#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose
# shellcheck disable=SC1091

# Load libraries
. /liblog.sh

chart_museum_validate() {
  info "Validating ChartMuseum parameters"

  if [[ -z ${STORAGE:-} ]]; then
    warn "No storage type provided, a local storage will be used"
  fi

  if ! [[ -d "/bitnami/certs" ]]; then
    warn "No certificates provided, an insecure connection will be used"
  fi
}

chart_museum_validate
