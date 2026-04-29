# Bitnami Secure Image for WildFly

> Wildfly is a lightweight, open source application server, formerly known as JBoss, that implements the latest enterprise Java standards.

[Overview of WildFly](https://www.wildfly.org/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name wildfly bitnami/wildfly:latest
```

## Using `docker-compose.yml`

The docker-compose.yaml file of this container can be found in the [Bitnami Containers repository](https://github.com/bitnami/containers/).

[https://github.com/bitnami/containers/tree/main/bitnami/wildfly/docker-compose.yml](https://github.com/bitnami/containers/tree/main/bitnami/wildfly/docker-compose.yml)

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/wildfly).

## Why use Bitnami Secure Images?

Those are hardened, minimal CVE images built and maintained by Bitnami. Bitnami Secure Images are based on the cloud-optimized, security-hardened enterprise [OS Photon Linux](https://vmware.github.io/photon/). Why choose BSI images?

- Hardened secure images of popular open source software with Near-Zero Vulnerabilities
- Vulnerability Triage & Prioritization with VEX Statements, KEV and EPSS Scores
- Compliance focus with FIPS, STIG, and air-gap options, including secure bill of materials (SBOM)
- Software supply chain provenance attestation through in-toto
- First class support for the internet’s favorite Helm charts

Each image comes with valuable security metadata. You can view the metadata in [our public catalog here](https://app-catalog.vmware.com/bitnami/apps). Note: Some data is only available with [commercial subscriptions to BSI](https://bitnami.com/).

![Alt text](https://github.com/bitnami/containers/blob/main/BSI%20UI%201.png?raw=true "Application details")
![Alt text](https://github.com/bitnami/containers/blob/main/BSI%20UI%202.png?raw=true "Packaging report")

If you are looking for our previous generation of images based on Debian Linux, please see the [Bitnami Legacy registry](https://hub.docker.com/u/bitnamilegacy).

## How to deploy WildFly in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami WildFly Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/wildfly).

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

## Get this image

The Bitnami WildFly Docker image is only available to [Bitnami Secure Images](https://bitnami.com) customers.

## Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami/wildfly` path. If the mounted directory is empty, it will be initialized on the first run.

> **NOTE** As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

## Deploying web applications on WildFly

The Bitnami WildFly image launches WildFLy in standalone mode. Therefore, you can deploy your web applications by placing your compressed web application resource (`.WAR`) files there at `/opt/bitnami/wildfly/standalone/` directory.

Additionally a helper symlink `/app` is present that points to the deployments directory which enables us to deploy applications on a running WildFly instance by simply doing:

```console
docker cp /path/to/app.war wildfly:/app
```

Find more information about the directory structure at [WildFly official documentation](https://docs.wildfly.org/23/Getting_Started_Guide.html#standalone-directory-structure)

> **NOTE** You can also deploy web applications on a running WildFly instance using the WildFly management interface.

## Accessing your WildFly server from the host

The Bitnami WildFly image exposes the application server on port `8080` and the management console on port `9990`. Access your web server in the browser by navigating to `http://localhost:8080` to access the application server and `http://localhost:9990/console` to access the management console.

> **NOTE** the management console is configured by default to listen exclusively in the localhost interface for security reasons. To allow access from different hosts, you can use the `WILDFLY_MANAGEMENT_LISTEN_ADDRESS` environment variable to set a different listen address (this is not recommended for production environments).

## Accessing the command line interface

The command line management tool `jboss-cli.sh` allows a user to connect to the WildFly server and execute management operations available through the de-typed management model. The Bitnami WildFly image ships the `jboss-cli.sh` client and can be launched by specifying the command while launching the container.

### Connecting a client container to the WildFly server container

You can run the client in the same container as the server using the Docker [exec](https://docs.docker.com/reference/commandline/cli/#exec) command.

```console
$ docker exec -it wildfly-server \
    jboss-cli.sh --controller=wildfly-server:9990 --connect
```

## Configuration

The following section describes the supported environment variables

### Environment variables

The following tables list the main variables you can set.

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

### Full configuration

The image looks for configurations (e.g. `standalone.xml`) in the `/bitnami/wildfly/configuration/` directory, this directory can be changed by setting the `WILDFLY_MOUNTED_CONF_DIR` environment variable.

### FIPS configuration in Bitnami Secure Images

The Bitnami WildFly Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.
- `JAVA_TOOL_OPTIONS`: controls Java FIPS mode. Use `-Djava.security.properties==/opt/bitnami/java/conf/security/java.security.restricted` (restricted), `-Djava.security.properties==/opt/bitnami/java/conf/security/java.security.relaxed` (relaxed), or `-Djava.security.properties==/opt/bitnami/java/conf/security/java.security.original` (off).

## Logging

The Bitnami WildFly Docker image sends the container logs to the `stdout`. You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Notable Changes

### 22.0.1-debian-10-r68 and 23.0.1-debian-10-r8 release

- The size of the container image has been decreased.
- The configuration logic is now based on Bash scripts in the *rootfs/* folder.
- The configuration is no longer persisted, instead it's adapted based on environment variables during the container initialization on every container restart. You can also mount custom configuration files and skip the configuration based on environment variables as it's detailed in [this section](#full-configuration).

Consequences:

- Backwards compatibility should be possible, but it is highly recommended to backup your application data before upgrading.

### 14.0.1-r75

- The WildFly container has been migrated to a non-root user approach. Previously the container ran as the `root` user and the WildFly daemon was started as the `wildfly` user. From now on, both the container and the WildFly daemon run as user `1001`. As a consequence, the data directory must be writable by that user. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile.

### 10.0.0-r3

- `WILDFLY_USER` parameter has been renamed to `WILDFLY_USERNAME`.

### 10.0.0-r0

- All volumes have been merged at `/bitnami/wildfly`. Now you only need to mount a single volume at `/bitnami/wildfly` for persistence.
- The logs are always sent to the `stdout` and are no longer collected in the volume.

## License

Copyright &copy; 2026 Broadcom. The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
