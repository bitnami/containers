#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Odoo environment
. /opt/bitnami/scripts/odoo-env.sh

# Load PostgreSQL Client environment for 'postgresql_remote_execute' (after 'odoo-env.sh' so that MODULE is not set to a wrong value)
if [[ -f /opt/bitnami/scripts/postgresql-client-env.sh ]]; then
    . /opt/bitnami/scripts/postgresql-client-env.sh
elif [[ -f /opt/bitnami/scripts/postgresql-env.sh ]]; then
    . /opt/bitnami/scripts/postgresql-env.sh
fi

# Load libraries
. /opt/bitnami/scripts/libodoo.sh

# Ensure Odoo environment variables are valid
odoo_validate

# Ensure Odoo is initialized
odoo_initialize
