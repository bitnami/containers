#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libmongodbshell.sh

# Load MongoDB Shell environment variables
. /opt/bitnami/scripts/mongodb-shell-env.sh

# Ensure MongoDB Shell environment variables settings are valid
mongodb_shell_validate
# Ensure MongoDB Shell is initialized
mongodb_shell_initialize
