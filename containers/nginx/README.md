# What is nginx?

nginx (pronounced "engine-x") is an open source reverse proxy server for HTTP, HTTPS, SMTP, POP3,
and IMAP protocols, as well as a load balancer, HTTP cache, and a web server (origin server).

# TLDR

```bash
docker run --name nginx bitnami/nginx
```

## Docker Compose

```
nginx:
  image: bitnami/nginx
```

# Get this image

The recommended way to get the Bitnami nginx Docker Image is to pull the prebuilt image from the
[Docker Hub Registry](https://hub.docker.com/u/bitnami/nginx).

```bash
docker pull bitnami/nginx:1.8.0-3
```

To always get the latest version, pull the `latest` tag.

```bash
docker pull bitnami/nginx:latest
```

If you wish, you can also build the image yourself.

```bash
git clone https://github.com/bitnami/bitnami-docker-nginx.git
cd bitnami-docker-nginx
docker build -t bitnami/nginx .
```

# Hosting a static website

This nginx image exposes a volume at `/app`. Content mounted here is served by the default catch-all
virtual host. Mounting an empty directory here will copy the default content to your volume.

```bash
docker run -v /path/to/app:/app bitnami/nginx
```

or using Docker Compose:

```
nginx:
  image: bitnami/nginx
  volumes:
    - path/to/app:/app
```

# Accessing your server from the host

To access your web server from your host machine you can ask Docker to map a random port on your
host to ports `80` and `443` exposed in the container.

```bash
docker run --name nginx -P bitnami/nginx
```

Run `docker port` to determine the random ports Docker assigned.

```bash
$ docker port nginx
443/tcp -> 0.0.0.0:32768
80/tcp -> 0.0.0.0:32769
```

You can also manually specify the ports you want forwarded from your host to the container.

```bash
docker run -p 8080:80 8443:443 bitnami/nginx
```

Access your web server in the browser by navigating to
[http://localhost:8080](http://localhost:8080/).

# Configuration

## Adding custom virtual hosts

The default nginx.conf includes virtual hosts placed in `/bitnami/nginx/conf/vhosts/*.conf`. You can
mount a directory at `/bitnami/nginx/conf/vhosts` from your host containing your custom virtual
hosts.

```bash
docker run -v /path/to/nginx/vhosts:/bitnami/nginx/conf/vhosts bitnami/nginx
```

or using Docker Compose:

```
nginx:
  image: bitnami/nginx
  volumes:
    - path/to/nginx/vhosts:/bitnami/nginx/conf/vhosts
```

## Full configuration

This container looks for configuration in `/bitnami/nginx/conf`. You can mount a directory there
with your own configuration, or the default configuration will be copied to your directory if it is
empty.

### Step 1: Run the nginx image

Run the nginx image, mounting a directory from your host.

```bash
docker run --name nginx -v /path/to/nginx/conf:/bitnami/nginx/conf bitnami/nginx
```

or using Docker Compose:

```
nginx:
  image: bitnami/nginx
  volumes:
    - path/to/nginx/conf:/bitnami/nginx/conf
```

### Step 2: Edit the configuration

Edit the configuration on your host using your favorite editor.

```bash
vi /path/to/nginx/conf/nginx.conf
```

### Step 4: Restart nginx

After changing the configuration, restart your nginx container for changes to take effect.

```bash
docker restart nginx
```

or using Docker Compose:

```bash
docker-compose restart nginx
```

**Note!**

You can also reload the nginx configuration by sending the `HUP` signal to the container using the `docker kill` command.

```bash
docker kill -s HUP nginx
```

# Reverse proxy to other containers

nginx can be used to reverse proxy to other containers using Docker's linking system. This is
particularly useful if you want to serve dynamic content through an nginx frontend. Bitnami provides
example virtual hosts for all of our runtime containers in `/bitnami/nginx/conf/vhosts/`.

**Further Reading:**

  - [nginx reverse proxy](http://nginx.com/resources/admin-guide/reverse-proxy/)

# Logging

The Bitnami nginx Docker Image supports two different logging modes: logging to stdout, and logging
to a file.

## Logging to stdout

The default behavior is to log to stdout, as Docker expects. These will be collected by Docker,
converted to JSON and stored in the host, to be accessible via the `docker logs` command.

```bash
docker logs nginx
```

or using Docker Compose:

```bash
docker-compose logs nginx
```

This method of logging has the downside of not being easy to manage. Without an easy way to rotate
logs, they could grow exponentially and take up large amounts of disk space on your host.

## Logging to file

To log to file, run the nginx image, mounting a directory from your host at `/bitnami/nginx/logs`.
This will instruct the container to send logs to your directory.

```bash
docker run --name nginx -v /path/to/nginx/logs:/bitnami/nginx/logs bitnami/nginx
```

or using Docker Compose:

```
nginx:
  image: bitnami/nginx
  volumes:
    - path/to/nginx/logs:/bitnami/nginx/logs
```

To perform operations (e.g. logrotate) on the logs, mount the same directory in a container designed
to operate on log files, such as logstash.

# Maintenance

## Backing up your container

To backup your configuration and logs, follow these simple steps:

### Step 1: Stop the currently running container

```bash
docker stop nginx
```

or using Docker Compose:

```bash
docker-compose stop nginx
```

### Step 2: Run the backup command

We need to mount two volumes in a container we will use to create the backup: a directory on your
host to store the backup in, and the volumes from the container we just stopped so we can access the
data.

```bash
docker run --rm -v /path/to/backups:/backups --volumes-from nginx busybox \
  cp -a /bitnami/nginx /backups/latest
```

or using Docker Compose:

```bash
docker run --rm -v /path/to/backups:/backups --volumes-from `docker-compose ps -q nginx` busybox \
  cp -a /bitnami/nginx /backups/latest
```

**Note!**
If you only need to backup configuration, you can change the first argument to `cp` to
`/bitnami/nginx/conf`.

## Restoring a backup

Restoring a backup is as simple as mounting the backup as volumes in the container.

```bash
docker run -v /path/to/backups/latest/conf:/bitnami/nginx/conf \
  -v /path/to/backups/latest/logs:/bitnami/nginx/logs \
  bitnami/nginx
```

or using Docker Compose:

```
nginx:
  image: bitnami/nginx
  volumes:
    - path/to/backups/latest/conf:/bitnami/nginx/conf
    - path/to/backups/latest/logs:/bitnami/nginx/logs
```

## Upgrade this image

Bitnami provides up-to-date versions of nginx, including security patches, soon after they are made
upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```bash
docker pull bitnami/nginx:1.8.0-3
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/nginx:1.8.0-3`.

### Step 2: Stop and backup the currently running container

Before continuing, you should backup your container's configuration and logs, unless you are
mounting these volumes from your host.

Follow the steps on [creating a backup](#backing-up-your-container).

### Step 3: Remove the currently running container

```bash
docker rm -v nginx
```

or using Docker Compose:

```bash
docker-compose rm -v nginx
```

### Step 4: Run the new image

Re-create your container from the new image, [restoring your backup](#restoring-a-backup) if
necessary.

```bash
docker run --name nginx bitnami/nginx:1.8.0-3
```

or using Docker Compose:

```bash
docker-compose start nginx
```

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an
[issue](https://github.com/bitnami/bitnami-docker-nginx/issues), or submit a
[pull request](https://github.com/bitnami/bitnami-docker-nginx/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an
[issue](https://github.com/bitnami/bitnami-docker-nginx/issues). For us to provide better support,
be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_APP_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive
information)

# License

Copyright 2015 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
