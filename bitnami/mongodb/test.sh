# #!/usr/bin/env bats
CONTAINER_NAME=bitnami-mongodb-test
IMAGE_NAME=${IMAGE_NAME:-bitnami/mongodb}
SLEEP_TIME=5
MONGODB_ROOT_USER=root
MONGODB_DATABASE=test_database
MONGODB_USER=test_user
MONGODB_PASSWORD=test_password
VOL_PREFIX=/bitnami/mongodb
HOST_VOL_PREFIX=${HOST_VOL_PREFIX:-/tmp/bitnami/$CONTAINER_NAME}

cleanup_running_containers() {
  if [ "$(docker ps -a | grep $CONTAINER_NAME)" ]; then
    docker rm -fv $CONTAINER_NAME
  fi
}

setup() {
  cleanup_running_containers
  mkdir -p $HOST_VOL_PREFIX
}

teardown() {
  cleanup_running_containers
}

cleanup_volumes_content() {
  docker run --rm\
    -v $HOST_VOL_PREFIX/data:$VOL_PREFIX/data\
    -v $HOST_VOL_PREFIX/conf:$VOL_PREFIX/conf\
    -v $HOST_VOL_PREFIX/logs:$VOL_PREFIX/logs\
    $IMAGE_NAME rm -rf $VOL_PREFIX/data/ $VOL_PREFIX/logs/ $VOL_PREFIX/conf/
}

create_container(){
  docker run --name $CONTAINER_NAME "$@" $IMAGE_NAME
  sleep $SLEEP_TIME
}

# $1 is the command
mongo_client(){
  docker run --rm --link $CONTAINER_NAME:$CONTAINER_NAME $IMAGE_NAME mongo --host $CONTAINER_NAME "$@"
}

create_full_container(){
  docker run -d --name $CONTAINER_NAME\
   -e MONGODB_USER=$MONGODB_USER\
   -e MONGODB_DATABASE=$MONGODB_DATABASE\
   -e MONGODB_PASSWORD=$MONGODB_PASSWORD $IMAGE_NAME
  sleep $SLEEP_TIME
}

create_full_container_mounted(){
  docker run -d --name $CONTAINER_NAME\
   -e MONGODB_USER=$MONGODB_USER\
   -e MONGODB_DATABASE=$MONGODB_DATABASE\
   -e MONGODB_PASSWORD=$MONGODB_PASSWORD\
   -v $HOST_VOL_PREFIX/data:$VOL_PREFIX/data\
   -v $HOST_VOL_PREFIX/conf:$VOL_PREFIX/conf\
   -v $HOST_VOL_PREFIX/logs:$VOL_PREFIX/logs\
   $IMAGE_NAME
  sleep $SLEEP_TIME
}

@test "Port 27017 exposed and accepting external connections" {
  create_container -d
  run mongo_client admin --eval "printjson(db.adminCommand('listDatabases'))"
  [[ "$output" =~ '"ok" : 1' ]]
}

@test "Root user created with password" {
  create_container -d -e MONGODB_PASSWORD=$MONGODB_PASSWORD
  # Can not login as root
  run mongo_client -u $MONGODB_ROOT_USER admin --eval "printjson(db.adminCommand('listDatabases'))"
  [[ "$output" =~ "login failed" ]]
  run mongo_client -u $MONGODB_ROOT_USER -p $MONGODB_PASSWORD admin --eval "printjson(db.adminCommand('listDatabases'))"
  [[ "$output" =~ '"ok" : 1' ]]
}

@test "Root user has access to admin database" {
  create_container -d -e MONGODB_PASSWORD=$MONGODB_PASSWORD
  run mongo_client -u $MONGODB_ROOT_USER -p $MONGODB_PASSWORD admin --eval "printjson(db.adminCommand('listDatabases'))"
  [[ "$output" =~ '"ok" : 1' ]]
}

@test "Can't create root user without password" {
  run create_container -it -e MONGODB_USER=$MONGODB_ROOT_USER
  [[ "$output" =~ "you need to provide the MONGODB_PASSWORD" ]]
}

@test "Can't create a custom user without password" {
  run create_container -it -e MONGODB_USER=$MONGODB_USER
  [[ "$output" =~ "you need to provide the MONGODB_PASSWORD" ]]
}

@test "Can't create a custom user without database" {
  run create_container -it -e MONGODB_USER=$MONGODB_USER -e MONGODB_PASSWORD=$MONGODB_PASSWORD
  [[ "$output" =~ "you need to provide the MONGODB_DATABASE" ]]
}

@test "Create custom user and database with password" {
  create_full_container
  # Cannot login without password
  run mongo_client -u $MONGODB_USER $MONGODB_DATABASE --eval "printjson(db.adminCommand('listCollections'))"
  [[ "$output" =~ "login failed" ]]
  run mongo_client -u $MONGODB_USER -p $MONGODB_PASSWORD $MONGODB_DATABASE --eval "printjson(db.adminCommand('listCollections'))"
  [[ "$output" =~ '"ok" : 1' ]]
}

@test "Custom user can't access admin database" {
  create_full_container
  run mongo_client -u $MONGODB_USER -p $MONGODB_PASSWORD admin --eval "printjson(db.adminCommand('listDatabases'))"
  [[ "$output" =~ 'login failed' ]]
}

@test "User and password settings are preserved after restart" {
  create_full_container

  docker stop $CONTAINER_NAME
  docker start $CONTAINER_NAME
  sleep $SLEEP_TIME

  run docker logs $CONTAINER_NAME
  [[ "$output" =~ "The credentials were set on first boot." ]]

  run mongo_client -u $MONGODB_USER -p $MONGODB_PASSWORD $MONGODB_DATABASE --eval "printjson(db.adminCommand('listCollections'))"
  [[ "$output" =~ '"ok" : 1' ]]
}

@test "If host mounted, password and settings are preserved after deletion" {
  cleanup_volumes_content
  create_full_container_mounted

  docker rm -fv $CONTAINER_NAME

  run docker run -d --name $CONTAINER_NAME\
   -v $HOST_VOL_PREFIX/data:$VOL_PREFIX/data\
   -v $HOST_VOL_PREFIX/conf:$VOL_PREFIX/conf\
   $IMAGE_NAME
  sleep $SLEEP_TIME

  run mongo_client -u $MONGODB_USER -p $MONGODB_PASSWORD $MONGODB_DATABASE --eval "printjson(db.adminCommand('listCollections'))"
  [[ "$output" =~ '"ok" : 1' ]]
  cleanup_volumes_content
}

@test "All the volumes exposed" {
  create_container -d
  run docker inspect $CONTAINER_NAME
  [[ "$output" =~ "$VOL_PREFIX/data" ]]
  [[ "$output" =~ "$VOL_PREFIX/conf" ]]
  [[ "$output" =~ "$VOL_PREFIX/logs" ]]
}

@test "Data gets generated in conf and data if bind mounted in the host" {
  create_full_container_mounted
  run docker run -v $HOST_VOL_PREFIX:$HOST_VOL_PREFIX --rm $IMAGE_NAME ls -l $HOST_VOL_PREFIX/conf/mongodb.conf $HOST_VOL_PREFIX/logs/mongodb.log
  [ $status = 0 ]
  cleanup_volumes_content
}
