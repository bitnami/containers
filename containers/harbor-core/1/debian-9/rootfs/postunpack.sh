#!/bin/bash

# shellcheck disable=SC1091

# Load libraries
. /libfs.sh

# Ensure a set of directories exist
for dir in "/etc/core" "/data"; do
    ensure_dir_exists "$dir"
done

# Add persisted configuration
ln -sf /data/certificates /etc/core/certificates
ln -sf /data/ca_download /etc/core/ca_download
ln -sf /data/psc /etc/core/token

# Ensure the non-root user has writing permission at a set of directories
chmod -R g+rwX "/etc/core" "/data"
