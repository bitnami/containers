#!/usr/bin/env bats
CONTAINER_NAME=bitnami-postgresql-test
IMAGE_NAME=${IMAGE_NAME:-bitnami/postgresql}
SLEEP_TIME=5
POSTGRESQL_DATABASE=test_database
POSTGRESQL_ROOT_USER=postgres
POSTGRESQL_USER=test_user
POSTGRESQL_PASSWORD=test_password
POSTGRESQL_REPLICATION_USER=repl_user
POSTGRESQL_REPLICATION_PASSWORD=repl_password
VOL_PREFIX=/bitnami/postgresql
HOST_VOL_PREFIX=${HOST_VOL_PREFIX:-/tmp/bitnami/$CONTAINER_NAME}

cleanup_running_containers() {
  if [ "$(docker ps -a | grep ${1:-$CONTAINER_NAME})" ]; then
    docker rm -fv ${1:-$CONTAINER_NAME}
  fi
}

setup() {
  cleanup_running_containers
  cleanup_running_containers $CONTAINER_NAME-master
  cleanup_running_containers $CONTAINER_NAME-slave
  mkdir -p $HOST_VOL_PREFIX
}

teardown() {
  cleanup_running_containers
  cleanup_running_containers $CONTAINER_NAME-master
  cleanup_running_containers $CONTAINER_NAME-slave
}

cleanup_volumes_content() {
  docker run --rm\
    -v $HOST_VOL_PREFIX/data:$VOL_PREFIX/data\
    -v $HOST_VOL_PREFIX/conf:$VOL_PREFIX/conf\
    -v $HOST_VOL_PREFIX/logs:$VOL_PREFIX/logs\
    $IMAGE_NAME rm -rf $VOL_PREFIX/data/ $VOL_PREFIX/logs/ $VOL_PREFIX/conf/
}

create_container() {
  docker run --name $CONTAINER_NAME -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD "$@" $IMAGE_NAME
  sleep $SLEEP_TIME
}

# $1 is the command
psql_client(){
  case "$1" in
    master|slave)
      SERVER_LINK="--link $CONTAINER_NAME-$1:$CONTAINER_NAME"
      shift
      ;;
    *)
      SERVER_LINK="--link $CONTAINER_NAME:$CONTAINER_NAME"
      ;;
  esac
  docker run --rm $SERVER_LINK -e PGPASSWORD=$POSTGRESQL_PASSWORD $IMAGE_NAME psql -h $CONTAINER_NAME "$@"
}

create_full_container() {
  docker run -d --name $CONTAINER_NAME\
   -e POSTGRESQL_USER=$POSTGRESQL_USER\
   -e POSTGRESQL_DATABASE=$POSTGRESQL_DATABASE\
   -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD $IMAGE_NAME
  sleep $SLEEP_TIME
}

create_full_container_mounted() {
  docker run -d --name $CONTAINER_NAME\
   -e POSTGRESQL_USER=$POSTGRESQL_USER\
   -e POSTGRESQL_DATABASE=$POSTGRESQL_DATABASE\
   -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD\
   -v $HOST_VOL_PREFIX/data:$VOL_PREFIX/data\
   -v $HOST_VOL_PREFIX/conf:$VOL_PREFIX/conf\
   -v $HOST_VOL_PREFIX/logs:$VOL_PREFIX/logs\
   $IMAGE_NAME
  sleep $SLEEP_TIME
}

@test "Port 5432 exposed and accepting external connections" {
  create_container -d

  run docker run --rm --name 'linked' --link $CONTAINER_NAME:$CONTAINER_NAME\
    -e PGPASSWORD=$POSTGRESQL_PASSWORD $IMAGE_NAME\
      pg_isready -h $CONTAINER_NAME -p 5432 -t 5
  [ $status = 0 ]
}

@test "User postgres created with password" {
  create_container -d -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD
  # Can not login as postgres
  run docker run --rm --link $CONTAINER_NAME:$CONTAINER_NAME $IMAGE_NAME psql -h $CONTAINER_NAME -U $POSTGRESQL_ROOT_USER -wc "\l"
  [ $status != 1 ]
  run psql_client -U $POSTGRESQL_ROOT_USER -c "\l"
  [ $status = 0 ]
}

@test "User postgres is superuser" {
  create_container -d -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD
  run psql_client -U $POSTGRESQL_ROOT_USER -Axc "SHOW is_superuser;"
  [[ $output =~ "is_superuser|on" ]]
  [ $status = 0 ]
}

@test "Custom database created" {
  create_container -d -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD -e POSTGRESQL_DATABASE=$POSTGRESQL_DATABASE
  run psql_client -U $POSTGRESQL_ROOT_USER -Axc "\l"
  [[ "$output" =~ "Name|$POSTGRESQL_DATABASE" ]]
}

@test "Can't create a custom user without database" {
  run create_container -e POSTGRESQL_USER=$POSTGRESQL_USER
  [[ "$output" =~ "you need to provide the POSTGRESQL_DATABASE" ]]
}

@test "Create custom user and database with password" {
  create_full_container
  # Can not login as postgres
  run docker run --rm --link $CONTAINER_NAME:$CONTAINER_NAME $IMAGE_NAME psql -h $CONTAINER_NAME -U $POSTGRESQL_ROOT_USER -wc "\l"
  [ $status != 1 ]
  run psql_client -U $POSTGRESQL_ROOT_USER -c "\l"
  [ $status != 1 ]
  run psql_client -U $POSTGRESQL_USER $POSTGRESQL_DATABASE -c "\dt"
  [ $status = 0 ]
}

@test "User and password settings are preserved after restart" {
  create_full_container

  docker stop $CONTAINER_NAME
  docker start $CONTAINER_NAME
  sleep $SLEEP_TIME

  run docker logs $CONTAINER_NAME
  [[ "$output" =~ "The credentials were set on first boot." ]]

  run psql_client -U $POSTGRESQL_USER $POSTGRESQL_DATABASE -c "\dt"
  [ $status = 0 ]
}

@test "If host mounted, password and settings are preserved after deletion" {
  cleanup_volumes_content
  create_full_container_mounted

  docker rm -fv $CONTAINER_NAME

  docker run -d --name $CONTAINER_NAME\
   -v $HOST_VOL_PREFIX/data:$VOL_PREFIX/data\
   -v $HOST_VOL_PREFIX/conf:$VOL_PREFIX/conf\
   $IMAGE_NAME
  sleep $SLEEP_TIME

  run psql_client -U $POSTGRESQL_USER $POSTGRESQL_DATABASE -c "\dt"
  [ $status = 0 ]
  cleanup_volumes_content
}

@test "All the volumes exposed" {
  create_container -d
  run docker inspect $CONTAINER_NAME
  [[ "$output" =~ "$VOL_PREFIX/data" ]]
  [[ "$output" =~ "$VOL_PREFIX/conf" ]]
  [[ "$output" =~ "$VOL_PREFIX/logs" ]]
}

@test "Data gets generated in conf, data and logs if bind mounted in the host" {
  create_full_container_mounted
  run docker run -v $HOST_VOL_PREFIX:$HOST_VOL_PREFIX --rm $IMAGE_NAME ls -l $HOST_VOL_PREFIX/conf/postgresql.conf $HOST_VOL_PREFIX/logs/postgresql.log
  [ $status = 0 ]
  cleanup_volumes_content
}

@test "Master database is replicated on slave" {
  create_container -d --name $CONTAINER_NAME-master \
   -e POSTGRESQL_USER=$POSTGRESQL_USER \
   -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD \
   -e POSTGRESQL_DATABASE=$POSTGRESQL_DATABASE \
   -e POSTGRESQL_REPLICATION_MODE=master \
   -e POSTGRESQL_REPLICATION_USER=$POSTGRESQL_REPLICATION_USER \
   -e POSTGRESQL_REPLICATION_PASSWORD=$POSTGRESQL_REPLICATION_PASSWORD

  create_container -d --name $CONTAINER_NAME-slave \
   --link $CONTAINER_NAME-master:$CONTAINER_NAME-master \
   -e POSTGRESQL_MASTER_HOST=$CONTAINER_NAME-master \
   -e POSTGRESQL_MASTER_PORT=5432 \
   -e POSTGRESQL_REPLICATION_MODE=slave \
   -e POSTGRESQL_REPLICATION_USER=$POSTGRESQL_REPLICATION_USER \
   -e POSTGRESQL_REPLICATION_PASSWORD=$POSTGRESQL_REPLICATION_PASSWORD

  psql_client master -U $POSTGRESQL_USER $POSTGRESQL_DATABASE -c "CREATE TABLE users (id serial, name varchar(40) NOT NULL);"
  psql_client master -U $POSTGRESQL_USER $POSTGRESQL_DATABASE -c "INSERT INTO users(name) VALUES ('Marko');"

  run psql_client slave -U $POSTGRESQL_USER $POSTGRESQL_DATABASE -c "SELECT * FROM users;"
  [[ "$output" =~ "Marko" ]]
  [ $status = 0 ]

  cleanup_running_containers $CONTAINER_NAME-master
  cleanup_running_containers $CONTAINER_NAME-slave
}

@test "Can't setup replication master without replication user" {
  run create_container --name $CONTAINER_NAME-master \
   -e POSTGRESQL_USER=$POSTGRESQL_USER \
   -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD \
   -e POSTGRESQL_DATABASE=$POSTGRESQL_DATABASE \
   -e POSTGRESQL_REPLICATION_MODE=master
  [[ "$output" =~ "you need to provide the POSTGRESQL_REPLICATION_USER" ]]

  cleanup_running_containers $CONTAINER_NAME-master
}

@test "Can't setup replication master without replication user password" {
  run create_container --name $CONTAINER_NAME-master \
   -e POSTGRESQL_USER=$POSTGRESQL_USER \
   -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD \
   -e POSTGRESQL_DATABASE=$POSTGRESQL_DATABASE \
   -e POSTGRESQL_REPLICATION_MODE=master \
   -e POSTGRESQL_REPLICATION_USER=$POSTGRESQL_REPLICATION_USER
  [[ "$output" =~ "you need to provide the POSTGRESQL_REPLICATION_PASSWORD" ]]

  cleanup_running_containers $CONTAINER_NAME-master
}

@test "Can't setup replication slave without master host" {
  run create_container --name $CONTAINER_NAME-slave \
   -e POSTGRESQL_REPLICATION_MODE=slave
  [[ "$output" =~ "you need to provide the POSTGRESQL_MASTER_HOST" ]]

  cleanup_running_containers $CONTAINER_NAME-slave
}

@test "Can't setup replication slave without replication user" {
  run create_container --name $CONTAINER_NAME-slave \
   -e POSTGRESQL_REPLICATION_MODE=slave \
   -e POSTGRESQL_MASTER_HOST=master
  [[ "$output" =~ "you need to provide the POSTGRESQL_REPLICATION_USER" ]]

  cleanup_running_containers $CONTAINER_NAME-slave
}

@test "Can't setup replication slave without replication password" {
  run create_container --name $CONTAINER_NAME-slave \
   -e POSTGRESQL_REPLICATION_MODE=slave \
   -e POSTGRESQL_MASTER_HOST=master \
   -e POSTGRESQL_REPLICATION_USER=$POSTGRESQL_REPLICATION_USER
  [[ "$output" =~ "you need to provide the POSTGRESQL_REPLICATION_PASSWORD" ]]

  cleanup_running_containers $CONTAINER_NAME-slave
}

@test "Replication slave can fetch replication parameters from link alias \"master\"" {
  create_container -d --name $CONTAINER_NAME-master \
   -e POSTGRESQL_USER=$POSTGRESQL_USER \
   -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD \
   -e POSTGRESQL_DATABASE=$POSTGRESQL_DATABASE \
   -e POSTGRESQL_REPLICATION_MODE=master \
   -e POSTGRESQL_REPLICATION_USER=$POSTGRESQL_REPLICATION_USER \
   -e POSTGRESQL_REPLICATION_PASSWORD=$POSTGRESQL_REPLICATION_PASSWORD

  create_container -d --name $CONTAINER_NAME-slave \
   --link $CONTAINER_NAME-master:master \
   -e POSTGRESQL_REPLICATION_MODE=slave

  psql_client master -U $POSTGRESQL_USER $POSTGRESQL_DATABASE -c "CREATE TABLE users (id serial, name varchar(40) NOT NULL);"
  psql_client master -U $POSTGRESQL_USER $POSTGRESQL_DATABASE -c "INSERT INTO users(name) VALUES ('Marko');"

  run psql_client slave -U $POSTGRESQL_USER $POSTGRESQL_DATABASE -c "SELECT * FROM users;"
  [[ "$output" =~ "Marko" ]]
  [ $status = 0 ]

  cleanup_running_containers $CONTAINER_NAME-master
  cleanup_running_containers $CONTAINER_NAME-slave
}

@test "Slave synchronizes with the master (delayed start)" {
  create_container -d --name $CONTAINER_NAME-master \
   -e POSTGRESQL_USER=$POSTGRESQL_USER \
   -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD \
   -e POSTGRESQL_DATABASE=$POSTGRESQL_DATABASE \
   -e POSTGRESQL_REPLICATION_MODE=master \
   -e POSTGRESQL_REPLICATION_USER=$POSTGRESQL_REPLICATION_USER \
   -e POSTGRESQL_REPLICATION_PASSWORD=$POSTGRESQL_REPLICATION_PASSWORD

  psql_client master -U $POSTGRESQL_USER $POSTGRESQL_DATABASE -c "CREATE TABLE users (id serial, name varchar(40) NOT NULL);"
  psql_client master -U $POSTGRESQL_USER $POSTGRESQL_DATABASE -c "INSERT INTO users(name) VALUES ('Marko');"

  create_container -d --name $CONTAINER_NAME-slave \
   --link $CONTAINER_NAME-master:master \
   -e POSTGRESQL_REPLICATION_MODE=slave

  run psql_client slave -U $POSTGRESQL_USER $POSTGRESQL_DATABASE -c "SELECT * FROM users;"
  [[ "$output" =~ "Marko" ]]
  [ $status = 0 ]

  cleanup_running_containers $CONTAINER_NAME-master
  cleanup_running_containers $CONTAINER_NAME-slave
}

@test "Replication status is preserved after deletion" {
  cleanup_volumes_content

  create_container -d --name $CONTAINER_NAME-master \
   -e POSTGRESQL_USER=$POSTGRESQL_USER \
   -e POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD \
   -e POSTGRESQL_DATABASE=$POSTGRESQL_DATABASE \
   -e POSTGRESQL_REPLICATION_MODE=master \
   -e POSTGRESQL_REPLICATION_USER=$POSTGRESQL_REPLICATION_USER \
   -e POSTGRESQL_REPLICATION_PASSWORD=$POSTGRESQL_REPLICATION_PASSWORD \
   -v $HOST_VOL_PREFIX/data:$VOL_PREFIX/data \
   -v $HOST_VOL_PREFIX/conf:$VOL_PREFIX/conf \
   -v $HOST_VOL_PREFIX/logs:$VOL_PREFIX/logs

  psql_client master -U $POSTGRESQL_USER $POSTGRESQL_DATABASE -c "CREATE TABLE users (id serial, name varchar(40) NOT NULL);"
  psql_client master -U $POSTGRESQL_USER $POSTGRESQL_DATABASE -c "INSERT INTO users(name) VALUES ('Marko');"

  create_container -d --name $CONTAINER_NAME-slave \
   --link $CONTAINER_NAME-master:master \
   -e POSTGRESQL_REPLICATION_MODE=slave

  run psql_client slave -U $POSTGRESQL_USER $POSTGRESQL_DATABASE -c "SELECT * FROM users;"
  [[ "$output" =~ "Marko" ]]
  [ $status = 0 ]

  cleanup_running_containers $CONTAINER_NAME-slave
  cleanup_running_containers $CONTAINER_NAME-master

  create_container -d --name $CONTAINER_NAME-master \
   -e POSTGRESQL_REPLICATION_MODE=master \
   -v $HOST_VOL_PREFIX/data:$VOL_PREFIX/data \
   -v $HOST_VOL_PREFIX/conf:$VOL_PREFIX/conf \
   -v $HOST_VOL_PREFIX/logs:$VOL_PREFIX/logs

  create_container -d --name $CONTAINER_NAME-slave \
   --link $CONTAINER_NAME-master:master \
   -e POSTGRESQL_REPLICATION_MODE=slave \
   -e POSTGRESQL_REPLICATION_USER=$POSTGRESQL_REPLICATION_USER \
   -e POSTGRESQL_REPLICATION_PASSWORD=$POSTGRESQL_REPLICATION_PASSWORD

  psql_client master -U $POSTGRESQL_USER $POSTGRESQL_DATABASE -c "INSERT INTO users(name) VALUES ('Polo');"

  run psql_client slave -U $POSTGRESQL_USER $POSTGRESQL_DATABASE -c "SELECT * FROM users;"
  [[ "$output" =~ "Marko" ]]
  [[ "$output" =~ "Polo" ]]
  [ $status = 0 ]

  cleanup_running_containers $CONTAINER_NAME-master
  cleanup_running_containers $CONTAINER_NAME-slave
  cleanup_volumes_content
}
