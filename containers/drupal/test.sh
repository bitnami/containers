#!/usr/bin/env bats

BITNAMI_APP_NAME=drupal
WELCOME_PAGE_TEXT="User login"
CONTAINER_NAME=bitnami-$BITNAMI_APP_NAME-test
IMAGE_NAME=bitnami/$BITNAMI_APP_NAME
SLEEP_TIME=90

# Check config override from host
cleanup_running_containers() {
  if [ "$(docker ps -a | grep $CONTAINER_NAME)" ]; then
    docker rm -fv $CONTAINER_NAME
  fi
}

setup() {
  cleanup_running_containers
}

teardown() {
  cleanup_running_containers
}

create_container(){
  docker run -d --name $CONTAINER_NAME \
   --expose 80 --expose 443 $IMAGE_NAME
  echo "Waiting $SLEEP_TIME for the container to initialize"
  sleep $SLEEP_TIME
}


@test "We can connect to the port 80 and 443" {
  create_container
  docker run --link $CONTAINER_NAME:$BITNAMI_APP_NAME --rm bitnami/$BITNAMI_APP_NAME curl -L -i http://$BITNAMI_APP_NAME:80 | {
    run grep "200 OK"
    [ $status = 0 ]
  }

  docker run --link $CONTAINER_NAME:$BITNAMI_APP_NAME --rm bitnami/$BITNAMI_APP_NAME curl -L -i -k https://$BITNAMI_APP_NAME:443 | {
    run grep "200 OK"
    [ $status = 0 ]
  }
}

@test "Returns default page" {
  create_container
  docker run --link $CONTAINER_NAME:$BITNAMI_APP_NAME --rm bitnami/$BITNAMI_APP_NAME curl -L -i http://$BITNAMI_APP_NAME:80 | {
    run grep "$WELCOME_PAGE_TEXT"
    [ $status = 0 ]
  }

  docker run --link $CONTAINER_NAME:$BITNAMI_APP_NAME --rm bitnami/$BITNAMI_APP_NAME curl -L -i -k https://$BITNAMI_APP_NAME:443 | {
    run grep "$WELCOME_PAGE_TEXT"
    [ $status = 0 ]
  }
}

@test "Logs to stdout" {
  create_container
  docker exec $CONTAINER_NAME bash -c '$BITNAMI_PREFIX/ctlscript.sh status' | {
    run grep -v "not running"
    [ $status = 0 ]
  }
}
