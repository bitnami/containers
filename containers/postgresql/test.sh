#!/usr/bin/env bats

POSTGRESQL_DATABASE=test_database
POSTGRESQL_ROOT_USER=postgres
POSTGRESQL_USER=test_user
POSTGRESQL_PASSWORD=test_password
POSTGRESQL_REPLICATION_USER=repl_user
POSTGRESQL_REPLICATION_PASSWORD=repl_password

# source the helper script
APP_NAME=postgresql
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
  container_remove_full slave1
  container_remove_full slave0
  container_remove_full master
  container_remove_full standalone
}

# Teardown called at the end of each test
teardown() {
  cleanup_environment
}

# cleanup the environment of any leftover containers and volumes before starting the tests
cleanup_environment

@test "Port 5432 exposed and accepting external connections" {
  container_create standalone -d \
    -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD

  # check if postgresql server is accepting connections
  run container_link_and_run_command standalone pg_isready -h $APP_NAME -p 5432 -t 5
  [[ "$output" =~ "accepting connections" ]]
}

@test "User postgres created with password" {
  container_create standalone -d \
    -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD

  # auth as POSTGRESQL_ROOT_USER user and list all databases
  run psql_client standalone -U $POSTGRESQL_ROOT_USER -Axc "\l"
  [[ "$output" =~ "Name|postgres" ]]
}

@test "User postgres is superuser" {
  container_create standalone -d \
    -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD

  # check if POSTGRESQL_ROOT_USER user is a superuser
  run psql_client standalone -U $POSTGRESQL_ROOT_USER -Axc "SHOW is_superuser;"
  [[ $output =~ "is_superuser|on" ]]
}

@test "Custom database created" {
  container_create standalone -d \
    -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD \
    -e POSTGRESQL_DATABASE=$POSTGRESQL_DATABASE

  # auth as POSTGRESQL_ROOT_USER user and list all databases
  run psql_client standalone -U $POSTGRESQL_ROOT_USER -Axc "\l"
  [[ "$output" =~ "Name|$POSTGRESQL_DATABASE" ]]
}

@test "Can't create a custom user without a password" {
  # create container without specifying POSTGRESQL_PASSWORD
  run container_create standalone \
    -e POSTGRESQL_USER=$POSTGRESQL_USER
  [[ "$output" =~ "you need to provide the POSTGRESQL_PASSWORD" ]]
}

@test "Can't create a custom user without database" {
  # create container without specifying POSTGRESQL_DATABASE
  run container_create standalone \
    -e POSTGRESQL_USER=$POSTGRESQL_USER \
    -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD
  [[ "$output" =~ "you need to provide the POSTGRESQL_DATABASE" ]]
}

@test "Create custom user and database with password" {
  container_create standalone -d \
    -e POSTGRESQL_USER=$POSTGRESQL_USER \
    -e POSTGRESQL_DATABASE=$POSTGRESQL_DATABASE \
    -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD

  # auth as POSTGRESQL_ROOT_USER user and list all databases, should fail
  run psql_client standalone -U $POSTGRESQL_ROOT_USER -Axc "\l"
  [[ "$output" =~ "authentication failed for user" ]]

  # auth as POSTGRESQL_USER and list all databases
  run psql_client standalone -U $POSTGRESQL_USER $POSTGRESQL_DATABASE -Axc "\l"
  [[ "$output" =~ "Name|$POSTGRESQL_DATABASE" ]]
}

@test "Can't create a replication user without a password" {
  # create replication user without specifying POSTGRESQL_REPLICATION_PASSWORD
  run container_create standalone \
    -e POSTGRESQL_REPLICATION_USER=$POSTGRESQL_REPLICATION_USER
  [[ "$output" =~ "you need to provide the POSTGRESQL_REPLICATION_PASSWORD" ]]
}

@test "Can create a replication user with password" {
  container_create standalone -d \
    -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD \
    -e POSTGRESQL_REPLICATION_USER=$POSTGRESQL_REPLICATION_USER \
    -e POSTGRESQL_REPLICATION_PASSWORD=$POSTGRESQL_REPLICATION_PASSWORD

  run psql_client standalone -U $POSTGRESQL_ROOT_USER -Axc "SELECT usename FROM pg_catalog.pg_user WHERE usename = '$POSTGRESQL_REPLICATION_USER' AND userepl = 'true';"
  [[ "$output" =~ "usename|$POSTGRESQL_REPLICATION_USER" ]]
}

@test "User and password settings are preserved after restart" {
  container_create standalone -d \
    -e POSTGRESQL_USER=$POSTGRESQL_USER \
    -e POSTGRESQL_DATABASE=$POSTGRESQL_DATABASE \
    -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD

  # restart container
  container_restart standalone

  # get container logs
  run container_logs standalone
  [[ "$output" =~ "The credentials were set on first boot." ]]

  # auth as POSTGRESQL_USER and list all databases
  run psql_client standalone -U $POSTGRESQL_USER $POSTGRESQL_DATABASE -Axc "\l"
  [[ "$output" =~ "Name|$POSTGRESQL_DATABASE" ]]
}

@test "All the volumes exposed" {
  container_create standalone -d

  # get container introspection details and check if volumes are exposed
  run container_inspect standalone --format {{.Mounts}}
  [[ "$output" =~ "$VOL_PREFIX/data" ]]
  [[ "$output" =~ "$VOL_PREFIX/conf" ]]
  [[ "$output" =~ "$VOL_PREFIX/logs" ]]
}

@test "Data gets generated in conf, data and logs if bind mounted in the host" {
  container_create_with_host_volumes standalone -d \
    -e POSTGRESQL_USER=$POSTGRESQL_USER \
    -e POSTGRESQL_DATABASE=$POSTGRESQL_DATABASE \
    -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD

  # files expected in conf volume (subset)
  run container_exec standalone ls -la $VOL_PREFIX/conf/
  [[ "$output" =~ "postgresql.conf" ]]
  [[ "$output" =~ "pg_hba.conf" ]]

  # files expected in data volume (subset)
  run container_exec standalone ls -la $VOL_PREFIX/data/
  [[ "$output" =~ "PG_VERSION" ]]
  [[ "$output" =~ "base" ]]

  # files expected in logs volume
  run container_exec standalone ls -la $VOL_PREFIX/logs/
  [[ "$output" =~ "postgresql.log" ]]
}

@test "If host mounted, password and settings are preserved after deletion" {
  container_create_with_host_volumes standalone -d \
    -e POSTGRESQL_USER=$POSTGRESQL_USER \
    -e POSTGRESQL_DATABASE=$POSTGRESQL_DATABASE \
    -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD

  # stop and remove container
  container_remove standalone

  # recreate container without specifying any env parameters
  container_create_with_host_volumes standalone -d

  # auth as POSTGRESQL_USER and list all databases
  run psql_client standalone -U $POSTGRESQL_USER $POSTGRESQL_DATABASE -Axc "\l"
  [[ "$output" =~ "Name|$POSTGRESQL_DATABASE" ]]
}

@test "Configuration changes are preserved after deletion" {
  container_create_with_host_volumes standalone -d

  # modify postgresql.conf
  container_exec standalone sed -i 's|^[#]*[ ]*log_connections[ ]*=.*|log_connections=on|' $VOL_PREFIX/conf/postgresql.conf
  container_exec standalone sed -i 's|^[#]*[ ]*log_disconnections[ ]*=.*|log_disconnections=on|' $VOL_PREFIX/conf/postgresql.conf

  # stop and remove container
  container_remove standalone

  # relaunch container with host volumes
  container_create_with_host_volumes standalone -d

  run container_exec standalone cat $VOL_PREFIX/conf/postgresql.conf
  [[ "$output" =~ "log_connections=on" ]]
  [[ "$output" =~ "log_disconnections=on" ]]
}

@test "Can't setup replication slave without master host" {
  # create replication slave without specifying POSTGRESQL_MASTER_HOST
  run container_create slave0 \
    -e POSTGRESQL_REPLICATION_MODE=slave
  [[ "$output" =~ "you need to provide the POSTGRESQL_MASTER_HOST" ]]
}

@test "Can't setup replication slave without replication user" {
  # create replication slave without specifying POSTGRESQL_REPLICATION_USER
  run container_create slave0 \
    -e POSTGRESQL_REPLICATION_MODE=slave \
    -e POSTGRESQL_MASTER_HOST=master
  [[ "$output" =~ "you need to provide the POSTGRESQL_REPLICATION_USER" ]]
}

@test "Can't setup replication slave without replication password" {
  # create replication slave without specifying POSTGRESQL_REPLICATION_PASSWORD
  run container_create slave0 \
    -e POSTGRESQL_REPLICATION_MODE=slave \
    -e POSTGRESQL_MASTER_HOST=master \
    -e POSTGRESQL_REPLICATION_USER=$POSTGRESQL_REPLICATION_USER
  [[ "$output" =~ "you need to provide the POSTGRESQL_REPLICATION_PASSWORD" ]]
}

@test "Master database is replicated on slave" {
  container_create master -d \
    -e POSTGRESQL_USER=$POSTGRESQL_USER \
    -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD \
    -e POSTGRESQL_DATABASE=$POSTGRESQL_DATABASE \
    -e POSTGRESQL_REPLICATION_MODE=master \
    -e POSTGRESQL_REPLICATION_USER=$POSTGRESQL_REPLICATION_USER \
    -e POSTGRESQL_REPLICATION_PASSWORD=$POSTGRESQL_REPLICATION_PASSWORD

  container_create slave0 -d \
    $(container_link master $CONTAINER_NAME) \
    -e POSTGRESQL_MASTER_HOST=$CONTAINER_NAME \
    -e POSTGRESQL_MASTER_PORT=5432 \
    -e POSTGRESQL_REPLICATION_MODE=slave \
    -e POSTGRESQL_REPLICATION_USER=$POSTGRESQL_REPLICATION_USER \
    -e POSTGRESQL_REPLICATION_PASSWORD=$POSTGRESQL_REPLICATION_PASSWORD

  # create users table on master and insert a record
  psql_client master -U $POSTGRESQL_USER $POSTGRESQL_DATABASE -c \
    "CREATE TABLE users (id serial, name varchar(40) NOT NULL); \
     INSERT INTO users(name) VALUES ('Marko');"

  # verify that record is replicated on slave0
  run psql_client slave0 -U $POSTGRESQL_USER $POSTGRESQL_DATABASE -Axc "SELECT * FROM users;"
  [[ "$output" =~ "name|Marko" ]]
}

@test "Replication slave can fetch replication parameters from link alias \"master\"" {
  container_create master -d \
    -e POSTGRESQL_USER=$POSTGRESQL_USER \
    -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD \
    -e POSTGRESQL_DATABASE=$POSTGRESQL_DATABASE \
    -e POSTGRESQL_REPLICATION_MODE=master \
    -e POSTGRESQL_REPLICATION_USER=$POSTGRESQL_REPLICATION_USER \
    -e POSTGRESQL_REPLICATION_PASSWORD=$POSTGRESQL_REPLICATION_PASSWORD

  # create replication slave0 linked to master with alias named master
  container_create slave0 -d \
    $(container_link master master) \
    -e POSTGRESQL_REPLICATION_MODE=slave

  # create users table on master and insert a new row
  psql_client master -U $POSTGRESQL_USER $POSTGRESQL_DATABASE -c \
    "CREATE TABLE users (id serial, name varchar(40) NOT NULL); \
     INSERT INTO users(name) VALUES ('Marko');"

  # check if row is replicated on slave
  run psql_client slave0 -U $POSTGRESQL_USER $POSTGRESQL_DATABASE -Axc "SELECT * FROM users;"
  [[ "$output" =~ "name|Marko" ]]
}

@test "Slave synchronizes with the master (delayed start)" {
  container_create master -d \
    -e POSTGRESQL_USER=$POSTGRESQL_USER \
    -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD \
    -e POSTGRESQL_DATABASE=$POSTGRESQL_DATABASE \
    -e POSTGRESQL_REPLICATION_MODE=master \
    -e POSTGRESQL_REPLICATION_USER=$POSTGRESQL_REPLICATION_USER \
    -e POSTGRESQL_REPLICATION_PASSWORD=$POSTGRESQL_REPLICATION_PASSWORD

  # create users table on master and insert a new row
  psql_client master -U $POSTGRESQL_USER $POSTGRESQL_DATABASE -c \
    "CREATE TABLE users (id serial, name varchar(40) NOT NULL); \
     INSERT INTO users(name) VALUES ('Marko');"

  # start slave linked to the master
  container_create slave0 -d \
    $(container_link master $CONTAINER_NAME) \
    -e POSTGRESQL_MASTER_HOST=$CONTAINER_NAME \
    -e POSTGRESQL_MASTER_PORT=5432 \
    -e POSTGRESQL_REPLICATION_MODE=slave \
    -e POSTGRESQL_REPLICATION_USER=$POSTGRESQL_REPLICATION_USER \
    -e POSTGRESQL_REPLICATION_PASSWORD=$POSTGRESQL_REPLICATION_PASSWORD

  # verify that master data is replicated on slave
  run psql_client slave0 -U $POSTGRESQL_USER $POSTGRESQL_DATABASE -Axc "SELECT * FROM users;"
  [[ "$output" =~ "name|Marko" ]]
}

@test "Replication status is preserved after deletion" {
  # create master container with host mounted volumes
  run container_create_with_host_volumes master -d \
    -e POSTGRESQL_USER=$POSTGRESQL_USER \
    -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD \
    -e POSTGRESQL_DATABASE=$POSTGRESQL_DATABASE \
    -e POSTGRESQL_REPLICATION_MODE=master \
    -e POSTGRESQL_REPLICATION_USER=$POSTGRESQL_REPLICATION_USER \
    -e POSTGRESQL_REPLICATION_PASSWORD=$POSTGRESQL_REPLICATION_PASSWORD

  # create users table on master and insert a new row
  psql_client master -U $POSTGRESQL_USER $POSTGRESQL_DATABASE -c \
    "CREATE TABLE users (id serial, name varchar(40) NOT NULL); \
     INSERT INTO users(name) VALUES ('Marko');"

  # create slave0 container with host mounted volumes, should replicate the master data
  container_create_with_host_volumes slave0 -d \
    $(container_link master $CONTAINER_NAME) \
    -e POSTGRESQL_MASTER_HOST=$CONTAINER_NAME \
    -e POSTGRESQL_MASTER_PORT=5432 \
    -e POSTGRESQL_REPLICATION_MODE=slave \
    -e POSTGRESQL_REPLICATION_USER=$POSTGRESQL_REPLICATION_USER \
    -e POSTGRESQL_REPLICATION_PASSWORD=$POSTGRESQL_REPLICATION_PASSWORD

  # stop and remove master and slave0 containers
  container_remove slave0
  container_remove master

  # start master and slave0 containers with existing host volumes and no additional env arguments
  container_create_with_host_volumes master -d
  container_create_with_host_volumes slave0 -d $(container_link master $CONTAINER_NAME)

  # insert new row into the master database
  psql_client master -U $POSTGRESQL_USER $POSTGRESQL_DATABASE -c "INSERT INTO users(name) VALUES ('Polo');"

  # verify that all previous and new data is replicated on slave0
  run psql_client slave0 -U $POSTGRESQL_USER $POSTGRESQL_DATABASE -Axc "SELECT * FROM users;"
  [[ "$output" =~ "name|Marko" ]]
  [[ "$output" =~ "name|Polo" ]]
}

@test "Replication slave can be triggered to act as the master" {
  container_create master -d \
    -e POSTGRESQL_USER=$POSTGRESQL_USER \
    -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD \
    -e POSTGRESQL_DATABASE=$POSTGRESQL_DATABASE \
    -e POSTGRESQL_REPLICATION_MODE=master \
    -e POSTGRESQL_REPLICATION_USER=$POSTGRESQL_REPLICATION_USER \
    -e POSTGRESQL_REPLICATION_PASSWORD=$POSTGRESQL_REPLICATION_PASSWORD

  container_create slave0 -d \
    $(container_link master $CONTAINER_NAME) \
    -e POSTGRESQL_MASTER_HOST=$CONTAINER_NAME \
    -e POSTGRESQL_MASTER_PORT=5432 \
    -e POSTGRESQL_REPLICATION_MODE=slave \
    -e POSTGRESQL_REPLICATION_USER=$POSTGRESQL_REPLICATION_USER \
    -e POSTGRESQL_REPLICATION_PASSWORD=$POSTGRESQL_REPLICATION_PASSWORD

  # create users table on master and insert a new row
  psql_client master -U $POSTGRESQL_USER $POSTGRESQL_DATABASE -c \
    "CREATE TABLE users (id serial, name varchar(40) NOT NULL); \
     INSERT INTO users(name) VALUES ('Marko');"

  # stop and remove master
  container_remove master

  # trigger slave to become master
  container_exec slave0 touch /tmp/postgresql.trigger.5432
  sleep $SLEEP_TIME

  # create slave1 that configures slave0 as the master
  container_create slave1 -d \
    $(container_link slave0 $CONTAINER_NAME) \
    -e POSTGRESQL_MASTER_HOST=$CONTAINER_NAME \
    -e POSTGRESQL_MASTER_PORT=5432 \
    -e POSTGRESQL_REPLICATION_MODE=slave \
    -e POSTGRESQL_REPLICATION_USER=$POSTGRESQL_REPLICATION_USER \
    -e POSTGRESQL_REPLICATION_PASSWORD=$POSTGRESQL_REPLICATION_PASSWORD

  # insert new row into slave0, since it is now the master it should allow writes
  psql_client slave0 -U $POSTGRESQL_USER $POSTGRESQL_DATABASE -c "INSERT INTO users(name) VALUES ('Polo');"

  # verify that all past and new data is replicated on slave1
  run psql_client slave1 -U $POSTGRESQL_USER $POSTGRESQL_DATABASE -Axc "SELECT * FROM users;"
  [[ "$output" =~ "name|Marko" ]]
  [[ "$output" =~ "name|Polo" ]]
}
