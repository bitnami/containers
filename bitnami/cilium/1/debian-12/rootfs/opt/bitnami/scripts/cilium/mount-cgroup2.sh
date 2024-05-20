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

# Load Cilium environment variables
. /opt/bitnami/scripts/cilium-env.sh

# Mount cgroup2 filesystem
mount_cgroup2 "$1" "$2"

# Apply sysctl overwrites
sysctl_overwrites "$1"
