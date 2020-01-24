#!/bin/bash -e

. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

print_welcome_page

if [[ "$1" == "nami" && "$2" == "start" ]] || [[ "$1" == "/run.sh" ]]; then
    ## Copy custom files to home
  readonly copy_log="/opt/bitnami/jenkins/copy_reference_file.log"
  touch "${copy_log}" || { echo "Can not write to ${copy_log}. Wrong volume permissions?"; exit 1; }
  echo "--- Copying files at $(date)" >> "$copy_log"
  find /usr/share/jenkins/ref/ \( -type f -o -type l \) | xargs -I % -P10 bash -c '. /jenkins-support; copy_reference_file %'

    nami_initialize jenkins
    info "Starting jenkins... "
fi

exec tini -- "$@"
