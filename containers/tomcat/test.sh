#!/usr/bin/env bats

TOMCAT_USER=manager
TOMCAT_PASSWORD=test_password

# source the helper script
APP_NAME=tomcat
SLEEP_TIME=5
VOL_PREFIX=/bitnami/$APP_NAME
VOLUMES=/app:$VOL_PREFIX/conf:$VOL_PREFIX/logs
load tests/docker_helper

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

@test "Port 8080 exposed and accepting external connections" {
  container_create default -d
  run curl_client default -i http://$APP_NAME:8080
  [[ "$output" =~ '200 OK' ]]
}

@test "Manager has access to management area" {
  container_create default -d
  run curl_client default -i http://$TOMCAT_USER@$APP_NAME:8080/manager/html
  [[ "$output" =~ '200 OK' ]]
}

@test "User manager created with password" {
  container_create default -d \
    -e TOMCAT_PASSWORD=$TOMCAT_PASSWORD

  run curl_client default -i http://$TOMCAT_USER:$TOMCAT_PASSWORD@$APP_NAME:8080/manager/html
  [[ "$output" =~ '200 OK' ]]
}

@test "Can't access management area without password" {
  container_create default -d \
    -e TOMCAT_PASSWORD=$TOMCAT_PASSWORD

  run curl_client default -i http://$TOMCAT_USER@$APP_NAME:8080/manager/html
  [[ "$output" =~ '401 Unauthorized' ]]
}

@test "Password is preserved after restart" {
  container_create default -d \
    -e TOMCAT_PASSWORD=$TOMCAT_PASSWORD

  container_restart default

  run container_logs default
  [[ "$output" =~ "The credentials were set on first boot." ]]

  run curl_client default -i http://$TOMCAT_USER:$TOMCAT_PASSWORD@$APP_NAME:8080/manager/html
  [[ "$output" =~ '200 OK' ]]
}

@test "All the volumes exposed" {
  container_create default -d

  run container_inspect default --format {{.Mounts}}
  [[ "$output" =~ "$VOL_PREFIX/conf" ]]
  [[ "$output" =~ "$VOL_PREFIX/logs" ]]
}

@test "Data gets generated in conf and app if bind mounted in the host" {
  container_create_with_host_volumes default -d \
    -e TOMCAT_PASSWORD=$TOMCAT_PASSWORD

  # files expected in conf volume (subset)
  run container_exec default ls -la $VOL_PREFIX/conf/
  [[ "$output" =~ "server.xml" ]]
  [[ "$output" =~ "tomcat-users.xml" ]]

  # files expected in app volume (subset)
  run container_exec default ls -la /app/
  [[ "$output" =~ "ROOT" ]]
  [[ "$output" =~ "manager" ]]
  [[ "$output" =~ "host-manager" ]]
}

@test "If host mounted, password and settings are preserved after deletion" {
  container_create_with_host_volumes default -d \
    -e TOMCAT_PASSWORD=$TOMCAT_PASSWORD

  # remove container
  container_remove default

  # recreate container without specifying any environment variables
  container_create_with_host_volumes default -d

  run curl_client default -i http://$TOMCAT_USER:$TOMCAT_PASSWORD@$APP_NAME:8080/manager/html
  [[ "$output" =~ '200 OK' ]]
}

@test "Configuration changes are preserved after deletion" {
  container_create_with_host_volumes default -d

  # modify catalina.properties
  container_exec default sed -i 's|^[#]*[ ]*tomcat.util.buf.StringCache.byte.enabled[ ]*=.*|tomcat.util.buf.StringCache.byte.enabled=false|' $VOL_PREFIX/conf/catalina.properties
  container_exec default sed -i 's|^[#]*[ ]*tomcat.util.buf.StringCache.char.enabled[ ]*=.*|tomcat.util.buf.StringCache.char.enabled=false|' $VOL_PREFIX/conf/catalina.properties
  container_exec default sed -i 's|^[#]*[ ]*tomcat.util.buf.StringCache.cacheSize[ ]*=.*|tomcat.util.buf.StringCache.cacheSize=4096|' $VOL_PREFIX/conf/catalina.properties

  # stop and remove container
  container_remove default

  # relaunch container with host volumes
  container_create_with_host_volumes default -d

  run container_exec default cat $VOL_PREFIX/conf/catalina.properties
  [[ "$output" =~ "tomcat.util.buf.StringCache.byte.enabled=false" ]]
  [[ "$output" =~ "tomcat.util.buf.StringCache.char.enabled=false" ]]
  [[ "$output" =~ "tomcat.util.buf.StringCache.cacheSize=4096" ]]
}

@test "Deploy sample application" {
  container_create_with_host_volumes default -d \
    -e TOMCAT_PASSWORD=$TOMCAT_PASSWORD

  # download sample app into the app deployment directory, allow 10 secs for the autodeploy to happen
  container_exec default curl --noproxy localhost --retry 5 http://localhost:8080/docs/appdev/sample/sample.war -o /app/sample.war
  sleep 10

  # test app deployment
  run curl_client default -i http://$APP_NAME:8080/sample/hello.jsp
  [[ "$output" =~ '200 OK' ]]
}
