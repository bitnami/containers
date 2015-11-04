#!/bin/bash

##
# Reusable helper script to do docker things in your tests
##
# The following variables should be defined in you BATS script for this helper
# script to work correctly.
#
# CONTAINER_NAME   - prefix for the name of containers that will be created
# IMAGE_NAME       - the docker image name
# SLEEP_TIME       - time in seconds to wait for containers to start
# VOL_PREFIX       - prefix of volumes inside the container
# HOST_VOL_PREFIX  - prefix of volumes mounted from the host
##

# Creates a container whose name has the prefix $CONTAINER_NAME
# $1: name for the new container
# ${@:2}: additional arguments for docker run while starting the container
create_container() {
  docker run --name $CONTAINER_NAME-$1 "${@:2}" $IMAGE_NAME
  sleep $SLEEP_TIME
}

# Creates a container with host volumes mounted at $VOL_PREFIX
# $1: name for the new container
# ${@:2}: additional arguments for docker run while starting the container
create_container_with_host_volumes() {
  create_container $1 "${@:2}" \
    -v $HOST_VOL_PREFIX/$1/data:$VOL_PREFIX/data \
    -v $HOST_VOL_PREFIX/$1/conf:$VOL_PREFIX/conf \
    -v $HOST_VOL_PREFIX/$1/logs:$VOL_PREFIX/logs
}

# Start a stopped container
# $1: name of the container
container_start() {
  if [ "$(docker ps -a | grep $CONTAINER_NAME-$1)" ]; then
    docker start $CONTAINER_NAME-$1
    sleep $SLEEP_TIME
  else
    return 1
  fi
}

# Stop a running container
# $1: name of the container
container_stop() {
  if [ "$(docker ps -a | grep $CONTAINER_NAME-$1)" ]; then
    docker stop $CONTAINER_NAME-$1
  else
    return 1
  fi
}

# Restart a running container (stops the container and then starts it)
# $1: name of the container
container_restart() {
  container_stop $1
  container_start $1
}

# Remove a running/stopped container
# $1: name of the container
container_remove() {
  if [ "$(docker ps -a | grep $CONTAINER_NAME-$1)" ]; then
    docker rm -fv $CONTAINER_NAME-$1
  fi
}

# Remove a running/stopped container and clear host volumes
# $1: name of the container
container_remove_full() {
  container_remove $1
  docker run --rm --entrypoint bash \
    -v $HOST_VOL_PREFIX/$1/data:$VOL_PREFIX/data \
    -v $HOST_VOL_PREFIX/$1/conf:$VOL_PREFIX/conf \
    -v $HOST_VOL_PREFIX/$1/logs:$VOL_PREFIX/logs \
      $IMAGE_NAME -c "rm -rf $VOL_PREFIX/data/ $VOL_PREFIX/logs/ $VOL_PREFIX/conf/"
}

# Get the logs of a container
# $1: name of the container
container_logs() {
  if [ "$(docker ps -a | grep $CONTAINER_NAME-$1)" ]; then
    docker logs $CONTAINER_NAME-$1
  else
    return 1
  fi
}

# Docker inspect a container
# $1: name of the container
container_inspect() {
  if [ "$(docker ps -a | grep $CONTAINER_NAME-$1)" ]; then
    docker inspect $CONTAINER_NAME-$1
  else
    return 1
  fi
}

# Execute a command in a running container using docker exec
# $1: name of the container
container_exec() {
  if [ "$(docker ps | grep $CONTAINER_NAME-$1)" ]; then
    docker exec $CONTAINER_NAME-$1 ${@:2}
  else
    return 1
  fi
}

# Generates docker link parameter for linking to a container
# $1: name of the container to link
# $2: alias for the link
container_link() {
  if [ "$(docker ps -a | grep $CONTAINER_NAME-$1)" ]; then
    echo "--link $CONTAINER_NAME-$1:$2"
  fi
}
