#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/libjenkins.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh

# Load Jenkins environment
. /opt/bitnami/scripts/jenkins-env.sh

# Ensure Jenkins environment variables are valid
jenkins_validate

if am_i_root; then
    info "Creating Jenkins daemon user"
    ensure_user_exists "$JENKINS_DAEMON_USER" --group "$JENKINS_DAEMON_GROUP" --home "$JENKINS_HOME" --system
fi

# Ensure Jenkins is initialized
jenkins_initialize
