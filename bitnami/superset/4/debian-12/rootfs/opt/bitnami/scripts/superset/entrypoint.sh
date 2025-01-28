#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Superset environment variables
. /opt/bitnami/scripts/superset-env.sh

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/libsuperset.sh

print_welcome_page

# Install custom python package if requirements.txt is present
if [[ -f "/bitnami/python/requirements.txt" ]]; then
    . /opt/bitnami/superset/venv/bin/activate
    pip install -r /bitnami/python/requirements.txt
    deactivate
fi

if [[ "$1" = "/opt/bitnami/scripts/superset/run.sh" ]]; then
    info "** Starting Superset setup **"
    /opt/bitnami/scripts/superset/setup.sh
    info "** Superset setup finished! **"
fi

echo ""
exec "$@"
