# What is Redis?

> Redis is an advanced key-value cache and store. It is often referred to as a data structure server
> since keys can contain strings, hashes, lists, sets, sorted sets, bitmaps and hyperloglogs.

[redis.io](http://redis.io/)

# TLDR

```bash
docker run --name redis bitnami/redis
```

## Docker Compose

```
redis:
  image: bitnami/redis
```

# Get this image

The recommended way to get the Bitnami Redis Docker Image is to pull the prebuilt image from the
[Docker Hub Registry](https://hub.docker.com/u/bitnami/redis).

```bash
docker pull bitnami/redis:latest
```

To use a specific version, you can pull a versioned tag. You can view the
[list of available versions](https://registry.hub.docker.com/u/bitnami/redis/tags/manage/)
in the Docker Hub Registry.

```bash
docker pull bitnami/redis:[TAG]
```

If you wish, you can also build the image yourself.

```bash
git clone https://github.com/bitnami/bitnami-docker-redis.git
cd bitnami-docker-redis
docker build -t bitnami/redis .
```

# Persisting your database

If you remove the container all your data will be lost, and the next time you run the image the
database will be reinitialized. To avoid this loss of data, you should mount a volume that will
persist even after the container is removed.

**Note!**
If you have already started using your database, follow the steps on
[backing up](#backing-up-your-container) and [restoring](#restoring-a-backup) to pull the data from
your running container down to your host.

The Redis image exposes a volume at `/bitnami/redis/data`, you can mount a directory from your
host to serve as the data store. If the directory you mount is empty, the database will be
initialized.

```bash
docker run -v /path/to/data:/bitnami/redis/data bitnami/redis
```

or using Docker Compose:

```
redis:
  image: bitnami/redis
  volumes:
    - /path/to/data:/bitnami/redis/data
```

# Linking

If you want to connect to your Redis server inside another container, you can use the linking
system provided by Docker.

## Connecting a Redis client container to the Redis server container

### Step 1: Run the Redis image with a specific name

The first step is to start our Redis server.

Docker's linking system uses container ids or names to reference containers. We can explicitly
specify a name for our Redis server to make it easier to connect to other containers.

```bash
docker run --name redis bitnami/redis
```

### Step 2: Run Redis as a client and link to our server

Now that we have our Redis server running, we can create another container that links to it by
giving Docker the `--link` option. This option takes the id or name of the container we want to link
it to as well as a hostname to use inside the container, separated by a colon. For example, to have
our Redis server accessible in another container with `server` as it's hostname we would pass
`--link redis:server` to the Docker run command.

The Bitnami Redis Docker Image also ships with a Redis client, but by default it will start a
server. To start the client instead, we can override the default command Docker runs by stating a
different command to run after the image name.

```bash
docker run --rm -it --link redis:server bitnami/redis redis-cli -h server
```

We started the Redis client passing in the `-h` option that allows us to specify the hostname of the
server, which we set to the hostname we created in the link.

**Note!**
You can also run the Redis client in the same container the server is running in using the Docker
[exec](https://docs.docker.com/reference/commandline/cli/#exec) command.

```bash
docker exec -it redis-server redis-cli
```

## Linking with Docker Compose

### Step 1: Add a Redis entry in your `docker-compose.yml`

Copy the snippet below into your `docker-compose.yml` to add Redis to your application.

```
redis:
  image: bitnami/redis
```

### Step 2: Link it to another container in your application

Update the definitions for containers you want to access your Redis server from to include a link
to the `redis` entry you added in Step 1.

```
myapp:
  image: myapp
  links:
    - redis:redis
```

Inside `myapp`, use `redis` as the hostname for the Redis server.

# Configuration

## Setting the server password on first run

Passing the `REDIS_PASSWORD` environment variable when running the image for the first time will
set the Redis server password to the value of `REDIS_PASSWORD`.

```bash
docker run --name redis -e REDIS_PASSWORD=password123 bitnami/redis
```

or using Docker Compose:

```
redis:
  image: bitnami/redis
  environment:
    - REDIS_PASSWORD=password123
```

## Command-line options

The simplest way to configure your Redis server is to pass custom command-line options when
running the image.

```bash
docker run bitnami/redis --maxclients 10
```

or using Docker Compose:

```
redis:
  image: bitnami/redis
  command: --maxclients 10
```

## Configuration file

This image looks for configuration in `/bitnami/redis/conf`. You can mount a volume there with
your own configuration, or the default configuration will be copied to your volume if it is empty.

### Step 1: Run the Redis image

Run the Redis image, mounting a directory from your host.

```bash
docker run --name redis -v /path/to/redis/conf:/bitnami/redis/conf bitnami/redis
```

or using Docker Compose:

```
redis:
  image: bitnami/redis
  volumes:
    - /path/to/redis/conf:/bitnami/redis/conf
```

### Step 2: Edit the configuration

Edit the configuration on your host using your favorite editor.

```bash
vi /path/to/redis/conf/redis.conf
```

### Step 3: Restart Redis

After changing the configuration, restart your Redis container for changes to take effect.

```bash
docker restart redis
```

or using Docker Compose:

```bash
docker-compose restart redis
```

**Further Reading:**

  - [Redis Configuration Documentation](http://redis.io/topics/config)

# Logging

The Bitnami Redis Docker Image supports two different logging modes: logging to stdout, and
logging to a file.

## Logging to stdout

The default behavior is to log to stdout, as Docker expects. These will be collected by Docker,
converted to JSON and stored in the host, to be accessible via the `docker logs` command.

```bash
docker logs redis
```

or using Docker Compose:

```bash
docker-compose logs redis
```

This method of logging has the downside of not being easy to manage. Without an easy way to rotate
logs, they could grow exponentially and take up large amounts of disk space on your host.

## Logging to file

To log to file, run the Redis image, mounting a directory from your host at `/bitnami/redis/logs`.
This will instruct the container to send logs to a `redis-server.log` file in the mounted volume.

```bash
docker run --name redis -v /path/to/redis/logs:/bitnami/redis/logs bitnami/redis
```

or using Docker Compose:

```
redis:
  image: bitnami/redis
  volumes:
    - /path/to/redis/logs:/bitnami/redis/logs
```

To perform operations (e.g. logrotate) on the logs, mount the same directory in a container designed
to operate on log files, such as logstash.

# Maintenance

## Backing up your container

To backup your data, configuration and logs, follow these simple steps:

### Step 1: Stop the currently running container

```bash
docker stop redis
```

or using Docker Compose:

```bash
docker-compose stop redis
```

### Step 2: Run the backup command

We need to mount two volumes in a container we will use to create the backup: a directory on your
host to store the backup in, and the volumes from the container we just stopped so we can access the
data.

```bash
docker run --rm -v /path/to/backups:/backups --volumes-from redis busybox \
  cp -a /bitnami/redis /backups/latest
```

or using Docker Compose:

```bash
docker run --rm -v /path/to/backups:/backups --volumes-from `docker-compose ps -q redis` busybox \
  cp -a /bitnami/redis /backups/latest
```

**Note!**
If you only need to backup database data, or configuration, you can change the first argument to
`cp` to `/bitnami/redis/data` or `/bitnami/redis/conf` respectively.

## Restoring a backup

Restoring a backup is as simple as mounting the backup as volumes in the container.

```bash
docker run -v /path/to/backups/latest/data:/bitnami/redis/data \
  -v /path/to/backups/latest/conf:/bitnami/redis/conf \
  -v /path/to/backups/latest/logs:/bitnami/redis/logs \
  bitnami/redis
```

or using Docker Compose:

```
redis:
  image: bitnami/redis
  volumes:
    - /path/to/backups/latest/data:/bitnami/redis/data
    - /path/to/backups/latest/conf:/bitnami/redis/conf
    - /path/to/backups/latest/logs:/bitnami/redis/logs
```

## Upgrade this image

Bitnami provides up-to-date versions of Redis, including security patches, soon after they are
made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```bash
docker pull bitnami/redis:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/redis:latest`.

### Step 2: Stop and backup the currently running container

Before continuing, you should backup your container's data, configuration and logs.

Follow the steps on [creating a backup](#backing-up-your-container).

### Step 3: Remove the currently running container

```bash
docker rm -v redis
```

or using Docker Compose:

```bash
docker-compose rm -v redis
```

### Step 4: Run the new image

Re-create your container from the new image, [restoring your backup](#restoring-a-backup) if
necessary.

```bash
docker run --name redis bitnami/redis:latest
```

or using Docker Compose:

```bash
docker-compose start redis
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
[issue](https://github.com/bitnami/bitnami-docker-redis/issues), or submit a
[pull request](https://github.com/bitnami/bitnami-docker-redis/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an
[issue](https://github.com/bitnami/bitnami-docker-redis/issues). For us to provide better support,
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
