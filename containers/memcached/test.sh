#!/usr/bin/env bats

CONTAINER_NAME=memcached
IMAGE_NAME=bitnami/memcached
RUBY_CONTAINER_NAME=ruby
RUBY_IMAGE_NAME=bitnami/ruby
SLEEP_TIME=3
VOL_PREFIX=/bitnami/$CONTAINER_NAME
MEMCACHED_PASSWORD=test_password123

teardown() {
  if [ "$(docker ps -a | grep $CONTAINER_NAME)" ]; then
    docker rm -fv $CONTAINER_NAME
  fi
  if [ "$(docker ps -a | grep $RUBY_CONTAINER_NAME)" ]; then
    docker rm -fv $RUBY_CONTAINER_NAME
  fi
}

create_container() {
  if [ $1 ]; then
    docker run -itd --name $CONTAINER_NAME\
     -e MEMCACHED_PASSWORD=$MEMCACHED_PASSWORD $IMAGE_NAME
  else
    docker run -itd --name $CONTAINER_NAME $IMAGE_NAME
  fi
  sleep $SLEEP_TIME
}

create_ruby_container() {
  docker run --name $RUBY_CONTAINER_NAME -itd\
   --link $CONTAINER_NAME:memcached $RUBY_IMAGE_NAME
  docker exec ruby sudo gem install dalli
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
  docker inspect $CONTAINER_NAME | {
    run grep "\"Volumes\":" -A 1
    [[ "$output" =~ "$VOL_PREFIX/logs" ]]
  }
}

