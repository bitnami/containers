
# What is Parse Dashboard?

> Parse Dashboard is a standalone dashboard for managing your Parse apps. You can use it to manage your Parse Server apps and your apps that are running on Parse.com.

http://www.parse.com/

# TL;DR;

## Docker Compose

```bash
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-parse-dashboard/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DTC)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/parse-dashboard?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/containers/how-to/work-with-non-root-containers/).

# Supported tags and respective `Dockerfile` links

> NOTE: Debian 9 images have been deprecated in favor of Debian 10 images. Bitnami will not longer publish new Docker images based on Debian 9.

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/).


* [`2-ol-7`, `2.0.5-ol-7-r101` (2/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-parse-dashboard/blob/2.0.5-ol-7-r101/2/ol-7/Dockerfile)
* [`2-debian-10`, `2.0.5-debian-10-r8`, `2`, `2.0.5`, `latest` (2/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-parse-dashboard/blob/2.0.5-debian-10-r8/2/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/parse-dashboard GitHub repo](https://github.com/bitnami/bitnami-docker-parse-dashboard).

# Prerequisites

To run this application you need Docker Engine 1.10.0. Docker Compose is recomended with a version 1.6.0 or later.

# How to use this image

### Run the application using Docker Compose

The main folder of this repository contains a functional [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-parse-dashboard/blob/master/docker-compose.yml) file. Run the application using it as shown below:

```bash
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-parse-dashboard/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

### Run the application manually

If you want to run the application manually instead of using docker-compose, these are the basic steps you need to run:

1. Create a network for the application, Parse Server and the database:

  ```bash
  $ docker network create parse_dashboard-tier
  ```

2. Start a MongoDB database in the network generated:

  ```bash
  $ docker run -d --name mongodb --net=parse_dashboard-tier bitnami/mongodb
  ```

  *Note:* You need to give the container a name in order to Parse to resolve the host.

3. Start a Parse Server container:

  ```bash
  $ docker run -d -p 1337:1337 --name parse --net=parse_dashboard-tier bitnami/parse
  ```

4. Run the Parse Dashboard container:

  ```bash
  $ docker run -d -p 80:4040 --name parse-dashboard --net=parse_dashboard-tier bitnami/parse-dashboard
  ```

Then you can access your application at http://your-ip/

## Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a volume at the `/bitnami` path. Additionally you should mount a volume for the persistence of [MongoDB](https://github.com/bitnami/bitnami-docker-mongodb#persisting-your-database) and [Parse](https://github.com/bitnami/bitnami-docker-parse#persisting-your-application) data.

The above examples define docker volumes namely `mongodb_data`, `parse_data` and `parse_dashboard_data`. The application state will persist as long as these volumes are not removed.

To avoid inadvertent removal of these volumes you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

### Mount host directories as data volumes with Docker Compose

This requires a minor change to the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-parse-dashboard/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  mongodb:
  ...
    volumes:
      - '/path/to/mongodb-persistence:/bitnami'
  ...
  parse:
  ...
    volumes:
      - '/path/to/parse-persistence:/bitnami'
  ...
  parse-dashboard:
  ...
    volumes:
      - '/path/to/parse_dashboard-persistence:/bitnami'
  ...
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

### Mount host directories as data volumes using the Docker command line

In this case you need to specify the directories to mount on the run command. The process is the same than the one previously shown:

1. Create a network (if it does not exist):

  ```bash
  $ docker network create parse_dashboard-tier
  ```

2. Create a MongoDB container with host volume:

  ```bash
  $ docker run -d --name mongodb \
    --net parse-dashboard-tier \
    --volume /path/to/mongodb-persistence:/bitnami \
    bitnami/mongodb:latest
  ```

  *Note:* You need to give the container a name in order to Parse to resolve the host.

3. Start a Parse Server container:

  ```bash
  $ docker run -d -name parse -p 1337:1337 \
    --net parse-dashboard-tier
    --volume /path/to/parse-persistence:/bitnami \
    bitnami/parse:latest
  ```

4. Run the Parse Dashboard container:

  ```bash
  $ docker run -d --name parse-dashboard -p 80:4040 \
  --volume /path/to/parse_dashboard-persistence:/bitnami \
  bitnami/parse-dashboard:latest
  ```

# Upgrade this application

Bitnami provides up-to-date versions of Parse Dashboard, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the Parse Dashboard container.

1. Get the updated images:

```bash
$ docker pull bitnami/parse-dashboard:latest
```

2. Stop your container

 * For docker-compose: `$ docker-compose stop parse-dashboard`
 * For manual execution: `$ docker stop parse-dashboard`

3. Take a snapshot of the application state

```bash
$ rsync -a /path/to/parse-persistence /path/to/parse-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

Additionally, snapshot the [MongoDB](https://github.com/bitnami/bitnami-docker-mongodb#step-2-stop-and-backup-the-currently-running-container) and [Parse server](https://github.com/bitnami/bitnami-docker-parse#step-2-stop-and-backup-the-currently-running-container) data.

You can use these snapshots to restore the application state should the upgrade fail.

4. Remove the currently running container

 * For docker-compose: `$ docker-compose rm parse-dashboard`
 * For manual execution: `$ docker rm parse-dashboard`

5. Run the new image

 * For docker-compose: `$ docker-compose up parse-dashboard`
 * For manual execution ([mount](#mount-persistent-folders-manually) the directories if needed): `docker run --name parse-dashboard bitnami/parse-dashboard:latest`

# Configuration

## Environment variables

When you start the parse-dashboard image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the docker run command line. If you want to add a new environment variable:

 * For docker-compose add the variable name and value under the application section in the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-parse-dashboard/blob/master/docker-compose.yml) file present in this repository:


```yaml
parse-dashboard:
  ...
  environment:
    - PARSE_DASHBOARD_PASSWORD=my_password
  ...
```

 * For manual execution add a `-e` option with each variable and value:

```bash
 $ docker run -d -e PARSE_DASHBOARD_PASSWORD=my_password -p 80:4040 --name parse-dashboard -v /your/local/path/bitnami/parse_dashboard:/bitnami --network=parse_dashboard-tier bitnami/parse-dashboard
```

Available variables:
 - `PARSE_DASHBOARD_USER`: Parse Dashboard application username. Default: **user**
 - `PARSE_DASHBOARD_PASSWORD`: Parse Dashboard application password. Default: **bitnami**
 - `PARSE_HOST`: Host used by Parse Dashboard to form the URLs to Parse Server.
 - `PARSE_PROTOCOL`: Protocol used by Parse Dashboard to form the URLs to Parse Server. Default: **http**
 - `PARSE_USE_HOSTNAME`: Whether to use a hostname or an IP to configure the "serverURL" setting. Default: **no**
 - `PARSE_PORT_NUMBER`: Parse Server Port. Default: **1337**
 - `PARSE_APP_ID`: Parse Server App Id. Default: **myappID**
 - `PARSE_MASTER_KEY`: Parse Server Master Key. Default: **mymasterKey**
 - `PARSE_DASHBOARD_APP_NAME`: Parse Dashboard application name. Default: **MyDashboard**

# Notable Changes

## 1.2.0-r69

- The Parse Dashboard container has been migrated to a non-root user approach. Previously the container ran as the `root` user and the Parse Dashboard daemon was started as the `parsedashboard` user. From now on, both the container and the Parse Dashboard daemon run as user `1001`. As a consequence, the data directory must be writable by that user. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-parse-dashboard/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-parse-dashboard/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-parse-dashboard/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_APP_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright 2016-2020 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
