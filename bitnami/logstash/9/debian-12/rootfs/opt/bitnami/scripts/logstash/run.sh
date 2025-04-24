#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/liblogstash.sh

# Load Logstash environment variables
. /opt/bitnami/scripts/logstash-env.sh

declare -a cmd=("logstash")

if is_boolean_yes "$LOGSTASH_EXPOSE_API"; then
    cmd+=("--api.http.host" "$LOGSTASH_BIND_ADDRESS" "--api.http.port" "$LOGSTASH_API_PORT_NUMBER")
fi

if [[ -n "$LOGSTASH_PIPELINE_CONF_STRING" ]]; then
    cmd+=("-e" "$LOGSTASH_PIPELINE_CONF_STRING")
elif ! is_boolean_yes "$LOGSTASH_ENABLE_MULTIPLE_PIPELINES"; then
    cmd+=("-f" "$LOGSTASH_PIPELINE_CONF_DIR")
fi

declare -a extra_args=()
read -r -a extra_args <<< "$LOGSTASH_EXTRA_FLAGS"
[[ "${#extra_args[@]}" -gt 0 ]] && cmd+=("${extra_args[@]}")

# JAVA_HOME to be deprecated, see warning:
#   warning: usage of JAVA_HOME is deprecated, use LS_JAVA_HOME
export LS_JAVA_HOME=/opt/bitnami/java

info "** Starting Logstash **"
if am_i_root; then
    exec_as_user "$LOGSTASH_DAEMON_USER" "${cmd[@]}"
else
    exec "${cmd[@]}"
fi
