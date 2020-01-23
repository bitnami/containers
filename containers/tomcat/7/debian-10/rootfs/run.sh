#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

#set -o xtrace # Uncomment this line for debugging purpose
# shellcheck disable=SC1091

# Load libraries
. /libtomcat.sh
. /liblog.sh

# Load Tomcat environment variables
eval "$(tomcat_env)"

info "** Starting Tomcat **"

start_command=("${TOMCAT_BIN_DIR}/catalina.sh" "run")

if am_i_root; then
    exec gosu "$TOMCAT_DAEMON_USER" "${start_command[@]}"
else
    exec "${start_command[@]}"
fi

