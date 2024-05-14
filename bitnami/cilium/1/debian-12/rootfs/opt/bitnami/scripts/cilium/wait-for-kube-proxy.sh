#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libcilium.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/liblog.sh

# Load Cilium environment variables
. /opt/bitnami/scripts/cilium-env.sh

exit_code=0
if ! retry_while "is_kube_proxy_ready"; then
    error "kube-proxy is not ready"
    exit_code=1
else
    info "kube-proxy ready"
fi

exit "$exit_code"
