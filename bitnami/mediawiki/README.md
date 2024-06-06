# Bitnami package for MediaWiki

## What is MediaWiki?

> MediaWiki is the free and open source wiki software that powers Wikipedia. Used by thousands of organizations, it is extremely powerful, scalable software and a feature-rich wiki implementation.

[Overview of MediaWiki](http://www.mediawiki.org/wiki/MediaWiki)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name mediawiki bitnami/mediawiki:latest
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

Looking to use MediaWiki in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## How to deploy MediaWiki in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami MediaWiki Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/mediawiki).

Bitnami containers can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-work-with-non-root-containers-index.html).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami MediaWiki Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/mediawiki).

```console
docker pull bitnami/mediawiki:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/mediawiki/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/mediawiki:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## How to use this image

MediaWiki requires access to a MySQL or MariaDB database to store information. We'll use the [Bitnami Docker Image for MariaDB](https://github.com/bitnami/containers/tree/main/bitnami/mariadb) for the database requirements.

### Using the Docker Command Line

#### Step 1: Create a network

```console
docker network create mediawiki-network
```

#### Step 2: Create a volume for MariaDB persistence and create a MariaDB container

```console
$ docker volume create --name mariadb_data
docker run -d --name mariadb \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env MARIADB_USER=bn_mediawiki \
  --env MARIADB_PASSWORD=bitnami \
  --env MARIADB_DATABASE=bitnami_mediawiki \
  --network mediawiki-network \
  --volume mariadb_data:/bitnami/mariadb \
  bitnami/mariadb:latest
```

#### Step 3: Create volumes for MediaWiki persistence and launch the container

```console
$ docker volume create --name mediawiki_data
docker run -d --name mediawiki \
  -p 8080:8080 -p 8443:8443 \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env MEDIAWIKI_DATABASE_USER=bn_mediawiki \
  --env MEDIAWIKI_DATABASE_PASSWORD=bitnami \
  --env MEDIAWIKI_DATABASE_NAME=bitnami_mediawiki \
  --network mediawiki-network \
  --volume mediawiki_data:/bitnami/mediawiki \
  bitnami/mediawiki:latest
```

Access your application at `http://your-ip/`

### Run the application using Docker Compose

```console
curl -sSL https://raw.githubusercontent.com/bitnami/containers/main/bitnami/mediawiki/docker-compose.yml > docker-compose.yml
docker-compose up -d
```

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/mediawiki).

If you detect any issue in the `docker-compose.yaml` file, feel free to report it or contribute with a fix by following our [Contributing Guidelines](https://github.com/bitnami/containers/blob/main/CONTRIBUTING.md).

## Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami/mediawiki` path. If the mounted directory is empty, it will be initialized on the first run. Additionally you should [mount a volume for persistence of the MariaDB data](https://github.com/bitnami/containers/blob/main/bitnami/mariadb#persisting-your-database).

The above examples define the Docker volumes named mariadb_data and mediawiki_data. The MediaWiki application state will persist as long as volumes are not removed.

To avoid inadvertent removal of volumes, you can mount host directories as data volumes. Alternatively you can make use of volume plugins to host the volume data.

### Mount host directories as data volumes with Docker Compose

This requires a minor change to the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/mediawiki/docker-compose.yml) file present in this repository:

```diff
   mariadb:
     ...
     volumes:
-      - 'mariadb_data:/bitnami/mariadb'
+      - /path/to/mariadb-persistence:/bitnami/mariadb
   ...
   mediawiki:
     ...
     volumes:
-      - 'mediawiki_data:/bitnami/mediawiki'
+      - /path/to/mediawiki-persistence:/bitnami/mediawiki
   ...
-volumes:
-  mariadb_data:
-    driver: local
-  mediawiki_data:
-    driver: local
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

### Mount host directories as data volumes using the Docker command line

#### Step 1: Create a network (if it does not exist)

```console
docker network create mediawiki-network
```

#### Step 2. Create a MariaDB container with host volume

```console
docker run -d --name mariadb \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env MARIADB_USER=bn_mediawiki \
  --env MARIADB_PASSWORD=bitnami \
  --env MARIADB_DATABASE=bitnami_mediawiki \
  --network mediawiki-network \
  --volume /path/to/mariadb-persistence:/bitnami/mariadb \
  bitnami/mariadb:latest
```

#### Step 3. Create the MediaWiki container with host volumes

```console
docker run -d --name mediawiki \
  -p 8080:8080 -p 8443:8443 \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env MEDIAWIKI_DATABASE_USER=bn_mediawiki \
  --env MEDIAWIKI_DATABASE_PASSWORD=bitnami \
  --env MEDIAWIKI_DATABASE_NAME=bitnami_mediawiki \
  --network mediawiki-network \
  --volume /path/to/mediawiki-persistence:/bitnami/mediawiki \
  bitnami/mediawiki:latest
```

## Configuration

### Environment variables

#### Customizable environment variables

| Name                                   | Description                                                                                                                                                                        | Default Value                               |
|----------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------|
| `MEDIAWIKI_DATA_TO_PERSIST`            | Files to persist relative to the MediaWiki installation directory. To provide multiple values, separate them with a whitespace.                                                    | `images extensions skins LocalSettings.php` |
| `MEDIAWIKI_SKIP_BOOTSTRAP`             | Whether to perform initial bootstrapping for the application.                                                                                                                      | `nil`                                       |
| `MEDIAWIKI_WIKI_NAME`                  | MediaWiki wiki name.                                                                                                                                                               | `Bitnami MediaWiki`                         |
| `MEDIAWIKI_WIKI_PREFIX`                | Base path to use for MediaWiki wiki URLs.                                                                                                                                          | `/wiki`                                     |
| `MEDIAWIKI_SCRIPT_PATH`                | Base path to use for MediaWiki script URLs.                                                                                                                                        | `nil`                                       |
| `MEDIAWIKI_HOST`                       | MediaWiki application host.                                                                                                                                                        | `localhost`                                 |
| `MEDIAWIKI_ENABLE_HTTPS`               | Whether to use HTTPS by default.                                                                                                                                                   | `no`                                        |
| `MEDIAWIKI_EXTERNAL_HTTP_PORT_NUMBER`  | Port to used by MediaWiki to generate URLs and links when accessing using HTTP.                                                                                                    | `80`                                        |
| `MEDIAWIKI_EXTERNAL_HTTPS_PORT_NUMBER` | Port to used by MediaWiki to generate URLs and links when accessing using HTTPS.                                                                                                   | `443`                                       |
| `MEDIAWIKI_USERNAME`                   | MediaWiki user name.                                                                                                                                                               | `user`                                      |
| `MEDIAWIKI_PASSWORD`                   | MediaWiki user password.                                                                                                                                                           | `bitnami123`                                |
| `MEDIAWIKI_EMAIL`                      | MediaWiki user e-mail address.                                                                                                                                                     | `user@example.com`                          |
| `MEDIAWIKI_SMTP_HOST`                  | MediaWiki SMTP server host.                                                                                                                                                        | `nil`                                       |
| `MEDIAWIKI_SMTP_HOST_ID`               | MediaWiki SMTP server host ID. It is a MediaWiki-specific setting used to build the Message-ID email header. If not provided, it will default to the value of MEDIAWIKI_SMTP_HOST. | `$MEDIAWIKI_SMTP_HOST`                      |
| `MEDIAWIKI_SMTP_PORT_NUMBER`           | MediaWiki SMTP server port number.                                                                                                                                                 | `nil`                                       |
| `MEDIAWIKI_SMTP_USER`                  | MediaWiki SMTP server user (if being used).                                                                                                                                        | `nil`                                       |
| `MEDIAWIKI_SMTP_PASSWORD`              | MediaWiki SMTP server user password (if being used).                                                                                                                               | `nil`                                       |
| `MEDIAWIKI_ENABLE_SMTP_AUTH`           | Whether to use authentication for SMTP server. Valid values: `yes`, `no`.                                                                                                          | `yes`                                       |
| `MEDIAWIKI_DATABASE_HOST`              | Database server host.                                                                                                                                                              | `mariadb`                                   |
| `MEDIAWIKI_DATABASE_PORT_NUMBER`       | Database server port.                                                                                                                                                              | `3306`                                      |
| `MEDIAWIKI_DATABASE_NAME`              | Database name.                                                                                                                                                                     | `bitnami_mediawiki`                         |
| `MEDIAWIKI_DATABASE_USER`              | Database user name.                                                                                                                                                                | `bn_mediawiki`                              |
| `MEDIAWIKI_DATABASE_PASSWORD`          | Database user password.                                                                                                                                                            | `nil`                                       |
| `MEDIAWIKI_SKIP_CONFIG_VALIDATION`     | Skip config validation during startup. Allows the use of deprecated values in MediaWiki configuration file.                                                                        | `no`                                        |

#### Read-only environment variables

| Name                       | Description                                          | Value                                     |
|----------------------------|------------------------------------------------------|-------------------------------------------|
| `MEDIAWIKI_BASE_DIR`       | MediaWiki installation directory.                    | `${BITNAMI_ROOT_DIR}/mediawiki`           |
| `MEDIAWIKI_CONF_FILE`      | Configuration file for MediaWiki.                    | `${MEDIAWIKI_BASE_DIR}/LocalSettings.php` |
| `MEDIAWIKI_VOLUME_DIR`     | MediaWiki directory for mounted configuration files. | `${BITNAMI_VOLUME_DIR}/mediawiki`         |
| `PHP_DEFAULT_MEMORY_LIMIT` | Default PHP memory limit.                            | `256M`                                    |

When you start the MediaWiki image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line. If you want to add a new environment variable:

* For docker-compose add the variable name and value under the application section in the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/mediawiki/docker-compose.yml) file present in this repository:

```yaml
mediawiki:
  ...
  environment:
    - MEDIAWIKI_PASSWORD=my_password
  ...
```

* For manual execution add a `--env` option with each variable and value:

  ```console
  docker run -d --name mediawiki -p 80:8080 -p 443:8443 \
    --env MEDIAWIKI_PASSWORD=my_password \
    --network mediawiki-tier \
    --volume /path/to/mediawiki-persistence:/bitnami/mediawiki \
    bitnami/mediawiki:latest
  ```

#### Example

This would be an example of SMTP configuration using a GMail account:

* Modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/mediawiki/docker-compose.yml) file present in this repository:

```yaml
  mediawiki:
    ...
    environment:
      - MEDIAWIKI_DATABASE_USER=bn_mediawiki
      - MEDIAWIKI_DATABASE_NAME=bitnami_mediawiki
      - ALLOW_EMPTY_PASSWORD=yes
      - MEDIAWIKI_SMTP_HOST=smtp.gmail.com
      - MEDIAWIKI_SMTP_HOST_ID=mydomain.com
      - MEDIAWIKI_SMTP_PORT=587
      - MEDIAWIKI_SMTP_USER=your_email@gmail.com
      - MEDIAWIKI_SMTP_PASSWORD=your_password
  ...
```

* For manual execution:

  ```console
  docker run -d --name mediawiki -p 80:8080 -p 443:8443 \
    --env MEDIAWIKI_DATABASE_USER=bn_mediawiki \
    --env MEDIAWIKI_DATABASE_NAME=bitnami_mediawiki \
    --env MEDIAWIKI_SMTP_HOST=smtp.gmail.com \
    --env MEDIAWIKI_SMTP_HOST_ID=mydomain.com \
    --env MEDIAWIKI_SMTP_PORT=587 \
    --env MEDIAWIKI_SMTP_USER=your_email@gmail.com \
    --env MEDIAWIKI_SMTP_PASSWORD=your_password \
    --network mediawiki-tier \
    --volume /path/to/mediawiki-persistence:/bitnami/mediawiki \
    bitnami/mediawiki:latest
  ```

## How to install imagemagick in the Bitnami MediaWiki Docker image

If you require better quality thumbnails for your uploaded images, you may want to install imagemagick instead of using GD. To do so you can build your own docker image adding the `imagemagick` system package. Since we are using a non-root container, we have to swap the user to root to install imagemagick and it's requirements.

1. Create the following Dockerfile

    ```Dockerfile
    FROM bitnami/mediawiki:latest
    USER root
    RUN install_packages imagemagick
    USER 1001
    ```

2. Build the docker image

    ```console
    docker build -t bitnami/mediawiki:imagemagick .
    ```

3. Edit the *docker-compose.yml* to use the docker image built in the previous step.

4. Finally exec into your MediaWiki container and edit the file */opt/bitnami/mediawiki/LocalSettings.php* as described [here](https://www.mediawiki.org/wiki/Manual:Installing_third-party_tools#Image_thumbnailing) in order to start using imagemagick.

## How to migrate from a Bitnami MediaWiki Stack

You can follow these steps in order to migrate it to this container:

1. Export the data from your SOURCE installation: (assuming an installation in `/opt/bitnami` directory)

    ```console
    mysqldump -u root -p bitnami_mediawiki > ~/backup-mediawiki-database.sql
    gzip -c ~/backup-mediawiki-database.sql > ~/backup-mediawiki-database.sql.gz
    cd /opt/bitnami/apps/mediawiki/htdocs/
    tar cfz ~/backup-mediawiki-extensions.tar.gz extensions
    tar cfz ~/backup-mediawiki-images.tar.gz images
    tar cfz ~/backup-mediawiki-skins.tar.gz skins
    ```

2. Copy the backup files to your TARGET installation:

    ```console
    scp ~/backup-mediawiki-* YOUR_USERNAME@TARGET_HOST:~
    ```

3. Create the MediaWiki Container as described in the section [How to use this Image (Using Docker Compose)](https://github.com/bitnami/containers/blob/main/bitnami/mediawiki#using-docker-compose)

4. Wait for the initial setup to finish. You can follow it with

    ```console
    docker-compose logs -f mediawiki
    ```

    and press `Ctrl-C` when you see this:

    ```console
    nami    INFO  mediawiki successfully initialized
    Starting mediawiki ...
    ```

5. Stop Apache:

    ```console
    docker-compose exec mediawiki nami stop apache
    ```

6. Obtain the password used by MediaWiki to access the database in order avoid reconfiguring it:

    ```console
    docker-compose exec mediawiki bash -c 'cat /opt/bitnami/mediawiki/LocalSettings.php | grep wgDBpassword'
    ```

7. Restore the database backup: (replace ROOT_PASSWORD below with your MariaDB root password)

    ```console
    cd ~
    docker-compose exec mariadb mysql -u root -pROOT_PASSWORD
    MariaDB [(none)]> drop database bitnami_mediawiki;
    MariaDB [(none)]> create database bitnami_mediawiki;
    MariaDB [(none)]> grant all privileges on bitnami_mediawiki.* to 'bn_mediawiki'@'%' identified by 'PASSWORD_OBTAINED_IN_STEP_6';
    MariaDB [(none)]> exit
    gunzip -c ./backup-mediawiki-database.sql.gz | docker exec -i $(docker-compose ps -q mariadb) mysql -u root bitnami_mediawiki -pROOT_PASSWORD
    ```

8. Restore extensions/images/skins directories from backup:

    ```console
    cat ./backup-mediawiki-extensions.tar.gz | docker exec -i $(docker-compose ps -q mediawiki) bash -c 'cd /bitnami/mediawiki/ ; tar -xzvf -'
    cat ./backup-mediawiki-images.tar.gz | docker exec -i $(docker-compose ps -q mediawiki) bash -c 'cd /bitnami/mediawiki/ ; tar -xzvf -'
    cat ./backup-mediawiki-skins.tar.gz | docker exec -i $(docker-compose ps -q mediawiki) bash -c 'cd /bitnami/mediawiki/ ; tar -xzvf -'
    ```

9. Fix MediaWiki directory permissions:

    ```console
    docker-compose exec mediawiki chown -R daemon:daemon /bitnami/mediawiki
    ```

10. Restart Apache:

    ```console
    docker-compose exec mediawiki nami start apache
    ```

## Logging

The Bitnami MediaWiki Docker image sends the container logs to `stdout`. To view the logs:

```console
docker logs mediawiki
```

Or using Docker Compose:

```console
docker-compose logs mediawiki
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Backing up your container

To backup your data, configuration and logs, follow these simple steps:

#### Step 1: Stop the currently running container

```console
docker stop mediawiki
```

Or using Docker Compose:

```console
docker-compose stop mediawiki
```

#### Step 2: Run the backup command

We need to mount two volumes in a container we will use to create the backup: a directory on your host to store the backup in, and the volumes from the container we just stopped so we can access the data.

```console
docker run --rm -v /path/to/mediawiki-backups:/backups --volumes-from mediawiki busybox \
  cp -a /bitnami/mediawiki /backups/latest
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

For the MediaWiki container:

```diff
 $ docker run -d --name mediawiki \
   ...
-  --volume /path/to/mediawiki-persistence:/bitnami/mediawiki \
+  --volume /path/to/mediawiki-backups/latest:/bitnami/mediawiki \
   bitnami/mediawiki:latest
```

### Upgrade this image

Bitnami provides up-to-date versions of MariaDB and MediaWiki, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the MediaWiki container. For the MariaDB upgrade see: <https://github.com/bitnami/containers/tree/main/bitnami/mariadb#upgrade-this-image>

#### Step 1: Get the updated image

```console
docker pull bitnami/mediawiki:latest
```

#### Step 2: Stop the running container

Stop the currently running container using the following command:

```console
docker-compose stop mediawiki
```

#### Step 3: Take a snapshot of the application state

Follow the steps in [Backing up your container](#backing-up-your-container) to take a snapshot of the current application state.

#### Step 4: Remove the currently running container

Remove the currently running container by executing the following command:

```consolee
docker-compose rm -v mediawiki
```

#### Step 5: Run the new image

Update the image tag in `docker-compose.yml` and re-create your container with the new image:

```console
docker-compose up -d
```

## Customize this image

The Bitnami MediaWiki Docker image is designed to be extended so it can be used as the base image for your custom web applications.

### Extend this image

Before extending this image, please note there are certain configuration settings you can modify using the original image:

* Settings that can be adapted using environment variables. For instance, you can change the ports used by Apache for HTTP and HTTPS, by setting the environment variables `APACHE_HTTP_PORT_NUMBER` and `APACHE_HTTPS_PORT_NUMBER` respectively.
* [Adding custom virtual hosts](https://github.com/bitnami/containers/blob/main/bitnami/apache#adding-custom-virtual-hosts).
* [Replacing the 'httpd.conf' file](https://github.com/bitnami/containers/blob/main/bitnami/apache#full-configuration).
* [Using custom SSL certificates](https://github.com/bitnami/containers/blob/main/bitnami/apache#using-custom-ssl-certificates).

If your desired customizations cannot be covered using the methods mentioned above, extend the image. To do so, create your own image using a Dockerfile with the format below:

```Dockerfile
FROM bitnami/mediawiki
## Put your customizations below
...
```

Here is an example of extending the image with the following modifications:

* Install the `vim` editor
* Modify the Apache configuration file
* Modify the ports used by Apache

```Dockerfile
FROM bitnami/mediawiki

## Change user to perform privileged actions
USER 0
## Install 'vim'
RUN install_packages vim
## Revert to the original non-root user
USER 1001

## Enable mod_ratelimit module
RUN sed -i -r 's/#LoadModule ratelimit_module/LoadModule ratelimit_module/' /opt/bitnami/apache/conf/httpd.conf

## Modify the ports used by Apache by default
# It is also possible to change these environment variables at runtime
ENV APACHE_HTTP_PORT_NUMBER=8181
ENV APACHE_HTTPS_PORT_NUMBER=8143
EXPOSE 8181 8143
```

Based on the extended image, you can update the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/mediawiki/docker-compose.yml) file present in this repository to add other features:

```diff
   mediawiki:
-    image: bitnami/mediawiki:latest
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

## Notable Changes

## 1.34.2-debian-10-r5

* The size of the container image has been decreased.
* The configuration logic is now based on Bash scripts in the *rootfs/* folder.
* The MediaWiki container image has been migrated to a "non-root" user approach. Previously the container ran as the `root` user and the Apache daemon was started as the `daemon` user. From now on, both the container and the Apache daemon run as user `1001`. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile, or `user: root` in `docker-compose.yml`. Consequences:
  * The HTTP/HTTPS ports exposed by the container are now `8080/8443` instead of `80/443`.
  * Backwards compatibility is not guaranteed when data is persisted using docker or docker-compose. We highly recommend migrating the MediaWiki site by exporting its content, and importing it on a new MediaWiki container. Follow the steps in [Backing up your container](#backing-up-your-container) and [Restoring a backup](#restoring-a-backup) to migrate the data between the old and new container.

## 1.32.1-debian-9-r20 and 1.32.1-ol-7-r33

* This image has been adapted so it's easier to customize. See the [Customize this image](#customize-this-image) section for more information.
* The Apache configuration volume (`/bitnami/apache`) has been deprecated, and support for this feature will be dropped in the near future. Until then, the container will enable the Apache configuration from that volume if it exists. By default, and if the configuration volume does not exist, the configuration files will be regenerated each time the container is created. Users wanting to apply custom Apache configuration files are advised to mount a volume for the configuration at `/opt/bitnami/apache/conf`, or mount specific configuration files individually.
* The PHP configuration volume (`/bitnami/php`) has been deprecated, and support for this feature will be dropped in the near future. Until then, the container will enable the PHP configuration from that volume if it exists. By default, and if the configuration volume does not exist, the configuration files will be regenerated each time the container is created. Users wanting to apply custom PHP configuration files are advised to mount a volume for the configuration at `/opt/bitnami/php/conf`, or mount specific configuration files individually.
* Enabling custom Apache certificates by placing them at `/opt/bitnami/apache/certs` has been deprecated, and support for this functionality will be dropped in the near future. Users wanting to enable custom certificates are advised to mount their certificate files on top of the preconfigured ones at `/certs`.

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
