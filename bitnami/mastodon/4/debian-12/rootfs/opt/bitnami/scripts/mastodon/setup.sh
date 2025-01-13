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
. /opt/bitnami/scripts/libmastodon.sh

# Load Mastodon environment settings
. /opt/bitnami/scripts/mastodon-env.sh

# Ensure Mastodon environment settings are valid
mastodon_validate
# Ensure 'mastodon' user exists when running as 'root'
am_i_root && ensure_user_exists "$MASTODON_DAEMON_USER" --group "$MASTODON_DAEMON_GROUP"

mastodon_initialize