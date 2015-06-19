#!/usr/bin/env bats

CONTAINER_NAME=bitnami-apache-test
IMAGE_NAME=bitnami/apache
SLEEP_TIME=2
VOL_PREFIX=/bitnami/apache

cleanup_running_containers() {
  if [ "$(docker ps -a | grep $CONTAINER_NAME)" ]; then
    docker rm -fv $CONTAINER_NAME
  fi
}

setup() {
  cleanup_running_containers
}

teardown() {
  cleanup_running_containers
}

create_container(){
  docker run -d --name $CONTAINER_NAME \
   --expose 81 $IMAGE_NAME
  sleep $SLEEP_TIME
}

add_vhost() {
  docker exec $CONTAINER_NAME sh -c "echo 'Listen 81
<VirtualHost *:81>
  ServerName default
  Redirect 405 /
</VirtualHost>' > $VOL_PREFIX/conf/vhosts/test.conf"
}


@test "We can connect to the port 80 and 443" {
  create_container
  run docker run --link $CONTAINER_NAME:apache --rm bitnami/apache curl -L -i http://apache:80
  [[ "$output" =~  "200 OK" ]]
  [ $status = 0 ]

  run docker run --link $CONTAINER_NAME:apache --rm bitnami/apache curl -L -i -k https://apache:443
  [[ "$output" =~  "200 OK" ]]
  [ $status = 0 ]
}

@test "Returns default page" {
  create_container
  run docker run --link $CONTAINER_NAME:apache --rm bitnami/apache curl -L -i http://apache:80
  [[ "$output" =~  "It works!" ]]
  [ $status = 0 ]

  run docker run --link $CONTAINER_NAME:apache --rm bitnami/apache curl -L -i -k https://apache:443
  [[ "$output" =~  "It works!" ]]
  [ $status = 0 ]
}

@test "Logs to stdout" {
  create_container
  docker run --link $CONTAINER_NAME:apache --rm bitnami/apache curl -L -i http://apache:80
  run docker logs $CONTAINER_NAME
  [[ "$output" =~  "GET / HTTP/1.1" ]]
  [ $status = 0 ]
}

@test "All the volumes exposed" {
  create_container
  run docker inspect $CONTAINER_NAME
  [[ "$output" =~ "$VOL_PREFIX/logs" ]]
  [[ "$output" =~ "$VOL_PREFIX/conf" ]]
  [[ "$output" =~ "/app" ]]
}

@test "Vhosts directory is imported" {
  create_container
  add_vhost
  docker restart $CONTAINER_NAME
  sleep $SLEEP_TIME
  docker run --link $CONTAINER_NAME:apache --rm bitnami/apache curl -L -i http://apache:81 | {
    run grep "405 Method Not Allowed"
    [ $status = 0 ]
  }
}
