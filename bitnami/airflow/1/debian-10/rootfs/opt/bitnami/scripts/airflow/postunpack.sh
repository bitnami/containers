#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load Airflow environment variables
. /opt/bitnami/scripts/airflow-env.sh

# Load libraries
. /opt/bitnami/scripts/libairflow.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh

for dir in "$AIRFLOW_VOLUME_DIR" "$AIRFLOW_BASE_DIR" "$AIRFLOW_DATA_DIR"; do
    ensure_dir_exists "$dir"
done

# Ensure the needed directories exist with write permissions
for dir in "$AIRFLOW_TMP_DIR" "$AIRFLOW_LOGS_DIR" "$AIRFLOW_SCHEDULER_LOGS_DIR" "$AIRFLOW_DAGS_DIR"; do
    ensure_dir_exists "$dir"
    configure_permissions_ownership "$dir" -d "775" -f "664" -g "root"
done

chmod -R g+rwX /bitnami "$AIRFLOW_VOLUME_DIR" "$AIRFLOW_BASE_DIR"
