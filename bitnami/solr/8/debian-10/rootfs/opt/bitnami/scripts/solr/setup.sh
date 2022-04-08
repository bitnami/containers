#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/libsolr.sh

# Load solr environment variables
. /opt/bitnami/scripts/solr-env.sh

# Ensure solr environment variables are valid
solr_validate

# Ensure solr is initialized
solr_initialize
