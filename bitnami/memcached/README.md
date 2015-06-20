[![Build Status](http://bitnami-container-builds.bitnamiapp.com/jenkins/buildStatus/icon?job=docker-memcached)](http://bitnami-container-builds.bitnamiapp.com/jenkins/job/docker-memcached/)

# What is Memcached?

> Memcached is an in-memory key-value store for small chunks of arbitrary data (strings, objects)
> from results of database calls, API calls, or page rendering.

[memcached.org](http://memcached.org/)

# TLDR

```bash
docker run --name memcached bitnami/memcached
```

## Docker Compose

```
memcached:
  image: bitnami/memcached
```

# Get this image

The recommended way to get the Bitnami Memcached Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com).

```bash
docker pull bitnami/memcached:latest
```

To use a specific version, you can pull a versioned tag. You can view the
[list of available versions](https://registry.hub.docker.com/u/bitnami/memcached/tags/manage/)
in the Docker Hub Registry.

```bash
docker pull bitnami/memcached:[TAG]
```

If you wish, you can also build the image yourself.

```bash
git clone https://github.com/bitnami/bitnami-docker-memcached.git
cd bitnami-docker-memcached
docker build -t bitnami/memcached .
```


# Linking

If you want to connect to your Memcached server inside another container, you can use the linking
system provided by Docker.

## Connecting your app container to the Memcached server container

### Step 1: Run the Memcached image with a specific name

The first step is to start our Memcached server.

Docker's linking system uses container ids or names to reference containers. We can explicitly
specify a name for our Memcached server to make it easier to connect to other containers.

```bash
docker run --name memcached bitnami/memcached
```

### Step 2: Run your app and link to our server

Now that we have our Memcached server running, we can create another container that links to it by
giving Docker the `--link` option. This option takes the id or name of the container we want to link
it to as well as a hostname to use inside the container, separated by a colon. For example, to have
our Memcached server accessible in another container with `memcached` as it's hostname we would pass
`--link memcached:memcached` to the Docker run command.

```bash
docker run -it --link memcached:memcached myapp
```

Inside `myapp`, use `memcached` as the hostname for the Memcached server.

## Linking with Docker Compose

### Step 1: Add a Memcached entry in your `docker-compose.yml`

Copy the snippet below into your `docker-compose.yml` to add Memcached to your application.

```
memcached:
  image: bitnami/memcached
```

### Step 2: Link it to another container in your application

Update the definitions for containers you want to access your Memcached server from to include a
link to the `memcached` entry you added in Step 1.

```
myapp:
  image: myapp
  links:
    - memcached:memcached
```

# Configuration

## Setting the server password on first run

Passing the `MEMCACHED_PASSWORD` environment variable when running the image for the first time will
set the Memcached server password to the value of `MEMCACHED_PASSWORD`.

```bash
docker run --name memcached -e MEMCACHED_PASSWORD=password123 bitnami/memcached
```

or using Docker Compose:

```
memcached:
  image: bitnami/memcached
  environment:
    - MEMCACHED_PASSWORD=password123
```

## Command-line options

You can configure your Memcached server by passing command-line options when running the image.

```bash
# Setting max connections to 100
docker run --name memcached bitnami/memcached -c 100
```

or using Docker Compose:

```
memcached:
  image: bitnami/memcached
  command: -c 10
```

**Further Reading:**

  - [Memcached Configuration Documentation](https://code.google.com/p/memcached/wiki/NewConfiguringServer)

# Logging

The Bitnami Memcached Docker Image supports two different logging modes: logging to stdout, and
logging to a file.

## Logging to stdout

The default behavior is to log to stdout, as Docker expects. These will be collected by Docker,
converted to JSON and stored in the host, to be accessible via the `docker logs` command.

```bash
docker logs memcached
```

or using Docker Compose:

```bash
docker-compose logs memcached
```

This method of logging has the downside of not being easy to manage. Without an easy way to rotate
logs, they could grow exponentially and take up large amounts of disk space on your host.

## Logging to file

To log to file, run the Memcached image, mounting a directory from your host at `/bitnami/memcached/logs`.
This will instruct the container to send logs to a `memcached.log` file in the mounted volume.

```bash
docker run --name memcached -v /path/to/memcached/logs:/bitnami/memcached/logs bitnami/memcached
```

or using Docker Compose:

```
memcached:
  image: bitnami/memcached
  volumes:
    - /path/to/memcached/logs:/bitnami/memcached/logs
```

To perform operations (e.g. logrotate) on the logs, mount the same directory in a container designed
to operate on log files, such as logstash.

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of Memcached, including security patches, soon after they are
made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```bash
docker pull bitnami/memcached:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/memcached:latest`.

### Step 2: Remove the currently running container

```bash
docker rm -v memcached
```

or using Docker Compose:

```bash
docker-compose rm -v memcached
```

### Step 3: Run the new image

Re-create your container from the new image.

```bash
docker run --name memcached bitnami/memcached:latest
```

or using Docker Compose:

```bash
docker-compose start memcached
```

# Testing

This image is tested for expected runtime behavior, using the
[Bats](https://github.com/sstephenson/bats) testing framework. You can run the tests on your machine
using the `bats` command.

```
bats test.sh
```

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an
[issue](https://github.com/bitnami/bitnami-docker-memcached/issues), or submit a
[pull request](https://github.com/bitnami/bitnami-docker-memcached/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an
[issue](https://github.com/bitnami/bitnami-docker-memcached/issues). For us to provide better support,
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
