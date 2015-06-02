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
  RANDOM_PASSW=1
fi

echo "Setting password..."

/usr/local/bitnami/memcached/bnconfig --userpassword $MEMCACHED_PASSWORD

echo "#########################################################################"
echo "#                                                                       #"
echo "# Credentials for memcached:                                            #"
echo "# password: $MEMCACHED_PASSWORD                                                #"
echo "#                                                                       #"

if [ $RANDOM_PASSW ]; then
  echo "# The password was generated automatically, if you want to use          #"
  echo "# your own password please set the MEMCACHED_PASSWORD environment       #"
  echo "# variable when running the container.                                  #"
  echo "#                                                                       #"
fi
echo "#########################################################################"
echo ""

exec "$@" >> /logs/memcached.log 2>&1
