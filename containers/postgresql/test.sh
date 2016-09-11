#!/usr/bin/env bats

POSTGRESQL_DATABASE=test_database
POSTGRESQL_USERNAME=test_user
POSTGRESQL_PASSWORD=test_password
POSTGRESQL_REPLICATION_USER=repl_user
POSTGRESQL_REPLICATION_PASSWORD=repl_password

# source the helper script
APP_NAME=postgresql
VOL_PREFIX=/bitnami/$APP_NAME
VOLUMES=$VOL_PREFIX
SLEEP_TIME=30
container_link_and_run_command_DOCKER_ARGS="-e PGPASSWORD=$POSTGRESQL_PASSWORD"
load tests/docker_helper

# Link to container and execute psql client
# $1 : name of the container to link to
# ${@:2} : arguments for the psql command
psql_client() {
  container_link_and_run_command $1 psql -h $APP_NAME -p 5432 "${@:2}"
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

# cleanup the environment of any leftover containers and volumes before starting the tests
cleanup_environment

@test "Port 5432 exposed and accepting external connections" {
  container_create default -d

  run container_link_and_run_command default pg_isready -h $APP_NAME -p 5432 -t 5
  [[ "$output" =~ "accepting connections" ]]
}

@test "Can create postgres user without password" {
  container_create default -d \
    -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD

  run container_exec default psql -U postgres -Axc "\l"
  [[ "$output" =~ "Name|postgres" ]]
}

@test "postgres user can login remotely without a password" {
  container_create default -d

  run psql_client default -U postgres -w -Axc "\l"
  [[ "$output" =~ "Name|postgres" ]]
}

@test "Can create postgres user with custom password" {
  container_create default -d \
    -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD

  run psql_client default -U postgres -Axc "\l"
  [[ "$output" =~ "Name|postgres" ]]
}

@test "Default postgres user is superuser" {
  container_create default -d \
    -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD

  run psql_client default -U postgres -Axc "SHOW is_superuser;"
  [[ $output =~ "is_superuser|on" ]]
}

@test "Can create custom database" {
  container_create default -d \
    -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD \
    -e POSTGRESQL_DATABASE=$POSTGRESQL_DATABASE

  run psql_client default -U postgres -Axc "\l"
  [[ "$output" =~ "Name|$POSTGRESQL_DATABASE" ]]
}

@test "Can't create custom user without password" {
  run container_create default \
    -e POSTGRESQL_USERNAME=$POSTGRESQL_USERNAME
  [[ "$output" =~ "provide the --password property as well" ]]
}

@test "Can't create custom user without database" {
  run container_create default \
    -e POSTGRESQL_USERNAME=$POSTGRESQL_USERNAME \
    -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD
  [[ "$output" =~ "provide the --database property as well" ]]
}

@test "Can create custom user with password and database" {
  container_create default -d \
    -e POSTGRESQL_USERNAME=$POSTGRESQL_USERNAME \
    -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD \
    -e POSTGRESQL_DATABASE=$POSTGRESQL_DATABASE

  run psql_client default -U $POSTGRESQL_USERNAME $POSTGRESQL_DATABASE -Axc "\l"
  [[ "$output" =~ "Name|$POSTGRESQL_DATABASE" ]]
}

@test "Custom user is not superuser" {
  container_create default -d \
    -e POSTGRESQL_USERNAME=$POSTGRESQL_USERNAME \
    -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD \
    -e POSTGRESQL_DATABASE=$POSTGRESQL_DATABASE

  run psql_client default -U $POSTGRESQL_USERNAME $POSTGRESQL_DATABASE -Axc "SHOW is_superuser;"
  [[ "$output" =~ "is_superuser|off" ]]
}

@test "Data is preserved on container restart" {
  container_create default -d \
    -e POSTGRESQL_USERNAME=$POSTGRESQL_USERNAME \
    -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD \
    -e POSTGRESQL_DATABASE=$POSTGRESQL_DATABASE

  container_restart default

  run psql_client default -U $POSTGRESQL_USERNAME $POSTGRESQL_DATABASE -Axc "\l"
  [[ "$output" =~ "Name|$POSTGRESQL_DATABASE" ]]
}

@test "All the volumes exposed" {
  container_create default -d

  run container_inspect default --format {{.Mounts}}
  [[ "$output" =~ "$VOL_PREFIX" ]]
}

@test "Data gets generated in volume if bind mounted in the host" {
  container_create_with_host_volumes default -d

  run container_exec default ls -la $VOL_PREFIX/data/
  [[ "$output" =~ "PG_VERSION" ]]
  [[ "$output" =~ "base" ]]

  run container_exec default ls -la $VOL_PREFIX/conf/
  [[ "$output" =~ "postgresql.conf" ]]
}

@test "If host mounted, password and settings are preserved after deletion" {
  container_create_with_host_volumes default -d \
    -e POSTGRESQL_USERNAME=$POSTGRESQL_USERNAME \
    -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD \
    -e POSTGRESQL_DATABASE=$POSTGRESQL_DATABASE

  container_remove default
  container_create_with_host_volumes default -d

  run psql_client default -U $POSTGRESQL_USERNAME $POSTGRESQL_DATABASE -Axc "\l"
  [[ "$output" =~ "Name|$POSTGRESQL_DATABASE" ]]
}

@test "Can't create replication user without password" {
  run container_create default \
    -e POSTGRESQL_REPLICATION_USER=$POSTGRESQL_REPLICATION_USER
  [[ "$output" =~ "provide the --replicationPassword property as well" ]]
}

@test "Can't setup replication slave without specifying the master host" {
  run container_create slave0 \
    -e POSTGRESQL_REPLICATION_MODE=slave
  [[ "$output" =~ "provide the --masterHost property as well" ]]
}

@test "Can't setup replication slave without replication user" {
  run container_create slave0 \
    -e POSTGRESQL_REPLICATION_MODE=slave \
    -e POSTGRESQL_MASTER_HOST=master
  [[ "$output" =~ "provide the --replicationUser property as well" ]]
}

@test "Can't setup replication slave without password for replication user" {
  run container_create slave0 \
    -e POSTGRESQL_REPLICATION_MODE=slave \
    -e POSTGRESQL_MASTER_HOST=master \
    -e POSTGRESQL_REPLICATION_USER=$POSTGRESQL_REPLICATION_USER
  [[ "$output" =~ "provide the --replicationPassword property as well" ]]
}

@test "Can setup master/slave replication with minimal configuration" {
  container_create default -d \
    -e POSTGRESQL_REPLICATION_MODE=master \
    -e POSTGRESQL_REPLICATION_USER=$POSTGRESQL_REPLICATION_USER \
    -e POSTGRESQL_REPLICATION_PASSWORD=$POSTGRESQL_REPLICATION_PASSWORD \
    -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD \
    -e POSTGRESQL_DATABASE=$POSTGRESQL_DATABASE

  container_create slave0 -d \
    $(container_link default $CONTAINER_NAME) \
    -e POSTGRESQL_REPLICATION_MODE=slave \
    -e POSTGRESQL_MASTER_HOST=$CONTAINER_NAME \
    -e POSTGRESQL_REPLICATION_USER=$POSTGRESQL_REPLICATION_USER \
    -e POSTGRESQL_REPLICATION_PASSWORD=$POSTGRESQL_REPLICATION_PASSWORD

  psql_client default -U postgres $POSTGRESQL_DATABASE -c \
    "CREATE TABLE users (id serial, name varchar(40) NOT NULL); \
     INSERT INTO users(name) VALUES ('Marko');"

  run psql_client slave0 -U postgres $POSTGRESQL_DATABASE -Axc "SELECT * FROM users;"
  [[ "$output" =~ "name|Marko" ]]
}

@test "Can setup master/slave replication with custom user" {
  container_create default -d \
    -e POSTGRESQL_REPLICATION_MODE=master \
    -e POSTGRESQL_REPLICATION_USER=$POSTGRESQL_REPLICATION_USER \
    -e POSTGRESQL_REPLICATION_PASSWORD=$POSTGRESQL_REPLICATION_PASSWORD \
    -e POSTGRESQL_USERNAME=$POSTGRESQL_USERNAME \
    -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD \
    -e POSTGRESQL_DATABASE=$POSTGRESQL_DATABASE

  container_create slave0 -d \
    $(container_link default $CONTAINER_NAME) \
    -e POSTGRESQL_REPLICATION_MODE=slave \
    -e POSTGRESQL_MASTER_HOST=$CONTAINER_NAME \
    -e POSTGRESQL_REPLICATION_USER=$POSTGRESQL_REPLICATION_USER \
    -e POSTGRESQL_REPLICATION_PASSWORD=$POSTGRESQL_REPLICATION_PASSWORD

  psql_client default -U $POSTGRESQL_USERNAME $POSTGRESQL_DATABASE -c \
    "CREATE TABLE users (id serial, name varchar(40) NOT NULL); \
     INSERT INTO users(name) VALUES ('Marko');"

  run psql_client slave0 -U $POSTGRESQL_USERNAME $POSTGRESQL_DATABASE -Axc "SELECT * FROM users;"
  [[ "$output" =~ "name|Marko" ]]
}

@test "Can setup master/slave replication using a custom master port" {
  container_create default -d -p 5432 \
    -e POSTGRESQL_REPLICATION_MODE=master \
    -e POSTGRESQL_REPLICATION_USER=$POSTGRESQL_REPLICATION_USER \
    -e POSTGRESQL_REPLICATION_PASSWORD=$POSTGRESQL_REPLICATION_PASSWORD \
    -e POSTGRESQL_USERNAME=$POSTGRESQL_USERNAME \
    -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD \
    -e POSTGRESQL_DATABASE=$POSTGRESQL_DATABASE

  MASTER_HOST=$(container_exec default ip route list | grep ^default | awk '{print $3}')
  MASTER_PORT=$(docker port $CONTAINER_NAME-default 5432/tcp | cut -d':' -f2)
  container_create slave0 -d \
    $(container_link default $CONTAINER_NAME) \
    -e POSTGRESQL_REPLICATION_MODE=slave \
    -e POSTGRESQL_MASTER_HOST=$MASTER_HOST \
    -e POSTGRESQL_MASTER_PORT=$MASTER_PORT \
    -e POSTGRESQL_REPLICATION_USER=$POSTGRESQL_REPLICATION_USER \
    -e POSTGRESQL_REPLICATION_PASSWORD=$POSTGRESQL_REPLICATION_PASSWORD

  psql_client default -U $POSTGRESQL_USERNAME $POSTGRESQL_DATABASE -c \
    "CREATE TABLE users (id serial, name varchar(40) NOT NULL); \
     INSERT INTO users(name) VALUES ('Marko');"

  run psql_client slave0 -U $POSTGRESQL_USERNAME $POSTGRESQL_DATABASE -Axc "SELECT * FROM users;"
  [[ "$output" =~ "name|Marko" ]]
}

@test "Slave synchronizes with the master (delayed start)" {
  container_create default -d \
    -e POSTGRESQL_REPLICATION_MODE=master \
    -e POSTGRESQL_REPLICATION_USER=$POSTGRESQL_REPLICATION_USER \
    -e POSTGRESQL_REPLICATION_PASSWORD=$POSTGRESQL_REPLICATION_PASSWORD \
    -e POSTGRESQL_USERNAME=$POSTGRESQL_USERNAME \
    -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD \
    -e POSTGRESQL_DATABASE=$POSTGRESQL_DATABASE

  psql_client default -U $POSTGRESQL_USERNAME $POSTGRESQL_DATABASE -c \
    "CREATE TABLE users (id serial, name varchar(40) NOT NULL); \
     INSERT INTO users(name) VALUES ('Marko');"

  container_create slave0 -d \
    $(container_link default $CONTAINER_NAME) \
    -e POSTGRESQL_REPLICATION_MODE=slave \
    -e POSTGRESQL_MASTER_HOST=$CONTAINER_NAME \
    -e POSTGRESQL_REPLICATION_USER=$POSTGRESQL_REPLICATION_USER \
    -e POSTGRESQL_REPLICATION_PASSWORD=$POSTGRESQL_REPLICATION_PASSWORD

  run psql_client slave0 -U $POSTGRESQL_USERNAME $POSTGRESQL_DATABASE -Axc "SELECT * FROM users;"
  [[ "$output" =~ "name|Marko" ]]
}

@test "Replication slave can be triggered to act as the master" {
  container_create default -d \
    -e POSTGRESQL_REPLICATION_MODE=master \
    -e POSTGRESQL_REPLICATION_USER=$POSTGRESQL_REPLICATION_USER \
    -e POSTGRESQL_REPLICATION_PASSWORD=$POSTGRESQL_REPLICATION_PASSWORD \
    -e POSTGRESQL_USERNAME=$POSTGRESQL_USERNAME \
    -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD \
    -e POSTGRESQL_DATABASE=$POSTGRESQL_DATABASE

  container_create slave0 -d \
    $(container_link default $CONTAINER_NAME) \
    -e POSTGRESQL_REPLICATION_MODE=slave \
    -e POSTGRESQL_MASTER_HOST=$CONTAINER_NAME \
    -e POSTGRESQL_REPLICATION_USER=$POSTGRESQL_REPLICATION_USER \
    -e POSTGRESQL_REPLICATION_PASSWORD=$POSTGRESQL_REPLICATION_PASSWORD

  psql_client default -U $POSTGRESQL_USERNAME $POSTGRESQL_DATABASE -c \
    "CREATE TABLE users (id serial, name varchar(40) NOT NULL); \
     INSERT INTO users(name) VALUES ('Marko');"

  # stop and remove master
  container_remove default

  # trigger slave to become master
  container_exec slave0 touch /tmp/postgresql.trigger.5432
  sleep $SLEEP_TIME

  # create new slave that configures slave0 as the master
  container_create default -d \
    $(container_link slave0 $CONTAINER_NAME) \
    -e POSTGRESQL_REPLICATION_MODE=slave \
    -e POSTGRESQL_MASTER_HOST=$CONTAINER_NAME \
    -e POSTGRESQL_REPLICATION_USER=$POSTGRESQL_REPLICATION_USER \
    -e POSTGRESQL_REPLICATION_PASSWORD=$POSTGRESQL_REPLICATION_PASSWORD

  psql_client slave0 -U $POSTGRESQL_USERNAME $POSTGRESQL_DATABASE -c "INSERT INTO users(name) VALUES ('Polo');"

  # verify that all past and new data is replicated on new slave
  run psql_client default -U $POSTGRESQL_USERNAME $POSTGRESQL_DATABASE -Axc "SELECT * FROM users;"
  [[ "$output" =~ "name|Marko" ]]
  [[ "$output" =~ "name|Polo" ]]
}

@test "Replication setup and state is preserved after restart" {
  container_create default -d \
    -e POSTGRESQL_REPLICATION_MODE=master \
    -e POSTGRESQL_REPLICATION_USER=$POSTGRESQL_REPLICATION_USER \
    -e POSTGRESQL_REPLICATION_PASSWORD=$POSTGRESQL_REPLICATION_PASSWORD \
    -e POSTGRESQL_USERNAME=$POSTGRESQL_USERNAME \
    -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD \
    -e POSTGRESQL_DATABASE=$POSTGRESQL_DATABASE

  psql_client default -U $POSTGRESQL_USERNAME $POSTGRESQL_DATABASE -c \
    "CREATE TABLE users (id serial, name varchar(40) NOT NULL); \
     INSERT INTO users(name) VALUES ('Marko');"

  container_create slave0 -d \
    $(container_link default $CONTAINER_NAME) \
    -e POSTGRESQL_REPLICATION_MODE=slave \
    -e POSTGRESQL_MASTER_HOST=$CONTAINER_NAME \
    -e POSTGRESQL_REPLICATION_USER=$POSTGRESQL_REPLICATION_USER \
    -e POSTGRESQL_REPLICATION_PASSWORD=$POSTGRESQL_REPLICATION_PASSWORD

  container_restart default
  container_restart slave0

  psql_client default -U $POSTGRESQL_USERNAME $POSTGRESQL_DATABASE -c "INSERT INTO users(name) VALUES ('Polo');"

  run psql_client slave0 -U $POSTGRESQL_USERNAME $POSTGRESQL_DATABASE -Axc "SELECT * FROM users;"
  [[ "$output" =~ "name|Marko" ]]
  [[ "$output" =~ "name|Polo" ]]
}

@test "Replication setup and state is preserved after deletion" {
  container_create_with_host_volumes default -d \
    -e POSTGRESQL_REPLICATION_MODE=master \
    -e POSTGRESQL_REPLICATION_USER=$POSTGRESQL_REPLICATION_USER \
    -e POSTGRESQL_REPLICATION_PASSWORD=$POSTGRESQL_REPLICATION_PASSWORD \
    -e POSTGRESQL_USERNAME=$POSTGRESQL_USERNAME \
    -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD \
    -e POSTGRESQL_DATABASE=$POSTGRESQL_DATABASE

  psql_client default -U $POSTGRESQL_USERNAME $POSTGRESQL_DATABASE -c \
    "CREATE TABLE users (id serial, name varchar(40) NOT NULL); \
     INSERT INTO users(name) VALUES ('Marko');"

  container_create_with_host_volumes slave0 -d \
    $(container_link default $CONTAINER_NAME) \
    -e POSTGRESQL_REPLICATION_MODE=slave \
    -e POSTGRESQL_MASTER_HOST=$CONTAINER_NAME \
    -e POSTGRESQL_REPLICATION_USER=$POSTGRESQL_REPLICATION_USER \
    -e POSTGRESQL_REPLICATION_PASSWORD=$POSTGRESQL_REPLICATION_PASSWORD

  container_remove default
  container_remove slave0

  container_create_with_host_volumes default -d
  container_create_with_host_volumes slave0 -d $(container_link default $CONTAINER_NAME)

  psql_client default -U $POSTGRESQL_USERNAME $POSTGRESQL_DATABASE -c "INSERT INTO users(name) VALUES ('Polo');"

  run psql_client slave0 -U $POSTGRESQL_USERNAME $POSTGRESQL_DATABASE -Axc "SELECT * FROM users;"
  [[ "$output" =~ "name|Marko" ]]
  [[ "$output" =~ "name|Polo" ]]
}

@test "Slave recovers if master is temporarily offine" {
  container_create_with_host_volumes default -d \
    -e POSTGRESQL_REPLICATION_MODE=master \
    -e POSTGRESQL_REPLICATION_USER=$POSTGRESQL_REPLICATION_USER \
    -e POSTGRESQL_REPLICATION_PASSWORD=$POSTGRESQL_REPLICATION_PASSWORD \
    -e POSTGRESQL_USERNAME=$POSTGRESQL_USERNAME \
    -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD \
    -e POSTGRESQL_DATABASE=$POSTGRESQL_DATABASE

  psql_client default -U $POSTGRESQL_USERNAME $POSTGRESQL_DATABASE -c \
    "CREATE TABLE users (id serial, name varchar(40) NOT NULL); \
     INSERT INTO users(name) VALUES ('Marko');"

  container_create_with_host_volumes slave0 -d \
    $(container_link default $CONTAINER_NAME) \
    -e POSTGRESQL_REPLICATION_MODE=slave \
    -e POSTGRESQL_MASTER_HOST=$CONTAINER_NAME \
    -e POSTGRESQL_REPLICATION_USER=$POSTGRESQL_REPLICATION_USER \
    -e POSTGRESQL_REPLICATION_PASSWORD=$POSTGRESQL_REPLICATION_PASSWORD

  container_restart default

  psql_client default -U $POSTGRESQL_USERNAME $POSTGRESQL_DATABASE -c "INSERT INTO users(name) VALUES ('Polo');"

  run psql_client slave0 -U $POSTGRESQL_USERNAME $POSTGRESQL_DATABASE -Axc "SELECT * FROM users;"
  [[ "$output" =~ "name|Marko" ]]
  [[ "$output" =~ "name|Polo" ]]
}
