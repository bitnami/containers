# Bitnami Node.js Docker Container

## Introduction to Bitnami containers
Bitnami provides easy-to-use, consistently configured, and always up-to-date container images. [Click here](https://bitnami.com) for more information on our packaging approach.

## What is Node.js?
Node.js allows developers to build scalable, real-time web applications with two-way connections between the client and server.

## Usage
You can instantiate a Bitnami Node.js container by doing:

```
HOST_NODE_APP_DIR=`pwd`/node_app
HOST_NODE_SERVER_PORT=8080
CONTAINER_NODE_SERVER_NAME=node-app
docker run -it \
  -p $HOST_NODE_SERVER_PORT:80 \
  -v $HOST_NODE_APP_DIR:/node_app \
  --name $CONTAINER_NODE_SERVER_NAME
  bitnami/node
```

## Linking

You can link the Node.js to a container running your application, e.g., using the Bitnami nginx container:

```
CONTAINER_NODE_LINK_NAME=node-app
docker run --rm -it \
    --link $CONTAINER_NODE_SERVER_NAME:$CONTAINER_NODE_LINK_NAME \
    -v $HOST_NODE_APP_DIR:/app bitnami/nginx
```

Inside your application, use the value of $CONTAINER_NODE_LINK_NAME when setting up your virtual host.
The Bitnami nginx container comes with an example virtual host for connecting to this Node.js container.

## Logging

The container is set up to log to stdout, which means logs can be obtained as follows:

```
docker logs $CONTAINER_NODE_SERVER_NAME
```

If you would like to log to a file instead, you can mount a volume at `/logs`.
