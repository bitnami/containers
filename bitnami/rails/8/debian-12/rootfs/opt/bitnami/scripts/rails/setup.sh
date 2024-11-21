#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/librails.sh

# Load Rails environment
. /opt/bitnami/scripts/rails-env.sh

# Ensure environment variables for the Rails app are valid
rails_validate

# Ensure Rails app is initialized
rails_initialize

# Ensure all folders in /app are writable by the non-root "bitnami" user
chown -R bitnami:bitnami /app
