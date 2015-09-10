#!/usr/bin/env bats
CONTAINER_NAME=bitnami-mariadb-test
IMAGE_NAME=${IMAGE_NAME:-bitnami/mariadb}
SLEEP_TIME=5
MARIADB_DATABASE=test_database
MARIADB_USER=test_user
MARIADB_PASSWORD=test_password
REPLICATION_USER=repl_user
REPLICATION_PASSWORD=repl_password
VOL_PREFIX=/bitnami/mariadb
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

create_container(){
  docker run "$@" $IMAGE_NAME; sleep $SLEEP_TIME
}

# $1 is the command
mysql_client(){
  case "$1" in
    master|slave)
      SERVER_LINK="--link $CONTAINER_NAME-$1:$CONTAINER_NAME"
      shift
      ;;
    *)
      SERVER_LINK="--link $CONTAINER_NAME:$CONTAINER_NAME"
      ;;
  esac
  docker run --rm $SERVER_LINK $IMAGE_NAME mysql -h $CONTAINER_NAME "$@"
}

create_full_container(){
  create_container -d --name $CONTAINER_NAME\
   -e MARIADB_USER=$MARIADB_USER\
   -e MARIADB_DATABASE=$MARIADB_DATABASE\
   -e MARIADB_PASSWORD=$MARIADB_PASSWORD
}

create_full_container_mounted(){
  create_container -d --name $CONTAINER_NAME\
   -e MARIADB_USER=$MARIADB_USER\
   -e MARIADB_DATABASE=$MARIADB_DATABASE\
   -e MARIADB_PASSWORD=$MARIADB_PASSWORD\
   -v $HOST_VOL_PREFIX/data:$VOL_PREFIX/data\
   -v $HOST_VOL_PREFIX/conf:$VOL_PREFIX/conf\
   -v $HOST_VOL_PREFIX/logs:$VOL_PREFIX/logs
}

@test "Root user created without password" {
  create_container -d --name $CONTAINER_NAME
  run mysql_client -e "select User from mysql.user where User=\"root\"\G"
  [[ "$output" =~ "User: root" ]]
}

@test "Root user created with password" {
  create_container -d --name $CONTAINER_NAME -e MARIADB_PASSWORD=$MARIADB_PASSWORD
  # Can not login as root
  run mysql_client -e 'show databases\G'
  [ $status = 1 ]
  run mysql_client -p$MARIADB_PASSWORD -e 'show databases\G'
  [ $status = 0 ]
}

@test "Root user has access to admin database" {
  create_container -d --name $CONTAINER_NAME
  run mysql_client -e 'show databases\G'
  [[ "$output" =~ 'Database: mysql' ]]
}

@test "Custom database created" {
  create_container -d --name $CONTAINER_NAME -e MARIADB_DATABASE=$MARIADB_DATABASE
  run mysql_client -e 'show databases\G'
  [[ "$output" =~ "Database: $MARIADB_DATABASE" ]]
}

@test "Can't create a custom user without database" {
  run create_container --name $CONTAINER_NAME -e MARIADB_USER=$MARIADB_USER
  [[ "$output" =~ "you need to provide the MARIADB_DATABASE" ]]
}

@test "Create custom user and database without password" {
  create_container -d --name $CONTAINER_NAME\
   -e MARIADB_USER=$MARIADB_USER\
   -e MARIADB_DATABASE=$MARIADB_DATABASE
  # Can not login as root
  run mysql_client -e 'show databases\G'
  [ $status = 1 ]
  run mysql_client -u $MARIADB_USER -e  'show databases\G'
  [[ "$output" =~ "Database: $MARIADB_DATABASE" ]]
}

@test "Create custom user and database with password" {
  create_full_container
  # Can not login as root
  run mysql_client -u $MARIADB_USER -e 'show databases\G'
  [ $status = 1 ]
  run mysql_client -u $MARIADB_USER -p$MARIADB_PASSWORD -e 'show databases\G'
  [ $status = 0 ]
}

@test "User and password settings are preserved after restart" {
  create_full_container

  docker stop $CONTAINER_NAME
  docker start $CONTAINER_NAME
  sleep $SLEEP_TIME

  run docker logs $CONTAINER_NAME
  [[ "$output" =~ "The credentials were set on first boot." ]]

  run mysql_client -u $MARIADB_USER -p$MARIADB_PASSWORD -e 'show databases\G'
  [ $status = 0 ]
}

@test "If host mounted, password and settings are preserved after deletion" {
  cleanup_volumes_content
  create_full_container_mounted

  docker rm -fv $CONTAINER_NAME

  create_container -d --name $CONTAINER_NAME\
   -v $HOST_VOL_PREFIX/data:$VOL_PREFIX/data\
   -v $HOST_VOL_PREFIX/conf:$VOL_PREFIX/conf

  run mysql_client -u $MARIADB_USER -p$MARIADB_PASSWORD -e 'show databases\G'
  [ $status = 0 ]
  cleanup_volumes_content
}

@test "Port 3306 exposed and accepting external connections" {
  create_container -d --name $CONTAINER_NAME

  run docker run --rm --name 'linked' --link $CONTAINER_NAME:$CONTAINER_NAME $IMAGE_NAME\
    mysql -h $CONTAINER_NAME -P 3306 -e 'show databases\G'
  [ $status = 0 ]
}

@test "All the volumes exposed" {
  create_container -d --name $CONTAINER_NAME
  run docker inspect $CONTAINER_NAME
  [[ "$output" =~ "$VOL_PREFIX/data" ]]
  [[ "$output" =~ "$VOL_PREFIX/conf" ]]
  [[ "$output" =~ "$VOL_PREFIX/logs" ]]
}

@test "Data gets generated in conf and data if bind mounted in the host" {
  create_full_container_mounted
  run docker run -v $HOST_VOL_PREFIX:$HOST_VOL_PREFIX --rm $IMAGE_NAME ls -l $HOST_VOL_PREFIX/conf/my.cnf $HOST_VOL_PREFIX/logs/mysqld.log
  [ $status = 0 ]
  cleanup_volumes_content
}

@test "Master database is replicated on slave" {
  create_container -d --name $CONTAINER_NAME-master \
   -e MARIADB_USER=$MARIADB_USER \
   -e MARIADB_PASSWORD=$MARIADB_PASSWORD \
   -e MARIADB_DATABASE=$MARIADB_DATABASE \
   -e REPLICATION_MODE=master \
   -e REPLICATION_USER=$REPLICATION_USER \
   -e REPLICATION_PASSWORD=$REPLICATION_PASSWORD

  create_container -d --name $CONTAINER_NAME-slave \
   --link $CONTAINER_NAME-master:mariadb-master \
   -e MASTER_HOST=$CONTAINER_NAME-master \
   -e MASTER_USER=$MARIADB_USER \
   -e MASTER_PASSWORD=$MARIADB_PASSWORD \
   -e MARIADB_USER=$MARIADB_USER \
   -e MARIADB_PASSWORD=$MARIADB_PASSWORD \
   -e MARIADB_DATABASE=$MARIADB_DATABASE \
   -e REPLICATION_MODE=slave \
   -e REPLICATION_USER=$REPLICATION_USER \
   -e REPLICATION_PASSWORD=$REPLICATION_PASSWORD

  mysql_client master -u$MARIADB_USER -p$MARIADB_PASSWORD $MARIADB_DATABASE -e "CREATE TABLE users (id INT AUTO_INCREMENT, name VARCHAR(30), datum TIMESTAMP DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY(id))"
  mysql_client master -u$MARIADB_USER -p$MARIADB_PASSWORD $MARIADB_DATABASE -e "INSERT INTO users(name) VALUES ('Marko')"

  run mysql_client slave -u$MARIADB_USER -p$MARIADB_PASSWORD $MARIADB_DATABASE -e "SELECT * FROM users"
  [[ "$output" =~ "Marko" ]]
  [ $status = 0 ]

  cleanup_running_containers $CONTAINER_NAME-master
  cleanup_running_containers $CONTAINER_NAME-slave
}

@test "Can setup replication without password for replication user" {
  create_container -d --name $CONTAINER_NAME-master \
   -e MARIADB_USER=$MARIADB_USER \
   -e MARIADB_PASSWORD=$MARIADB_PASSWORD \
   -e MARIADB_DATABASE=$MARIADB_DATABASE \
   -e REPLICATION_MODE=master \
   -e REPLICATION_USER=$REPLICATION_USER

  create_container -d --name $CONTAINER_NAME-slave \
   --link $CONTAINER_NAME-master:mariadb-master \
   -e MASTER_HOST=$CONTAINER_NAME-master \
   -e MASTER_USER=$MARIADB_USER \
   -e MASTER_PASSWORD=$MARIADB_PASSWORD \
   -e MARIADB_USER=$MARIADB_USER \
   -e MARIADB_PASSWORD=$MARIADB_PASSWORD \
   -e MARIADB_DATABASE=$MARIADB_DATABASE \
   -e REPLICATION_MODE=slave \
   -e REPLICATION_USER=$REPLICATION_USER

  mysql_client master -u$MARIADB_USER -p$MARIADB_PASSWORD $MARIADB_DATABASE -e "CREATE TABLE users (id INT AUTO_INCREMENT, name VARCHAR(30), datum TIMESTAMP DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY(id))"
  mysql_client master -u$MARIADB_USER -p$MARIADB_PASSWORD $MARIADB_DATABASE -e "INSERT INTO users(name) VALUES ('Marko')"

  run mysql_client slave -u$MARIADB_USER -p$MARIADB_PASSWORD $MARIADB_DATABASE -e "SELECT * FROM users"
  [[ "$output" =~ "Marko" ]]
  [ $status = 0 ]

  cleanup_running_containers $CONTAINER_NAME-master
  cleanup_running_containers $CONTAINER_NAME-slave
}

@test "Can't setup replication slave without master user" {
  create_container -d --name $CONTAINER_NAME-master \
   -e MARIADB_USER=$MARIADB_USER \
   -e MARIADB_PASSWORD=$MARIADB_PASSWORD \
   -e MARIADB_DATABASE=$MARIADB_DATABASE \
   -e REPLICATION_MODE=master \
   -e REPLICATION_USER=$REPLICATION_USER \
   -e REPLICATION_PASSWORD=$REPLICATION_PASSWORD

  run create_container --name $CONTAINER_NAME-slave \
   --link $CONTAINER_NAME-master:master \
   -e MASTER_HOST=master \
   -e MARIADB_USER=$MARIADB_USER \
   -e MARIADB_PASSWORD=$MARIADB_PASSWORD \
   -e MARIADB_DATABASE=$MARIADB_DATABASE \
   -e REPLICATION_MODE=slave \
   -e REPLICATION_USER=$REPLICATION_USER \
   -e REPLICATION_PASSWORD=$REPLICATION_PASSWORD
[[ "$output" =~ "you need to provide the MASTER_USER" ]]

  cleanup_running_containers $CONTAINER_NAME-master
  cleanup_running_containers $CONTAINER_NAME-slave
}

@test "Can't setup replication slave without database" {
  create_container -d --name $CONTAINER_NAME-master \
   -e MARIADB_USER=$MARIADB_USER \
   -e MARIADB_PASSWORD=$MARIADB_PASSWORD \
   -e MARIADB_DATABASE=$MARIADB_DATABASE \
   -e REPLICATION_MODE=master \
   -e REPLICATION_USER=$REPLICATION_USER \
   -e REPLICATION_PASSWORD=$REPLICATION_PASSWORD

  run create_container --name $CONTAINER_NAME-slave \
   --link $CONTAINER_NAME-master:mariadb-master \
   -e MASTER_HOST=$CONTAINER_NAME-master \
   -e MASTER_USER=$MARIADB_USER \
   -e MASTER_PASSWORD=$MARIADB_PASSWORD \
   -e MARIADB_USER=$MARIADB_USER \
   -e MARIADB_PASSWORD=$MARIADB_PASSWORD \
   -e REPLICATION_MODE=slave \
   -e REPLICATION_USER=$REPLICATION_USER \
   -e REPLICATION_PASSWORD=$REPLICATION_PASSWORD
  [[ "$output" =~ "you need to provide the MARIADB_DATABASE" ]]

  cleanup_running_containers $CONTAINER_NAME-master
  cleanup_running_containers $CONTAINER_NAME-slave
}

@test "Can't setup replication slave without replication user" {
  create_container -d --name $CONTAINER_NAME-master \
   -e MARIADB_USER=$MARIADB_USER \
   -e MARIADB_PASSWORD=$MARIADB_PASSWORD \
   -e MARIADB_DATABASE=$MARIADB_DATABASE \
   -e REPLICATION_MODE=master \
   -e REPLICATION_USER=$REPLICATION_USER \
   -e REPLICATION_PASSWORD=$REPLICATION_PASSWORD

  run create_container --name $CONTAINER_NAME-slave \
   --link $CONTAINER_NAME-master:master \
   -e MASTER_HOST=$CONTAINER_NAME-master \
   -e MASTER_USER=$MARIADB_USER \
   -e MASTER_PASSWORD=$MARIADB_PASSWORD \
   -e MARIADB_USER=$MARIADB_USER \
   -e MARIADB_PASSWORD=$MARIADB_PASSWORD \
   -e MARIADB_DATABASE=$MARIADB_DATABASE \
   -e REPLICATION_MODE=slave
  [[ "$output" =~ "you need to provide the REPLICATION_USER" ]]

  cleanup_running_containers $CONTAINER_NAME-master
  cleanup_running_containers $CONTAINER_NAME-slave
}

@test "Replication slave can automatically fetch connection parameters from master using docker links" {
  create_container -d --name $CONTAINER_NAME-master \
   -e MARIADB_USER=$MARIADB_USER \
   -e MARIADB_PASSWORD=$MARIADB_PASSWORD \
   -e MARIADB_DATABASE=$MARIADB_DATABASE \
   -e REPLICATION_MODE=master \
   -e REPLICATION_USER=$REPLICATION_USER \
   -e REPLICATION_PASSWORD=$REPLICATION_PASSWORD

  create_container -d --name $CONTAINER_NAME-slave \
   --link $CONTAINER_NAME-master:mariadb-master \
   -e MARIADB_USER=$MARIADB_USER \
   -e MARIADB_PASSWORD=$MARIADB_PASSWORD \
   -e MARIADB_DATABASE=$MARIADB_DATABASE \
   -e REPLICATION_MODE=slave

  mysql_client master -u$MARIADB_USER -p$MARIADB_PASSWORD $MARIADB_DATABASE -e "CREATE TABLE users (id INT AUTO_INCREMENT, name VARCHAR(30), datum TIMESTAMP DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY(id))"
  mysql_client master -u$MARIADB_USER -p$MARIADB_PASSWORD $MARIADB_DATABASE -e "INSERT INTO users(name) VALUES ('Marko')"

  run mysql_client slave -u$MARIADB_USER -p$MARIADB_PASSWORD $MARIADB_DATABASE -e "SELECT * FROM users"
  [[ "$output" =~ "Marko" ]]
  [ $status = 0 ]

  cleanup_running_containers $CONTAINER_NAME-master
  cleanup_running_containers $CONTAINER_NAME-slave
}

@test "Slave synchronizes with the master (delayed start)" {
  create_container -d --name $CONTAINER_NAME-master \
   -e MARIADB_USER=$MARIADB_USER \
   -e MARIADB_PASSWORD=$MARIADB_PASSWORD \
   -e MARIADB_DATABASE=$MARIADB_DATABASE \
   -e REPLICATION_MODE=master \
   -e REPLICATION_USER=$REPLICATION_USER \
   -e REPLICATION_PASSWORD=$REPLICATION_PASSWORD

  mysql_client master -u$MARIADB_USER -p$MARIADB_PASSWORD $MARIADB_DATABASE -e "CREATE TABLE users (id INT AUTO_INCREMENT, name VARCHAR(30), datum TIMESTAMP DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY(id))"
  mysql_client master -u$MARIADB_USER -p$MARIADB_PASSWORD $MARIADB_DATABASE -e "INSERT INTO users(name) VALUES ('Marko')"

  create_container -d --name $CONTAINER_NAME-slave \
   --link $CONTAINER_NAME-master:mariadb-master \
   -e MARIADB_USER=$MARIADB_USER \
   -e MARIADB_PASSWORD=$MARIADB_PASSWORD \
   -e MARIADB_DATABASE=$MARIADB_DATABASE \
   -e REPLICATION_MODE=slave

  mysql_client master -u$MARIADB_USER -p$MARIADB_PASSWORD $MARIADB_DATABASE -e "INSERT INTO users(name) VALUES ('Polo')"

  run mysql_client slave -u$MARIADB_USER -p$MARIADB_PASSWORD $MARIADB_DATABASE -e "SELECT * FROM users"
  [[ "$output" =~ "Marko" ]]
  [[ "$output" =~ "Polo" ]]
  [ $status = 0 ]

  cleanup_running_containers $CONTAINER_NAME-master
  cleanup_running_containers $CONTAINER_NAME-slave
}

@test "Replication status is preserved after deletion" {
  cleanup_volumes_content

  create_container -d --name $CONTAINER_NAME-master \
   -e MARIADB_USER=$MARIADB_USER \
   -e MARIADB_PASSWORD=$MARIADB_PASSWORD \
   -e MARIADB_DATABASE=$MARIADB_DATABASE \
   -e REPLICATION_MODE=master \
   -e REPLICATION_USER=$REPLICATION_USER \
   -e REPLICATION_PASSWORD=$REPLICATION_PASSWORD \
   -v $HOST_VOL_PREFIX/data:$VOL_PREFIX/data \
   -v $HOST_VOL_PREFIX/conf:$VOL_PREFIX/conf \
   -v $HOST_VOL_PREFIX/logs:$VOL_PREFIX/logs

  mysql_client master -u$MARIADB_USER -p$MARIADB_PASSWORD $MARIADB_DATABASE -e "CREATE TABLE users (id INT AUTO_INCREMENT, name VARCHAR(30), datum TIMESTAMP DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY(id))"
  mysql_client master -u$MARIADB_USER -p$MARIADB_PASSWORD $MARIADB_DATABASE -e "INSERT INTO users(name) VALUES ('Marko')"

  create_container -d --name $CONTAINER_NAME-slave \
   --link $CONTAINER_NAME-master:mariadb-master \
   -e MASTER_HOST=$CONTAINER_NAME-master \
   -e MASTER_USER=$MARIADB_USER \
   -e MASTER_PASSWORD=$MARIADB_PASSWORD \
   -e MARIADB_USER=$MARIADB_USER \
   -e MARIADB_PASSWORD=$MARIADB_PASSWORD \
   -e MARIADB_DATABASE=$MARIADB_DATABASE \
   -e REPLICATION_MODE=slave \
   -e REPLICATION_USER=$REPLICATION_USER \
   -e REPLICATION_PASSWORD=$REPLICATION_PASSWORD

  run mysql_client slave -u$MARIADB_USER -p$MARIADB_PASSWORD $MARIADB_DATABASE -e "SELECT * FROM users"
  [[ "$output" =~ "Marko" ]]
  [ $status = 0 ]

  docker rm -fv $CONTAINER_NAME-slave
  docker rm -fv $CONTAINER_NAME-master

  create_container -d --name $CONTAINER_NAME-master \
   -v $HOST_VOL_PREFIX/data:$VOL_PREFIX/data \
   -v $HOST_VOL_PREFIX/conf:$VOL_PREFIX/conf

  run mysql_client master -u$MARIADB_USER -p$MARIADB_PASSWORD $MARIADB_DATABASE -e "SELECT * FROM users"
  [[ "$output" =~ "Marko" ]]
  [ $status = 0 ]

  mysql_client master -u$MARIADB_USER -p$MARIADB_PASSWORD $MARIADB_DATABASE -e "INSERT INTO users(name) VALUES ('Polo')"

  create_container -d --name $CONTAINER_NAME-slave \
   --link $CONTAINER_NAME-master:mariadb-master \
   -e MASTER_HOST=$CONTAINER_NAME-master \
   -e MASTER_USER=$MARIADB_USER \
   -e MASTER_PASSWORD=$MARIADB_PASSWORD \
   -e MARIADB_USER=$MARIADB_USER \
   -e MARIADB_PASSWORD=$MARIADB_PASSWORD \
   -e MARIADB_DATABASE=$MARIADB_DATABASE \
   -e REPLICATION_MODE=slave \
   -e REPLICATION_USER=$REPLICATION_USER \
   -e REPLICATION_PASSWORD=$REPLICATION_PASSWORD

  run mysql_client slave -u$MARIADB_USER -p$MARIADB_PASSWORD $MARIADB_DATABASE -e "SELECT * FROM users"
  [[ "$output" =~ "Marko" ]]
  [[ "$output" =~ "Polo" ]]
  [ $status = 0 ]

  cleanup_running_containers $CONTAINER_NAME-master
  cleanup_running_containers $CONTAINER_NAME-slave
  cleanup_volumes_content
}
