#!/usr/bin/env bats

# source the helper script
APP_NAME=ruby
VOLUMES=/app
SLEEP_TIME=0
load tests/docker_helper

# Cleans up all running/stopped containers
cleanup_environment() {
  container_remove default
}

# Teardown called at the end of each test
teardown() {
  cleanup_environment
}

# cleanup the environment before starting the tests
cleanup_environment

@test "ruby, gem and bundler installed" {
  container_create default -id

  run container_exec default ruby -v
  [ "$status" = 0 ]
  run container_exec default gem -v
  [ "$status" = 0 ]
  run container_exec default bundle -v
  [ "$status" = 0 ]
}

@test "can install gem modules with system requirements" {
  container_create default -id
  run container_exec default gem install nokogiri mysql2 pg --no-document
  [ "$status" = 0 ]
}

@test "port 3000 exposed" {
  container_create default -id

  # create sample sinatra application
  container_exec default sh -c "cat > /app/server.rb <<EOF
require 'sinatra'

set :bind, '0.0.0.0'
set :port, 3000

get '/hi' do
  'A Lanister always pays his debts'
end
EOF"

  # install application dependencies
  container_exec default gem install sinatra --no-ri --no-rdoc

  # start application and wait 5 secs for app to boot up
  container_exec_detached default ruby server.rb
  sleep 5

  # test application using curl
  run curl_client default http://ruby:3000/hi
  [[ "$output" =~ "A Lanister always pays his debts" ]]
}
