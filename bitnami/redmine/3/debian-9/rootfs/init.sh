#!/bin/bash

# Set default values depending on database variation
if [ -n "$REDMINE_DB_POSTGRES" ]; then
    export REDMINE_DB_PORT_NUMBER=${REDMINE_DB_PORT_NUMBER:-5432}
    export REDMINE_DB_USERNAME=${REDMINE_DB_USERNAME:-postgres}
elif [ -n "$REDMINE_DB_MYSQL" ]; then
    export REDMINE_DB_PORT_NUMBER=${REDMINE_DB_PORT_NUMBER:-3306}
    export REDMINE_DB_USERNAME=${REDMINE_DB_USERNAME:-root}
fi
