#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libkong.sh

# Load Kong environment variables
. /opt/bitnami/scripts/kong-env.sh

# Ensure Kong environment variables are valid
kong_validate
# Ensure file ownership is correct
am_i_root && chown -R "$KONG_DAEMON_USER":"$KONG_DAEMON_GROUP" "$KONG_SERVER_DIR" "$KONG_CONF_DIR"
# Ensure Kong is initialized
kong_initialize
# Allow running custom initialization scripts
kong_custom_init_scripts
