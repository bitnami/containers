#!/usr/bin/env bats

MONGODB_ROOT_USER=root
MONGODB_DATABASE=test_database
MONGODB_USER=test_user
MONGODB_PASSWORD=test_password

# source the helper script
APP_NAME=mongodb
SLEEP_TIME=5
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
  run mongo_client default ping
  [[ "$output" =~ "bye" ]]
}

@test "Can't create root user without password" {
  # create container without specifying MONGODB_PASSWORD for root user
  run container_create default \
    -e MONGODB_USER=$MONGODB_ROOT_USER
  [[ "$output" =~ "you need to provide the MONGODB_PASSWORD" ]]
}

@test "Root user created with password" {
  container_create default -d \
    -e MONGODB_USER=$MONGODB_ROOT_USER \
    -e MONGODB_PASSWORD=$MONGODB_PASSWORD

  # auth as root without specifying password
  run mongo_client default -u $MONGODB_ROOT_USER admin --eval "printjson(db.adminCommand('listDatabases'))"
  [[ "$output" =~ "login failed" ]]

  # auth as root and list all databases
  run mongo_client default -u $MONGODB_ROOT_USER -p $MONGODB_PASSWORD admin --eval "printjson(db.adminCommand('listDatabases'))"
  [[ "$output" =~ '"ok" : 1' ]]
  [[ "$output" =~ '"name" : "local"' ]]
}

@test "Can't create a custom user without password" {
  # create custom user without specifying MONGODB_PASSWORD
  run container_create default \
    -e MONGODB_USER=$MONGODB_USER
  [[ "$output" =~ "you need to provide the MONGODB_PASSWORD" ]]
}

@test "Can't create a custom user without database" {
  # create custom user without specifying MONGODB_DATABASE
  run container_create default \
    -e MONGODB_USER=$MONGODB_USER \
    -e MONGODB_PASSWORD=$MONGODB_PASSWORD
  [[ "$output" =~ "you need to provide the MONGODB_DATABASE" ]]
}

@test "Create custom user and database with password" {
  container_create default -d \
    -e MONGODB_USER=$MONGODB_USER \
    -e MONGODB_DATABASE=$MONGODB_DATABASE \
    -e MONGODB_PASSWORD=$MONGODB_PASSWORD

  # auth as MONGODB_USER without specifying MONGODB_PASSWORD
  run mongo_client default -u $MONGODB_USER $MONGODB_DATABASE --eval "printjson(db.adminCommand('listCollections'))"
  [[ "$output" =~ "login failed" ]]

  # auth as MONGODB_USER and list all Collections from MONGODB_DATABASE
  run mongo_client default -u $MONGODB_USER -p $MONGODB_PASSWORD $MONGODB_DATABASE --eval "printjson(db.adminCommand('listCollections'))"
  [[ "$output" =~ '"ok" : 1' ]]
}

@test "Custom user can't access admin database" {
  container_create default -d \
    -e MONGODB_USER=$MONGODB_USER \
    -e MONGODB_DATABASE=$MONGODB_DATABASE \
    -e MONGODB_PASSWORD=$MONGODB_PASSWORD

  # auth as MONGODB_USER and list all databases
  run mongo_client default -u $MONGODB_USER -p $MONGODB_PASSWORD admin --eval "printjson(db.adminCommand('listDatabases'))"
  [[ "$output" =~ 'login failed' ]]
}

@test "All the volumes exposed" {
  container_create default -d

  # get container introspection details and check if volumes are exposed
  run container_inspect default --format {{.Mounts}}
  [[ "$output" =~ "$VOL_PREFIX/data" ]]
  [[ "$output" =~ "$VOL_PREFIX/conf" ]]
  [[ "$output" =~ "$VOL_PREFIX/logs" ]]
}

@test "Data gets generated in conf, data and logs if bind mounted in the host" {
  container_create_with_host_volumes default -d \
    -e MONGODB_USER=$MONGODB_USER \
    -e MONGODB_DATABASE=$MONGODB_DATABASE \
    -e MONGODB_PASSWORD=$MONGODB_PASSWORD

  # files expected in conf volume
  run container_exec default ls -la $VOL_PREFIX/conf/
  [[ "$output" =~ "mongodb.conf" ]]

  # files expected in data volume (subset)
  run container_exec default ls -la $VOL_PREFIX/data/
  [[ "$output" =~ "storage.bson" ]]
  [[ "$output" =~ "local.0" ]]
  [[ "$output" =~ "local.ns" ]]

  # files expected in logs volume
  run container_exec default ls -la $VOL_PREFIX/logs/
  [[ "$output" =~ "mongodb.log" ]]
}

@test "User and password settings are preserved after restart" {
  container_create default -d \
    -e MONGODB_USER=$MONGODB_USER \
    -e MONGODB_DATABASE=$MONGODB_DATABASE \
    -e MONGODB_PASSWORD=$MONGODB_PASSWORD

  # restart container
  container_restart default

  # get container logs
  run container_logs default
  [[ "$output" =~ "The credentials were set on first boot." ]]

  # auth as MONGODB_USER and list all Collections from MONGODB_DATABASE
  run mongo_client default -u $MONGODB_USER -p $MONGODB_PASSWORD $MONGODB_DATABASE --eval "printjson(db.adminCommand('listCollections'))"
  [[ "$output" =~ '"ok" : 1' ]]
}

@test "If host mounted, password and settings are preserved after deletion" {
  container_create_with_host_volumes default -d \
    -e MONGODB_USER=$MONGODB_USER \
    -e MONGODB_DATABASE=$MONGODB_DATABASE \
    -e MONGODB_PASSWORD=$MONGODB_PASSWORD

  # stop and remove container
  container_remove default

  # recreate container without specifying any env parameters
  container_create_with_host_volumes default -d

  # auth as MONGODB_USER and list all Collections from MONGODB_DATABASE
  run mongo_client default -u $MONGODB_USER -p $MONGODB_PASSWORD $MONGODB_DATABASE --eval "printjson(db.adminCommand('listCollections'))"
  [[ "$output" =~ '"ok" : 1' ]]
}

@test "Configuration changes are preserved after deletion" {
  container_create_with_host_volumes default -d

  # modify mongodb.conf
  container_exec default sed -i 's|^[#]*[ ]*bind_ip[ ]*=.*|bind_ip=0.0.0.0|' $VOL_PREFIX/conf/mongodb.conf
  container_exec default sed -i 's|^[#]*[ ]*logappend[ ]*=.*|logappend=false|' $VOL_PREFIX/conf/mongodb.conf
  container_exec default sed -i 's|^[#]*[ ]*cpu[ ]*=.*|cpu=false|' $VOL_PREFIX/conf/mongodb.conf

  # stop and remove container
  container_remove default

  # relaunch container with host volumes
  container_create_with_host_volumes default -d

  run container_exec default cat $VOL_PREFIX/conf/mongodb.conf
  [[ "$output" =~ "bind_ip=0.0.0.0" ]]
  [[ "$output" =~ "logappend=false" ]]
  [[ "$output" =~ "cpu=false" ]]
}
