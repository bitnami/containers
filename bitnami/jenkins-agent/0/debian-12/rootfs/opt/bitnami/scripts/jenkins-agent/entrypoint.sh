#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh

# Load Jenkins Agent environment
. /opt/bitnami/scripts/jenkins-agent-env.sh

print_welcome_page

# If running as root, run the agent using the daemon user
# Otherwise, set nss_wrapper vars only when running as non-root
if am_i_root; then
    ensure_user_exists "$JENKINS_AGENT_DAEMON_USER" --group "$JENKINS_AGENT_DAEMON_GROUP" --home "$JENKINS_AGENT_WORKDIR" --system
else
    export LNAME="jenkins"
    export LD_PRELOAD="/opt/bitnami/common/lib/libnss_wrapper.so"
    if ! user_exists "$(id -u)" && [[ -f "$LD_PRELOAD" ]]; then
        info "Configuring libnss_wrapper"
        NSS_WRAPPER_PASSWD="$(mktemp)"
        export NSS_WRAPPER_PASSWD
        NSS_WRAPPER_GROUP="$(mktemp)"
        export NSS_WRAPPER_GROUP
        echo "jenkins:x:$(id -u):$(id -g):Jenkins:${JENKINS_AGENT_WORKDIR}:/bin/false" >"$NSS_WRAPPER_PASSWD"
        echo "jenkins:x:$(id -g):" >"$NSS_WRAPPER_GROUP"
        chmod 400 "$NSS_WRAPPER_PASSWD" "$NSS_WRAPPER_GROUP"
        export HOME="$JENKINS_AGENT_WORKDIR"
    fi
fi

declare -a args
if [[ -n "${JAVA_OPTS:-}" ]]; then
    read -r -a java_opts <<< "$JAVA_OPTS"
    args+=("${java_opts[@]}")
fi

args+=(
    "-cp" "${JENKINS_AGENT_BASE_DIR}/agent.jar"
    "hudson.remoting.jnlp.Main"
)

[[ -n "$JENKINS_AGENT_TUNNEL" ]] && args+=("-tunnel" "$JENKINS_AGENT_TUNNEL") #JENKINS_TUNNEL
[[ -n "$JENKINS_AGENT_URL" ]] && args+=("-url" "$JENKINS_AGENT_URL")
[[ -n "$JENKINS_AGENT_PROTOCOLS" ]] && args+=("-protocols" "$JENKINS_AGENT_PROTOCOLS")
[[ -n "$JENKINS_AGENT_DIRECT_CONNECTION" ]] && args+=("-direct" "$JENKINS_AGENT_DIRECT_CONNECTION")
[[ -n "$JENKINS_AGENT_INSTANCE_IDENTITY" ]] && args+=("-instanceIdentity" "$JENKINS_INSTANCE_IDENTITY")
[[ -n "$JENKINS_AGENT_SECRET" ]] && args+=("$JENKINS_SECRET")
[[ -n "$JENKINS_AGENT_NAME" ]] && args+=("$JENKINS_AGENT_NAME")
[[ -n "$JENKINS_AGENT_WORKDIR" ]] && args+=("-workDir" "$JENKINS_AGENT_WORKDIR")
is_boolean_yes "$JENKINS_AGENT_WEB_SOCKET" && args+=("-webSocket")

args+=("$@")

info "** Starting Jenkins Agent"
if am_i_root; then
    exec_as_user "$JENKINS_AGENT_DAEMON_USER" java "${args[@]}"
else
    exec java "${args[@]}"
fi
