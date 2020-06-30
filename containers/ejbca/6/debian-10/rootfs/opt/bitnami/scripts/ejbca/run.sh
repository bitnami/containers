#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libejbca.sh

# Load ejbca environment variables
. /opt/bitnami/scripts/ejbca-env.sh

info "** Starting ejbca **"
start_command=("${EJBCA_WILDFLY_BIN_DIR}/standalone.sh" "-b" "0.0.0.0")

if am_i_root; then
    exec gosu "$EJBCA_DAEMON_USER" "${start_command[@]}"
else
    exec "${start_command[@]}"
fi
