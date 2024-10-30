#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Airflow environment variables
. /opt/bitnami/scripts/airflow-env.sh

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/libairflow.sh

print_welcome_page

if ! am_i_root && [[ -e "$LIBNSS_WRAPPER_PATH" ]]; then
    info "Enabling non-root system user with nss_wrapper"
    echo "airflow:x:$(id -u):$(id -g):Airflow:$AIRFLOW_HOME:/bin/false" > "$NSS_WRAPPER_PASSWD"
    echo "airflow:x:$(id -g):" > "$NSS_WRAPPER_GROUP"

    export LD_PRELOAD="$LIBNSS_WRAPPER_PATH"
    export HOME="$AIRFLOW_HOME"
fi

# Install custom python package if requirements.txt is present
if [[ -f "/bitnami/python/requirements.txt" ]]; then
    . /opt/bitnami/airflow/venv/bin/activate
    pip install -r /bitnami/python/requirements.txt
    deactivate
fi

if [[ "$*" = *"/opt/bitnami/scripts/airflow/run.sh"* || "$*" = *"/run.sh"* ]]; then
    info "** Starting Airflow setup **"
    /opt/bitnami/scripts/airflow/setup.sh
    info "** Airflow setup finished! **"
fi

echo ""
exec "$@"
