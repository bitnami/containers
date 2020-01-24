#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /liblog.sh
. /liblogstash.sh

# Load Logstash environment variables
eval "$(logstash_env)"

info "** Starting Logstash **"

if [[ -n "$LOGSTASH_CONF_STRING" ]]; then
    info "Starting logstash using config string"
    args=( "-e"  "$LOGSTASH_CONF_STRING" )
else
    info "Starting logstash using config file"
    args=( "-f" "$LOGSTASH_CONF_FILE" )
fi

is_boolean_yes "$LOGSTASH_EXPOSE_API" && args+=( "--http.host" "0.0.0.0" "--http.port" "$LOGSTASH_API_PORT_NUMBER" )

if am_i_root; then
    exec gosu "$LOGSTASH_DAEMON_USER" "${LOGSTASH_BIN_DIR}/logstash" "${args[@]}"
else
    exec "${LOGSTASH_BIN_DIR}/logstash" "${args[@]}"
fi
