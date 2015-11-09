#!/usr/bin/env bats

NGINX_IMAGE_NAME=bitnami/nginx
NGINX_CONTAINER_NAME=bitnami-nginx-test

# source the helper script
APP_NAME=php-fpm
SLEEP_TIME=3
VOL_PREFIX=/bitnami/$APP_NAME
VOLUMES=/app:$VOL_PREFIX/logs:$VOL_PREFIX/conf
load tests/docker_helper

# Cleans up all running/stopped containers and host mounted volumes
cleanup_environment() {
  if docker ps -a | grep $NGINX_CONTAINER_NAME; then
    docker rm -fv $NGINX_CONTAINER_NAME
  fi
  container_remove_full default
}

# Teardown called at the end of each test
teardown() {
  cleanup_environment
}

# cleanup the environment of any leftover containers and volumes before starting the tests
cleanup_environment

@test "php and php-fpm installed" {
  container_create default -d

  run container_exec default php -v
  [ "$status" = 0 ]
  run container_exec default php-fpm -v
  [ "$status" = 0 ]
}

create_nginx_container() {
  docker run --name $NGINX_CONTAINER_NAME -d \
    $(container_link default $APP_NAME) $NGINX_IMAGE_NAME
  sleep $SLEEP_TIME

  docker exec $NGINX_CONTAINER_NAME sh -c "cat > /bitnami/nginx/conf/vhosts/test.conf <<EOF
server {
  listen 0.0.0.0:81;
  root /app;
  location ~ \.php\$ {
    fastcgi_pass $APP_NAME:9000;
    include fastcgi.conf;
  }
}
EOF"

  docker restart $NGINX_CONTAINER_NAME
  sleep $SLEEP_TIME
}

@test "winter is coming via nginx" {
  container_create default -d

  # create test app
  container_exec default sh -c "cat > /app/index.php <<EOF
<?php echo \"Winter is coming\"; ?>
EOF"

  create_nginx_container

  run docker exec $NGINX_CONTAINER_NAME curl --noproxy 127.0.0.1 127.0.0.1:81/index.php
  [[ "$output" =~ "Winter is coming" ]]
}

@test "required volumes exposed" {
  container_create default -d
  run container_inspect default --format {{.Mounts}}
  [[ "$output" =~ "$VOL_PREFIX/logs" ]]
  [[ "$output" =~ "$VOL_PREFIX/conf" ]]
}

@test "Data gets generated in conf if bind mounted in the host" {
  container_create_with_host_volumes default -d

  # files expected in conf volume
  run container_exec default ls -la $VOL_PREFIX/conf/
  [[ "$output" =~ "php-fpm.conf" ]]

  # files expected in logs volume
  run container_exec default ls -la $VOL_PREFIX/conf/ $VOL_PREFIX/logs/
  [[ "$output" =~ "php-fpm.log" ]]
}
