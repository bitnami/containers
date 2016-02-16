#!/usr/bin/env bats

MARIADB_DATABASE=test_database
MARIADB_USER=test_user
MARIADB_PASSWORD=test_password
MARIADB_REPLICATION_USER=repl_user
MARIADB_REPLICATION_PASSWORD=repl_password

# source the helper script
APP_NAME=mariadb
SLEEP_TIME=10
load tests/docker_helper

# Link to container and execute mysql client
# $1 : name of the container to link to
# ${@:2} : arguments for the mysql command
mysql_client() {
  container_link_and_run_command $1 mysql --no-defaults -h $APP_NAME -P 3306 "${@:2}"
}

cleanup_environment() {
  container_remove_full slave0
  container_remove_full master
  container_remove_full standalone
}

teardown() {
  cleanup_environment
}

# cleanup the environment of any leftover containers and volumes before starting the tests
cleanup_environment

@test "Port 3306 exposed and accepting external connections" {
  container_create standalone -d

  # ping mysqld server
  run container_link_and_run_command standalone mysqladmin --no-defaults -h $APP_NAME -P 3306 ping
  [[ "$output" =~ "mysqld is alive" ]]
}

@test "Root user created without password" {
  container_create standalone -d

  # auth as root user and list all databases
  run mysql_client standalone -uroot -e 'SHOW DATABASES\G;'
  [[ "$output" =~ "Database: mysql" ]]
}

@test "Root user created with password" {
  container_create standalone -d \
    -e MARIADB_PASSWORD=$MARIADB_PASSWORD

  # cannot auth as root without password
  run mysql_client standalone -uroot -e "SHOW DATABASES\G"
  [[ "$output" =~ "Access denied for user" ]]

  # auth as root with password and list all databases
  run mysql_client standalone -uroot -p$MARIADB_PASSWORD -e "SHOW DATABASES\G"
  [[ "$output" =~ "Database: mysql" ]]
}

@test "Root user has access to admin database" {
  container_create standalone -d
  run mysql_client standalone -uroot -e "SHOW DATABASES\G"
  [[ "$output" =~ 'Database: mysql' ]]
}

@test "Custom database created" {
  container_create standalone -d \
    -e MARIADB_DATABASE=$MARIADB_DATABASE

  # auth as root and check if MARIADB_DATABASE exists
  run mysql_client standalone -uroot -e "SHOW DATABASES\G"
  [[ "$output" =~ "Database: $MARIADB_DATABASE" ]]
}

@test "Can't create a custom user without database" {
  # create container without specifying MARIADB_DATABASE
  run container_create standalone \
    -e MARIADB_USER=$MARIADB_USER
  [[ "$output" =~ "you need to provide the MARIADB_DATABASE" ]]
}

@test "Create custom user and database without password" {
  container_create standalone -d \
    -e MARIADB_USER=$MARIADB_USER \
    -e MARIADB_DATABASE=$MARIADB_DATABASE

  # cannot auth as root
  run mysql_client standalone -uroot -e "SHOW DATABASES\G"
  [[ "$output" =~ "Access denied for user" ]]

  # auth as MARIADB_USER and check of MARIADB_DATABASE exists
  run mysql_client standalone -u$MARIADB_USER -e "SHOW DATABASES\G"
  [[ "$output" =~ "Database: $MARIADB_DATABASE" ]]
}

@test "Create custom user and database with password" {
  container_create standalone -d \
    -e MARIADB_USER=$MARIADB_USER \
    -e MARIADB_DATABASE=$MARIADB_DATABASE \
    -e MARIADB_PASSWORD=$MARIADB_PASSWORD

  # auth as MARIADB_USER with password and check if MARIADB_DATABASE exists
  run mysql_client standalone -u$MARIADB_USER -p$MARIADB_PASSWORD -e "SHOW DATABASES\G"
  [[ "$output" =~ "Database: $MARIADB_DATABASE" ]]
}

@test "User and password settings are preserved after restart" {
  container_create standalone -d \
    -e MARIADB_USER=$MARIADB_USER \
    -e MARIADB_DATABASE=$MARIADB_DATABASE \
    -e MARIADB_PASSWORD=$MARIADB_PASSWORD

  # restart container
  container_restart standalone

  # get container logs
  run container_logs standalone
  [[ "$output" =~ "The credentials were set on first boot." ]]

  # auth as MARIADB_USER and check if MARIADB_DATABASE exists
  run mysql_client standalone -u$MARIADB_USER -p$MARIADB_PASSWORD -e "SHOW DATABASES\G"
  [[ "$output" =~ "Database: $MARIADB_DATABASE" ]]
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
    -e MARIADB_USER=$MARIADB_USER \
    -e MARIADB_DATABASE=$MARIADB_DATABASE \
    -e MARIADB_PASSWORD=$MARIADB_PASSWORD

  # files expected in conf volume
  run container_exec standalone ls -la $VOL_PREFIX/conf/
  [[ "$output" =~ "my.cnf" ]]

  # files expected in data volume (subset)
  run container_exec standalone ls -la $VOL_PREFIX/data/
  [[ "$output" =~ "mysql" ]]
  [[ "$output" =~ "ibdata1" ]]

  # files expected in logs volume
  run container_exec standalone ls -la $VOL_PREFIX/logs/
  [[ "$output" =~ "mysqld.log" ]]
}

@test "If host mounted, password and settings are preserved after deletion" {
  container_create_with_host_volumes standalone -d \
    -e MARIADB_USER=$MARIADB_USER \
    -e MARIADB_DATABASE=$MARIADB_DATABASE \
    -e MARIADB_PASSWORD=$MARIADB_PASSWORD

  # stop and remove container
  container_remove standalone

  # recreate container without specifying any env parameters
  container_create_with_host_volumes standalone -d

  # auth as MARIADB_USER and check of MARIADB_DATABASE exists
  run mysql_client standalone -u$MARIADB_USER -p$MARIADB_PASSWORD -e "SHOW DATABASES\G"
  [[ "$output" =~ "Database: $MARIADB_DATABASE" ]]
}

@test "Configuration changes are preserved after deletion" {
  container_create_with_host_volumes standalone -d

  # modify my.cnf
  container_exec standalone sed -i 's|^[#]*[ ]*max_allowed_packet[ ]*=.*|max_allowed_packet=64M|' $VOL_PREFIX/conf/my.cnf
  container_exec standalone sed -i 's|^[#]*[ ]*bind-address[ ]*=.*|bind-address=0.0.0.0|' $VOL_PREFIX/conf/my.cnf

  # stop and remove container
  container_remove standalone

  # relaunch container with host volumes
  container_create_with_host_volumes standalone -d

  run container_exec standalone cat $VOL_PREFIX/conf/my.cnf
  [[ "$output" =~ "max_allowed_packet=64M" ]]
  [[ "$output" =~ "bind-address=0.0.0.0" ]]
}

@test "Can't setup replication master without replication user" {
  # create replication master without specifying MARIADB_REPLICATION_USER
  run container_create master \
    -e MARIADB_USER=$MARIADB_USER \
    -e MARIADB_PASSWORD=$MARIADB_PASSWORD \
    -e MARIADB_DATABASE=$MARIADB_DATABASE \
    -e MARIADB_REPLICATION_MODE=master
  [[ "$output" =~ "you need to provide the MARIADB_REPLICATION_USER" ]]
}

@test "Can't setup replication slave without master host" {
  # create replication slave without specifying MARIADB_MASTER_HOST
  run container_create slave0 \
    -e MARIADB_REPLICATION_MODE=slave
  [[ "$output" =~ "you need to provide the MARIADB_MASTER_HOST" ]]
}

@test "Can't setup replication slave without database" {
  # create replication slave without specifying MARIADB_DATABASE
  run container_create slave0 \
    -e MARIADB_REPLICATION_MODE=slave \
    -e MARIADB_MASTER_HOST=master \
    -e MARIADB_MASTER_USER=$MARIADB_USER
  [[ "$output" =~ "you need to provide the MARIADB_DATABASE" ]]
}

@test "Can't setup replication slave without replication user" {
  # create replication slave without specifying MARIADB_REPLICATION_USER
  run container_create slave0 \
    -e MARIADB_REPLICATION_MODE=slave \
    -e MARIADB_MASTER_HOST=master \
    -e MARIADB_MASTER_USER=$MARIADB_USER \
    -e MARIADB_DATABASE=$MARIADB_DATABASE
  [[ "$output" =~ "you need to provide the MARIADB_REPLICATION_USER" ]]
}

@test "Master database is replicated on slave" {
  container_create master -d \
    -e MARIADB_USER=$MARIADB_USER \
    -e MARIADB_PASSWORD=$MARIADB_PASSWORD \
    -e MARIADB_DATABASE=$MARIADB_DATABASE \
    -e MARIADB_REPLICATION_MODE=master \
    -e MARIADB_REPLICATION_USER=$MARIADB_REPLICATION_USER \
    -e MARIADB_REPLICATION_PASSWORD=$MARIADB_REPLICATION_PASSWORD

  container_create slave0 -d \
    $(container_link master $CONTAINER_NAME) \
    -e MARIADB_MASTER_HOST=$CONTAINER_NAME \
    -e MARIADB_MASTER_USER=$MARIADB_USER \
    -e MARIADB_MASTER_PASSWORD=$MARIADB_PASSWORD \
    -e MARIADB_USER=$MARIADB_USER \
    -e MARIADB_PASSWORD=$MARIADB_PASSWORD \
    -e MARIADB_DATABASE=$MARIADB_DATABASE \
    -e MARIADB_REPLICATION_MODE=slave \
    -e MARIADB_REPLICATION_USER=$MARIADB_REPLICATION_USER \
    -e MARIADB_REPLICATION_PASSWORD=$MARIADB_REPLICATION_PASSWORD

  # create users table on master and insert a record
  mysql_client master -u$MARIADB_USER -p$MARIADB_PASSWORD $MARIADB_DATABASE -e \
    "CREATE TABLE users (id INT AUTO_INCREMENT, name VARCHAR(30), datum TIMESTAMP DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY(id)); \
     INSERT INTO users(name) VALUES ('Marko');"

  # verify that record is replicated on slave0
  run mysql_client slave0 -u$MARIADB_USER -p$MARIADB_PASSWORD $MARIADB_DATABASE -e "SELECT * FROM users\G"
  [[ "$output" =~ "name: Marko" ]]
}

@test "Can setup replication without password for replication user" {
  container_create master -d \
    -e MARIADB_USER=$MARIADB_USER \
    -e MARIADB_PASSWORD=$MARIADB_PASSWORD \
    -e MARIADB_DATABASE=$MARIADB_DATABASE \
    -e MARIADB_REPLICATION_MODE=master \
    -e MARIADB_REPLICATION_USER=$MARIADB_REPLICATION_USER

  container_create slave0 -d \
    $(container_link master $CONTAINER_NAME) \
    -e MARIADB_MASTER_HOST=$CONTAINER_NAME \
    -e MARIADB_MASTER_USER=$MARIADB_USER \
    -e MARIADB_MASTER_PASSWORD=$MARIADB_PASSWORD \
    -e MARIADB_USER=$MARIADB_USER \
    -e MARIADB_PASSWORD=$MARIADB_PASSWORD \
    -e MARIADB_DATABASE=$MARIADB_DATABASE \
    -e MARIADB_REPLICATION_MODE=slave \
    -e MARIADB_REPLICATION_USER=$MARIADB_REPLICATION_USER

  # create users table on master and insert a record
  mysql_client master -u$MARIADB_USER -p$MARIADB_PASSWORD $MARIADB_DATABASE -e \
    "CREATE TABLE users (id INT AUTO_INCREMENT, name VARCHAR(30), datum TIMESTAMP DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY(id)); \
     INSERT INTO users(name) VALUES ('Marko');"

  # verify that record is replicated on slave0
  run mysql_client slave0 -u$MARIADB_USER -p$MARIADB_PASSWORD $MARIADB_DATABASE -e "SELECT * FROM users\G"
  [[ "$output" =~ "name: Marko" ]]
}

@test "Replication slave can fetch replication parameters from link alias \"master\"" {
  container_create master -d \
    -e MARIADB_USER=$MARIADB_USER \
    -e MARIADB_PASSWORD=$MARIADB_PASSWORD \
    -e MARIADB_DATABASE=$MARIADB_DATABASE \
    -e MARIADB_REPLICATION_MODE=master \
    -e MARIADB_REPLICATION_USER=$MARIADB_REPLICATION_USER \
    -e MARIADB_REPLICATION_PASSWORD=$MARIADB_REPLICATION_PASSWORD

  # create replication slave0 linked to master with alias named master
  container_create slave0 -d \
    $(container_link master master) \
    -e MARIADB_REPLICATION_MODE=slave

  # create users table on master and insert a new row
  mysql_client master -u$MARIADB_USER -p$MARIADB_PASSWORD $MARIADB_DATABASE -e \
    "CREATE TABLE users (id INT AUTO_INCREMENT, name VARCHAR(30), datum TIMESTAMP DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY(id)); \
     INSERT INTO users(name) VALUES ('Marko');"

  # check if row is replicated on slave0
  run mysql_client slave0 -u$MARIADB_USER -p$MARIADB_PASSWORD $MARIADB_DATABASE -e "SELECT * FROM users\G"
  [[ "$output" =~ "name: Marko" ]]
}

@test "Slave synchronizes with the master (delayed start)" {
  container_create master -d \
    -e MARIADB_USER=$MARIADB_USER \
    -e MARIADB_PASSWORD=$MARIADB_PASSWORD \
    -e MARIADB_DATABASE=$MARIADB_DATABASE \
    -e MARIADB_REPLICATION_MODE=master \
    -e MARIADB_REPLICATION_USER=$MARIADB_REPLICATION_USER \
    -e MARIADB_REPLICATION_PASSWORD=$MARIADB_REPLICATION_PASSWORD

  # create users table on master and insert a new row
  mysql_client master -u$MARIADB_USER -p$MARIADB_PASSWORD $MARIADB_DATABASE -e \
    "CREATE TABLE users (id INT AUTO_INCREMENT, name VARCHAR(30), datum TIMESTAMP DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY(id)) ;
     INSERT INTO users(name) VALUES ('Marko');"

  # start slave0 linked to the master
  container_create slave0 -d \
    $(container_link master $CONTAINER_NAME) \
    -e MARIADB_MASTER_HOST=$CONTAINER_NAME \
    -e MARIADB_MASTER_USER=$MARIADB_USER \
    -e MARIADB_MASTER_PASSWORD=$MARIADB_PASSWORD \
    -e MARIADB_USER=$MARIADB_USER \
    -e MARIADB_PASSWORD=$MARIADB_PASSWORD \
    -e MARIADB_DATABASE=$MARIADB_DATABASE \
    -e MARIADB_REPLICATION_MODE=slave \
    -e MARIADB_REPLICATION_USER=$MARIADB_REPLICATION_USER \
    -e MARIADB_REPLICATION_PASSWORD=$MARIADB_REPLICATION_PASSWORD

  # verify that master data is replicated on slave
  run mysql_client slave0 -u$MARIADB_USER -p$MARIADB_PASSWORD $MARIADB_DATABASE -e "SELECT * FROM users\G"
  [[ "$output" =~ "name: Marko" ]]
}

@test "Replication status is preserved after deletion" {
  # create master container with host mounted volumes
  container_create_with_host_volumes master -d \
    -e MARIADB_USER=$MARIADB_USER \
    -e MARIADB_PASSWORD=$MARIADB_PASSWORD \
    -e MARIADB_DATABASE=$MARIADB_DATABASE \
    -e MARIADB_REPLICATION_MODE=master \
    -e MARIADB_REPLICATION_USER=$MARIADB_REPLICATION_USER \
    -e MARIADB_REPLICATION_PASSWORD=$MARIADB_REPLICATION_PASSWORD

  # create users table on master and insert a new row
  mysql_client master -u$MARIADB_USER -p$MARIADB_PASSWORD $MARIADB_DATABASE -e \
    "CREATE TABLE users (id INT AUTO_INCREMENT, name VARCHAR(30), datum TIMESTAMP DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY(id)) ;
     INSERT INTO users(name) VALUES ('Marko');"

  # create slave0 container with host mounted volumes, should replicate the master data
  container_create_with_host_volumes slave0 -d \
    $(container_link master $CONTAINER_NAME) \
    -e MARIADB_MASTER_HOST=$CONTAINER_NAME \
    -e MARIADB_MASTER_USER=$MARIADB_USER \
    -e MARIADB_MASTER_PASSWORD=$MARIADB_PASSWORD \
    -e MARIADB_USER=$MARIADB_USER \
    -e MARIADB_PASSWORD=$MARIADB_PASSWORD \
    -e MARIADB_DATABASE=$MARIADB_DATABASE \
    -e MARIADB_REPLICATION_MODE=slave \
    -e MARIADB_REPLICATION_USER=$MARIADB_REPLICATION_USER \
    -e MARIADB_REPLICATION_PASSWORD=$MARIADB_REPLICATION_PASSWORD

  # stop and remove master and slave0 containers
  container_remove master
  container_remove slave0

  # start master and slave0 containers with existing host volumes and no additional env arguments other than MARIADB_REPLICATION_MODE
  container_create_with_host_volumes master -d -e MARIADB_REPLICATION_MODE=master
  container_create_with_host_volumes slave0 -d $(container_link master $CONTAINER_NAME) -e MARIADB_REPLICATION_MODE=slave

  # insert new row into the master database
  mysql_client master -u$MARIADB_USER -p$MARIADB_PASSWORD $MARIADB_DATABASE -e "INSERT INTO users(name) VALUES ('Polo')"

  # verify that all previous and new data is replicated on slave0
  run mysql_client slave0 -u$MARIADB_USER -p$MARIADB_PASSWORD $MARIADB_DATABASE -e "SELECT * FROM users\G"
  [[ "$output" =~ "name: Marko" ]]
  [[ "$output" =~ "name: Polo" ]]
}
