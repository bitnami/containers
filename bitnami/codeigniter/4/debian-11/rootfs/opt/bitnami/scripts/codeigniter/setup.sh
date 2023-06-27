#!/bin/bash
# Copyright VMware, Inc.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libcodeigniter.sh

# Load CodeIgniter environment
. /opt/bitnami/scripts/codeigniter-env.sh

# Load MySQL Client environment for 'mysql_remote_execute' (after 'symfony-env.sh' so that MODULE is not set to a wrong value)
. /opt/bitnami/scripts/mysql-client-env.sh

# Ensure CodeIgniter environment variables are valid
codeigniter_validate

# Ensure CodeIgniter app is initialized
codeigniter_initialize

# Ensure all folders in /app are writable by the non-root "bitnami" user
chown -R bitnami:bitnami /app
