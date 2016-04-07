#!/usr/bin/env bats

MARIADB_DATABASE=test_database
MARIADB_USER=test_user
MARIADB_PASSWORD=test_password

# source the helper script
APP_NAME=mariadb
SLEEP_TIME=20
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
    -e MARIADB_PASSWORD=$MARIADB_PASSWORD

  run mysql_client default -uroot -p$MARIADB_PASSWORD -e 'SHOW DATABASES\G;'
  [[ "$output" =~ "Database: mysql" ]]
}

@test "Root user has access to admin database" {
  container_create default -d \
    -e MARIADB_PASSWORD=$MARIADB_PASSWORD

  run mysql_client default -uroot -p$MARIADB_PASSWORD mysql -e 'SHOW TABLES\G;'
  [[ "$output" =~ "Tables_in_mysql: user" ]]
}

@test "Root user can create databases" {
  container_create default -d \
    -e MARIADB_PASSWORD=$MARIADB_PASSWORD

  mysql_client default -uroot -p$MARIADB_PASSWORD -e "CREATE DATABASE \`$MARIADB_DATABASE\`;"
  run mysql_client default -uroot -p$MARIADB_PASSWORD -e "SHOW DATABASES\G"
  [[ "$output" =~ "Database: $MARIADB_DATABASE" ]]
}

@test "Root user can create users" {
  container_create default -d \
    -e MARIADB_PASSWORD=$MARIADB_PASSWORD

  mysql_client default -uroot -p$MARIADB_PASSWORD -e "CREATE USER '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_PASSWORD';"
  mysql_client default -uroot -p$MARIADB_PASSWORD -e "CREATE DATABASE \`$MARIADB_DATABASE\`;"
  mysql_client default -uroot -p$MARIADB_PASSWORD -e "GRANT ALL ON \`$MARIADB_DATABASE\`.* TO \`$MARIADB_USER\`@'%' ;"

  run mysql_client default -u$MARIADB_USER -p$MARIADB_PASSWORD -e "SHOW DATABASES\G"
  [[ "$output" =~ "Database: $MARIADB_DATABASE" ]]
}

@test "Data is preserved on container restart" {
  container_create default -d \
    -e MARIADB_PASSWORD=$MARIADB_PASSWORD

  mysql_client default -uroot -p$MARIADB_PASSWORD -e "CREATE USER '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_PASSWORD';"
  mysql_client default -uroot -p$MARIADB_PASSWORD -e "CREATE DATABASE \`$MARIADB_DATABASE\`;"
  mysql_client default -uroot -p$MARIADB_PASSWORD -e "GRANT ALL ON \`$MARIADB_DATABASE\`.* TO \`$MARIADB_USER\`@'%' ;"

  container_restart default

  run mysql_client default -u$MARIADB_USER -p$MARIADB_PASSWORD -e "SHOW DATABASES\G"
  [[ "$output" =~ "Database: $MARIADB_DATABASE" ]]
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
    -e MARIADB_PASSWORD=$MARIADB_PASSWORD

  container_remove default
  container_create_with_host_volumes default -d

  run mysql_client default -uroot -p$MARIADB_PASSWORD -e "SHOW DATABASES\G"
  [[ "$output" =~ "Database: mysql" ]]
}
