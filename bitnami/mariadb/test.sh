#!/usr/bin/env bats

CONTAINER_NAME=mariadb
IMAGE_NAME=bitnami/mariadb
SLEEP_TIME=5
MARIADB_DATABASE=test_database
MARIADB_USER=test_user
MARIADB_PASSWORD=test_password
VOL_PREFIX=/bitnami/mariadb
HOST_VOL_PREFIX=/tmp/bitnami/$CONTAINER_NAME

setup() {
  mkdir -p $HOST_VOL_PREFIX
}

teardown() {
  if [ "$(docker ps -a | grep $CONTAINER_NAME)" ]; then
    docker rm -fv $CONTAINER_NAME
  fi
}

cleanup_volumes_content() {
  docker run -it --rm\
    -v $HOST_VOL_PREFIX/data:$VOL_PREFIX/data\
    -v $HOST_VOL_PREFIX/conf:$VOL_PREFIX/conf\
    -v $HOST_VOL_PREFIX/logs:$VOL_PREFIX/logs\
    $IMAGE_NAME rm -rf $VOL_PREFIX/data/ $VOL_PREFIX/logs/ $VOL_PREFIX/conf/
}

create_basic_container(){
  docker run -itd --name $CONTAINER_NAME $IMAGE_NAME; sleep $SLEEP_TIME
}

create_full_container(){
  docker run -itd --name $CONTAINER_NAME\
   -e MARIADB_USER=$MARIADB_USER\
   -e MARIADB_DATABASE=$MARIADB_DATABASE\
   -e MARIADB_PASSWORD=$MARIADB_PASSWORD $IMAGE_NAME
  sleep $SLEEP_TIME
}

create_full_container_mounted(){
  docker run -itd --name $CONTAINER_NAME\
   -e MARIADB_USER=$MARIADB_USER\
   -e MARIADB_DATABASE=$MARIADB_DATABASE\
   -e MARIADB_PASSWORD=$MARIADB_PASSWORD\
   -v $HOST_VOL_PREFIX/data:$VOL_PREFIX/data\
   -v $HOST_VOL_PREFIX/conf:$VOL_PREFIX/conf\
   -v $HOST_VOL_PREFIX/logs:$VOL_PREFIX/logs\
   $IMAGE_NAME
  sleep $SLEEP_TIME
}

@test "Root user created without password" {
  create_basic_container
  docker exec -it $CONTAINER_NAME mysql -e "select User from mysql.user where User=\"root\"\G" | {
    run grep 'User: root'
    [ $status = 0 ]
  }
}

@test "Root user created with password" {
  docker run -itd --name $CONTAINER_NAME -e MARIADB_PASSWORD=$MARIADB_PASSWORD $IMAGE_NAME
  sleep $SLEEP_TIME
  # Can not login as root
  run docker exec -it $CONTAINER_NAME mysql -e 'show databases\G'
  [ $status = 1 ]
  run docker exec -it $CONTAINER_NAME mysql -p$MARIADB_PASSWORD -e 'show databases\G'
  [ $status = 0 ]
}

@test "Root user has access to admin database" {
  create_basic_container
  docker exec -it $CONTAINER_NAME mysql -e 'show databases\G' | {
    run grep 'Database: mysql'
    [ $status = 0 ]
  }
}

@test "Custom database created" {
  docker run -itd --name $CONTAINER_NAME -e MARIADB_DATABASE=$MARIADB_DATABASE $IMAGE_NAME
  sleep $SLEEP_TIME
  docker exec -it $CONTAINER_NAME mysql -e 'show databases\G' | {
    run grep "Database: $MARIADB_DATABASE"
    [ $status = 0 ]
  }
}

@test "Can't create a custom user without database" {
  run docker run -it --name $CONTAINER_NAME -e MARIADB_USER=$MARIADB_USER $IMAGE_NAME
  [[ "$output" =~ "you need to provide the MARIADB_DATABASE" ]]
  [ $status = 255 ]
}

@test "Create custom user and database without password" {
  docker run -itd --name $CONTAINER_NAME\
   -e MARIADB_USER=$MARIADB_USER\
   -e MARIADB_DATABASE=$MARIADB_DATABASE $IMAGE_NAME
  sleep $SLEEP_TIME
  # Can not login as root
  run docker exec -it $CONTAINER_NAME mysql -e 'show databases\G'
  [ $status = 1 ]
  docker exec -it $CONTAINER_NAME mysql -u $MARIADB_USER -e  'show databases\G' | {
    run grep "Database: $MARIADB_DATABASE"
    [ $status = 0 ]
  }
}

@test "Create custom user and database with password" {
  create_full_container
  # Can not login as root
  run docker exec -it $CONTAINER_NAME mysql -u $MARIADB_USER -e 'show databases\G'
  [ $status = 1 ]
  run docker exec -it $CONTAINER_NAME mysql -u $MARIADB_USER -p$MARIADB_PASSWORD -e 'show databases\G'
  [ $status = 0 ]
}

@test "User and password settings are preserved after restart" {
  create_full_container

  docker stop $CONTAINER_NAME
  docker start $CONTAINER_NAME
  sleep $SLEEP_TIME

  run docker logs $CONTAINER_NAME
  [[ "$output" =~ "The credentials were set on first boot." ]]

  run docker exec -it $CONTAINER_NAME mysql -u $MARIADB_USER -p$MARIADB_PASSWORD -e 'show databases\G'
  [ $status = 0 ]
}

@test "If host mounted, password and settings are preserved after deletion" {
  cleanup_volumes_content
  create_full_container_mounted

  docker rm -fv $CONTAINER_NAME

  docker run -itd --name $CONTAINER_NAME\
   -v $HOST_VOL_PREFIX/data:$VOL_PREFIX/data\
   -v $HOST_VOL_PREFIX/conf:$VOL_PREFIX/conf\
   $IMAGE_NAME
  sleep $SLEEP_TIME

  run docker exec -it $CONTAINER_NAME mysql -u $MARIADB_USER -p$MARIADB_PASSWORD -e 'show databases\G'
  [ $status = 0 ]
  cleanup_volumes_content
}

@test "Port 3306 exposed and accepting external connections" {
  create_basic_container

  run docker run -it --rm --name 'linked' --link $CONTAINER_NAME:$CONTAINER_NAME $IMAGE_NAME\
    mysql -h $CONTAINER_NAME -P 3306 -e 'show databases\G'
  [ $status = 0 ]
}

@test "All the volumes exposed" {
  create_basic_container
  docker inspect $CONTAINER_NAME | {
    run grep "\"Volumes\":" -A 3
    [[ "$output" =~ "$VOL_PREFIX/data" ]]
    [[ "$output" =~ "$VOL_PREFIX/conf" ]]
    [[ "$output" =~ "$VOL_PREFIX/logs" ]]
  }
}

@test "Data gets generated in conf and data if bind mounted in the host" {
  create_full_container_mounted
  run ls -l $HOST_VOL_PREFIX/conf/my.cnf $HOST_VOL_PREFIX/logs/mysqld.log
  [ $status = 0 ]
  cleanup_volumes_content
}

