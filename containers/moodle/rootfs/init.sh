#!/bin/sh
test -f /etc/cron.d/moodle && /usr/sbin/cron
nami start --foreground apache
