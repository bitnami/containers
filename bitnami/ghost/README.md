# Bitnami Secure Image for Ghost

## What is Ghost?

> Ghost is an open source publishing platform designed to create blogs, magazines, and news sites. It includes a simple markdown editor with preview, theming, and SEO built-in to simplify editing.

[Overview of Ghost](https://ghost.org/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name ghost bitnami/ghost:latest
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

## How to deploy Ghost in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Ghost Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/ghost).

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

## Get this image

The recommended way to get the Bitnami Ghost Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/ghost).

```console
docker pull bitnami/ghost:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/ghost/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/ghost:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## How to use this image

Ghost requires access to a MySQL or MariaDB database to store information. We'll use the [Bitnami Docker Image for MySQL](https://github.com/bitnami/containers/tree/main/bitnami/mysql) for the database requirements.

### Run the application using Docker Compose

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/ghost).

## Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami/ghost` path. If the mounted directory is empty, it will be initialized on the first run. Additionally you should [mount a volume for persistence of the MySQL data](https://github.com/bitnami/containers/blob/main/bitnami/mysql#persisting-your-database).

The above examples define the Docker volumes named `mysql_data` and `ghost_data`. The Ghost application state will persist as long as volumes are not removed.

To avoid inadvertent removal of volumes, you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

## Configuration

### Environment variables

#### Customizable environment variables

| Name                               | Description                                                                                                                 | Default Value                    |
|------------------------------------|-----------------------------------------------------------------------------------------------------------------------------|----------------------------------|
| `GHOST_DATA_TO_PERSIST`            | Files to persist relative to the Ghost installation directory. To provide multiple values, separate them with a whitespace. | `content config.production.json` |
| `GHOST_ENABLE_HTTPS`               | Whether to enable HTTPS for Ghost by default.                                                                               | `no`                             |
| `GHOST_EXTERNAL_HTTP_PORT_NUMBER`  | External HTTP port for Ghost.                                                                                               | `80`                             |
| `GHOST_EXTERNAL_HTTPS_PORT_NUMBER` | External HTTPS port for Ghost.                                                                                              | `443`                            |
| `GHOST_HOST`                       | Ghost host name.                                                                                                            | `localhost`                      |
| `GHOST_PORT_NUMBER`                | Port number in which Ghost will run.                                                                                        | `nil`                            |
| `GHOST_BLOG_TITLE`                 | Ghost blog title.                                                                                                           | `"User's blog"`                  |
| `GHOST_SKIP_BOOTSTRAP`             | Whether to perform initial bootstrapping for the application.                                                               | `nil`                            |
| `GHOST_USERNAME`                   | Ghost user name.                                                                                                            | `user`                           |
| `GHOST_PASSWORD`                   | Ghost user password.                                                                                                        | `bitnami123`                     |
| `GHOST_EMAIL`                      | Ghost user e-mail address.                                                                                                  | `user@example.com`               |
| `GHOST_SMTP_FROM_ADDRESS`          | Ghost SMTP from address.                                                                                                    | `nil`                            |
| `GHOST_SMTP_HOST`                  | Ghost SMTP server host.                                                                                                     | `nil`                            |
| `GHOST_SMTP_PORT_NUMBER`           | Ghost SMTP server port number.                                                                                              | `nil`                            |
| `GHOST_SMTP_USER`                  | Ghost SMTP server user.                                                                                                     | `nil`                            |
| `GHOST_SMTP_PASSWORD`              | Ghost SMTP server user password.                                                                                            | `nil`                            |
| `GHOST_SMTP_PROTOCOL`              | Ghost SMTP server protocol to use.                                                                                          | `nil`                            |
| `GHOST_DATABASE_HOST`              | Database server host.                                                                                                       | `$GHOST_DEFAULT_DATABASE_HOST`   |
| `GHOST_DATABASE_PORT_NUMBER`       | Database server port.                                                                                                       | `3306`                           |
| `GHOST_DATABASE_NAME`              | Database name.                                                                                                              | `bitnami_ghost`                  |
| `GHOST_DATABASE_USER`              | Database user name.                                                                                                         | `bn_ghost`                       |
| `GHOST_DATABASE_PASSWORD`          | Database user password.                                                                                                     | `nil`                            |
| `GHOST_DATABASE_ENABLE_SSL`        | Whether to enable SSL for database connection                                                                               | `no`                             |
| `GHOST_DATABASE_SSL_CA_FILE`       | Path to the database SSL CA file                                                                                            | `nil`                            |

#### Read-only environment variables

| Name                          | Description                                        | Value                                      |
|-------------------------------|----------------------------------------------------|--------------------------------------------|
| `GHOST_BASE_DIR`              | Ghost installation directory.                      | `${BITNAMI_ROOT_DIR}/ghost`                |
| `GHOST_BIN_DIR`               | Ghost bin directory.                               | `${GHOST_BASE_DIR}/bin`                    |
| `GHOST_LOG_FILE`              | Ghost log file.                                    | `${GHOST_BASE_DIR}/content/logs/ghost.log` |
| `GHOST_CONF_FILE`             | Configuration file for Ghost.                      | `${GHOST_BASE_DIR}/config.production.json` |
| `GHOST_PID_FILE`              | Path to the Ghost PID file.                        | `${GHOST_BASE_DIR}/.ghostpid`              |
| `GHOST_VOLUME_DIR`            | Ghost directory for mounted configuration files.   | `${BITNAMI_VOLUME_DIR}/ghost`              |
| `GHOST_DAEMON_USER`           | Ghost system user.                                 | `ghost`                                    |
| `GHOST_DAEMON_GROUP`          | Ghost system group.                                | `ghost`                                    |
| `GHOST_DEFAULT_PORT_NUMBER`   | Default Ghost port number to enable at build time. | `2368`                                     |
| `GHOST_DEFAULT_DATABASE_HOST` | Default database server host.                      | `mysql`                                    |

When you start the Ghost image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line.

#### Examples

##### SMTP configuration

The `GHOST_SMTP_*` environment variables allows you configure the SMTP settings in the application. Please take a look at the environment variables information above for more information.

##### Connect Ghost container to an existing database

The Bitnami Ghost container supports connecting the Ghost application to an external database. In case the database already contains data from a previous Ghost installation, you need to set the variable `GHOST_SKIP_BOOTSTRAP` to `yes`. Otherwise, the container would execute the installation wizard and could modify the existing data in the database. Note that, when setting `GHOST_SKIP_BOOTSTRAP` to `yes`, values for environment variables such as `GHOST_USERNAME`, `GHOST_PASSWORD` or `GHOST_EMAIL` will be ignored.

### FIPS configuration in Bitnami Secure Images

The Bitnami Ghost Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.

## Logging

The Bitnami Ghost Docker image sends the container logs to `stdout`. To view the logs:

```console
docker logs ghost
```

Or using Docker Compose:

```console
docker-compose logs ghost
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Backing up your container

To backup your data, configuration and logs, follow these simple steps:

#### Step 1: Stop the currently running container

```console
docker stop ghost
```

Or using Docker Compose:

```console
docker-compose stop ghost
```

#### Step 2: Run the backup command

We need to mount two volumes in a container we will use to create the backup: a directory on your host to store the backup in, and the volumes from the container we just stopped so we can access the data.

```console
docker run --rm -v /path/to/ghost-backups:/backups --volumes-from ghost busybox \
  cp -a /bitnami/ghost /backups/latest
```

### Restoring a backup

Restoring a backup is as simple as mounting the backup as volumes in the containers.

For the MySQL database container:

```diff
 $ docker run -d --name mysql \
   ...
-  --volume /path/to/mysql-persistence:/bitnami/mysql \
+  --volume /path/to/mysql-backups/latest:/bitnami/mysql \
   bitnami/mysql:latest
```

For the Ghost container:

```diff
 $ docker run -d --name ghost \
   ...
-  --volume /path/to/ghost-persistence:/bitnami/ghost \
+  --volume /path/to/ghost-backups/latest:/bitnami/ghost \
   bitnami/ghost:latest
```

## Customize this image

The Bitnami Ghost Docker image is designed to be extended so it can be used as the base image for your custom web applications.

### Extend this image

To do so, create your own image using a Dockerfile with the format below:

```Dockerfile
FROM bitnami/ghost
## Put your customizations below
...
```

This example shows how to install the [Storage Adapter for S3](https://github.com/colinmeinke/ghost-storage-adapter-s3#ghost-storage-adapter-s3).

```Dockerfile
FROM bitnami/ghost:latest

## Change user to perform privileged actions
USER root

COPY post_ghost_config.sh /
RUN mkdir -p /.npm \
    && chmod -R g+rwX,o+rw /.npm \
    && chmod +x /post_ghost_config.sh \
    && cp /opt/bitnami/scripts/ghost/entrypoint.sh /tmp/entrypoint.sh \
    && sed '/info "\*\* Ghost setup finished! \*\*"/ a . /post_ghost_config.sh' /tmp/entrypoint.sh > /opt/bitnami/scripts/ghost/entrypoint.sh
ENV AWS_ACCESS_KEY_ID="AWS_ACCESS_KEY_ID" \
    AWS_ACCESS_SECRET_KEY="AWS_ACCESS_SECRET_KEY" \
    AWS_REGION="AWS_REGION" \
    AWS_BUCKET="AWS_BUCKET"

## Revert to the original non-root user
USER 1001

RUN cd /bitnami/ghost \
    && npm i --silent ghost-storage-adapter-s3 \
    && mkdir -p /opt/bitnami/ghost/content/adapters/storage/s3 \
    && cp -r ./node_modules/ghost-storage-adapter-s3/* /opt/bitnami/ghost/content/adapters/storage/s3/
```

1. Prepare npm and install an adapter.
2. Add configuration for the adapter.

#### Create a script named `post_ghost_config.sh` using `jq` for adding configuration to the `config.production.json`

```console
#!/bin/bash -e
cp /opt/bitnami/ghost/config.production.json /tmp/config.tmp.json

jq -r --arg keyId $AWS_ACCESS_KEY_ID --arg accessKey $AWS_ACCESS_SECRET_KEY --arg region $AWS_REGION --arg bucket $AWS_BUCKET \
    '. + { storage: { active: "s3", s3: { accessKeyId: $keyId, secretAccessKey: $accessKey, region: $region, bucket: $bucket } } }' \
    /tmp/config.tmp.json > /opt/bitnami/ghost/config.production.json
```

**Add it to the `app-entrypoint.sh` just after ghost is configured.**

Finally, build the container and set the required environment variables to configure the adapter.

## Notable Changes

### 3.42.5-debian-10-r67 and 4.8.4-debian-10-r7

- The size of the container image has been decreased.
- The configuration logic is now based on Bash scripts in the *rootfs/* folder.
- It is now possible to import existing Ghost databases from other installations. In order to do this, use the environment variable `GHOST_SKIP_BOOTSTRAP`, which forces the container not to run the initial Ghost setup wizard.

### 0.11.10-r2

- The ghost container has been migrated to a non-root container approach. Previously the container run as `root` user and the ghost daemon was started as `ghost` user. From now own, both the container and the ghost daemon run as user `1001`. As a consequence, the configuration files are writable by the user running the ghost process.

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
