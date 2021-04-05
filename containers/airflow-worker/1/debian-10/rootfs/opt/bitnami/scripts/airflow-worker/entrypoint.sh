#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load Airflow environment variables
. /opt/bitnami/scripts/airflow-worker-env.sh

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/libairflowworker.sh

print_welcome_page

if [[ "$*" = *"/opt/bitnami/scripts/airflow-worker/run.sh"* || "$*" = *"/run.sh"* ]]; then
    info "** Starting Airflow setup **"
    /opt/bitnami/scripts/airflow-worker/setup.sh
    info "** Airflow setup finished! **"
fi

echo ""
exec "$@"
