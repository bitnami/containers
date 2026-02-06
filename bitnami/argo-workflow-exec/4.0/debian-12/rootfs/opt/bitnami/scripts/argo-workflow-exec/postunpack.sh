#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh

# Apply hacks
# Ref: https://github.com/argoproj/argo-workflows/blob/9936cf680d56b88ea9c16411500924724fb2f06d/Dockerfile#L63
ensure_dir_exists /etc/ssh/
mv /opt/bitnami/argo-workflow-exec/hack/ssh_known_hosts /etc/ssh/
mv /opt/bitnami/argo-workflow-exec/hack/nsswitch.conf /etc/
