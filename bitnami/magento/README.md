# Bitnami package for Magento

## What is Magento?

> Magento is a powerful open source e-commerce platform. With easy customizations and rich features, it allows retailers to grow their online businesses in a cost-effective way.

[Overview of Magento](http://www.magento.com)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name magento bitnami/magento:latest
```

**Warning**: This quick setup is only intended for development environments. You are encouraged to change the insecure default credentials and check out the available configuration options in the [Environment Variables](#environment-variables) section for a more secure deployment.

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use Magento in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## How to deploy Magento in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Magento Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/magento).

Bitnami containers can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami Magento Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/magento).

```console
docker pull bitnami/magento:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/magento/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/magento:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## How to use this image

Magento requires access to a MySQL or MariaDB database to store information. We'll use the [Bitnami Docker Image for MariaDB](https://github.com/bitnami/containers/tree/main/bitnami/mariadb) for the database requirements.

### Using the Docker Command Line

#### Step 1: Create a network

```console
docker network create magento-network
```

#### Step 2: Create a volume for MariaDB persistence and create a MariaDB container

```console
$ docker volume create --name mariadb_data
docker run -d --name mariadb \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env MARIADB_USER=bn_magento \
  --env MARIADB_PASSWORD=bitnami \
  --env MARIADB_DATABASE=bitnami_magento \
  --network magento-network \
  --volume mariadb_data:/bitnami/mariadb \
  bitnami/mariadb:latest
```

#### Step 3: Create volumes for Magento persistence and launch the container

```console
$ docker volume create --name magento_data
docker run -d --name magento \
  -p 8080:8080 -p 8443:8443 \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env MAGENTO_DATABASE_USER=bn_magento \
  --env MAGENTO_DATABASE_PASSWORD=bitnami \
  --env MAGENTO_DATABASE_NAME=bitnami_magento \
  --network magento-network \
  --volume magento_data:/bitnami/magento \
  bitnami/magento:latest
```

Access your application at `http://your-ip/`

## Installing Magento extensions

There are a large number of Magento extensions used to add features to your Magento Stores. If you want to install an extension to your Magento container, these are the basic steps you need to take:

### Step 1: Log into the container shell as root

```console
docker exec -it magento /bin/bash
```

### Step 2: Login as the web server user

```console
su daemon -s /bin/bash
```

### Step 3: Change directory to the Magento root

```console
cd /bitnami/magento
```

### Step 4: Follow the installation instructions for the extension. The Magento standard is to use composer

```console
composer require <extension name>
php bin/magento module:enable <extension name>
php bin/magento setup:upgrade
php bin/magento setup:di:compile
php bin/magento setup:static-content:deploy -f
php bin/magento cache:flush
```

### Run the application using Docker Compose

```console
curl -sSL https://raw.githubusercontent.com/bitnami/containers/main/bitnami/magento/docker-compose.yml > docker-compose.yml
docker-compose up -d
```

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/magento).

If you detect any issue in the `docker-compose.yaml` file, feel free to report it or contribute with a fix by following our [Contributing Guidelines](https://github.com/bitnami/containers/blob/main/CONTRIBUTING.md).

## Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami/magento` path. If the mounted directory is empty, it will be initialized on the first run. Additionally you should mount a volume for persistence of the [MariaDB data](https://github.com/bitnami/containers/blob/main/bitnami/mariadb#persisting-your-database).

The above examples define the Docker volumes named `mariadb_data` and `magento_data`. The Magento application state will persist as long as volumes are not removed.

To avoid inadvertent removal of volumes, you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

### Mount host directories as data volumes with Docker Compose

This requires a minor change to the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/magento/docker-compose.yml) file present in this repository:

```diff
   mariadb:
     ...
     volumes:
-      - 'mariadb_data:/bitnami/mariadb'
+      - /path/to/mariadb-persistence:/bitnami/mariadb
   ...
   magento:
     ...
     volumes:
-      - 'magento_data:/bitnami/magento'
+      - /path/to/magento-persistence:/bitnami/magento
   ...
-volumes:
-  mariadb_data:
-    driver: local
-  magento_data:
-    driver: local
```

### Mount host directories as data volumes using the Docker command line

#### Step 1: Create a network (if it does not exist)

```console
docker network create magento-network
```

#### Step 2. Create a MariaDB container with host volume

```console
docker run -d --name mariadb \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env MARIADB_USER=bn_magento \
  --env MARIADB_PASSWORD=bitnami \
  --env MARIADB_DATABASE=bitnami_magento \
  --network magento-network \
  --volume /path/to/mariadb-persistence:/bitnami/mariadb \
  bitnami/mariadb:latest
```

#### Step 3. Create the Magento container with host volumes

```console
docker run -d --name magento \
  -p 8080:8080 -p 8443:8443 \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env MAGENTO_DATABASE_USER=bn_magento \
  --env MAGENTO_DATABASE_PASSWORD=bitnami \
  --env MAGENTO_DATABASE_NAME=bitnami_magento \
  --network magento-network \
  --volume /path/to/magento-persistence:/bitnami/magento \
  bitnami/magento:latest
```

## Configuration

### Initializing a new instance

When the container is executed for the first time, it will execute the files with extensions `.sh` located at `/docker-entrypoint-initdb.d`.

### Environment variables

#### Customizable environment variables

| Name                                     | Description                                                                                                                   | Default Value       |
|------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------|---------------------|
| `MAGENTO_DATA_TO_PERSIST`                | Files to persist relative to the Magento installation directory. To provide multiple values, separate them with a whitespace. | `$MAGENTO_BASE_DIR` |
| `MAGENTO_HOST`                           | Magento host domain or IP address.                                                                                            | `localhost`         |
| `MAGENTO_ENABLE_HTTPS`                   | Whether to enable SSL to access the Magento store.                                                                            | `no`                |
| `MAGENTO_ENABLE_ADMIN_HTTPS`             | Whether to use SSL to access the Magento administration panel.                                                                | `no`                |
| `MAGENTO_EXTERNAL_HTTP_PORT_NUMBER`      | Port to access Magento from outside of the instance using HTTP.                                                               | `80`                |
| `MAGENTO_EXTERNAL_HTTPS_PORT_NUMBER`     | Port to access Magento from outside of the instance using HTTPS.                                                              | `443`               |
| `MAGENTO_FIRST_NAME`                     | Magento user first name.                                                                                                      | `FirstName`         |
| `MAGENTO_LAST_NAME`                      | Magento user last name.                                                                                                       | `LastName`          |
| `MAGENTO_MODE`                           | Magento mode.                                                                                                                 | `default`           |
| `MAGENTO_EXTRA_INSTALL_ARGS`             | Extra flags to append to the Magento 'setup:install' command call.                                                            | `nil`               |
| `MAGENTO_ADMIN_URL_PREFIX`               | URL prefix to access the Magento administration panel.                                                                        | `admin`             |
| `MAGENTO_DEPLOY_STATIC_CONTENT`          | Whether to deploy Magento static content during the initialization, to optimize initial page load time.                       | `no`                |
| `MAGENTO_KEEP_STATIC`                    | Whether to keep the content of 'pub/static' folder during the initialization.                                                 | `no`                |
| `MAGENTO_SKIP_REINDEX`                   | Whether to skip Magento re-index during the initialization.                                                                   | `no`                |
| `MAGENTO_SKIP_BOOTSTRAP`                 | Whether to perform initial bootstrapping for the application.                                                                 | `no`                |
| `MAGENTO_USERNAME`                       | Magento user login name.                                                                                                      | `user`              |
| `MAGENTO_PASSWORD`                       | Magento user password.                                                                                                        | `bitnami1`          |
| `MAGENTO_EMAIL`                          | Magento user e-mail address.                                                                                                  | `user@example.com`  |
| `MAGENTO_ENABLE_HTTP_CACHE`              | Whether to enable a HTTP cache server for Magento (i.e. Varnish).                                                             | `no`                |
| `MAGENTO_HTTP_CACHE_BACKEND_HOST`        | HTTP cache backend hostname.                                                                                                  | `nil`               |
| `MAGENTO_HTTP_CACHE_BACKEND_PORT_NUMBER` | HTTP cache backend port.                                                                                                      | `nil`               |
| `MAGENTO_HTTP_CACHE_SERVER_HOST`         | HTTP cache server hostname.                                                                                                   | `nil`               |
| `MAGENTO_HTTP_CACHE_SERVER_PORT_NUMBER`  | HTTP cache server port.                                                                                                       | `nil`               |
| `MAGENTO_DATABASE_HOST`                  | Database server host.                                                                                                         | `mariadb`           |
| `MAGENTO_DATABASE_PORT_NUMBER`           | Database server port.                                                                                                         | `3306`              |
| `MAGENTO_DATABASE_NAME`                  | Database name.                                                                                                                | `bitnami_magento`   |
| `MAGENTO_DATABASE_USER`                  | Database user name.                                                                                                           | `bn_magento`        |
| `MAGENTO_DATABASE_PASSWORD`              | Database user password.                                                                                                       | `nil`               |
| `MAGENTO_ENABLE_DATABASE_SSL`            | Whether to enable SSL for database connections.                                                                               | `no`                |
| `MAGENTO_VERIFY_DATABASE_SSL`            | Whether to verify the database SSL certificate when SSL is enabled for database connections.                                  | `yes`               |
| `MAGENTO_DATABASE_SSL_CERT_FILE`         | Path to the database client certificate file.                                                                                 | `nil`               |
| `MAGENTO_DATABASE_SSL_KEY_FILE`          | Path to the database client certificate key file.                                                                             | `nil`               |
| `MAGENTO_DATABASE_SSL_CA_FILE`           | Path to the database server CA bundle file.                                                                                   | `nil`               |
| `MAGENTO_SEARCH_ENGINE`                  | Magento search engine to use.                                                                                                 | `elasticsearch7`    |
| `MAGENTO_ELASTICSEARCH_HOST`             | Elasticsearch server host.                                                                                                    | `elasticsearch`     |
| `MAGENTO_ELASTICSEARCH_PORT_NUMBER`      | Elasticsearch server port.                                                                                                    | `9200`              |
| `MAGENTO_ELASTICSEARCH_USE_HTTPS`        | Whether to use https to connect with Elasticsearch.                                                                           | `no`                |
| `MAGENTO_ELASTICSEARCH_ENABLE_AUTH`      | Whether to enable authentication for connections to the Elasticsearch server.                                                 | `no`                |
| `MAGENTO_ELASTICSEARCH_USER`             | Elasticsearch server user login.                                                                                              | `nil`               |
| `MAGENTO_ELASTICSEARCH_PASSWORD`         | Elasticsearch server user password.                                                                                           | `nil`               |

#### Read-only environment variables

| Name                             | Description                                        | Value                                 |
|----------------------------------|----------------------------------------------------|---------------------------------------|
| `MAGENTO_BASE_DIR`               | Magento installation directory.                    | `${BITNAMI_ROOT_DIR}/magento`         |
| `MAGENTO_BIN_DIR`                | Magento directory for executable files.            | `${MAGENTO_BASE_DIR}/bin`             |
| `MAGENTO_CONF_FILE`              | Configuration file for Magento.                    | `${MAGENTO_BASE_DIR}/app/etc/env.php` |
| `MAGENTO_VOLUME_DIR`             | Magento directory for mounted configuration files. | `${BITNAMI_VOLUME_DIR}/magento`       |
| `PHP_DEFAULT_MAX_EXECUTION_TIME` | Default PHP max execution time.                    | `18000`                               |
| `PHP_DEFAULT_MEMORY_LIMIT`       | Default PHP memory limit.                          | `1G`                                  |

When you start the Magento image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line. If you want to add a new environment variable:

* For docker-compose add the variable name and value under the application section in the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/magento/docker-compose.yml) file present in this repository:

```yaml
magento:
  ...
  environment:
    - MAGENTO_PASSWORD=my_password1234
  ...
```

* For manual execution add a `--env` option with each variable and value:

  ```console
  docker run -d --name magento -p 80:8080 -p 443:8443 \
    --env MAGENTO_PASSWORD=my_password1234 \
    --network magento-tier \
    --volume /path/to/magento-persistence:/bitnami \
    bitnami/magento:latest
  ```

## Logging

The Bitnami Magento Docker image sends the container logs to `stdout`. To view the logs:

```console
docker logs magento
```

Or using Docker Compose:

```console
docker-compose logs magento
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Backing up your container

To backup your data, configuration and logs, follow these simple steps:

#### Step 1: Stop the currently running container

```console
docker stop magento
```

Or using Docker Compose:

```console
docker-compose stop magento
```

#### Step 2: Run the backup command

We need to mount two volumes in a container we will use to create the backup: a directory on your host to store the backup in, and the volumes from the container we just stopped so we can access the data.

```console
docker run --rm -v /path/to/magento-backups:/backups --volumes-from magento busybox \
  cp -a /bitnami/magento /backups/latest
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

For the Magento container:

```diff
 $ docker run -d --name magento \
   ...
-  --volume /path/to/magento-persistence:/bitnami/magento \
+  --volume /path/to/magento-backups/latest:/bitnami/magento \
   bitnami/magento:latest
```

### Upgrade this image

Bitnami provides up-to-date versions of MariaDB and Magento, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the Magento application and bundled components (Apache, PHP...). For the MariaDB upgrade see: <https://github.com/bitnami/containers/tree/main/bitnami/mariadb#upgrade-this-image>

#### Upgrading the Magento application

Follow this guide to update the Magento version used in your running container image. Note that the below steps will not update any bundled image components such as Apache or PHP, to do this check the next section.

##### Step 1: Create a backup

Before following any of the below steps, [create a backup of your container](#backing-up-your-container) to avoid possible data loss, in case something goes wrong.

##### Step 2: Getting Magento authentication keys

In order to properly upgrade Magento, you will need Magento authentication keys that will be used to fetch the Magento updates. To obtain these keys, follow [this guide](https://devdocs.magento.com/guides/v2.4/install-gde/prereq/connect-auth.html).

##### Step 3: Preparing the Docker container for the upgrade

* Enter the container shell as the `root` user (e.g. `docker exec -u root ...`).

* Only if the container is running as `root` user, disable cron jobs and wait for any pending jobs to complete:

    ```console
    sed -i 's/^/#/' /etc/cron.d/magento
    ```

* Increase the PHP `memory_limit` to an apropriate value for the upgrade commands to work, such as `2G`:

    ```console
    sed -i 's/memory_limit = .*/memory_limit = 2G/' /opt/bitnami/php/etc/php.ini
    ```

* Backup `composer.json`:

    ```console
    cp /opt/bitnami/magento/composer.json /opt/bitnami/magento/composer.json.bak
    ```

##### Step 4: Update Magento to the desired version

* Only if the container is running as `root` user, login as the web server user before executing the below command:

    ```console
    su daemon -s /bin/bash
    ```

* To avoid user access to your Magento site while you are upgrading, enable maintenance mode:

    ```console
    magento maintenance:enable
    ```

* Update your Magento requirement to the new desired version in `composer.json`. At this point, you will be asked to provide credentials to access `repo.magento.com`. Enter the authentication keys obtained in Step 1.

    ```console
    cd /opt/bitnami/magento
    composer require magento/product-community-edition=VERSION --no-update
    ```

    > NOTE: Replace the `VERSION` placeholder with an appropriate value, i.e.: `2.4.1`

* Update your installation. You will also be asked to provide the same credentials provided in the previous step.

    ```console
    composer update
    ```

    > NOTE: If you see an error similar to this while executing the above command, you will need to increase the PHP `memory_limit` configuration to an even higher value.
    >
    > ```text
    > Fatal error: Allowed memory size of 21610612736 bytes exhausted
    > ```

* Clear the `var/` and `generated/` directories:

    ```console
    rm -rf /opt/bitnami/magento/var/cache/*
    rm -rf /opt/bitnami/magento/var/page_cache/*
    rm -rf /opt/bitnami/magento/generated/*
    ```

* Upgrade the Magento database schema:

    ```console
    magento setup:upgrade
    ```

* Finally, disable maintenance mode to complete the upgrade:

    ```console
    magento maintenance:disable
    ```

##### Step 5: Restart Docker container

Restart the Docker container to reset any configuration changes:

```console
docker stop magento
```

Or using Docker Compose:

```console
docker-compose stop magento
```

#### Upgrading bundled image components

Follow this guide to upgrade any bundled image components, such as Apache or PHP. Note that **Magento will not be updated** if you follow these steps.

##### Step 1: Get the updated image

```console
docker pull bitnami/magento:latest
```

##### Step 2: Stop the running container

Stop the currently running container using the command

```console
docker-compose stop magento
```

##### Step 3: Take a snapshot of the application state

Follow the steps in [Backing up your container](#backing-up-your-container) to take a snapshot of the current application state.

##### Step 4: Remove the currently running container

Remove the currently running container by executing the following command:

```console
docker-compose rm -v magento
```

##### Step 5: Run the new image

Update the image tag in `docker-compose.yml` and re-create your container with the new image:

```console
docker-compose up -d
```

## Customize this image

The Bitnami Magento Docker image is designed to be extended so it can be used as the base image for your custom web applications.

### Extend this image

Before extending this image, please note there are certain configuration settings you can modify using the original image:

* Settings that can be adapted using environment variables. For instance, you can change the ports used by Apache for HTTP and HTTPS, by setting the environment variables `APACHE_HTTP_PORT_NUMBER` and `APACHE_HTTPS_PORT_NUMBER` respectively.
* [Adding custom virtual hosts](https://github.com/bitnami/containers/blob/main/bitnami/apache#adding-custom-virtual-hosts).
* [Replacing the 'httpd.conf' file](https://github.com/bitnami/containers/blob/main/bitnami/apache#full-configuration).
* [Using custom SSL certificates](https://github.com/bitnami/containers/blob/main/bitnami/apache#using-custom-ssl-certificates).

If your desired customizations cannot be covered using the methods mentioned above, extend the image. To do so, create your own image using a Dockerfile with the format below:

```Dockerfile
FROM bitnami/magento
## Put your customizations below
...
```

Here is an example of extending the image with the following modifications:

* Install the `vim` editor
* Modify the Apache configuration file
* Modify the ports used by Apache

```Dockerfile
FROM bitnami/magento

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

Based on the extended image, you can update the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/magento/docker-compose.yml) file present in this repository to add other features:

```diff
   magento:
-    image: bitnami/magento:latest
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

## 2.4.1-debian-10-r80

* The size of the container image has been decreased.
* The configuration logic is now based on Bash scripts in the *rootfs/* folder.
* The Magento container now supports the "non-root" user approach, but it still runs as the `root` user by default. When running as a non-root user, all services will be run under the same user and Cron jobs will be disabled as crond requires to be run as a superuser. To run as a non-root user, change `USER root` to `USER 1001` in the Dockerfile, or specify `user: 1001` in `docker-compose.yml`. Related changes:
  * The HTTP/HTTPS ports exposed by the container are now `8080/8443` instead of `80/443`.
  * Backwards compatibility is not guaranteed when data is persisted using docker or docker-compose. We highly recommend migrating the Magento site by exporting its content, and importing it on a new Magento container.

## 2.3.5-debian-10-r57

* To avoid issues running custom plugins and themes, the container image has been modified to persist the entire Magento `htdocs` directory.  As a consecuence of this change, it is not possible to update the application by changing the image tag anymore, instead, it is needed to [follow the official update guide](https://devdocs.magento.com/guides/v2.3/comp-mgr/cli/cli-upgrade.html).

## 2.3.1-debian-9-r44 and 2.3.1-ol-7-r53

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
