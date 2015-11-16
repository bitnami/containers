# Redis Utility functions

set_redis_password() {
  if [ "$REDIS_PASSWORD" ]; then
    echo "Setting redis password ..."
    sed -i 's/# requirepass .*/requirepass '"$REDIS_PASSWORD"'/' $BITNAMI_APP_DIR/etc/conf/redis.conf
  fi
}

configure_replication() {
  if [ "$REDIS_REPLICATION_MODE" == "slave" ]; then
    echo ""
    echo "==> Setting up Redis slave..."

    echo "==> Trying to fetch Redis replication parameters from the master link..."
    REDIS_MASTER_HOST=${REDIS_MASTER_HOST:-$MASTER_PORT_6379_TCP_ADDR}
    REDIS_MASTER_PORT=${REDIS_MASTER_PORT:-$MASTER_PORT_6379_TCP_PORT}
    REDIS_MASTER_PASSWORD=${REDIS_MASTER_PASSWORD:-$MASTER_ENV_REDIS_PASSWORD}

    if [ ! $REDIS_MASTER_HOST ]; then
      echo "In order to setup a replication slave you need to provide the REDIS_MASTER_HOST as well"
      echo ""
      exit -1
    fi

    if [ ! $REDIS_MASTER_PORT ]; then
      echo "REDIS_MASTER_PORT not specified. Defaulting to 6379"
      echo ""
      POSTGRESQL_MASTER_PORT=${POSTGRESQL_MASTER_PORT:-6379}
    fi

    echo "==> Checking if master is ready to accept connection (60s timeout)..."
    timeout=60
    while ! redis-cli -h $REDIS_MASTER_HOST -p $REDIS_MASTER_PORT ${REDIS_MASTER_PASSWORD:+-a $REDIS_MASTER_PASSWORD} ping >/dev/null 2>&1
    do
      timeout=$(expr $timeout - 1)
      if [[ $timeout -eq 0 ]]; then
        echo ""
        echo "Could not connect to replication master"
        echo ""
        exit -1
      fi
      sleep 1
    done

    echo "==> Setting the master configuration..."
    sed 's|^[#]*[ ]*slaveof .*|slaveof '"$REDIS_MASTER_HOST"' '"$REDIS_MASTER_PORT"'|' -i $BITNAMI_APP_DIR/etc/conf/redis.conf
    if [ $REDIS_MASTER_PASSWORD ]; then
      sed 's|^[#]*[ ]*masterauth .*|masterauth '"$REDIS_MASTER_PASSWORD"'|' -i $BITNAMI_APP_DIR/etc/conf/redis.conf
    fi
    echo ""
  fi
}

print_redis_password() {
  if [ -z $REDIS_PASSWORD ]; then
    echo "**none**"
  else
    echo $REDIS_PASSWORD
  fi
}
