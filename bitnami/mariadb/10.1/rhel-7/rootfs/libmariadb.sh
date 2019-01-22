#!/bin/bash
#
# Bitnami MariaDB library

# shellcheck disable=SC1091

# Export env. variables
export DB_FLAVOR="mariadb"
export DB_SBINDIR="/opt/bitnami/${DB_FLAVOR}/sbin"

# Load MySQL Library
# 'libmariadb.sh' is just a wrapper of 'libmysql.sh'
. /libmysql.sh
