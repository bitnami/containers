#!/bin/bash

# shellcheck disable=SC1091

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libharbor.sh

read -r -a directories <<< "$(get_system_cert_paths)"
directories+=("/var/log/jobs")

# Ensure a set of directories exist
# Ensure the non-root user has writing permission at a set of directories
for dir in "${directories[@]}"; do
    ensure_dir_exists "$dir"
    chmod -R g+rwX "$dir"
done

ensure_dir_exists "/etc/jobservice"
