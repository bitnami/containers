# Bitnami Docker Image for Redmine

## What is Redmine?

> Redmine is a flexible project management web application. Written using the Ruby on Rails framework, it is cross-platform and cross-database.

https://redmine.org/

## TL;DR

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-redmine/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

You can find the default credentials and available configuration options in the [Environment Variables](#environment-variables) section.

## Why use Bitnami Images?

- Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
- With Bitnami images the latest bug fixes and features are available as soon as possible.
- Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
- All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
- All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
- Bitnami container images are released daily with the latest distribution packages available.

> This [CVE scan report](https://quay.io/repository/bitnami/redmine?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

## How to deploy Redmine in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Redmine Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/redmine).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


- [`4`, `4-debian-10`, `4.2.1`, `4.2.1-debian-10-r75`, `latest` (4/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-redmine/blob/4.2.1-debian-10-r75/4/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/redmine GitHub repo](https://github.com/bitnami/bitnami-docker-redmine).

## Get this image

The recommended way to get the Bitnami Redmine Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/redmine).

```console
$ docker pull bitnami/redmine:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/redmine/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/redmine:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/redmine:latest 'https://github.com/bitnami/bitnami-docker-redmine.git#master:4/debian-10'
```

## How to use this image

Redmine requires access to a MySQL, MariaDB or PostgreSQL database to store information. We'll use the [Bitnami Docker Image for MariaDB](https://www.github.com/bitnami/bitnami-docker-mariadb) for the database requirements.

### Run the application using Docker Compose

The main folder of this repository contains a functional [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-redmine/blob/master/docker-compose.yml) file. Run the application using it as shown below:

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-redmine/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

### Using the Docker Command Line

If you want to run the application manually instead of using `docker-compose`, these are the basic steps you need to run:

#### Step 1: Create a network

```console
$ docker network create redmine-network
```

#### Step 2: Create a volume for MariaDB persistence and create a MariaDB container

```console
$ docker volume create --name mariadb_data
$ docker run -d --name mariadb \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env MARIADB_USER=bn_redmine \
  --env MARIADB_PASSWORD=bitnami \
  --env MARIADB_DATABASE=bitnami_redmine \
  --network redmine-network \
  --volume mariadb_data:/bitnami/mariadb \
  bitnami/mariadb:latest
```

#### Step 3: Create volumes for Redmine persistence and launch the container

```console
$ docker volume create --name redmine_data
$ docker run -d --name redmine \
  -p 8080:8080 -p 8443:8443 \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env REDMINE_DATABASE_USER=bn_redmine \
  --env REDMINE_DATABASE_PASSWORD=bitnami \
  --env REDMINE_DATABASE_NAME=bitnami_redmine \
  --network redmine-network \
  --volume redmine_data:/bitnami/redmine \
  bitnami/redmine:latest
```

Access your application at *http://your-ip/*

## Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami/redmine` path. If the mounted directory is empty, it will be initialized on the first run. Additionally you should [mount a volume for persistence of the MariaDB data](https://github.com/bitnami/bitnami-docker-mariadb#persisting-your-database).

The above examples define the Docker volumes named `mariadb_data` and `redmine_data`. The Redmine application state will persist as long as volumes are not removed.

To avoid inadvertent removal of volumes, you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

### Mount host directories as data volumes with Docker Compose

This requires a minor change to the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-redmine/blob/master/docker-compose.yml) file present in this repository:

```diff
   mariadb:
     ...
     volumes:
-      - 'mariadb_data:/bitnami/mariadb'
+      - /path/to/mariadb-persistence:/bitnami/mariadb
   ...
   redmine:
     ...
     volumes:
-      - 'redmine_data:/bitnami/redmine'
+      - /path/to/redmine-persistence:/bitnami/redmine
   ...
-volumes:
-  mariadb_data:
-    driver: local
-  redmine_data:
-    driver: local
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

### Mount host directories as data volumes using the Docker command line

#### Step 1: Create a network (if it does not exist)

```console
$ docker network create redmine-network
```

#### Step 2. Create a MariaDB container with host volume

```console
$ docker run -d --name mariadb \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env MARIADB_USER=bn_redmine \
  --env MARIADB_PASSWORD=bitnami \
  --env MARIADB_DATABASE=bitnami_redmine \
  --network redmine-network \
  --volume /path/to/mariadb-persistence:/bitnami/mariadb \
  bitnami/mariadb:latest
```

#### Step 3. Create the Redmine container with host volumes

```console
$ docker run -d --name redmine \
  -p 8080:8080 -p 8443:8443 \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env REDMINE_DATABASE_USER=bn_redmine \
  --env REDMINE_DATABASE_PASSWORD=bitnami \
  --env REDMINE_DATABASE_NAME=bitnami_redmine \
  --network redmine-network \
  --volume /path/to/redmine-persistence:/bitnami/redmine \
  bitnami/redmine:latest
```

## Configuration

### Environment variables

When you start the Redmine image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line. If you want to add a new environment variable:

- For docker-compose add the variable name and value under the application section in the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-redmine/blob/master/docker-compose.yml) file present in this repository:

    ```yaml
    redmine:
      ...
      environment:
        - REDMINE_PASSWORD=my_password
      ...
    ```

- For manual execution add a `--env` option with each variable and value:

    ```console
    $ docker run -d --name redmine -p 80:8080 -p 443:8443 \
      --env REDMINE_PASSWORD=my_password \
      --network redmine-tier \
      --volume /path/to/redmine-persistence:/bitnami \
      bitnami/redmine:latest
    ```

Available environment variables:

##### User and Site configuration

- `REDMINE_PORT_NUMBER`: Port number in which Redmine will run. Default: **3000**
- `REDMINE_USERNAME`: Redmine application username. Default: **user**
- `REDMINE_PASSWORD`: Redmine application password. Default: **bitnami1**
- `REDMINE_EMAIL`: Redmine application email. Default: **user@example.com**
- `REDMINE_FIRST_NAME`: Redmine user first name. Default: **UserName**
- `REDMINE_LAST_NAME`: Redmine user last name. Default: **LastName**
- `REDMINE_LANGUAGE`: Redmine site default language. Default: **en**
- `REDMINE_LOAD_DEFAULT_DATA`: Whether to load default configuration data for Redmine. Default: **yes**
- `REDMINE_SKIP_BOOTSTRAP`: Whether to perform initial bootstrapping for the application. This is necessary in case you use a database that already has Redmine data. Default: **no**

##### Database connection configuration

- `REDMINE_DATABASE_TYPE`: Database type to be used for the Redmine installation. Allowed values: *mariadb*, *postgresql*. Default: **mariadb**
- `REDMINE_DATABASE_HOST`: Hostname for the MariaDB or MySQL server. Default: **mariadb**
- `REDMINE_DATABASE_PORT_NUMBER`: Port used by the MariaDB or MySQL server. Default: **3306**
- `REDMINE_DATABASE_NAME`: Database name that Redmine will use to connect with the database. Default: **bitnami_redmine**
- `REDMINE_DATABASE_USER`: Database user that Redmine will use to connect with the database. Default: **bn_redmine**
- `REDMINE_DATABASE_PASSWORD`: Database password that Redmine will use to connect with the database. No default.
- `ALLOW_EMPTY_PASSWORD`: It can be used to allow blank passwords. Default: **no**

##### Create a database for Redmine using mysql-client

- `MYSQL_CLIENT_DATABASE_HOST`: Hostname for the MariaDB or MySQL server. Default: **mariadb**
- `MYSQL_CLIENT_DATABASE_PORT_NUMBER`: Port used by the MariaDB or MySQL server. Default: **3306**
- `MYSQL_CLIENT_DATABASE_ROOT_USER`: Database admin user. Default: **root**
- `MYSQL_CLIENT_DATABASE_ROOT_PASSWORD`: Database password for the database admin user. No default.
- `MYSQL_CLIENT_CREATE_DATABASE_NAME`: New database to be created by the mysql client module. No default.
- `MYSQL_CLIENT_CREATE_DATABASE_USER`: New database user to be created by the mysql client module. No default.
- `MYSQL_CLIENT_CREATE_DATABASE_PASSWORD`: Database password for the `MYSQL_CLIENT_CREATE_DATABASE_USER` user. No default.
- `MYSQL_CLIENT_CREATE_DATABASE_CHARACTER_SET`: Character set to use for the new database. No default.
- `MYSQL_CLIENT_CREATE_DATABASE_COLLATE`: Database collation to use for the new database. No default.
- `MYSQL_CLIENT_ENABLE_SSL`: Whether to enable SSL connections for the new database. Default: **no**
- `MYSQL_CLIENT_SSL_CA_FILE`: Path to the SSL CA file for the new database. No default.
- `ALLOW_EMPTY_PASSWORD`: It can be used to allow blank passwords. Default: **no**

##### Create a database for Redmine using postgresql-client

- `POSTGRESQL_CLIENT_DATABASE_HOST`: Hostname for the PostgreSQL server. Default: **postgresql**
- `POSTGRESQL_CLIENT_DATABASE_PORT_NUMBER`: Port used by the PostgreSQL server. Default: **5432**
- `POSTGRESQL_CLIENT_DATABASE_ROOT_USER`: Database admin user. Default: **root**
- `POSTGRESQL_CLIENT_DATABASE_ROOT_PASSWORD`: Database password for the database admin user. No defaults.
- `POSTGRESQL_CLIENT_CREATE_DATABASE_NAME`: New database to be created by the mysql client module. No defaults.
- `POSTGRESQL_CLIENT_CREATE_DATABASE_USER`: New database user to be created by the mysql client module. No defaults.
- `POSTGRESQL_CLIENT_CREATE_DATABASE_PASSWORD`: Database password for the `POSTGRESQL_CLIENT_CREATE_DATABASE_USER` user. No defaults.
- `POSTGRESQL_CLIENT_CREATE_DATABASE_EXTENSIONS`: PostgreSQL extensions to enable in the specified database during the first initialization. No defaults.
- `POSTGRESQL_CLIENT_ENABLE_SSL`: Whether to enable SSL connections for the new database. Default: **no**
- `POSTGRESQL_CLIENT_SSL_CA_FILE`: Path to the SSL CA file for the new database. No defaults
- `ALLOW_EMPTY_PASSWORD`: It can be used to allow blank passwords. Default: **no**

##### SMTP Configuration

To configure Redmine to send email using SMTP you can set the following environment variables:

- `REDMINE_SMTP_HOST`: SMTP host.
- `REDMINE_SMTP_PORT`: SMTP port.
- `REDMINE_SMTP_USER`: SMTP account user.
- `REDMINE_SMTP_PASSWORD`: SMTP account password.
- `REDMINE_SMTP_PROTOCOL`: If specified, SMTP protocol to use. Allowed values: *tls*, *ssl*. No default.
- `REDMINE_SMTP_AUTH`: SMTP authentication method. Allowed values: *login*, *plain*, *cram_md5*. Default: **login**.

#### Examples

##### SMTP configuration using a Gmail account

This would be an example of SMTP configuration using a Gmail account:

- Modify the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-redmine/blob/master/docker-compose.yml) file present in this repository:

    ```yaml
      redmine:
        ...
        environment:
          - REDMINE_DATABASE_USER=bn_redmine
          - REDMINE_DATABASE_NAME=bitnami_redmine
          - ALLOW_EMPTY_PASSWORD=yes
          - REDMINE_SMTP_HOST=smtp.gmail.com
          - REDMINE_SMTP_PORT=587
          - REDMINE_SMTP_USER=your_email@gmail.com
          - REDMINE_SMTP_PASSWORD=your_password
      ...
    ```

- For manual execution:

    ```console
    $ docker run -d --name redmine -p 80:8080 -p 443:8443 \
      --env REDMINE_DATABASE_USER=bn_redmine \
      --env REDMINE_DATABASE_NAME=bitnami_redmine \
      --env REDMINE_SMTP_HOST=smtp.gmail.com \
      --env REDMINE_SMTP_PORT=587 \
      --env REDMINE_SMTP_USER=your_email@gmail.com \
      --env REDMINE_SMTP_PASSWORD=your_password \
      --network redmine-tier \
      --volume /path/to/redmine-persistence:/bitnami \
      bitnami/redmine:latest
    ```

##### Connect Redmine container to an existing database

The Bitnami Redmine container supports connecting the Redmine application to an external database. This would be an example of using an external database for Redmine.

- Modify the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-redmine/blob/master/docker-compose.yml) file present in this repository:

    ```diff
       redmine:
         ...
         environment:
    -      - REDMINE_DATABASE_HOST=mariadb
    +      - REDMINE_DATABASE_HOST=mariadb_host
           - REDMINE_DATABASE_PORT_NUMBER=3306
           - REDMINE_DATABASE_NAME=redmine_db
           - REDMINE_DATABASE_USER=redmine_user
    -      - ALLOW_EMPTY_PASSWORD=yes
    +      - REDMINE_DATABASE_PASSWORD=redmine_password
         ...
    ```

- For manual execution:

    ```console
    $ docker run -d --name redmine\
      -p 8080:8080 -p 8443:8443 \
      --network redmine-network \
      --env REDMINE_DATABASE_HOST=mariadb_host \
      --env REDMINE_DATABASE_PORT_NUMBER=3306 \
      --env REDMINE_DATABASE_NAME=redmine_db \
      --env REDMINE_DATABASE_USER=redmine_user \
      --env REDMINE_DATABASE_PASSWORD=redmine_password \
      --volume redmine_data:/bitnami/redmine \
      bitnami/redmine:latest
    ```

In case the database already contains data from a previous Redmine installation, you need to set the variable `REDMINE_SKIP_BOOTSTRAP` to `yes`. Otherwise, the container would execute the installation wizard and could modify the existing data in the database. Note that, when setting `REDMINE_SKIP_BOOTSTRAP` to `yes`, values for environment variables such as `REDMINE_USERNAME`, `REDMINE_PASSWORD` or `REDMINE_EMAIL` will be ignored.

## Logging

The Bitnami Redmine Docker image sends the container logs to `stdout`. To view the logs:

```console
$ docker logs redmine
```

Or using Docker Compose:

```console
$ docker-compose logs redmine
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Backing up your container

To backup your data, configuration and logs, follow these simple steps:

#### Step 1: Stop the currently running container

```console
$ docker stop redmine
```

Or using Docker Compose:

```console
$ docker-compose stop redmine
```

#### Step 2: Run the backup command

We need to mount two volumes in a container we will use to create the backup: a directory on your host to store the backup in, and the volumes from the container we just stopped so we can access the data.

```console
$ docker run --rm -v /path/to/redmine-backups:/backups --volumes-from redmine busybox \
  cp -a /bitnami/redmine /backups/latest
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

For the Redmine container:

```diff
 $ docker run -d --name redmine \
   ...
-  --volume /path/to/redmine-persistence:/bitnami/redmine \
+  --volume /path/to/redmine-backups/latest:/bitnami/redmine \
   bitnami/redmine:latest
```

### Upgrade this image

Bitnami provides up-to-date versions of MariaDB and Redmine, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the Redmine container. For the MariaDB upgrade see: https://github.com/bitnami/bitnami-docker-mariadb/blob/master/README.md#upgrade-this-image

The `bitnami/redmine:latest` tag always points to the most recent release. To get the most recent release you can simple repull the `latest` tag from the Docker Hub with `docker pull bitnami/redmine:latest`. However it is recommended to use [tagged versions](https://hub.docker.com/r/bitnami/redmine/tags/).

#### Step 1: Get the updated image

```console
$ docker pull bitnami/redmine:latest
```

#### Step 2: Stop the running container

Stop the currently running container using the command

```console
$ docker-compose stop redmine
```

#### Step 3: Take a snapshot of the application state

Follow the steps in [Backing up your container](#backing-up-your-container) to take a snapshot of the current application state.

#### Step 4: Remove the currently running container

Remove the currently running container by executing the following command:

```console
docker-compose rm -v redmine
```

#### Step 5: Run the new image

Update the image tag in `docker-compose.yml` and re-create your container with the new image:

```console
$ docker-compose up -d
```

## Notable Changes

### 4.2.1-debian-10-r70

- The size of the container image has been decreased.
- The configuration logic is now based on Bash scripts in the *rootfs/* folder.
- It is now possible to use an already populated Redmine database from another installation. In order to do this, use the environment variable `REDMINE_SKIP_BOOTSTRAP`, which forces the container not to run the initial Redmine setup wizard.
- The following environment variables have been deprecated. They will continue to work as before, but support for these may be removed in a future update:

  - `REDMINE_DB_POSTGRES`, in favor of `REDMINE_DB_TYPE=postgresql`.
  - `REDMINE_DB_MYSQL`, in favor of `REDMINE_DB_TYPE=mariadb`.
  - `SMTP_AUTH`, in favor of `REDMINE_PROTOCOL=tls`.

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-redmine/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-redmine/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-redmine/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

## License

Copyright (c) 2021 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
