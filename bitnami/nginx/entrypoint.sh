#!/bin/bash

if [ ! "$(ls -A /conf)" ]; then
  cp -r /opt/bitnami/nginx/conf.defaults/* /opt/bitnami/nginx/conf
fi

if [ ! "$(ls -A /app)" ]; then
  cp -r /opt/bitnami/nginx/html.defaults/* /opt/bitnami/nginx/html
fi
exec "$@"
