#!/usr/bin/env bats

CONTAINER_NAME=bitnami-redis-test
IMAGE_NAME=bitnami/redis
SLEEP_TIME=3
VOL_PREFIX=/bitnami/redis
REDIS_PASSWORD=test_password123
HOST_VOL_PREFIX=/tmp/$VOL_PREFIX

cleanup_running_containers() {
  if [ "$(docker ps -a | grep $CONTAINER_NAME)" ]; then
    docker rm -fv $CONTAINER_NAME
  fi
}

cleanup_volumes_content() {
  docker run --rm\
    -v $HOST_VOL_PREFIX/data:$VOL_PREFIX/data\
    $IMAGE_NAME rm -rf $VOL_PREFIX/data/
}

setup() {
  cleanup_running_containers
}

teardown() {
  cleanup_running_containers
}

create_container(){
  docker run -d --name $CONTAINER_NAME "$@" $IMAGE_NAME
  sleep $SLEEP_TIME
}

redis_client(){
  docker exec $CONTAINER_NAME redis-cli "$@"
}

@test "Auth if no password provided" {
  create_container
  run redis_client ping
  [[ "$output" =~ "PONG" ]]
}

@test "Auth if password provided" {
  create_container -e REDIS_PASSWORD=$REDIS_PASSWORD
  # Longs sleep because of bnconfig password update
  sleep 15
  # Can't connect without passw
  run redis_client ping
  [[ "$output" =~ "NOAUTH Authentication required" ]]
  run redis_client -a $REDIS_PASSWORD ping
  [[ "$output" =~ "PONG" ]]
}

@test "Password settings are preserved after restart" {
  create_container -e REDIS_PASSWORD=$REDIS_PASSWORD
  sleep 15
  run docker logs $CONTAINER_NAME
  [[ "$output" =~ "Credentials for redis:" ]]
  [[ "$output" =~ "Password: $REDIS_PASSWORD" ]]

  docker stop $CONTAINER_NAME
  docker start $CONTAINER_NAME
  sleep $SLEEP_TIME

  run docker logs $CONTAINER_NAME
  [[ "$output" =~ "The credentials were set on first boot." ]]

  run redis_client -a $REDIS_PASSWORD ping
  [[ "$output" =~ "PONG" ]]
}

@test "All the volumes exposed" {
  create_container
  run docker inspect $CONTAINER_NAME
  [[ "$output" =~ "$VOL_PREFIX/logs" ]]
  [[ "$output" =~ "$VOL_PREFIX/conf" ]]
  [[ "$output" =~ "$VOL_PREFIX/data" ]]
}

@test "dump.rdb is properly created" {
  create_container -v $HOST_VOL_PREFIX/data:$VOL_PREFIX/data
  docker stop $CONTAINER_NAME
  run docker run -v $HOST_VOL_PREFIX/data:$HOST_VOL_PREFIX/data --rm $IMAGE_NAME ls -l $HOST_VOL_PREFIX/data/dump.rdb
  [ $status = 0 ]
  cleanup_volumes_content
}

@test "Redis db persists if deleted and host mounted" {
  create_container -v $HOST_VOL_PREFIX/data:$VOL_PREFIX/data
  run redis_client set winter 'is coming'
  [[ "$output" =~ "OK" ]]
  docker stop $CONTAINER_NAME
  docker rm -fv $CONTAINER_NAME
  create_container -v $HOST_VOL_PREFIX/data:$VOL_PREFIX/data
  run redis_client get winter
  [[ "$output" =~ "is coming" ]]
  cleanup_volumes_content
}
