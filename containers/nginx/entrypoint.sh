#!/bin/bash

if [ ! "$(ls -A /conf)" ]; then
  cp -r /usr/local/bitnami/nginx/conf.defaults/* /usr/local/bitnami/nginx/conf
fi

if [ ! "$(ls -A /app)" ]; then
  cp -r /usr/local/bitnami/nginx/html.defaults/* /usr/local/bitnami/nginx/html
fi
exec "$@"
