#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libapache.sh
. /opt/bitnami/scripts/liblog.sh

# Load Apache environment
. /opt/bitnami/scripts/apache-env.sh

info "** Starting Apache **"
exec "${APACHE_BIN_DIR}/httpd" -f "$APACHE_CONF_FILE" -D "FOREGROUND"
