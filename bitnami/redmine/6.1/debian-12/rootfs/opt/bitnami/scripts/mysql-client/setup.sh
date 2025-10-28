#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libmysqlclient.sh

# Load MySQL Client environment variables
. /opt/bitnami/scripts/mysql-client-env.sh

# Ensure MySQL Client environment variables settings are valid
mysql_client_validate
# Ensure MySQL Client is initialized
mysql_client_initialize
