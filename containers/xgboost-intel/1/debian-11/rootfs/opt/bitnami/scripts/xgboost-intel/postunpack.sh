#!/bin/bash

# shellcheck disable=SC1091

# Load libraries
. /opt/bitnami/scripts/libfs.sh

XGBOOST_WORKSPACE="/app"

# Ensure non-root user has write permissions on the workspace
ensure_dir_exists "$XGBOOST_WORKSPACE"

chmod -R g+rwX "$XGBOOST_WORKSPACE"

