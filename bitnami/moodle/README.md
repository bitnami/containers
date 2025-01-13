# Bitnami LMS powered by Moodle&trade; LMS

## What is Bitnami LMS powered by Moodle&trade; LMS?

> Moodle&trade; LMS is an open source online Learning Management System widely used at universities, schools, and corporations. It is modular and highly adaptable to any type of online learning.

[Overview of Bitnami LMS powered by Moodle&trade; LMS](http://moodle.org/)
Disclaimer: The respective trademarks mentioned in the offering are owned by the respective companies. We do not provide commercial license of any of these products. This listing has an open source license. Moodle(TM) LMS is run and maintained by Moodle HQ, that is a completely and separate project from Bitnami.

## TL;DR

```console
docker run --name moodle bitnami/moodle:latest
```

**Warning**: This quick setup is only intended for development environments. You are encouraged to change the insecure default credentials and check out the available configuration options in the [Environment Variables](#environment-variables) section for a more secure deployment.

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use Bitnami LMS powered by Moodle&trade; LMS in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## How to deploy Moodle&trade; in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Chart for Moodle&trade; GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/moodle).

Bitnami containers can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Only latest stable branch maintained in the free Bitnami catalog

Starting December 10th 2024, only the latest stable branch of any container will receive updates in the free Bitnami catalog. To access up-to-date releases for all upstream-supported branches, consider upgrading to Bitnami Premium. Previous versions already released will not be deleted. They are still available to pull from DockerHub.

Please check the Bitnami Premium page in our partner [Arrow Electronics](https://www.arrow.com/globalecs/na/vendors/bitnami?utm_source=GitHub&utm_medium=containers) for more information.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami Docker Image for Moodle&trade; is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/moodle).

```console
docker pull bitnami/moodle:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/moodle/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/moodle:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## How to use this image

Moodle&trade; requires access to a MySQL or MariaDB database to store information. We'll use the [Bitnami Docker Image for MariaDB](https://github.com/bitnami/containers/tree/main/bitnami/mariadb) for the database requirements.

### Using the Docker Command Line

#### Step 1: Create a network

```console
docker network create moodle-network
```

#### Step 2: Create a volume for MariaDB persistence and create a MariaDB container

```console
$ docker volume create --name mariadb_data
docker run -d --name mariadb \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env MARIADB_USER=bn_moodle \
  --env MARIADB_PASSWORD=bitnami \
  --env MARIADB_DATABASE=bitnami_moodle \
  --network moodle-network \
  --volume mariadb_data:/bitnami/mariadb \
  bitnami/mariadb:latest
```

#### Step 3: Create volumes for Moodle&trade; persistence and launch the container

```console
$ docker volume create --name moodle_data
docker run -d --name moodle \
  -p 8080:8080 -p 8443:8443 \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env MOODLE_DATABASE_USER=bn_moodle \
  --env MOODLE_DATABASE_PASSWORD=bitnami \
  --env MOODLE_DATABASE_NAME=bitnami_moodle \
  --network moodle-network \
  --volume moodle_data:/bitnami/moodle \
  --volume moodledata_data:/bitnami/moodledata \
  bitnami/moodle:latest
```

Access your application at `http://your-ip/`

### Run the application using Docker Compose

```console
curl -sSL https://raw.githubusercontent.com/bitnami/containers/main/bitnami/moodle/docker-compose.yml > docker-compose.yml
docker-compose up -d
```

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/moodle).

If you detect any issue in the `docker-compose.yaml` file, feel free to report it or contribute with a fix by following our [Contributing Guidelines](https://github.com/bitnami/containers/blob/main/CONTRIBUTING.md).

## Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami/moodle` path and another at `/bitnami/moodledata`. If the mounted directory is empty, it will be initialized on the first run. Additionally you should mount a volume for persistence of the [MariaDB data](https://github.com/bitnami/containers/blob/main/bitnami/mariadb#persisting-your-database).

The above examples define the Docker volumes named mariadb_data, moodle_data and moodledata_data. The Moodle&trade; application state will persist as long as volumes are not removed.

To avoid inadvertent removal of volumes, you can mount host directories as data volumes. Alternatively you can make use of volume plugins to host the volume data.

### Mount host directories as data volumes with Docker Compose

This requires a minor change to the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/moodle/docker-compose.yml) file present in this repository:

```diff
   mariadb:
     ...
     volumes:
-      - 'mariadb_data:/bitnami/mariadb'
+      - /path/to/mariadb-persistence:/bitnami/mariadb
   ...
   moodle:
     ...
     volumes:
-      - 'moodle_data:/bitnami/moodle'
+      - /path/to/moodle-persistence:/bitnami/moodle
-      - 'moodledata_data:/bitnami/moodledata'
+      - /path/to/moodledata-persistence:/bitnami/moodle
   ...
-volumes:
-  mariadb_data:
-    driver: local
-  moodle_data:
-    driver: local
```

### Mount host directories as data volumes using the Docker command line

#### Step 1: Create a network (if it does not exist)

```console
docker network create moodle-network
```

#### Step 2. Create a MariaDB container with host volume

```console
docker run -d --name mariadb \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env MARIADB_USER=bn_moodle \
  --env MARIADB_PASSWORD=bitnami \
  --env MARIADB_DATABASE=bitnami_moodle \
  --network moodle-network \
  --volume /path/to/mariadb-persistence:/bitnami/mariadb \
  bitnami/mariadb:latest
```

#### Step 3. Create the Moodle&trade; container with host volumes

```console
docker run -d --name moodle \
  -p 8080:8080 -p 8443:8443 \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env MOODLE_DATABASE_USER=bn_moodle \
  --env MOODLE_DATABASE_PASSWORD=bitnami \
  --env MOODLE_DATABASE_NAME=bitnami_moodle \
  --network moodle-network \
  --volume /path/to/moodle-persistence:/bitnami/moodle \
  --volume /path/to/moodledata-persistence:/bitnami/moodledata \
  bitnami/moodle:latest
```

## Configuration

### Environment variables

#### Customizable environment variables

| Name                          | Description                                                                                                                  | Default Value                      |
|-------------------------------|------------------------------------------------------------------------------------------------------------------------------|------------------------------------|
| `MOODLE_DATA_DIR`             | Directory where to store Moodle data files.                                                                                  | `${BITNAMI_VOLUME_DIR}/moodledata` |
| `MOODLE_DATA_TO_PERSIST`      | Files to persist relative to the Moodle installation directory. To provide multiple values, separate them with a whitespace. | `$MOODLE_BASE_DIR`                 |
| `MOODLE_SKIP_BOOTSTRAP`       | Whether to perform initial bootstrapping for the application.                                                                | `nil`                              |
| `MOODLE_INSTALL_EXTRA_ARGS`   | Extra arguments to pass to the Moodle install.php script.                                                                    | `nil`                              |
| `MOODLE_SITE_NAME`            | Moodle site name.                                                                                                            | `New Site`                         |
| `MOODLE_HOST`                 | Moodle www root.                                                                                                             | `nil`                              |
| `MOODLE_CRON_MINUTES`         | Moodle cron frequency in minutes.                                                                                            | `1`                                |
| `MOODLE_REVERSEPROXY`         | Activate the reverseproxy feature of Moodle.                                                                                 | `no`                               |
| `MOODLE_SSLPROXY`             | Activate the sslproxy feature of Moodle.                                                                                     | `no`                               |
| `MOODLE_LANG`                 | Allow to define default site language                                                                                        | `en`                               |
| `MOODLE_USERNAME`             | Moodle user name.                                                                                                            | `user`                             |
| `MOODLE_PASSWORD`             | Moodle user password.                                                                                                        | `bitnami`                          |
| `MOODLE_DATABASE_MIN_VERSION` | Change database minimum version because of an issue with Azure Database for MariaDB.                                         | `nil`                              |
| `MOODLE_EMAIL`                | Moodle user e-mail address.                                                                                                  | `user@example.com`                 |
| `MOODLE_SMTP_HOST`            | Moodle SMTP server host.                                                                                                     | `nil`                              |
| `MOODLE_SMTP_PORT_NUMBER`     | Moodle SMTP server port number.                                                                                              | `nil`                              |
| `MOODLE_SMTP_USER`            | Moodle SMTP server user.                                                                                                     | `nil`                              |
| `MOODLE_SMTP_PASSWORD`        | Moodle SMTP server user password.                                                                                            | `nil`                              |
| `MOODLE_SMTP_PROTOCOL`        | Moodle SMTP server protocol.                                                                                                 | `nil`                              |
| `MOODLE_DATABASE_TYPE`        | Database type to be used for the Moodle installation.                                                                        | `mariadb`                          |
| `MOODLE_DATABASE_HOST`        | Database server host.                                                                                                        | `mariadb`                          |
| `MOODLE_DATABASE_PORT_NUMBER` | Database server port.                                                                                                        | `3306`                             |
| `MOODLE_DATABASE_NAME`        | Database name.                                                                                                               | `bitnami_moodle`                   |
| `MOODLE_DATABASE_USER`        | Database user name.                                                                                                          | `bn_moodle`                        |
| `MOODLE_DATABASE_PASSWORD`    | Database user password.                                                                                                      | `nil`                              |

#### Read-only environment variables

| Name                         | Description                                                | Value                           |
|------------------------------|------------------------------------------------------------|---------------------------------|
| `MOODLE_BASE_DIR`            | Moodle installation directory.                             | `${BITNAMI_ROOT_DIR}/moodle`    |
| `MOODLE_CONF_FILE`           | Configuration file for Moodle.                             | `${MOODLE_BASE_DIR}/config.php` |
| `MOODLE_VOLUME_DIR`          | Persisted directory for Moodle files.                      | `${BITNAMI_VOLUME_DIR}/moodle`  |
| `PHP_DEFAULT_MEMORY_LIMIT`   | Default PHP memory limit.                                  | `256M`                          |
| `PHP_DEFAULT_MAX_INPUT_VARS` | Default maximum amount of input variables for PHP scripts. | `5000`                          |

When you start the Moodle&trade; image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line. If you want to add a new environment variable:

* For docker-compose add the variable name and value under the application section in the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/moodle/docker-compose.yml) file present in this repository:

```yaml
moodle:
  ...
  environment:
    - MOODLE_PASSWORD=my_password
  ...
```

* For manual execution add a `--env` option with each variable and value:

  ```console
  docker run -d --name moodle -p 80:8080 -p 443:8443 \
    --env MOODLE_PASSWORD=my_password \
    --network moodle-tier \
    --volume /path/to/moodle-persistence:/bitnami/moodle \
    --volume /path/to/moodledata-persistence:/bitnami/moodledata \
    bitnami/moodle:latest
  ```

### Examples

This would be an example of SMTP configuration using a Gmail account:

* Modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/moodle/docker-compose.yml) file present in this repository:

  ```yaml
  moodle:
    ...
    environment:
      - MOODLE_DATABASE_USER=bn_moodle
      - MOODLE_DATABASE_NAME=bitnami_moodle
      - ALLOW_EMPTY_PASSWORD=yes
      - MOODLE_SMTP_HOST=smtp.gmail.com
      - MOODLE_SMTP_PORT=587
      - MOODLE_SMTP_USER=your_email@gmail.com
      - MOODLE_SMTP_PASSWORD=your_password
      - MOODLE_SMTP_PROTOCOL=tls
  ...
  ```

* For manual execution:

  ```console
  docker run -d --name moodle -p 80:8080 -p 443:8443 \
    --env MOODLE_DATABASE_USER=bn_moodle \
    --env MOODLE_DATABASE_NAME=bitnami_moodle \
    --env MOODLE_SMTP_HOST=smtp.gmail.com \
    --env MOODLE_SMTP_PORT=587 \
    --env MOODLE_SMTP_USER=your_email@gmail.com \
    --env MOODLE_SMTP_PASSWORD=your_password \
    --env MOODLE_SMTP_PROTOCOL=tls \
    --network moodle-tier \
    --volume /path/to/moodle-persistence:/bitnami/moodle \
    --volume /path/to/moodledata-persistence:/bitnami/moodledata \
    bitnami/moodle:latest
  ```

This would be an instance ready to be put behind the NGINX load balancer.

* Modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/moodle/docker-compose.yml) file present in this repository:

  ```yaml
  moodle:
    ...
    environment:
      - MOODLE_HOST=example.com
      - MOODLE_REVERSEPROXY=true
      - MOODLE_SSLPROXY=true
  ...
  ```

* For manual execution:

  ```console
  docker run -d --name moodle -p 80:8080 -p 443:8443 \
    --env MOODLE_HOST=example.com \
    --env MOODLE_REVERSEPROXY=true \
    --env MOODLE_SSLPROXY=true \
    --network moodle-tier \
    --volume /path/to/moodle-persistence:/bitnami/moodle \
    --volume /path/to/moodledata-persistence:/bitnami/moodledata \
    bitnami/moodle:latest
  ```

### Installing additional language packs

By default, this container packs a generic English version of Moodle&trade;. Nevertheless, more Language Packs can be added to the default configuration using the in-platform Administration [interface](https://docs.moodle.org/38/en/Language_packs#Language_pack_installation_and_uninstallation). In order to fully support a new Language Pack it is also a requirement to update the system's locales files. To do that, you have several options:

#### Build the default image with the `EXTRA_LOCALES` build-time variable

You can add extra locales using the `EXTRA_LOCALES` build-time variable when building the Docker image. The values must be separated by commas or semicolons (and optional spaces), and refer to entries in the `/usr/share/i18n/SUPPORTED` file inside the container.

For example, the following value would add French, German, Italian and Spanish, you would specify the following value in `EXTRA_LOCALES`:

```text
fr_FR.UTF-8 UTF-8, de_DE.UTF-8 UTF-8, it_IT.UTF-8 UTF-8, es_ES.UTF-8 UTF-8
```

> NOTE: The locales `en_AU.UTF-8 UTF-8` and `en_US.UTF-8 UTF-8` will always be packaged, defaulting to `en_US.UTF-8 UTF-8`.

To use `EXTRA_LOCALES`, you have two options:

* Modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/moodle/docker-compose.yml) file present in this repository:

  ```yaml
  moodle:
  ...
    # image: 'bitnami/moodle:latest' # remove this line !
    build:
      context: .
      dockerfile: Dockerfile
      args:
        - EXTRA_LOCALES=fr_FR.UTF-8 UTF-8, de_DE.UTF-8 UTF-8, it_IT.UTF-8 UTF-8, es_ES.UTF-8 UTF-8
  ...
  ```

* For manual execution, clone the repository and run the following command inside the `X/debian-12` directory:

  ```console
  docker build -t bitnami/moodle:latest --build-arg EXTRA_LOCALES="fr_FR.UTF-8 UTF-8, de_DE.UTF-8 UTF-8, it_IT.UTF-8 UTF-8, es_ES.UTF-8 UTF-8" .
  ```

#### Enable all supported locales using the `WITH_ALL_LOCALES` build-time variable

You can generate all supported locales by setting the build environment variable `WITH_ALL_LOCALES=yes`. Note that the generation of all the locales takes some time.

To use `WITH_ALL_LOCALES`, you have two options:

* Modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/moodle/docker-compose.yml) file present in this repository:

  ```yaml
  moodle:
  ...
    # image: 'bitnami/moodle:latest' # remove this line !
    build:
      context: .
      dockerfile: Dockerfile
      args:
        - WITH_ALL_LOCALES=yes
  ...
  ```

* For manual execution, clone the repository and run the following command inside the `X/debian-12` directory:

  ```console
  docker build -t bitnami/moodle:latest --build-arg WITH_ALL_LOCALES=yes .
  ```

#### Extending the default image

Finally, you can [extend](https://github.com/bitnami/containers/blob/main/bitnami/moodle#extend-this-image) the default image and adding as many locales as needed:

```Dockerfile
FROM bitnami/moodle
RUN echo "es_ES.UTF-8 UTF-8" >> /etc/locale.gen && locale-gen
```

Bear in mind that in the example above `es_ES.UTF-8 UTF-8` is the locale needed for the desired Language Pack to install. You may change this value to the locale corresponding to your pack.

## Logging

The Bitnami Docker image for Moodle&trade; sends the container logs to `stdout`. To view the logs:

```console
docker logs moodle
```

Or using Docker Compose:

```console
docker-compose logs moodle
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

By default, the logging of debug information is disabled. You can enable it by setting the environment variable `BITNAMI_DEBUG` to `true`.

## Maintenance

### Backing up your container

To backup your data, configuration and logs, follow these simple steps:

#### Step 1: Stop the currently running container

```console
docker stop moodle
```

Or using Docker Compose:

```console
docker-compose stop moodle
```

#### Step 2: Run the backup command

We need to mount two volumes in a container we will use to create the backup: a directory on your host to store the backup in, and the volumes from the container we just stopped so we can access the data.

```console
docker run --rm -v /path/to/moodle-backups:/backups --volumes-from moodle busybox \
  cp -a /bitnami/moodle /backups/latest
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

For the Moodle&trade; container:

```diff
 $ docker run -d --name moodle \
   ...
-  --volume /path/to/moodle-persistence:/bitnami/moodle \
+  --volume /path/to/moodle-backups/latest/moodle:/bitnami/moodle \
-  --volume /path/to/moodledata-persistence:/bitnami/moodledata \
+  --volume /path/to/moodledata-backups/latest/moodledata:/bitnami/moodledata \
   bitnami/moodle:latest
```

### Upgrade this image

> **NOTE:** Since Moodle(TM) 3.4.0-r1, the application upgrades should be done manually inside the docker container following the [official documentation](https://docs.moodle.org/37/en/Upgrading).
> As an alternative, you can try upgrading using an updated Docker image. However, any data from the Moodle(TM) container will be lost and you will have to reinstall all the plugins and themes you manually added.

Bitnami provides up-to-date versions of MariaDB and Moodle&trade;, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the Moodle&trade; container. For the MariaDB upgrade see: <https://github.com/bitnami/containers/tree/main/bitnami/mariadb#upgrade-this-image>

#### Step 1: Get the updated image

```console
docker pull bitnami/moodle:latest
```

#### Step 2: Stop the running container

Stop the currently running container using the command

```console
docker-compose stop moodle
```

#### Step 3: Take a snapshot of the application state

Follow the steps in [Backing up your container](#backing-up-your-container) to take a snapshot of the current application state.

#### Step 4: Remove the currently running container

Remove the currently running container by executing the following command:

```console
docker-compose rm -v moodle
```

#### Step 5: Run the new image

Update the image tag in `docker-compose.yml` and re-create your container with the new image:

```console
docker-compose up -d
```

## Customize this image

The Bitnami Docker image for Moodle&trade; is designed to be extended so it can be used as the base image for your custom web applications.

### Extend this image

Before extending this image, please note there are certain configuration settings you can modify using the original image:

* Settings that can be adapted using environment variables. For instance, you can change the ports used by Apache for HTTP and HTTPS, by setting the environment variables `APACHE_HTTP_PORT_NUMBER` and `APACHE_HTTPS_PORT_NUMBER` respectively.
* [Adding custom virtual hosts](https://github.com/bitnami/containers/blob/main/bitnami/apache#adding-custom-virtual-hosts).
* [Replacing the 'httpd.conf' file](https://github.com/bitnami/containers/blob/main/bitnami/apache#full-configuration).
* [Using custom SSL certificates](https://github.com/bitnami/containers/blob/main/bitnami/apache#using-custom-ssl-certificates).

If your desired customizations cannot be covered using the methods mentioned above, extend the image. To do so, create your own image using a Dockerfile with the format below:

```Dockerfile
FROM bitnami/moodle
## Put your customizations below
...
```

Here is an example of extending the image with the following modifications:

* Install the `vim` editor
* Modify the Apache configuration file
* Modify the ports used by Apache

```Dockerfile
FROM bitnami/moodle

## Install 'vim'
RUN install_packages vim

## Enable mod_ratelimit module
RUN sed -i -r 's/#LoadModule ratelimit_module/LoadModule ratelimit_module/' /opt/bitnami/apache/conf/httpd.conf

## Modify the ports used by Apache by default
# It is also possible to change these environment variables at runtime
ENV APACHE_HTTP_PORT_NUMBER=8181
ENV APACHE_HTTPS_PORT_NUMBER=8143
EXPOSE 8181 8143
```

Based on the extended image, you can update the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/moodle/docker-compose.yml) file present in this repository to add other features:

```diff
   moodle:
-    image: bitnami/moodle:latest
+    build: .
     ports:
-      - '80:8080'
-      - '443:8443'
+      - '80:8181'
+      - '443:8143'
     environment:
       ...
+      - PHP_MEMORY_LIMIT=512m
     ...
```

## Notable Changes

## 3.9.0-debian-10-r17

* The size of the container image has been decreased.
* The configuration logic is now based on Bash scripts in the *rootfs/* folder.
* The Moodle&trade; container now supports the "non-root" user approach, but it still runs as the `root` user by default. When running as a non-root user, all services will be run under the same user and Cron jobs will be disabled as crond requires to be run as a superuser. To run as a non-root user, change `USER root` to `USER 1001` in the Dockerfile, or specify `user: 1001` in `docker-compose.yml`. Related changes:
  * The HTTP/HTTPS ports exposed by the container are now `8080/8443` instead of `80/443`.
  * Backwards compatibility is not guaranteed when data is persisted using docker or docker-compose. We highly recommend migrating the Moodle&trade; site by exporting its content, and importing it on a new Moodle&trade; container.

## 3.7.1-debian-9-r38 and 3.7.1-ol-7-r40

* It is now possible to use existing Moodle&trade; databases from other installations. In order to do this, use the environment variable `MOODLE_SKIP_INSTALL`, which forces the container not to run the initial Moodle&trade; setup wizard.

## 3.7.0-debian-9-r12 and 3.7.0-ol-7-r13

* This image has been adapted so it's easier to customize. See the [Customize this image](#customize-this-image) section for more information.
* The Apache configuration volume (`/bitnami/apache`) has been deprecated, and support for this feature will be dropped in the near future. Until then, the container will enable the Apache configuration from that volume if it exists. By default, and if the configuration volume does not exist, the configuration files will be regenerated each time the container is created. Users wanting to apply custom Apache configuration files are advised to mount a volume for the configuration at `/opt/bitnami/apache/conf`, or mount specific configuration files individually.
* The PHP configuration volume (`/bitnami/php`) has been deprecated, and support for this feature will be dropped in the near future. Until then, the container will enable the PHP configuration from that volume if it exists. By default, and if the configuration volume does not exist, the configuration files will be regenerated each time the container is created. Users wanting to apply custom PHP configuration files are advised to mount a volume for the configuration at `/opt/bitnami/php/conf`, or mount specific configuration files individually.
* Enabling custom Apache certificates by placing them at `/opt/bitnami/apache/certs` has been deprecated, and support for this functionality will be dropped in the near future. Users wanting to enable custom certificates are advised to mount their certificate files on top of the preconfigured ones at `/certs`.

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
