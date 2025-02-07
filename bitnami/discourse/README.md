# Discourse&reg; packaged by Bitnami

## What is Discourse&reg;?

> Discourse is an open source discussion platform with built-in moderation and governance systems that let discussion communities protect themselves from bad actors even without official moderators.

[Overview of Discourse&reg;](http://www.discourse.org/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name discourse bitnami/discourse:latest
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

Looking to use Discourse&reg; in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Only latest stable branch maintained in the free Bitnami catalog

Starting December 10th 2024, only the latest stable branch of any container will receive updates in the free Bitnami catalog. To access up-to-date releases for all upstream-supported branches, consider upgrading to Bitnami Premium. Previous versions already released will not be deleted. They are still available to pull from DockerHub.

Please check the Bitnami Premium page in our partner [Arrow Electronics](https://www.arrow.com/globalecs/na/vendors/bitnami?utm_source=GitHub&utm_medium=containers) for more information.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami Discourse Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/discourse).

```console
docker pull bitnami/discourse:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/discourse/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/discourse:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## How to use this image

Discourse requires access to a PostgreSQL database to store information. We'll use the [Bitnami Docker Image for PostgreSQL](https://github.com/bitnami/containers/tree/main/bitnami/postgresql) for the database requirements.

### Using the Docker Command Line

#### Step 1: Create a network

```console
docker network create discourse-network
```

#### Step 2: Create a volume for PostgreSQL persistence and create a PostgreSQL container

```console
$ docker volume create --name postgresql_data
docker run -d --name postgresql \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env POSTGRESQL_USERNAME=bn_discourse \
  --env POSTGRESQL_PASSWORD=bitnami123 \
  --env POSTGRESQL_DATABASE=bitnami_discourse \
  --network discourse-network \
  --volume postgresql_data:/bitnami/postgresql \
  bitnami/postgresql:latest
```

#### Step 3: Create a volume for Redis persistence and create a Redis container

```console
$ docker volume create --name redis_data
docker run -d --name redis \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --network discourse-network \
  --volume redis_data:/bitnami/redis \
  bitnami/redis:latest
```

#### Step 4: Create volumes for Discourse persistence and launch the container

```console
$ docker volume create --name discourse_data
docker run -d --name discourse \
  -p 8080:8080 -p 8443:8443 \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env DISCOURSE_DATABASE_USER=bn_discourse \
  --env DISCOURSE_DATABASE_PASSWORD=bitnami123 \
  --env DISCOURSE_DATABASE_NAME=bitnami_discourse \
  --env DISCOURSE_HOST=www.example.com \
  --network discourse-network \
  --volume discourse_data:/bitnami/discourse \
  bitnami/discourse:latest
```

#### Step 5: Launch the Sidekiq container

```console
docker run -d --name sidekiq \
  --network discourse-network \
  --volume discourse_data:/bitnami/discourse \
  bitnami/discourse:latest /opt/bitnami/scripts/discourse-sidekiq/run.sh
```

Access your application at `http://your-ip/`

### Run the application using Docker Compose

```console
curl -sSL https://raw.githubusercontent.com/bitnami/containers/main/bitnami/discourse/docker-compose.yml > docker-compose.yml
docker-compose up -d
```

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/discourse).

If you detect any issue in the `docker-compose.yaml` file, feel free to report it or contribute with a fix by following our [Contributing Guidelines](https://github.com/bitnami/containers/blob/main/CONTRIBUTING.md).

### Troubleshooting discourse

If you need to run discourse administrative commands like [Create admin account from console](https://meta.discourse.org/t/create-admin-account-from-console/17274), you can do so by executing a shell inside the container and running with the proper environment variables.

```console
cd /opt/bitnami/discourse
RAILS_ENV=production bundle exec rake admin:create
```

## Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami/discourse` path. If the mounted directory is empty, it will be initialized on the first run. Additionally you should [mount a volume for persistence of the PostgreSQL data](https://github.com/bitnami/containers/tree/main/bitnami/postgresql#persisting-your-database).

The above examples define the Docker volumes named `postgresql_data` and `discourse_data`. The Discourse application state will persist as long as volumes are not removed.

To avoid inadvertent removal of volumes, you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

### Mount host directories as data volumes with Docker Compose

This requires a minor change to the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/discourse/docker-compose.yml) file present in this repository:

```diff
   postgresql:
     ...
     volumes:
-      - 'postgresql_data:/bitnami/postgresql'
+      - /path/to/postgresql-persistence:/bitnami/postgresql
   ...
   redis:
     ...
     volumes:
-      - 'redis_data:/bitnami/redis'
+      - /path/to/redis-persistence:/bitnami/redis
   ...
   discourse:
     ...
     volumes:
-      - 'discourse_data:/bitnami/discourse'
+      - /path/to/discourse-persistence:/bitnami/discourse
   ...
   sidekiq:
     ...
     volumes:
-      - 'discourse_data:/bitnami/discourse'
+      - /path/to/discourse-persistence:/bitnami/discourse
   ...
-volumes:
-  postgresql_data:
-    driver: local
-  redis_data:
-    driver: local
-  discourse_data:
-    driver: local
```

### Mount host directories as data volumes using the Docker command line

#### Step 1: Create a network (if it does not exist)

```console
docker network create discourse-network
```

#### Step 2. Create a PostgreSQL container with host volume

```console
docker run -d --name postgresql \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env POSTGRESQL_USERNAME=bn_discourse \
  --env POSTGRESQL_PASSWORD=bitnami123 \
  --env POSTGRESQL_DATABASE=bitnami_discourse \
  --network discourse-network \
  --volume /path/to/postgresql-persistence:/bitnami/postgresql \
  bitnami/postgresql:latest
```

#### Step 3. Create a Redis container with host volume

```console
docker run -d --name redis \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --network discourse-network \
  --volume /path/to/redis-persistence:/bitnami/redis \
  bitnami/redis:latest
```

#### Step 4. Create the Discourse container with host volumes

```console
docker run -d --name discourse \
  -p 8080:8080 -p 8443:8443 \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env DISCOURSE_DATABASE_USER=bn_discourse \
  --env DISCOURSE_DATABASE_PASSWORD=bitnami123 \
  --env DISCOURSE_DATABASE_NAME=bitnami_discourse \
  --env DISCOURSE_HOST=www.example.com \
  --network discourse-network \
  --volume /path/to/discourse-persistence:/bitnami/discourse \
  bitnami/discourse:latest
```

#### Step 5. Create the Sidekiq container with host volumes

```console
docker run -d --name sidekiq \
  --network discourse-network \
  --volume /path/to/discourse-persistence:/bitnami/discourse \
  bitnami/discourse:latest
```

## Configuration

### Configuration files

You can mount your configuration files to the `/opt/bitnami/discourse/mounted-conf` directory. Make sure that your configuration files follow the standardized names used by Discourse. Some of the most common files include:

* `discourse.conf`
* `database.yml`
* `site_settings.yml`

The set of default standard configuration files may be found [here](https://github.com/discourse/discourse/tree/master/config). You may refer to the the Discourse [webpage](https://www.discourse.org/) for further details and specific configuration guides.

### Environment variables

#### Customizable environment variables

| Name                                   | Description                                                                                                                     | Default Value                           |
|----------------------------------------|---------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------|
| `DISCOURSE_DATA_TO_PERSIST`            | Files to persist relative to the Discourse installation directory. To provide multiple values, separate them with a whitespace. | `plugins public/backups public/uploads` |
| `DISCOURSE_ENABLE_HTTPS`               | Whether to enable HTTPS for Discourse by default.                                                                               | `no`                                    |
| `DISCOURSE_EXTERNAL_HTTP_PORT_NUMBER`  | External HTTP port for Discourse.                                                                                               | `80`                                    |
| `DISCOURSE_EXTERNAL_HTTPS_PORT_NUMBER` | External HTTPS port for Discourse.                                                                                              | `443`                                   |
| `DISCOURSE_HOST`                       | Discourse host name.                                                                                                            | `www.example.com`                       |
| `DISCOURSE_PORT_NUMBER`                | Port number in which Discourse will run.                                                                                        | `3000`                                  |
| `DISCOURSE_SKIP_BOOTSTRAP`             | Whether to perform initial bootstrapping for the application.                                                                   | `nil`                                   |
| `DISCOURSE_SITE_NAME`                  | Discourse site name.                                                                                                            | `My site!`                              |
| `DISCOURSE_ENV`                        | Discourse environment mode. Allowed values: *development*, *production*, *test*.                                                | `production`                            |
| `DISCOURSE_PRECOMPILE_ASSETS`          | Whether to precompile assets during the initialization. Required when installing plugins.                                       | `yes`                                   |
| `DISCOURSE_ENABLE_CONF_PERSISTENCE`    | Whether to enable persistence of the Discourse `discourse.conf` configuration file.                                             | `no`                                    |
| `DISCOURSE_EXTRA_CONF_CONTENT`         | Extra configuration to append to the `discourse.conf` configuration file.                                                       | `yes`                                   |
| `DISCOURSE_PASSENGER_SPAWN_METHOD`     | Passenger method used for spawning application processes. Valid values: direct, smart.                                          | `direct`                                |
| `DISCOURSE_PASSENGER_EXTRA_FLAGS`      | Extra flags to pass to the Passenger start command.                                                                             | `nil`                                   |
| `DISCOURSE_USERNAME`                   | Discourse user name.                                                                                                            | `user`                                  |
| `DISCOURSE_PASSWORD`                   | Discourse user password.                                                                                                        | `bitnami123`                            |
| `DISCOURSE_EMAIL`                      | Discourse user e-mail address.                                                                                                  | `user@example.com`                      |
| `DISCOURSE_FIRST_NAME`                 | Discourse user first name.                                                                                                      | `UserName`                              |
| `DISCOURSE_LAST_NAME`                  | Discourse user last name.                                                                                                       | `LastName`                              |
| `DISCOURSE_SMTP_HOST`                  | Discourse SMTP server host.                                                                                                     | `nil`                                   |
| `DISCOURSE_SMTP_PORT_NUMBER`           | Discourse SMTP server port number.                                                                                              | `nil`                                   |
| `DISCOURSE_SMTP_USER`                  | Discourse SMTP server user.                                                                                                     | `nil`                                   |
| `DISCOURSE_SMTP_PASSWORD`              | Discourse SMTP server user password.                                                                                            | `nil`                                   |
| `DISCOURSE_SMTP_PROTOCOL`              | Discourse SMTP server protocol to use.                                                                                          | `nil`                                   |
| `DISCOURSE_SMTP_AUTH`                  | Discourse SMTP authentication method. Allowed values: *login*, *plain*, *cram_md5*.                                             | `login`                                 |
| `DISCOURSE_SMTP_OPEN_TIMEOUT`          | Discourse `smtp_open_timeout` configuration override.                                                                           | `nil`                                   |
| `DISCOURSE_SMTP_READ_TIMEOUT`          | Discourse `smtp_read_timeout` configuration override.                                                                           | `nil`                                   |
| `DISCOURSE_DATABASE_HOST`              | Database server host.                                                                                                           | `$DISCOURSE_DEFAULT_DATABASE_HOST`      |
| `DISCOURSE_DATABASE_PORT_NUMBER`       | Database server port.                                                                                                           | `5432`                                  |
| `DISCOURSE_DATABASE_NAME`              | Database name.                                                                                                                  | `bitnami_discourse`                     |
| `DISCOURSE_DATABASE_USER`              | Database user name.                                                                                                             | `bn_discourse`                          |
| `DISCOURSE_DATABASE_PASSWORD`          | Database user password.                                                                                                         | `nil`                                   |
| `DISCOURSE_DB_BACKUP_HOST`             | Database backup server host.                                                                                                    | `$DISCOURSE_DATABASE_HOST`              |
| `DISCOURSE_DB_BACKUP_PORT`             | Database backup server port.                                                                                                    | `$DISCOURSE_DATABASE_PORT_NUMBER`       |
| `DISCOURSE_REDIS_HOST`                 | Redis(R) server host.                                                                                                           | `$DISCOURSE_DEFAULT_REDIS_HOST`         |
| `DISCOURSE_REDIS_PORT_NUMBER`          | Redis(R) server port.                                                                                                           | `6379`                                  |
| `DISCOURSE_REDIS_PASSWORD`             | Redis(R) user password.                                                                                                         | `nil`                                   |
| `DISCOURSE_REDIS_USE_SSL`              | Whether to enable SSL for Redis(R).                                                                                             | `no`                                    |
| `DISCOURSE_REDIS_DB`                   | Redis(R) database number.                                                                                                       | `0`                                     |

#### Read-only environment variables

| Name                              | Description                                          | Value                                         |
|-----------------------------------|------------------------------------------------------|-----------------------------------------------|
| `DISCOURSE_BASE_DIR`              | Discourse installation directory.                    | `${BITNAMI_ROOT_DIR}/discourse`               |
| `DISCOURSE_CONF_FILE`             | Configuration file for Discourse.                    | `${DISCOURSE_BASE_DIR}/config/discourse.conf` |
| `YARN_CACHE_FOLDER`               | Yarn cache folder                                    | `${DISCOURSE_BASE_DIR}/tmp/cache`             |
| `DISCOURSE_VOLUME_DIR`            | Discourse directory for mounted configuration files. | `${BITNAMI_VOLUME_DIR}/discourse`             |
| `DISCOURSE_DAEMON_USER`           | Discourse system user.                               | `discourse`                                   |
| `DISCOURSE_DAEMON_GROUP`          | Discourse system group.                              | `discourse`                                   |
| `DISCOURSE_DEFAULT_DATABASE_HOST` | Default database server host.                        | `postgresql`                                  |
| `DISCOURSE_DEFAULT_REDIS_HOST`    | Default Redis(R) server host.                        | `redis`                                       |

When you start the Discourse image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line. If you want to add a new environment variable:

* For docker-compose add the variable name and value under the application section in the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/discourse/docker-compose.yml) file present in this repository:

    ```yaml
    discourse:
      ...
      environment:
        - DISCOURSE_PASSWORD=my_password
      ...
    ```

* For manual execution add a `--env` option with each variable and value:

    ```console
    $ docker run -d --name discourse -p 80:8080 -p 443:8443 \
      --env DISCOURSE_PASSWORD=my_password \
      --network discourse-tier \
      --volume /path/to/discourse-persistence:/bitnami \
      bitnami/discourse:latest
    ```

#### Examples

##### SMTP configuration using a Gmail account

This would be an example of SMTP configuration using a Gmail account:

* Modify the environment variables used for the `discourse` and `sidekiq` containers in the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/discourse/docker-compose.yml) file present in this repository:

    ```yaml
      discourse:
        ...
        environment:
          ...
          - DISCOURSE_SMTP_HOST=smtp.gmail.com
          - DISCOURSE_SMTP_PORT=587
          - DISCOURSE_SMTP_USER=your_email@gmail.com
          - DISCOURSE_SMTP_PASSWORD=your_password
          - DISCOURSE_SMTP_PROTOCOL=tls
      ...
      sidekiq:
        ...
        environment:
          ...
          - DISCOURSE_SMTP_HOST=smtp.gmail.com
          - DISCOURSE_SMTP_PORT=587
          - DISCOURSE_SMTP_USER=your_email@gmail.com
          - DISCOURSE_SMTP_PASSWORD=your_password
          - DISCOURSE_SMTP_PROTOCOL=tls
      ...
    ```

* For manual execution:

  * First, create the Discourse container:

    ```console
    $ docker run -d --name discourse -p 80:8080 -p 443:8443 \
      --env DISCOURSE_DATABASE_USER=bn_discourse \
      --env DISCOURSE_DATABASE_NAME=bitnami_discourse \
      --env DISCOURSE_SMTP_HOST=smtp.gmail.com \
      --env DISCOURSE_SMTP_PORT=587 \
      --env DISCOURSE_SMTP_USER=your_email@gmail.com \
      --env DISCOURSE_SMTP_PASSWORD=your_password \
      --env DISCOURSE_SMTP_PROTOCOL=tls \
      --network discourse-tier \
      --volume /path/to/discourse-persistence:/bitnami \
      bitnami/discourse:latest
    ```

  * Then, create the Sidekiq container:

    ```console
    $ docker run -d --name sidekiq \
      --env DISCOURSE_DATABASE_USER=bn_discourse \
      --env DISCOURSE_DATABASE_NAME=bitnami_discourse \
      --env DISCOURSE_SMTP_HOST=smtp.gmail.com \
      --env DISCOURSE_SMTP_PORT=587 \
      --env DISCOURSE_SMTP_USER=your_email@gmail.com \
      --env DISCOURSE_SMTP_PASSWORD=your_password \
      --env DISCOURSE_SMTP_PROTOCOL=tls \
      --network discourse-tier \
      --volume /path/to/discourse-persistence:/bitnami \
      bitnami/discourse:latest
    ```

In order to verify your configuration works properly, you can test your configuration parameters from the container itself.

```console
docker run -u root -it bitnami/discourse:latest bash
install_packages swaks
swaks --to your_email@domain.com --from your_email@domain.com --server your.smtp.server.com --auth LOGIN --auth-user your_email@domain.com -tls
```

See the [documentation on troubleshooting SMTP issues](https://docs.bitnami.com/general/how-to/troubleshoot-smtp-issues/) if there are problems.

##### Connect Discourse container to an existing database

The Bitnami Discourse container supports connecting the Discourse application to an external database. This would be an example of using an external database for Discourse.

* Modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/discourse/docker-compose.yml) file present in this repository:

    ```diff
       discourse:
         ...
         environment:
    -      - DISCOURSE_DATABASE_HOST=mariadb
    +      - DISCOURSE_DATABASE_HOST=mariadb_host
           - DISCOURSE_DATABASE_PORT_NUMBER=3306
           - DISCOURSE_DATABASE_NAME=discourse_db
           - DISCOURSE_DATABASE_USER=discourse_user
    -      - ALLOW_EMPTY_PASSWORD=yes
    +      - DISCOURSE_DATABASE_PASSWORD=discourse_password
         ...
    ```

* For manual execution:

    ```console
    $ docker run -d --name discourse\
      -p 8080:8080 -p 8443:8443 \
      --network discourse-network \
      --env DISCOURSE_DATABASE_HOST=mariadb_host \
      --env DISCOURSE_DATABASE_PORT_NUMBER=3306 \
      --env DISCOURSE_DATABASE_NAME=discourse_db \
      --env DISCOURSE_DATABASE_USER=discourse_user \
      --env DISCOURSE_DATABASE_PASSWORD=discourse_password \
      --volume discourse_data:/bitnami/discourse \
      bitnami/discourse:latest
    ```

In case the database already contains data from a previous Discourse installation, you need to set the variable `DISCOURSE_SKIP_BOOTSTRAP` to `yes`. Otherwise, the container would execute the installation wizard and could modify the existing data in the database. Note that, when setting `DISCOURSE_SKIP_BOOTSTRAP` to `yes`, values for environment variables such as `DISCOURSE_USERNAME`, `DISCOURSE_PASSWORD` or `DISCOURSE_EMAIL` will be ignored.

## Logging

The Bitnami Discourse Docker image sends the container logs to `stdout`. To view the logs:

```console
docker logs discourse
```

Or using Docker Compose:

```console
docker-compose logs discourse
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Backing up your container

To backup your data, configuration and logs, follow these simple steps:

#### Step 1: Stop the currently running container

```console
docker stop discourse
```

Or using Docker Compose:

```console
docker-compose stop discourse
```

#### Step 2: Run the backup command

We need to mount two volumes in a container we will use to create the backup: a directory on your host to store the backup in, and the volumes from the container we just stopped so we can access the data.

```console
docker run --rm -v /path/to/discourse-backups:/backups --volumes-from discourse busybox \
  cp -a /bitnami/discourse /backups/latest
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

For the Discourse container:

```diff
 $ docker run -d --name discourse \
   ...
-  --volume /path/to/discourse-persistence:/bitnami/discourse \
+  --volume /path/to/discourse-backups/latest:/bitnami/discourse \
   bitnami/discourse:latest
```

### Upgrade this image

Bitnami provides up-to-date versions of PostgreSQL and Discourse, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the Discourse container. For the PostgreSQL upgrade see: <https://github.com/bitnami/containers/blob/main/bitnami/postgresql/README.md#user-content-upgrade-this-image>

The `bitnami/discourse:latest` tag always points to the most recent release. To get the most recent release you can simple repull the `latest` tag from the Docker Hub with `docker pull bitnami/discourse:latest`. However it is recommended to use [tagged versions](https://hub.docker.com/r/bitnami/discourse/tags/).

#### Step 1: Get the updated image

```console
docker pull bitnami/discourse:latest
```

#### Step 2: Stop the running container

Stop the currently running container using the command

```console
docker-compose stop discourse
```

#### Step 3: Take a snapshot of the application state

Follow the steps in [Backing up your container](#backing-up-your-container) to take a snapshot of the current application state.

#### Step 4: Remove the currently running container

Remove the currently running container by executing the following command:

```console
docker-compose rm -v discourse
```

#### Step 5: Run the new image

Update the image tag in `docker-compose.yml` and re-create your container with the new image:

```console
docker-compose up -d
```

## Notable Changes

### 2.7.0-debian-10-r4

* The size of the container image has been decreased.
* The configuration logic is now based on Bash scripts in the *rootfs/* folder.

### 2.4.4-debian-10-r8 release

* Discourse and Sidekiq now make use of the same volume to persist data. This solves issues related to being unable to locate some files generated on-demand by the Sidekiq job scheduler.

### 2.3.2-debian-9-r48 and 2.3.2-ol-7-r47

* The Discourse container now uses Passenger's ['direct' process spawning method](https://www.phusionpassenger.com/docs/advanced_guides/in_depth/ruby/spawn_methods.html) (instead of the default 'smart'), which fixes a bug where settings would randomly revert back to the original values. This setting may cause an increase in memory usage. It is possible to configure the spawning method by setting the `DISCOURSE_PASSENGER_SPAWN_METHOD` environment variable.

### 2.2.5-debian-9-r9 and 2.2.5-ol-7-r8

* It is now possible to import existing Discourse databases from other installations. In order to do this, use the environment variable `DISCOURSE_SKIP_INSTALL`, which forces the container not to run the initial Discourse setup wizard.

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
