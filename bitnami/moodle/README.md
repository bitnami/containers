# Bitnami LMS powered by Moodle&trade; LMS

> Moodle&trade; LMS is an open source online Learning Management System widely used at universities, schools, and corporations. It is modular and highly adaptable to any type of online learning.

[Overview of Bitnami LMS powered by Moodle&trade; LMS](https://moodle.org/)
Disclaimer: The respective trademarks mentioned in the offering are owned by the respective companies. We do not provide commercial license of any of these products. This listing has an open source license. Moodle(TM) LMS is run and maintained by Moodle HQ, that is a completely and separate project from Bitnami.

## <a id="tl-dr"></a> TL;DR

```console
docker run --name moodle bitnami/moodle:latest
```

**Warning**: This quick setup is only intended for development environments. You are encouraged to change the insecure default credentials and check out the available configuration options in the [Environment Variables](#environment-variables) section for a more secure deployment.

## <a id="why-use-bitnami-secure-images"></a> Why use Bitnami Secure Images?

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

## <a id="how-to-deploy-moodle&trade--in-kubernetes?"></a> How to deploy Moodle&trade; in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Chart for Moodle&trade; GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/moodle).

## <a id="supported-tags"></a> Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

## <a id="get-this-image"></a> Get this image

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

### <a id="run-the-application-using-docker-compose"></a> Run the application using Docker Compose

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/moodle).

## <a id="persisting-your-application"></a> Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami/moodle` path and another at `/bitnami/moodledata`. If the mounted directory is empty, it will be initialized on the first run. Additionally you should mount a volume for persistence of the [MariaDB data](https://github.com/bitnami/containers/blob/main/bitnami/mariadb#persisting-your-database).

To avoid inadvertent removal of volumes, you can mount host directories as data volumes. Alternatively you can make use of volume plugins to host the volume data.

## <a id="configuration"></a> Configuration

The following section describes the supported environment variables

### <a id="environment-variables"></a> Environment variables

The following tables list the main variables you can set.

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

When you start the Moodle&trade; image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line.

### <a id="examples"></a> Examples

#### SMTP configuration

The `MOODLE_SMTP_*` environment variables allows you configure the SMTP settings in the application. Please take a look at the environment variables information above for more information.

#### Load balancer

This would be an instance ready to be put behind the NGINX load balancer.

- Modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/moodle/docker-compose.yml) file present in this repository:

  ```yaml
  moodle:
    ...
    environment:
      - MOODLE_HOST=example.com
      - MOODLE_REVERSEPROXY=true
      - MOODLE_SSLPROXY=true
  ...
  ```

- For manual execution:

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

### <a id="installing-additional-language-packs"></a> Installing additional language packs

By default, this container packs a generic English version of Moodle&trade;. Nevertheless, more Language Packs can be added to the default configuration using the in-platform Administration [interface](https://docs.moodle.org/38/en/Language_packs#Language_pack_installation_and_uninstallation). In order to fully support a new Language Pack it is also a requirement to update the system's locales files. To do that, you have several options:

#### Build the default image with the `EXTRA_LOCALES` build-time variable

You can add extra locales using the `EXTRA_LOCALES` build-time variable when building the Docker image. The values must be separated by commas or semicolons (and optional spaces), and refer to entries in the `/usr/share/i18n/SUPPORTED` file inside the container.

#### Enable all supported locales using the `WITH_ALL_LOCALES` build-time variable

You can generate all supported locales by setting the build environment variable `WITH_ALL_LOCALES=yes`. Note that the generation of all the locales takes some time.

#### Extending the default image

Finally, you can [extend](https://github.com/bitnami/containers/blob/main/bitnami/moodle#extend-this-image) the default image and adding as many locales as needed:

```Dockerfile
FROM bitnami/moodle
RUN echo "es_ES.UTF-8 UTF-8" >> /etc/locale.gen && locale-gen
```

Bear in mind that in the example above `es_ES.UTF-8 UTF-8` is the locale needed for the desired Language Pack to install. You may change this value to the locale corresponding to your pack.

### <a id="fips-configuration"></a> FIPS configuration in Bitnami Secure Images

The Bitnami Bitnami LMS powered by Moodle&trade; LMS Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.

## <a id="logging"></a> Logging

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

## <a id="maintenance"></a> Maintenance

### <a id="backing-up-your-container"></a> Backing up your container

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

### <a id="restoring-a-backup"></a> Restoring a backup

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

## <a id="customize-this-image"></a> Customize this image

The Bitnami Docker image for Moodle&trade; is designed to be extended so it can be used as the base image for your custom web applications.

### <a id="extend-this-image"></a> Extend this image

Before extending this image, please note there are certain configuration settings you can modify using the original image:

- Settings that can be adapted using environment variables. For instance, you can change the ports used by Apache for HTTP and HTTPS, by setting the environment variables `APACHE_HTTP_PORT_NUMBER` and `APACHE_HTTPS_PORT_NUMBER` respectively.
- [Adding custom virtual hosts](https://github.com/bitnami/containers/blob/main/bitnami/apache#adding-custom-virtual-hosts).
- [Replacing the 'httpd.conf' file](https://github.com/bitnami/containers/blob/main/bitnami/apache#full-configuration).
- [Using custom SSL certificates](https://github.com/bitnami/containers/blob/main/bitnami/apache#using-custom-ssl-certificates).

If your desired customizations cannot be covered using the methods mentioned above, extend the image. To do so, create your own image using a Dockerfile with the format below:

```Dockerfile
FROM bitnami/moodle
## <a id="put-your-customizations-below"></a> Put your customizations below
...
```

Here is an example of extending the image with the following modifications:

- Install the `vim` editor
- Modify the Apache configuration file
- Modify the ports used by Apache

```Dockerfile
FROM bitnami/moodle

## <a id="install-'vim'"></a> Install 'vim'
RUN install_packages vim

## <a id="enable-mod_ratelimit-module"></a> Enable mod_ratelimit module
RUN sed -i -r 's/#LoadModule ratelimit_module/LoadModule ratelimit_module/' /opt/bitnami/apache/conf/httpd.conf

## <a id="modify-the-ports-used-by-apache-by-default"></a> Modify the ports used by Apache by default
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
-      - 80:8080
-      - 443:8443
+      - 80:8181
+      - 443:8143
     environment:
       ...
+      - PHP_MEMORY_LIMIT=512m
     ...
```

## <a id="notable-changes"></a> Notable Changes

## 3.9.0-debian-10-r17

- The size of the container image has been decreased.
- The configuration logic is now based on Bash scripts in the *rootfs/* folder.
- The Moodle&trade; container now supports the "non-root" user approach, but it still runs as the `root` user by default. When running as a non-root user, all services will be run under the same user and Cron jobs will be disabled as crond requires to be run as a superuser. To run as a non-root user, change `USER root` to `USER 1001` in the Dockerfile, or specify `user: 1001` in `docker-compose.yml`. Related changes:
  - The HTTP/HTTPS ports exposed by the container are now `8080/8443` instead of `80/443`.
  - Backwards compatibility is not guaranteed when data is persisted using docker or docker-compose. We highly recommend migrating the Moodle&trade; site by exporting its content, and importing it on a new Moodle&trade; container.

## 3.7.1-debian-9-r38 and 3.7.1-ol-7-r40

- It is now possible to use existing Moodle&trade; databases from other installations. In order to do this, use the environment variable `MOODLE_SKIP_INSTALL`, which forces the container not to run the initial Moodle&trade; setup wizard.

## 3.7.0-debian-9-r12 and 3.7.0-ol-7-r13

- This image has been adapted so it's easier to customize. See the [Customize this image](#customize-this-image) section for more information.
- The Apache configuration volume (`/bitnami/apache`) has been deprecated, and support for this feature will be dropped in the near future. Until then, the container will enable the Apache configuration from that volume if it exists. By default, and if the configuration volume does not exist, the configuration files will be regenerated each time the container is created. Users wanting to apply custom Apache configuration files are advised to mount a volume for the configuration at `/opt/bitnami/apache/conf`, or mount specific configuration files individually.
- The PHP configuration volume (`/bitnami/php`) has been deprecated, and support for this feature will be dropped in the near future. Until then, the container will enable the PHP configuration from that volume if it exists. By default, and if the configuration volume does not exist, the configuration files will be regenerated each time the container is created. Users wanting to apply custom PHP configuration files are advised to mount a volume for the configuration at `/opt/bitnami/php/conf`, or mount specific configuration files individually.
- Enabling custom Apache certificates by placing them at `/opt/bitnami/apache/certs` has been deprecated, and support for this functionality will be dropped in the near future. Users wanting to enable custom certificates are advised to mount their certificate files on top of the preconfigured ones at `/certs`.

## <a id="license"></a> License

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
