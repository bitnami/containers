#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libtensorflow-serving.sh

# Load tensorflow environment variables
. /opt/bitnami/scripts/tensorflowserving-env.sh

print_welcome_page

if [[ "$*" = *"/opt/bitnami/scripts/tensorflow-serving/run.sh"* ]]; then
    info "** Starting Tensorflow setup **"
    /opt/bitnami/scripts/tensorflow-serving/setup.sh
    info "** Tensorflow setup finished! **"
fi

echo ""
exec "$@"
