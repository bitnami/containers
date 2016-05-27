[![Build Status](http://bitnami-container-builds.bitnamiapp.com/jenkins/buildStatus/icon?job=docker-memcached)](http://bitnami-container-builds.bitnamiapp.com/jenkins/job/docker-memcached/)

# What is Memcached?

> Memcached is an in-memory key-value store for small chunks of arbitrary data (strings, objects) from results of database calls, API calls, or page rendering.

[memcached.org](http://memcached.org/)

# TLDR

```bash
docker run --name memcached bitnami/memcached:latest
```

## Docker Compose

```yaml
memcached:
  image: bitnami/memcached:latest
```

# Get this image

The recommended way to get the Bitnami Memcached Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com).

```bash
docker pull bitnami/memcached:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/memcached/tags/) in the Docker Hub Registry.

```bash
docker pull bitnami/memcached:[TAG]
```

If you wish, you can also build the image yourself.

```bash
docker build -t bitnami/memcached:latest https://github.com/bitnami/bitnami-docker-memcached.git
```


# Linking

If you want to connect to your Memcached server inside another container, you can use the linking system provided by Docker.

## Connecting your app container to the Memcached server container

### Step 1: Run the Memcached image with a specific name

The first step is to start our Memcached server.

Docker's linking system uses container ids or names to reference containers. We can explicitly specify a name for our Memcached server to make it easier to connect to other containers.

```bash
docker run --name memcached bitnami/memcached:latest
```

### Step 2: Run your app and link to our server

Now that we have our Memcached server running, we can create another container that links to it by giving Docker the `--link` option. This option takes the id or name of the container we want to link it to as well as a hostname to use inside the container, separated by a colon. For example, to have our Memcached server accessible in another container with `memcached` as it's hostname we would pass `--link memcached:memcached` to the Docker run command.

```bash
docker run -it --link memcached:memcached myapp
```

Inside `myapp`, use `memcached` as the hostname for the Memcached server.

## Linking with Docker Compose

### Step 1: Add a Memcached entry in your `docker-compose.yml`

Copy the snippet below into your `docker-compose.yml` to add Memcached to your application.

```yaml
memcached:
  image: bitnami/memcached
```

### Step 2: Link it to another container in your application

Update the definitions for containers you want to access your Memcached server from to include a link to the `memcached` entry you added in Step 1.

```yaml
myapp:
  image: myapp
  links:
    - memcached:memcached
```

# Configuration

## Creating the Memcached admin user

Authentication on the Memcached server is disabled by default. To enable authentication, specify a username and password for the Memcached admin user using the `MEMCACHED_USER` and `MEMCACHED_PASSWORD` environment variables.

```bash
docker run --name memcached \
  -e MEMCACHED_USER=my_user \
  -e MEMCACHED_PASSWORD=my_password \
  bitnami/memcached:latest
```

or using Docker Compose:

```yaml
memcached:
  image: bitnami/memcached:latest
  environment:
    - MEMCACHED_USER=my_user
    - MEMCACHED_PASSWORD=my_password
```

> The default value of the `MEMCACHED_USER` is `root`.

# Logging

The Bitnami Memcached Docker image sends the container logs to the `stdout`. To view the logs:

```bash
docker logs memcached
```

or using Docker Compose:

```bash
docker-compose logs memcached
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of Memcached, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

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

This image is tested for expected runtime behavior, using the [Bats](https://github.com/sstephenson/bats) testing framework. You can run the tests on your machine using the `bats` command.

```
bats test.sh
```

# Notable Changes

## 1.4.25-r0

- The logs are always sent to the `stdout` and are no longer collected in the volume.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-memcached/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-memcached/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-memcached/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_APP_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

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
