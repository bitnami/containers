#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libwildfly.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libvalidations.sh

# Load WildFly environment
. /opt/bitnami/scripts/wildfly-env.sh

# Ensure WildFly environment variables are valid
wildfly_validate

if am_i_root; then
    info "Creating WildFly daemon user"
    ensure_user_exists "$WILDFLY_DAEMON_USER" --group "$WILDFLY_DAEMON_GROUP" --home "$WILDFLY_HOME_DIR" --system
fi

# Ensure WildFly is initialized
wildfly_initialize
