#!/bin/bash

# shellcheck disable=SC1090

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. "${BITNAMI_SCRIPTS_DIR:-}"/libfs.sh
. "${BITNAMI_SCRIPTS_DIR:-}"/libos.sh
. "${BITNAMI_SCRIPTS_DIR:-}"/libmemcached.sh

# Load Memcached environment variables
. "${BITNAMI_SCRIPTS_DIR:-}"/memcached-env.sh

# Ensure Memcached environment variables are valid
memcached_validate

# Ensure Memcached is initialized
memcached_initialize
