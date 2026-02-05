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
. /opt/bitnami/scripts/libkubescape.sh

# Load Kubescape environment variables
. /opt/bitnami/scripts/kubescape-env.sh

# Custom action that performs Bitnami OSS assessment
if [[ "$1" = "oss-assessment" ]]; then
    kubescape_oss_assessment "$@"
else
    exec "kubescape" "$@"
fi

