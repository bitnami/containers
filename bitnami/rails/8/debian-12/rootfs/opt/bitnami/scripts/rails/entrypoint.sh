#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh

# Load Rails environment
. /opt/bitnami/scripts/rails-env.sh

print_welcome_page

if [[ "$*" == "bundle exec "* ]]; then
    info "** Running Rails setup **"
    /opt/bitnami/scripts/rails/setup.sh
    info "** Rails setup finished! **"
fi

echo ""
exec "$@"
