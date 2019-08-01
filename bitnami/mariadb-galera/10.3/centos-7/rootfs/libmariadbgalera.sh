#!/bin/bash
#
# Bitnami MariaDB library

# shellcheck disable=SC1091

# Export environment variables
export DB_FLAVOR="mariadb"
export DB_SBINDIR="/opt/bitnami/${DB_FLAVOR}/sbin"

# Load MySQL Library
# 'libmariadbgalera.sh' is just a wrapper of 'libmysqlgalera.sh'
. /libmysqlgalera.sh
