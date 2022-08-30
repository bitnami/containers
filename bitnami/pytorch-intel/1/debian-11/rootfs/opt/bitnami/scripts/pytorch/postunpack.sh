#!/bin/bash

# shellcheck disable=SC1091

# Load libraries
. /opt/bitnami/scripts/libfs.sh

PYTORCH_BASEDIR="/opt/bitnami/python"
PYTORCH_WORKSPACE="/app"

# Ensure non-root user has write permissions on the workspace
ensure_dir_exists "$PYTORCH_WORKSPACE"

chmod -R g+rwX "$PYTORCH_BASEDIR" "$PYTORCH_WORKSPACE"
