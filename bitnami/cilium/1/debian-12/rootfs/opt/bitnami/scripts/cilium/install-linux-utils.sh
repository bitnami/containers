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

# The statically compiled Go binaries do not depend on system utilities
# that can be missed on distros installed on the underlying host.
cilium_install_linux_utils "$1" "$2"
