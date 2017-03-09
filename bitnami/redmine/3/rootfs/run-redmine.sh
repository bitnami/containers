#!/bin/bash -e
. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

info "Starting redmine..."

cd /opt/bitnami/redmine
exec bundle exec passenger start -e production --log-file /opt/bitnami/redmine/logs/production.log -p 3000
