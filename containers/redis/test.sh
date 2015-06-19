#!/usr/bin/env bats

CONTAINER_NAME=bitnami-redis-test
IMAGE_NAME=bitnami/redis
SLEEP_TIME=3
VOL_PREFIX=/bitnami/redis
REDIS_PASSWORD=test_password123

teardown() {
  if [ "$(docker ps -a | grep $CONTAINER_NAME)" ]; then
    docker rm -fv $CONTAINER_NAME
  fi
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
  sleep 10
  # Can't connect without passw
  run redis_client ping
  [[ "$output" =~ "NOAUTH Authentication required" ]]
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

