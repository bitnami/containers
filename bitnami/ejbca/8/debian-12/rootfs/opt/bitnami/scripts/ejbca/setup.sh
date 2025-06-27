#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libejbca.sh

# Load ejbca environment variables
. /opt/bitnami/scripts/ejbca-env.sh

# Ensure ejbca environment variables are valid
ejbca_validate

# Ensure ejbca is initialized
ejbca_initialize

# Launch init scripts
ejbca_custom_init_scripts
