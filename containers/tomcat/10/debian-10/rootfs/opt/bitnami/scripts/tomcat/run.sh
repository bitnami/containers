#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/libtomcat.sh
. /opt/bitnami/scripts/liblog.sh

# Load Tomcat environment variables
eval "$(tomcat_env)"

info "** Starting Tomcat **"

start_command=("${TOMCAT_BIN_DIR}/catalina.sh" "run")

if am_i_root; then
    exec gosu "$TOMCAT_DAEMON_USER" "${start_command[@]}"
else
    exec "${start_command[@]}"
fi

