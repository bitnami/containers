#!/usr/bin/env bats
CONTAINER_NAME=node-test
IMAGE_NAME=bitnami/node
SLEEP_TIME=3
VOL_PREFIX=/bitnami/$CONTAINER_NAME

create_container(){
  docker run -itd --name $CONTAINER_NAME $IMAGE_NAME
  sleep $SLEEP_TIME
}

setup () {
  create_container
}

teardown() {
  if [ "$(docker ps -a | grep $CONTAINER_NAME)" ]; then
    docker rm -fv $CONTAINER_NAME
  fi
}

@test "node and npm installed" {
  run docker exec $CONTAINER_NAME npm -v
  [ "$status" = 0 ]
  run docker exec $CONTAINER_NAME node -v
  [ "$status" = 0 ]
}

@test "python installed" {
  skip
  run docker exec $CONTAINER_NAME python -v
  [ "$status" = 0 ]
}

@test "can install npm modules with system requirements" {
  run docker exec $CONTAINER_NAME\
  # test npm modules
  npm install imagemagick-native express bower
  [ "$status" = 0 ]
}

@test "All the volumes exposed" {
  docker inspect $CONTAINER_NAME | {
    run grep "\"Volumes\":" -A 1
    [[ "$output" =~ "/app" ]]
  }
}

