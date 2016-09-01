[![Docker Hub Automated Build](http://container.checkforupdates.com/badges/bitnami/kibana)](https://hub.docker.com/r/bitnami/kibana/)
# What is Kibana?

> Kibana is an open source, browser based analytics and search dashboard for Elasticsearch. Kibana is a snap to setup and start using. Kibana strives to be easy to get started with, while also being flexible and powerful, just like Elasticsearch

[elastic.co/products/kibana](https://www.elastic.co/products/kibana)

# TLDR

```bash
docker run --name kibana bitnami/kibana:latest
```

## Docker Compose

```
kibana:
  image: bitnami/kibana:latest
```

# Get this image

The recommended way to get the Bitnami Kibana Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/kibana).

```bash
docker pull bitnami/kibana:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/kibana/tags/) in the Docker Hub Registry.

```bash
docker pull bitnami/kibana:[TAG]
```

If you wish, you can also build the image yourself.

```bash
docker build -t bitnami/kibana:latest https://github.com/bitnami/bitnami-docker-kibana.git
```
# How to use this image

## Run the application using Docker Compose

This is the recommended way to run Kibana. You can use the following docker compose template:

```
version: '2'

services:
  application:
    image: 'bitnami/kibana:latest'
    ports:
      - 5601:5601
    environment:
      - ELASTICSEARCH_URL=elasticsearch
    volumes:
      - 'kibana_data:/bitnami/kibana'
  elasticsearch:
    image: 'bitnami/elasticsearc:latest'
    ports:
      - 9200:9200
    volumes:
      - 'elasticsearch_data:/bitnami/elasticsearch'
volumes:
  kibana_data:
    driver:local
  elasticsearch_data:
    driver:local
```

## Run the application manually

If you want to run the application manually instead of using docker-compose, these are the basic steps you need to run:

1. Create a new network for the application and the database:

  ```
  $ docker network create kibana_network
  ```

2. Run the Elasticsearch container:

  ```
  $ docker run -d -p 9200:9200 --name elasticsearch --net=kibana_network bitnami/elasticsearch
  ```

3. Run the Kibana container:

  ```
  $ docker run -d -p 5601:5601 -e ELASTICSEARCH_URL=elasticsearch --name kibana --net=kibana_network bitnami/kibana
  ```

Then you can access your application at http://your-ip:5601/


# Persisting your database

If you remove the container all your data and configurations will be lost, and the next time you run the image the data and configurations will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

**Note!**
If you have already started using your database, follow the steps on [backing up](#backing-up-your-container) and [restoring](#restoring-a-backup) to pull the data from your running container down to your host.

The image exposes a volume at `/bitnami/kibana` for the Kibana data and configurations. For persistence you can mount a directory at this location from your host. If the mounted directory is empty, it will be initialized on the first run.

```bash
docker run -v /path/to/kibana-persistence:/bitnami/kibana bitnami/kibana:latest
```

or using Docker Compose:

```
kibana:
  image: bitnami/kibana:latest
  volumes:
    - /path/to/kibana-persistence:/bitnami/kibana
```

# Linking

If you want to connect to your Kibana server inside another container, you can use the linking system provided by Docker.

## Connecting a Kibana client container to the Kibana server container

### Step 1: Run the Kibana image with a specific name

The first step is to start our Kibana server.

Docker's linking system uses container ids or names to reference containers. We can explicitly specify a name for our Kibana server to make it easier to connect to other containers.

```bash
docker run --name kibana bitnami/kibana:latest
```

### Step 2: Run Kibana as a client and link to our server

Now that we have our Kibana server running, we can create another container that links to it by giving Docker the `--link` option. This option takes the id or name of the container we want to link it to as well as a hostname to use inside the container, separated by a colon. For example, to have our Kibana server accessible in another container with `server` as it's hostname we would pass `--link kibana:server` to the Docker run command.

The Bitnami Kibana Docker Image also ships with a Kibana client, but by default it will start a server. To start the client instead, we can override the default command Docker runs by stating a different command to run after the image name.

```bash
docker run --rm -it --link kibana:server bitnami/kibana:latest kibana-cli -h server
```

We started the Kibana client passing in the `-h` option that allows us to specify the hostname of the server, which we set to the hostname we created in the link.

**Note!**
You can also run the Kibana client in the same container the server is running in using the Docker [exec](https://docs.docker.com/reference/commandline/cli/#exec) command.

```bash
docker exec -it kibana kibana-cli
```

## Linking with Docker Compose

### Step 1: Add a Kibana entry in your `docker-compose.yml`

Copy the snippet below into your `docker-compose.yml` to add Kibana to your application.

```
kibana:
  image: bitnami/kibana:latest
```

### Step 2: Link it to another container in your application

Update the definitions for containers you want to access your Kibana server from to include a link to the `kibana` entry you added in Step 1.

```
myapp:
  image: myapp
  links:
    - kibana:kibana
```

Inside `myapp`, use `kibana` as the hostname for the Kibana server.

# Configuration

## Configuration file

The image looks for configuration in the `conf/` directory of `/bitnami/kibana`. As as mentioned in [Persisting your database](#persisting-your-data) you can mount a volume at this location and copy your own configurations in the `conf/` directory. The default configuration will be copied to the `conf/` directory if it's empty.

### Step 1: Run the Kibana image

Run the Kibana image, mounting a directory from your host.

```bash
docker run --name kibana -v /path/to/kibana-persistence:/bitnami/kibana bitnami/kibana:latest
```

or using Docker Compose:

```
kibana:
  image: bitnami/kibana:latest
  volumes:
    - /path/to/kibana-persistence:/bitnami/kibana
```

### Step 2: Edit the configuration

Edit the configuration on your host using your favorite editor.

```bash
vi /path/to/kibana-persistence/conf/kibana.conf
```

### Step 3: Restart Kibana

After changing the configuration, restart your Kibana container for changes to take effect.

```bash
docker restart kibana
```

or using Docker Compose:

```bash
docker-compose restart kibana
```

**Further Reading:**

  - [Kibana Configuration Documentation](http://kibana.io/topics/config)

# Logging

The Bitnami Kibana Docker image sends the container logs to the `stdout`. To view the logs:

```bash
docker logs kibana
```

or using Docker Compose:

```bash
docker-compose logs kibana
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Maintenance

## Backing up your container

To backup your data, configuration and logs, follow these simple steps:

### Step 1: Stop the currently running container

```bash
docker stop kibana
```

or using Docker Compose:

```bash
docker-compose stop kibana
```

### Step 2: Run the backup command

We need to mount two volumes in a container we will use to create the backup: a directory on your host to store the backup in, and the volumes from the container we just stopped so we can access the data.

```bash
docker run --rm -v /path/to/kibana-backups:/backups --volumes-from kibana busybox \
  cp -a /bitnami/kibana:latest /backups/latest
```

or using Docker Compose:

```bash
docker run --rm -v /path/to/kibana-backups:/backups --volumes-from `docker-compose ps -q kibana` busybox \
  cp -a /bitnami/kibana:latest /backups/latest
```

## Restoring a backup

Restoring a backup is as simple as mounting the backup as volumes in the container.

```bash
docker run -v /path/to/kibana-backups/latest:/bitnami/kibana bitnami/kibana:latest
```

or using Docker Compose:

```
kibana:
  image: bitnami/kibana:latest
  volumes:
    - /path/to/kibana-backups/latest:/bitnami/kibana
```

## Upgrade this image

Bitnami provides up-to-date versions of Kibana, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```bash
docker pull bitnami/kibana:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/kibana:latest`.

### Step 2: Stop and backup the currently running container

Before continuing, you should backup your container's data, configuration and logs.

Follow the steps on [creating a backup](#backing-up-your-container).

### Step 3: Remove the currently running container

```bash
docker rm -v kibana
```

or using Docker Compose:

```bash
docker-compose rm -v kibana
```

### Step 4: Run the new image

Re-create your container from the new image, [restoring your backup](#restoring-a-backup) if necessary.

```bash
docker run --name kibana bitnami/kibana:latest
```

or using Docker Compose:

```bash
docker-compose start kibana
```
# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-kibana/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-kibana/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-kibana/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_APP_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License
Copyright 2016 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
