#!/bin/bash

# shellcheck disable=SC1091

# Load libraries
. /opt/bitnami/scripts/libharbor.sh

read -r -a directories <<< "$(get_system_cert_paths)"

# Ensure the non-root user has writing permission at a set of directories
for dir in "${directories[@]}"; do
    chmod -R g+rwX "$dir"
done
