# What is Spark?

Apache Spark is a high-performance engine for large-scale computing tasks, such as
data processing, machine learning and real-time data streaming.
It includes APIs for Java, Python, Scala and R.

[https://spark.apache.org/](https://spark.apache.org/)

# TL;DR;

## Docker Compose

```
$ curl -LO https://raw.githubusercontent.com/bitnami/bitnami-docker-spark/master/docker-compose.yml
$ docker-compose up
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DTC)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.

> This [CVE scan report](https://quay.io/repository/bitnami/spark?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy Apache Spark in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Apache Spark Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/spark).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/containers/how-to/work-with-non-root-containers/).

# Supported tags and respective `Dockerfile` links

> NOTE: Debian 8 images have been deprecated in favor of Debian 9 images. Bitnami will not longer publish new Docker images based on Debian 8.

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/).


* [`2-debian-9`, `2.4.3-debian-9-r49`, `2`, `2.4.3`, `2.4.3-r49`, `latest` (2/debian-9/Dockerfile)](https://github.com/bitnami/bitnami-docker-spark/blob/2.4.3-debian-9-r49/2/debian-9/Dockerfile)

Subscribe to project updates by watching the [bitnami/spark GitHub repo](https://github.com/bitnami/bitnami-docker-spark).

# Get this image

The recommended way to get the Bitnami Spark Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/spark).

```bash
docker pull bitnami/spark:latest
```

To use a specific version, you can pull a versioned tag. You can view the
[list of available versions](https://hub.docker.com/r/bitnami/spark/tags/)
in the Docker Hub Registry.

```bash
docker pull bitnami/spark:[TAG]
```

If you wish, you can also build the image yourself.

```bash
docker build -t bitnami/spark:latest https://github.com/bitnami/bitnami-docker-spark.git
```

# Configuration

## Environment variables

When you start the spark image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the docker run command line. If you want to add a new environment variable:

* For docker-compose add the variable name and value under the application section in the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-spark/blob/master/docker-compose.yml) file present in this repository:

```
spark:
  ...
  environment:
    - SPARK_MODE=master
  ...
```

* For manual execution add a -e option with each variable and value:

 $ docker run -d --name spark \
    --network=spark_network \
    -e SPARK_MODE=master \
    bitnami/spark

Available variables:

* SPARK_MODE: Cluster mode starting Spark. Valid values: *master*, *worker*. Default: **master**
* SPARK_MASTER_URL: Url where the worker can find the master. Only needed when spark mode is *worker*. Default: **spark://spark-master:7077**
* SPARK_RPC_AUTHENTICATION_ENABLED: Enable RPC authentication. Default: **no**
* SPARK_RPC_AUTHENTICATION_SECRET: The secret key used for RPC authentication. No defaults.
* SPARK_RPC_ENCRYPTION_ENABLED: Enable RPC encryption. Default: **no**
* SPARK_LOCAL_STORAGE_ENCRYPTION_ENABLED: Enable local storage encryption: Default **no**
* SPARK_SSL_ENABLED: Enable SSL configuration. Default: **no**
* SPARK_SSL_KEY_PASSWORD: The password to the private key in the key store. No defaults.
* SPARK_SSL_KEYSTORE_PASSWORD: The password for the key store. No defaults.
* SPARK_SSL_TRUSTSTORE_PASSWORD: The password for the trust store. No defaults.
* SPARK_SSL_NEED_CLIENT_AUTH: Whether to require client authentication. Default: **yes**
* SPARK_SSL_PROTOCOL: TLS protocol to use. Default: **TLSv1.2**
* SPARK_DAEMON_USER: Spark system user when the container is started as root. Default: **spark**
* SPARK_DAEMON_GROUP: Spark system group when the container is started as root. Default: **spark**

More environment variables natively supported by Spark can be found [at the official documentation](https://spark.apache.org/docs/latest/spark-standalone.html#cluster-launch-scripts).
For example, you could still use `SPARK_WORKER_CORES` or `SPARK_WORKER_MEMORY` to configure the number of cores and the amount of memory to be used by a worker machine.

## Security

The Bitnani Spark docker image supports enabling RPC authentication, RPC encryption and local storage encryption easily using the following env vars in all the nodes of the cluster.

```diff
+ SPARK_RPC_AUTHENTICATION_ENABLED=yes
+ SPARK_RPC_AUTHENTICATION_SECRET=RPC_AUTHENTICATION_SECRET
+ SPARK_RPC_ENCRYPTION=yes
+ SPARK_LOCAL_STORAGE_ENCRYPTION=yes
```

> Please note that `RPC_AUTHENTICATION_SECRET` is a placeholder that needs to be updated with a correct value.

> Be also aware that currently is not possible to submit an application to a standalone cluster if RPC authentication is configured. More info about the issue [here](https://issues.apache.org/jira/browse/SPARK-25078).

Additionally, SSL configuration can be easily activated following the next steps:

1. Enable SSL configuration by setting the following env vars:

```diff
+ SPARK_SSL_ENABLED=yes
+ SPARK_SSL_KEY_PASSWORD=KEY_PASSWORD
+ SPARK_SSL_KEYSTORE_PASSWORD=KEYSTORE_PASSWORD
+ SPARK_SSL_TRUSTSTORE_PASSWORD=TRUSTSTORE_PASSWORD
+ SPARK_SSL_NEED_CLIENT_AUTH=yes
+ SPARK_SSL_PROTOCOL=TLSv1.2
```

> Please note that `KEY_PASSWORD`, `KEYSTORE_PASSWORD`, and `TRUSTSTORE_PASSWORD` are placeholders that needs to be updated with a correct value.

2. You need to mount your spark keystore and trustore files to `/opt/bitnami/spark/conf/certs`. Please note they should be called `spark-keystore.jks` and `spark-truststore.jks` and they should be in JKS format.

## Setting up a Spark Cluster

A Spark cluster can easily be setup with the default docker-compose.yml file from the root of this repo. The docker-compose includes two different services, `spark-master` and `spark-worker.`

By default, when you deploy the docker-compose file you will get a Spark cluster with 1 master and 1 worker.

If you want N workers, all you need to do is start the docker-compose deployment with the following command:

```
docker-compose up --scale spark-worker=3
```

## Mount a custom configuration file
The image looks for configuration in the `conf/` directory of `/opt/bitnami/spark`.


### Using docker-compose

```yaml
...
volumes:
  - /path/to/spark-defaults.conf:/opt/bitnami/spark/conf/spark-defaults.conf
...  
```

### Using the command line

```bash
docker run --name spark -v /path/to/spark-defaults.conf:/opt/bitnami/spark/conf/spark-defaults.conf bitnami/spark:latest
```

After that, your changes will be taken into account in the server's behaviour.


# Logging

The Bitnami Spark Docker image sends the container logs to the `stdout`. To view the logs:

```bash
docker logs spark
```

or using Docker Compose:

```bash
docker-compose logs spark
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Maintenance

## Backing up your container

To backup your data, configuration and logs, follow these simple steps:

### Step 1: Stop the currently running container

```bash
docker stop spark
```

or using Docker Compose:

```bash
docker-compose stop spark
```

### Step 2: Run the backup command

We need to mount two volumes in a container we will use to create the backup: a directory on your host to store the backup in, and the volumes from the container we just stopped so we can access the data.

```bash
docker run --rm -v /path/to/spark-backups:/backups --volumes-from spark busybox \
  cp -a /bitnami/spark:latest /backups/latest
```

or using Docker Compose:

```bash
docker run --rm -v /path/to/spark-backups:/backups --volumes-from `docker-compose ps -q spark` busybox \
  cp -a /bitnami/spark:latest /backups/latest
```

## Restoring a backup

Restoring a backup is as simple as mounting the backup as volumes in the container.

```bash
docker run -v /path/to/spark-backups/latest:/bitnami/spark bitnami/spark:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-spark/blob/master/docker-compose.yml) file present in this repository:


```yaml
services:
  spark:
  ...
    volumes:
      - /path/to/spark-backups/latest:/bitnami/spark
  ...
```

## Upgrade this image

Bitnami provides up-to-date versions of spark, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```bash
docker pull bitnami/spark:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/spark:latest`.

### Step 2: Stop and backup the currently running container

Before continuing, you should backup your container's data, configuration and logs.

Follow the steps on [creating a backup](#backing-up-your-container).

### Step 3: Remove the currently running container

```bash
docker rm -v spark
```

or using Docker Compose:


```bash
docker-compose rm -v spark
```

### Step 4: Run the new image

Re-create your container from the new image, [restoring your backup](#restoring-a-backup) if necessary.

```bash
docker run --name spark bitnami/spark:latest
```

or using Docker Compose:

```bash
docker-compose up spark
```

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-spark/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-spark/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-spark/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright (c) 2019 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
