#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load DokuWiki environment
. /opt/bitnami/scripts/dokuwiki-env.sh

# Load libraries
. /opt/bitnami/scripts/libdokuwiki.sh
. /opt/bitnami/scripts/libwebserver.sh

# Load web server environment and functions (after DokuWiki environment file so MODULE is not set to a wrong value)
. "/opt/bitnami/scripts/$(web_server_type)-env.sh"

# Ensure DokuWiki environment variables are valid
dokuwiki_validate

# Update web server configuration with runtime environment (needs to happen before the initialization)
web_server_update_app_configuration "dokuwiki"

# Ensure DokuWiki is initialized
dokuwiki_initialize
