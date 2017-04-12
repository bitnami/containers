#!/bin/bash
. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

USER=ghost

export NODE_ENV=production

info "Starting ghost..."
exec gosu ${USER} /opt/bitnami/ghost/node_modules/pm2/bin/pm2 start --merge-logs --no-daemon \
  -p /opt/bitnami/ghost/tmp/pids/ghost.pid \
  -l /opt/bitnami/ghost/logs/ghost.log \
  /opt/bitnami/ghost/index.js
