#!/bin/bash
set -e

if [ ! "$(ls -A /conf)" ]; then
  cp -r /usr/local/bitnami/redis/etc/conf.defaults/* /usr/local/bitnami/redis/etc/conf

  if [ -z "$REDIS_PASSWORD" ]; then
    REDIS_PASSWORD=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c10)$(< /dev/urandom tr -dc 0-9 | head -c2)
    RANDOM_PASSW=1
  fi

  # bnconfig depends on ctlscript file so we create it
  # and remove it afterwards, TODO, fix
  touch /usr/local/bitnami/ctlscript.sh
  chmod a+x /usr/local/bitnami/ctlscript.sh

  echo "Setting password in /conf/redis.conf ..."
  /usr/local/bitnami/redis/bnconfig --userpassword $REDIS_PASSWORD

  rm /usr/local/bitnami/ctlscript.sh

  echo "===> Credentials for redis:"
  echo "  password: $REDIS_PASSWORD"
  echo ""

  if [ $RANDOM_PASSW ]; then
    echo "  The password was generated automatically, if you want to use your own password "
    echo "  please set the REDIS_PASSWORD environment variable when running the container."
  fi
  echo ""

else
  echo "===> Credentials for redis:"
  echo "  The REDIS_PASSWORD was added to /conf/redis.conf during the first boot."
  echo "  Please check \"requirepass\" option in that file."
  echo "  If you want to regenerate the password recreate this container."
fi

exec "$@"
