#!/usr/bin/env bats

TOMCAT_DEFAULT_USER=user
TOMCAT_USER=tomcat_user
TOMCAT_PASSWORD=test_password

# source the helper script
APP_NAME=tomcat
SLEEP_TIME=30
VOL_PREFIX=/bitnami/$APP_NAME
VOLUMES=$VOL_PREFIX
load tests/docker_helper

# Cleans up all running/stopped containers and host mounted volumes
cleanup_environment() {
  container_remove_full default
}

# Teardown called at the end of each test
teardown() {
  cleanup_environment
}

# cleanup the environment before starting the tests
cleanup_environment

@test "Port 8080 exposed and accepting external connections" {
  container_create default -d
  run curl_client default -i http://$APP_NAME:8080
  [[ "$output" =~ '200 OK' ]]
}

@test "Default user is created without a password" {
  container_create default -d
  run curl_client default -i http://$TOMCAT_DEFAULT_USER@$APP_NAME:8080/manager/html
  [[ "$output" =~ '200 OK' ]]
}

@test "Can assign custom password for the default user" {
  container_create default -d \
    -e TOMCAT_PASSWORD=$TOMCAT_PASSWORD
  run curl_client default -i http://$TOMCAT_DEFAULT_USER:$TOMCAT_PASSWORD@$APP_NAME:8080/manager/html
  [[ "$output" =~ '200 OK' ]]
}

@test "Can create custom user with manager role" {
  container_create default -d \
    -e TOMCAT_USER=$TOMCAT_USER \
    -e TOMCAT_PASSWORD=$TOMCAT_PASSWORD
  run curl_client default -i http://$TOMCAT_USER:$TOMCAT_PASSWORD@$APP_NAME:8080/manager/html
  [[ "$output" =~ '200 OK' ]]
}

@test "Password and settings are preserved after restart" {
  container_create default -d \
    -e TOMCAT_USER=$TOMCAT_USER \
    -e TOMCAT_PASSWORD=$TOMCAT_PASSWORD

  container_restart default

  run curl_client default -i http://$TOMCAT_USER:$TOMCAT_PASSWORD@$APP_NAME:8080/manager/html
  [[ "$output" =~ '200 OK' ]]
}

@test "All the volumes exposed" {
  container_create default -d
  run container_inspect default --format {{.Mounts}}
  [[ "$output" =~ "$VOL_PREFIX" ]]
}

@test "Data gets generated in volume if bind mounted in the host" {
  container_create_with_host_volumes default -d \
    -e TOMCAT_USER=$TOMCAT_USER \
    -e TOMCAT_PASSWORD=$TOMCAT_PASSWORD

  run container_exec default ls -la $VOL_PREFIX/conf/
  [[ "$output" =~ "server.xml" ]]
  [[ "$output" =~ "tomcat-users.xml" ]]

  run container_exec default ls -la $VOL_PREFIX/data/
  [[ "$output" =~ "ROOT" ]]
  [[ "$output" =~ "manager" ]]
}

@test "If host mounted, password and settings are preserved after deletion" {
  container_create_with_host_volumes default -d \
    -e TOMCAT_USER=$TOMCAT_USER \
    -e TOMCAT_PASSWORD=$TOMCAT_PASSWORD

  container_remove default
  container_create_with_host_volumes default -d

  run curl_client default -i http://$TOMCAT_USER:$TOMCAT_PASSWORD@$APP_NAME:8080/manager/html
  [[ "$output" =~ '200 OK' ]]
}

@test "Deploy sample application" {
  container_create_with_host_volumes default -d \
    -e TOMCAT_USER=$TOMCAT_USER \
    -e TOMCAT_PASSWORD=$TOMCAT_PASSWORD

  container_exec default curl --noproxy localhost --retry 5 \
    http://localhost:8080/docs/appdev/sample/sample.war -o $VOL_PREFIX/data/sample.war
  sleep 10

  run curl_client default -i http://$APP_NAME:8080/sample/hello.jsp
  [[ "$output" =~ '200 OK' ]]
}
