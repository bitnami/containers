#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libjenkins.sh
. /opt/bitnami/scripts/liblog.sh

# Load Jenkins environment
. /opt/bitnami/scripts/jenkins-env.sh

declare -a args
if [[ -n "${JAVA_OPTS:-}" ]]; then
    read -r -a java_opts <<<"$JAVA_OPTS"
    args+=("${java_opts[@]}")
fi

args+=("-Duser.home=${JENKINS_HOME}" "-jar" "${JENKINS_BASE_DIR}/jenkins.war")
if is_boolean_yes "$JENKINS_FORCE_HTTPS"; then
    args+=(
        "--httpPort=-1"
        "--httpsPort=${JENKINS_HTTPS_PORT_NUMBER:-"$JENKINS_DEFAULT_HTTPS_PORT_NUMBER"}"
        "--httpsListenAddress=${JENKINS_HTTPS_LISTEN_ADDRESS:-"$JENKINS_DEFAULT_HTTPS_LISTEN_ADDRESS"}"
        "--httpsKeyStore=${JENKINS_CERTS_DIR}/jenkins.jks"
        "--httpsKeyStorePassword=${JENKINS_KEYSTORE_PASSWORD}"
    )
else
    args+=(
        "--httpPort=${JENKINS_HTTP_PORT_NUMBER:-"$JENKINS_DEFAULT_HTTP_PORT_NUMBER"}"
        "--httpListenAddress=${JENKINS_HTTP_LISTEN_ADDRESS:-"$JENKINS_DEFAULT_HTTP_LISTEN_ADDRESS"}"
        "--httpsPort=${JENKINS_HTTPS_PORT_NUMBER:-"$JENKINS_DEFAULT_HTTPS_PORT_NUMBER"}"
        "--httpsListenAddress=${JENKINS_HTTPS_LISTEN_ADDRESS:-"$JENKINS_DEFAULT_HTTPS_LISTEN_ADDRESS"}"
        "--httpsKeyStore=${JENKINS_CERTS_DIR}/jenkins.jks"
        "--httpsKeyStorePassword=${JENKINS_KEYSTORE_PASSWORD}"
    )
fi
if [[ -n "${JENKINS_OPTS:-}" ]]; then
    read -r -a jenkins_opts <<<"$JENKINS_OPTS"
    args+=("${jenkins_opts[@]}")
fi
args+=("$@")

info "** Starting Jenkins **"
if am_i_root; then
    exec_as_user "$JENKINS_DAEMON_USER" java "${args[@]}"
else
    exec java "${args[@]}"
fi
