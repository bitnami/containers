#!/bin/bash

# shellcheck disable=SC1091

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libharbor.sh

# Ensure a set of directories exist
for dir in "/var/lib/registry" "/storage" "/etc/registry" "/etc/registryctl"; do
    ensure_dir_exists "$dir"
done

# Ensure the non-root user has writing permission at a set of directories
read -r -a directories <<< "$(get_system_cert_paths)"
directories+=("/var/lib/registry" "/storage")

for dir in "${directories[@]}"; do
    chmod -R g+rwX "$dir"
done
