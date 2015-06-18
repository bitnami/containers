#!/usr/bin/env bats

CONTAINER_NAME=redis
IMAGE_NAME=bitnami/redis
SLEEP_TIME=3
VOL_PREFIX=/bitnami/$CONTAINER_NAME
HOST_VOL_PREFIX=/tmp/bitnami/$CONTAINER_NAME
REDIS_PASSWORD=test_password123

# Check config override from host
setup() {
  mkdir -p $HOST_VOL_PREFIX
}

teardown() {
  if [ "$(docker ps -a | grep $CONTAINER_NAME)" ]; then
    docker rm -fv $CONTAINER_NAME
  fi
}

create_container(){
  docker run -itd --name $CONTAINER_NAME $IMAGE_NAME
  sleep $SLEEP_TIME
}


@test "Auth if no password provided" {
  create_container
  run docker exec -it $CONTAINER_NAME redis-cli ping
  [[ "$output" =~ "PONG" ]]
}

@test "Auth if password provided" {
  docker run -itd --name $CONTAINER_NAME\
   -e REDIS_PASSWORD=$REDIS_PASSWORD $IMAGE_NAME
  # Longs sleep because of bnconfig password update
  sleep 10
  # Can't connect without passw
  run docker exec -it $CONTAINER_NAME redis-cli ping
  [[ "$output" =~ "NOAUTH Authentication required" ]]
  run docker exec -it $CONTAINER_NAME redis-cli -a $REDIS_PASSWORD ping
  [[ "$output" =~ "PONG" ]]
}

@test "All the volumes exposed" {
  create_container
  docker inspect $CONTAINER_NAME | {
    run grep "\"Volumes\":" -A 3
    [[ "$output" =~ "$VOL_PREFIX/logs" ]]
    [[ "$output" =~ "$VOL_PREFIX/conf" ]]
    [[ "$output" =~ "$VOL_PREFIX/data" ]]
  }
}

