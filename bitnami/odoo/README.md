# Bitnami package for Odoo

## What is Odoo?

> Odoo is an open source ERP and CRM platform, formerly known as OpenERP, that can connect a wide variety of business operations such as sales, supply chain, finance, and project management.

[Overview of Odoo](https://www.odoo.com/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name odoo bitnami/odoo:latest
```

**Warning**: This quick setup is only intended for development environments. You are encouraged to change the insecure default credentials and check out the available configuration options in the [Environment Variables](#environment-variables) section for a more secure d
eployment.

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use Odoo in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## How to deploy Odoo in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the
[Bitnami Odoo Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/odoo).

Bitnami containers can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Only latest stable branch maintained in the free Bitnami catalog

Starting December 10th 2024, only the latest stable branch of any container will receive updates in the free Bitnami catalog. To access up-to-date releases for all upstream-supported branches, consider upgrading to Bitnami Premium. Previous versions already released will not be deleted. They are still available to pull from DockerHub.

Please check the Bitnami Premium page in our partner [Arrow Electronics](https://www.arrow.com/globalecs/na/vendors/bitnami?utm_source=GitHub&utm_medium=containers) for more information.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami Odoo Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/odoo).

```console
docker pull bitnami/odoo:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/odoo/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/odoo:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## How to use this image

Odoo requires access to a PostgreSQL database to store information. We'll use the [Bitnami Docker Image for PostgreSQL](https://github.com/bitnami/containers/tree/main/bitnami/postgresql) for the database requirements.

### Using the Docker Command Line

#### Step 1: Create a network

```console
docker network create odoo-network
```

#### Step 2: Create a volume for PostgreSQL persistence and create a PostgreSQL container

```console
$ docker volume create --name postgresql_data
docker run -d --name postgresql \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env POSTGRESQL_PASSWORD=bitnami \
  --network odoo-network \
  --volume postgresql_data:/bitnami/postgresql \
  bitnami/postgresql:latest
```

#### Step 3: Create volumes for Odoo persistence and launch the container

```console
$ docker volume create --name odoo_data
docker run -d --name odoo \
  -p 80:8069 \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env ODOO_DATABASE_ADMIN_PASSWORD=bitnami \
  --network odoo-network \
  --volume odoo_data:/bitnami/odoo \
  bitnami/odoo:latest
```

Access your application at `http://your-ip/`

### Run the application using Docker Compose

```console
curl -sSL https://raw.githubusercontent.com/bitnami/containers/main/bitnami/odoo/docker-compose.yml > docker-compose.yml
docker-compose up -d
```

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/odoo).

If you detect any issue in the `docker-compose.yaml` file, feel free to report it or contribute with a fix by following our [Contributing Guidelines](https://github.com/bitnami/containers/blob/main/CONTRIBUTING.md).

## Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami/odoo` path. If the mounted directory is empty, it will be initialized on the first run. Additionally you should [mount a volume for persistence of the PostgreSQL data](https://github.com/bitnami/containers/tree/main/bitnami/postgresql#persisting-your-database).

The above examples define the Docker volumes named `postgresql_data` and `odoo_data`. The Odoo application state will persist as long as volumes are not removed.

To avoid inadvertent removal of volumes, you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

### Mount host directories as data volumes with Docker Compose

This requires a minor change to the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/odoo/docker-compose.yml) file present in this repository:

```diff
   postgresql:
     ...
     volumes:
-      - 'postgresql_data:/bitnami/postgresql'
+      - /path/to/postgresql-persistence:/bitnami/postgresql
   ...
   odoo:
     ...
     volumes:
-      - 'odoo_data:/bitnami/odoo'
+      - /path/to/odoo-persistence:/bitnami/odoo
   ...
-volumes:
-  postgresql_data:
-    driver: local
-  odoo_data:
-    driver: local
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

### Mount host directories as data volumes using the Docker command line

#### Step 1: Create a network (if it does not exist)

```console
docker network create odoo-network
```

#### Step 2. Create a PostgreSQL container with host volume

```console
docker run -d --name postgresql \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env POSTGRESQL_PASSWORD=bitnami \
  --network odoo-network \
  --volume /path/to/postgresql-persistence:/bitnami/postgresql \
  bitnami/postgresql:latest
```

#### Step 3. Create the Odoo container with host volumes

```console
docker run -d --name odoo \
  -p 80:8069 \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env ODOO_DATABASE_ADMIN_PASSWORD=bitnami \
  --network odoo-network \
  --volume /path/to/odoo-persistence:/bitnami/odoo \
  bitnami/odoo:latest
```

## Configuration

### Environment variables

#### Customizable environment variables

| Name                           | Description                                                                                                                | Default Value                                          |
|--------------------------------|----------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------|
| `ODOO_DATA_TO_PERSIST`         | Files to persist relative to the Odoo installation directory. To provide multiple values, separate them with a whitespace. | `${ODOO_ADDONS_DIR} ${ODOO_CONF_DIR} ${ODOO_DATA_DIR}` |
| `ODOO_PORT_NUMBER`             | Port number in which Odoo will run.                                                                                        | `8069`                                                 |
| `ODOO_LONGPOLLING_PORT_NUMBER` | Port number in which the Odoo Longpolling service will run.                                                                | `8072`                                                 |
| `ODOO_SKIP_BOOTSTRAP`          | Whether to perform initial bootstrapping for the application.                                                              | `no`                                                   |
| `ODOO_SKIP_MODULES_UPDATE`     | Whether to perform initial update of the plugins installed.                                                                | `no`                                                   |
| `ODOO_LOAD_DEMO_DATA`          | Whether to load demo data.                                                                                                 | `no`                                                   |
| `ODOO_LIST_DB`                 | Whether the database selector is available.                                                                                | `no`                                                   |
| `ODOO_EMAIL`                   | Odoo user e-mail address.                                                                                                  | `user@example.com`                                     |
| `ODOO_PASSWORD`                | Odoo user password.                                                                                                        | `bitnami`                                              |
| `ODOO_SMTP_HOST`               | Odoo SMTP server host.                                                                                                     | `nil`                                                  |
| `ODOO_SMTP_PORT_NUMBER`        | Odoo SMTP server port number.                                                                                              | `nil`                                                  |
| `ODOO_SMTP_USER`               | Odoo SMTP server user.                                                                                                     | `nil`                                                  |
| `ODOO_SMTP_PASSWORD`           | Odoo SMTP server user password.                                                                                            | `nil`                                                  |
| `ODOO_SMTP_PROTOCOL`           | Odoo SMTP server protocol to use.                                                                                          | `nil`                                                  |
| `ODOO_DATABASE_HOST`           | Database server host.                                                                                                      | `$ODOO_DEFAULT_DATABASE_HOST`                          |
| `ODOO_DATABASE_PORT_NUMBER`    | Database server port.                                                                                                      | `5432`                                                 |
| `ODOO_DATABASE_NAME`           | Database name.                                                                                                             | `bitnami_odoo`                                         |
| `ODOO_DATABASE_USER`           | Database user name.                                                                                                        | `bn_odoo`                                              |
| `ODOO_DATABASE_PASSWORD`       | Database user password.                                                                                                    | `nil`                                                  |
| `ODOO_DATABASE_FILTER`         | Database filter                                                                                                            | `nil`                                                  |

#### Read-only environment variables

| Name                         | Description                                     | Value                                         |
|------------------------------|-------------------------------------------------|-----------------------------------------------|
| `ODOO_BASE_DIR`              | Odoo installation directory.                    | `${BITNAMI_ROOT_DIR}/odoo`                    |
| `ODOO_BIN_DIR`               | Odoo directory for binary executables.          | `${ODOO_BASE_DIR}/bin`                        |
| `ODOO_CONF_DIR`              | Odoo directory for configuration files.         | `${ODOO_BASE_DIR}/conf`                       |
| `ODOO_CONF_FILE`             | Configuration file for Odoo.                    | `${ODOO_CONF_DIR}/odoo.conf`                  |
| `ODOO_DATA_DIR`              | Odoo directory for data files.                  | `${ODOO_BASE_DIR}/data`                       |
| `ODOO_ADDONS_DIR`            | Odoo directory for addons.                      | `${ODOO_ADDONS_DIR:-${ODOO_BASE_DIR}/addons}` |
| `ODOO_TMP_DIR`               | Odoo directory for temporary files.             | `${ODOO_BASE_DIR}/tmp`                        |
| `ODOO_PID_FILE`              | PID file for Odoo.                              | `${ODOO_TMP_DIR}/odoo.pid`                    |
| `ODOO_LOGS_DIR`              | Odoo directory for log files.                   | `${ODOO_BASE_DIR}/log`                        |
| `ODOO_LOG_FILE`              | Log file for Odoo.                              | `${ODOO_LOGS_DIR}/odoo-server.log`            |
| `ODOO_VOLUME_DIR`            | Odoo directory for mounted configuration files. | `${BITNAMI_VOLUME_DIR}/odoo`                  |
| `ODOO_DAEMON_USER`           | Odoo system user.                               | `odoo`                                        |
| `ODOO_DAEMON_GROUP`          | Odoo system group.                              | `odoo`                                        |
| `ODOO_DEFAULT_DATABASE_HOST` | Default database server host.                   | `postgresql`                                  |

When you start the Odoo image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line. If you want to add a new environment variable:

* For docker-compose add the variable name and value under the application section in the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/odoo/docker-compose.yml) file present in this repository:

    ```yaml
    odoo:
      ...
      environment:
        - ODOO_PASSWORD=my_password
      ...
    ```

* For manual execution add a `--env` option with each variable and value:

    ```console
    $ docker run -d --name odoo -p 80:8069 \
      --env ODOO_PASSWORD=my_password \
      --network odoo-tier \
      --volume /path/to/odoo-persistence:/bitnami \
      bitnami/odoo:latest
    ```

### Examples

#### SMTP configuration using a Gmail account

This would be an example of SMTP configuration using a Gmail account:

* Modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/odoo/docker-compose.yml) file present in this repository:

    ```yaml
      odoo:
        ...
        environment:
          - ALLOW_EMPTY_PASSWORD=yes
          - ODOO_SMTP_HOST=smtp.gmail.com
          - ODOO_SMTP_PORT_NUMBER=587
          - ODOO_SMTP_USER=your_email@gmail.com
          - ODOO_SMTP_PASSWORD=your_password
      ...
    ```

* For manual execution:

    ```console
    $ docker run -d --name odoo -p 80:8069 \
      --env ODOO_SMTP_HOST=smtp.gmail.com \
      --env ODOO_SMTP_PORT_NUMBER=587 \
      --env ODOO_SMTP_USER=your_email@gmail.com \
      --env ODOO_SMTP_PASSWORD=your_password \
      --network odoo-tier \
      --volume /path/to/odoo-persistence:/bitnami \
      bitnami/odoo:latest
    ```

#### Connect Odoo container to an existing database

The Bitnami Odoo container supports connecting the Odoo application to an external database. This would be an example of using an external database for Odoo.

* Modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/odoo/docker-compose.yml) file present in this repository:

    ```diff
       odoo:
         ...
         environment:
    -      - ODOO_DATABASE_HOST=mariadb
    +      - ODOO_DATABASE_HOST=mariadb_host
           - ODOO_DATABASE_PORT_NUMBER=3306
    -      - ALLOW_EMPTY_PASSWORD=yes
    +      - ODOO_DATABASE_ADMIN_PASSWORD=odoo_password
         ...
    ```

* For manual execution:

    ```console
    $ docker run -d --name odoo\
      -p 80:8069 \
      --network odoo-network \
      --env ODOO_DATABASE_HOST=mariadb_host \
      --env ODOO_DATABASE_PORT_NUMBER=3306 \
      --env ODOO_DATABASE_ADMIN_PASSWORD=odoo_password \
      --volume odoo_data:/bitnami/odoo \
      bitnami/odoo:latest
    ```

In case the database already contains data from a previous Odoo installation, you need to set the variable `ODOO_SKIP_BOOTSTRAP` to `yes`. Otherwise, the container would execute the installation wizard and could modify the existing data in the database. Note that, when setting `ODOO_SKIP_BOOTSTRAP` to `yes`, values for environment variables such as `ODOO_EMAIL` or `ODOO_PASSWORD` will be ignored.

## Logging

The Bitnami Odoo Docker image sends the container logs to `stdout`. To view the logs:

```console
docker logs odoo
```

Or using Docker Compose:

```console
docker-compose logs odoo
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Backing up your container

To backup your data, configuration and logs, follow these simple steps:

#### Step 1: Stop the currently running container

```console
docker stop odoo
```

Or using Docker Compose:

```console
docker-compose stop odoo
```

#### Step 2: Run the backup command

We need to mount two volumes in a container we will use to create the backup: a directory on your host to store the backup in, and the volumes from the container we just stopped so we can access the data.

```console
docker run --rm -v /path/to/odoo-backups:/backups --volumes-from odoo busybox \
  cp -a /bitnami/odoo /backups/latest
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

For the Odoo container:

```diff
 $ docker run -d --name odoo \
   ...
-  --volume /path/to/odoo-persistence:/bitnami/odoo \
+  --volume /path/to/odoo-backups/latest:/bitnami/odoo \
   bitnami/odoo:latest
```

### Upgrade this image

Bitnami provides up-to-date versions of PostgreSQL and Odoo, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the Odoo container. For the PostgreSQL upgrade see: <https://github.com/bitnami/containers/tree/main/bitnami/odoo#user-content-upgrade-this-image>

The `bitnami/odoo:latest` tag always points to the most recent release. To get the most recent release you can simple repull the `latest` tag from the Docker Hub with `docker pull bitnami/odoo:latest`. However it is recommended to use [tagged versions](https://hub.docker.com/r/bitnami/odoo/tags/).

#### Step 1: Get the updated image

```console
docker pull bitnami/odoo:latest
```

#### Step 2: Stop the running container

Stop the currently running container using the command

```console
docker-compose stop odoo
```

#### Step 3: Take a snapshot of the application state

Follow the steps in [Backing up your container](#backing-up-your-container) to take a snapshot of the current application state.

#### Step 4: Remove the currently running container

Remove the currently running container by executing the following command:

```console
docker-compose rm -v odoo
```

#### Step 5: Run the new image

Update the image tag in `docker-compose.yml` and re-create your container with the new image:

```console
docker-compose up -d
```

## Notable Changes

### 12.0.20210615-debian-10-r20, 13.0.20210610-debian-10-r24 and 14.0.20210610-debian-10-r22

* The size of the container image has been decreased.
* The configuration logic is now based on Bash scripts in the *rootfs/* folder.
* It is now possible to use an already populated Odoo database from another installation. In order to do this, use the environment variable `ODOO_SKIP_BOOTSTRAP`, which forces the container not to run the initial Odoo setup wizard.
* Removed port 8071 from list of exposed ports. This port was used by the Odoo XMLRPCS service, but was removed in Odoo 10.
* Added port 8072 to the list of exposed ports. This port is used by the [Odoo Longpolling service](https://www.odoo.com/documentation/14.0/administration/deployment/deploy.html#livechat).
* The `WITHOUT_DEMO` environment variable was deprecated in favor of the boolean `ODOO_LOAD_DEMO_DATA` environment variable.

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
