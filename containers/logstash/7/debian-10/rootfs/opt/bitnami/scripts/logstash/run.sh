#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/liblogstash.sh

# Load Logstash environment variables
eval "$(logstash_env)"

info "** Starting Logstash **"

if [[ -n "$LOGSTASH_CONF_STRING" ]]; then
    info "Starting logstash using config string"
    args=( "-e"  "$LOGSTASH_CONF_STRING" )
elif is_boolean_yes "$LOGSTASH_ENABLE_MULTIPLE_PIPELINES"; then
    info "Starting logstash using pipelines file (pipelines.yml)"
else
    info "Starting logstash using config file ($LOGSTASH_CONF_FILENAME)"
    args=( "-f" "$LOGSTASH_CONF_FILE" )
fi

if [[ -n "$LOGSTASH_EXTRA_ARGS" ]]; then
    read -r -a extra_args <<<"$LOGSTASH_EXTRA_ARGS"
    args+=("${extra_args[@]}")
fi

is_boolean_yes "$LOGSTASH_EXPOSE_API" && args+=( "--http.host" "0.0.0.0" "--http.port" "$LOGSTASH_API_PORT_NUMBER" )

if am_i_root; then
    exec gosu "$LOGSTASH_DAEMON_USER" "${LOGSTASH_BIN_DIR}/logstash" "${args[@]}"
else
    exec "${LOGSTASH_BIN_DIR}/logstash" "${args[@]}"
fi
