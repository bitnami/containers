#!/usr/bin/env bats

MYSQL_DATABASE=test_database
MYSQL_USER=test_user
MYSQL_PASSWORD=test_password
MYSQL_REPLICATION_USER=repl_user
MYSQL_REPLICATION_PASSWORD=repl_password

# source the helper script
APP_NAME=mysql
SLEEP_TIME=60
VOL_PREFIX=/bitnami/$APP_NAME
VOLUMES=$VOL_PREFIX
load tests/docker_helper

# Link to container and execute mysql client
# $1 : name of the container to link to
# ${@:2} : arguments for the mysql command
mysql_client() {
  container_link_and_run_command $1 mysql --no-defaults -h$APP_NAME -P3306 "${@:2}"
}

cleanup_environment() {
  container_remove_full default
  container_remove_full slave0
}

teardown() {
  cleanup_environment
}

# cleanup the environment of any leftover containers and volumes before starting the tests
cleanup_environment

@test "Port 3306 exposed and accepting external connections" {
  container_create default -d

  run container_link_and_run_command default mysqladmin --no-defaults \
    -h$APP_NAME -P3306 -uroot ping
  [[ "$output" =~ "mysqld is alive" ]]
}

@test "Root can login without a password" {
  container_create default -d

  run mysql_client default -uroot -e 'SHOW DATABASES\G;'
  [[ "$output" =~ "Database: mysql" ]]
}

@test "Root user created with custom password" {
  container_create default -d \
    -e MYSQL_ROOT_PASSWORD=$MYSQL_PASSWORD

  run mysql_client default -uroot -p$MYSQL_PASSWORD -e 'SHOW DATABASES\G;'
  [[ "$output" =~ "Database: mysql" ]]
}

@test "Can't set root user password with MYSQL_PASSWORD" {
  run container_create default \
    -e MYSQL_PASSWORD=$MYSQL_PASSWORD
  [[ "$output" =~ "provide the --rootPassword property" ]]
}

@test "Can't specify 'root' in MYSQL_USER" {
  run container_create default \
    -e MYSQL_USER=root
  [[ "$output" =~ "'root' user is created by default" ]]
}

@test "Root user has access to admin database" {
  container_create default -d \
    -e MYSQL_ROOT_PASSWORD=$MYSQL_PASSWORD

  run mysql_client default -uroot -p$MYSQL_PASSWORD mysql -e 'SHOW TABLES\G;'
  [[ "$output" =~ "Tables_in_mysql: user" ]]
}

@test "Can create custom database" {
  container_create default -d \
    -e MYSQL_DATABASE=$MYSQL_DATABASE

  run mysql_client default -uroot -e "SHOW DATABASES\G"
  [[ "$output" =~ "Database: $MYSQL_DATABASE" ]]
}

@test "Can create custom database with '-' character in the name" {
  container_create default -d \
    -e MYSQL_DATABASE=my-db

  run mysql_client default -uroot -e "SHOW DATABASES\G"
  [[ "$output" =~ "Database: my-db" ]]
}

@test "Can create custom database with password for root" {
  container_create default -d \
    -e MYSQL_ROOT_PASSWORD=$MYSQL_PASSWORD \
    -e MYSQL_DATABASE=$MYSQL_DATABASE

  run mysql_client default -uroot -p$MYSQL_PASSWORD -e "SHOW DATABASES\G"
  [[ "$output" =~ "Database: $MYSQL_DATABASE" ]]
}

@test "Can't create custom user without database" {
  run container_create default \
    -e MYSQL_USER=$MYSQL_USER
  [[ "$output" =~ "provide the --database property as well" ]]
}

@test "Custom user created without password" {
  container_create default -d \
    -e MYSQL_USER=$MYSQL_USER \
    -e MYSQL_DATABASE=$MYSQL_DATABASE

  run mysql_client default -u$MYSQL_USER -e "SHOW DATABASES\G"
  [[ "$output" =~ "Database: $MYSQL_DATABASE" ]]
}

@test "Custom user created with password" {
  container_create default -d \
    -e MYSQL_USER=$MYSQL_USER \
    -e MYSQL_PASSWORD=$MYSQL_PASSWORD \
    -e MYSQL_DATABASE=$MYSQL_DATABASE

  run mysql_client default -u$MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES\G"
  [[ "$output" =~ "Database: $MYSQL_DATABASE" ]]
}

@test "Custom user can't access admin database" {
  container_create default -d \
    -e MYSQL_USER=$MYSQL_USER \
    -e MYSQL_PASSWORD=$MYSQL_PASSWORD \
    -e MYSQL_DATABASE=$MYSQL_DATABASE

  run mysql_client default -u$MYSQL_USER -p$MYSQL_PASSWORD mysql -e 'SHOW TABLES\G;'
  [[ "$output" =~ "Access denied for user" ]]
}

@test "Can set root password and create custom user without password" {
  container_create default -d \
    -e MYSQL_ROOT_PASSWORD=$MYSQL_PASSWORD \
    -e MYSQL_USER=$MYSQL_USER \
    -e MYSQL_DATABASE=$MYSQL_DATABASE

  run mysql_client default -uroot -p$MYSQL_PASSWORD -e "SHOW DATABASES\G"
  [[ "$output" =~ "Database: mysql" ]]

  run mysql_client default -u$MYSQL_USER -e "SHOW DATABASES\G"
  [[ "$output" =~ "Database: $MYSQL_DATABASE" ]]
}

@test "Can set root password and create custom user with password" {
  container_create default -d \
    -e MYSQL_ROOT_PASSWORD=$MYSQL_PASSWORD \
    -e MYSQL_USER=$MYSQL_USER \
    -e MYSQL_PASSWORD=$MYSQL_PASSWORD \
    -e MYSQL_DATABASE=$MYSQL_DATABASE

  run mysql_client default -uroot -p$MYSQL_PASSWORD -e "SHOW DATABASES\G"
  [[ "$output" =~ "Database: mysql" ]]

  run mysql_client default -u$MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES\G"
  [[ "$output" =~ "Database: $MYSQL_DATABASE" ]]
}

@test "Data is preserved on container restart" {
  container_create default -d \
    -e MYSQL_USER=$MYSQL_USER \
    -e MYSQL_PASSWORD=$MYSQL_PASSWORD \
    -e MYSQL_DATABASE=$MYSQL_DATABASE

  container_restart default

  run mysql_client default -u$MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES\G"
  [[ "$output" =~ "Database: $MYSQL_DATABASE" ]]
}

@test "All the volumes exposed" {
  container_create default -d

  run container_inspect default --format {{.Mounts}}
  [[ "$output" =~ "$VOL_PREFIX" ]]
}

@test "Data gets generated in volume if bind mounted in the host" {
  container_create_with_host_volumes default -d

  run container_exec default ls -la $VOL_PREFIX/data/
  [[ "$output" =~ "mysql" ]]
  [[ "$output" =~ "ibdata1" ]]

  run container_exec default ls -la $VOL_PREFIX/conf/
  [[ "$output" =~ "my.cnf" ]]
}

@test "If host mounted, password and settings are preserved after deletion" {
  container_create_with_host_volumes default -d \
    -e MYSQL_USER=$MYSQL_USER \
    -e MYSQL_PASSWORD=$MYSQL_PASSWORD \
    -e MYSQL_DATABASE=$MYSQL_DATABASE

  container_remove default
  container_create_with_host_volumes default -d

  run mysql_client default -u$MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES\G"
  [[ "$output" =~ "Database: $MYSQL_DATABASE" ]]
}

@test "Can't setup replication master without creating a replication user" {
  run container_create default \
    -e MYSQL_REPLICATION_MODE=master
  [[ "$output" =~ "provide the --replicationUser property as well" ]]
}

@test "Can't setup replication slave without specifying the master host" {
  run container_create slave0 \
    -e MYSQL_REPLICATION_MODE=slave
  [[ "$output" =~ "provide the --masterHost property as well" ]]
}

@test "Can't setup replication slave without database" {
  run container_create slave0 \
    -e MYSQL_REPLICATION_MODE=slave \
    -e MYSQL_MASTER_HOST=master
  [[ "$output" =~ "provide the --database property as well" ]]
}

@test "Can't setup replication slave without replication user" {
  run container_create slave0 \
    -e MYSQL_REPLICATION_MODE=slave \
    -e MYSQL_MASTER_HOST=master \
    -e MYSQL_DATABASE=$MYSQL_DATABASE
  [[ "$output" =~ "provide the --replicationUser property as well" ]]
}

@test "Can setup master/slave replication with minimal configuration" {
  container_create default -d \
    -e MYSQL_REPLICATION_MODE=master \
    -e MYSQL_REPLICATION_USER=$MYSQL_REPLICATION_USER \
    -e MYSQL_DATABASE=$MYSQL_DATABASE

  container_create slave0 -d \
    $(container_link default $CONTAINER_NAME) \
    -e MYSQL_REPLICATION_MODE=slave \
    -e MYSQL_REPLICATION_USER=$MYSQL_REPLICATION_USER \
    -e MYSQL_MASTER_HOST=$CONTAINER_NAME \
    -e MYSQL_DATABASE=$MYSQL_DATABASE

  mysql_client default -uroot $MYSQL_DATABASE -e \
    "CREATE TABLE users (id INT AUTO_INCREMENT, name VARCHAR(30), datum TIMESTAMP DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY(id)); \
     INSERT INTO users(name) VALUES ('Marko');"

  run mysql_client slave0 -uroot $MYSQL_DATABASE -e "SELECT * FROM users\G"
  [[ "$output" =~ "name: Marko" ]]
}

@test "Can setup master/slave replication with root password" {
  container_create default -d \
    -e MYSQL_REPLICATION_MODE=master \
    -e MYSQL_REPLICATION_USER=$MYSQL_REPLICATION_USER \
    -e MYSQL_REPLICATION_PASSWORD=$MYSQL_REPLICATION_PASSWORD \
    -e MYSQL_ROOT_PASSWORD=$MYSQL_PASSWORD \
    -e MYSQL_DATABASE=$MYSQL_DATABASE

  container_create slave0 -d \
    $(container_link default $CONTAINER_NAME) \
    -e MYSQL_REPLICATION_MODE=slave \
    -e MYSQL_REPLICATION_USER=$MYSQL_REPLICATION_USER \
    -e MYSQL_REPLICATION_PASSWORD=$MYSQL_REPLICATION_PASSWORD \
    -e MYSQL_MASTER_HOST=$CONTAINER_NAME \
    -e MYSQL_MASTER_PASSWORD=$MYSQL_PASSWORD \
    -e MYSQL_ROOT_PASSWORD=$MYSQL_PASSWORD \
    -e MYSQL_DATABASE=$MYSQL_DATABASE

  mysql_client default -uroot -p$MYSQL_PASSWORD $MYSQL_DATABASE -e \
    "CREATE TABLE users (id INT AUTO_INCREMENT, name VARCHAR(30), datum TIMESTAMP DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY(id)); \
     INSERT INTO users(name) VALUES ('Marko');"

  run mysql_client slave0 -uroot -p$MYSQL_PASSWORD $MYSQL_DATABASE -e "SELECT * FROM users\G"
  [[ "$output" =~ "name: Marko" ]]
}

@test "Can setup master/slave replication using a custom master port" {
  container_create default -d -p 3306 \
    -e MYSQL_REPLICATION_MODE=master \
    -e MYSQL_REPLICATION_USER=$MYSQL_REPLICATION_USER \
    -e MYSQL_REPLICATION_PASSWORD=$MYSQL_REPLICATION_PASSWORD \
    -e MYSQL_ROOT_PASSWORD=$MYSQL_PASSWORD \
    -e MYSQL_DATABASE=$MYSQL_DATABASE

  MASTER_HOST=$(container_exec default ip route list | grep ^default | awk '{print $3}')
  MASTER_PORT=$(docker port $CONTAINER_NAME-default 3306/tcp | cut -d':' -f2)
  container_create slave0 -d \
    -e MYSQL_REPLICATION_MODE=slave \
    -e MYSQL_REPLICATION_USER=$MYSQL_REPLICATION_USER \
    -e MYSQL_REPLICATION_PASSWORD=$MYSQL_REPLICATION_PASSWORD \
    -e MYSQL_MASTER_HOST=$MASTER_HOST \
    -e MYSQL_MASTER_PORT=$MASTER_PORT \
    -e MYSQL_MASTER_PASSWORD=$MYSQL_PASSWORD \
    -e MYSQL_ROOT_PASSWORD=$MYSQL_PASSWORD \
    -e MYSQL_DATABASE=$MYSQL_DATABASE

  mysql_client default -uroot -p$MYSQL_PASSWORD $MYSQL_DATABASE -e \
    "CREATE TABLE users (id INT AUTO_INCREMENT, name VARCHAR(30), datum TIMESTAMP DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY(id)); \
     INSERT INTO users(name) VALUES ('Marko');"

  run mysql_client slave0 -uroot -p$MYSQL_PASSWORD $MYSQL_DATABASE -e "SELECT * FROM users\G"
  [[ "$output" =~ "name: Marko" ]]
}

@test "Can setup master/slave replication with password for replication user" {
  container_create default -d \
    -e MYSQL_REPLICATION_MODE=master \
    -e MYSQL_REPLICATION_USER=$MYSQL_REPLICATION_USER \
    -e MYSQL_REPLICATION_PASSWORD=$MYSQL_REPLICATION_PASSWORD \
    -e MYSQL_ROOT_PASSWORD=$MYSQL_PASSWORD \
    -e MYSQL_DATABASE=$MYSQL_DATABASE

  container_create slave0 -d \
    $(container_link default $CONTAINER_NAME) \
    -e MYSQL_REPLICATION_MODE=slave \
    -e MYSQL_REPLICATION_USER=$MYSQL_REPLICATION_USER \
    -e MYSQL_REPLICATION_PASSWORD=$MYSQL_REPLICATION_PASSWORD \
    -e MYSQL_MASTER_HOST=$CONTAINER_NAME \
    -e MYSQL_MASTER_PASSWORD=$MYSQL_PASSWORD \
    -e MYSQL_ROOT_PASSWORD=$MYSQL_PASSWORD \
    -e MYSQL_DATABASE=$MYSQL_DATABASE

  mysql_client default -uroot -p$MYSQL_PASSWORD $MYSQL_DATABASE -e \
    "CREATE TABLE users (id INT AUTO_INCREMENT, name VARCHAR(30), datum TIMESTAMP DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY(id)); \
     INSERT INTO users(name) VALUES ('Marko');"

  run mysql_client slave0 -uroot -p$MYSQL_PASSWORD $MYSQL_DATABASE -e "SELECT * FROM users\G"
  [[ "$output" =~ "name: Marko" ]]
}

@test "Can setup master/slave replication with custom user without password" {
  container_create default -d \
    -e MYSQL_REPLICATION_MODE=master \
    -e MYSQL_REPLICATION_USER=$MYSQL_REPLICATION_USER \
    -e MYSQL_REPLICATION_PASSWORD=$MYSQL_REPLICATION_PASSWORD \
    -e MYSQL_USER=$MYSQL_USER \
    -e MYSQL_DATABASE=$MYSQL_DATABASE

  container_create slave0 -d \
    $(container_link default $CONTAINER_NAME) \
    -e MYSQL_REPLICATION_MODE=slave \
    -e MYSQL_REPLICATION_USER=$MYSQL_REPLICATION_USER \
    -e MYSQL_REPLICATION_PASSWORD=$MYSQL_REPLICATION_PASSWORD \
    -e MYSQL_MASTER_HOST=$CONTAINER_NAME \
    -e MYSQL_MASTER_USER=$MYSQL_USER \
    -e MYSQL_USER=$MYSQL_USER \
    -e MYSQL_DATABASE=$MYSQL_DATABASE

  mysql_client default -u$MYSQL_USER $MYSQL_DATABASE -e \
    "CREATE TABLE users (id INT AUTO_INCREMENT, name VARCHAR(30), datum TIMESTAMP DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY(id)); \
     INSERT INTO users(name) VALUES ('Marko');"

  run mysql_client slave0 -u$MYSQL_USER $MYSQL_DATABASE -e "SELECT * FROM users\G"
  [[ "$output" =~ "name: Marko" ]]
}

@test "Can setup master/slave replication with custom user and password" {
  container_create default -d \
    -e MYSQL_REPLICATION_MODE=master \
    -e MYSQL_REPLICATION_USER=$MYSQL_REPLICATION_USER \
    -e MYSQL_REPLICATION_PASSWORD=$MYSQL_REPLICATION_PASSWORD \
    -e MYSQL_USER=$MYSQL_USER \
    -e MYSQL_PASSWORD=$MYSQL_PASSWORD \
    -e MYSQL_DATABASE=$MYSQL_DATABASE

  container_create slave0 -d \
    $(container_link default $CONTAINER_NAME) \
    -e MYSQL_REPLICATION_MODE=slave \
    -e MYSQL_REPLICATION_USER=$MYSQL_REPLICATION_USER \
    -e MYSQL_REPLICATION_PASSWORD=$MYSQL_REPLICATION_PASSWORD \
    -e MYSQL_MASTER_HOST=$CONTAINER_NAME \
    -e MYSQL_MASTER_USER=$MYSQL_USER \
    -e MYSQL_MASTER_PASSWORD=$MYSQL_PASSWORD \
    -e MYSQL_USER=$MYSQL_USER \
    -e MYSQL_PASSWORD=$MYSQL_PASSWORD \
    -e MYSQL_DATABASE=$MYSQL_DATABASE

  mysql_client default -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE -e \
    "CREATE TABLE users (id INT AUTO_INCREMENT, name VARCHAR(30), datum TIMESTAMP DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY(id)); \
     INSERT INTO users(name) VALUES ('Marko');"

  run mysql_client slave0 -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE -e "SELECT * FROM users\G"
  [[ "$output" =~ "name: Marko" ]]
}

@test "Slave synchronizes with the master (delayed start)" {
  container_create default -d \
    -e MYSQL_REPLICATION_MODE=master \
    -e MYSQL_REPLICATION_USER=$MYSQL_REPLICATION_USER \
    -e MYSQL_REPLICATION_PASSWORD=$MYSQL_REPLICATION_PASSWORD \
    -e MYSQL_USER=$MYSQL_USER \
    -e MYSQL_PASSWORD=$MYSQL_PASSWORD \
    -e MYSQL_DATABASE=$MYSQL_DATABASE

  mysql_client default -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE -e \
    "CREATE TABLE users (id INT AUTO_INCREMENT, name VARCHAR(30), datum TIMESTAMP DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY(id)); \
     INSERT INTO users(name) VALUES ('Marko');"

  container_create slave0 -d \
    $(container_link default $CONTAINER_NAME) \
    -e MYSQL_REPLICATION_MODE=slave \
    -e MYSQL_REPLICATION_USER=$MYSQL_REPLICATION_USER \
    -e MYSQL_REPLICATION_PASSWORD=$MYSQL_REPLICATION_PASSWORD \
    -e MYSQL_MASTER_HOST=$CONTAINER_NAME \
    -e MYSQL_MASTER_USER=$MYSQL_USER \
    -e MYSQL_MASTER_PASSWORD=$MYSQL_PASSWORD \
    -e MYSQL_USER=$MYSQL_USER \
    -e MYSQL_PASSWORD=$MYSQL_PASSWORD \
    -e MYSQL_DATABASE=$MYSQL_DATABASE

  run mysql_client slave0 -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE -e "SELECT * FROM users\G"
  [[ "$output" =~ "name: Marko" ]]
}

@test "Replication setup and state is preserved after restart" {
  container_create_with_host_volumes default -d \
    -e MYSQL_REPLICATION_MODE=master \
    -e MYSQL_REPLICATION_USER=$MYSQL_REPLICATION_USER \
    -e MYSQL_REPLICATION_PASSWORD=$MYSQL_REPLICATION_PASSWORD \
    -e MYSQL_USER=$MYSQL_USER \
    -e MYSQL_PASSWORD=$MYSQL_PASSWORD \
    -e MYSQL_DATABASE=$MYSQL_DATABASE

  mysql_client default -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE -e \
    "CREATE TABLE users (id INT AUTO_INCREMENT, name VARCHAR(30), datum TIMESTAMP DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY(id)); \
     INSERT INTO users(name) VALUES ('Marko');"

  container_create_with_host_volumes slave0 -d \
    $(container_link default $CONTAINER_NAME) \
    -e MYSQL_REPLICATION_MODE=slave \
    -e MYSQL_REPLICATION_USER=$MYSQL_REPLICATION_USER \
    -e MYSQL_REPLICATION_PASSWORD=$MYSQL_REPLICATION_PASSWORD \
    -e MYSQL_MASTER_HOST=$CONTAINER_NAME \
    -e MYSQL_MASTER_USER=$MYSQL_USER \
    -e MYSQL_MASTER_PASSWORD=$MYSQL_PASSWORD \
    -e MYSQL_USER=$MYSQL_USER \
    -e MYSQL_PASSWORD=$MYSQL_PASSWORD \
    -e MYSQL_DATABASE=$MYSQL_DATABASE

  container_restart default
  container_restart slave0

  mysql_client default -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE -e "INSERT INTO users(name) VALUES ('Polo')"

  run mysql_client slave0 -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE -e "SELECT * FROM users\G"
  [[ "$output" =~ "name: Marko" ]]
  [[ "$output" =~ "name: Polo" ]]
}

@test "Slave recovers if master is temporarily offine" {
  container_create_with_host_volumes default -d \
    -e MYSQL_REPLICATION_MODE=master \
    -e MYSQL_REPLICATION_USER=$MYSQL_REPLICATION_USER \
    -e MYSQL_REPLICATION_PASSWORD=$MYSQL_REPLICATION_PASSWORD \
    -e MYSQL_USER=$MYSQL_USER \
    -e MYSQL_PASSWORD=$MYSQL_PASSWORD \
    -e MYSQL_DATABASE=$MYSQL_DATABASE

  mysql_client default -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE -e \
    "CREATE TABLE users (id INT AUTO_INCREMENT, name VARCHAR(30), datum TIMESTAMP DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY(id)); \
     INSERT INTO users(name) VALUES ('Marko');"

  container_create_with_host_volumes slave0 -d \
    $(container_link default $CONTAINER_NAME) \
    -e MYSQL_REPLICATION_MODE=slave \
    -e MYSQL_REPLICATION_USER=$MYSQL_REPLICATION_USER \
    -e MYSQL_REPLICATION_PASSWORD=$MYSQL_REPLICATION_PASSWORD \
    -e MYSQL_MASTER_HOST=$CONTAINER_NAME \
    -e MYSQL_MASTER_USER=$MYSQL_USER \
    -e MYSQL_MASTER_PASSWORD=$MYSQL_PASSWORD \
    -e MYSQL_USER=$MYSQL_USER \
    -e MYSQL_PASSWORD=$MYSQL_PASSWORD \
    -e MYSQL_DATABASE=$MYSQL_DATABASE

  container_restart default

  mysql_client default -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE -e "INSERT INTO users(name) VALUES ('Polo')"

  # wait for slave to sync
  sleep 60

  run mysql_client slave0 -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE -e "SELECT * FROM users\G"
  [[ "$output" =~ "name: Marko" ]]
  [[ "$output" =~ "name: Polo" ]]
}

@test "Replication setup and state is preserved after deletion" {
  container_create_with_host_volumes default -d \
    -e MYSQL_REPLICATION_MODE=master \
    -e MYSQL_REPLICATION_USER=$MYSQL_REPLICATION_USER \
    -e MYSQL_REPLICATION_PASSWORD=$MYSQL_REPLICATION_PASSWORD \
    -e MYSQL_USER=$MYSQL_USER \
    -e MYSQL_PASSWORD=$MYSQL_PASSWORD \
    -e MYSQL_DATABASE=$MYSQL_DATABASE

  mysql_client default -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE -e \
    "CREATE TABLE users (id INT AUTO_INCREMENT, name VARCHAR(30), datum TIMESTAMP DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY(id)); \
     INSERT INTO users(name) VALUES ('Marko');"

  container_create_with_host_volumes slave0 -d \
    $(container_link default $CONTAINER_NAME) \
    -e MYSQL_REPLICATION_MODE=slave \
    -e MYSQL_REPLICATION_USER=$MYSQL_REPLICATION_USER \
    -e MYSQL_REPLICATION_PASSWORD=$MYSQL_REPLICATION_PASSWORD \
    -e MYSQL_MASTER_HOST=$CONTAINER_NAME \
    -e MYSQL_MASTER_USER=$MYSQL_USER \
    -e MYSQL_MASTER_PASSWORD=$MYSQL_PASSWORD \
    -e MYSQL_USER=$MYSQL_USER \
    -e MYSQL_PASSWORD=$MYSQL_PASSWORD \
    -e MYSQL_DATABASE=$MYSQL_DATABASE

  container_remove default
  container_remove slave0

  container_create_with_host_volumes default -d \
    -e MYSQL_REPLICATION_MODE=master

  container_create_with_host_volumes slave0 -d \
    $(container_link default $CONTAINER_NAME) \
    -e MYSQL_REPLICATION_MODE=slave \
    -e MYSQL_DATABASE=$MYSQL_DATABASE

  mysql_client default -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE -e "INSERT INTO users(name) VALUES ('Polo')"

  run mysql_client slave0 -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE -e "SELECT * FROM users\G"
  [[ "$output" =~ "name: Marko" ]]
  [[ "$output" =~ "name: Polo" ]]
}
