#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libsolr.sh

# Load solr environment variables
. /opt/bitnami/scripts/solr-env.sh

# Ensure solr environment variables are valid
solr_validate

# Ensure solr is initialized
solr_initialize
