#!/usr/bin/env bats

WELCOME_PAGE_TEXT="Redmine"

MARIADB_IMAGE_NAME=bitnami/mariadb
MARIADB_CONTAINER_NAME=bitnami-mariadb-test

# source the helper script
APP_NAME=redmine
SLEEP_TIME=120
VOLUMES=/bitnami/$APP_NAME:/bitnami/apache
load tests/docker_helper

# Cleans up all running/stopped containers and host mounted volumes
cleanup_environment() {
  if docker ps -a | grep $MARIADB_CONTAINER_NAME; then
    docker rm -fv $MARIADB_CONTAINER_NAME
  fi
  container_remove_full default
}

# Teardown called at the end of each test
teardown() {
  cleanup_environment
}

# cleanup the environment of any leftover containers and volumes before starting the tests
cleanup_environment

create_mariadb_container() {
  docker run --name $MARIADB_CONTAINER_NAME -d $MARIADB_IMAGE_NAME
  sleep 90
}

@test "Port 3000 is exposed and accepting connections" {
  create_mariadb_container
  container_create default -d \
    --link $MARIADB_CONTAINER_NAME:mariadb \
    --env MARIADB_HOST=mariadb \
    --env MARIADB_PORT=3306

  run container_exec default curl --noproxy 127.0.0.1 http://127.0.0.1:3000
  [[ "$output" =~ "$WELCOME_PAGE_TEXT" ]]
}

