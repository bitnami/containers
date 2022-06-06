#!/bin/bash

# shellcheck disable=SC1091

# Load libraries
. /opt/bitnami/scripts/libfs.sh

INC_WORKSPACE="/app"

# Ensure non-root user has write permissions on the workspace
ensure_dir_exists "$INC_WORKSPACE"

chmod -R g+rwX "$INC_WORKSPACE"
