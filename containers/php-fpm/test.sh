#!/usr/bin/env bats

NGINX_IMAGE_NAME=bitnami/nginx
NGINX_CONTAINER_NAME=bitnami-nginx-test

# source the helper script
APP_NAME=php-fpm
SLEEP_TIME=10
VOL_PREFIX=/bitnami/$APP_NAME
VOLUMES=$VOL_PREFIX
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

create_nginx_container() {
  docker run --name $NGINX_CONTAINER_NAME -d \
    $(container_link default $APP_NAME) $NGINX_IMAGE_NAME
  sleep $SLEEP_TIME

  docker exec $NGINX_CONTAINER_NAME sh -c "mkdir -p /bitnami/nginx/conf/vhosts && cat > /bitnami/nginx/conf/vhosts/test.conf <<EOF
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

@test "php and php-fpm installed" {
  container_create default -d

  run container_exec default php -v
  [ "$status" = 0 ]
  run container_exec default php-fpm -v
  [ "$status" = 0 ]
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

@test "All the volumes exposed" {
  container_create default -d

  # get container introspection details and check if volumes are exposed
  run container_inspect default --format {{.Mounts}}
  [[ "$output" =~ "$VOL_PREFIX" ]]
}

@test "Data gets generated in conf if bind mounted in the host" {
  container_create_with_host_volumes default -d

  # files expected in conf volume
  run container_exec default ls -la $VOL_PREFIX/conf/
  [[ "$output" =~ "php-fpm.conf" ]]
  [[ "$output" =~ "php.ini" ]]
}

@test "Configuration changes are preserved after restart" {
  container_create default -d

  # modify php-fpm.conf
  container_exec default sed -i 's|^[#]*[ ]*pm.max_children[ ]*=.*|pm.max_children=10|' $VOL_PREFIX/conf/php-fpm.d/www.conf
  container_exec default sed -i 's|^[#]*[ ]*pm.start_servers[ ]*=.*|pm.start_servers=5|' $VOL_PREFIX/conf/php-fpm.d/www.conf
  container_exec default sed -i 's|^[#]*[ ]*pm.min_spare_servers[ ]*=.*|pm.min_spare_servers=3|' $VOL_PREFIX/conf/php-fpm.d/www.conf

  # modify php.ini
  container_exec default sed -i 's|^[;]*[ ]*soap.wsdl_cache_limit[ ]*=.*|soap.wsdl_cache_limit=10|' $VOL_PREFIX/conf/php.ini
  container_exec default sed -i 's|^[;]*[ ]*opcache.enable[ ]*=.*|opcache.enable=1|' $VOL_PREFIX/conf/php.ini

  container_restart default

  run container_exec default cat $VOL_PREFIX/conf/php-fpm.d/www.conf
  [[ "$output" =~ "pm.max_children=10" ]]
  [[ "$output" =~ "pm.start_servers=5" ]]
  [[ "$output" =~ "pm.min_spare_servers=3" ]]

  run container_exec default cat $VOL_PREFIX/conf/php.ini
  [[ "$output" =~ "soap.wsdl_cache_limit=10" ]]
  [[ "$output" =~ "opcache.enable=1" ]]
}

@test "Configuration changes are preserved after deletion" {
  container_create_with_host_volumes default -d

  # modify php-fpm.conf
  container_exec default sed -i 's|^[#]*[ ]*pm.max_children[ ]*=.*|pm.max_children=10|' $VOL_PREFIX/conf/php-fpm.d/www.conf
  container_exec default sed -i 's|^[#]*[ ]*pm.start_servers[ ]*=.*|pm.start_servers=5|' $VOL_PREFIX/conf/php-fpm.d/www.conf
  container_exec default sed -i 's|^[#]*[ ]*pm.min_spare_servers[ ]*=.*|pm.min_spare_servers=3|' $VOL_PREFIX/conf/php-fpm.d/www.conf

  # modify php.ini
  container_exec default sed -i 's|^[;]*[ ]*soap.wsdl_cache_limit[ ]*=.*|soap.wsdl_cache_limit=10|' $VOL_PREFIX/conf/php.ini
  container_exec default sed -i 's|^[;]*[ ]*opcache.enable[ ]*=.*|opcache.enable=1|' $VOL_PREFIX/conf/php.ini

  # stop and remove container
  container_remove default

  # relaunch container with host volumes
  container_create_with_host_volumes default -d

  run container_exec default cat $VOL_PREFIX/conf/php-fpm.d/www.conf
  [[ "$output" =~ "pm.max_children=10" ]]
  [[ "$output" =~ "pm.start_servers=5" ]]
  [[ "$output" =~ "pm.min_spare_servers=3" ]]

  run container_exec default cat $VOL_PREFIX/conf/php.ini
  [[ "$output" =~ "soap.wsdl_cache_limit=10" ]]
  [[ "$output" =~ "opcache.enable=1" ]]
}
