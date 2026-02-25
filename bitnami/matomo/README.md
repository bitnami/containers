# Bitnami Secure Image for Matomo

## What is Matomo?

> Matomo, formerly known as Piwik, is a real time web analytics program. It provides detailed reports on website visitors.

[Overview of Matomo](https://matomo.org/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name matomo bitnami/matomo:latest
```

**Warning**: This quick setup is only intended for development environments. You are encouraged to change the insecure default credentials and check out the available configuration options in the [Environment Variables](#environment-variables) section for a more secure d
eployment.

## Why use Bitnami Secure Images?

Those are hardened, minimal CVE images built and maintained by Bitnami. Bitnami Secure Images are based on the cloud-optimized, security-hardened enterprise [OS Photon Linux](https://vmware.github.io/photon/). Why choose BSI images?

- Hardened secure images of popular open source software with Near-Zero Vulnerabilities
- Vulnerability Triage & Prioritization with VEX Statements, KEV and EPSS Scores
- Compliance focus with FIPS, STIG, and air-gap options, including secure bill of materials (SBOM)
- Software supply chain provenance attestation through in-toto
- First class support for the internet’s favorite Helm charts

Each image comes with valuable security metadata. You can view the metadata in [our public catalog here](https://app-catalog.vmware.com/bitnami/apps). Note: Some data is only available with [commercial subscriptions to BSI](https://bitnami.com/).

![Alt text](https://github.com/bitnami/containers/blob/main/BSI%20UI%201.png?raw=true "Application details")
![Alt text](https://github.com/bitnami/containers/blob/main/BSI%20UI%202.png?raw=true "Packaging report")

If you are looking for our previous generation of images based on Debian Linux, please see the [Bitnami Legacy registry](https://hub.docker.com/u/bitnamilegacy).

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

## How to get this image

The recommended way to get the Bitnami Matomo Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/matomo/).
To use a specific version, you can pull a versioned tag. Find the [list of available versions] (<https://hub.docker.com/r/bitnami/matomo/tags/>) in the Docker Hub Registry.

```console
docker pull bitnami/matomo:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## How to use this image

Matomo requires access to a MySQL database or MariaDB database to store information. It uses our [MariaDB image] (<https://github.com/bitnami/containers/blob/main/bitnami/mariadb>) for the database requirements.

### Run the application using Docker Compose

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/matomo).

### Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a volume at the `/bitnami` path. Additionally you should mount a volume for [persistence of the MariaDB data](https://github.com/bitnami/containers/blob/main/bitnami/mariadb#persisting-your-database).

The above examples define docker volumes namely `mariadb_data` and `matomo_data`. The Matomo application state will persist as long as these volumes are not removed.

To avoid inadvertent removal of these volumes you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

## Configuration

### Environment variables

#### Customizable environment variables

| Name                                   | Description                                                                                                                                                                           | Default Value                   |
|----------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------|
| `MATOMO_DATA_TO_PERSIST`               | Files to persist relative to the Matomo installation directory. To provide multiple values, separate them with a whitespace.                                                          | `$MATOMO_BASE_DIR`              |
| `MATOMO_EXCLUDED_DATA_FROM_UPDATE`     | Files to exclude from being updated relative to the Matomo installation directory (same as config.ini.php). To provide multiple values, separate them with a whitespace. No defaults. | `nil`                           |
| `MATOMO_SKIP_BOOTSTRAP`                | Whether to perform initial bootstrapping for the application.                                                                                                                         | `nil`                           |
| `MATOMO_PROXY_HOST_HEADER`             | Specify the host IP HTTP Header. Usually HTTP_X_FORWARDED_HOST. No defaults.                                                                                                          | `nil`                           |
| `MATOMO_PROXY_CLIENT_HEADER`           | Specify the client IP HTTP Header. Usually HTTP_X_FORWARDED_FOR.                                                                                                                      | `nil`                           |
| `MATOMO_ENABLE_ASSUME_SECURE_PROTOCOL` | Enable assume_secure_protocol in Matomo configuration file.                                                                                                                           | `no`                            |
| `MATOMO_ENABLE_FORCE_SSL`              | Enable force_ssl in Matomo configuration file.                                                                                                                                        | `no`                            |
| `MATOMO_ENABLE_PROXY_URI_HEADER`       | Enable proxy_uri_header in Matomo configuration file.                                                                                                                                 | `no`                            |
| `MATOMO_USERNAME`                      | Matomo user name.                                                                                                                                                                     | `user`                          |
| `MATOMO_PASSWORD`                      | Matomo user password.                                                                                                                                                                 | `bitnami`                       |
| `MATOMO_EMAIL`                         | Matomo user e-mail address.                                                                                                                                                           | `user@example.com`              |
| `MATOMO_HOST`                          | Name of a website to track in Matomo.                                                                                                                                                 | `127.0.0.1`                     |
| `MATOMO_WEBSITE_NAME`                  | Name of a website to track in Matomo.                                                                                                                                                 | `example`                       |
| `MATOMO_WEBSITE_HOST`                  | Website host or domain to track in Matomo.                                                                                                                                            | `https://example.org`           |
| `MATOMO_ENABLE_TRUSTED_HOST_CHECK`     | Enable trusted host check.                                                                                                                                                            | `no`                            |
| `MATOMO_ENABLE_DATABASE_SSL`           | Whether to enable SSL for database connections in the Matomo configuration file.                                                                                                      | `no`                            |
| `MATOMO_DATABASE_SSL_CA_FILE`          | Path to the database server CA bundle file.                                                                                                                                           | `nil`                           |
| `MATOMO_DATABASE_SSL_CERT_FILE`        | Path to the database client certificate file.                                                                                                                                         | `nil`                           |
| `MATOMO_DATABASE_SSL_KEY_FILE`         | Path to the database client certificate key                                                                                                                                           | `nil`                           |
| `MATOMO_VERIFY_DATABASE_SSL`           | Whether to verify the database SSL certificate when SSL is enabled                                                                                                                    | `yes`                           |
| `MATOMO_SMTP_HOST`                     | Matomo SMTP server host.                                                                                                                                                              | `nil`                           |
| `MATOMO_SMTP_PORT_NUMBER`              | Matomo SMTP server port number.                                                                                                                                                       | `nil`                           |
| `MATOMO_SMTP_USER`                     | Matomo SMTP server user.                                                                                                                                                              | `nil`                           |
| `MATOMO_SMTP_PASSWORD`                 | Matomo SMTP server user password.                                                                                                                                                     | `nil`                           |
| `MATOMO_SMTP_AUTH`                     | Matomo SMTP server auth type (Plain, Login or Cram-md5)                                                                                                                               | `nil`                           |
| `MATOMO_SMTP_PROTOCOL`                 | Matomo SMTP server protocol to use.                                                                                                                                                   | `nil`                           |
| `MATOMO_NOREPLY_NAME`                  | Matomo noreply name.                                                                                                                                                                  | `nil`                           |
| `MATOMO_NOREPLY_ADDRESS`               | Matomo noreply address.                                                                                                                                                               | `nil`                           |
| `MATOMO_DATABASE_HOST`                 | Database server host.                                                                                                                                                                 | `$MATOMO_DEFAULT_DATABASE_HOST` |
| `MATOMO_DATABASE_PORT_NUMBER`          | Database server port.                                                                                                                                                                 | `3306`                          |
| `MATOMO_DATABASE_NAME`                 | Database name.                                                                                                                                                                        | `bitnami_matomo`                |
| `MATOMO_DATABASE_USER`                 | Database user name.                                                                                                                                                                   | `bn_matomo`                     |
| `MATOMO_DATABASE_PASSWORD`             | Database user password.                                                                                                                                                               | `nil`                           |
| `MATOMO_DATABASE_TABLE_PREFIX`         | Database table prefix.                                                                                                                                                                | `matomo_`                       |

#### Read-only environment variables

| Name                           | Description                                       | Value                               |
|--------------------------------|---------------------------------------------------|-------------------------------------|
| `MATOMO_BASE_DIR`              | Matomo installation directory.                    | `${BITNAMI_ROOT_DIR}/matomo`        |
| `MATOMO_CONF_DIR`              | Configuration dir for Matomo.                     | `${MATOMO_BASE_DIR}/config`         |
| `MATOMO_CONF_FILE`             | Configuration file for Matomo.                    | `${MATOMO_CONF_DIR}/config.ini.php` |
| `MATOMO_VOLUME_DIR`            | Matomo directory for mounted configuration files. | `${BITNAMI_VOLUME_DIR}/matomo`      |
| `MATOMO_DEFAULT_DATABASE_HOST` | Default database server host.                     | `mariadb`                           |
| `PHP_DEFAULT_MEMORY_LIMIT`     | Default PHP memory limit.                         | `256M`                              |

When you start the Matomo image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line.

#### Reverse proxy configuration example

This would be an example of reverse proxy configuration:

- Modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/matomo/docker-compose.yml) file present in this repository:

```yaml
  application:
  ...
    environment:
      - MATOMO_PROXY_CLIENT_HEADER=HTTP_X_FORWARDED_FOR
      - MATOMO_ENABLE_FORCE_SSL=yes
      - MATOMO_ENABLE_ASSUME_SECURE_PROTOCOL=yes
  ...
```

- For manual execution:

```console
 $ docker run -d --name matomo -p 80:80 -p 443:443 \
   --net matomo_network \
   -e MARIADB_HOST=mariadb \
   -e MARIADB_PORT_NUMBER=3306 \
   -e MATOMO_DATABASE_USER=bn_matomo \
   -e MATOMO_DATABASE_NAME=bitnami_matomo \
   -e MATOMO_PROXY_CLIENT_HEADER=HTTP_X_FORWARDED_FOR \
   -e MATOMO_ENABLE_FORCE_SSL=yes \
   -e MATOMO_ENABLE_ASSUME_SECURE_PROTOCOL=yes \
   -v /your/local/path/bitnami/matomo:/bitnami \
 bitnami/matomo:latest
```

#### SMTP configuration

The `MATOMO_SMTP_*` environment variables allows you configure the SMTP settings in the application. Please take a look at the environment variables information above for more information.

### Backing up your container

To backup your data, configuration and logs, follow these simple steps:

#### Step 1: Stop the currently running container

```console
docker stop matomo
```

Or using Docker Compose:

```console
docker-compose stop matomo
```

#### Step 2: Run the backup command

We need to mount two volumes in a container we will use to create the backup: a directory on your host to store the backup in, and the volumes from the container we just stopped so we can access the data.

```console
docker run --rm -v /path/to/matomo-backups:/backups --volumes-from matomo busybox \
  cp -a /bitnami/matomo /backups/latest
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

For the Matomo container:

```diff
 $ docker run -d --name matomo \
   ...
-  --volume /path/to/matomo-persistence:/bitnami/matomo \
+  --volume /path/to/matomo-backups/latest:/bitnami/matomo \
   bitnami/matomo:latest
```

## Upgrading Matomo

Bitnami provides up-to-date versions of MariaDB and Matomo, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the Matomo container. For the MariaDB upgrade you can take a look at <https://github.com/bitnami/containers/tree/main/bitnami/mariadb#upgrade-this-image>

1. Get the updated images:

    ```console
    docker pull bitnami/matomo:latest
    ```

2. Stop your container

    - For docker-compose: `$ docker-compose stop matomo`
    - For manual execution: `$ docker stop matomo`

3. Take a snapshot of the application state

    ```console
    rsync -a /path/to/matomo-persistence /path/to/matomo-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
    ```

    Additionally, [snapshot the MariaDB data](https://github.com/bitnami/containers/blob/main/bitnami/mariadb#step-2-stop-and-backup-the-currently-running-container)

    You can use these snapshots to restore the application state should the upgrade fail.

4. Remove the currently running container

    - For docker-compose: `$ docker-compose rm -v matomo`
    - For manual execution: `$ docker rm -v matomo`

5. Run the new image

    - For docker-compose: `$ docker-compose up matomo`
    - For manual execution (mount the directories if needed): `docker run --name matomo bitnami/matomo:latest`

### FIPS configuration in Bitnami Secure Images

The Bitnami Matomo Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.

## Customize this image

The Bitnami Matomo Docker image is designed to be extended so it can be used as the base image for your custom web applications.

### Extend this image

Before extending this image, please note there are certain configuration settings you can modify using the original image:

- Settings that can be adapted using environment variables. For instance, you can change the ports used by Apache for HTTP and HTTPS, by setting the environment variables `APACHE_HTTP_PORT_NUMBER` and `APACHE_HTTPS_PORT_NUMBER` respectively.
- [Adding custom virtual hosts](https://github.com/bitnami/containers/blob/main/bitnami/apache#adding-custom-virtual-hosts).
- [Replacing the 'httpd.conf' file](https://github.com/bitnami/containers/blob/main/bitnami/apache#full-configuration).
- [Using custom SSL certificates](https://github.com/bitnami/containers/blob/main/bitnami/apache#using-custom-ssl-certificates).

If your desired customizations cannot be covered using the methods mentioned above, extend the image. To do so, create your own image using a Dockerfile with the format below:

```Dockerfile
FROM bitnami/matomo
### Put your customizations below
...
```

## Notable Changes

## 4.15.0-debian-11-r20

From this version on, all Matomo files are persisted (MATOMO_DATA_TO_PERSIST env var). During the upgrade process, they will be replaced (except the config.ini.php file) as suggested in [the official documentation](https://matomo.org/faq/on-premise/update-matomo/#the-manual-three-step-update)

### 3.14.1-debian-10-r82

- The size of the container image has been decreased.
- The configuration logic is now based on Bash scripts in the *rootfs/* folder.
- The Matomo container image has been migrated to a "non-root" user approach. Previously the container ran as the `root` user and the Apache daemon was started as the `daemon` user. From now on, both the container and the Apache daemon run as user `1001`. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile, or `user: root` in `docker-compose.yml`. Consequences:
  - The HTTP/HTTPS ports exposed by the container are now `8080/8443` instead of `80/443`.
  - Backwards compatibility is not guaranteed when data is persisted using docker or docker-compose. We highly recommend migrating the Matomo site by exporting its content, and importing it on a new Matomo container. Follow the steps in [Backing up your container](#backing-up-your-container) and [Restoring a backup](#restoring-a-backup) to migrate the data between the old and new container.

To upgrade a previous Bitnami Matomo container image, which did not support non-root, the easiest way is to start the new image as a root user and updating the port numbers. Modify your docker-compose.yml file as follows:

```diff
       - ALLOW_EMPTY_PASSWORD=yes
+    user: root
     ports:
-      - 80:80
-      - 443:443
+      - 80:8080
+      - 443:8443
     volumes:
```

### 3.9.1-debian-9-r51 and 3.9.1-ol-7-r62

- This image has been adapted so it's easier to customize. See the [Customize this image](#customize-this-image) section for more information.
- The Apache configuration volume (`/bitnami/apache`) has been deprecated, and support for this feature will be dropped in the near future. Until then, the container will enable the Apache configuration from that volume if it exists. By default, and if the configuration volume does not exist, the configuration files will be regenerated each time the container is created. Users wanting to apply custom Apache configuration files are advised to mount a volume for the configuration at `/opt/bitnami/apache/conf`, or mount specific configuration files individually.
- The PHP configuration volume (`/bitnami/php`) has been deprecated, and support for this feature will be dropped in the near future. Until then, the container will enable the PHP configuration from that volume if it exists. By default, and if the configuration volume does not exist, the configuration files will be regenerated each time the container is created. Users wanting to apply custom PHP configuration files are advised to mount a volume for the configuration at `/opt/bitnami/php/conf`, or mount specific configuration files individually.
- Enabling custom Apache certificates by placing them at `/opt/bitnami/apache/certs` has been deprecated, and support for this functionality will be dropped in the near future. Users wanting to enable custom certificates are advised to mount their certificate files on top of the preconfigured ones at `/certs`.

## License

Copyright &copy; 2026 Broadcom. The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
