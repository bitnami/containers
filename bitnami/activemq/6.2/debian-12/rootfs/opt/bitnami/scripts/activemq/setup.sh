#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load ActiveMQ environment
. /opt/bitnami/scripts/activemq-env.sh

# Load libraries
. /opt/bitnami/scripts/libactivemq.sh

# Ensure ActiveMQ environment variables are valid
activemq_validate

# Ensure ActiveMQ is initialized
activemq_initialize