#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091,SC1090

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Airflow environment variables
. /opt/bitnami/scripts/airflow-env.sh

# Load libraries
. /opt/bitnami/scripts/libairflow.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh

ensure_dir_exists "$AIRFLOW_BASE_DIR"
# Ensure the needed directories exist with write permissions
for dir in "$AIRFLOW_TMP_DIR" "$AIRFLOW_LOGS_DIR" "$AIRFLOW_SCHEDULER_LOGS_DIR" "$AIRFLOW_DAGS_DIR" "${AIRFLOW_BASE_DIR}/nss-wrapper"; do
    ensure_dir_exists "$dir"
    configure_permissions_ownership "$dir" -d "775" -f "664" -g "root"
done

chmod -R g+rwX "$AIRFLOW_BASE_DIR"
