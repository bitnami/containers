#!/usr/bin/env bats

REDIS_PASSWORD=test_password123

# source the helper script
APP_NAME=redis
SLEEP_TIME=5
load tests/docker_helper

# Link to container and execute redis client
# $1 : name of the container to link to
# ${@:2} : arguments for the redis-cli command
redis_client() {
  container_link_and_run_command $1 redis-cli -h $APP_NAME "${@:2}"
}

# Cleans up all running/stopped containers and host mounted volumes
cleanup_environment() {
  container_remove_full default
  container_remove_full master
  container_remove_full slave0
}

# Teardown called at the end of each test
teardown() {
  cleanup_environment
}

# cleanup the environment before starting the tests
cleanup_environment

@test "Auth if no password provided" {
  container_create default -d
  run redis_client default ping
  [[ "$output" =~ "PONG" ]]
}

@test "Auth if password provided" {
  container_create default -d \
    -e REDIS_PASSWORD=$REDIS_PASSWORD

  run redis_client default ping
  [[ "$output" =~ "NOAUTH Authentication required" ]]

  run redis_client default -a $REDIS_PASSWORD ping
  [[ "$output" =~ "PONG" ]]
}

@test "Password settings are preserved after restart" {
  container_create default -d \
    -e REDIS_PASSWORD=$REDIS_PASSWORD

  run container_logs default
  [[ "$output" =~ "Credentials for redis:" ]]
  [[ "$output" =~ "Password: $REDIS_PASSWORD" ]]

  container_restart default

  run container_logs default
  [[ "$output" =~ "The credentials were set on first boot." ]]

  run redis_client default -a $REDIS_PASSWORD ping
  [[ "$output" =~ "PONG" ]]
}

@test "All the volumes exposed" {
  container_create default -d

  run container_inspect default --format {{.Mounts}}
  [[ "$output" =~ "$VOL_PREFIX/logs" ]]
  [[ "$output" =~ "$VOL_PREFIX/conf" ]]
  [[ "$output" =~ "$VOL_PREFIX/data" ]]
}

@test "Data gets generated in conf, data and logs if bind mounted in the host" {
  container_create_with_host_volumes default -d

  # restart container to force redis-server to generate `dump.rdb`
  container_restart default

  # files expected in conf volume
  run container_exec default ls -la $VOL_PREFIX/conf/
  [[ "$output" =~ "redis.conf" ]]

  # files expected in data volume
  run container_exec default ls -la $VOL_PREFIX/data/
  [[ "$output" =~ "dump.rdb" ]]

  # files expected in logs volume
  run container_exec default ls -la $VOL_PREFIX/logs/
  [[ "$output" =~ "redis-server.log" ]]
}

@test "If host mounted, configuration and data persist" {
  container_create_with_host_volumes default -d \
    -e REDIS_PASSWORD=$REDIS_PASSWORD

  run redis_client default -a $REDIS_PASSWORD set winter 'is coming'
  [[ "$output" =~ "OK" ]]

  # remove container
  container_remove default

  # recreate container without specifying any env parameters
  container_create_with_host_volumes default -d

  # check if record exists
  run redis_client default -a $REDIS_PASSWORD get winter
  [[ "$output" =~ "is coming" ]]
}

@test "Can't setup replication slave without master host" {
  # create replication slave without specifying REDIS_MASTER_HOST
  run container_create slave0 \
    -e REDIS_REPLICATION_MODE=slave
  [[ "$output" =~ "you need to provide the REDIS_MASTER_HOST" ]]
}

@test "Master data is replicated on slave" {
  container_create master -d \
    -e REDIS_REPLICATION_MODE=master

  container_create slave0 -d \
    $(container_link master $CONTAINER_NAME) \
    -e REDIS_MASTER_HOST=$CONTAINER_NAME \
    -e REDIS_MASTER_PORT=6379 \
    -e REDIS_REPLICATION_MODE=slave

  # create record in master
  run redis_client master set winter 'is coming'
  [[ "$output" =~ "OK" ]]

  # verify that record is replicated on slave0
  run redis_client slave0 get winter
  [[ "$output" =~ "is coming" ]]
}

@test "Master data is replicated on slave with authentication enabled" {
  container_create master -d \
    -e REDIS_PASSWORD=$REDIS_PASSWORD \
    -e REDIS_REPLICATION_MODE=master

  container_create slave0 -d \
    $(container_link master $CONTAINER_NAME) \
    -e REDIS_MASTER_HOST=$CONTAINER_NAME \
    -e REDIS_MASTER_PORT=6379 \
    -e REDIS_MASTER_PASSWORD=$REDIS_PASSWORD \
    -e REDIS_PASSWORD=$REDIS_PASSWORD \
    -e REDIS_REPLICATION_MODE=slave

  # create record in master
  run redis_client master -a $REDIS_PASSWORD set winter 'is coming'
  [[ "$output" =~ "OK" ]]

  # verify that record is replicated on slave0
  run redis_client slave0 -a $REDIS_PASSWORD get winter
  [[ "$output" =~ "is coming" ]]
}

@test "Replication slave can fetch replication parameters from link alias \"master\"" {
  container_create master -d \
    -e REDIS_PASSWORD=$REDIS_PASSWORD \
    -e REDIS_REPLICATION_MODE=master

  container_create slave0 -d \
    $(container_link master master) \
    -e REDIS_PASSWORD=$REDIS_PASSWORD \
    -e REDIS_REPLICATION_MODE=slave

  # create record in master
  run redis_client master -a $REDIS_PASSWORD set winter 'is coming'
  [[ "$output" =~ "OK" ]]

  # verify that record is replicated on slave0
  run redis_client slave0 -a $REDIS_PASSWORD get winter
  [[ "$output" =~ "is coming" ]]
}

@test "Slave synchronizes with the master (delayed start)" {
  container_create master -d \
    -e REDIS_PASSWORD=$REDIS_PASSWORD \
    -e REDIS_REPLICATION_MODE=master

  # create record in master
  run redis_client master -a $REDIS_PASSWORD set winter 'is coming'
  [[ "$output" =~ "OK" ]]

  container_create slave0 -d \
    $(container_link master $CONTAINER_NAME) \
    -e REDIS_MASTER_HOST=$CONTAINER_NAME \
    -e REDIS_MASTER_PORT=6379 \
    -e REDIS_MASTER_PASSWORD=$REDIS_PASSWORD \
    -e REDIS_PASSWORD=$REDIS_PASSWORD \
    -e REDIS_REPLICATION_MODE=slave

  # verify that record is replicated on slave0
  run redis_client slave0 -a $REDIS_PASSWORD get winter
  [[ "$output" =~ "is coming" ]]
}

@test "Replication status is preserved after deletion" {
  container_create_with_host_volumes master -d \
    -e REDIS_PASSWORD=$REDIS_PASSWORD \
    -e REDIS_REPLICATION_MODE=master

  # create record in master
  run redis_client master -a $REDIS_PASSWORD set winter 'is coming'
  [[ "$output" =~ "OK" ]]

  container_create_with_host_volumes slave0 -d \
    $(container_link master $CONTAINER_NAME) \
    -e REDIS_MASTER_HOST=$CONTAINER_NAME \
    -e REDIS_MASTER_PORT=6379 \
    -e REDIS_MASTER_PASSWORD=$REDIS_PASSWORD \
    -e REDIS_PASSWORD=$REDIS_PASSWORD \
    -e REDIS_REPLICATION_MODE=slave

  # stop and remove master and slave0 containers
  container_remove slave0
  container_remove master

  # start master and slave0 containers with existing host volumes and no additional env arguments
  container_create_with_host_volumes master -d
  container_create_with_host_volumes slave0 -d $(container_link master $CONTAINER_NAME)

  # insert new record into the master
  run redis_client master -a $REDIS_PASSWORD set night 'is dark and full of terrors'
  [[ "$output" =~ "OK" ]]

  # verify that all previous and new data is replicated on slave0
  run redis_client slave0 -a $REDIS_PASSWORD get winter
  [[ "$output" =~ "is coming" ]]

  run redis_client slave0 -a $REDIS_PASSWORD get night
  [[ "$output" =~ "is dark and full of terrors" ]]
}
