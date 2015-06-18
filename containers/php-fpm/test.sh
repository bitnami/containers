#!/usr/bin/env bats
CONTAINER_NAME=php-fpm-test
NGINX_CONTAINER_NAME=nginx-test
IMAGE_NAME=bitnami/php-fpm
NGINX_IMAGE_NAME=bitnami/nginx
SLEEP_TIME=3
VOL_PREFIX=/bitnami/php-fpm

create_container(){
  docker run -itd --name $CONTAINER_NAME $IMAGE_NAME
}

add_vhost() {
  docker exec $NGINX_CONTAINER_NAME sh -c "echo 'server { listen 0.0.0.0:81; root /app; location ~ \.php$ { fastcgi_pass php:9000; include fastcgi.conf; } }' > /bitnami/nginx/conf/vhosts/test.conf"
}

create_nginx_container(){
  docker run -itd --name $NGINX_CONTAINER_NAME\
   --link $CONTAINER_NAME:php $NGINX_IMAGE_NAME
  add_vhost
  docker restart $NGINX_CONTAINER_NAME
  sleep $SLEEP_TIME
}

setup () {
  create_container
}

teardown() {
  if [ "$(docker ps -a | grep $CONTAINER_NAME)" ]; then
    docker rm -fv $CONTAINER_NAME
  fi

  if [ "$(docker ps -a | grep $NGINX_CONTAINER_NAME)" ]; then
    docker rm -fv $NGINX_CONTAINER_NAME
  fi
}

@test "php and php-fpm installed" {
  run docker exec $CONTAINER_NAME php -v
  [ "$status" = 0 ]
  run docker exec $CONTAINER_NAME php-fpm -v
  [ "$status" = 0 ]
}

@test "winter is coming via nginx" {
  docker exec $CONTAINER_NAME sh -c "echo '<?php echo \"Winter is coming\"; ?>' > index.php"
  create_nginx_container
  run docker exec $NGINX_CONTAINER_NAME curl 127.0.0.1:81/index.php
  [[ "$output" =~ "Winter is coming" ]]
}

@test "required volumes exposed" {
  docker inspect $CONTAINER_NAME | {
    run grep "\"Volumes\":" -A 3
    [[ "$output" =~ "/app" ]]
    [[ "$output" =~ "$VOL_PREFIX/logs" ]]
    [[ "$output" =~ "$VOL_PREFIX/conf" ]]
  }
}

