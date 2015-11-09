#!/bin/bash

##
# Reusable helper script to do docker things in your tests
##
# The following variables should be defined in you BATS script for this helper
# script to work correctly.
#
# APP_NAME                                    - app name, used as link alias in container_link_and_run_command
# CONTAINER_NAME                              - prefix for the name of containers that will be created (default: bitnami-$APP_NAME-test)
# IMAGE_NAME                                  - the docker image name (default: bitnami/$APP_NAME)
# SLEEP_TIME                                  - time in seconds to wait for containers to start (default: 5)
# VOL_PREFIX                                  - prefix of volumes inside the container (default: /bitnami/$APP_NAME)
# VOLUMES                                     - colon separated list of container volumes (default: $VOL_PREFIX/data:$VOL_PREFIX/conf:$VOL_PREFIX/logs)
# HOST_VOL_PREFIX                             - prefix of volumes mounted from the host (default: /tmp/bitnami/$CONTAINER_NAME)
# container_link_and_run_command_DOCKER_ARGS  - optional arguments passed to docker run in container_link_and_run_command (default: none)
##

CONTAINER_NAME=bitnami-$APP_NAME-test
IMAGE_NAME=${IMAGE_NAME:-bitnami/$APP_NAME}
SLEEP_TIME=${SLEEP_TIME:-5}
VOL_PREFIX=${VOL_PREFIX:-/bitnami/$APP_NAME}
VOLUMES=${VOLUMES:-$VOL_PREFIX/data:$VOL_PREFIX/conf:$VOL_PREFIX/logs}
HOST_VOL_PREFIX=${HOST_VOL_PREFIX:-/tmp/bitnami/$CONTAINER_NAME}

# Creates a container whose name has the prefix $CONTAINER_NAME
# $1: name for the new container
# ${@:2}: additional arguments for docker run while starting the container
container_create() {
  docker run --name $CONTAINER_NAME-$1 "${@:2}" $IMAGE_NAME
  sleep $SLEEP_TIME
}

# Creates a container with host mounted volumes for volumes listed in VOLUMES
# $1: name for the new container
# ${@:2}: additional arguments for docker run while starting the container
container_create_with_host_volumes() {
  # populate volume mount arguments from VOLUMES variable
  VOLUME_ARGS=
  OLD_IFS=${IFS}
  IFS=":"
  for VOLUME in $VOLUMES
  do
    VOL_NAME=$(basename $VOLUME)
    VOLUME_ARGS+="-v $HOST_VOL_PREFIX/$1/$VOL_NAME:$VOLUME "
  done
  IFS=${OLD_IFS}

  container_create $1 "${@:2}" $VOLUME_ARGS
}

# Start a stopped container
# $1: name of the container
container_start() {
  if docker ps -a | grep -q $CONTAINER_NAME-$1; then
    docker start $CONTAINER_NAME-$1
    sleep $SLEEP_TIME
  else
    return 1
  fi
}

# Stop a running container
# $1: name of the container
container_stop() {
  if docker ps | grep -q $CONTAINER_NAME-$1; then
    docker stop $CONTAINER_NAME-$1
  else
    return 1
  fi
}

# Restart a running container (stops the container and then starts it)
# $1: name of the container
container_restart() {
  if docker ps | grep -q $CONTAINER_NAME-$1; then
    docker stop $CONTAINER_NAME-$1
    docker start $CONTAINER_NAME-$1
    sleep $SLEEP_TIME
  fi
}

# Remove a running/stopped container
# $1: name of the container
container_remove() {
  if docker ps -a | grep -q $CONTAINER_NAME-$1; then
    docker stop $CONTAINER_NAME-$1
    docker rm -v $CONTAINER_NAME-$1
  fi
}

# Remove a running/stopped container and clear host volumes
# $1: name of the container
container_remove_full() {
  container_remove $1

  # populate volume mount and rm arguments from VOLUMES variable
  VOLUME_ARGS=
  RM_ARGS=
  OLD_IFS=${IFS}
  IFS=":"
  for VOLUME in $VOLUMES
  do
    VOL_NAME=$(basename $VOLUME)
    VOLUME_ARGS+="-v $HOST_VOL_PREFIX/$1/$VOL_NAME:$VOLUME "
    RM_ARGS+="$VOLUME/* $VOLUME/.[^.]* "
  done
  IFS=${OLD_IFS}

  docker run --rm --entrypoint bash $VOLUME_ARGS \
      $IMAGE_NAME -c "rm -rf $RM_ARGS"
}

# Get the logs of a container
# $1: name of the container
container_logs() {
  if docker ps -a | grep -q $CONTAINER_NAME-$1; then
    docker logs $CONTAINER_NAME-$1
  else
    return 1
  fi
}

# Docker inspect a container
# $1: name of the container
container_inspect() {
  if docker ps -a | grep -q $CONTAINER_NAME-$1; then
    # docker inspect "${@:2}" $CONTAINER_NAME-$1 # requires docker >= 1.9.0
    docker inspect $CONTAINER_NAME-$1
  else
    return 1
  fi
}

# Execute a command in a running container using docker exec
# $1: name of the container
container_exec() {
  if docker ps | grep -q $CONTAINER_NAME-$1; then
    docker exec $CONTAINER_NAME-$1 "${@:2}"
  else
    return 1
  fi
}

# Execute a command in a running container using docker exec (detached)
# $1: name of the container
container_exec_detached() {
  if docker ps | grep -q $CONTAINER_NAME-$1; then
    docker exec -d $CONTAINER_NAME-$1 "${@:2}"
  else
    return 1
  fi
}

# Generates docker link parameter for linking to a container
# $1: name of the container to link
# $2: alias for the link
container_link() {
  if docker ps -a | grep -q $CONTAINER_NAME-$1; then
    echo "--link $CONTAINER_NAME-$1:$2"
  fi
}

# Link to container and execute command
# $1: name of the container to link to
# ${@:2}: command to execute
container_link_and_run_command() {
  # launch command as the entrypoint to skip the s6 init sequence (speeds up the tests)
  docker run --rm $(container_link $1 $APP_NAME) $container_link_and_run_command_DOCKER_ARGS --entrypoint ${2} $IMAGE_NAME "${@:3}"
}

# Link to container and execute curl
# $1: name of the container to link to
# ${@:2}: arguments to curl
curl_client() {
  container_link_and_run_command $1 curl --noproxy $APP_NAME --retry 5 -L "${@:2}"
}
