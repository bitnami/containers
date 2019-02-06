#!/bin/bash -e

. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

print_welcome_page

if [[ "$1" == "nami" && "$2" == "start" ]] || [[ "$1" == "/run.sh" ]]; then
    if ! getent passwd "$(id -u)" &> /dev/null && [ -e /usr/lib/libnss_wrapper.so ]; then
    export LD_PRELOAD='/usr/lib/libnss_wrapper.so'
    export NSS_WRAPPER_PASSWD='/opt/bitnami/airflow/nss_passwd'
    export NSS_WRAPPER_GROUP='/opt/bitnami/airflow/nss_group'
    echo "airflow:x:$(id -u):$(id -g):Airflow:$AIRFLOW_HOME:/bin/false" > "$NSS_WRAPPER_PASSWD"
    echo "airflow:x:$(id -g):" > "$NSS_WRAPPER_GROUP"
  fi

  nami_initialize airflow
  info "Starting airflow... "
fi

exec tini -- "$@"
