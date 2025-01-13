#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libfile.sh

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

if [[ "$(get_os_metadata --id)" == "photon" ]]; then
    append_file_after_last_match "/etc/ssl/openssl.cnf" "openssl_conf = openssl_init" "nodejs_conf = openssl_init"
fi
