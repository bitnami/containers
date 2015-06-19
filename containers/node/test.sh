#!/usr/bin/env bats
CONTAINER_NAME=bitnami-node-test
IMAGE_NAME=bitnami/node

cleanup_running_containers() {
  if [ "$(docker ps -a | grep $CONTAINER_NAME)" ]; then
    docker rm -fv $CONTAINER_NAME
  fi
}

add_app() {
  docker exec $CONTAINER_NAME sh -c "echo \"
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
\" > /app/server.js"
}

create_container() {
  docker run -id --name $CONTAINER_NAME $IMAGE_NAME
}

setup () {
  cleanup_running_containers
  create_container
}

teardown() {
  cleanup_running_containers
}

@test "node and npm installed" {
  run docker exec $CONTAINER_NAME npm -v
  [ "$status" = 0 ]
  run docker exec $CONTAINER_NAME node -v
  [ "$status" = 0 ]
}

@test "python installed" {
  skip
  run docker exec $CONTAINER_NAME python -v
  [ "$status" = 0 ]
}

@test "can install npm modules with system requirements" {
  run docker exec $CONTAINER_NAME\
  npm install imagemagick-native bower
  [ "$status" = 0 ]
}

@test "all the volumes exposed" {
  docker inspect $CONTAINER_NAME | {
    run grep "\"Volumes\":" -A 1
    [[ "$output" =~ "/app" ]]
  }
}

@test "port 3000 exposed" {
  add_app
  docker exec -d $CONTAINER_NAME sh -c 'npm install express && node server.js'
  sleep 10
  run docker run --rm --link $CONTAINER_NAME:node bitnami/node curl http://node:3000/
  [[ "$output" =~ "The night is dark and full of terrors" ]]
}
