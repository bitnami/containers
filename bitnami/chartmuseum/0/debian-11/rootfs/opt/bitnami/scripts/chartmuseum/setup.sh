#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libharbor.sh

# Load environment
. /opt/bitnami/scripts/chartmuseum-env.sh

chart_museum_validate() {
    info "Validating ChartMuseum parameters"

    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }

    if [[ -z ${STORAGE:-} ]]; then
        warn "No storage type provided, a local storage will be used"
    fi

    if [[ -n "${TLS_CERT:-}" ]] && [[ -n "${TLS_KEY:-}" ]]; then
        if [[ ! -f "$TLS_CERT" ]]; then
            print_validation_error "The TLS certificate file in the specified path ${TLS_CERT} does not exist" || exit 1
        fi

        if [[ ! -f "$TLS_KEY" ]]; then
            print_validation_error "The TLS private key file in the specified path ${TLS_KEY} does not exist" || exit 1
        fi
    elif [[ -n "${TLS_CERT:-}" ]] || [[ -n "${TLS_KEY:-}" ]]; then
        print_validation_error "Both TLS_CERT and TLS_KEY env variables must be set to enable TLS" || exit 1
    else
        warn "No certificates provided, an insecure connection will be used"
    fi

    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}

chart_museum_validate
install_custom_certs
