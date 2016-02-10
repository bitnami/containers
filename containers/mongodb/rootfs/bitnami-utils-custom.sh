# MongoDB Utility functions
PROGRAM_OPTIONS="--config $BITNAMI_APP_DIR/conf/mongodb.conf --dbpath $BITNAMI_APP_DIR/data"

create_mongodb_user() {
  if [ "$MONGODB_USER" ] && [ -z $MONGODB_PASSWORD ]; then
    echo ""
    echo "In order to create a MONGODB_USER you need to provide the MONGODB_PASSWORD as well"
    echo ""
    exit -1
  elif [ -z $MONGODB_PASSWORD ]; then
    return 0
  fi

  MONGODB_USER=${MONGODB_USER:-root}
  if [ "$MONGODB_USER" != "root" ] && [ ! $MONGODB_DATABASE ]; then
    echo ""
    echo "In order to use a custom MONGODB_USER you need to provide the MONGODB_DATABASE as well"
    echo ""
    exit -1
  fi

  echo ""
  echo "==> Creating user $MONGODB_USER..."

  # start mongodb server and wait for it to accept connections
  mongod $PROGRAM_OPTIONS --logpath /dev/null --bind_ip 127.0.0.1 --fork >/dev/null
  timeout=10
  while ! mongo --eval "db.adminCommand('listDatabases')" >/dev/null 2>&1
  do
    timeout=$(($timeout - 1))
    if [ $timeout -eq 0 ]; then
      echo "Could not connect to server. Aborting..."
      exit 1
    fi
    sleep 1
  done

  if [ "$MONGODB_USER" == "root" ]; then
    cat >> /tmp/initMongo.js <<EOF
db = db.getSiblingDB('admin')
db.createUser(
  {
    user: "$MONGODB_USER",
    pwd: "$MONGODB_PASSWORD",
    roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
  }
)
EOF
  fi

  if [ $MONGODB_DATABASE ]; then
    cat >> /tmp/initMongo.js <<EOF
db = db.getSiblingDB('$MONGODB_DATABASE')
db.createUser(
  {
    user: "$MONGODB_USER",
    pwd: "$MONGODB_PASSWORD",
    roles: [ { role: "readWrite", db: "$MONGODB_DATABASE" } ]
  }
)
EOF
  fi

  mongo /tmp/initMongo.js >/dev/null
  mongod $PROGRAM_OPTIONS --shutdown >/dev/null

  # enable authentication in mongo configuration
  sed -i -e "s|^[#]*[ ]*auth = .*|auth = true|" $BITNAMI_APP_DIR/conf/mongodb.conf
}

print_mongo_user() {
  if [ -z $MONGODB_USER ]; then
    echo "**none**"
  else
    echo $MONGODB_USER
  fi
}

print_mongo_password() {
  if [ -z $MONGODB_PASSWORD ]; then
    echo "**none**"
  else
    echo $MONGODB_PASSWORD
  fi
}

print_mongo_database() {
 if [ $MONGODB_DATABASE ]; then
    echo "Database: $MONGODB_DATABASE"
 fi
}
