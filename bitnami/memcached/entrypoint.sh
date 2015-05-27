#!/bin/bash
set -e

# if command starts with an option, prepend memcached
if [ "${1:0:1}" = '-' ]; then
  set -- memcached "$@"
fi

if [ "$1" = 'memcached' ]; then
  set -- "$@" -u memcached -S -l 0.0.0.0
fi

if [ -z "$MEMCACHED_PASSWORD" ]; then
  MEMCACHED_PASSWORD=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c10)$(< /dev/urandom tr -dc 0-9 | head -c2)
fi

/usr/local/bitnami/memcached/bnconfig --userpassword $MEMCACHED_PASSWORD

echo "===> Credentials for memcached:"
echo "  username: user"
echo "  password: $MEMCACHED_PASSWORD"
echo ""
echo "  Set the MEMCACHED_PASSWORD environment variable when running the"
echo "  container to manually set a password."
echo ""

if [ "$(readlink /logs/memcached.log)" != "/dev/stdout" ]; then
  echo "===> Logging to /logs/memcached.log"
  echo ""
fi

exec "$@" >> /logs/memcached.log 2>&1
