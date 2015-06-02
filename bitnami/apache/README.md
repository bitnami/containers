# Bitnami Apache Docker Container

## Introduction to Bitnami containers
Bitnami provides easy-to-use, consistently configured, and always up-to-date container images.  [Click here](https://bitnami.com) for more information on our packaging approach.

## What is Apache?
The Apache HTTP Server Project is an effort to develop and maintain an open-source HTTP server for modern operating systems including UNIX and Windows NT. The goal of this project is to provide a secure, efficient and extensible server that provides HTTP services in sync with the current HTTP standards.

## Usage
You can instantiate a Bitnami Apache container by doing:

```
HOST_APACHE_HTTP_PORT=8080
HOST_APACHE_HTTPS_PORT=8443
HOST_APACHE_CONF_DIR=`pwd`/apache_conf
HOST_APACHE_APP_DIR=`pwd`/app
docker run -it \
  -p $HOST_APACHE_HTTP_PORT:80 \
  -p $HOST_APACHE_HTTPS_PORT:443 \
  -v $HOST_APACHE_CONF_DIR:/conf \
  -v $HOST_APACHE_APP_DIR:/app \
  bitnami/apache
```

### Ports
The command above allows you to access Apache via ports 8080 and 8443 (or whatever alternative ports you pick) on the host.  These will map to ports 80 and 443 respectively inside the container.

### Configuration
Apache configuration should live in $HOST_APACHE_CONF_DIR on the host.  You can edit files in that directory to change the behavior of Apache running inside the container.

### Application content
Static content that you wish to be served via Apache should live in $HOST_APACHE_APP_DIR.

### Logs
By default, without a mapping for /logs specified, the container will send the access and error logs to stdout and stderr respectively. You can optionally map a directory on the host to /logs inside the container (with another -v option); this will write the access and error logs to that directory instead.
