#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libharbor.sh

# Load environment
. /opt/bitnami/scripts/harbor-registryctl-env.sh

ensure_user_exists "$HARBOR_REGISTRYCTL_DAEMON_USER" --group "$HARBOR_REGISTRYCTL_DAEMON_GROUP"

# Ensure the non-root user has writing permission at a set of directories
read -r -a directories <<<"$(get_system_cert_paths)"
directories+=("/var/lib/registry" "$HARBOR_REGISTRYCTL_STORAGE_DIR")
for dir in "${directories[@]}"; do
    ensure_dir_exists "$dir"
    chmod -R g+rwX "$dir"
    chown -R "$HARBOR_REGISTRYCTL_DAEMON_USER" "$dir"
done

ensure_dir_exists "/etc/registry"
ensure_dir_exists "/etc/registryctl"

# Fix for CentOS Internal TLS
if [[ -f /etc/pki/tls/certs/ca-bundle.crt ]]; then
    chmod g+w /etc/pki/tls/certs/ca-bundle.crt
    chown "$HARBOR_REGISTRY_DAEMON_USER" /etc/pki/tls/certs/ca-bundle.crt
fi

if [[ -f /etc/pki/tls/certs/ca-bundle.trust.crt ]]; then
    chmod g+w /etc/pki/tls/certs/ca-bundle.trust.crt
    chown "$HARBOR_REGISTRY_DAEMON_USER" /etc/pki/tls/certs/ca-bundle.trust.crt
fi
