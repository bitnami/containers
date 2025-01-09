# Bitnami package for Apache Tomcat

## What is Apache Tomcat?

> Apache Tomcat is an open-source web server designed to host and run Java-based web applications. It is a lightweight server with a good performance for applications running in production environments.

[Overview of Apache Tomcat](http://tomcat.apache.org/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name tomcat bitnami/tomcat:latest
```

You can find the default credentials and available configuration options in the [Environment Variables](#environment-variables) section.

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use Apache Tomcat in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## How to deploy Apache Apache Tomcat in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Apache Apache Tomcat Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/tomcat).

Bitnami containers can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

## Only latest stable branch maintained in the free Bitnami catalog

Starting December 10th 2024, only the latest stable branch of any container will receive updates in the free Bitnami catalog. To access up-to-date releases for all upstream-supported branches, consider upgrading to Bitnami Premium. Previous versions already released will not be deleted. They are still available to pull from DockerHub.

Please check the Bitnami Premium page in our partner [Arrow Electronics](https://www.arrow.com/globalecs/na/vendors/bitnami?utm_source=GitHub&utm_medium=containers) for more information.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami Apache Tomcat Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/tomcat).

```console
docker pull bitnami/tomcat:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/tomcat/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/tomcat:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami` path. If the mounted directory is empty, it will be initialized on the first run.

```console
docker run -v /path/to/tomcat-persistence:/bitnami bitnami/tomcat:latest
```

Alternatively, modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/tomcat/docker-compose.yml) file present in this repository:

```yaml
services:
  tomcat:
  ...
    volumes:
      - /path/to/tomcat-persistence:/bitnami
  ...
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

## Deploying web applications on Apache Tomcat

The `/bitnami/tomcat/data` directory is configured as the Apache Tomcat webapps deployment directory. At this location, you either copy a so-called *exploded web application*, i.e. non-compressed, or a compressed web application resource (`.WAR`) file and it will automatically be deployed by Apache Tomcat.

Additionally a helper symlink `/app` is present that points to the webapps deployment directory which enables us to deploy applications on a running Apache Tomcat instance by simply doing:

```console
docker cp /path/to/app.war tomcat:/app
```

In case you want to create a custom image that already contains your application war file, you need to add it to the `/opt/bitnami/tomcat/webapps` folder. In the example below we create a forked image with an extra `.war` file.

```Dockerfile
FROM bitnami/tomcat:9.0
COPY sample.war /opt/bitnami/tomcat/webapps
```

**Note!**
You can also deploy web applications on a running Apache Tomcat instance using the Apache Tomcat management interface.

**Further Reading:**

* [Apache Tomcat Web Application Deployment](https://tomcat.apache.org/tomcat-7.0-doc/deployer-howto.html)

## Accessing your Apache Tomcat server from the host

To access your web server from your host machine you can ask Docker to map a random port on your host to port `8080` exposed in the container.

```console
docker run --name tomcat -P bitnami/tomcat:latest
```

Run `docker port` to determine the random ports Docker assigned.

```console
$ docker port tomcat
8080/tcp -> 0.0.0.0:32768
```

You can also manually specify the ports you want forwarded from your host to the container.

```console
docker run -p 8080:8080 bitnami/tomcat:latest
```

Access your web server in the browser by navigating to `http://localhost:8080`.

## Configuration

### Environment variables

#### Customizable environment variables

| Name                             | Description                                                                           | Default Value                                                                                                                                                |
|----------------------------------|---------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `TOMCAT_SHUTDOWN_PORT_NUMBER`    | Tomcat shutdown port number.                                                          | `8005`                                                                                                                                                       |
| `TOMCAT_HTTP_PORT_NUMBER`        | Tomcat HTTP port number.                                                              | `8080`                                                                                                                                                       |
| `TOMCAT_AJP_PORT_NUMBER`         | Tomcat AJP port number.                                                               | `8009`                                                                                                                                                       |
| `TOMCAT_USERNAME`                | Tomcat username.                                                                      | `manager`                                                                                                                                                    |
| `TOMCAT_PASSWORD`                | Tomcat password.                                                                      | `nil`                                                                                                                                                        |
| `TOMCAT_ALLOW_REMOTE_MANAGEMENT` | Whether to allow connections from remote addresses to the Tomcat manager application. | `yes`                                                                                                                                                        |
| `TOMCAT_ENABLE_AUTH`             | Whether to enable authentication for Tomcat manager applications.                     | `yes`                                                                                                                                                        |
| `TOMCAT_ENABLE_AJP`              | Whether to enable the Tomcat AJP connector.                                           | `no`                                                                                                                                                         |
| `TOMCAT_START_RETRIES`           | The number or retries while waiting for Catalina to start.                            | `12`                                                                                                                                                         |
| `TOMCAT_EXTRA_JAVA_OPTS`         | Additional Java settings for Tomcat.                                                  | `nil`                                                                                                                                                        |
| `TOMCAT_INSTALL_DEFAULT_WEBAPPS` | Whether to add default webapps (ROOT, manager, host-manager, etc.) for deployment.    | `yes`                                                                                                                                                        |
| `JAVA_OPTS`                      | Java runtime parameters.                                                              | `-Djava.awt.headless=true -XX:+UseG1GC -Dfile.encoding=UTF-8 -Djava.net.preferIPv4Stack=true -Djava.net.preferIPv4Addresses=true -Duser.home=${TOMCAT_HOME}` |

#### Read-only environment variables

| Name                      | Description                                        | Value                                 |
|---------------------------|----------------------------------------------------|---------------------------------------|
| `TOMCAT_BASE_DIR`         | Tomcat installation directory.                     | `${BITNAMI_ROOT_DIR}/tomcat`          |
| `TOMCAT_VOLUME_DIR`       | Tomcat persistence directory.                      | `/bitnami/tomcat`                     |
| `TOMCAT_BIN_DIR`          | Tomcat directory for binary files.                 | `${TOMCAT_BASE_DIR}/bin`              |
| `TOMCAT_LIB_DIR`          | Tomcat directory for library files.                | `${TOMCAT_BASE_DIR}/lib`              |
| `TOMCAT_WORK_DIR`         | Tomcat directory for runtime files.                | `${TOMCAT_BASE_DIR}/work`             |
| `TOMCAT_WEBAPPS_DIR`      | Tomcat directory where webapps are stored.         | `${TOMCAT_VOLUME_DIR}/webapps`        |
| `TOMCAT_CONF_DIR`         | Tomcat configuration directory.                    | `${TOMCAT_BASE_DIR}/conf`             |
| `TOMCAT_DEFAULT_CONF_DIR` | Tomcat default configuration directory.            | `${TOMCAT_BASE_DIR}/conf.default`     |
| `TOMCAT_CONF_FILE`        | Tomcat configuration file.                         | `${TOMCAT_CONF_DIR}/server.xml`       |
| `TOMCAT_USERS_CONF_FILE`  | Tomcat configuration file.                         | `${TOMCAT_CONF_DIR}/tomcat-users.xml` |
| `TOMCAT_LOGS_DIR`         | Directory where Tomcat logs are stored.            | `${TOMCAT_BASE_DIR}/logs`             |
| `TOMCAT_TMP_DIR`          | Directory where Tomcat temporary files are stored. | `${TOMCAT_BASE_DIR}/temp`             |
| `TOMCAT_LOG_FILE`         | Path to the log file for Tomcat.                   | `${TOMCAT_LOGS_DIR}/catalina.out`     |
| `TOMCAT_PID_FILE`         | Path to the PID file for Tomcat.                   | `${TOMCAT_TMP_DIR}/catalina.pid`      |
| `TOMCAT_HOME`             | Tomcat home directory.                             | `$TOMCAT_BASE_DIR`                    |
| `TOMCAT_DAEMON_USER`      | Tomcat system user.                                | `tomcat`                              |
| `TOMCAT_DAEMON_GROUP`     | Tomcat system group.                               | `tomcat`                              |
| `JAVA_HOME`               | Java installation folder.                          | `${BITNAMI_ROOT_DIR}/java`            |

#### Creating a custom user

By default, a management user named `manager` is created and is not assigned a password. Passing the `TOMCAT_PASSWORD` environment variable when running the image for the first time will set the password of this user to the value of `TOMCAT_PASSWORD`.

Additionally you can specify a user name for the management user using the `TOMCAT_USERNAME` environment variable. When not specified, the `TOMCAT_PASSWORD` configuration is applied on the default user (`manager`).

#### Specifying Environment variables using Docker Compose

This requires a minor change to the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/tomcat/docker-compose.yml) file present in this repository:

```yaml
services:
  tomcat:
  ...
    environment:
      - TOMCAT_USERNAME=my_user
      - TOMCAT_PASSWORD=my_password
  ...
```

#### Specifying Environment variables on the Docker command line

```console
docker run --name tomcat \
  -e TOMCAT_USERNAME=my_user \
  -e TOMCAT_PASSWORD=my_password \
  bitnami/tomcat:latest
```

### Configuration files

During the initialization of the container, the default Apache Tomcat configuration files are modified with the basic options defined through [environment variables](#environment-variables). If you want to add more specific configuration options, you can always mount your own configuration files under `/opt/bitnami/tomcat/conf/` to override the existing ones. Please note that those files should be writable by the system user of the container.

```console
docker run --name tomcat -v /path/to/config/server.xml:/opt/bitnami/tomcat/conf/server.xml bitnami/tomcat:latest
```

or using Docker Compose:

```yaml
services:
  tomcat:
  ...
    volumes:
      - /path/to/config/server.xml:/opt/bitnami/tomcat/conf/server.xml
  ...
```

Refer to the [Apache Tomcat configuration](https://tomcat.apache.org/tomcat-7.0-doc/config/index.html) manual for the complete list of configuration options.

## Logging

The Bitnami Apache Tomcat Docker image sends the container logs to the `stdout`. To view the logs:

```console
docker logs tomcat
```

or using Docker Compose:

```console
docker-compose logs tomcat
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of Apache Tomcat, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/tomcat:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/tomcat:latest`.

#### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```console
docker stop tomcat
```

or using Docker Compose:

```console
docker-compose stop tomcat
```

Next, take a snapshot of the persistent volume `/path/to/tomcat-persistence` using:

```console
rsync -a /path/to/tomcat-persistence /path/to/tomcat-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

#### Step 3: Remove the currently running container

```console
docker rm -v tomcat
```

or using Docker Compose:

```console
docker-compose rm -v tomcat
```

#### Step 4: Run the new image

Re-create your container from the new image.

```console
docker run --name tomcat bitnami/tomcat:latest
```

or using Docker Compose:

```console
docker-compose up tomcat
```

## Notable Changes

### Debian: 9.0.26-r0, 8.5.46-r0, 8.0.53-r382, 7.0.96-r50. Oracle: 9.0.24-ol-7-r35, 8.5.45-ol-7-r34, 8.0.53-ol-7-r426, 7.0.96-ol-7-r61

* Decrease the size of the container. The configuration logic is now based on Bash scripts in the `rootfs/` folder.

### 9.0.13-r27 , 8.5.35-r26, 8.0.53-r131 & 7.0.92-r20

* The Apache Tomcat container has been migrated to a non-root user approach. Previously the container ran as the `root` user and the Apache Tomcat daemon was started as the `tomcat` user. From now on, both the container and the Apache Tomcat daemon run as user `1001`. As a consequence, the data directory must be writable by that user. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile.

### 8.0.35-r3

* `TOMCAT_USER` parameter has been renamed to `TOMCAT_USERNAME`.

### 8.0.35-r0

* All volumes have been merged at `/bitnami/tomcat`. Now you only need to mount a single volume at `/bitnami/tomcat` for persistence.
* The logs are always sent to the `stdout` and are no longer collected in the volume.

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/tomcat).

If you detect any issue in the `docker-compose.yaml` file, feel free to report it or contribute with a fix by following our [Contributing Guidelines](https://github.com/bitnami/containers/blob/main/CONTRIBUTING.md).

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues) or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/containers/issues/new/choose). For us to provide better support, be sure to fill the issue template.

## License

Copyright &copy; 2025 Broadcom. The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
