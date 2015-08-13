#!/usr/bin/env bats
CONTAINER_NAME=bitnami-tomcat-test
IMAGE_NAME=${IMAGE_NAME:-bitnami/tomcat}
SLEEP_TIME=5
TOMCAT_USER=manager
TOMCAT_PASSWORD=test_password

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
  docker run --name $CONTAINER_NAME "$@" $IMAGE_NAME
  sleep $SLEEP_TIME
}

create_full_container(){
  docker run -d --name $CONTAINER_NAME\
   -e TOMCAT_PASSWORD=$TOMCAT_PASSWORD $IMAGE_NAME
  sleep $SLEEP_TIME
}

@test "Port 8080 exposed and accepting external connections" {
  create_container -d
  run docker run --link $CONTAINER_NAME:tomcat --rm $IMAGE_NAME curl -L -i http://tomcat:8080
  [[ "$output" =~ '200 OK' ]]
}

@test "Manager has access to management area" {
  create_container -d
  run docker run --link $CONTAINER_NAME:tomcat --rm $IMAGE_NAME curl -L -i http://$TOMCAT_USER@tomcat:8080/manager/html
  [[ "$output" =~ '200 OK' ]]
}

@test "User manager created with password" {
  create_container -d -e TOMCAT_PASSWORD=$TOMCAT_PASSWORD
  run docker run --link $CONTAINER_NAME:tomcat --rm $IMAGE_NAME curl -L -i http://$TOMCAT_USER:$TOMCAT_PASSWORD@tomcat:8080/manager/html
  [[ "$output" =~ '200 OK' ]]
}

@test "Can't access management area without password" {
  create_container -d -e TOMCAT_PASSWORD=$TOMCAT_PASSWORD
  run docker run --link $CONTAINER_NAME:tomcat --rm $IMAGE_NAME curl -L -i http://$TOMCAT_USER@tomcat:8080/manager/html
  [[ "$output" =~ '401 Unauthorized' ]]
}

@test "Password is preserved after restart" {
  create_full_container

  docker stop $CONTAINER_NAME
  docker start $CONTAINER_NAME
  sleep $SLEEP_TIME

  run docker logs $CONTAINER_NAME
  [[ "$output" =~ "The credentials were set on first boot." ]]

  run docker run --link $CONTAINER_NAME:tomcat --rm $IMAGE_NAME curl -L -i http://$TOMCAT_USER:$TOMCAT_PASSWORD@tomcat:8080/manager/html
  [[ "$output" =~ '200 OK' ]]
}

@test "All the volumes exposed" {
  create_container -d
  run docker inspect $CONTAINER_NAME
  [[ "$output" =~ "/app" ]]
  [[ "$output" =~ "$VOL_PREFIX/conf" ]]
  [[ "$output" =~ "$VOL_PREFIX/logs" ]]
}
