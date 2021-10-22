#!/bin/bash

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load SonarQube environment
. /opt/bitnami/scripts/sonarqube-env.sh

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libsonarqube.sh

# Using 'sonar.sh console' to start SonarQube in foreground
START_CMD=("${SONARQUBE_BIN_DIR}/sonar.sh" "console")

# SonarQube expects files and folders (i.e. temp or data) to be relative to the CWD by default
cd "$SONARQUBE_BASE_DIR"

info "** Starting SonarQube **"
if am_i_root; then
    exec gosu "$SONARQUBE_DAEMON_USER" "${START_CMD[@]}" "$@"
else
    exec "${START_CMD[@]}" "$@"
fi
