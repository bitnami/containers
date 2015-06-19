#!/usr/bin/env bats

CONTAINER_NAME=bitnami-memcached-test
IMAGE_NAME=bitnami/memcached
RUBY_CONTAINER_NAME=bitnami-ruby-test
RUBY_IMAGE_NAME=bitnami/ruby
SLEEP_TIME=3
VOL_PREFIX=/bitnami/memcached
MEMCACHED_PASSWORD=test_password123

cleanup_running_containers() {
  if [ "$(docker ps -a | grep $CONTAINER_NAME)" ]; then
    docker rm -fv $CONTAINER_NAME
  fi
  if [ "$(docker ps -a | grep $RUBY_CONTAINER_NAME)" ]; then
    docker rm -fv $RUBY_CONTAINER_NAME
  fi
}

setup() {
  cleanup_running_containers
}

teardown() {
  cleanup_running_containers
}

create_container() {
  if [ $1 ]; then
    docker run -d --name $CONTAINER_NAME\
     -e MEMCACHED_PASSWORD=$MEMCACHED_PASSWORD $IMAGE_NAME
  else
    docker run -d --name $CONTAINER_NAME $IMAGE_NAME
  fi
  sleep $SLEEP_TIME
}

create_ruby_container() {
  docker run --name $RUBY_CONTAINER_NAME -id\
   --link $CONTAINER_NAME:memcached $RUBY_IMAGE_NAME
  docker exec $RUBY_CONTAINER_NAME sudo gem install dalli
}

@test "Auth if no password provided" {
  create_container
  create_ruby_container
  run docker exec $RUBY_CONTAINER_NAME ruby -e "require 'dalli'; Dalli::Client.new('memcached:11211').set('test', 'bitnami')"
  [[ "$status" = 0 ]]
}

@test "Auth if password provided" {
  create_container with_password
  create_ruby_container
  run docker exec $RUBY_CONTAINER_NAME ruby -e "require 'dalli'; Dalli::Client.new('memcached:11211').set('test', 'bitnami')"
  [[ "$status" = 1 ]]
  run docker exec $RUBY_CONTAINER_NAME\
    ruby -e "require 'dalli'; Dalli::Client.new('memcached:11211', {username: 'user', password: '$MEMCACHED_PASSWORD'}).set('test', 'bitnami')"
  [[ "$status" = 0 ]]
}

@test "All the volumes exposed" {
  create_container
  run docker inspect $CONTAINER_NAME
  [[ "$output" =~ "$VOL_PREFIX/logs" ]]
}

