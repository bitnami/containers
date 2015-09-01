#!/usr/bin/env bats

CONTAINER_NAME=bitnami-wildfly-test
IMAGE_NAME=${IMAGE_NAME:-bitnami/wildfly}
SLEEP_TIME=5
WILDFLY_USER=manager
WILDFLY_DEFAULT_PASSWORD=wildfly
WILDFLY_PASSWORD=test_password

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

create_container() {
  docker run --name $CONTAINER_NAME "$@" $IMAGE_NAME
  sleep $SLEEP_TIME
}

create_full_container() {
  docker run -d --name $CONTAINER_NAME\
   -e WILDFLY_PASSWORD=$WILDFLY_PASSWORD $IMAGE_NAME
  sleep $SLEEP_TIME
}

@test "Ports 8080 and 9990 exposed and accepting external connections" {
  create_container -d
  run docker run --link $CONTAINER_NAME:wildfly --rm $IMAGE_NAME curl -L -i http://wildfly:8080
  [[ "$output" =~ '200 OK' ]]
  run docker run --link $CONTAINER_NAME:wildfly --rm $IMAGE_NAME curl -L -i http://wildfly:9990
  [[ "$output" =~ '200 OK' ]]
}

@test "Manager has access to management area" {
  create_container -d
  run docker run --link $CONTAINER_NAME:wildfly --rm $IMAGE_NAME curl -L -i --digest http://$WILDFLY_USER:$WILDFLY_DEFAULT_PASSWORD@wildfly:9990/management
  [[ "$output" =~ '200 OK' ]]
}

@test "User manager created with custom password" {
  create_container -d -e WILDFLY_PASSWORD=$WILDFLY_PASSWORD
  run docker run --link $CONTAINER_NAME:wildfly --rm $IMAGE_NAME curl -L -i --digest http://$WILDFLY_USER:$WILDFLY_PASSWORD@wildfly:9990/management
  [[ "$output" =~ '200 OK' ]]
}

@test "Can't access management area without password" {
  create_container -d -e WILDFLY_PASSWORD=$WILDFLY_PASSWORD
  run docker run --link $CONTAINER_NAME:wildfly --rm $IMAGE_NAME curl -L -i --digest http://$WILDFLY_USER@wildfly:9990/management
  [[ "$output" =~ '401 Unauthorized' ]]
}

@test "Password is preserved after restart" {
  create_full_container

  docker stop $CONTAINER_NAME
  docker start $CONTAINER_NAME
  sleep $SLEEP_TIME

  run docker logs $CONTAINER_NAME
  [[ "$output" =~ "The credentials were set on first boot." ]]

  run docker run --link $CONTAINER_NAME:wildfly --rm $IMAGE_NAME curl -L -i --digest http://$WILDFLY_USER:$WILDFLY_PASSWORD@wildfly:9990/management
  [[ "$output" =~ '200 OK' ]]
}
