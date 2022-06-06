#!/bin/bash

# shellcheck disable=SC1091

# Load libraries
. /opt/bitnami/scripts/libfs.sh

MXNET_BASEDIR="/opt/bitnami/python"
MXNET_WORKSPACE="/app"

# Ensure non-root user has write permissions on the workspace
ensure_dir_exists "$MXNET_WORKSPACE"

chmod -R g+rwX "$MXNET_BASEDIR" "$MXNET_WORKSPACE"