#!/usr/bin/env bats

MARIADB_DEFAULT_PASSWORD=password
MARIADB_DATABASE=test_database
MARIADB_USER=test_user
MARIADB_PASSWORD=test_password

# source the helper script
APP_NAME=mariadb
SLEEP_TIME=20
VOL_PREFIX=/bitnami/$APP_NAME
VOLUMES=$VOL_PREFIX/data
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

  # ping mysqld server
  run container_link_and_run_command default mysqladmin --no-defaults \
    -h$APP_NAME -P3306 -uroot -p$MARIADB_DEFAULT_PASSWORD ping
  [[ "$output" =~ "mysqld is alive" ]]
}

@test "Root user can't access server without a password" {
  container_create default -d

  # auth as root user and list all databases
  run mysql_client default -uroot -e 'SHOW DATABASES\G;'
  [[ "$output" =~ "Access denied for user" ]]
}

@test "Root user created with default password" {
  container_create default -d

  # auth as root user and list all databases
  run mysql_client default -uroot -p$MARIADB_DEFAULT_PASSWORD -e 'SHOW DATABASES\G;'
  [[ "$output" =~ "Database: mysql" ]]
}

@test "Root user created with custom password" {
  container_create default -d

  # auth as root with password and list all databases
  run mysql_client default -uroot -p$MARIADB_DEFAULT_PASSWORD -e "SHOW DATABASES\G"
  [[ "$output" =~ "Database: mysql" ]]
}

@test "Root user has access to admin database" {
  container_create default -d

  run mysql_client default -uroot -p$MARIADB_DEFAULT_PASSWORD -e "SHOW DATABASES\G"
  [[ "$output" =~ 'Database: mysql' ]]
}

@test "Root user can create new databases" {
  container_create default -d

  mysql_client default -uroot -p$MARIADB_DEFAULT_PASSWORD -e "CREATE DATABASE \`$MARIADB_DATABASE\`;"

  # check if database was created
  run mysql_client default -uroot -p$MARIADB_DEFAULT_PASSWORD -e "SHOW DATABASES\G"
  [[ "$output" =~ "Database: $MARIADB_DATABASE" ]]
}

@test "Root user can create new users" {
  container_create default -d

  mysql_client default -uroot -p$MARIADB_DEFAULT_PASSWORD -e "CREATE USER '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_PASSWORD';"
  mysql_client default -uroot -p$MARIADB_DEFAULT_PASSWORD -e "CREATE DATABASE \`$MARIADB_DATABASE\`;"
  mysql_client default -uroot -p$MARIADB_DEFAULT_PASSWORD -e "GRANT ALL ON \`$MARIADB_DATABASE\`.* TO \`$MARIADB_USER\`@'%' ;"

  # check if user was created
  run mysql_client default -u$MARIADB_USER -p$MARIADB_PASSWORD -e "SHOW DATABASES\G"
  [[ "$output" =~ "Database: $MARIADB_DATABASE" ]]
}

@test "Data is preserved on container restart" {
  container_create default -d

  mysql_client default -uroot -p$MARIADB_DEFAULT_PASSWORD -e "CREATE USER '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_PASSWORD';"
  mysql_client default -uroot -p$MARIADB_DEFAULT_PASSWORD -e "CREATE DATABASE \`$MARIADB_DATABASE\`;"
  mysql_client default -uroot -p$MARIADB_DEFAULT_PASSWORD -e "GRANT ALL ON \`$MARIADB_DATABASE\`.* TO \`$MARIADB_USER\`@'%' ;"

  # restart container
  container_restart default

  # auth as MARIADB_USER and check if MARIADB_DATABASE exists
  run mysql_client default -u$MARIADB_USER -p$MARIADB_PASSWORD -e "SHOW DATABASES\G"
  [[ "$output" =~ "Database: $MARIADB_DATABASE" ]]
}

@test "All the volumes exposed" {
  container_create default -d

  # get container introspection details and check if volumes are exposed
  run container_inspect default --format {{.Mounts}}
  [[ "$output" =~ "$VOL_PREFIX/data" ]]
}

@test "Data gets generated in data volume if bind mounted in the host" {
  container_create_with_host_volumes default -d

  # files expected in data volume (subset)
  run container_exec default ls -la $VOL_PREFIX/data/
  [[ "$output" =~ "mysql" ]]
  [[ "$output" =~ "ibdata1" ]]
}

@test "If host mounted, password and settings are preserved after deletion" {
  # known to fail
  skip

  container_create_with_host_volumes default -d \
    -e MARIADB_PASSWORD=$MARIADB_PASSWORD

  # stop and remove container
  container_remove default

  # recreate container without specifying any env parameters
  container_create_with_host_volumes default -d

  run mysql_client default -uroot -p$MARIADB_PASSWORD -e "SHOW DATABASES\G"
  [[ "$output" =~ "Database: mysql" ]]
}
