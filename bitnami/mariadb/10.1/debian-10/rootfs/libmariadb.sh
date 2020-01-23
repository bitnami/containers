#!/bin/bash
#
# Bitnami MariaDB library

# shellcheck disable=SC1091

# Export environment variables
export DB_FLAVOR="mariadb"
export DB_SBIN_DIR="/opt/bitnami/${DB_FLAVOR}/sbin"

# Load MySQL Library
# 'libmariadb.sh' is just a wrapper of 'libmysql.sh'
. /libmysql.sh
