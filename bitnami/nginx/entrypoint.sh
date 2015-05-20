#!/bin/bash

if [ ! "$(ls -A /config)" ]; then
  cp -r /opt/bitnami/nginx/conf.defaults/* /opt/bitnami/nginx/conf
fi
exec "$@"
