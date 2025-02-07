# Bitnami package for WildFly

## What is WildFly?

> Wildfly is a lightweight, open source application server, formerly known as JBoss, that implements the latest enterprise Java standards.

[Overview of WildFly](http://www.wildfly.org/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name wildfly bitnami/wildfly:latest
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use WildFly in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## How to deploy WildFly in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami WildFly Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/wildfly).

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

The recommended way to get the Bitnami WildFly Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/wildfly).

```console
docker pull bitnami/wildfly:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/wildfly/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/wildfly:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami/wildfly` path. If the mounted directory is empty, it will be initialized on the first run.

```console
docker run -p 8080:8080 -p 9990:9990 \
    -v /path/to/wildfly-persistence:/bitnami/wildfly \
    bitnami/wildfly:latest
```

Alternatively, modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/wildfly/docker-compose.yml) file present in this repository:

```yaml
services:
  wildfly:
  ...
    volumes:
      - /path/to/wildfly-persistence:/bitnami/wildfly
  ...
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

## Deploying web applications on WildFly

The Bitnami WildFly image launches WildFLy in standalone mode. Therefore, you can deploy your web applications by placing your compressed web application resource (`.WAR`) files there at `/opt/bitnami/wildfly/standalone/` directory.

Additionally a helper symlink `/app` is present that points to the deployments directory which enables us to deploy applications on a running WildFly instance by simply doing:

```console
docker cp /path/to/app.war wildfly:/app
```

Find more information about the directory structue at [WildFly official documentation](https://docs.wildfly.org/23/Getting_Started_Guide.html#standalone-directory-structure)

> NOTE: You can also deploy web applications on a running WildFly instance using the WildFly management interface.

## Accessing your WildFly server from the host

The Bitnami WildFly image exposes the application server on port `8080` and the management console on port `9990`. To access your web server from your host machine you can ask Docker to map random ports on your host to the ports `8080` and `9990` of the container.

```console
docker run --name wildfly -P bitnami/wildfly:latest
```

Run `docker port` to determine the random ports Docker assigned.

```console
$ docker port wildfly
8080/tcp -> 0.0.0.0:32775
9990/tcp -> 0.0.0.0:32774
```

You can also manually specify the ports you want forwarded from your host to the container.

```console
docker run -p 8080:8080 -p 9990:9990 bitnami/wildfly:latest
```

Access your web server in the browser by navigating to `http://localhost:8080` to access the application server and `http://localhost:9990/console` to access the management console.

> NOTE: the management console is configured by default to listen exclusively in the localhost interface for security reasons. To allow access from different hosts, you can use the `WILDFLY_MANAGEMENT_LISTEN_ADDRESS` environment variable to set a different listen address (this is not recommended for production environments).

## Accessing the command line interface

The command line management tool `jboss-cli.sh` allows a user to connect to the WildFly server and execute management operations available through the de-typed management model. The Bitnami WildFly image ships the `jboss-cli.sh` client and can be launched by specifying the command while launching the container.

### Connecting a client container to the WildFly server container

#### Step 1: Create a network

```console
docker network create wildfly-tier --driver bridge
```

#### Step 2: Launch the WildFly server instance

Use the `--network wildfly-tier` argument to the `docker run` command to attach the WildFly container to the `wildfly-tier` network.

```console
docker run -d --name wildfly-server \
    --network wildfly-tier \
    bitnami/wildfly:latest
```

#### Step 3: Launch your WildFly client instance

Finally we create a new container instance to launch the WildFly client and connect to the server created in the previous step:

```console
docker run -it --rm \
    --network wildfly-tier \
    bitnami/wildfly:latest \
    jboss-cli.sh --controller=wildfly-server:9990 --connect
```

You can also run the client in the same container as the server using the Docker [exec](https://docs.docker.com/reference/commandline/cli/#exec) command.

```console
$ docker exec -it wildfly-server \
    jboss-cli.sh --controller=wildfly-server:9990 --connect
```

## Configuration

### Environment variables

#### Customizable environment variables

| Name                                | Description                                                                                   | Default Value                           |
|-------------------------------------|-----------------------------------------------------------------------------------------------|-----------------------------------------|
| `WILDFLY_CONF_FILE`                 | Path to the WildFly configuration file.                                                       | `${WILDFLY_CONF_DIR}/standalone.xml`    |
| `WILDFLY_MOUNTED_CONF_DIR`          | Directory for including custom configuration files (that override the default generated ones) | `${WILDFLY_VOLUME_DIR}/configuration`   |
| `WILDFLY_DATA_DIR`                  | WildFly data directory.                                                                       | `${WILDFLY_VOLUME_DIR}/standalone/data` |
| `WILDFLY_SERVER_LISTEN_ADDRESS`     | WildFly server listen address.                                                                | `nil`                                   |
| `WILDFLY_MANAGEMENT_LISTEN_ADDRESS` | WildFly management listen address.                                                            | `nil`                                   |
| `WILDFLY_HTTP_PORT_NUMBER`          | Port number used by the WildFly for HTTP connections.                                         | `nil`                                   |
| `WILDFLY_HTTPS_PORT_NUMBER`         | Port number used by the WildFly for HTTPS connections.                                        | `nil`                                   |
| `WILDFLY_AJP_PORT_NUMBER`           | Port number used by the WildFly for AJP connections.                                          | `nil`                                   |
| `WILDFLY_MANAGEMENT_PORT_NUMBER`    | Port number used by the WildFly management interface.                                         | `nil`                                   |
| `WILDFLY_USERNAME`                  | WildFly admin username.                                                                       | `user`                                  |
| `WILDFLY_PASSWORD`                  | WildFly admin user password.                                                                  | `nil`                                   |
| `JAVA_HOME`                         | Java Home directory.                                                                          | `${BITNAMI_ROOT_DIR}/java`              |
| `JAVA_OPTS`                         | Java options.                                                                                 | `nil`                                   |
| `JAVA_TOOL_OPTIONS`                 | Java tool options.                                                                            | `nil`                                   |

#### Read-only environment variables

| Name                                        | Description                                                                      | Value                                          |
|---------------------------------------------|----------------------------------------------------------------------------------|------------------------------------------------|
| `WILDFLY_BASE_DIR`                          | WildFly installation directory.                                                  | `${BITNAMI_ROOT_DIR}/wildfly`                  |
| `WILDFLY_HOME_DIR`                          | WildFly user home directory.                                                     | `/home/wildfly`                                |
| `WILDFLY_BIN_DIR`                           | WildFly directory for binary executables.                                        | `${WILDFLY_BASE_DIR}/bin`                      |
| `WILDFLY_CONF_DIR`                          | WildFly server configuration directory.                                          | `${WILDFLY_BASE_DIR}/standalone/configuration` |
| `WILDFLY_LOGS_DIR`                          | WildFly directory for log files.                                                 | `${WILDFLY_BASE_DIR}/standalone/log`           |
| `WILDFLY_TMP_DIR`                           | WildFly directory for runtime temporary files.                                   | `${WILDFLY_BASE_DIR}/standalone/tmp`           |
| `WILDFLY_DOMAIN_DIR`                        | Wildfly domain directory.                                                        | `${WILDFLY_BASE_DIR}/domain`                   |
| `WILDFLY_STANDALONE_DIR`                    | Wildfly standalone directory.                                                    | `${WILDFLY_BASE_DIR}/standalone`               |
| `WILDFLY_DEFAULT_DOMAIN_DIR`                | Wildfly default domain directory.                                                | `${WILDFLY_BASE_DIR}/domain.default`           |
| `WILDFLY_DEFAULT_STANDALONE_DIR`            | Wildfly default standalone directory.                                            | `${WILDFLY_BASE_DIR}/standalone.default`       |
| `WILDFLY_PID_FILE`                          | Path to the WildFly PID file.                                                    | `${WILDFLY_TMP_DIR}/wildfly.pid`               |
| `WILDFLY_VOLUME_DIR`                        | WildFly directory for mounted configuration files.                               | `${BITNAMI_VOLUME_DIR}/wildfly`                |
| `WILDFLY_DAEMON_USER`                       | WildFly system user.                                                             | `wildfly`                                      |
| `WILDFLY_DAEMON_GROUP`                      | WildFly system group.                                                            | `wildfly`                                      |
| `WILDFLY_DEFAULT_SERVER_LISTEN_ADDRESS`     | Default WildFLY SERVER listen address to enable at build time.                   | `0.0.0.0`                                      |
| `WILDFLY_DEFAULT_MANAGEMENT_LISTEN_ADDRESS` | Default WildFLY MANAGEMENT listen address to enable at build time.               | `127.0.0.1`                                    |
| `WILDFLY_DEFAULT_HTTP_PORT_NUMBER`          | Default WildFLY HTTP port number to enable at build time.                        | `8080`                                         |
| `WILDFLY_DEFAULT_HTTPS_PORT_NUMBER`         | Default WildFLY HTTPS port number to enable at build time.                       | `8443`                                         |
| `WILDFLY_DEFAULT_AJP_PORT_NUMBER`           | Default WildFLY AJP port number to enable at build time.                         | `8009`                                         |
| `WILDFLY_DEFAULT_MANAGEMENT_PORT_NUMBER`    | Default WildFLY MANAGEMENT port number to enable at build time.                  | `9990`                                         |
| `LAUNCH_JBOSS_IN_BACKGROUND`                | Ensure signals are forwarded to the JVM process correctly for graceful shutdown. | `true`                                         |

### Creating a custom user

By default, a management user named `user` is created with the default password `bitnami`. Passing the `WILDFLY_PASSWORD` environment variable when running the image for the first time will set the password of this user to the value of `WILDFLY_PASSWORD`.

Additionally you can specify a user name for the management user using the `WILDFLY_USERNAME` environment variable. When not specified, the `WILDFLY_PASSWORD` configuration is applied on the default user (`user`).

```console
docker run --name wildfly \
    -e WILDFLY_USERNAME=my_user \
    -e WILDFLY_PASSWORD=my_password \
    bitnami/wildfly:latest
```

or modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/wildfly/docker-compose.yml) file present in this repository:

```yaml
services:
  wildfly:
  ...
    environment:
      - WILDFLY_USERNAME=my_user
      - WILDFLY_PASSWORD=my_password
  ...
```

### Full configuration

The image looks for configurations (e.g. `standalone.xml`) in the `/bitnami/wildfly/configuration/` directory, this directory can be changed by setting the `WILDFLY_MOUNTED_CONF_DIR` environment variable.

```console
docker run --name wildfly \
    -v /path/to/standalone.xml:/bitnami/wildfly/configuration/standalone.xml \
    bitnami/wildfly:latest
```

Alternatively, modify the [docker-compose.yml](https://github.com/bitnami/containers/blob/main/bitnami/wildfly/docker-compose.yml) file present in this repository:

```yaml
services:
  wildfly:
    ...
    volumes:
      - /path/to/standalone.xml:/bitnami/wildfly/configuration/standalone.xml:ro
    ...
```

After that, your changes will be taken into account in the server's behaviour.

## Logging

The Bitnami WildFly Docker image sends the container logs to the `stdout`. To view the logs:

```console
docker logs wildfly
```

or using Docker Compose:

```console
docker-compose logs wildfly
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of WildFly, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/wildfly:latest
```

or if you're using Docker Compose, update the value of the image property to `bitnami/wildfly:latest`.

#### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```console
docker stop wildfly
```

or using Docker Compose:

```console
docker-compose stop wildfly
```

Next, take a snapshot of the persistent volume `/path/to/wildfly-persistence` using:

```console
rsync -a /path/to/wildfly-persistence /path/to/wildfly-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

#### Step 3: Remove the currently running container

```console
docker rm -v wildfly
```

or using Docker Compose:

```console
docker-compose rm -v wildfly
```

#### Step 4: Run the new image

Re-create your container from the new image.

```console
docker run --name wildfly bitnami/wildfly:latest
```

or using Docker Compose:

```console
docker-compose up wildfly
```

## Notable Changes

### 22.0.1-debian-10-r68 and 23.0.1-debian-10-r8 release

* The size of the container image has been decreased.
* The configuration logic is now based on Bash scripts in the *rootfs/* folder.
* The configuration is no longer persisted, instead it's adapted based on environment variables during the container initialization on every container restart. You can also mount custom configuration files and skip the configuration based on environment variables as it's detailed in [this section](#full-configuration).

Consequences:

* Backwards compatibility should be possible, but it is highly recommended to backup your application data before upgrading.

### 14.0.1-r75

* The WildFly container has been migrated to a non-root user approach. Previously the container ran as the `root` user and the WildFly daemon was started as the `wildfly` user. From now on, both the container and the WildFly daemon run as user `1001`. As a consequence, the data directory must be writable by that user. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile.

### 10.0.0-r3

* `WILDFLY_USER` parameter has been renamed to `WILDFLY_USERNAME`.

### 10.0.0-r0

* All volumes have been merged at `/bitnami/wildfly`. Now you only need to mount a single volume at `/bitnami/wildfly` for persistence.
* The logs are always sent to the `stdout` and are no longer collected in the volume.

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/wildfly).

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
