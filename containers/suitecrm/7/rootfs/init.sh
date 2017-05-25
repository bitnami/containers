#!/bin/sh

_forwardTerm () {
 echo "Caugth signal SIGTERM, passing it to child processes..."
 cpids=$(pgrep -P $$ | xargs)
 kill -15 $cpids 2> /dev/null
 wait
 exit $?
}

trap _forwardTerm TERM

# Adding cron entries
ln -fs /opt/bitnami/suitecrm/conf/cron /etc/cron.d/suitecrm

/usr/sbin/cron &
nami start --foreground apache &
wait
