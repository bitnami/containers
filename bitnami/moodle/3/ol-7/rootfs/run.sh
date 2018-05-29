#!/bin/bash

# Adding cron entries
ln -fs /opt/bitnami/moodle/conf/cron /etc/cron.d/moodle

/usr/sbin/crond
nami start --foreground apache
