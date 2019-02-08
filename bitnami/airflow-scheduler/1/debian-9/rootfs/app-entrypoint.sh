#!/bin/bash -e

. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

print_welcome_page

if [[ "$1" == "nami" && "$2" == "start" ]] || [[ "$1" == "/run.sh" ]]; then
  if [ ! $EUID -eq 0 ] && ! getent passwd "$(id -u)" &> /dev/null && [ -e /usr/lib/libnss_wrapper.so ]; then
    echo "airflow:x:$(id -u):$(id -g):Airflow:$AIRFLOW_HOME:/bin/false" > "$NSS_WRAPPER_PASSWD"
    echo "airflow:x:$(id -g):" > "$NSS_WRAPPER_GROUP"
else
    unset LD_PRELOAD
fi

  nami_initialize airflow-scheduler
  info "Starting airflow-scheduler... "
fi

exec tini -- "$@"
