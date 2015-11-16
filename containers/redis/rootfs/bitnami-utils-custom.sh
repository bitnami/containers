# Redis Utility functions

set_redis_password() {
  if [ "$REDIS_PASSWORD" ]; then
    echo "Setting redis password ..."
    sed -i 's/# requirepass .*/requirepass '"$REDIS_PASSWORD"'/' $BITNAMI_APP_DIR/etc/conf/redis.conf
  fi
}

print_redis_password() {
  if [ -z $REDIS_PASSWORD ]; then
    echo "**none**"
  else
    echo $REDIS_PASSWORD
  fi
}
