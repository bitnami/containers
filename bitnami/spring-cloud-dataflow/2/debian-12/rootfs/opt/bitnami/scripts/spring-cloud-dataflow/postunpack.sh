#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami Spring Cloud Data Flow postunpack

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libfs.sh

# Load Spring Cloud Data Flow environment variables
. /opt/bitnami/scripts/spring-cloud-dataflow-env.sh

for dir in "$SPRING_CLOUD_DATAFLOW_VOLUME_DIR" "$SPRING_CLOUD_DATAFLOW_CONF_DIR" "$SPRING_CLOUD_DATAFLOW_M2_DIR"; do
    ensure_dir_exists "$dir"
    chmod -R g+rwX "$dir"
done
