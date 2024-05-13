#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh

# Load Jenkins Agent environment
. /opt/bitnami/scripts/jenkins-agent-env.sh

# Ensure required directories exist
chmod g+rwX "$JENKINS_AGENT_BASE_DIR"
for dir in "$JENKINS_AGENT_WORKDIR" "$JENKINS_AGENT_TMP_DIR" "$JENKINS_AGENT_LOGS_DIR"; do
    ensure_dir_exists "$dir"
    configure_permissions_ownership "$dir" -d "775" -f "664"
done
