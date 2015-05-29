# Bitnami Memcached Docker Container

## Introduction to Bitnami containers
Bitnami provides easy-to-use, consistently configured, and always up-to-date container images. [Click here](https://bitnami.com) for more information on our packaging approach.

## What is Memcached?
Memcached is an in-memory key-value store for small chunks of arbitrary data (strings, objects) from results of database calls, API calls, or page rendering.

## Usage
You can instantiate a Bitnami Memcached container by doing:

```
CONTAINER_MEMCACHED_SERVER_NAME=memcached
docker run -it \
  --name $CONTAINER_MEMCACHED_SERVER_NAME
  bitnami/memcached
```

### Environment variables

You can specify the `MEMCACHED_PASSWORD` to specify a password for your memcached server.

## Linking

You can link the Memcached to a container running your application, e.g., using the Bitnami node container:

```
CONTAINER_MEMCACHED_LINK_NAME=memcached
docker run --rm -it \
    --link $CONTAINER_MEMCACHED_SERVER_NAME:$CONTAINER_MEMCACHED_LINK_NAME bitnami/node \
    npm start --production
```
Inside your application, use the value of $CONTAINER_MEMCACHED_LINK_NAME when setting the Memcached host.

## Logging

The container is set up to log to stdout, which means logs can be obtained as follows:

```
docker logs memcached
```

If you would like to log to a file instead, you can mount a volume at `/logs`.
