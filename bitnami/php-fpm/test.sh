#!/usr/bin/env bats
CONTAINER_NAME=bitnami-php-fpm-test
NGINX_CONTAINER_NAME=bitnami-nginx-test
IMAGE_NAME=bitnami/php-fpm
NGINX_IMAGE_NAME=bitnami/nginx
SLEEP_TIME=3
VOL_PREFIX=/bitnami/php-fpm
HOST_VOL_PREFIX=/tmp/bitnami/php-fpm

cleanup_running_containers() {
  if [ "$(docker ps -a | grep $CONTAINER_NAME)" ]; then
    docker rm -fv $CONTAINER_NAME
  fi

  if [ "$(docker ps -a | grep $NGINX_CONTAINER_NAME)" ]; then
    docker rm -fv $NGINX_CONTAINER_NAME
  fi
}

create_container(){
  docker run -d --name $CONTAINER_NAME "$@" $IMAGE_NAME
}

add_vhost() {
  docker exec $NGINX_CONTAINER_NAME sh -c "echo 'server { listen 0.0.0.0:81; root /app; location ~ \.php$ { fastcgi_pass php:9000; include fastcgi.conf; } }' > /bitnami/nginx/conf/vhosts/test.conf"
}

create_nginx_container(){
  docker run -d --name $NGINX_CONTAINER_NAME\
   --link $CONTAINER_NAME:php $NGINX_IMAGE_NAME
  add_vhost
  docker restart $NGINX_CONTAINER_NAME
  sleep $SLEEP_TIME
}

setup () {
  cleanup_running_containers
}

teardown() {
  cleanup_running_containers
}

@test "php and php-fpm installed" {
  create_container
  run docker exec $CONTAINER_NAME php -v
  [ "$status" = 0 ]
  run docker exec $CONTAINER_NAME php-fpm -v
  [ "$status" = 0 ]
}

@test "winter is coming via nginx" {
  create_container
  docker exec $CONTAINER_NAME sh -c "echo '<?php echo \"Winter is coming\"; ?>' > index.php"
  create_nginx_container
  run docker exec $NGINX_CONTAINER_NAME curl 127.0.0.1:81/index.php
  [[ "$output" =~ "Winter is coming" ]]
}

@test "required volumes exposed" {
  create_container
  run docker inspect $CONTAINER_NAME
  [[ "$output" =~ "/app" ]]
  [[ "$output" =~ "$VOL_PREFIX/logs" ]]
  [[ "$output" =~ "$VOL_PREFIX/conf" ]]
}

@test "Data gets generated in conf if bind mounted in the host" {
  create_container -v $HOST_VOL_PREFIX/conf:$VOL_PREFIX/conf -v $HOST_VOL_PREFIX/logs:$VOL_PREFIX/logs
  run docker run --rm -v $HOST_VOL_PREFIX:$HOST_VOL_PREFIX $IMAGE_NAME ls -l $HOST_VOL_PREFIX/conf/php-fpm.conf $HOST_VOL_PREFIX/logs/php-fpm.log
  [ $status = 0 ]
  docker run --rm -v $HOST_VOL_PREFIX:$HOST_VOL_PREFIX $IMAGE_NAME sh -c "sudo rm -rf $HOST_VOL_PREFIX/*"
}
