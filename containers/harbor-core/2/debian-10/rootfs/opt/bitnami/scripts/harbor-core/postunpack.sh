#!/bin/bash

# shellcheck disable=SC1091

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libharbor.sh

read -r -a directories <<< "$(get_system_cert_paths)"
directories+=("/etc/core" "/data")

# Ensure a set of directories exist
for dir in "/etc/core" "/data"; do
    ensure_dir_exists "$dir"
done

# Add persisted configuration
ln -sf /data/certificates /etc/core/certificates
ln -sf /data/ca_download /etc/core/ca_download
ln -sf /data/psc /etc/core/token

# Ensure the non-root user has writing permission at a set of directories
for dir in "${directories[@]}"; do
    chmod -R g+rwX "$dir"
done
