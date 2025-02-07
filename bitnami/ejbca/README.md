# Bitnami package for EJBCA

## What is EJBCA?

> EJBCA is an enterprise class PKI Certificate Authority software, built using Java (JEE) technology.

[Overview of EJBCA](http://www.ejbca.org)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name ejbca bitnami/ejbca:latest
```

**Warning**: This quick setup is only intended for development environments. You are encouraged to change the insecure default credentials and check out the available configuration options in the [Configuration](#configuration) section for a more secure deployment.

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use EJBCA in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/containers/how-to/work-with-non-root-containers/).

## Only latest stable branch maintained in the free Bitnami catalog

Starting December 10th 2024, only the latest stable branch of any container will receive updates in the free Bitnami catalog. To access up-to-date releases for all upstream-supported branches, consider upgrading to Bitnami Premium. Previous versions already released will not be deleted. They are still available to pull from DockerHub.

Please check the Bitnami Premium page in our partner [Arrow Electronics](https://www.arrow.com/globalecs/na/vendors/bitnami?utm_source=GitHub&utm_medium=containers) for more information.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami EJBCA Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/ejbca).

```console
docker pull bitnami/ejbca:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/ejbca/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/ejbca:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## How to use this image

EJBCA requires access to a MySQL or MariaDB database to store information. We'll use our very own [MariaDB image](https://github.com/bitnami/containers/tree/main/bitnami/mariadb) for the database requirements.

### Using the Docker Command Line

#### Step 1: Create a network

```console
docker network create ejbca-network
```

#### Step 2: Create a volume for MariaDB persistence and create a MariaDB container

```console
$ docker volume create --name mariadb_data
docker run -d --name mariadb \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env MARIADB_USER=bn_ejbca \
  --env MARIADB_PASSWORD=Bitnami1234 \
  --env MARIADB_DATABASE=bitnami_ejbca \
  --network ejbca-network \
  --volume mariadb_data:/bitnami/mariadb \
  bitnami/mariadb:latest
```

#### Step 3: Create volumes for EJBCA persistence and launch the container

```console
$ docker volume create --name ejbca_data
docker run -d --name ejbca \
  -p 8080:8080 -p 8443:8443 \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env EJBCA_DATABASE_USERNAME=bn_ejbca \
  --env EJBCA_DATABASE_PASSWORD=Bitnami1234 \
  --env EJBCA_DATABASE_HOST=mariadb \
  --env EJBCA_DATABASE_NAME=bitnami_ejbca \
  --network ejbca-network \
  --volume ejbca_data:/bitnami/wildfly \
  bitnami/ejbca:latest
```

Access your application at `http://your-ip:8080/ejbca/`

### Run the application using Docker Compose

```console
curl -sSL https://raw.githubusercontent.com/bitnami/containers/main/bitnami/ejbca/docker-compose.yml > docker-compose.yml
docker-compose up -d
```

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/ejbca).

If you detect any issue in the `docker-compose.yaml` file, feel free to report it or contribute with a fix by following our [Contributing Guidelines](https://github.com/bitnami/containers/blob/main/CONTRIBUTING.md).

## Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami/wildfly` path. If the mounted directory is empty, it will be initialized on the first run.

```console
docker run \
    -v /path/to/ejbca-persistence:/bitnami/wildfly \
    bitnami/ejbca:latest
```

You can also do this with a minor change to the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/ejbca/docker-compose.yml) file present in this repository:

```diff
   ejbca:
     ...
     volumes:
-      - 'wildfly_data:/bitnami/wildfly'
+      - /path/to/ejbca-persistence:/bitnami/wildfly
   ...
-volumes:
-  ejbca_data:
-    driver: local
```

## Configuration

### Environment variables

#### Customizable environment variables

| Name                                 | Description                               | Default Value                                                                                                                                          |
|--------------------------------------|-------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------|
| `EJBCA_WILDFLY_ADMIN_USER`           | Wildfly admin user                        | `admin`                                                                                                                                                |
| `EJBCA_WILDFLY_ADMIN_PASSWORD`       | Wildfly admin password                    | `nil`                                                                                                                                                  |
| `EJBCA_SERVER_CERT_FILE`             | Server cert file                          | `nil`                                                                                                                                                  |
| `EJBCA_SERVER_CERT_PASSWORD`         | Server cert file password.                | `nil`                                                                                                                                                  |
| `EJBCA_HTTP_PORT_NUMBER`             | Wildfly http port number                  | `8080`                                                                                                                                                 |
| `EJBCA_HTTPS_PORT_NUMBER`            | Wilfly https port number                  | `8443`                                                                                                                                                 |
| `EJBCA_HTTPS_ADVERTISED_PORT_NUMBER` | Rendered port for administrator login URL | `$EJBCA_HTTPS_PORT_NUMBER`                                                                                                                             |
| `EJBCA_ADMIN_USERNAME`               | EJBCA administrator username              | `superadmin`                                                                                                                                           |
| `EJBCA_ADMIN_PASSWORD`               | EJBCA administrator password.             | `Bitnami1234`                                                                                                                                          |
| `EJBCA_DATABASE_FLAVOR`              | EJBCA database flavor                     | `mariadb`                                                                                                                                              |
| `EJBCA_DATABASE_HOST`                | Database hostname                         | `nil`                                                                                                                                                  |
| `EJBCA_DATABASE_PORT`                | Database port number.                     | `3306`                                                                                                                                                 |
| `EJBCA_DATABASE_NAME`                | EJBCA database name.                      | `nil`                                                                                                                                                  |
| `EJBCA_DATABASE_USERNAME`            | EJBCA database username.                  | `nil`                                                                                                                                                  |
| `EJBCA_DATABASE_PASSWORD`            | EJBCA database password.                  | `nil`                                                                                                                                                  |
| `EJBCA_CA_NAME`                      | CA name.                                  | `ManagementCA`                                                                                                                                         |
| `JAVA_OPTS`                          | JVM options                               | `-Xms2048m -Xmx2048m -Djava.net.preferIPv4Stack=true -Dhibernate.dialect=org.hibernate.dialect.MySQLDialect -Dhibernate.dialect.storage_engine=innodb` |
| `EJBCA_SMTP_HOST`                    | SMTP hostname                             | `localhost`                                                                                                                                            |
| `EJBCA_SMTP_PORT`                    | SMTP port                                 | `25`                                                                                                                                                   |
| `EJBCA_SMTP_FROM_ADDRESS`            | SMTP from address                         | `user@example.com`                                                                                                                                     |
| `EJBCA_SMTP_TLS`                     | SMTP enable TLS                           | `false`                                                                                                                                                |
| `EJBCA_SMTP_USERNAME`                | SMTP username                             | `nil`                                                                                                                                                  |
| `EJBCA_SMTP_PASSWORD`                | SMTP password                             | `nil`                                                                                                                                                  |

#### Read-only environment variables

| Name                                     | Description                                      | Value                                                                                                                                                                                        |
|------------------------------------------|--------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `BITNAMI_VOLUME_DIR`                     | Directory where to mount volumes.                | `/bitnami`                                                                                                                                                                                   |
| `EJBCA_BASE_DIR`                         | EJBCA installation directory.                    | `${BITNAMI_ROOT_DIR}/ejbca`                                                                                                                                                                  |
| `EJBCA_BIN_DIR`                          | EJBCA directory for binary executables.          | `${EJBCA_BASE_DIR}/bin`                                                                                                                                                                      |
| `EJBCA_CONF_DIR`                         | EJBCA directory for configuration files.         | `${EJBCA_BASE_DIR}/conf`                                                                                                                                                                     |
| `EJBCA_DEFAULT_CONF_DIR`                 | EJBCA directory for default configuration files. | `${EJBCA_BASE_DIR}/conf.default`                                                                                                                                                             |
| `EJBCA_TMP_DIR`                          | EJBCA directory for temp files.                  | `${EJBCA_BASE_DIR}/tmp`                                                                                                                                                                      |
| `EJBCA_INITSCRIPTS_DIR`                  | EJBCA directory for init scripts.                | `/docker-entrypoint-initdb.d`                                                                                                                                                                |
| `EJBCA_DATABASE_SCRIPTS_DIR`             | EJBCA directory for database scripts.            | `${EJBCA_BASE_DIR}/sql-scripts`                                                                                                                                                              |
| `EJBCA_VOLUME_DIR`                       | EJBCA persistence directory.                     | `${BITNAMI_VOLUME_DIR}/ejbca`                                                                                                                                                                |
| `EJBCA_WILDFLY_VOLUME_DIR`               | EJBCA Wildlfy persistence directory.             | `${BITNAMI_VOLUME_DIR}/wildfly`                                                                                                                                                              |
| `EJBCA_DATA_DIR`                         | EJBCA data directory.                            | `${EJBCA_VOLUME_DIR}/tls`                                                                                                                                                                    |
| `EJBCA_DB_SCRIPT_INDEXES`                | EJBCA database tables creation script.           | `${EJBCA_DATABASE_SCRIPTS_DIR}/create-index-ejbca.sql`                                                                                                                                       |
| `EJBCA_DB_SCRIPT_TABLES`                 | EJBCA database indexes creation script.          | `${EJBCA_DATABASE_SCRIPTS_DIR}/create-tables-ejbca-mysql.sql`                                                                                                                                |
| `EJBCA_EAR_FILE`                         | EJBCA application deployment file.               | `${EJBCA_BASE_DIR}/dist/ejbca.ear`                                                                                                                                                           |
| `EJBCA_WILDFLY_BASE_DIR`                 | Wildfly base directory.                          | `${BITNAMI_ROOT_DIR}/wildfly`                                                                                                                                                                |
| `EJBCA_WILDFLY_STANDALONE_DIR`           | Wildfly standalone directory.                    | `${EJBCA_WILDFLY_BASE_DIR}/standalone`                                                                                                                                                       |
| `EJBCA_WILDFLY_DEFAULT_STANDALONE_DIR`   | Wildfly default standalone directory.            | `${EJBCA_WILDFLY_BASE_DIR}/standalone.default`                                                                                                                                               |
| `EJBCA_WILDFLY_DOMAIN_DIR`               | Wildfly domain directory.                        | `${EJBCA_WILDFLY_BASE_DIR}/domain`                                                                                                                                                           |
| `EJBCA_WILDFLY_DEFAULT_DOMAIN_DIR`       | Wildfly default domain directory.                | `${EJBCA_WILDFLY_BASE_DIR}/domain.default`                                                                                                                                                   |
| `EJBCA_WILDFLY_TMP_DIR`                  | Wildfly temporal directory                       | `${EJBCA_WILDFLY_BASE_DIR}/tmp`                                                                                                                                                              |
| `EJBCA_WILDFLY_BIN_DIR`                  | Wildfly bin directory                            | `${EJBCA_WILDFLY_BASE_DIR}/bin`                                                                                                                                                              |
| `EJBCA_WILDFLY_CONF_DIR`                 | Wildfly configuration directory                  | `${EJBCA_WILDFLY_STANDALONE_DIR}/configuration`                                                                                                                                              |
| `EJBCA_WILDFLY_PID_DIR`                  | Wildlfy directory to hold PID file               | `${EJBCA_TMP_DIR}`                                                                                                                                                                           |
| `EJBCA_WILDFLY_PID_FILE`                 | Wildfly PID file                                 | `${EJBCA_WILDFLY_PID_DIR}/wildfly.pid`                                                                                                                                                       |
| `EJBCA_WILDFLY_DEPLOY_DIR`               | Wildfly deployment directory.                    | `${EJBCA_WILDFLY_STANDALONE_DIR}/deployments`                                                                                                                                                |
| `EJBCA_WILDFLY_TRUSTSTORE_FILE`          | Wildfly truststore file                          | `${EJBCA_WILDFLY_CONF_DIR}/truststore.jks`                                                                                                                                                   |
| `EJBCA_WILDFLY_KEYSTORE_FILE`            | Wildfly keystore file                            | `${EJBCA_WILDFLY_CONF_DIR}/keystore.jks`                                                                                                                                                     |
| `EJBCA_WILDFLY_STANDALONE_CONF_FILE`     | Wildfly standalone configuration file            | `${EJBCA_WILDFLY_BIN_DIR}/standalone.conf`                                                                                                                                                   |
| `EJBCA_WILDFLY_STANDALONE_XML_FILE`      | Wildfly standalone configuration file            | `${EJBCA_WILDFLY_CONF_DIR}/standalone.xml`                                                                                                                                                   |
| `EJBCA_DAEMON_USER`                      | Wildfly system user.                             | `wildfly`                                                                                                                                                                                    |
| `EJBCA_DAEMON_GROUP`                     | Wildfly system group                             | `wildfly`                                                                                                                                                                                    |
| `EJBCA_WILDFLY_KEYSTORE_PASSWORD_FILE`   | File to store the keystore password              | `${EJBCA_WILDFLY_TMP_DIR}/keystore.pwd`                                                                                                                                                      |
| `EJBCA_WILDFLY_TRUSTSTORE_PASSWORD_FILE` | File to store the truststore password            | `${EJBCA_WILDFLY_TMP_DIR}/truststore.pwd`                                                                                                                                                    |
| `EJBCA_WILDFLY_ADMIN_PASSWORD_FILE`      | File to store the wildfly admin password         | `${EJBCA_WILDFLY_TMP_DIR}/wildfly_admin.pwd`                                                                                                                                                 |
| `EJBCA_TEMP_CERT`                        | Temporary cert file                              | `${EJBCA_TMP_DIR}/cacert.der`                                                                                                                                                                |
| `EJBCA_HOME`                             | EJBCA home.                                      | `${EJBCA_BASE_DIR}`                                                                                                                                                                          |
| `JAVA_HOME`                              | Java home.                                       | `/opt/bitnami/java`                                                                                                                                                                          |
| `JBOSS_HOME`                             | Jboss home                                       | `${EJBCA_WILDFLY_BASE_DIR}`                                                                                                                                                                  |
| `LAUNCH_JBOSS_IN_BACKGROUND`             | Run jboss in background                          | `true`                                                                                                                                                                                       |
| `JBOSS_PIDFILE`                          | Wildfly PID file                                 | `${EJBCA_WILDFLY_PID_FILE}`                                                                                                                                                                  |
| `EJBCA_WILDFLY_DATA_TO_PERSIST`          | EJBCA data to persist.                           | `${EJBCA_WILDFLY_CONF_DIR},${EJBCA_WILDFLY_ADMIN_PASSWORD_FILE},${EJBCA_WILDFLY_BASE_DIR}/standalone/data,${EJBCA_WILDFLY_KEYSTORE_PASSWORD_FILE},${EJBCA_WILDFLY_TRUSTSTORE_PASSWORD_FILE}` |

## Logging

The Bitnami EJBCA Docker image sends the container logs to `stdout`. To view the logs:

```console
docker logs ejbca
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Custom scripts

The Bitnami EJBCA Docker image contains functions to execute any shell scripts after startup. These scripts are executed during the initialization of the EJBCA Wildfly installation.

You can add custom script into the `/docker-entrypoint-init.d` directory. All files in the directory will be executed using bash.

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of EJBCA, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/ejbca:latest
```

#### Step 2: Stop the running container

Stop the currently running container using the command

```console
docker stop ejbca
```

#### Step 3: Remove the currently running container

```console
docker rm -v ejbca
```

#### Step 4: Run the new image

Re-create your container from the new image.

```console
docker run --name ejbca bitnami/ejbca:latest
```

## Notable Changes

### 7.4.3-2-debian-10-r68

The persistence has been refactorized and the volume mount point was moved from `/bitnami/ejbca` to `/bitnami/wildfly`.

In previous versions only password files were persisted, making the container was unable to restart. The initialization logic has been changed as well as the persisted data directories. The Wildlfy configuration and data directories are now persisted, making the container able to automatically restart.
The time that the container takes to restart has also been improved.
Due to the mentioned changes, the automatic upgrade from previous image versions is not supported and requires a manual migration.

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
