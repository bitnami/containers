#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libkibana.sh
. /opt/bitnami/scripts/libfs.sh

# Load environment
. /opt/bitnami/scripts/kibana-env.sh

for dir in "$KIBANA_TMP_DIR" "$KIBANA_LOGS_DIR" "$KIBANA_CONF_DIR" "$KIBANA_PLUGINS_DIR" "$KIBANA_VOLUME_DIR" "$KIBANA_DATA_DIR" "$KIBANA_INITSCRIPTS_DIR"; do
    ensure_dir_exists "$dir"
    chmod -R ug+rwX "$dir"
done

# Optimize feature for Kibana 6
[[ -d "$KIBANA_OPTIMIZE_DIR" ]] && chmod -R ug+rwX "$KIBANA_OPTIMIZE_DIR"

kibana_conf_set "path.data" "$KIBANA_DATA_DIR"
# For backwards compatibility, create a symlink to the default path
! is_dir_empty "${KIBANA_BASE_DIR}/data" || rm -rf "${KIBANA_BASE_DIR}/data" && ln -s "$KIBANA_DATA_DIR" "${KIBANA_BASE_DIR}/data"
