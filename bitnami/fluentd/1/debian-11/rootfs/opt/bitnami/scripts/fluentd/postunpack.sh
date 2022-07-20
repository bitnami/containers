#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

. /opt/bitnami/scripts/libfluentd.sh
. /opt/bitnami/scripts/libfs.sh

# Load Fluentd environment
eval "$(fluentd_env)"

for subdir in "gems" "specifications" "cache" "doc"; do
    ensure_dir_exists "$FLUENTD_BASE_DIR/$subdir"
    chmod -R g+rwX "$FLUENTD_BASE_DIR/$subdir"
done

for dir in "$FLUENTD_CONF_DIR" "$FLUENTD_LOG_DIR" "$FLUENTD_PLUGINS_DIR"; do
    ensure_dir_exists "$dir"
    chmod -R g+rwX "$dir"
done
