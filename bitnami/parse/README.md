# What is Parse?

> Parse Server is an open source version of the Parse backend that can be deployed to any infrastructure that can run Node.js.

http://parse.com/

# Looking for Parse + Parse Dashboard?

We also provide a Docker Image for Parse Dashboard. Parse Dashboard is a standalone dashboard for managing your Parse apps. You can find it at:

[Bitnami Parse Dashboard](https://github.com/bitnami/bitnami-docker-parse-dashboard)

# TL;DR;

## Docker Compose

```bash
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-parse/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/parse?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy Parse Server in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Parse Server Chart GitHub repository](https://github.com/bitnami/charts/tree/master/upstreamed/parse).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/containers/how-to/work-with-non-root-containers/).

# Supported tags and respective `Dockerfile` links

> NOTE: Debian 8 images have been deprecated in favor of Debian 9 images. Bitnami will not longer publish new Docker images based on Debian 8.

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/).


* [`3-rhel-7`, `3.1.3-rhel-7-r13` (3/rhel-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-parse/blob/3.1.3-rhel-7-r13/3/rhel-7/Dockerfile)
* [`3-ol-7`, `3.1.3-ol-7-r61` (3/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-parse/blob/3.1.3-ol-7-r61/3/ol-7/Dockerfile)
* [`3-debian-9`, `3.1.3-debian-9-r53`, `3`, `3.1.3`, `3.1.3-r53`, `latest` (3/debian-9/Dockerfile)](https://github.com/bitnami/bitnami-docker-parse/blob/3.1.3-debian-9-r53/3/debian-9/Dockerfile)

Subscribe to project updates by watching the [bitnami/parse GitHub repo](https://github.com/bitnami/bitnami-docker-parse).

# Prerequisites

To run this application you need Docker Engine 1.10.0. Docker Compose is recomended with a version 1.6.0 or later.

# How to use this image

## Run Parse with a Database Container

Running Parse with a database server is the recommended way. You can either use docker-compose or run the containers manually.

### Run the application using Docker Compose

This is the recommended way to run Parse. You can use the following docker compose template:

```yaml
version: '2'

services:
  mongodb:
    image: 'bitnami/mongodb:latest'
    volumes:
      - 'mongodb_data:/bitnami'
  parse:
    image: 'bitnami/parse:latest'
    environment:
      PARSE_HOST: your_host
    ports:
      - '1337:1337'
    volumes:
      - 'parse_data:/bitnami'
    depends_on:
      - mongodb
volumes:
  mongodb_data:
    driver: local
  parse_data:
    driver: local
```

### Run the application manually

If you want to run the application manually instead of using docker-compose, these are the basic steps you need to run:

1. Create a new network for the application and the database:

  ```bash
  $ docker network create parse_network
  ```

2. Start a MongoDB database in the network generated:

  ```bash
  $ docker run -d --name mongodb --net=parse_network bitnami/mongodb
  ```

  *Note:* You need to give the container a name in order to Parse to resolve the host

3. Run the Parse container:

  ```bash
  $ docker run -d -p 1337:1337 --name parse --net=parse_network bitnami/parse
  ```

Then you can access your application at http://your-ip/parse

## Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a volume at the `/bitnami` path. Additionally you should mount a volume for [persistence of the MongoDB data](https://github.com/bitnami/bitnami-docker-mongodb#persisting-your-database).

The above examples define docker volumes namely `mongodb_data` and `parse_data`. The Parse application state will persist as long as these volumes are not removed.

To avoid inadvertent removal of these volumes you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

### Mount host directories as data volumes with Docker Compose

This requires a minor change to the `docker-compose.yml` template previously shown:

```yaml
version: '2'

  mongodb:
    image: 'bitnami/mongodb:latest'
    volumes:
      - '/path/to/your/local/mongodb_data:/bitnami'
  parse:
    image: bitnami/parse:latest
    depends_on:
      - mongodb
    ports:
      - 1337:1337
    volumes:
      - '/path/to/parse-persistence:/bitnami'
```

### Mount host directories as data volumes using the Docker command line

In this case you need to specify the directories to mount on the run command. The process is the same than the one previously shown:

1. Create a network (if it does not exist):

  ```bash
  $ docker network create parse-tier
  ```

2. Create a MongoDB container with host volume:

  ```bash
  $ docker run -d --name mongodb \
    --net parse-tier \
    --volume /path/to/mongodb-persistence:/bitnami \
    bitnami/mongodb:latest
  ```

  *Note:* You need to give the container a name in order to Parse to resolve the host

3. Run the Parse container:

  ```bash
  $ docker run -d --name parse -p 1337:1337 \
    --net parse-tier \
    --volume /path/to/parse-persistence:/bitnami \
     bitnami/parse:latest
  ```

# Upgrade this application

Bitnami provides up-to-date versions of Mongodb and Parse, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the Parse container. For the Mongodb upgrade see https://github.com/bitnami/bitnami-docker-mongodb/blob/master/README.md#upgrade-this-image

1. Get the updated images:

  ```bash
  $ docker pull bitnami/parse:latest
  ```

2. Stop your container

 * For docker-compose: `$ docker-compose stop parse`
 * For manual execution: `$ docker stop parse`

3. Take a snapshot of the application state

```bash
$ rsync -a /path/to/parse-persistence /path/to/parse-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

Additionally, [snapshot the MongoDB data](https://github.com/bitnami/bitnami-docker-mongodb#step-2-stop-and-backup-the-currently-running-container)

You can use these snapshots to restore the application state should the upgrade fail.

4. Remove the currently running container

 * For docker-compose: `$ docker-compose rm parse`
 * For manual execution: `$ docker rm parse`

5. Run the new image

 * For docker-compose: `$ docker-compose up parse`
 * For manual execution ([mount](#mount-persistent-folders-manually) the directories if needed): `docker run --name parse bitnami/parse:latest`

# Configuration

## Environment variables

When you start the parse image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the docker run command line. If you want to add a new environment variable:

 * For docker-compose add the variable name and value under the application section:

```yaml
parse:
  image: bitnami/parse:latest
  ports:
    - 1337:1337
  environment:
    - PARSE_HOST=my_host
  volumes:
    - 'parse_data:/bitnami'
  depends_on:
    - mongodb
```

 * For manual execution add a `-e` option with each variable and value:

```bash
 $ docker run -d -e PARSE_HOST=my_host -p 1337:1337 --name parse -v /your/local/path/bitnami/parse:/bitnami --network=parse_network bitnami/parse
```

Available variables:
 - `PARSE_HOST`: Parse server host. Default: **127.0.0.1**
 - `PARSE_PORT_NUMBER_NUMBER`: Parse server port. Default: **1337**
 - `PARSE_MOUNT_PATH`: Parse server mount path. Default: **/parse**
 - `PARSE_APP_ID`: Parse server App ID. Default: **myappID**
 - `PARSE_MASTER_KEY`: Parse server Master Key: **mymasterKey**
 - `PARSE_ENABLE_CLOUD_CODE`: Enable Parse Cloud Code support. Default **no**
 - `MONGODB_HOST`: Hostname for Mongodb server. Default: **mongodb**
 - `MONGODB_PORT_NUMBER`: Port used by Mongodb server. Default: **27017**

## How to deploy your Cloud functions with Parse Cloud Code?

You can use Cloud Code to run a piece of code in your Parse Server instead of the user's mobile devices. To run your Cloud functions using this image, follow the steps below:

* Create a directory on your host machine and put your Cloud functions on it. In the example below, a simple "Hello world!" function is used:

```bash
$ mkdir ~/cloud
$ cat > ~/cloud/main.js <<'EOF'
Parse.Cloud.define("sayHelloWorld", function(request, response) {
    response.success("Hello world!");
});
EOF
```

* Mount the directory as a data volume at the `/opt/bitnami/parse/cloud` path on your Parse Container and set the environment variable `PARSE_ENABLE_CLOUD_CODE` to `yes`. You can use the `docker-compose.yml` below:

> NOTE: In the example below, Parse Dashboard is also deployed.

```yaml
version: '2'
services:
  mongodb:
    image: 'bitnami/mongodb:latest'
    volumes:
      - 'mongodb_data:/bitnami'
  parse:
    image: 'bitnami/parse:latest'
    ports:
      - '1337:1337'
    environment:
      - PARSE_ENABLE_CLOUD_CODE=yes
    volumes:
      - 'parse_data:/bitnami'
      - '/path/to/home/directory/cloud:/opt/bitnami/parse/cloud'
    depends_on:
      - mongodb
    parse-dashboard:
      image: 'bitnami/parse-dashboard:latest'
      ports:
        - '80:4040'
      volumes:
        - 'parse_dashboard_data:/bitnami'
      depends_on:
        - parse
volumes:
  mongodb_data:
    driver: local
  parse_data:
    driver: local
  parse_dashboard_data:
    driver: local
```

* Use the `docker-compose` tool to deploy Parse and Parse Dashboard:

```
$ docker-compose up -d
```

* Once both Parse and Parse Dashboard are running, access Parse Dashboard and browse to 'My Dashboard -> API Console'.
* Then, send a 'test query' of type 'POST' using 'functions/sayHelloWorld' as endpoint. Ensure you activate the 'Master Key' parameter.
* Everything should be working now and you should receive a 'Hello World' message in the results.

Find more information about Cloud Code and Cloud functions in the [official documentation](https://docs.parseplatform.org/cloudcode/guide/).

# Notable Changes

## 3.1.2-r14

- The Parse container has been migrated to a non-root user approach. Previously the container ran as the `root` user and the Parse daemon was started as the `parse` user. From now on, both the container and the Parse daemon run as user `1001`. As a consequence, the data directory must be writable by that user. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-parse/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-parse/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-parse/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright 2016-2019 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
