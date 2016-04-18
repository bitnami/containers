#!/usr/bin/env bats

MONGODB_DATABASE=test_database
MONGODB_USER=test_user
MONGODB_PASSWORD=test_password

# source the helper script
APP_NAME=mongodb
VOL_PREFIX=/bitnami/$APP_NAME
VOLUMES=$VOL_PREFIX
SLEEP_TIME=15
load tests/docker_helper

# Link to container and execute mongo client
# $1 : name of the container to link to
# ${@:2} : arguments for the mongo command
mongo_client() {
  container_link_and_run_command $1 mongo --host $APP_NAME "${@:2}"
}

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

@test "Port 27017 exposed and accepting external connections" {
  container_create default -d

  # ping the mongod server
  run mongo_client default admin --eval "printjson(db.adminCommand('ping'))"
  [[ "$output" =~ '"ok" : 1' ]]
}

@test "Authentication is enabled if password is specified" {
  container_create default -d \
    -e MONGODB_PASSWORD=$MONGODB_PASSWORD

  run mongo_client default admin --eval "printjson(db.adminCommand('listDatabases'))"
  [[ "$output" =~ "not authorized on admin to execute command" ]]
}

@test "Root user created with password" {
  container_create default -d \
    -e MONGODB_PASSWORD=$MONGODB_PASSWORD

  run mongo_client default -u root -p $MONGODB_PASSWORD admin --eval "printjson(db.adminCommand('listDatabases'))"
  [[ "$output" =~ '"ok" : 1' ]]
  [[ "$output" =~ '"name" : "local"' ]]
}

@test "Custom user created with password" {
  container_create default -d \
    -e MONGODB_USER=$MONGODB_USER \
    -e MONGODB_PASSWORD=$MONGODB_PASSWORD

  run mongo_client default -u $MONGODB_USER -p $MONGODB_PASSWORD admin --eval "printjson(db.adminCommand('listDatabases'))"
  [[ "$output" =~ '"ok" : 1' ]]
  [[ "$output" =~ '"name" : "local"' ]]
}

@test "Custom user can access admin database" {
  container_create default -d \
    -e MONGODB_USER=$MONGODB_USER \
    -e MONGODB_PASSWORD=$MONGODB_PASSWORD

  run mongo_client default -u $MONGODB_USER -p $MONGODB_PASSWORD admin --eval "printjson(db.adminCommand('listDatabases'))"
  [[ "$output" =~ '"ok" : 1' ]]
  [[ "$output" =~ '"name" : "local"' ]]
}

@test "All the volumes exposed" {
  container_create default -d

  # get container introspection details and check if volumes are exposed
  run container_inspect default --format {{.Mounts}}
  [[ "$output" =~ "$VOL_PREFIX" ]]
}

@test "Data gets generated in volume if bind mounted" {
  container_create_with_host_volumes default -d \
    -e MONGODB_USER=$MONGODB_USER \
    -e MONGODB_PASSWORD=$MONGODB_PASSWORD

  run container_exec default ls -la $VOL_PREFIX/conf/
  [[ "$output" =~ "mongodb.conf" ]]

  run container_exec default ls -la $VOL_PREFIX/data/db/
  [[ "$output" =~ "storage.bson" ]]
}

@test "User and password settings are preserved after restart" {
  container_create default -d \
    -e MONGODB_USER=$MONGODB_USER \
    -e MONGODB_PASSWORD=$MONGODB_PASSWORD

  container_restart default

  run mongo_client default -u $MONGODB_USER -p $MONGODB_PASSWORD admin --eval "printjson(db.adminCommand('listDatabases'))"
  [[ "$output" =~ '"ok" : 1' ]]
  [[ "$output" =~ '"name" : "local"' ]]
}

@test "If host mounted, password and settings are preserved after deletion" {
  container_create_with_host_volumes default -d \
    -e MONGODB_USER=$MONGODB_USER \
    -e MONGODB_PASSWORD=$MONGODB_PASSWORD

  container_remove default
  container_create_with_host_volumes default -d

  run mongo_client default -u $MONGODB_USER -p $MONGODB_PASSWORD admin --eval "printjson(db.adminCommand('listDatabases'))"
  [[ "$output" =~ '"ok" : 1' ]]
  [[ "$output" =~ '"name" : "local"' ]]
}

@test "Configuration changes are preserved after deletion" {
  container_create_with_host_volumes default -d \
    -e MONGODB_USER=$MONGODB_USER \
    -e MONGODB_PASSWORD=$MONGODB_PASSWORD

  # modify mongodb.conf to disable auth
  container_exec default sed -i 's|[#]*auth[ ]*=.*|auth = false|' $VOL_PREFIX/conf/mongodb.conf

  container_remove default
  container_create_with_host_volumes default -d

  # list database without authentication
  run mongo_client default admin --eval "printjson(db.adminCommand('listDatabases'))"
  [[ "$output" =~ '"ok" : 1' ]]
  [[ "$output" =~ '"name" : "local"' ]]
}
