# Bitnami Secure Image for Apache Tomcat

> Apache Tomcat is an open-source web server designed to host and run Java-based web applications. It is a lightweight server with a good performance for applications running in production environments.

[Overview of Apache Tomcat](https://tomcat.apache.org/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name tomcat bitnami/tomcat:latest
```

You can find the default credentials and available configuration options in the [Environment Variables](#environment-variables) section.

## Using `docker-compose.yml`

The docker-compose.yaml file of this container can be found in the [Bitnami Containers repository](https://github.com/bitnami/containers/).

[https://github.com/bitnami/containers/tree/main/bitnami/tomcat/docker-compose.yml](https://github.com/bitnami/containers/tree/main/bitnami/tomcat/docker-compose.yml)

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/tomcat).

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

## How to deploy Apache Apache Tomcat in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Apache Apache Tomcat Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/tomcat).

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

## Get this image

The Bitnami Apache Tomcat Docker image is only available to [Bitnami Secure Images](https://bitnami.com) customers.

## Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami` path. If the mounted directory is empty, it will be initialized on the first run.

> **NOTE** As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

## Deploying web applications on Apache Tomcat

The `/bitnami/tomcat/data` directory is configured as the Apache Tomcat webapps deployment directory. At this location, you either copy a so-called *exploded web application*, i.e. non-compressed, or a compressed web application resource (`.WAR`) file and it will automatically be deployed by Apache Tomcat.

Additionally a helper symlink `/app` is present that points to the webapps deployment directory which enables us to deploy applications on a running Apache Tomcat instance by simply doing:

```console
docker cp /path/to/app.war tomcat:/app
```

In case you want to create a custom image that already contains your application war file, you need to add it to the `/opt/bitnami/tomcat/webapps` folder. In the example below we create a forked image with an extra `.war` file.

```Dockerfile
FROM bitnami/tomcat:latest
COPY sample.war /opt/bitnami/tomcat/webapps
```

**Note!**
You can also deploy web applications on a running Apache Tomcat instance using the Apache Tomcat management interface.

**Further Reading:**

- [Apache Tomcat Web Application Deployment](https://tomcat.apache.org/tomcat-11.0-doc/deployer-howto.html)

## Configuration

The following section describes the supported environment variables

### Environment variables

The following tables list the main variables you can set.

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

### Configuration files

During the initialization of the container, the default Apache Tomcat configuration files are modified with the basic options defined through [environment variables](#environment-variables). If you want to add more specific configuration options, you can always mount your own configuration files under `/opt/bitnami/tomcat/conf/` to override the existing ones. Please note that those files should be writable by the system user of the container.

Refer to the [Apache Tomcat configuration](https://tomcat.apache.org/tomcat-11.0-doc/config/index.html) manual for the complete list of configuration options.

### FIPS configuration in Bitnami Secure Images

The Bitnami Apache Tomcat Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.
- `JAVA_TOOL_OPTIONS`: controls Java FIPS mode. Use `-Djava.security.properties==/opt/bitnami/java/conf/security/java.security.restricted` (restricted), `-Djava.security.properties==/opt/bitnami/java/conf/security/java.security.relaxed` (relaxed), or `-Djava.security.properties==/opt/bitnami/java/conf/security/java.security.original` (off).

## Logging

The Bitnami Apache Tomcat Docker image sends the container logs to the `stdout`. You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Notable Changes

### Debian: 9.0.26-r0, 8.5.46-r0, 8.0.53-r382, 7.0.96-r50. Oracle: 9.0.24-ol-7-r35, 8.5.45-ol-7-r34, 8.0.53-ol-7-r426, 7.0.96-ol-7-r61

- Decrease the size of the container. The configuration logic is now based on Bash scripts in the `rootfs/` folder.

### 9.0.13-r27 , 8.5.35-r26, 8.0.53-r131 & 7.0.92-r20

- The Apache Tomcat container has been migrated to a non-root user approach. Previously the container ran as the `root` user and the Apache Tomcat daemon was started as the `tomcat` user. From now on, both the container and the Apache Tomcat daemon run as user `1001`. As a consequence, the data directory must be writable by that user. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile.

### 8.0.35-r3

- `TOMCAT_USER` parameter has been renamed to `TOMCAT_USERNAME`.

### 8.0.35-r0

- All volumes have been merged at `/bitnami/tomcat`. Now you only need to mount a single volume at `/bitnami/tomcat` for persistence.
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
