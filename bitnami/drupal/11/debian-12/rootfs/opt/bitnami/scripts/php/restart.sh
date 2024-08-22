#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libphp.sh

# Load PHP-FPM environment variables
. /opt/bitnami/scripts/php-env.sh

/opt/bitnami/scripts/php/stop.sh
/opt/bitnami/scripts/php/start.sh
