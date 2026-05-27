#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libopensearch.sh

# Load OpenSearch environment variables
. /opt/bitnami/scripts/opensearch-env.sh

# Ensure we clean up temporary files when this script ends
trap "cleanup_credentials" EXIT
elasticsearch_healthcheck
