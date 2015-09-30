#!/usr/bin/env bats
CONTAINER_NAME=bitnami-ruby-test
IMAGE_NAME=bitnami/ruby
VOL_PREFIX=/bitnami/$CONTAINER_NAME

create_container(){
  docker run -itd --name $CONTAINER_NAME $IMAGE_NAME
}

add_app() {
  docker exec $CONTAINER_NAME sh -c "echo \"
require 'sinatra'

set :bind, '0.0.0.0'
set :port, 3000

get '/hi' do
  'A Lanister always pays his debts'
end\" > /app/server.rb"
}

setup () {
  create_container
}

teardown() {
  if [ "$(docker ps -a | grep $CONTAINER_NAME)" ]; then
    docker rm -fv $CONTAINER_NAME
  fi
}

@test "ruby, gem and bundler installed" {
  run docker exec $CONTAINER_NAME ruby -v
  [ "$status" = 0 ]
  run docker exec $CONTAINER_NAME gem -v
  [ "$status" = 0 ]
  run docker exec $CONTAINER_NAME bundle -v
  [ "$status" = 0 ]
}

@test "can install gem modules with system requirements" {
  run docker exec $CONTAINER_NAME gem install nokogiri --no-ri --no-rdoc
  [ "$status" = 0 ]
}

@test "port 3000 exposed" {
  add_app
  docker exec -d $CONTAINER_NAME sh -c 'gem install sinatra --no-ri --no-rdoc && ruby server.rb'
  sleep 10
  run docker run --rm --link $CONTAINER_NAME:ruby bitnami/ruby curl http://ruby:3000/hi
  [[ "$output" =~ "A Lanister always pays his debts" ]]
}
