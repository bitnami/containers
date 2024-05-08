#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Ghost environment
. /opt/bitnami/scripts/ghost-env.sh

# Load libraries
. /opt/bitnami/scripts/libghost.sh

DOMAIN="${1:?missing host}"

# Configure host
ghost_configure_host "$DOMAIN"
