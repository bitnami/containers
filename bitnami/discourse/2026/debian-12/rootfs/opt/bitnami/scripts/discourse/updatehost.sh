#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Discourse environment
. /opt/bitnami/scripts/discourse-env.sh

# Load libraries
. /opt/bitnami/scripts/libdiscourse.sh

# If DISCOURSE_HOST is not provided via user-data, force value from CLI args
if [[ -z "$DISCOURSE_HOST" || "$DISCOURSE_HOST" = "www.example.com" ]]; then
    DISCOURSE_DOMAIN="${1:?missing host}"
else
    DISCOURSE_DOMAIN="$DISCOURSE_HOST"
fi

info "Updating configuration file"
discourse_set_hostname "$DISCOURSE_DOMAIN"
