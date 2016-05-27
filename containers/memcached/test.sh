#!/usr/bin/env bats

MEMCACHED_USER=test_user
MEMCACHED_PASSWORD=test_password123

RUBY_CONTAINER_NAME=bitnami-ruby-test
RUBY_IMAGE_NAME=bitnami/ruby

# source the helper script
APP_NAME=memcached
SLEEP_TIME=5
load tests/docker_helper

# Cleans up all running/stopped containers and host mounted volumes
cleanup_environment() {
  # remove ruby container
  if docker ps -a | grep $RUBY_CONTAINER_NAME; then
    docker rm -fv $RUBY_CONTAINER_NAME
  fi
  container_remove default
}

# Teardown called at the end of each test
teardown() {
  cleanup_environment
}

# cleanup the environment of any leftover containers and volumes before starting the tests
cleanup_environment

create_ruby_container() {
  docker run --name $RUBY_CONTAINER_NAME -id \
    $(container_link default $APP_NAME) $RUBY_IMAGE_NAME
  sleep $SLEEP_TIME
  docker exec $RUBY_CONTAINER_NAME sudo gem install dalli
}

@test "Port 11211 is exposed and accepting connections" {
  container_create default -d
  create_ruby_container
  run docker exec $RUBY_CONTAINER_NAME \
    ruby -e "require 'dalli'; Dalli::Client.new('$APP_NAME:11211').set('test', 'bitnami')"
  [[ "$status" = 0 ]]
}

@test "Auth if password provided" {
  container_create default -d \
    -e MEMCACHED_PASSWORD=$MEMCACHED_PASSWORD

  create_ruby_container

  run docker exec $RUBY_CONTAINER_NAME \
    ruby -e "require 'dalli'; Dalli::Client.new('$APP_NAME:11211').set('test', 'bitnami')"
  [[ "$output" =~ "Authentication required" ]]

  run docker exec $RUBY_CONTAINER_NAME \
    ruby -e "require 'dalli'; Dalli::Client.new('$APP_NAME:11211', {username: 'root', password: '$MEMCACHED_PASSWORD'}).set('test', 'bitnami')"
  [[ "$output" =~ "Authenticated" ]]
}

@test "Can create custom user with password" {
  container_create default -d \
    -e MEMCACHED_USER=$MEMCACHED_USER \
    -e MEMCACHED_PASSWORD=$MEMCACHED_PASSWORD

  create_ruby_container

  run docker exec $RUBY_CONTAINER_NAME \
    ruby -e "require 'dalli'; Dalli::Client.new('$APP_NAME:11211', {username: '$MEMCACHED_USER', password: '$MEMCACHED_PASSWORD'}).set('test', 'bitnami')"
  [[ "$output" =~ "Authenticated" ]]
}
