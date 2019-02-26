#!/bin/bash
. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

USER=ghost

# The reason to use the pipe is that currently there is no way to start ghost in unattended mode
# as it will ask you to update ghost-cli or continue without doing it:
# https://github.com/TryGhost/Ghost-CLI/issues/563
START_COMMAND="echo y | ghost start && tail -f /opt/bitnami/ghost/logs/ghost.log"
export NODE_ENV=production

cd /opt/bitnami/ghost || exit 1

# If container is started as `root` user
if [ $EUID -eq 0 ]; then
    exec gosu ${USER} bash -c "${START_COMMAND}"
else
    exec bash -c "$START_COMMAND"
fi
