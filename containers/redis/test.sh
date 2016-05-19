#!/usr/bin/env bats

REDIS_PASSWORD=test_password123

# source the helper script
APP_NAME=redis
VOL_PREFIX=/bitnami/$APP_NAME
VOLUMES=$VOL_PREFIX
SLEEP_TIME=30
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
  container_remove_full slave0
}

# Teardown called at the end of each test
teardown() {
  cleanup_environment
}

# cleanup the environment before starting the tests
cleanup_environment

@test "Port 6379 exposed and accepting external connections" {
  container_create default -d

  run redis_client default ping
  [[ "$output" =~ "PONG" ]]
}

@test "Authentication is enabled if password is specified" {
  container_create default -d \
    -e REDIS_PASSWORD=$REDIS_PASSWORD

  run redis_client default ping
  [[ "$output" =~ "Authentication required" ]]

  run redis_client default -a $REDIS_PASSWORD ping
  [[ "$output" =~ "PONG" ]]
}

@test "All the volumes exposed" {
  container_create default -d

  run container_inspect default --format {{.Mounts}}
  [[ "$output" =~ "$VOL_PREFIX" ]]
}

@test "Data gets generated in the volume if bind mounted" {
  container_create_with_host_volumes default -d

  # restart container to force redis-server to generate `dump.rdb`
  container_restart default

  run container_exec default ls -la $VOL_PREFIX/data/
  [[ "$output" =~ "dump.rdb" ]]

  run container_exec default ls -la $VOL_PREFIX/conf/
  [[ "$output" =~ "redis.conf" ]]
}

@test "Password settings are preserved after restart" {
  container_create default -d \
    -e REDIS_PASSWORD=$REDIS_PASSWORD

  container_restart default

  run redis_client default -a $REDIS_PASSWORD ping
  [[ "$output" =~ "PONG" ]]
}

@test "If host mounted, configuration and data persist" {
  container_create_with_host_volumes default -d \
    -e REDIS_PASSWORD=$REDIS_PASSWORD

  run redis_client default -a $REDIS_PASSWORD set winter 'is coming'
  [[ "$output" =~ "OK" ]]

  container_remove default
  container_create_with_host_volumes default -d

  run redis_client default -a $REDIS_PASSWORD get winter
  [[ "$output" =~ "is coming" ]]
}

@test "Configuration changes are preserved after deletion" {
  container_create_with_host_volumes default -d

  # modify redis.conf
  container_exec default sed -i 's|^[#]*[ ]*appendonly \+.*|appendonly yes|' $VOL_PREFIX/conf/redis.conf
  container_exec default sed -i 's|^[#]*[ ]*maxclients \+.*|maxclients 1024|' $VOL_PREFIX/conf/redis.conf

  # stop and remove container
  container_remove default

  # relaunch container with host volumes
  container_create_with_host_volumes default -d

  run container_exec default cat $VOL_PREFIX/conf/redis.conf
  [[ "$output" =~ "appendonly yes" ]]
  [[ "$output" =~ "maxclients 1024" ]]
}

@test "Can't setup replication slave without master host" {
  run container_create slave0 \
    -e REDIS_REPLICATION_MODE=slave
  [[ "$output" =~ "provide the --masterHost property as well" ]]
}

@test "Can setup master/slave replication without authentication" {
  container_create default -d \
    -e REDIS_REPLICATION_MODE=master

  container_create slave0 -d \
    $(container_link default $CONTAINER_NAME) \
    -e REDIS_REPLICATION_MODE=slave \
    -e REDIS_MASTER_HOST=$CONTAINER_NAME

  run redis_client default set winter 'is coming'
  [[ "$output" =~ "OK" ]]

  run redis_client slave0 get winter
  [[ "$output" =~ "is coming" ]]
}

@test "Can setup master/slave replication with authentication" {
  container_create default -d \
    -e REDIS_REPLICATION_MODE=master \
    -e REDIS_PASSWORD=$REDIS_PASSWORD

  container_create slave0 -d \
    $(container_link default $CONTAINER_NAME) \
    -e REDIS_REPLICATION_MODE=slave \
    -e REDIS_MASTER_HOST=$CONTAINER_NAME \
    -e REDIS_MASTER_PASSWORD=$REDIS_PASSWORD

  run redis_client default -a $REDIS_PASSWORD set winter 'is coming'
  [[ "$output" =~ "OK" ]]

  run redis_client slave0 get winter
  [[ "$output" =~ "is coming" ]]
}

@test "Can setup master/slave replication with authentication and a slave password" {
  container_create default -d \
    -e REDIS_REPLICATION_MODE=master \
    -e REDIS_PASSWORD=$REDIS_PASSWORD

  container_create slave0 -d \
    $(container_link default $CONTAINER_NAME) \
    -e REDIS_REPLICATION_MODE=slave \
    -e REDIS_MASTER_HOST=$CONTAINER_NAME \
    -e REDIS_MASTER_PASSWORD=$REDIS_PASSWORD \
    -e REDIS_PASSWORD=$REDIS_PASSWORD

  run redis_client default -a $REDIS_PASSWORD set winter 'is coming'
  [[ "$output" =~ "OK" ]]

  run redis_client slave0 -a $REDIS_PASSWORD get winter
  [[ "$output" =~ "is coming" ]]
}

@test "Slave synchronizes with the master (delayed start)" {
  container_create default -d \
    -e REDIS_REPLICATION_MODE=master \
    -e REDIS_PASSWORD=$REDIS_PASSWORD

  run redis_client default -a $REDIS_PASSWORD set winter 'is coming'
  [[ "$output" =~ "OK" ]]

  container_create slave0 -d \
    $(container_link default $CONTAINER_NAME) \
    -e REDIS_REPLICATION_MODE=slave \
    -e REDIS_MASTER_HOST=$CONTAINER_NAME \
    -e REDIS_MASTER_PASSWORD=$REDIS_PASSWORD \
    -e REDIS_PASSWORD=$REDIS_PASSWORD \

  run redis_client slave0 -a $REDIS_PASSWORD get winter
  [[ "$output" =~ "is coming" ]]
}

@test "Replication setup and state is preserved after restart" {
  container_create_with_host_volumes default -d \
    -e REDIS_REPLICATION_MODE=master \
    -e REDIS_PASSWORD=$REDIS_PASSWORD

  run redis_client default -a $REDIS_PASSWORD set winter 'is coming'
  [[ "$output" =~ "OK" ]]

  container_create_with_host_volumes slave0 -d \
    $(container_link default $CONTAINER_NAME) \
    -e REDIS_REPLICATION_MODE=slave \
    -e REDIS_MASTER_HOST=$CONTAINER_NAME \
    -e REDIS_MASTER_PASSWORD=$REDIS_PASSWORD \
    -e REDIS_PASSWORD=$REDIS_PASSWORD

  container_restart slave0
  container_restart default

  run redis_client default -a $REDIS_PASSWORD set night 'is dark and full of terrors'
  [[ "$output" =~ "OK" ]]

  run redis_client slave0 -a $REDIS_PASSWORD get winter
  [[ "$output" =~ "is coming" ]]

  run redis_client slave0 -a $REDIS_PASSWORD get night
  [[ "$output" =~ "is dark and full of terrors" ]]
}

@test "Replication setup and state is preserved after deletion" {
  container_create_with_host_volumes default -d \
    -e REDIS_REPLICATION_MODE=master \
    -e REDIS_PASSWORD=$REDIS_PASSWORD

  run redis_client default -a $REDIS_PASSWORD set winter 'is coming'
  [[ "$output" =~ "OK" ]]

  container_create_with_host_volumes slave0 -d \
    $(container_link default $CONTAINER_NAME) \
    -e REDIS_REPLICATION_MODE=slave \
    -e REDIS_MASTER_HOST=$CONTAINER_NAME \
    -e REDIS_MASTER_PASSWORD=$REDIS_PASSWORD \
    -e REDIS_PASSWORD=$REDIS_PASSWORD

  container_remove slave0
  container_remove default

  container_create_with_host_volumes default -d
  container_create_with_host_volumes slave0 -d $(container_link default $CONTAINER_NAME)

  run redis_client default -a $REDIS_PASSWORD set night 'is dark and full of terrors'
  [[ "$output" =~ "OK" ]]

  run redis_client slave0 -a $REDIS_PASSWORD get winter
  [[ "$output" =~ "is coming" ]]

  run redis_client slave0 -a $REDIS_PASSWORD get night
  [[ "$output" =~ "is dark and full of terrors" ]]
}

@test "Slave recovers if master is temporarily offine" {
  container_create_with_host_volumes default -d \
    -e REDIS_REPLICATION_MODE=master \
    -e REDIS_PASSWORD=$REDIS_PASSWORD

  run redis_client default -a $REDIS_PASSWORD set winter 'is coming'
  [[ "$output" =~ "OK" ]]

  container_create slave0 -d \
    $(container_link default $CONTAINER_NAME) \
    -e REDIS_REPLICATION_MODE=slave \
    -e REDIS_MASTER_HOST=$CONTAINER_NAME \
    -e REDIS_MASTER_PASSWORD=$REDIS_PASSWORD \
    -e REDIS_PASSWORD=$REDIS_PASSWORD

  container_restart default

  run redis_client default -a $REDIS_PASSWORD set dead 'may never die'
  [[ "$output" =~ "OK" ]]

  run redis_client default -a $REDIS_PASSWORD get winter
  [[ "$output" =~ "is coming" ]]

  run redis_client default -a $REDIS_PASSWORD get dead
  [[ "$output" =~ "may never die" ]]
}

@test "Slave can be triggered to act as the master" {
  container_create default -d \
    -e REDIS_REPLICATION_MODE=master \
    -e REDIS_PASSWORD=$REDIS_PASSWORD

  container_create slave0 -d \
    $(container_link default $CONTAINER_NAME) \
    -e REDIS_REPLICATION_MODE=slave \
    -e REDIS_MASTER_HOST=$CONTAINER_NAME \
    -e REDIS_MASTER_PASSWORD=$REDIS_PASSWORD \
    -e REDIS_PASSWORD=$REDIS_PASSWORD

  # create record in master
  run redis_client default -a $REDIS_PASSWORD set winter 'is coming'
  [[ "$output" =~ "OK" ]]

  # stop and remove master
  container_remove default

  # convert slave to become master
  run redis_client slave0 -a $REDIS_PASSWORD SLAVEOF NO ONE
  [[ "$output" =~ "OK" ]]

  # create container that configures slave as the master
  container_create default -d \
    $(container_link slave0 $CONTAINER_NAME) \
    -e REDIS_REPLICATION_MODE=slave \
    -e REDIS_MASTER_HOST=$CONTAINER_NAME \
    -e REDIS_MASTER_PASSWORD=$REDIS_PASSWORD \
    -e REDIS_PASSWORD=$REDIS_PASSWORD

  # insert new record into slave, since it is now the master it should allow writes
  run redis_client slave0 -a $REDIS_PASSWORD set night 'is dark and full of terrors'
  [[ "$output" =~ "OK" ]]

  # verify that all past and new data is replicated on new slave
  run redis_client default -a $REDIS_PASSWORD get winter
  [[ "$output" =~ "is coming" ]]

  run redis_client default -a $REDIS_PASSWORD get night
  [[ "$output" =~ "is dark and full of terrors" ]]
}
