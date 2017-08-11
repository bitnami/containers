#!/bin/bash
. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

USER=ghost
# ghost initialization leaves a running pm2 instance
KILL_PREVIOUS_PROCESS_COMMAND="/opt/bitnami/ghost/node_modules/pm2/bin/pm2 kill"
START_COMMAND="/opt/bitnami/ghost/node_modules/pm2/bin/pm2 start --merge-logs --no-daemon \
                                                         -p /opt/bitnami/ghost/tmp/pids/ghost.pid \
                                                         -l /opt/bitnami/ghost/logs/ghost.log \
                                                         /opt/bitnami/ghost/index.js"
export NODE_ENV=production
export HOME=/home/ghost

# If container is started as `root` user
if [ $EUID -eq 0 ]; then
    gosu ${USER} ${KILL_PREVIOUS_PROCESS_COMMAND}
    exec gosu ${USER} ${START_COMMAND}
else
    ${KILL_PREVIOUS_PROCESS_COMMAND}
    exec ${START_COMMAND}
fi
