# Bitnami package for SuiteCRM

## What is SuiteCRM?

> SuiteCRM is a completely open source, enterprise-grade Customer Relationship Management (CRM) application. SuiteCRM is a fork of the popular SugarCRM application.

[Overview of SuiteCRM](http://www.suitecrm.com/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name suitecrm bitnami/suitecrm:latest
```

**Warning**: This quick setup is only intended for development environments. You are encouraged to change the insecure default credentials and check out the available configuration options in the [Environment Variables](#environment-variables) section for a more secure deployment.

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use SuiteCRM in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Only latest stable branch maintained in the free Bitnami catalog

Starting December 10th 2024, only the latest stable branch of any container will receive updates in the free Bitnami catalog. To access up-to-date releases for all upstream-supported branches, consider upgrading to Bitnami Premium. Previous versions already released will not be deleted. They are still available to pull from DockerHub.

Please check the Bitnami Premium page in our partner [Arrow Electronics](https://www.arrow.com/globalecs/na/vendors/bitnami?utm_source=GitHub&utm_medium=containers) for more information.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami SuiteCRM Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/suitecrm).

```console
docker pull bitnami/suitecrm:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/suitecrm/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/suitecrm:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## How to use this image

SuiteCRM requires access to a MySQL or MariaDB database to store information. We'll use the [Bitnami Docker Image for MariaDB](https://github.com/bitnami/containers/tree/main/bitnami/mariadb) for the database requirements.

### Using the Docker Command Line

#### Step 1: Create a network

```console
docker network create suitecrm-network
```

#### Step 2: Create a volume for MariaDB persistence and create a MariaDB container

```console
$ docker volume create --name mariadb_data
docker run -d --name mariadb \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env MARIADB_USER=bn_suitecrm \
  --env MARIADB_PASSWORD=bitnami \
  --env MARIADB_DATABASE=bitnami_suitecrm \
  --network suitecrm-network \
  --volume mariadb_data:/bitnami/mariadb \
  bitnami/mariadb:latest
```

#### Step 3: Create volumes for SuiteCRM persistence and launch the container

```console
$ docker volume create --name suitecrm_data
docker run -d --name suitecrm \
  -p 8080:8080 -p 8443:8443 \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env SUITECRM_DATABASE_USER=bn_suitecrm \
  --env SUITECRM_DATABASE_PASSWORD=bitnami \
  --env SUITECRM_DATABASE_NAME=bitnami_suitecrm \
  --network suitecrm-network \
  --volume suitecrm_data:/bitnami/suitecrm \
  bitnami/suitecrm:latest
```

Access your application at `http://your-ip/`

### Run the application using Docker Compose

```console
curl -sSL https://raw.githubusercontent.com/bitnami/containers/main/bitnami/suitecrm/docker-compose.yml > docker-compose.yml
docker-compose up -d
```

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/suitecrm).

If you detect any issue in the `docker-compose.yaml` file, feel free to report it or contribute with a fix by following our [Contributing Guidelines](https://github.com/bitnami/containers/blob/main/CONTRIBUTING.md).

## Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami/suitecrm` path. If the mounted directory is empty, it will be initialized on the first run. Additionally you should [mount a volume for persistence of the MariaDB data](https://github.com/bitnami/containers/blob/main/bitnami/mariadb#persisting-your-database).

The above examples define the Docker volumes named `mariadb_data` and `suitecrm_data`. The SuiteCRM application state will persist as long as volumes are not removed.

To avoid inadvertent removal of volumes, you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

### Mount host directories as data volumes with Docker Compose

This requires a minor change to the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/suitecrm/docker-compose.yml) file present in this repository:

```diff
   mariadb:
     ...
     volumes:
-      - 'mariadb_data:/bitnami/mariadb'
+      - /path/to/mariadb-persistence:/bitnami/mariadb
   ...
   suitecrm:
     ...
     volumes:
-      - 'suitecrm_data:/bitnami/suitecrm'
+      - /path/to/suitecrm-persistence:/bitnami/suitecrm
   ...
-volumes:
-  mariadb_data:
-    driver: local
-  suitecrm_data:
-    driver: local
```

### Restoring persisted SuiteCRM installation

The entire directory of the SuiteCRM application will be persisted. To update the application, you will need to do it manualy.
SuiteCRM does not offer any out-of-the-box tool to upgrade the database schema after an upgrade, so it will not be done automatically.

### Mount host directories as data volumes using the Docker command line

#### Step 1: Create a network (if it does not exist)

```console
docker network create suitecrm-network
```

#### Step 2. Create a MariaDB container with host volume

```console
docker run -d --name mariadb \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env MARIADB_USER=bn_suitecrm \
  --env MARIADB_PASSWORD=bitnami \
  --env MARIADB_DATABASE=bitnami_suitecrm \
  --network suitecrm-network \
  --volume /path/to/mariadb-persistence:/bitnami/mariadb \
  bitnami/mariadb:latest
```

#### Step 3. Create the SuiteCRM container with host volumes

```console
docker run -d --name suitecrm \
  -p 8080:8080 -p 8443:8443 \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env SUITECRM_DATABASE_USER=bn_suitecrm \
  --env SUITECRM_DATABASE_PASSWORD=bitnami \
  --env SUITECRM_DATABASE_NAME=bitnami_suitecrm \
  --network suitecrm-network \
  --volume /path/to/suitecrm-persistence:/bitnami/suitecrm \
  bitnami/suitecrm:latest
```

## Configuration

### Environment variables

#### Customizable environment variables

| Name                                  | Description                                                                                                                    | Default Value                     |
|---------------------------------------|--------------------------------------------------------------------------------------------------------------------------------|-----------------------------------|
| `SUITECRM_DATA_TO_PERSIST`            | Files to persist relative to the SuiteCRM installation directory. To provide multiple values, separate them with a whitespace. | `$SUITECRM_BASE_DIR`              |
| `SUITECRM_SKIP_BOOTSTRAP`             | Whether to perform initial bootstrapping for the application.                                                                  | `nil`                             |
| `SUITECRM_USERNAME`                   | SuiteCRM user name.                                                                                                            | `user`                            |
| `SUITECRM_PASSWORD`                   | SuiteCRM user password.                                                                                                        | `bitnami`                         |
| `SUITECRM_EMAIL`                      | SuiteCRM user e-mail address.                                                                                                  | `user@example.com`                |
| `SUITECRM_HOST`                       | SuiteCRM server site URL.                                                                                                      | `localhost`                       |
| `SUITECRM_ENABLE_HTTPS`               | Whether to use HTTPS by default.                                                                                               | `no`                              |
| `SUITECRM_EXTERNAL_HTTP_PORT_NUMBER`  | Port to used by SuiteCRM to generate URLs and links when accessing using HTTP.                                                 | `80`                              |
| `SUITECRM_EXTERNAL_HTTPS_PORT_NUMBER` | Port to used by SuiteCRM to generate URLs and links when accessing using HTTPS.                                                | `443`                             |
| `SUITECRM_VALIDATE_USER_IP`           | Whether or not to validate te user IP.                                                                                         | `true`                            |
| `SUITECRM_SMTP_HOST`                  | SuiteCRM SMTP server host.                                                                                                     | `nil`                             |
| `SUITECRM_SMTP_PORT_NUMBER`           | SuiteCRM SMTP server port number.                                                                                              | `nil`                             |
| `SUITECRM_SMTP_USER`                  | SuiteCRM SMTP server user.                                                                                                     | `nil`                             |
| `SUITECRM_SMTP_PASSWORD`              | SuiteCRM SMTP server user password.                                                                                            | `nil`                             |
| `SUITECRM_SMTP_PROTOCOL`              | SuiteCRM SMTP server protocol to use.                                                                                          | `nil`                             |
| `SUITECRM_SMTP_NOTIFY_ADDRESS`        | SuiteCRM email address to use in notifications.                                                                                | `${SUITECRM_EMAIL}`               |
| `SUITECRM_SMTP_NOTIFY_NAME`           | SuiteCRM name to use in notifications.                                                                                         | `SuiteCRM`                        |
| `SUITECRM_DATABASE_HOST`              | Database server host.                                                                                                          | `$SUITECRM_DEFAULT_DATABASE_HOST` |
| `SUITECRM_DATABASE_PORT_NUMBER`       | Database server port.                                                                                                          | `3306`                            |
| `SUITECRM_DATABASE_NAME`              | Database name.                                                                                                                 | `bitnami_suitecrm`                |
| `SUITECRM_DATABASE_USER`              | Database user name.                                                                                                            | `bn_suitecrm`                     |
| `SUITECRM_DATABASE_PASSWORD`          | Database user password.                                                                                                        | `nil`                             |

#### Read-only environment variables

| Name                                | Description                                                                                                                          | Value                                              |
|-------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------|
| `SUITECRM_BASE_DIR`                 | SuiteCRM installation directory.                                                                                                     | `${BITNAMI_ROOT_DIR}/suitecrm`                     |
| `SUITECRM_CONF_FILE`                | Configuration file for SuiteCRM.                                                                                                     | `${SUITECRM_BASE_DIR}/public/legacy/config.php`    |
| `SUITECRM_SILENT_INSTALL_CONF_FILE` | Configuration file for the SuiteCRM silent installation wizard.                                                                      | `${SUITECRM_BASE_DIR}/public/legacy/config_si.php` |
| `SUITECRM_VOLUME_DIR`               | SuiteCRM directory for mounted configuration files.                                                                                  | `${BITNAMI_VOLUME_DIR}/suitecrm`                   |
| `SUITECRM_MOUNTED_CONF_FILE`        | Mounted configuration file for SuiteCRM. It will be copied to the SuiteCRM installation directory during the initialization process. | `${SUITECRM_VOLUME_DIR}/config_si.php`             |
| `SUITECRM_DEFAULT_DATABASE_HOST`    | Default database server host.                                                                                                        | `mariadb`                                          |
| `PHP_DEFAULT_MEMORY_LIMIT`          | Default PHP memory limit.                                                                                                            | `256M`                                             |
| `PHP_DEFAULT_POST_MAX_SIZE`         | Default maximum size for PHP POST requests.                                                                                          | `60M`                                              |
| `PHP_DEFAULT_UPLOAD_MAX_FILESIZE`   | Default maximum file size for PHP uploads.                                                                                           | `60M`                                              |

When you start the SuiteCRM image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line. If you want to add a new environment variable:

* For docker-compose add the variable name and value under the application section in the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/suitecrm/docker-compose.yml) file present in this repository:

```yaml
suitecrm:
  ...
  environment:
    - SUITECRM_PASSWORD=my_password
  ...
```

* For manual execution add a `--env` option with each variable and value:

  ```console
  docker run -d --name suitecrm -p 80:8080 -p 443:8443 \
    --env SUITECRM_PASSWORD=my_password \
    --network suitecrm-tier \
    --volume /path/to/suitecrm-persistence:/bitnami \
    bitnami/suitecrm:latest
  ```

### Example

This would be an example of SMTP configuration using a Gmail account:

* Modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/suitecrm/docker-compose.yml) file present in this repository:

```yaml
  suitecrm:
    ...
    environment:
      - SUITECRM_DATABASE_USER=bn_suitecrm
      - SUITECRM_DATABASE_NAME=bitnami_suitecrm
      - ALLOW_EMPTY_PASSWORD=yes
      - SUITECRM_SMTP_HOST=smtp.gmail.com
      - SUITECRM_SMTP_PROTOCOL=tls
      - SUITECRM_SMTP_PORT=587
      - SUITECRM_SMTP_USER=your_email@gmail.com
      - SUITECRM_SMTP_PASSWORD=your_password
  ...
```

* For manual execution:

  ```console
  docker run -d --name suitecrm -p 80:8080 -p 443:8443 \
    --env SUITECRM_DATABASE_USER=bn_suitecrm \
    --env SUITECRM_DATABASE_NAME=bitnami_suitecrm \
    --env SUITECRM_SMTP_HOST=smtp.gmail.com \
    --env SUITECRM_SMTP_PORT=587 \
    --env SUITECRM_SMTP_PROTOCOL=tls \
    --env SUITECRM_SMTP_USER=your_email@gmail.com \
    --env SUITECRM_SMTP_PASSWORD=your_password \
    --network suitecrm-tier \
    --volume /path/to/suitecrm-persistence:/bitnami \
    bitnami/suitecrm:latest
  ```

## Logging

The Bitnami SuiteCRM Docker image sends the container logs to `stdout`. To view the logs:

```console
docker logs suitecrm
```

Or using Docker Compose:

```console
docker-compose logs suitecrm
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Backing up your container

To backup your data, configuration and logs, follow these simple steps:

#### Step 1: Stop the currently running container

```console
docker stop suitecrm
```

Or using Docker Compose:

```console
docker-compose stop suitecrm
```

#### Step 2: Run the backup command

We need to mount two volumes in a container we will use to create the backup: a directory on your host to store the backup in, and the volumes from the container we just stopped so we can access the data.

```console
docker run --rm -v /path/to/suitecrm-backups:/backups --volumes-from suitecrm busybox \
  cp -a /bitnami/suitecrm /backups/latest
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

For the SuiteCRM container:

```diff
 $ docker run -d --name suitecrm \
   ...
-  --volume /path/to/suitecrm-persistence:/bitnami/suitecrm \
+  --volume /path/to/suitecrm-backups/latest:/bitnami/suitecrm \
   bitnami/suitecrm:latest
```

### Upgrade this image

Bitnami provides up-to-date versions of MariaDB and SuiteCRM, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the SuiteCRM container. For the MariaDB upgrade see: <https://github.com/bitnami/containers/tree/main/bitnami/mariadb#upgrade-this-image>

#### Step 1: Get the updated image

```console
docker pull bitnami/suitecrm:latest
```

#### Step 2: Stop the running container

Stop the currently running container using the command

```console
docker-compose stop suitecrm
```

#### Step 3: Take a snapshot of the application state

Follow the steps in [Backing up your container](#backing-up-your-container) to take a snapshot of the current application state.

#### Step 4: Remove the currently running container

Remove the currently running container by executing the following command:

```console
docker-compose rm -v suitecrm
```

#### Step 5: Run the new image

Update the image tag in `docker-compose.yml` and re-create your container with the new image:

```console
docker-compose up -d
```

## Customize this image

The Bitnami SuiteCRM Docker image is designed to be extended so it can be used as the base image for your custom web applications.

### Extend this image

Before extending this image, please note there are certain configuration settings you can modify using the original image:

* Settings that can be adapted using environment variables. For instance, you can change the ports used by Apache for HTTP and HTTPS, by setting the environment variables `APACHE_HTTP_PORT_NUMBER` and `APACHE_HTTPS_PORT_NUMBER` respectively.
* [Adding custom virtual hosts](https://github.com/bitnami/containers/blob/main/bitnami/apache#adding-custom-virtual-hosts).
* [Replacing the 'httpd.conf' file](https://github.com/bitnami/containers/blob/main/bitnami/apache#full-configuration).
* [Using custom SSL certificates](https://github.com/bitnami/containers/blob/main/bitnami/apache#using-custom-ssl-certificates).

If your desired customizations cannot be covered using the methods mentioned above, extend the image. To do so, create your own image using a Dockerfile with the format below:

```Dockerfile
FROM bitnami/suitecrm
## Put your customizations below
...
```

## Example 1

Here is an example of extending the image with the following modifications:

* Install the `vim` editor
* Modify the Apache configuration file
* Modify the ports used by Apache

```Dockerfile
FROM bitnami/suitecrm

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

Based on the extended image, you can update the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/suitecrm/docker-compose.yml) file present in this repository to add other features:

```diff
   suitecrm:
-    image: bitnami/suitecrm:latest
+    build: .
     ports:
-      - '80:8080'
-      - '443:8443'
+      - '80:8181'
+      - '443:8143'
     environment:
+      - PHP_MEMORY_LIMIT=512m
     ...
```

## Example 2: Add SuiteCRM API support

```Dockerfile
FROM bitnami/suitecrm
## Install keys
RUN openssl genrsa -out /opt/bitnami/suitecrm/Api/V8/OAuth2/private.key 2048 && \
    openssl rsa -in /opt/bitnami/suitecrm/Api/V8/OAuth2/private.key -pubout -out /opt/bitnami/suitecrm/Api/V8/OAuth2/public.key && \
    chmod 640 /opt/bitnami/suitecrm/Api/V8/OAuth2/private.key && \
    chgrp daemon /opt/bitnami/suitecrm/Api/V8/OAuth2/private.key /opt/bitnami/suitecrm/Api/V8/OAuth2/public.key
```

## Notable Changes

### 7.11.18-debian-10-r13

* The size of the container image has been decreased.
* The configuration logic is now based on Bash scripts in the *rootfs/* folder.
* `SUITECRM_HTTP_TIMEOUT` environment variable has been removed.
* The SuiteCRM container now supports the "non-root" user approach, but it still runs as the root user by default. When running as a non-root user, all services will be run under the same user and Cron jobs will be disabled as crond requires to be run as a superuser. To run as a non-root user, change USER root to USER 1001 in the Dockerfile, or use user: 1001 in docker-compose.yml. Related changes:
* The HTTP/HTTPS ports exposed by the container are now `8080/8443` instead of `80/443`.
* Backwards compatibility is not guaranteed when data is persisted using docker or docker-compose. We highly recommend migrating the SuiteCRM site by exporting its content, and importing it on a new SuiteCRM container.

To upgrade a deployment with the previous Bitnami SuiteCRM container image, which did not support non-root, the easiest way is to start the new image as a *root* user and updating the port numbers. Modify your `docker-compose.yml` file as follows:

```diff
       - ALLOW_EMPTY_PASSWORD=yes
+    user: root
     ports:
-      - '80:80'
-      - '443:443'
+      - '80:8080'
+      - '443:8443'
     volumes:
```

### 7.11.4-debian-9-r21 and 7.11.4-ol-7-r32

* This image has been adapted so it's easier to customize. See the [Customize this image](#customize-this-image) section for more information.
* The Apache configuration volume (`/bitnami/apache`) has been deprecated, and support for this feature will be dropped in the near future. Until then, the container will enable the Apache configuration from that volume if it exists. By default, and if the configuration volume does not exist, the configuration files will be regenerated each time the container is created. Users wanting to apply custom Apache configuration files are advised to mount a volume for the configuration at `/opt/bitnami/apache/conf`, or mount specific configuration files individually.
* The PHP configuration volume (`/bitnami/php`) has been deprecated, and support for this feature will be dropped in the near future. Until then, the container will enable the PHP configuration from that volume if it exists. By default, and if the configuration volume does not exist, the configuration files will be regenerated each time the container is created. Users wanting to apply custom PHP configuration files are advised to mount a volume for the configuration at `/opt/bitnami/php/conf`, or mount specific configuration files individually.
* Enabling custom Apache certificates by placing them at `/opt/bitnami/apache/certs` has been deprecated, and support for this functionality will be dropped in the near future. Users wanting to enable custom certificates are advised to mount their certificate files on top of the preconfigured ones at `/certs`.

### 7.10.10-debian-9-r18 and 7.10.10-ol-7-r24

* Due to several broken SuiteCRM features and plugins, the entire `htdocs` directory is now being persisted (instead of a select number of files and directories). Because of this, upgrades will not work and a full migration needs to be performed. Upgrade instructions have been updated to reflect these changes.

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
