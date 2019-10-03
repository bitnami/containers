#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

. /libfluentd.sh
. /libfs.sh

# Load Fluentd environment
eval "$(fluentd_env)"

# Ensure non-root user has write permissions on a set of directories
chmod -R g+rwX "$FLUENTD_BASE_DIR"
