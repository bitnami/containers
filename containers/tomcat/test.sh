#!/usr/bin/env bats
CONTAINER_NAME=bitnami-tomcat-test
IMAGE_NAME=${IMAGE_NAME:-bitnami/tomcat}
SLEEP_TIME=5
TOMCAT_USER=manager
TOMCAT_PASSWORD=test_password
VOL_PREFIX=/bitnami/tomcat
HOST_VOL_PREFIX=${HOST_VOL_PREFIX:-/tmp/bitnami/$CONTAINER_NAME}

cleanup_running_containers() {
  if [ "$(docker ps -a | grep $CONTAINER_NAME)" ]; then
    docker rm -fv $CONTAINER_NAME
  fi
}

setup() {
  cleanup_running_containers
  mkdir -p $HOST_VOL_PREFIX
}

teardown() {
  cleanup_running_containers
}

cleanup_volumes_content() {
  docker run --rm\
    -v $HOST_VOL_PREFIX/app:/app\
    -v $HOST_VOL_PREFIX/conf:$VOL_PREFIX/conf\
    -v $HOST_VOL_PREFIX/logs:$VOL_PREFIX/logs\
    $IMAGE_NAME rm -rf /app/ $VOL_PREFIX/logs/ $VOL_PREFIX/conf/
}

create_container() {
  docker run --name $CONTAINER_NAME "$@" $IMAGE_NAME
  sleep $SLEEP_TIME
}

create_full_container_mounted() {
  docker run -d --name $CONTAINER_NAME\
   -e TOMCAT_PASSWORD=$TOMCAT_PASSWORD\
   -v $HOST_VOL_PREFIX/app:/app\
   -v $HOST_VOL_PREFIX/conf:$VOL_PREFIX/conf\
   -v $HOST_VOL_PREFIX/logs:$VOL_PREFIX/logs\
   $IMAGE_NAME
  sleep $SLEEP_TIME
}

@test "Port 8080 exposed and accepting external connections" {
  create_container -d
  run docker run --link $CONTAINER_NAME:tomcat --rm $IMAGE_NAME curl --noproxy tomcat --retry 5 -L -i http://tomcat:8080
  [[ "$output" =~ '200 OK' ]]
}

@test "Manager has access to management area" {
  create_container -d
  run docker run --link $CONTAINER_NAME:tomcat --rm $IMAGE_NAME curl --noproxy tomcat --retry 5 -L -i http://$TOMCAT_USER@tomcat:8080/manager/html
  [[ "$output" =~ '200 OK' ]]
}

@test "User manager created with password" {
  create_container -d -e TOMCAT_PASSWORD=$TOMCAT_PASSWORD
  run docker run --link $CONTAINER_NAME:tomcat --rm $IMAGE_NAME curl --noproxy tomcat --retry 5 -L -i http://$TOMCAT_USER:$TOMCAT_PASSWORD@tomcat:8080/manager/html
  [[ "$output" =~ '200 OK' ]]
}

@test "Can't access management area without password" {
  create_container -d -e TOMCAT_PASSWORD=$TOMCAT_PASSWORD
  run docker run --link $CONTAINER_NAME:tomcat --rm $IMAGE_NAME curl --noproxy tomcat --retry 5 -L -i http://$TOMCAT_USER@tomcat:8080/manager/html
  [[ "$output" =~ '401 Unauthorized' ]]
}

@test "Password is preserved after restart" {
  create_container -d -e TOMCAT_PASSWORD=$TOMCAT_PASSWORD

  docker stop $CONTAINER_NAME
  docker start $CONTAINER_NAME
  sleep $SLEEP_TIME

  run docker logs $CONTAINER_NAME
  [[ "$output" =~ "The credentials were set on first boot." ]]

  run docker run --link $CONTAINER_NAME:tomcat --rm $IMAGE_NAME curl --noproxy tomcat --retry 5 -L -i http://$TOMCAT_USER:$TOMCAT_PASSWORD@tomcat:8080/manager/html
  [[ "$output" =~ '200 OK' ]]
}

@test "All the volumes exposed" {
  create_container -d
  run docker inspect $CONTAINER_NAME
  [[ "$output" =~ "/app" ]]
  [[ "$output" =~ "$VOL_PREFIX/conf" ]]
  [[ "$output" =~ "$VOL_PREFIX/logs" ]]
}

@test "Data gets generated in conf if bind mounted in the host" {
  create_full_container_mounted
  run docker run -v $HOST_VOL_PREFIX:$HOST_VOL_PREFIX --rm $IMAGE_NAME ls -l $HOST_VOL_PREFIX/conf/server.xml
  [ $status = 0 ]
  cleanup_volumes_content
}

@test "If host mounted, password and settings are preserved after deletion" {
  cleanup_volumes_content
  create_full_container_mounted

  docker rm -fv $CONTAINER_NAME
  create_container -d -v $HOST_VOL_PREFIX/app:/app -v $HOST_VOL_PREFIX/conf:$VOL_PREFIX/conf

  run docker run --link $CONTAINER_NAME:tomcat --rm $IMAGE_NAME curl --noproxy tomcat --retry 5 -L -i http://$TOMCAT_USER:$TOMCAT_PASSWORD@tomcat:8080/manager/html
  [[ "$output" =~ '200 OK' ]]
  cleanup_volumes_content
}

@test "Deploy sample application" {
  cleanup_volumes_content
  create_full_container_mounted

  run docker run --rm \
    --link $CONTAINER_NAME:tomcat \
    -v $HOST_VOL_PREFIX/app:/app \
    $IMAGE_NAME curl --noproxy tomcat --retry 5 http://tomcat:8080/docs/appdev/sample/sample.war -o /app/sample.war
  [ $status = 0 ]
  sleep 10

  run docker run --link $CONTAINER_NAME:tomcat --rm $IMAGE_NAME curl --noproxy tomcat --retry 5 -L -i http://tomcat:8080/sample/hello.jsp
  [[ "$output" =~ '200 OK' ]]

  cleanup_volumes_content
}
