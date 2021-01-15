#!/bin/bash -e

. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

print_welcome_page

if [[ "$1" == "nami" && "$2" == "start" ]] || [[ "$1" == "/run.sh" ]]; then
    if [ ! $EUID -eq 0 ] && [ -e "$LIBNSS_WRAPPER_PATH" ]; then
    echo "airflow:x:$(id -u):$(id -g):Airflow:$AIRFLOW_HOME:/bin/false" > "$NSS_WRAPPER_PASSWD"
    echo "airflow:x:$(id -g):" > "$NSS_WRAPPER_GROUP"

    export LD_PRELOAD="$LIBNSS_WRAPPER_PATH"

fi

    # Install custom python package if requirements.txt is present
if [[ -f "/bitnami/python/requirements.txt" ]]; then
    source /opt/bitnami/airflow/venv/bin/activate
    pip install -r /bitnami/python/requirements.txt
    deactivate
fi

    nami_initialize airflow-scheduler
    info "Starting airflow-scheduler... "
fi

exec tini -- "$@"
