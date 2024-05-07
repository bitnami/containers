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

# Load Jenkins environment
. /opt/bitnami/scripts/jenkins-env.sh

print_welcome_page

# Set nss_wrapper vars only when running as non-root
# Configure libnss_wrapper based on the UID/GID used to run the container
# This container supports arbitrary UIDs, therefore we have do it dynamically
if ! am_i_root; then
    export LNAME="jenkins"
    export LD_PRELOAD="/opt/bitnami/common/lib/libnss_wrapper.so"
    if ! user_exists "$(id -u)" && [[ -f "$LD_PRELOAD" ]]; then
        info "Configuring libnss_wrapper"
        NSS_WRAPPER_PASSWD="$(mktemp)"
        export NSS_WRAPPER_PASSWD
        NSS_WRAPPER_GROUP="$(mktemp)"
        export NSS_WRAPPER_GROUP
        echo "jenkins:x:$(id -u):$(id -g):Jenkins:${JENKINS_HOME}:/bin/false" >"$NSS_WRAPPER_PASSWD"
        echo "jenkins:x:$(id -g):" >"$NSS_WRAPPER_GROUP"
        chmod 400 "$NSS_WRAPPER_PASSWD" "$NSS_WRAPPER_GROUP"
        export HOME="$JENKINS_HOME"
    fi
fi

if [[ "$1" = "/opt/bitnami/scripts/jenkins/run.sh" ]]; then
    info "** Starting Jenkins setup **"
    /opt/bitnami/scripts/jenkins/setup.sh
    info "** Jenkins setup finished! **"
fi

echo ""
exec "$@"
