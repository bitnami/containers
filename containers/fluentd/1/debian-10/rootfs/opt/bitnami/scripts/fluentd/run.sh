#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace 

# Load libraries
. /opt/bitnami/scripts/libfluentd.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh

# Load Fluentd environment
eval "$(fluentd_env)"

EXEC="$(command -v fluentd)"
args=("--config" "${FLUENTD_CONF_DIR}/${FLUENTD_CONF:-fluentd.conf}" "--plugin" "$FLUENTD_PLUGINS_DIR")

# extra command line flags
if [[ -n "$FLUENTD_OPT" ]]; then
    read -r -a envExtraFlags <<< "$FLUENTD_OPT"
    args+=("${envExtraFlags[@]}")
fi

info "** Starting Fluentd **"
if am_i_root; then
    exec gosu "$FLUENTD_DAEMON_USER" "$EXEC" "${args[@]}"
else
    exec "$EXEC" "${args[@]}"
fi
