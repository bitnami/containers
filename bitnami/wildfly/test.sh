#!/usr/bin/env bats

WILDFLY_USER=manager
WILDFLY_DEFAULT_PASSWORD=wildfly
WILDFLY_PASSWORD=test_password

# source the helper script
APP_NAME=wildfly
SLEEP_TIME=5
VOL_PREFIX=/bitnami/$APP_NAME
VOLUMES=/app:$VOL_PREFIX/conf:$VOL_PREFIX/logs
load tests/docker_helper

# Link to container and execute jboss-cli
# $1: name of the container to link to
# ${@:2}: command to execute
jboss_client() {
  container_link_and_run_command $1 jboss-cli.sh --controller=$APP_NAME:9990 "${@:2}"
}

# Cleans up all running/stopped containers and host mounted volumes
cleanup_environment() {
  container_remove_full standalone
  container_remove_full domain
}

# Teardown called at the end of each test
teardown() {
  cleanup_environment
}

# cleanup the environment before starting the tests
cleanup_environment

@test "Ports 8080 and 9990 exposed and accepting external connections" {
  container_create standalone -d

  run curl_client standalone -i http://$APP_NAME:8080
  [[ "$output" =~ '200 OK' ]]

  run curl_client standalone -i http://$APP_NAME:9990
  [[ "$output" =~ '200 OK' ]]

  container_create domain -d \
    -e BITNAMI_APP_DAEMON=domain.sh

  sleep $SLEEP_TIME
  run curl_client domain -i http://$APP_NAME:8080
  [[ "$output" =~ '200 OK' ]]
  run curl_client domain -i http://$APP_NAME:9990
  [[ "$output" =~ '200 OK' ]]
}

@test "Manager has access to management area" {
  container_create standalone -d
  run curl_client standalone -i --digest http://$WILDFLY_USER:$WILDFLY_DEFAULT_PASSWORD@$APP_NAME:9990/management
  [[ "$output" =~ '200 OK' ]]

  container_create domain -d \
    -e BITNAMI_APP_DAEMON=domain.sh

  run curl_client domain -i --digest http://$WILDFLY_USER:$WILDFLY_DEFAULT_PASSWORD@$APP_NAME:9990/management
  [[ "$output" =~ '200 OK' ]]
}

@test "User manager created with custom password" {
  container_create standalone -d \
    -e WILDFLY_PASSWORD=$WILDFLY_PASSWORD

  run curl_client standalone -i --digest http://$WILDFLY_USER:$WILDFLY_PASSWORD@$APP_NAME:9990/management
  [[ "$output" =~ '200 OK' ]]

  container_create domain -d \
    -e BITNAMI_APP_DAEMON=domain.sh \
    -e WILDFLY_PASSWORD=$WILDFLY_PASSWORD

  run curl_client domain -i --digest http://$WILDFLY_USER:$WILDFLY_PASSWORD@$APP_NAME:9990/management
  [[ "$output" =~ '200 OK' ]]
}

@test "Can't access management area without password" {
  container_create standalone -d \
    -e WILDFLY_PASSWORD=$WILDFLY_PASSWORD
  run curl_client standalone -i --digest http://$WILDFLY_USER@$APP_NAME:9990/management
  [[ "$output" =~ '401 Unauthorized' ]]

  container_create domain -d \
    -e BITNAMI_APP_DAEMON=domain.sh \
    -e WILDFLY_PASSWORD=$WILDFLY_PASSWORD
  run curl_client domain -i --digest http://$WILDFLY_USER@$APP_NAME:9990/management
  [[ "$output" =~ '401 Unauthorized' ]]
}

@test "jboss-cli.sh can connect to Wildfly server" {
  container_create standalone -d \
    -e WILDFLY_PASSWORD=$WILDFLY_PASSWORD
  run jboss_client standalone --connect --user=$WILDFLY_USER --password=$WILDFLY_PASSWORD --command=version
  [ $status = 0 ]

  container_create domain -d \
    -e BITNAMI_APP_DAEMON=domain.sh \
    -e WILDFLY_PASSWORD=$WILDFLY_PASSWORD
  run jboss_client domain --connect --user=$WILDFLY_USER --password=$WILDFLY_PASSWORD --command=version
  [ $status = 0 ]
}

@test "jboss-cli.sh can't access Wildfly server without password" {
  container_create standalone -d \
    -e WILDFLY_PASSWORD=$WILDFLY_PASSWORD
  run jboss_client standalone --connect --user=$WILDFLY_USER --command=version
  [[ "$output" =~ "Unable to authenticate against controller" ]]

  container_create domain -d \
    -e BITNAMI_APP_DAEMON=domain.sh \
    -e WILDFLY_PASSWORD=$WILDFLY_PASSWORD
  run jboss_client domain --connect --user=$WILDFLY_USER --command=version
  [[ "$output" =~ "Unable to authenticate against controller" ]]
}

@test "Password is preserved after restart" {
  container_create standalone -d \
    -e WILDFLY_PASSWORD=$WILDFLY_PASSWORD

  # restart container
  container_restart standalone

  # get logs
  run container_logs standalone
  [[ "$output" =~ "The credentials were set on first boot." ]]

  run curl_client standalone -i --digest http://$WILDFLY_USER:$WILDFLY_PASSWORD@$APP_NAME:9990/management
  [[ "$output" =~ '200 OK' ]]

  container_create domain -d \
    -e BITNAMI_APP_DAEMON=domain.sh \
    -e WILDFLY_PASSWORD=$WILDFLY_PASSWORD

  # restart container
  container_restart domain

  # get logs
  run container_logs domain
  [[ "$output" =~ "The credentials were set on first boot." ]]

  run curl_client domain -i --digest http://$WILDFLY_USER:$WILDFLY_PASSWORD@$APP_NAME:9990/management
  [[ "$output" =~ '200 OK' ]]
}

@test "All the volumes exposed" {
  container_create standalone -d
  run container_inspect standalone --format {{.Mounts}}
  [[ "$output" =~ "$VOL_PREFIX/conf" ]]
  [[ "$output" =~ "$VOL_PREFIX/logs" ]]
}

@test "Data gets generated in conf and app volumes if bind mounted in the host" {
  container_create_with_host_volumes standalone -d

  # files expected in conf volume
  run container_exec standalone ls -la $VOL_PREFIX/conf/
  [[ "$output" =~ "domain" ]]
  [[ "$output" =~ "standalone" ]]

  # files expected in app volume (subset)
  run container_exec standalone ls -la /app/
  [[ "$output" =~ ".initialized" ]]
  [[ "$output" =~ "mysql-connector-java" ]]
  [[ "$output" =~ "postgresql" ]]

  # files expected in logs volume
  run container_exec standalone ls -la $VOL_PREFIX/logs/
  [[ "$output" =~ "server.log" ]]
}

@test "If host mounted, password and settings are preserved after deletion" {
  container_create_with_host_volumes standalone -d \
    -e WILDFLY_PASSWORD=$WILDFLY_PASSWORD

  # remove container
  container_remove standalone

  # recreate container without specifying any env parameters
  container_create_with_host_volumes standalone -d

  run curl_client standalone -i --digest http://$WILDFLY_USER:$WILDFLY_PASSWORD@$APP_NAME:9990/management
  [[ "$output" =~ '200 OK' ]]
}

@test "Configuration changes are preserved after deletion" {
  container_create_with_host_volumes standalone -d

  # edit standalone/configuration/standalone.xml
  container_exec standalone sh -c "echo '\n<!-- WINTER IS COMING! -->' >> $VOL_PREFIX/conf/standalone/configuration/standalone.xml"

  # edit domain/configuration/domain.xml
  container_exec standalone sh -c "echo '\n<!-- THE NIGHT IS DARK AND FULL OF TERRORS! -->' >> $VOL_PREFIX/conf/domain/configuration/domain.xml"

  # stop and remove container
  container_remove standalone

  # relaunch container with host volumes
  container_create_with_host_volumes standalone -d

  run container_exec standalone cat $VOL_PREFIX/conf/standalone/configuration/standalone.xml
  [[ "$output" =~ "WINTER IS COMING!" ]]

  run container_exec standalone cat $VOL_PREFIX/conf/domain/configuration/domain.xml
  [[ "$output" =~ "THE NIGHT IS DARK AND FULL OF TERRORS!" ]]
}

@test "Deploy sample application on standalone" {
  container_create_with_host_volumes standalone -d \
    -e WILDFLY_PASSWORD=$WILDFLY_PASSWORD

  # download sample app into the deployments directory and allow it some time to come up
  container_exec standalone curl --noproxy localhost --retry 5 https://raw.githubusercontent.com/goldmann/wildfly-docker-deployment-example/master/node-info.war -o /app/node-info.war
  sleep $SLEEP_TIME

  # test the deployment
  run curl_client standalone -i http://$APP_NAME:8080/node-info/
  [[ "$output" =~ '200 OK' ]]
}
