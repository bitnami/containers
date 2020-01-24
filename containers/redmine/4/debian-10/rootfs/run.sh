#!/bin/bash -e
. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

USER=redmine
RAILS_ENV=production
PID_FILE=/opt/bitnami/redmine/tmp/pids/redmine.pid
LOG_FILE=/opt/bitnami/redmine/logs/production.log

mkdir -p /opt/bitnami/redmine/tmp/pids
chown ${USER}: -R /opt/bitnami/redmine/tmp
chmod -R 1777 /opt/bitnami/redmine/tmp

info "Starting redmine..."
cd /opt/bitnami/redmine || exit 1
exec gosu ${USER} bundle exec passenger start -e ${RAILS_ENV} --pid-file ${PID_FILE} --log-file ${LOG_FILE} -p 3000
