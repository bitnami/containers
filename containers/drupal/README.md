[![Build Status](http://bitnami-container-builds.bitnamiapp.com/jenkins/buildStatus/icon?job=docker-drupal)](http://bitnami-container-builds.bitnamiapp.com/jenkins/job/docker-drupal/)

# Bitnami Docker Image for Drupal
This is an all-in-one container for [Bitnami Drupal Stack](https://bitnami.com/stack/drupal). It includes all the required dependencies to run Drupal in a container in less than 1 minute. 

# TLDR
```
docker run --name=drupal -p 80:80 -p 443:443 bitnami/drupal
```
The application is configured with default credentials `user` / `bitnami`.

# Get this image

The recommended way to get the Bitnami Docker Image for Drupal is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/drupal).

```bash
docker pull bitnami/drupal:latest
```

To use a specific version, you can pull a versioned tag. You can view the
[list of available versions](https://hub.docker.com/r/bitnami/drupal/tags/)
in the Docker Hub Registry.

```bash
docker pull bitnami/drupal:[TAG]
```

If you wish, you can also build the image yourself.

```bash
git clone https://github.com/bitnami/bitnami-docker-drupal.git
cd bitnami-docker-drupal
docker build -t bitnami/drupal .
```

# Configuration

## Application credentials

Running the container in foreground will show some information about to access your application. If you started the
container with the flag `-d` you can retrieve it by running `docker logs drupal`.

In case you want to change the default user and password for Drupal you would need to build the image by your own following [this steps](#get-this-image)
and modifying the line `BITNAMI_APPLICATION_PASSWORD=bitnami` in the Dockerfile before starting the build.

## Application files (optional)

If you want to make the application files accessible for modifying them you could use a volume to share these files with the host. This can be done by adding some extra options to the `docker run` command:

```
docker run --name=drupal -v ~/drupal-files:/opt/bitnami/apps -e USER_UID=`id -u` -p 80:80 -p 443:443 bitnami/drupal
```
This will create a folder `drupal-files` in your home directory exposing the folder `/opt/bitnami/apps` into the container. This folder should be empty or non existent when creating the container.

NOTE: Currently is only possible to expose `/opt/bitnami/apps`. Also setting the variable USER_UID will make the files modifiable by your current user.

# Logging

The Bitnami Docker Image for Drupal will write to stdout the information about the initialization process so it is accesible by running the command `docker logs drupal`.

In order to check the logs from services as the HTTP server or databases you could use the following commands:

```
docker exec -it drupal /opt/bitnami/scripts/logs.sh apache
docker exec -it drupal /opt/bitnami/scripts/logs.sh mysql
```

# Maintenance

## Backing up your container

In order to backup your containers you could pack the `/opt/bitnami` directory and copy it to the host by running the following commands:

```
docker exec -it drupal /services.sh stop
docker exec -it drupal tar -pczvf /tmp/drupal-backup.tar.gz /opt/bitnami
docker exec -it drupal /services.sh start
docker cp drupal:/tmp/drupal-backup.tar.gz /path/to/destination/directory
```
NOTE: this commands assume that your container is named `drupal`.

## Restoring a backup

In order to restore a previously created backup of your container, you woild need to copy the compressed file into the container and uncompress it by following commands:

```
docker cp /path/to/drupal-backup.tar.gz drupal:/tmp/drupal-backup.tar.gz
docker exec -it drupal /services.sh stop
docker exec -it drupal tar -xzvf /tmp/drupal-backup.tar.gz
docker exec -it drupal /services.sh start
```
NOTE: this commands assume that your container is named `drupal`.

## Upgrade this image

This image is intended for development/testing purposes. For this reason, upgrading the individual components is not supported.

# Testing

This image is tested for expected runtime behavior, using the
[Bats](https://github.com/sstephenson/bats) testing framework. You can run the tests on your machine
using the `bats` command.

```
bats test.sh
```

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an
[issue](https://github.com/bitnami/bitnami-docker-drupal/issues), or submit a
[pull request](https://github.com/bitnami/bitnami-docker-drupal/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an
[issue](https://github.com/bitnami/bitnami-docker-drupal/issues). For us to provide better support,
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
