#!/usr/bin/env bats

# source the helper script
APP_NAME=node
VOLUMES=/app
SLEEP_TIME=3
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

@test "node and npm installed" {
  container_create default -id

  run container_exec default npm -v
  [ "$status" = 0 ]

  run container_exec default node -v
  [ "$status" = 0 ]
}

@test "python installed" {
  container_create default -id

  run container_exec default python -v
  [ "$status" = 0 ]
}

@test "can install npm modules with system requirements" {
  container_create default -id

  run container_exec default npm install pg-native bower
  [ "$status" = 0 ]
}

@test "can install global npm modules" {
  container_create default -id

  run container_exec default npm install -g node-static
  [ "$status" = 0 ]
}

@test "port 3000 exposed" {
  container_create default -id

  # create sample express app
  container_exec default sh -c "cat > /app/server.js <<EOF
var express = require('express');
var app = express();

app.get('/', function (req, res) {
  res.send('The night is dark and full of terrors');
});

var server = app.listen(3000, '0.0.0.0', function () {
  var host = server.address().address;
  var port = server.address().port;

  console.log('Example app listening at http://%s:%s', host, port);
});
EOF"

  # install express
  container_exec default npm install express

  # start server
  container_exec_detached default node server.js
  sleep 5

  # test connection on port 3000
  run curl_client default http://node:3000/
  [[ "$output" =~ "The night is dark and full of terrors" ]]
}
