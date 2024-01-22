# Bitnami package for ReportServer Community

## What is ReportServer Community?

> ReportServer is the open source business intelligence tool for fast information access and analysis. It integrates multiple reporting engines and features an intuitive dashboard component.

[Overview of ReportServer Community](https://reportserver.net/en/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name reportserver bitnami/reportserver:latest
```

**Warning**: This quick setup is only intended for development environments. You are encouraged to change the insecure default credentials and check out the available configuration options in the [Environment Variables](#environment-variables) section for a more secure deployment.

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use ReportServer Community in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami ReportServer Community Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/reportserver).

```console
docker pull bitnami/reportserver:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/reportserver/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/reportserver:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## How to use this image

ReportServer Community requires access to a MySQL or MariaDB database to store information. We'll use the [Bitnami Docker Image for MariaDB](https://github.com/bitnami/containers/tree/main/bitnami/mariadb) for the database requirements.

### Using the Docker Command Line

#### Step 1: Create a network

```console
docker network create reportserver-network
```

#### Step 2: Create a volume for MariaDB persistence and create a MariaDB container

```console
$ docker volume create --name mariadb_data
docker run -d --name mariadb \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env MARIADB_USER=bn_reportserver \
  --env MARIADB_PASSWORD=bitnami \
  --env MARIADB_DATABASE=bitnami_reportserver \
  --network reportserver-network \
  --volume mariadb_data:/bitnami/mariadb \
  bitnami/mariadb:latest
```

#### Step 3: Create volumes for ReportServer Community persistence and launch the container

```console
$ docker volume create --name reportserver_data
docker run -d --name reportserver \
  -p 8080:8080 -p 8443:8443 \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env REPORTSERVER_DATABASE_USER=bn_reportserver \
  --env REPORTSERVER_DATABASE_PASSWORD=bitnami \
  --env REPORTSERVER_DATABASE_NAME=bitnami_reportserver \
  --network reportserver-network \
  --volume reportserver_data:/bitnami/reportserver \
  bitnami/reportserver:latest
```

Access your application at `http://your-ip/`

### Run the application using Docker Compose

```console
curl -sSL https://raw.githubusercontent.com/bitnami/containers/main/bitnami/reportserver/docker-compose.yml > docker-compose.yml
docker-compose up -d
```

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes.

If you detect any issue in the `docker-compose.yaml` file, feel free to report it or contribute with a fix by following our [Contributing Guidelines](https://github.com/bitnami/containers/blob/main/CONTRIBUTING.md).

## Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami/reportserver` path. If the mounted directory is empty, it will be initialized on the first run. Additionally you should [mount a volume for persistence of the MariaDB data](https://github.com/bitnami/containers/blob/main/bitnami/mariadb#persisting-your-database).

The above examples define the Docker volumes named `mariadb_data` and `reportserver_data`. The ReportServer Community application state will persist as long as volumes are not removed.

To avoid inadvertent removal of volumes, you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

### Mount host directories as data volumes with Docker Compose

This requires a minor change to the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/reportserver/docker-compose.yml) file present in this repository:

```diff
   mariadb:
     ...
     volumes:
-      - 'mariadb_data:/bitnami/mariadb'
+      - /path/to/mariadb-persistence:/bitnami/mariadb
   ...
   reportserver:
     ...
     volumes:
-      - 'reportserver_data:/bitnami/reportserver'
+      - /path/to/reportserver-persistence:/bitnami/reportserver
   ...
-volumes:
-  mariadb_data:
-    driver: local
-  reportserver_data:
-    driver: local
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

### Mount host directories as data volumes using the Docker command line

#### Step 1: Create a network (if it does not exist)

```console
docker network create reportserver-network
```

#### Step 2. Create a MariaDB container with host volume

```console
docker run -d --name mariadb \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env MARIADB_USER=bn_reportserver \
  --env MARIADB_PASSWORD=bitnami \
  --env MARIADB_DATABASE=bitnami_reportserver \
  --network reportserver-network \
  --volume /path/to/mariadb-persistence:/bitnami/mariadb \
  bitnami/mariadb:latest
```

#### Step 3. Create the ReportServer Community container with host volumes

```console
docker run -d --name reportserver \
  -p 8080:8080 -p 8443:8443 \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env REPORTSERVER_DATABASE_USER=bn_reportserver \
  --env REPORTSERVER_DATABASE_PASSWORD=bitnami \
  --env REPORTSERVER_DATABASE_NAME=bitnami_reportserver \
  --network reportserver-network \
  --volume /path/to/reportserver-persistence:/bitnami/reportserver \
  bitnami/reportserver:latest
```

## Configuration

### Environment variables

#### Customizable environment variables

| Name                                | Description                       | Default Value                                                     |
|-------------------------------------|-----------------------------------|-------------------------------------------------------------------|
| `REPORTSERVER_INSTALL_DEMO_DATA`    | Whether to install demo data.     | `no`                                                              |
| `REPORTSERVER_USERNAME`             | ReportServer user name.           | `user`                                                            |
| `REPORTSERVER_PASSWORD`             | ReportServer user password.       | `bitnami`                                                         |
| `REPORTSERVER_EMAIL`                | ReportServer user e-mail address. | `user@example.com`                                                |
| `REPORTSERVER_FIRST_NAME`           | ReportServer user first name.     | `FirstName`                                                       |
| `REPORTSERVER_LAST_NAME`            | ReportServer user last name.      | `LastName`                                                        |
| `REPORTSERVER_SMTP_PROTOCOL`        | Enable SMTP SSL.                  | `tls`                                                             |
| `REPORTSERVER_DATABASE_HOST`        | Database server host.             | `$REPORTSERVER_DEFAULT_DATABASE_HOST`                             |
| `REPORTSERVER_DATABASE_PORT_NUMBER` | Database server port.             | `3306`                                                            |
| `REPORTSERVER_DATABASE_NAME`        | Database name.                    | `bitnami_reportserver`                                            |
| `REPORTSERVER_DATABASE_USER`        | Database user name.               | `bn_reportserver`                                                 |
| `TOMCAT_EXTRA_JAVA_OPTS`            | Tomcat extra java options.        | `$TOMCAT_EXTRA_JAVA_OPTS -Drs.configdir=${REPORTSERVER_CONF_DIR}` |

#### Read-only environment variables

| Name                                  | Description                           | Value                                              |
|---------------------------------------|---------------------------------------|----------------------------------------------------|
| `REPORTSERVER_BASE_DIR`               | ReportServer installation directory.  | `${BITNAMI_ROOT_DIR}/reportserver`                 |
| `REPORTSERVER_CONF_DIR`               | ReportServer configuration directory. | `${REPORTSERVER_BASE_DIR}/WEB-INF/classes`         |
| `REPORTSERVER_CONF_FILE`              | Configuration file for ReportServer.  | `${REPORTSERVER_CONF_DIR}/reportserver.properties` |
| `REPORTSERVER_DAEMON_USER`            | ReportServer system user.             | `tomcat`                                           |
| `REPORTSERVER_DAEMON_GROUP`           | ReportServer system group.            | `tomcat`                                           |
| `REPORTSERVER_DEFAULT_DATABASE_HOST`  | Default database server host.         | `mariadb`                                          |
| `REPORTSERVER_DEFAULT_DATABASE_HOST`  | Default database server host.         | `127.0.0.1`                                        |
| `REPORTSERVER_TOMCAT_AJP_PORT_NUMBER` | Tomcat AJP port number.               | `8009`                                             |

When you start the ReportServer Community image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line. If you want to add a new environment variable:

* For docker-compose add the variable name and value under the application section in the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/reportserver/docker-compose.yml) file present in this repository:

    ```yaml
    reportserver:
      ...
      environment:
        - REPORTSERVER_PASSWORD=my_password
      ...
    ```

* For manual execution add a `--env` option with each variable and value:

    ```console
    $ docker run -d --name reportserver -p 80:8080 -p 443:8443 \
      --env REPORTSERVER_PASSWORD=my_password \
      --network reportserver-tier \
      --volume /path/to/reportserver-persistence:/bitnami \
      bitnami/reportserver:latest
    ```

### Examples

#### SMTP configuration using a Gmail account

This would be an example of SMTP configuration using a Gmail account:

* Modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/reportserver/docker-compose.yml) file present in this repository:

    ```yaml
      reportserver:
        ...
        environment:
          - REPORTSERVER_DATABASE_USER=bn_reportserver
          - REPORTSERVER_DATABASE_NAME=bitnami_reportserver
          - ALLOW_EMPTY_PASSWORD=yes
          - REPORTSERVER_SMTP_HOST=smtp.gmail.com
          - REPORTSERVER_SMTP_PORT=587
          - REPORTSERVER_SMTP_USER=your_email@gmail.com
          - REPORTSERVER_SMTP_PASSWORD=your_password
      ...
    ```

* For manual execution:

    ```console
    $ docker run -d --name reportserver -p 80:8080 -p 443:8443 \
      --env REPORTSERVER_DATABASE_USER=bn_reportserver \
      --env REPORTSERVER_DATABASE_NAME=bitnami_reportserver \
      --env REPORTSERVER_SMTP_HOST=smtp.gmail.com \
      --env REPORTSERVER_SMTP_PORT=587 \
      --env REPORTSERVER_SMTP_USER=your_email@gmail.com \
      --env REPORTSERVER_SMTP_PASSWORD=your_password \
      --network reportserver-tier \
      --volume /path/to/reportserver-persistence:/bitnami \
      bitnami/reportserver:latest
    ```

#### Connect ReportServer Community container to an existing database

The Bitnami ReportServer Community container supports connecting the ReportServer Community application to an external database. This would be an example of using an external database for ReportServer Community.

* Modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/reportserver/docker-compose.yml) file present in this repository:

    ```diff
       reportserver:
         ...
         environment:
    -      - REPORTSERVER_DATABASE_HOST=mariadb
    +      - REPORTSERVER_DATABASE_HOST=mariadb_host
           - REPORTSERVER_DATABASE_PORT_NUMBER=3306
           - REPORTSERVER_DATABASE_NAME=reportserver_db
           - REPORTSERVER_DATABASE_USER=reportserver_user
    -      - ALLOW_EMPTY_PASSWORD=yes
    +      - REPORTSERVER_DATABASE_PASSWORD=reportserver_password
         ...
    ```

* For manual execution:

    ```console
    $ docker run -d --name reportserver\
      -p 8080:8080 -p 8443:8443 \
      --network reportserver-network \
      --env REPORTSERVER_DATABASE_HOST=mariadb_host \
      --env REPORTSERVER_DATABASE_PORT_NUMBER=3306 \
      --env REPORTSERVER_DATABASE_NAME=reportserver_db \
      --env REPORTSERVER_DATABASE_USER=reportserver_user \
      --env REPORTSERVER_DATABASE_PASSWORD=reportserver_password \
      --volume reportserver_data:/bitnami/reportserver \
      bitnami/reportserver:latest
    ```

In case the database already contains data from a previous ReportServer Community installation, you need to set the variable `REPORTSERVER_SKIP_BOOTSTRAP` to `yes`. Otherwise, the container would execute the installation wizard and could modify the existing data in the database. Note that, when setting `REPORTSERVER_SKIP_BOOTSTRAP` to `yes`, values for environment variables such as `REPORTSERVER_USERNAME`, `REPORTSERVER_PASSWORD` or `REPORTSERVER_EMAIL` will be ignored.

## Logging

The Bitnami ReportServer Community Docker image sends the container logs to `stdout`. To view the logs:

```console
docker logs reportserver
```

Or using Docker Compose:

```console
docker-compose logs reportserver
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Backing up your container

To backup your data, configuration and logs, follow these simple steps:

#### Step 1: Stop the currently running container

```console
docker stop reportserver
```

Or using Docker Compose:

```console
docker-compose stop reportserver
```

#### Step 2: Run the backup command

We need to mount two volumes in a container we will use to create the backup: a directory on your host to store the backup in, and the volumes from the container we just stopped so we can access the data.

```console
docker run --rm -v /path/to/reportserver-backups:/backups --volumes-from reportserver busybox \
  cp -a /bitnami/reportserver /backups/latest
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

For the ReportServer Community container:

```diff
 $ docker run -d --name reportserver \
   ...
-  --volume /path/to/reportserver-persistence:/bitnami/reportserver \
+  --volume /path/to/reportserver-backups/latest:/bitnami/reportserver \
   bitnami/reportserver:latest
```

### Upgrade this image

Bitnami provides up-to-date versions of MariaDB and ReportServer Community, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the ReportServer Community container. For the MariaDB upgrade see: <https://github.com/bitnami/containers/tree/main/bitnami/mariadb#upgrade-this-image>

The `bitnami/reportserver:latest` tag always points to the most recent release. To get the most recent release you can simple repull the `latest` tag from the Docker Hub with `docker pull bitnami/reportserver:latest`. However it is recommended to use [tagged versions](https://hub.docker.com/r/bitnami/reportserver/tags/).

#### Step 1: Get the updated image

```console
docker pull bitnami/reportserver:latest
```

#### Step 2: Stop the running container

Stop the currently running container using the command

```console
docker-compose stop reportserver
```

#### Step 3: Take a snapshot of the application state

Follow the steps in [Backing up your container](#backing-up-your-container) to take a snapshot of the current application state.

#### Step 4: Remove the currently running container

Remove the currently running container by executing the following command:

```console
docker-compose rm -v reportserver
```

#### Step 5: Run the new image

Update the image tag in `docker-compose.yml` and re-create your container with the new image:

```console
docker-compose up -d
```

## Learn more about ReportServer Community

Developers can obtain the source code for ReportServer Community from [https://github.com/infofabrik/reportserver](https://github.com/infofabrik/reportserver).

More information is available from the [ReportServer website](https://reportserver.net/en/).

## Notable Changes

### 3.7.0-6044-debian-10-r52

* The size of the container image has been reduced.
* The configuration logic is now based on Bash scripts in the *rootfs/* folder.

### 3.1.2-6022-debian-10-r23

* Java distribution has been migrated from AdoptOpenJDK to OpenJDK Liberica. As part of VMware, we have an agreement with Bell Software to distribute the Liberica distribution of OpenJDK. That way, we can provide support & the latest versions and security releases for Java.

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues) or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/containers/issues/new/choose). For us to provide better support, be sure to fill the issue template.

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
