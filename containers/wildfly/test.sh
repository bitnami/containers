#!/usr/bin/env bats

WILDFLY_USER=manager
WILDFLY_DEFAULT_PASSWORD=wildfly
WILDFLY_PASSWORD=test_password

# source the helper script
APP_NAME=wildfly
SLEEP_TIME=25
load tests/docker_helper

# Link to container and execute jboss-cli
# $1: name of the container to link to
# ${@:2}: command to execute
jboss_client() {
  container_link_and_run_command $1 jboss-cli.sh --controller=$APP_NAME:9990 "${@:2}"
}

# Cleans up all running/stopped containers and host mounted volumes
cleanup_environment() {
  container_remove_full default
}

# Teardown called at the end of each test
teardown() {
  cleanup_environment
}

# cleanup the environment before starting the tests
cleanup_environment

@test "Ports 8080 and 9990 exposed and accepting external connections (standalone mode)" {
  container_create default -d

  run curl_client default -i http://$APP_NAME:8080
  [[ "$output" =~ '200 OK' ]]

  run curl_client default -i http://$APP_NAME:9990
  [[ "$output" =~ '200 OK' ]]
}

@test "Ports 8080 and 9990 exposed and accepting external connections (domain mode)" {
  container_create default -d \
    -e BITNAMI_APP_DAEMON=domain.sh
  sleep $SLEEP_TIME

  run curl_client default -i http://$APP_NAME:8080
  [[ "$output" =~ '200 OK' ]]
  run curl_client default -i http://$APP_NAME:9990
  [[ "$output" =~ '200 OK' ]]
}

@test "Manager has access to management area (standalone mode)" {
  container_create default -d

  run curl_client default -i --digest http://$WILDFLY_USER:$WILDFLY_DEFAULT_PASSWORD@$APP_NAME:9990/management
  [[ "$output" =~ '200 OK' ]]
}

@test "Manager has access to management area (domain mode)" {
  container_create default -d \
    -e BITNAMI_APP_DAEMON=domain.sh

  run curl_client default -i --digest http://$WILDFLY_USER:$WILDFLY_DEFAULT_PASSWORD@$APP_NAME:9990/management
  [[ "$output" =~ '200 OK' ]]
}

@test "User manager created with custom password (standalone mode)" {
  container_create default -d \
    -e WILDFLY_PASSWORD=$WILDFLY_PASSWORD

  run curl_client default -i --digest http://$WILDFLY_USER:$WILDFLY_PASSWORD@$APP_NAME:9990/management
  [[ "$output" =~ '200 OK' ]]
}

@test "User manager created with custom password (domain mode)" {
  container_create default -d \
    -e BITNAMI_APP_DAEMON=domain.sh \
    -e WILDFLY_PASSWORD=$WILDFLY_PASSWORD

  run curl_client default -i --digest http://$WILDFLY_USER:$WILDFLY_PASSWORD@$APP_NAME:9990/management
  [[ "$output" =~ '200 OK' ]]
}

@test "Can't access management area without password (standalone mode)" {
  container_create default -d \
    -e WILDFLY_PASSWORD=$WILDFLY_PASSWORD

  run curl_client default -i --digest http://$WILDFLY_USER@$APP_NAME:9990/management
  [[ "$output" =~ '401 Unauthorized' ]]
}

@test "Can't access management area without password (domain mode)" {
  container_create default -d \
    -e BITNAMI_APP_DAEMON=domain.sh \
    -e WILDFLY_PASSWORD=$WILDFLY_PASSWORD

  run curl_client default -i --digest http://$WILDFLY_USER@$APP_NAME:9990/management
  [[ "$output" =~ '401 Unauthorized' ]]
}

@test "jboss-cli.sh can connect to Wildfly server (standalone mode)" {
  container_create default -d \
    -e WILDFLY_PASSWORD=$WILDFLY_PASSWORD

  run jboss_client default --connect --user=$WILDFLY_USER --password=$WILDFLY_PASSWORD --command=version
  [ $status = 0 ]
}

@test "jboss-cli.sh can connect to Wildfly server (domain mode)" {
  container_create default -d \
    -e BITNAMI_APP_DAEMON=domain.sh \
    -e WILDFLY_PASSWORD=$WILDFLY_PASSWORD

  run jboss_client default --connect --user=$WILDFLY_USER --password=$WILDFLY_PASSWORD --command=version
  [ $status = 0 ]
}

@test "jboss-cli.sh can't access Wildfly server without password (standalone mode)" {
  container_create default -d \
    -e WILDFLY_PASSWORD=$WILDFLY_PASSWORD

  run jboss_client default --connect --user=$WILDFLY_USER --command=version
  [[ "$output" =~ "Unable to authenticate against controller" ]]
}

@test "jboss-cli.sh can't access Wildfly server without password (domain mode)" {
  container_create default -d \
    -e BITNAMI_APP_DAEMON=domain.sh \
    -e WILDFLY_PASSWORD=$WILDFLY_PASSWORD

  run jboss_client default --connect --user=$WILDFLY_USER --command=version
  [[ "$output" =~ "Unable to authenticate against controller" ]]
}

@test "Password is preserved after restart (standalone mode)" {
  container_create default -d \
    -e WILDFLY_PASSWORD=$WILDFLY_PASSWORD

  # restart container
  container_restart default

  # get logs
  run container_logs default
  [[ "$output" =~ "The credentials were set on first boot." ]]

  run curl_client default -i --digest http://$WILDFLY_USER:$WILDFLY_PASSWORD@$APP_NAME:9990/management
  [[ "$output" =~ '200 OK' ]]
}

@test "Password is preserved after restart (domain mode)" {
  container_create default -d \
    -e BITNAMI_APP_DAEMON=domain.sh \
    -e WILDFLY_PASSWORD=$WILDFLY_PASSWORD

  # restart container
  container_restart default

  # get logs
  run container_logs default
  [[ "$output" =~ "The credentials were set on first boot." ]]

  run curl_client default -i --digest http://$WILDFLY_USER:$WILDFLY_PASSWORD@$APP_NAME:9990/management
  [[ "$output" =~ '200 OK' ]]
}

@test "All the volumes exposed" {
  container_create default -d

  run container_inspect default --format {{.Mounts}}
  [[ "$output" =~ "$VOL_PREFIX/conf" ]]
  [[ "$output" =~ "$VOL_PREFIX/logs" ]]
}

@test "Data gets generated in conf and app volumes if bind mounted in the host" {
  container_create_with_host_volumes default -d

  # files expected in conf volume
  run container_exec default ls -la $VOL_PREFIX/conf/
  [[ "$output" =~ "domain" ]]
  [[ "$output" =~ "standalone" ]]

  # files expected in app volume (subset)
  run container_exec default ls -la $VOL_PREFIX/data/
  [[ "$output" =~ ".initialized" ]]
  [[ "$output" =~ "domain" ]]
  [[ "$output" =~ "standalone" ]]

  # files expected in logs volume
  run container_exec default ls -la $VOL_PREFIX/logs/
  [[ "$output" =~ "server.log" ]]
}

@test "If host mounted, password and settings are preserved after deletion" {
  container_create_with_host_volumes default -d \
    -e WILDFLY_PASSWORD=$WILDFLY_PASSWORD

  # remove container
  container_remove default

  # recreate container without specifying any env parameters
  container_create_with_host_volumes default -d

  run curl_client default -i --digest http://$WILDFLY_USER:$WILDFLY_PASSWORD@$APP_NAME:9990/management
  [[ "$output" =~ '200 OK' ]]
}

@test "Configuration changes are preserved after deletion" {
  container_create_with_host_volumes default -d

  # edit conf/standalone/standalone.xml
  container_exec default sh -c "echo '\n<!-- WINTER IS COMING! -->' >> $VOL_PREFIX/conf/standalone/standalone.xml"

  # edit conf/domain/domain.xml
  container_exec default sh -c "echo '\n<!-- THE NIGHT IS DARK AND FULL OF TERRORS! -->' >> $VOL_PREFIX/conf/domain/domain.xml"

  # stop and remove container
  container_remove default

  # relaunch container with host volumes
  container_create_with_host_volumes default -d

  run container_exec default cat $VOL_PREFIX/conf/standalone/standalone.xml
  [[ "$output" =~ "WINTER IS COMING!" ]]

  run container_exec default cat $VOL_PREFIX/conf/domain/domain.xml
  [[ "$output" =~ "THE NIGHT IS DARK AND FULL OF TERRORS!" ]]
}

@test "Deploy sample application on standalone" {
  container_create_with_host_volumes default -d \
    -e WILDFLY_PASSWORD=$WILDFLY_PASSWORD

  # download sample app into the deployments directory and allow it some time to come up
  container_exec default curl --noproxy localhost --retry 5 https://raw.githubusercontent.com/goldmann/wildfly-docker-deployment-example/master/node-info.war -o $VOL_PREFIX/data/standalone/deployments/node-info.war
  sleep $SLEEP_TIME

  # test the deployment
  run curl_client default -i http://$APP_NAME:8080/node-info/
  [[ "$output" =~ '200 OK' ]]
}
