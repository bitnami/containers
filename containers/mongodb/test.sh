#!/usr/bin/env bats

MONGODB_DATABASE=test_database
MONGODB_USER=test_user
MONGODB_PASSWORD=test_password

# source the helper script
APP_NAME=mongodb
VOL_PREFIX=/bitnami/$APP_NAME
VOLUMES=$VOL_PREFIX
SLEEP_TIME=60
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
  container_remove_full secondary
}

# Teardown called at the end of each test
teardown() {
  cleanup_environment
}

# cleanup the environment before starting the tests
cleanup_environment

@test "Port 27017 exposed and accepting external connections" {
  container_create default -d

  run mongo_client default admin --eval "printjson(db.adminCommand('ping'))"
  [[ "$output" =~ '"ok" : 1' ]]
}

@test "Can login without a password" {
  container_create default -d
  run mongo_client default admin --eval "printjson(db.adminCommand('listDatabases'))"
  [[ "$output" =~ '"ok" : 1' ]]
  [[ "$output" =~ '"name" : "local"' ]]
}

@test "Authentication is enabled if root password is specified" {
  container_create default -d \
    -e MONGODB_ROOT_PASSWORD=$MONGODB_PASSWORD

  run mongo_client default admin --eval "printjson(db.adminCommand('listDatabases'))"
  [[ "$output" =~ "not authorized on admin to execute command" ]]
}

@test "Root user created with custom password" {
  container_create default -d \
    -e MONGODB_ROOT_PASSWORD=$MONGODB_PASSWORD

  run mongo_client default -u root -p $MONGODB_PASSWORD admin --eval "printjson(db.adminCommand('listDatabases'))"
  [[ "$output" =~ '"ok" : 1' ]]
  [[ "$output" =~ '"name" : "admin"' ]]
}

@test "Can't set root user password with MONGODB_PASSWORD" {
  run container_create default \
    -e MONGODB_PASSWORD=$MONGODB_PASSWORD
  [[ "$output" =~ "If you defined a password or a database you should define an username too" ]]
}

@test "Can't create custom user without a password" {
  run container_create default \
    -e MONGODB_USER=$MONGODB_USER
  [[ "$output" =~ "If you defined an username you must define a password and a database too" ]]
}

@test "Can't create custom user without database" {
  run container_create default \
    -e MONGODB_USER=$MONGODB_USER \
    -e MONGODB_PASSWORD=$MONGODB_PASSWORD \
  [[ "$output" =~ "If you defined an username you must define a password and a database too" ]]
}

@test "Custom user created with password" {
  container_create default -d \
    -e MONGODB_USER=$MONGODB_USER \
    -e MONGODB_PASSWORD=$MONGODB_PASSWORD \
    -e MONGODB_DATABASE=$MONGODB_DATABASE

  run mongo_client default -u $MONGODB_USER -p $MONGODB_PASSWORD $MONGODB_DATABASE --eval "printjson(db.createCollection('users'))"
  [[ "$output" =~ '"ok" : 1' ]]

  run mongo_client default -u $MONGODB_USER -p $MONGODB_PASSWORD $MONGODB_DATABASE --eval "printjson(db.getCollectionNames())"
  [[ "$output" =~ '"users"' ]]
}

@test "Custom user can't access admin database" {
  container_create default -d \
    -e MONGODB_USER=$MONGODB_USER \
    -e MONGODB_PASSWORD=$MONGODB_PASSWORD \
    -e MONGODB_DATABASE=$MONGODB_DATABASE

  run mongo_client default -u $MONGODB_USER -p $MONGODB_PASSWORD admin --eval "printjson(db.adminCommand('listDatabases'))"
  [[ "$output" =~ "login failed" ]]
}

@test "Can set root password and create custom user" {
  container_create default -d \
    -e MONGODB_ROOT_PASSWORD=$MONGODB_PASSWORD \
    -e MONGODB_USER=$MONGODB_USER \
    -e MONGODB_PASSWORD=$MONGODB_PASSWORD \
    -e MONGODB_DATABASE=$MONGODB_DATABASE

  run mongo_client default -u root -p $MONGODB_PASSWORD admin --eval "printjson(db.adminCommand('listDatabases'))"
  [[ "$output" =~ '"ok" : 1' ]]
  [[ "$output" =~ '"name" : "admin"' ]]

  run mongo_client default -u $MONGODB_USER -p $MONGODB_PASSWORD $MONGODB_DATABASE --eval "printjson(db.createCollection('users'))"
  [[ "$output" =~ '"ok" : 1' ]]

  run mongo_client default -u $MONGODB_USER -p $MONGODB_PASSWORD $MONGODB_DATABASE --eval "printjson(db.getCollectionNames())"
  [[ "$output" =~ '"users"' ]]
}

@test "Settings and data are preserved on container restart" {
  container_create default -d \
    -e MONGODB_USER=$MONGODB_USER \
    -e MONGODB_PASSWORD=$MONGODB_PASSWORD \
    -e MONGODB_DATABASE=$MONGODB_DATABASE

  run mongo_client default -u $MONGODB_USER -p $MONGODB_PASSWORD $MONGODB_DATABASE --eval "printjson(db.createCollection('users'))"
  [[ "$output" =~ '"ok" : 1' ]]

  container_restart default

  run mongo_client default -u $MONGODB_USER -p $MONGODB_PASSWORD $MONGODB_DATABASE --eval "printjson(db.getCollectionNames())"
  [[ "$output" =~ '"users"' ]]
}

@test "All the volumes exposed" {
  container_create default -d
  run container_inspect default --format {{.Mounts}}
  [[ "$output" =~ "$VOL_PREFIX" ]]
}

@test "Data gets generated in volume if bind mounted" {
  container_create_with_host_volumes default -d

  run container_exec default ls -la $VOL_PREFIX/conf/
  [[ "$output" =~ "mongodb.conf" ]]

  run container_exec default ls -la $VOL_PREFIX/data/db/
  [[ "$output" =~ "storage.bson" ]]
}

@test "If host mounted, setting and data are preserved after deletion" {
  container_create_with_host_volumes default -d \
    -e MONGODB_USER=$MONGODB_USER \
    -e MONGODB_PASSWORD=$MONGODB_PASSWORD \
    -e MONGODB_DATABASE=$MONGODB_DATABASE

  run mongo_client default -u $MONGODB_USER -p $MONGODB_PASSWORD $MONGODB_DATABASE --eval "printjson(db.createCollection('users'))"
  [[ "$output" =~ '"ok" : 1' ]]

  container_remove default
  container_create_with_host_volumes default -d

  run mongo_client default -u $MONGODB_USER -p $MONGODB_PASSWORD $MONGODB_DATABASE --eval "printjson(db.getCollectionNames())"
  [[ "$output" =~ '"users"' ]]
}

@test "Can't create replicaSet with authentication" {
  run container_create default \
    -e MONGODB_REPLICA_SET_MODE=primary \
    -e MONGODB_PASSWORD=$MONGODB_PASSWORD
  [[ "$output" =~ "Not possible to configure replica set scenario using authentication" ]]
}

@test "Can't create secondary replicaSet node without specifying MONGODB_PRIMARY_HOST" {
  run container_create secondary \
    -e MONGODB_REPLICA_SET_MODE=secondary
  [[ "$output" =~ "provide the --primaryHost property" ]]
}

@test "Can create replicaSet without authentication" {
  container_create default -d \
    -e MONGODB_REPLICA_SET_MODE=primary

  container_create secondary -d \
    $(container_link default $CONTAINER_NAME) \
    -e MONGODB_REPLICA_SET_MODE=secondary \
    -e MONGODB_PRIMARY_HOST=$CONTAINER_NAME

  run mongo_client default $MONGODB_DATABASE --eval "printjson(db.createCollection('users'))"
  [[ "$output" =~ '"ok" : 1' ]]

  sleep 3
  run mongo_client secondary $MONGODB_DATABASE --eval "rs.slaveOk(); printjson(db.getCollectionNames())"
  [[ "$output" =~ '"users"' ]]
}

@test "Secondary node in replicaSet synchronizes with the primary (delayed start)" {
  container_create default -d \
    -e MONGODB_REPLICA_SET_MODE=primary

  run mongo_client default $MONGODB_DATABASE --eval "printjson(db.createCollection('users'))"
  [[ "$output" =~ '"ok" : 1' ]]

  container_create secondary -d \
    $(container_link default $CONTAINER_NAME) \
    -e MONGODB_REPLICA_SET_MODE=secondary \
    -e MONGODB_PRIMARY_HOST=$CONTAINER_NAME

  run mongo_client secondary $MONGODB_DATABASE --eval "rs.slaveOk(); printjson(db.getCollectionNames())"
  [[ "$output" =~ '"users"' ]]
}

@test "replicaSet setup and state is preserved after restart" {
  container_create default -d \
    -e MONGODB_REPLICA_SET_MODE=primary

  run mongo_client default $MONGODB_DATABASE --eval "printjson(db.createCollection('users'))"
  [[ "$output" =~ '"ok" : 1' ]]

  container_create secondary -d \
    $(container_link default $CONTAINER_NAME) \
    -e MONGODB_REPLICA_SET_MODE=secondary \
    -e MONGODB_PRIMARY_HOST=$CONTAINER_NAME

  container_restart secondary
  container_restart default

  run mongo_client default $MONGODB_DATABASE --eval "printjson(db.createCollection('networks'))"
  [[ "$output" =~ '"ok" : 1' ]]

  sleep 3
  run mongo_client secondary $MONGODB_DATABASE --eval "rs.slaveOk(); printjson(db.getCollectionNames())"
  [[ "$output" =~ '"users"' ]]
  [[ "$output" =~ '"networks"' ]]
}

@test "replicaSet setup and state is preserved after deletion" {
  container_create_with_host_volumes default -d \
    -e MONGODB_REPLICA_SET_MODE=primary

  run mongo_client default $MONGODB_DATABASE --eval "printjson(db.createCollection('users'))"
  [[ "$output" =~ '"ok" : 1' ]]

  container_create_with_host_volumes secondary -d \
    $(container_link default $CONTAINER_NAME) \
    -e MONGODB_REPLICA_SET_MODE=secondary \
    -e MONGODB_PRIMARY_HOST=$CONTAINER_NAME

  container_remove secondary
  container_remove default

  container_create_with_host_volumes default -d
  container_create_with_host_volumes secondary -d $(container_link default $CONTAINER_NAME)

  run mongo_client default $MONGODB_DATABASE --eval "printjson(db.createCollection('networks'))"
  [[ "$output" =~ '"ok" : 1' ]]

  sleep 3
  run mongo_client secondary $MONGODB_DATABASE --eval "rs.slaveOk(); printjson(db.getCollectionNames())"
  [[ "$output" =~ '"users"' ]]
  [[ "$output" =~ '"networks"' ]]
}

@test "Slave recovers if master is temporarily offine" {
  container_create_with_host_volumes default -d \
    -e MONGODB_REPLICA_SET_MODE=primary

  run mongo_client default $MONGODB_DATABASE --eval "printjson(db.createCollection('users'))"
  [[ "$output" =~ '"ok" : 1' ]]

  container_create_with_host_volumes secondary -d \
    $(container_link default $CONTAINER_NAME) \
    -e MONGODB_REPLICA_SET_MODE=secondary \
    -e MONGODB_PRIMARY_HOST=$CONTAINER_NAME

  container_restart default

  run mongo_client default $MONGODB_DATABASE --eval "printjson(db.createCollection('networks'))"
  [[ "$output" =~ '"ok" : 1' ]]

  sleep 3
  run mongo_client secondary $MONGODB_DATABASE --eval "rs.slaveOk(); printjson(db.getCollectionNames())"
  [[ "$output" =~ '"users"' ]]
  [[ "$output" =~ '"networks"' ]]
}
