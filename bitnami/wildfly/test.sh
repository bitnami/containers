#!/usr/bin/env bats

CONTAINER_NAME=bitnami-wildfly-test
IMAGE_NAME=${IMAGE_NAME:-bitnami/wildfly}
SLEEP_TIME=10
WILDFLY_USER=manager
WILDFLY_DEFAULT_PASSWORD=wildfly
WILDFLY_PASSWORD=test_password
VOL_PREFIX=/bitnami/wildfly
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

create_container_domain() {
  docker run --name $CONTAINER_NAME "$@" $IMAGE_NAME domain.sh
  sleep $SLEEP_TIME
}

create_full_container_mounted() {
  docker run -d --name $CONTAINER_NAME\
   -e WILDFLY_PASSWORD=$WILDFLY_PASSWORD\
   -v $HOST_VOL_PREFIX/app:/app\
   -v $HOST_VOL_PREFIX/conf:$VOL_PREFIX/conf\
   -v $HOST_VOL_PREFIX/logs:$VOL_PREFIX/logs\
   $IMAGE_NAME
  sleep $SLEEP_TIME
}

@test "Ports 8080 and 9990 exposed and accepting external connections (standalone)" {
  create_container -d
  run docker run --link $CONTAINER_NAME:wildfly --rm $IMAGE_NAME curl -L -i http://wildfly:8080
  [[ "$output" =~ '200 OK' ]]
  run docker run --link $CONTAINER_NAME:wildfly --rm $IMAGE_NAME curl -L -i http://wildfly:9990
  [[ "$output" =~ '200 OK' ]]
}

@test "Manager has access to management area (standalone)" {
  create_container -d
  run docker run --link $CONTAINER_NAME:wildfly --rm $IMAGE_NAME curl -L -i --digest http://$WILDFLY_USER:$WILDFLY_DEFAULT_PASSWORD@wildfly:9990/management
  [[ "$output" =~ '200 OK' ]]
}

@test "User manager created with custom password (standalone)" {
  create_container -d -e WILDFLY_PASSWORD=$WILDFLY_PASSWORD
  run docker run --link $CONTAINER_NAME:wildfly --rm $IMAGE_NAME curl -L -i --digest http://$WILDFLY_USER:$WILDFLY_PASSWORD@wildfly:9990/management
  [[ "$output" =~ '200 OK' ]]
}

@test "Can't access management area without password (standalone)" {
  create_container -d -e WILDFLY_PASSWORD=$WILDFLY_PASSWORD
  run docker run --link $CONTAINER_NAME:wildfly --rm $IMAGE_NAME curl -L -i --digest http://$WILDFLY_USER@wildfly:9990/management
  [[ "$output" =~ '401 Unauthorized' ]]
}

@test "Password is preserved after restart (standalone)" {
  create_container -d -e WILDFLY_PASSWORD=$WILDFLY_PASSWORD

  docker stop $CONTAINER_NAME
  docker start $CONTAINER_NAME
  sleep $SLEEP_TIME

  run docker logs $CONTAINER_NAME
  [[ "$output" =~ "The credentials were set on first boot." ]]

  run docker run --link $CONTAINER_NAME:wildfly --rm $IMAGE_NAME curl -L -i --digest http://$WILDFLY_USER:$WILDFLY_PASSWORD@wildfly:9990/management
  [[ "$output" =~ '200 OK' ]]
}

@test "Ports 8080 and 9990 exposed and accepting external connections (domain)" {
  create_container_domain -d
  run docker run --link $CONTAINER_NAME:wildfly --rm $IMAGE_NAME curl -L -i http://wildfly:8080
  [[ "$output" =~ '200 OK' ]]
  run docker run --link $CONTAINER_NAME:wildfly --rm $IMAGE_NAME curl -L -i http://wildfly:9990
  [[ "$output" =~ '200 OK' ]]
}

@test "Manager has access to management area (domain)" {
  create_container_domain -d
  run docker run --link $CONTAINER_NAME:wildfly --rm $IMAGE_NAME curl -L -i --digest http://$WILDFLY_USER:$WILDFLY_DEFAULT_PASSWORD@wildfly:9990/management
  [[ "$output" =~ '200 OK' ]]
}

@test "User manager created with custom password (domain)" {
  create_container_domain -d -e WILDFLY_PASSWORD=$WILDFLY_PASSWORD
  run docker run --link $CONTAINER_NAME:wildfly --rm $IMAGE_NAME curl -L -i --digest http://$WILDFLY_USER:$WILDFLY_PASSWORD@wildfly:9990/management
  [[ "$output" =~ '200 OK' ]]
}

@test "Can't access management area without password (domain)" {
  create_container_domain -d -e WILDFLY_PASSWORD=$WILDFLY_PASSWORD
  run docker run --link $CONTAINER_NAME:wildfly --rm $IMAGE_NAME curl -L -i --digest http://$WILDFLY_USER@wildfly:9990/management
  [[ "$output" =~ '401 Unauthorized' ]]
}

@test "Password is preserved after restart (domain)" {
  create_container_domain -d -e WILDFLY_PASSWORD=$WILDFLY_PASSWORD

  docker stop $CONTAINER_NAME
  docker start $CONTAINER_NAME
  sleep $SLEEP_TIME

  run docker logs $CONTAINER_NAME
  [[ "$output" =~ "The credentials were set on first boot." ]]

  run docker run --link $CONTAINER_NAME:wildfly --rm $IMAGE_NAME curl -L -i --digest http://$WILDFLY_USER:$WILDFLY_PASSWORD@wildfly:9990/management
  [[ "$output" =~ '200 OK' ]]
}

@test "All the volumes exposed" {
  create_container -d
  run docker inspect $CONTAINER_NAME
  [[ "$output" =~ "/app" ]]
  [[ "$output" =~ "$VOL_PREFIX/conf" ]]
  [[ "$output" =~ "$VOL_PREFIX/logs" ]]
}

@test "Data gets generated in conf and app volumes if bind mounted in the host" {
  create_full_container_mounted
  sleep 10
  run docker run -v $HOST_VOL_PREFIX:$HOST_VOL_PREFIX --rm $IMAGE_NAME ls -la $HOST_VOL_PREFIX/conf/standalone $HOST_VOL_PREFIX/conf/domain $HOST_VOL_PREFIX/logs/server.log $HOST_VOL_PREFIX/app/.initialized
  [ $status = 0 ]
  cleanup_volumes_content
}

@test "If host mounted, password and settings are preserved after deletion" {
  cleanup_volumes_content
  create_full_container_mounted

  docker rm -fv $CONTAINER_NAME

  run docker run -d --name $CONTAINER_NAME\
   -v $HOST_VOL_PREFIX/app:/app\
   -v $HOST_VOL_PREFIX/conf:$VOL_PREFIX/conf\
   $IMAGE_NAME
  sleep $SLEEP_TIME

  run docker run --link $CONTAINER_NAME:wildfly --rm $IMAGE_NAME curl --noproxy wildfly -L -i --digest http://$WILDFLY_USER:$WILDFLY_PASSWORD@wildfly:9990/management
  [[ "$output" =~ '200 OK' ]]
  cleanup_volumes_content
}

@test "Deploy sample application on standalone server" {
  cleanup_volumes_content
  create_full_container_mounted

  run docker run --rm \
    --link $CONTAINER_NAME:wildfly \
    -v $HOST_VOL_PREFIX/app:/app \
    $IMAGE_NAME curl https://raw.githubusercontent.com/goldmann/wildfly-docker-deployment-example/master/node-info.war -o /app/node-info.war
  [ $status = 0 ]
  sleep 10

  run docker run --link $CONTAINER_NAME:wildfly --rm $IMAGE_NAME curl --noproxy wildfly -L -i http://wildfly:8080/node-info/
  [[ "$output" =~ '200 OK' ]]

  cleanup_volumes_content
}
