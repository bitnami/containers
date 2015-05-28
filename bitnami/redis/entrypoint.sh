#!/bin/bash

if [ ! "$(ls -A /conf)" ]; then
  cp -r /usr/local/bitnami/redis/etc/conf.defaults/* /usr/local/bitnami/redis/etc/conf
fi

# TODO, Add random password

exec "$@"
