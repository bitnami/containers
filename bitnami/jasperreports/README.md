# Bitnami package for JasperReports

## What is JasperReports?

> JasperReports Server is a stand-alone and embeddable reporting server. It is a central information hub, with reporting and analytics that can be embedded into web and mobile applications.

[Overview of JasperReports](http://community.jaspersoft.com/project/jasperreports-server)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name jasperreports bitnami/jasperreports:latest
```

**Warning**: This quick setup is only intended for development environments. You are encouraged to change the insecure default credentials and check out the available configuration options in the [Environment Variables](#environment-variables) section for a more secure deployment.

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use JasperReports in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## How to deploy JasperReports Server in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami JasperReports Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/jasperreports).

Bitnami containers can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami JasperReports Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/jasperreports).

```console
docker pull bitnami/jasperreports:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/jasperreports/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/jasperreports:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## How to use this image

JasperReports requires access to a MySQL or MariaDB database to store information. We'll use the [Bitnami Docker Image for MariaDB](https://github.com/bitnami/containers/tree/main/bitnami/mariadb) for the database requirements.

### Provide jasper specific file config

```diff
  ...
  jasperreports:
    image: docker.io/bitnami/jasperreports:latest
    ports:
      - '80:8080'
    volumes:
      - 'jasperreports_data:/bitnami/jasperreports'
# The line below allows you to provide your own JasperReports configuration files, to be copied to WEB-INF
# - "./config:/bitnami/jasperreports-mounted-conf"
    depends_on:
      - mariadb
    environment:
      # ALLOW_EMPTY_PASSWORD is recommended only for development.
      - ALLOW_EMPTY_PASSWORD=yes
      - JASPERREPORTS_DATABASE_HOST=mariadb
      - JASPERREPORTS_DATABASE_PORT_NUMBER=3306
      - JASPERREPORTS_DATABASE_USER=bn_jasperreports
      - JASPERREPORTS_DATABASE_NAME=bitnami_jasperreports

```

### Using the Docker Command Line

#### Step 1: Create a network

```console
docker network create jasperreports-network
```

#### Step 2: Create a volume for MariaDB persistence and create a MariaDB container

```console
$ docker volume create --name mariadb_data
docker run -d --name mariadb \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env MARIADB_USER=bn_jasperreports \
  --env MARIADB_PASSWORD=bitnami \
  --env MARIADB_DATABASE=bitnami_jasperreports \
  --network jasperreports-network \
  --volume mariadb_data:/bitnami/mariadb \
  bitnami/mariadb:latest
```

#### Step 3: Create volumes for JasperReports persistence and launch the container

```console
$ docker volume create --name jasperreports_data
docker run -d --name jasperreports \
  -p 8080:8080 -p 8443:8443 \
  --env JASPERREPORTS_DATABASE_USER=bn_jasperreports \
  --env JASPERREPORTS_DATABASE_PASSWORD=bitnami \
  --env JASPERREPORTS_DATABASE_NAME=bitnami_jasperreports \
  --network jasperreports-network \
  --volume jasperreports_data:/bitnami/jasperreports \
  bitnami/jasperreports:latest
```

Access your application at `http://your-ip/`

### Run the application using Docker Compose

```console
curl -sSL https://raw.githubusercontent.com/bitnami/containers/main/bitnami/jasperreports/docker-compose.yml > docker-compose.yml
docker-compose up -d
```

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/jasperreports).

If you detect any issue in the `docker-compose.yaml` file, feel free to report it or contribute with a fix by following our [Contributing Guidelines](https://github.com/bitnami/containers/blob/main/CONTRIBUTING.md).

## Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence, you should mount a directory at the `/bitnami/jasperreports` path. If the mounted directory is empty, it will be initialized on the first run. Additionally you should [mount a volume for persistence of the MariaDB data](https://github.com/bitnami/containers/blob/main/bitnami/mariadb#persisting-your-database).

The above examples define the Docker volumes named `mariadb_data` and `jasperreports_data`. The JasperReports application state will persist as long as volumes are not removed.

To avoid inadvertent removal of volumes, you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

### Mount host directories as data volumes with Docker Compose

This requires a minor change to the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/jasperreports/docker-compose.yml) file present in this repository:

```diff
   mariadb:
     ...
     volumes:
-      - 'mariadb_data:/bitnami/mariadb'
+      - /path/to/mariadb-persistence:/bitnami/mariadb
   ...
   jasperreports:
     ...
     volumes:
-      - 'jasperreports_data:/bitnami/jasperreports'
+      - /path/to/jasperreports-persistence:/bitnami/jasperreports
   ...
-volumes:
-  mariadb_data:
-    driver: local
-  jasperreports_data:
-    driver: local
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

### Mount host directories as data volumes using the Docker command line

#### Step 1: Create a network (if it does not exist)

```console
docker network create jasperreports-network
```

#### Step 2. Create a MariaDB container with host volume

```console
docker run -d --name mariadb \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env MARIADB_USER=bn_jasperreports \
  --env MARIADB_PASSWORD=bitnami \
  --env MARIADB_DATABASE=bitnami_jasperreports \
  --network jasperreports-network \
  --volume /path/to/mariadb-persistence:/bitnami/mariadb \
  bitnami/mariadb:latest
```

#### Step 3. Create the JasperReports container with host volumes

```console
docker run -d --name jasperreports \
  -p 8080:8080 -p 8443:8443 \
  --env JASPERREPORTS_DATABASE_USER=bn_jasperreports \
  --env JASPERREPORTS_DATABASE_PASSWORD=bitnami \
  --env JASPERREPORTS_DATABASE_NAME=bitnami_jasperreports \
  --network jasperreports-network \
  --volume /path/to/jasperreports-persistence:/bitnami/jasperreports \
  bitnami/jasperreports:latest
```

## Configuration

### Environment variables

#### Customizable environment variables

| Name                                 | Description                                                                                                                         | Default Value                                                                                                                                                               |
|--------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `JASPERREPORTS_DATA_TO_PERSIST`      | Files to persist relative to the JasperReports installation directory. To provide multiple values, separate them with a whitespace. | `buildomatic/default_master.properties buildomatic/conf_source/db/mysql/db.template.properties buildomatic/conf_source/db/postgresql/db.template.properties .jrsks .jrsksp` |
| `JASPERREPORTS_HOST`                 | JasperReports host name.                                                                                                            | `localhost`                                                                                                                                                                 |
| `JASPERREPORTS_SKIP_BOOTSTRAP`       | Whether to perform initial bootstrapping for the application.                                                                       | `no`                                                                                                                                                                        |
| `JASPERREPORTS_USE_ROOT_URL`         | Move the application to root.                                                                                                       | `false`                                                                                                                                                                     |
| `JASPERREPORTS_USERNAME`             | JasperReports user name.                                                                                                            | `jasperadmin`                                                                                                                                                               |
| `JASPERREPORTS_PASSWORD`             | JasperReports user password.                                                                                                        | `bitnami`                                                                                                                                                                   |
| `JASPERREPORTS_EMAIL`                | JasperReports user e-mail address.                                                                                                  | `user@example.com`                                                                                                                                                          |
| `JASPERREPORTS_SMTP_PROTOCOL`        | JasperReports SMTP server protocol to use.                                                                                          | `smtp`                                                                                                                                                                      |
| `JASPERREPORTS_SMTP_EMAIL`           | JasperReports SMTP server email to use.                                                                                             | `fromuser@example.com`                                                                                                                                                      |
| `JASPERREPORTS_DATABASE_TYPE`        | Database server type.                                                                                                               | `mariadb`                                                                                                                                                                   |
| `JASPERREPORTS_DATABASE_HOST`        | Database server host.                                                                                                               | `$JASPERREPORTS_DEFAULT_DATABASE_HOST`                                                                                                                                      |
| `JASPERREPORTS_DATABASE_PORT_NUMBER` | Database server port.                                                                                                               | `3306`                                                                                                                                                                      |
| `JASPERREPORTS_DATABASE_NAME`        | Database name.                                                                                                                      | `bitnami_jasperreports`                                                                                                                                                     |
| `JASPERREPORTS_DATABASE_USER`        | Database user name.                                                                                                                 | `bn_jasperreports`                                                                                                                                                          |

#### Read-only environment variables

| Name                                   | Description                                              | Value                                                 |
|----------------------------------------|----------------------------------------------------------|-------------------------------------------------------|
| `JASPERREPORTS_BASE_DIR`               | JasperReports installation directory.                    | `${BITNAMI_ROOT_DIR}/jasperreports`                   |
| `JASPERREPORTS_CONF_DIR`               | Configuration directory for JasperReports.               | `${JASPERREPORTS_BASE_DIR}/buildomatic`               |
| `JASPERREPORTS_LOGS_DIR`               | Log directory for JasperReports.                         | `${JASPERREPORTS_BASE_DIR}/WEB-INF/logs`              |
| `JASPERREPORTS_LOG_FILE`               | Log file for JasperReports.                              | `${JASPERREPORTS_LOGS_DIR}/jasperserver.log`          |
| `JASPERREPORTS_CONF_FILE`              | Configuration file for JasperReports.                    | `${JASPERREPORTS_CONF_DIR}/default_master.properties` |
| `JASPERREPORTS_VOLUME_DIR`             | JasperReports directory for mounted configuration files. | `${BITNAMI_VOLUME_DIR}/jasperreports`                 |
| `JASPERREPORTS_DAEMON_USER`            | JasperReports system user.                               | `tomcat`                                              |
| `JASPERREPORTS_DAEMON_GROUP`           | JasperReports system group.                              | `tomcat`                                              |
| `JASPERREPORTS_TOMCAT_AJP_PORT_NUMBER` | Tomcat AJP port number.                                  | `8009`                                                |
| `JASPERREPORTS_DEFAULT_DATABASE_HOST`  | Default database server host.                            | `mariadb`                                             |
| `JASPERREPORTS_DEFAULT_DATABASE_HOST`  | Default database server host.                            | `127.0.0.1`                                           |

When you start the JasperReports image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line. If you want to add a new environment variable:

* For docker-compose add the variable name and value under the application section in the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/jasperreports/docker-compose.yml) file present in this repository:

    ```yaml
    jasperreports:
      ...
      environment:
        - JASPERREPORTS_PASSWORD=my_password
      ...
    ```

* For manual execution add a `--env` option with each variable and value:

    ```console
    $ docker run -d --name jasperreports -p 80:8080 -p 443:8443 \
      --env JASPERREPORTS_PASSWORD=my_password \
      --network jasperreports-tier \
      --volume /path/to/jasperreports-persistence:/bitnami \
      bitnami/jasperreports:latest
    ```

#### Examples

##### SMTP configuration using a Gmail account

This would be an example of SMTP configuration using a Gmail account:

* Modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/jasperreports/docker-compose.yml) file present in this repository:

    ```yaml
      jasperreports:
        ...
        environment:
          - JASPERREPORTS_DATABASE_USER=bn_jasperreports
          - JASPERREPORTS_DATABASE_NAME=bitnami_jasperreports
          - ALLOW_EMPTY_PASSWORD=yes
          - JASPERREPORTS_SMTP_HOST=smtp.gmail.com
          - JASPERREPORTS_SMTP_PORT_NUMBER=587
          - JASPERREPORTS_SMTP_PROTOCOL=smtps
          - JASPERREPORTS_SMTP_USER=your_email@gmail.com
          - JASPERREPORTS_SMTP_PASSWORD=your_password
      ...
    ```

* For manual execution:

    ```console
    $ docker run -d --name jasperreports -p 80:8080 -p 443:8443 \
      --env JASPERREPORTS_DATABASE_USER=bn_jasperreports \
      --env JASPERREPORTS_DATABASE_NAME=bitnami_jasperreports \
      --env JASPERREPORTS_SMTP_HOST=smtp.gmail.com \
      --env JASPERREPORTS_SMTP_PORT_NUMBER=587 \
      --env JASPERREPORTS_SMTP_PROTOCOL=smtps \
      --env JASPERREPORTS_SMTP_USER=your_email@gmail.com \
      --env JASPERREPORTS_SMTP_PASSWORD=your_password \
      --network jasperreports-tier \
      --volume /path/to/jasperreports-persistence:/bitnami \
      bitnami/jasperreports:latest
    ```

##### Connect JasperReports container to an existing database

The Bitnami JasperReports container supports connecting the JasperReports application to an external database. This would be an example of using an external database for JasperReports.

* Modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/jasperreports/docker-compose.yml) file present in this repository:

    ```diff
       jasperreports:
         ...
         environment:
    -      - JASPERREPORTS_DATABASE_HOST=mariadb
    +      - JASPERREPORTS_DATABASE_HOST=mariadb_host
           - JASPERREPORTS_DATABASE_PORT_NUMBER=3306
           - JASPERREPORTS_DATABASE_NAME=jasperreports_db
           - JASPERREPORTS_DATABASE_USER=jasperreports_user
    -      - ALLOW_EMPTY_PASSWORD=yes
    +      - JASPERREPORTS_DATABASE_PASSWORD=jasperreports_password
         ...
    ```

* For manual execution:

    ```console
    $ docker run -d --name jasperreports\
      -p 8080:8080 -p 8443:8443 \
      --network jasperreports-network \
      --env JASPERREPORTS_DATABASE_HOST=mariadb_host \
      --env JASPERREPORTS_DATABASE_PORT_NUMBER=3306 \
      --env JASPERREPORTS_DATABASE_NAME=jasperreports_db \
      --env JASPERREPORTS_DATABASE_USER=jasperreports_user \
      --env JASPERREPORTS_DATABASE_PASSWORD=jasperreports_password \
      --volume jasperreports_data:/bitnami/jasperreports \
      bitnami/jasperreports:latest
    ```

In case the database already contains data from a previous JasperReports installation, you need to set the variable `JASPERREPORTS_SKIP_BOOTSTRAP` to `yes`. Otherwise, the container would execute the installation wizard and could modify the existing data in the database. Note that, when setting `JASPERREPORTS_SKIP_BOOTSTRAP` to `yes`, values for environment variables such as `JASPERREPORTS_USERNAME`, `JASPERREPORTS_PASSWORD` or `JASPERREPORTS_EMAIL` will be ignored.

## Logging

The Bitnami JasperReports Docker image sends the container logs to `stdout`. To view the logs:

```console
docker logs jasperreports
```

Or using Docker Compose:

```console
docker-compose logs jasperreports
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Backing up your container

To backup your data, configuration and logs, follow these simple steps:

#### Step 1: Stop the currently running container

```console
docker stop jasperreports
```

Or using Docker Compose:

```console
docker-compose stop jasperreports
```

#### Step 2: Run the backup command

We need to mount two volumes in a container we will use to create the backup: a directory on your host to store the backup in, and the volumes from the container we just stopped so we can access the data.

```console
docker run --rm -v /path/to/jasperreports-backups:/backups --volumes-from jasperreports bitnami/minideb \
  cp -a /bitnami/jasperreports /backups/latest
```

### Restoring a backup

Restoring a backup is as simple as mounting the backup as volumes in the containers.

For the MariaDB database container:

```diff
 $ docker run -d --name mariadb \
   ...
-  --volume /path/to/mariadb-persistence:/bitnami/mariadb \
+  --volume /path/to/mariadb-backups/latest:/bitnami/mariadb \
   bitnami/mariadb:latest
```

For the JasperReports container:

```diff
 $ docker run -d --name jasperreports \
   ...
-  --volume /path/to/jasperreports-persistence:/bitnami/jasperreports \
+  --volume /path/to/jasperreports-backups/latest:/bitnami/jasperreports \
   bitnami/jasperreports:latest
```

### Upgrade this image

Bitnami provides up-to-date versions of MariaDB and JasperReports, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the JasperReports container. For the MariaDB upgrade see: <https://github.com/bitnami/containers/tree/main/bitnami/mariadb#upgrade-this-image>

The `bitnami/jasperreports:latest` tag always points to the most recent release. To get the most recent release you can simple repull the `latest` tag from the Docker Hub with `docker pull bitnami/jasperreports:latest`. However it is recommended to use [tagged versions](https://hub.docker.com/r/bitnami/jasperreports/tags/).

#### Step 1: Get the updated image

```console
docker pull bitnami/jasperreports:latest
```

#### Step 2: Stop the running container

Stop the currently running container using the command

```console
docker-compose stop jasperreports
```

#### Step 3: Take a snapshot of the application state

Follow the steps in [Backing up your container](#backing-up-your-container) to take a snapshot of the current application state.

#### Step 4: Remove the currently running container

Remove the currently running container by executing the following command:

```console
docker-compose rm -v jasperreports
```

#### Step 5: Run the new image

Update the image tag in `docker-compose.yml` and re-create your container with the new image:

```console
docker-compose up -d
```

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues) or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/containers/issues/new/choose). For us to provide better support, be sure to fill the issue template.

## Notable Changes

## 7.8.0-debian-10-r275

* The size of the container image has been reduced.
* The configuration logic is now based on Bash scripts in the *rootfs/* folder.
* The container has been migrated to a non-root user approach. Previously the container ran as the `root` user and the Tomcat daemon was started as the `tomcat` user. From now on, both the container and the Tomcat daemon run as user `1001`. As a consequence, the data directory must be writable by that user. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile.

## 7.2.0-debian-10-r64

* Java distribution has been migrated from AdoptOpenJDK to OpenJDK Liberica. As part of VMware, we have an agreement with Bell Software to distribute the Liberica distribution of OpenJDK. That way, we can provide support & the latest versions and security releases for Java.

## License

Copyright &copy; 2024 Broadcom. The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
