# Bitnami package for SonarQube&trade;

## What is SonarQube&trade;?

> SonarQube&trade; is an open source quality management platform that analyzes and measures code's technical quality. It enables developers to detect code issues, vulnerabilities, and bugs in early stages.

[Overview of SonarQube&trade;](http://www.sonarqube.org)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement. SonarQube is a registered trademark of SonarSource SA.

## TL;DR

```console
docker run --name sonarqube bitnami/sonarqube:latest
```

**Warning**: This quick setup is only intended for development environments. You are encouraged to change the insecure default credentials and check out the available configuration options in the [Environment Variables](#environment-variables) section for a more secure deployment.

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use SonarQube&trade; in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

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

The recommended way to get the Bitnami SonarQube&trade; Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/sonarqube).

```console
docker pull bitnami/sonarqube:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/sonarqube/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/sonarqube:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## How to use this image

SonarQube&trade; requires access to a PostgreSQL database to store information. We'll use the [Bitnami Docker Image for PostgreSQL](https://github.com/bitnami/containers/tree/main/bitnami/postgresql) for the database requirements.

### Using the Docker Command Line

#### Step 1: Create a network

```console
docker network create sonarqube-network
```

#### Step 2: Create a volume for PostgreSQL persistence and create a PostgreSQL container

```console
$ docker volume create --name postgresql_data
docker run -d --name postgresql \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env POSTGRESQL_USERNAME=bn_sonarqube \
  --env POSTGRESQL_PASSWORD=bitnami \
  --env POSTGRESQL_DATABASE=bitnami_sonarqube \
  --network sonarqube-network \
  --volume postgresql_data:/bitnami/postgresql \
  bitnami/postgresql:latest
```

#### Step 3: Create volumes for SonarQube&trade; persistence and launch the container

```console
$ docker volume create --name sonarqube_data
docker run -d --name sonarqube \
  -p 8080:8080 -p 8443:8443 \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env SONARQUBE_DATABASE_USER=bn_sonarqube \
  --env SONARQUBE_DATABASE_PASSWORD=bitnami \
  --env SONARQUBE_DATABASE_NAME=bitnami_sonarqube \
  --network sonarqube-network \
  --volume sonarqube_data:/bitnami/sonarqube \
  bitnami/sonarqube:latest
```

Access your application at `http://your-ip/`

### Run the application using Docker Compose

```console
curl -sSL https://raw.githubusercontent.com/bitnami/containers/main/bitnami/sonarqube/docker-compose.yml > docker-compose.yml
docker-compose up -d
```

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/apache).

If you detect any issue in the `docker-compose.yaml` file, feel free to report it or contribute with a fix by following our [Contributing Guidelines](https://github.com/bitnami/containers/blob/main/CONTRIBUTING.md).

## Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami/sonarqube` path. If the mounted directory is empty, it will be initialized on the first run. Additionally you should [mount a volume for persistence of the PostgreSQL data](https://github.com/bitnami/containers/tree/main/bitnami/postgresql#persisting-your-database).

The above examples define the Docker volumes named `postgresql_data` and `sonarqube_data`. The SonarQube&trade; application state will persist as long as volumes are not removed.

To avoid inadvertent removal of volumes, you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

### Mount host directories as data volumes with Docker Compose

This requires a minor change to the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/sonarqube/docker-compose.yml) file present in this repository:

```diff
   postgresql:
     ...
     volumes:
-      - 'postgresql_data:/bitnami/postgresql'
+      - /path/to/postgresql-persistence:/bitnami/postgresql
   ...
   sonarqube:
     ...
     volumes:
-      - 'sonarqube_data:/bitnami/sonarqube'
+      - /path/to/sonarqube-persistence:/bitnami/sonarqube
   ...
-volumes:
-  postgresql_data:
-    driver: local
-  sonarqube_data:
-    driver: local
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

### Mount host directories as data volumes using the Docker command line

#### Step 1: Create a network (if it does not exist)

```console
docker network create sonarqube-network
```

#### Step 2. Create a PostgreSQL container with host volume

```console
docker run -d --name postgresql \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env POSTGRESQL_USERNAME=bn_sonarqube \
  --env POSTGRESQL_PASSWORD=bitnami \
  --env POSTGRESQL_DATABASE=bitnami_sonarqube \
  --network sonarqube-network \
  --volume /path/to/postgresql-persistence:/bitnami/postgresql \
  bitnami/postgresql:latest
```

#### Step 3. Create the SonarQube&trade; container with host volumes

```console
docker run -d --name sonarqube \
  -p 8080:8080 -p 8443:8443 \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env SONARQUBE_DATABASE_USER=bn_sonarqube \
  --env SONARQUBE_DATABASE_PASSWORD=bitnami \
  --env SONARQUBE_DATABASE_NAME=bitnami_sonarqube \
  --network sonarqube-network \
  --volume /path/to/sonarqube-persistence:/bitnami/sonarqube \
  bitnami/sonarqube:latest
```

## Configuration

### Environment variables

#### Customizable environment variables

| Name                                    | Description                                                                                                                                            | Default Value                                       |
|-----------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------|
| `SONARQUBE_MOUNTED_PROVISIONING_DIR`    | Directory for SonarQube initial provisioning.                                                                                                          | `/bitnami/sonarqube-provisioning`                   |
| `SONARQUBE_DATA_TO_PERSIST`             | Files to persist relative to the SonarQube installation directory. To provide multiple values, separate them with a whitespace.                        | `${SONARQUBE_DATA_DIR} ${SONARQUBE_EXTENSIONS_DIR}` |
| `SONARQUBE_PORT_NUMBER`                 | SonarQube Web application port number.                                                                                                                 | `9000`                                              |
| `SONARQUBE_ELASTICSEARCH_PORT_NUMBER`   | SonarQube Elasticsearch application port number.                                                                                                       | `9001`                                              |
| `SONARQUBE_START_TIMEOUT`               | Timeout for the application to start in seconds.                                                                                                       | `300`                                               |
| `SONARQUBE_SKIP_BOOTSTRAP`              | Whether to perform initial bootstrapping for the application.                                                                                          | `no`                                                |
| `SONARQUBE_WEB_CONTEXT`                 | SonarQube prefix used to access to the application.                                                                                                    | `/`                                                 |
| `SONARQUBE_MAX_HEAP_SIZE`               | Maximum heap size for SonarQube services (CE, Search and Web).                                                                                         | `nil`                                               |
| `SONARQUBE_MIN_HEAP_SIZE`               | Minimum heap size for SonarQube services (CE, Search and Web).                                                                                         | `nil`                                               |
| `SONARQUBE_CE_JAVA_ADD_OPTS`            | Additional Java options for Compute Engine.                                                                                                            | `nil`                                               |
| `SONARQUBE_ELASTICSEARCH_JAVA_ADD_OPTS` | Additional Java options for Elasticsearch.                                                                                                             | `nil`                                               |
| `SONARQUBE_WEB_JAVA_ADD_OPTS`           | Additional Java options for Web.                                                                                                                       | `nil`                                               |
| `SONARQUBE_EXTRA_PROPERTIES`            | Comma separated list of properties to be set in the sonar.properties file, e.g. `my.sonar.property1=property_value,my.sonar.property2=property_value`. | `nil`                                               |
| `SONARQUBE_USERNAME`                    | SonarQube user name.                                                                                                                                   | `admin`                                             |
| `SONARQUBE_PASSWORD`                    | SonarQube user password.                                                                                                                               | `bitnami`                                           |
| `SONARQUBE_EMAIL`                       | SonarQube user e-mail address.                                                                                                                         | `user@example.com`                                  |
| `SONARQUBE_SMTP_HOST`                   | SonarQube SMTP server host.                                                                                                                            | `nil`                                               |
| `SONARQUBE_SMTP_PORT_NUMBER`            | SonarQube SMTP server port number.                                                                                                                     | `nil`                                               |
| `SONARQUBE_SMTP_USER`                   | SonarQube SMTP server user.                                                                                                                            | `nil`                                               |
| `SONARQUBE_SMTP_PASSWORD`               | SonarQube SMTP server user password.                                                                                                                   | `nil`                                               |
| `SONARQUBE_SMTP_PROTOCOL`               | SonarQube SMTP server protocol to use.                                                                                                                 | `nil`                                               |
| `SONARQUBE_DATABASE_HOST`               | Database server host.                                                                                                                                  | `$SONARQUBE_DEFAULT_DATABASE_HOST`                  |
| `SONARQUBE_DATABASE_PORT_NUMBER`        | Database server port.                                                                                                                                  | `5432`                                              |
| `SONARQUBE_DATABASE_NAME`               | Database name.                                                                                                                                         | `bitnami_sonarqube`                                 |
| `SONARQUBE_DATABASE_USER`               | Database user name.                                                                                                                                    | `bn_sonarqube`                                      |
| `SONARQUBE_DATABASE_PASSWORD`           | Database user password.                                                                                                                                | `nil`                                               |

#### Read-only environment variables

| Name                              | Description                                          | Value                                      |
|-----------------------------------|------------------------------------------------------|--------------------------------------------|
| `SONARQUBE_BASE_DIR`              | SonarQube installation directory.                    | `${BITNAMI_ROOT_DIR}/sonarqube`            |
| `SONARQUBE_DATA_DIR`              | Directory for SonarQube data files.                  | `${SONARQUBE_BASE_DIR}/data`               |
| `SONARQUBE_EXTENSIONS_DIR`        | Directory for SonarQube extensions.                  | `${SONARQUBE_BASE_DIR}/extensions`         |
| `SONARQUBE_CONF_DIR`              | Directory for SonarQube configuration files.         | `${SONARQUBE_BASE_DIR}/conf`               |
| `SONARQUBE_CONF_FILE`             | Configuration file for SonarQube.                    | `${SONARQUBE_CONF_DIR}/sonar.properties`   |
| `SONARQUBE_LOGS_DIR`              | Directory for SonarQube log files.                   | `${SONARQUBE_BASE_DIR}/logs`               |
| `SONARQUBE_LOG_FILE`              | SonarQube log file.                                  | `${SONARQUBE_LOGS_DIR}/sonar.log`          |
| `SONARQUBE_TMP_DIR`               | Directory for SonarQube temporary files.             | `${SONARQUBE_BASE_DIR}/temp`               |
| `SONARQUBE_PID_FILE`              | SonarQube PID file.                                  | `${SONARQUBE_BASE_DIR}/pids/SonarQube.pid` |
| `SONARQUBE_BIN_DIR`               | SonarQube directory for binary executables.          | `${SONARQUBE_BASE_DIR}/bin/linux-x86-64`   |
| `SONARQUBE_VOLUME_DIR`            | SonarQube directory for mounted configuration files. | `${BITNAMI_VOLUME_DIR}/sonarqube`          |
| `SONARQUBE_DAEMON_USER`           | SonarQube system user.                               | `sonarqube`                                |
| `SONARQUBE_DAEMON_USER_ID`        | SonarQube system user ID.                            | `1001`                                     |
| `SONARQUBE_DAEMON_GROUP`          | SonarQube system group.                              | `sonarqube`                                |
| `SONARQUBE_DAEMON_GROUP_ID`       | SonarQube system group.                              | `1001`                                     |
| `SONARQUBE_DEFAULT_DATABASE_HOST` | Default database server host.                        | `postgresql`                               |

When you start the SonarQube&trade; image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line. If you want to add a new environment variable:

* For docker-compose add the variable name and value under the application section in the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/sonarqube/docker-compose.yml) file present in this repository:

    ```yaml
    sonarqube:
      ...
      environment:
        - SONARQUBE_PASSWORD=my_password
      ...
    ```

* For manual execution add a `--env` option with each variable and value:

    ```console
    $ docker run -d --name sonarqube -p 80:8080 -p 443:8443 \
      --env SONARQUBE_PASSWORD=my_password \
      --network sonarqube-tier \
      --volume /path/to/sonarqube-persistence:/bitnami \
      bitnami/sonarqube:latest
    ```

### Examples

#### SMTP configuration using a Gmail account

This would be an example of SMTP configuration using a Gmail account:

* Modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/sonarqube/docker-compose.yml) file present in this repository:

    ```yaml
      sonarqube:
        ...
        environment:
          - SONARQUBE_DATABASE_USER=bn_sonarqube
          - SONARQUBE_DATABASE_NAME=bitnami_sonarqube
          - ALLOW_EMPTY_PASSWORD=yes
          - SONARQUBE_SMTP_HOST=smtp.gmail.com
          - SONARQUBE_SMTP_PORT_NUMBER=587
          - SONARQUBE_SMTP_USER=your_email@gmail.com
          - SONARQUBE_SMTP_PASSWORD=your_password
      ...
    ```

* For manual execution:

    ```console
    $ docker run -d --name sonarqube -p 80:8080 -p 443:8443 \
      --env SONARQUBE_DATABASE_USER=bn_sonarqube \
      --env SONARQUBE_DATABASE_NAME=bitnami_sonarqube \
      --env SONARQUBE_SMTP_HOST=smtp.gmail.com \
      --env SONARQUBE_SMTP_PORT_NUMBER=587 \
      --env SONARQUBE_SMTP_USER=your_email@gmail.com \
      --env SONARQUBE_SMTP_PASSWORD=your_password \
      --network sonarqube-tier \
      --volume /path/to/sonarqube-persistence:/bitnami \
      bitnami/sonarqube:latest
    ```

#### Connect SonarQube&trade; container to an existing database

The Bitnami SonarQube&trade; container supports connecting the SonarQube&trade; application to an external database. This would be an example of using an external database for SonarQube&trade;.

* Modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/sonarqube/docker-compose.yml) file present in this repository:

    ```diff
       sonarqube:
         ...
         environment:
    -      - SONARQUBE_DATABASE_HOST=mariadb
    +      - SONARQUBE_DATABASE_HOST=mariadb_host
           - SONARQUBE_DATABASE_PORT_NUMBER=3306
           - SONARQUBE_DATABASE_NAME=sonarqube_db
           - SONARQUBE_DATABASE_USER=sonarqube_user
    -      - ALLOW_EMPTY_PASSWORD=yes
    +      - SONARQUBE_DATABASE_PASSWORD=sonarqube_password
         ...
    ```

* For manual execution:

    ```console
    $ docker run -d --name sonarqube\
      -p 8080:8080 -p 8443:8443 \
      --network sonarqube-network \
      --env SONARQUBE_DATABASE_HOST=mariadb_host \
      --env SONARQUBE_DATABASE_PORT_NUMBER=3306 \
      --env SONARQUBE_DATABASE_NAME=sonarqube_db \
      --env SONARQUBE_DATABASE_USER=sonarqube_user \
      --env SONARQUBE_DATABASE_PASSWORD=sonarqube_password \
      --volume sonarqube_data:/bitnami/sonarqube \
      bitnami/sonarqube:latest
    ```

In case the database already contains data from a previous SonarQube&trade; installation, you need to set the variable `SONARQUBE_SKIP_BOOTSTRAP` to `yes`. Otherwise, the container would execute the installation wizard and could modify the existing data in the database. Note that, when setting `SONARQUBE_SKIP_BOOTSTRAP` to `yes`, values for environment variables such as `SONARQUBE_USERNAME`, `SONARQUBE_PASSWORD` or `SONARQUBE_EMAIL` will be ignored.

## Logging

The Bitnami SonarQube&trade; Docker image sends the container logs to `stdout`. To view the logs:

```console
docker logs sonarqube
```

Or using Docker Compose:

```console
docker-compose logs sonarqube
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Backing up your container

To backup your data, configuration and logs, follow these simple steps:

#### Step 1: Stop the currently running container

```console
docker stop sonarqube
```

Or using Docker Compose:

```console
docker-compose stop sonarqube
```

#### Step 2: Run the backup command

We need to mount two volumes in a container we will use to create the backup: a directory on your host to store the backup in, and the volumes from the container we just stopped so we can access the data.

```console
docker run --rm -v /path/to/sonarqube-backups:/backups --volumes-from sonarqube busybox \
  cp -a /bitnami/sonarqube /backups/latest
```

### Restoring a backup

Restoring a backup is as simple as mounting the backup as volumes in the containers.

For the PostgreSQL database container:

```diff
 $ docker run -d --name postgresql \
   ...
-  --volume /path/to/postgresql-persistence:/bitnami/postgresql \
+  --volume /path/to/postgresql-backups/latest:/bitnami/postgresql \
   bitnami/postgresql:latest
```

For the SonarQube&trade; container:

```diff
 $ docker run -d --name sonarqube \
   ...
-  --volume /path/to/sonarqube-persistence:/bitnami/sonarqube \
+  --volume /path/to/sonarqube-backups/latest:/bitnami/sonarqube \
   bitnami/sonarqube:latest
```

### Upgrade this image

Bitnami provides up-to-date versions of PostgreSQL and SonarQube&trade;, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the SonarQube&trade; container. For the PostgreSQL upgrade see: <https://github.com/bitnami/containers/tree/main/bitnami/postgresql#user-content-upgrade-this-image>

The `bitnami/sonarqube:latest` tag always points to the most recent release. To get the most recent release you can simple repull the `latest` tag from the Docker Hub with `docker pull bitnami/sonarqube:latest`. However it is recommended to use [tagged versions](https://hub.docker.com/r/bitnami/sonarqube/tags/).

#### Step 1: Get the updated image

```console
docker pull bitnami/sonarqube:latest
```

#### Step 2: Stop the running container

Stop the currently running container using the command

```console
docker-compose stop sonarqube
```

#### Step 3: Take a snapshot of the application state

Follow the steps in [Backing up your container](#backing-up-your-container) to take a snapshot of the current application state.

#### Step 4: Remove the currently running container

Remove the currently running container by executing the following command:

```console
docker-compose rm -v sonarqube
```

#### Step 5: Run the new image

Update the image tag in `docker-compose.yml` and re-create your container with the new image:

```console
docker-compose up -d
```

## Notable Changes

### 9.0.0-debian-10-r0

* The size of the container image has been decreased.
* The configuration logic is now based on Bash scripts in the *rootfs/* folder.
* The SonarQube&trade; container image has been migrated to a "non-root" user approach. Previously the container ran as the `root` user and the SonarQube&trade; daemon was started as the `sonarqube` user. From now on, both the container and the SonarQube&trade; daemon run as user `1001`. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile, or `user: root` in `docker-compose.yml`. Consequences:
  * Backwards compatibility is not guaranteed when data is persisted using docker or docker-compose. We highly recommend migrating the SonarQube&trade; site by exporting its content, and importing it on a new SonarQube&trade; container. Follow the steps in [Backing up your container](#backing-up-your-container) and [Restoring a backup](#restoring-a-backup) to migrate the data between the old and new container.

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
