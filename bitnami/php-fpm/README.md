# Bitnami PHP-FPM Docker Container

## Introduction to Bitnami containers
Bitnami provides easy-to-use, consistently configured, and always up-to-date container images. [Click here](https://bitnami.com) for more information on our packaging approach.

## What is PHP-FPM?
PHP-FPM (FastCGI Process Manager) is an alternative PHP FastCGI implementation with some additional features useful for sites of any size, especially busier sites.

## Usage
You can instantiate a Bitnami PHP-FPM container by doing:

```
HOST_PHP_APP_DIR=`pwd`/php_app
HOST_PHP_SERVER_PORT=9000
CONTAINER_PHP_SERVER_NAME=php-app
docker run -it \
  -p $HOST_PHP_SERVER_PORT:9000 \
  -v $HOST_PHP_APP_DIR:/php_app \
  --name $CONTAINER_PHP_SERVER_NAME
  bitnami/php-fpm
```

## Configuration

You can configure PHP in `/bitnami/phpfpm/conf` inside the container.

## Linking

You can link the PHP-FPM to a container running your application, e.g., using the Bitnami nginx container:

```
CONTAINER_PHP_LINK_NAME=php-app
docker run --rm -it \
    --link $CONTAINER_PHP_SERVER_NAME:$CONTAINER_PHP_LINK_NAME \
    -v $HOST_PHP_APP_DIR:/app bitnami/nginx
```

Inside your application, use the value of $CONTAINER_PHP_LINK_NAME when setting up your virtual host.
The Bitnami nginx container comes with an example virtual host for connecting to this PHP-FPM container.

## Logging

The container is set up to log to stdout, which means logs can be obtained as follows:

```
docker logs php-app
```

If you would like to log to a file instead, you can mount a volume at `/logs`.
