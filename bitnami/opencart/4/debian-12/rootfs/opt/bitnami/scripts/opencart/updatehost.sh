#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load OpenCart environment
. /opt/bitnami/scripts/opencart-env.sh

# Load libraries
. /opt/bitnami/scripts/libopencart.sh

DOMAIN="${1:?missing host}"

opencart_update_hostname "$DOMAIN"
