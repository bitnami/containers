# Apache Geode packaged by Bitnami

## What is Apache Geode?

> Apache Geode is a data management platform that provides advanced capabilities for data-intensive applications.

[Overview of Apache Geode](https://geode.apache.org/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-geode/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

**Warning**: This quick setup is only intended for development environments. You are encouraged to change the insecure default credentials and check out the available configuration options in the [Environment Variables](#environment-variables) section for a more secure deployment.

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.

> This [CVE scan report](https://quay.io/repository/bitnami/geode?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

## How to deploy Apache Geode in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Apache Geode Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/geode).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`1`, `1-debian-10`, `1.14.2`, `1.14.2-debian-10-r14`, `latest` (1/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-geode/blob/1.14.2-debian-10-r14/1/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/geode GitHub repo](https://github.com/bitnami/bitnami-docker-geode).

## Get this image

The recommended way to get the Bitnami Apache Geode Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/geode).

```console
$ docker pull bitnami/geode:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/geode/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/geode:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/geode:latest 'https://github.com/bitnami/bitnami-docker-geode.git#master:1/debian-10'
```

## How to use this image

### Run the application using Docker Compose

The main folder of this repository contains a functional [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-geode/blob/master/docker-compose.yml) file. Run the application using it as shown below:

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-geode/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

### Using the Docker Command Line

If you want to run the application manually instead of using `docker-compose`, these are the basic steps you need to run:

#### Step 0: Create a network

```console
$ docker network create geode-network
```

#### Step 1: Create volumes for Apache Geode persistence and launch the container

```console
$ docker volume create --name geode_data
$ docker run -d --name geode -p 7070:7070 \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --network geode-network \
  --volume geode_data:/bitnami/geode \
  bitnami/geode:latest
```

Access your application at `http://your-ip/`

## Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami/geode` path. If the mounted directory is empty, it will be initialized on the first run.

To avoid inadvertent removal of volumes, you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

### Mount host directories as data volumes with Docker Compose

This requires a minor change to the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-geode/blob/master/docker-compose.yml) file present in this repository:

```diff
   geode:
     ...
     volumes:
-      - 'geode_data:/bitnami/geode'
+      - /path/to/geode-persistence:/bitnami/geode
   ...
-volumes:
-  geode_data:
-    driver: local
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

### Mount host directories as data volumes using the Docker command line

#### Step 0: Create a network

```console
$ docker network create geode-network
```

#### Step 1. Create the Apache Geode container with host volumes

```console
$ docker run -d --name geode -p 7070:7070 \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --network geode-network \
  --volume /path/to/geode-persistence:/bitnami/geode \
  bitnami/geode:latest
```

## Configuration

### Environment variables

When you start the Apache Geode image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line. If you want to add a new environment variable:

* For docker-compose add the variable name and value under the application section in the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-geode/blob/master/docker-compose.yml) file present in this repository:

```yaml
geode:
  ...
  environment:
    - GEODE_ENABLE_SECURITY=yes
    - GEODE_SECURITY_PASSWORD=my_password
  ...
```

* For manual execution add a `--env` option with each variable and value:

  ```console
  $ docker run -d --name geode -p 7070:7070 \
    --env GEODE_ENABLE_SECURITY=yes \
    --env GEODE_SECURITY_PASSWORD=my_password \
    bitnami/geode:latest
  ```

Available environment variables:

#### Apache Geode configuration

* `GEODE_HTTP_BIND_ADDRESS`: Apache Geode HTTP bind address (bound to all local addresses if not specified). No defaults.
* `GEODE_HTTP_PORT_NUMBER`: Apache Geode HTTP port number. Default: **7070**
* `GEODE_RMI_BIND_ADDRESS`: Apache Geode RMI bind address (bound to all local addresses if not specified). No defaults.
* `GEODE_RMI_PORT_NUMBER`: Apache Geode RMI port number. Default: **1099**
* `GEODE_ADVERTISED_HOSTNAME`: Apache Geode advertised hostname. No defaults.
* `GEODE_NODE_NAME`: Apache Geode node name. No defaults.
* `GEODE_NODE_TYPE`: Apache Geode node type. Allowed values: *server* and *locator* Default: **server**
* `GEODE_LOG_LEVEL`: Apache Geode loge level. Allowed values: *severe*, *error*, *warning*, *info*, *config* and *fine*. Default: **info**
* `GEODE_INITIAL_HEAP_SIZE`: Initial size of the heap in the same format as the JVM -Xmx parameter. No defaults.
* `GEODE_MAX_HEAP_SIZE`: Maximum size of the heap in the same format as the JVM -Xmx parameter. No defaults.
* `GEODE_ENABLE_METRICS`: Enable exposing Apache Geode metrics for Prometheus. Default: **no**
* `GEODE_METRICS_PORT_NUMBER`: Apache Geode metrics port number. Default: **9914**

#### Apache Geode security configuration

* `GEODE_ENABLE_SECURITY`: Enable Apache Geode security. Default: **no**
* `GEODE_SECURITY_MANAGER`: Fully qualified name of the class that implements the SecurityManager interface. Default: **org.apache.geode.examples.security.ExampleSecurityManager**
* `GEODE_SECURITY_USERNAME`: Username credential the node will use to connect with locators. Default: **admin**
* `GEODE_SECURITY_PASSWORD`: Password credential the node will use to connect with locators. No defaults.
* `GEODE_SECURITY_TLS_COMPONENTS`: Comma-separated list of components for which to enable TLS. Allowed values: *cluster*, *gateway*, *web*, *jmx*, *locator*, *server* and *all*. No defaults.
* `GEODE_SECURITY_TLS_PROTOCOLS`: Comma-separated list of valid protocols versions for TCP/IP connections with TLS encryption enabled. Default: **any**
* `GEODE_SECURITY_TLS_REQUIRE_AUTHENTICATION`: Enable two-way authentication via TLS. Default: **no**
* `GEODE_SECURITY_TLS_ENDPOINT_IDENTIFICATION_ENABLED`: Enable server hostname validation using server certificates. Default: **no**
* `GEODE_SECURITY_TLS_KEYSTORE_FILE`: Path to the key store file. Default: **/bitnami/geode/config/certs/geode.keystore.jks**
* `GEODE_SECURITY_TLS_KEYSTORE_PASSWORD`: Key store file. No defaults.
* `GEODE_SECURITY_TLS_TRUSTSTORE_FILE`: Path to the trust store file. Default: **/bitnami/geode/config/certs/geode.truststore.jks**
* `GEODE_SECURITY_TLS_TRUSTSTORE_PASSWORD`: Trust store password. No defaults.

#### Apache Geode cluster configuration

* `GEODE_LOCATORS`: Comma-separated list of Apache Geode locators use to join the Geode cluster. No defaults.
* `GEODE_GROUPS`: Comma-separated list of Apache Geode member groups this node belongs to. Default: **server**

#### Apache Geode Cache Servers configuration

* `GEODE_SERVER_BIND_ADDRESS`: Apache Geode Cache server bind address (bound to all local addresses if not specified). No defaults.
* `GEODE_SERVER_PORT_NUMBER`: Apache Geode Cache server port number. Default: **40404**

#### Apache Geode Locators configuration

* `GEODE_LOCATOR_BIND_ADDRESS`: Apache Geode Locator bind address (bound to all local addresses if not specified). No defaults.
* `GEODE_LOCATOR_PORT_NUMBER`: Apache Geode Locator port number. Default: **10334**
* `GEODE_LOCATOR_START_COMMAND`: Command to execute to configure a Locator node after starting it. Default: **configure pdx --read-serialized --disk-store**

### Security

The Bitnami Apache Geode Docker image does not enable security mechanisms by default, please remember this is not recommended for production environments.

#### Authentication & Authorization

In order to implement authentication and authorization mechanisms, you need to configure a Security Manager that implements the "SecurityManager" interface. To enable authentication and authorization on this container, set the `GEODE_ENABLE_SECURITY` environment variable to `yes` and set `GEODE_SECURITY_MANAGER` with the FQDN of the desired class that implements the "SecurityManager" interface.

> Learn more about the Security Manager in the [Apache Geode documentation](https://geode.apache.org/docs/guide/114/managing/security/enable_security.html).

By default this container uses [this ExampleSecurityManager](https://geode.apache.org/releases/latest/javadoc/org/apache/geode/examples/security/ExampleSecurityManager.html) as Security Manager, which is based on JSON resource called `security.json` where you can define your users and roles.When the `security.json` is not provided, this container generates a very simple one that:

* Configures authentication for user defined at `GEODE_SECURITY_USERNAME` using the password defined at `GEODE_SECURITY_PASSWORD`.
* Authorizes the user defined at `GEODE_SECURITY_USERNAME` with all the privileges.

To use a custom `security.json`, mount it into `/opt/bitnami/geode/extensions` on every Apache Geode container in the cluster.

> Note: The "ExampleSecurityManager" is not recommended for production environments

#### TLS authentication

You can also configure TLS for authentication between members and to protect your data during distribution. TLS authentication can be configured for every component or only on certain communications (e.g. only communication with and between locators). This container exposes the `GEODE_SECURITY_TLS_COMPONENTS` so you can choose the components for which to enable TLS (none by default).

> Note: TLS authentication can be alone or in conjunction with the authentication provided by the Security Manager

To configure TLS, you must use your own certificates. You can drop your Java Key Stores into `/bitnami/geode/config/certs`. If the JKS certs are password protected (recommended), you will need to provide them also setting `GEODE_SECURITY_TLS_KEYSTORE_PASSWORD` and `GEODE_SECURITY_TLS_TRUSTSTORE_PASSWORD`.

> If your Java Key Stores are mounted in a different location than `/opt/bitnami/geode/config/certs/geode.keystore.jks` and `/opt/bitnami/geode/config/certs/geode.truststore.jks`, set the environment variables `GEODE_SECURITY_TLS_KEYSTORE_FILE` and `GEODE_SECURITY_TLS_TRUSTSTORE_FILE` with the name of the path where you mounted your key store and trust store files, respectively.

The following script (intended for Kafka but valid for Apache Geode) can help you with the creation of the JKS and certificates:

* [kafka-generate-ssl.sh](https://raw.githubusercontent.com/confluentinc/confluent-platform-security-tools/master/kafka-generate-ssl.sh)

Keep in mind the following notes:

* Set the Common Name or FQDN values to your Apache Geode container hostname, e.g. `geode.example.com`. After entering this value, when prompted "What is your first and last name?", enter this value as well.
  * As an alternative, you can disable host name verification setting the environment variable `GEODE_SECURITY_TLS_ENDPOINT_IDENTIFICATION_ENABLED` to `no`.
* Each Apache Geode Cache server and Locator needs its own keystore. You will have to repeat the process for each of the member in the cluster.

> Learn more about the TLS configuration in the [Apache Geode documentation](https://geode.apache.org/docs/guide/114/managing/security/implementing_ssl.html).

The following Docker Compose is just an example showing how to enable TLS authentication communications for between clients and servers, and mount your JKS certificates protected by the password `pass123` in a Apache Geode standalone Cache server:

```yaml
version: '2.1'

services:
  geode:
    image: 'bitnami/geode:latest'
    ports:
      - 7070:7070
    environment:
      - GEODE_ENABLE_SECURITY=yes
      - GEODE_SECURITY_TLS_COMPONENTS=server
      - GEODE_SECURITY_TLS_ENDPOINT_IDENTIFICATION_ENABLED=no
      - GEODE_SECURITY_TLS_KEYSTORE_PASSWORD=pass123
      - GEODE_SECURITY_TLS_TRUSTSTORE_PASSWORD=pass123

    volumes:
      - './geode.keystore.jks:/bitnami/geode/config/certs/geode.keystore.jks:ro'
      - './geode.truststore.jks:/bitnami/geode/config/certs/geode.truststore.jks:ro'
```

### Setting up an Apache Geode Cluster

An Apache Geode cluster with both Locators and Chache server nodes can easily be setup with the Bitnami Apache Geode Docker image. To do so, this image exposes a set of useful environment variables.

#### Using the Docker Command Line

##### Step 0: Create a network

Create a Docker network to enable visibility between Apache Geode nodes:

```console
$ docker network create geode-network --driver bridge
```

##### Step 1: Create an Apache Geode Locator

The first step is to create an Apache Geode Locator node.

```console
$ docker run --name geode-locator -p 7070:7070 \
  --network geode-network \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env GEODE_NODE_NAME=locator \
  --env GEODE_NODE_TYPE=locator \
  --env GEODE_ADVERTISED_HOSTNAME=geode-locator \
  bitnami/geode:development
```

##### Step 2: Create the first Apache Geode Cache server

Then, we can create our fist Apache Geode Cache server node.

```console
$ docker run --name geode-server-0 \
  --network geode-network \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env GEODE_NODE_NAME=server-0 \
  --env GEODE_NODE_TYPE=server \
  --env GEODE_ADVERTISED_HOSTNAME=geode-server-0 \
  --env GEODE_LOCATORS=geode-locator[10334] \
  bitnami/geode:development
```

##### Step 3: Create the second Apache Geode Cache server

Next, we create a new Apache Geode Cache server node.

```console
$ docker run --name geode-server-1 \
  --network geode-network \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env GEODE_NODE_NAME=server-1 \
  --env GEODE_NODE_TYPE=server \
  --env GEODE_ADVERTISED_HOSTNAME=geode-server-1 \
  --env GEODE_LOCATORS=geode-locator[10334] \
  bitnami/geode:development
```

You now have a Apache Geode cluster up and running. You can scale the cluster by adding/removing new nodes without incurring any downtime.

#### Using Docker Compose

The main folder of this repository contains a functional [`docker-compose-cluster.yml`](https://github.com/bitnami/bitnami-docker-geode/blob/master/docker-compose-cluster.yml) file. Run an Apache Geode cluster using it as shown below:

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-geode/master/docker-compose-cluster.yml > docker-compose.yml
$ docker-compose up -d
```

### Full configuration

The image looks for configuration files (`gemfire.properties`, `cache.xml`, `log4j2.xml`, etc.) in the `/bitnami/geode/config/` directory. Find very simple examples below.

#### Using the Docker Command Line

```console
$ docker run -d --name geode -p 7070:7070 \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --volume /path/to/gemfire.properties:/bitnami/geode/config/gemfire.properties:ro \
  bitnami/geode:latest
```

After that, your custom configuration will be taken into account to start the Apache Geode node.

#### Using Docker Compose

Modify the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-geode/blob/master/docker-compose.yml) file present in this repository as follows:

```diff
...
services:
  geode:
    ...
    volumes:
      - 'geode_data:/bitnami/geode'
+     - /path/to/gemfire.properties:/bitnami/geode/config/gemfire.properties:ro
```

After that, your custom configuration will be taken into account to start the Apache Geode node.

## Logging

The Bitnami Apache Geode Docker image sends the container logs to `stdout`. To view the logs:

```console
$ docker logs geode
```

Or using Docker Compose:

```console
$ docker-compose logs geode
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Initializing a new instance

When the container is launched, it will execute the files with extension `.sh` located at `/docker-entrypoint-initdb.d`.

In order to have your custom files inside the docker image you can mount them as a volume.

```console
$ docker run --name geode \
  -v /path/to/init-scripts:/docker-entrypoint-initdb.d \
  bitnami/geode:latest
```

Or with Docker Compose:

```yaml
geode:
  image: bitnami/geode:latest
  volumes:
    - /path/to/init-scripts:/docker-entrypoint-initdb.d
```

## Maintenance

### Backing up your container

To backup your data and configuration, follow these simple steps:

#### Step 1: Export the configuration (optional)

Unless you're using the Cluster Configuration Service (only available when running locator nodes), the configuration is not persisted. To avoid losing your configuration in standalone Cache servers, you can export it as it's explained in the [Apache Geode documentation](https://geode.apache.org/docs/guide/114/tools_modules/gfsh/command-pages/export.html).

#### Step 2: Stop the currently running container

```console
$ docker stop geode
```

Or using Docker Compose:

```console
$ docker-compose stop geode
```

#### Step 3: Run the backup command

We need to mount two volumes in a container we will use to create the backup: a directory on your host to store the backup in, and the volumes from the container we just stopped so we can access the data.

```console
$ docker run --rm -v /path/to/geode-backups:/backups --volumes-from geode busybox \
  cp -a /bitnami/geode:latest /backups/latest
```

Or using Docker Compose:

```console
$ docker run --rm -v /path/to/geode-backups:/backups --volumes-from `docker-compose ps -q geode` busybox \
  cp -a /bitnami/geode:latest /backups/latest
```

### Restoring a backup

Restoring a backup is as simple as mounting the backup as volumes in the container.

```console
$ docker run -v /path/to/geode-backups/latest:/bitnami/geode bitnami/geode:latest
```

You can also modify the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-geode/blob/master/docker-compose.yml) file present in this repository:

```yaml
geode:
  volumes:
    - /path/to/geode-backups/latest:/bitnami/geode
```

> Note: if you exported your node configuration, you can restore in your Apache Geode node by mountin the configuration files as explained in the [Full Confiuration section)[#full-configuration].

### Upgrade this image

Bitnami provides up-to-date versions of Kafka, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
$ docker pull bitnami/geode:latest
```

or if you're using Docker Compose, update the value of the image property to `bitnami/geode:latest`.

#### Step 2: Stop and backup the currently running container

Before continuing, you should backup your container's data, configuration and logs.

Follow the steps on [creating a backup](#backing-up-your-container).

#### Step 3: Remove the currently running container

```console
$ docker rm -v geode
```

Or using Docker Compose:

```console
$ docker-compose rm -v geode
```

#### Step 4: Run the new image

Re-create your container from the new image, [restoring your backup](#restoring-a-backup) if necessary.

```console
$ docker run --name geode bitnami/geode:latest
```

Or using Docker Compose:

```console
$ docker-compose up geode
```

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-geode/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-geode/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-geode/issues/new). For us to provide better support, be sure to include the following information in your issue:

* Host OS and version
* Docker version (`docker version`)
* Output of `docker info`
* Version of this container
* The command you used to run the container, and any relevant output you saw (masking any sensitive information)

## License

Copyright 2021 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
