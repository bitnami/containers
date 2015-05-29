# Bitnami nginx Docker Container

## Introduction to Bitnami containers
Bitnami provides easy-to-use, consistently configured, and always up-to-date container images.  [Click here](https://bitnami.com) for more information on our packaging approach.

## What is nginx?
nginx (pronounced "engine-x") is an open source reverse proxy server for HTTP, HTTPS, SMTP, POP3, and IMAP protocols, as well as a load balancer, HTTP cache, and a web server (origin server).

## Usage
You can instantiate a Bitnami nginx container by doing:

```
HOST_NGINX_HTTP_PORT=8080
HOST_NGINX_HTTPS_PORT=8443
HOST_NGINX_CONF_DIR=`pwd`/nginx_conf
HOST_NGINX_APP_DIR=`pwd`/app
docker run -it \
  -p $HOST_NGINX_HTTP_PORT:80 \
  -p $HOST_NGINX_HTTPS_PORT:443 \
  -v $HOST_NGINX_CONF_DIR:/conf \
  -v $HOST_NGINX_APP_DIR:/app \
  Bitnami/nginx
```

### Ports
The command above allows you to access nginx via ports 8080 and 8443 (or whatever alternative ports you pick) on the host.  These will map to ports 80 and 443 respectively inside the container.

### Configuration
nginx configuration should live in $HOST_NGINX_CONF_DIR on the host.  You can edit files in that directory to change the behavior of nginx running inside the container. To add custom vhost entries, add appropriate configuration files in $HOST_NGINX_CONF_DIR/vhosts.

### Application content
Static content that you wish to be served via nginx should live in $HOST_NGINX_APP_DIR.

### Logs
By default, without a mapping for /logs specified, the container will send the access and error logs to stdout and stderr respectively. You can optionally map a directory on the host to /logs inside the container (with another -v option); this will write the access and error logs to that directory instead.
