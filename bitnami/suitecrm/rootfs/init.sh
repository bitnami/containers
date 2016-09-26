#!/bin/sh

_forwardTerm () {
 echo "Caugth signal SIGTERM, passing it to child processes..."
 cpids=$(pgrep -P $$ | xargs)
 kill -15 $cpids 2> /dev/null
 wait
 exit $?
}

trap _forwardTerm TERM

/usr/sbin/cron &
harpoon start --foreground apache &
wait
