#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/harbor-adapter-trivy-env.sh
. /opt/bitnami/scripts/libharbor.sh

read -r -a directories <<<"$(get_system_cert_paths)"
directories+=("$SCANNER_TRIVY_CACHE_DIR" "$SCANNER_TRIVY_REPORTS_DIR")

# Create directories
for dir in "${directories[@]}"; do
    ensure_dir_exists "$dir"
    chmod -R g+rwX "$dir"
done

# Fix for CentOS Internal TLS
if [[ -f /etc/pki/tls/certs/ca-bundle.crt ]]; then
    chmod g+w /etc/pki/tls/certs/ca-bundle.crt
fi

if [[ -f /etc/pki/tls/certs/ca-bundle.trust.crt ]]; then
    chmod g+w /etc/pki/tls/certs/ca-bundle.trust.crt
fi
