#!/bin/bash

# shellcheck disable=SC1091

# Load libraries
. /opt/bitnami/scripts/libharbor.sh

read -r -a directories <<<"$(get_system_cert_paths)"

# Ensure the non-root user has writing permission at a set of directories
for dir in "${directories[@]}"; do
    chmod -R g+rwX "$dir"
done

# Fix for CentOS Internal TLS
if [[ -f /etc/pki/tls/certs/ca-bundle.crt ]]; then
    chmod g+w /etc/pki/tls/certs/ca-bundle.crt
    chmod g+w /etc/pki/tls/certs/ca-bundle.trust.crt
fi
