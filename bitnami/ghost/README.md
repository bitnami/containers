# Ghost packaged by Bitnami

## What is Ghost?

> Ghost is an open source publishing platform designed to create blogs, magazines, and news sites. It includes a simple markdown editor with preview, theming, and SEO built-in to simplify editing.

[Overview of Ghost](https://ghost.org/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/containers/main/bitnami/ghost/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

**Warning**: This quick setup is only intended for development environments. You are encouraged to change the insecure default credentials and check out the available configuration options in the [Environment Variables](#environment-variables) section for a more secure deployment.

## Why use Bitnami Images?

- Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
- With Bitnami images the latest bug fixes and features are available as soon as possible.
- Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
- All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
- All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
- Bitnami container images are released on a regular basis with the latest distribution packages available.

# How to deploy Ghost in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Ghost Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/ghost).

Bitnami containers can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami Ghost Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/ghost).

```console
$ docker pull bitnami/ghost:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/ghost/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/ghost:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
$ git clone https://github.com/bitnami/containers.git
$ cd bitnami/APP/VERSION/OPERATING-SYSTEM
$ docker build -t bitnami/APP:latest .
```

## How to use this image

Ghost requires access to a MySQL or MariaDB database to store information. We'll use the [Bitnami Docker Image for MySQL](https://github.com/bitnami/containers/tree/main/bitnami/mysql) for the database requirements.

### Run the application using Docker Compose

The main folder of this repository contains a functional [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/ghost/docker-compose.yml) file. Run the application using it as shown below:

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/containers/main/bitnami/ghost/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

### Using the Docker Command Line

If you want to run the application manually instead of using `docker-compose`, these are the basic steps you need to run:

#### Step 1: Create a network

```console
$ docker network create ghost-network
```

#### Step 2: Create a volume for MySQL persistence and create a MySQL container

```console
$ docker volume create --name mysql_data
$ docker run -d --name mysql \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env MYSQL_USER=bn_ghost \
  --env MYSQL_PASSWORD=bitnami \
  --env MYSQL_DATABASE=bitnami_ghost \
  --network ghost-network \
  --volume mysql_data:/bitnami/mysql \
  bitnami/mysql:latest
```

#### Step 3: Create volumes for Ghost persistence and launch the container

```console
$ docker volume create --name ghost_data
$ docker run -d --name ghost \
  -p 8080:8080 -p 8443:8443 \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env GHOST_DATABASE_USER=bn_ghost \
  --env GHOST_DATABASE_PASSWORD=bitnami \
  --env GHOST_DATABASE_NAME=bitnami_ghost \
  --network ghost-network \
  --volume ghost_data:/bitnami/ghost \
  bitnami/ghost:latest
```

Access your application at `http://your-ip/`

## Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami/ghost` path. If the mounted directory is empty, it will be initialized on the first run. Additionally you should [mount a volume for persistence of the MySQL data](https://github.com/bitnami/containers/blob/main/bitnami/mysql#persisting-your-database).

The above examples define the Docker volumes named `mysql_data` and `ghost_data`. The Ghost application state will persist as long as volumes are not removed.

To avoid inadvertent removal of volumes, you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

### Mount host directories as data volumes with Docker Compose

This requires a minor change to the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/ghost/docker-compose.yml) file present in this repository:

```diff
   mysql:
     ...
     volumes:
-      - 'mysql_data:/bitnami/mysql'
+      - /path/to/mysql-persistence:/bitnami/mysql
   ...
   ghost:
     ...
     volumes:
-      - 'ghost_data:/bitnami/ghost'
+      - /path/to/ghost-persistence:/bitnami/ghost
   ...
-volumes:
-  mysql_data:
-    driver: local
-  ghost_data:
-    driver: local
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

### Mount host directories as data volumes using the Docker command line

#### Step 1: Create a network (if it does not exist)

```console
$ docker network create ghost-network
```

#### Step 2. Create a MySQL container with host volume

```console
$ docker run -d --name mysql \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env MYSQL_USER=bn_ghost \
  --env MYSQL_PASSWORD=bitnami \
  --env MYSQL_DATABASE=bitnami_ghost \
  --network ghost-network \
  --volume /path/to/mysql-persistence:/bitnami/mysql \
  bitnami/mysql:latest
```

#### Step 3. Create the Ghost container with host volumes

```console
$ docker run -d --name ghost \
  -p 8080:8080 -p 8443:8443 \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env GHOST_DATABASE_USER=bn_ghost \
  --env GHOST_DATABASE_PASSWORD=bitnami \
  --env GHOST_DATABASE_NAME=bitnami_ghost \
  --network ghost-network \
  --volume /path/to/ghost-persistence:/bitnami/ghost \
  bitnami/ghost:latest
```

## Configuration

### Environment variables

When you start the Ghost image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line. If you want to add a new environment variable:

- For docker-compose add the variable name and value under the application section in the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/ghost/docker-compose.yml) file present in this repository:

    ```yaml
    ghost:
      ...
      environment:
        - GHOST_PASSWORD=my_password
      ...
    ```

- For manual execution add a `--env` option with each variable and value:

    ```console
    $ docker run -d --name ghost -p 80:8080 -p 443:8443 \
      --env GHOST_PASSWORD=my_password \
      --network ghost-tier \
      --volume /path/to/ghost-persistence:/bitnami/ghost \
      bitnami/ghost:latest
    ```

Available environment variables:

##### User and Site configuration

- `GHOST_USERNAME`: Ghost application username. Default: **user**
- `GHOST_PASSWORD`: Ghost application password. Default: **bitnami123**
- `GHOST_EMAIL`: Ghost application email. Default: **user@example.com**
- `GHOST_BLOG_TITLE`: Ghost blog name. Default: **User's blog**
- `GHOST_HOST`: Hostname used by Ghost to form URLs. Default: **localhost**
- `GHOST_PORT_NUMBER`: Port used by Ghost to listen for connections. Default: **2368**
- `GHOST_ENABLE_HTTPS`: Enable serving Ghost through HTTPS instead of HTTP. Default: **no**
- `GHOST_EXTERNAL_HTTP_PORT_NUMBER`: Port to used by Ghost to generate URLs and links when accessing using HTTP. Default: **80**
- `GHOST_EXTERNAL_HTTPS_PORT_NUMBER`: Port to used by Ghost to generate URLs and links when accessing using HTTPS. Default: **443**
- `GHOST_SKIP_BOOTSTRAP`: Whether to skip performing the initial bootstrapping for the application. This is necessary in case you use a database that already has Ghost data. Default: **no**

##### Database connection configuration

- `GHOST_DATABASE_HOST`: Hostname for the MariaDB or MySQL server. Default: **mysql**
- `GHOST_DATABASE_PORT_NUMBER`: Port used by the MariaDB or MySQL server. Default: **3306**
- `GHOST_DATABASE_NAME`: Database name that Ghost will use to connect with the database. Default: **bitnami_ghost**
- `GHOST_DATABASE_USER`: Database user that Ghost will use to connect with the database. Default: **bn_ghost**
- `GHOST_DATABASE_PASSWORD`: Database password that Ghost will use to connect with the database. No default.
- `GHOST_DATABASE_ENABLE_SSL`: It can be used to enable database SSL configuration. Default: **no**
- `GHOST_DATABASE_SSL_CA_FILE`: Path to the database SSL CA file. No default.
- `ALLOW_EMPTY_PASSWORD`: It can be used to allow blank passwords. Default: **no**

##### Create a database for Ghost using mysql-client

- `MYSQL_CLIENT_DATABASE_HOST`: Hostname for the MariaDB or MySQL server. Default: **mysql**
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

##### SMTP Configuration

To configure Ghost to send email using SMTP you can set the following environment variables:

- `GHOST_SMTP_HOST`: SMTP host. No default.
- `GHOST_SMTP_PORT`: SMTP port. No default.
- `GHOST_SMTP_USER`: SMTP account user. No default.
- `GHOST_SMTP_PASSWORD`: SMTP account password. No default.
- `GHOST_SMTP_PROTOCOL`: SMTP protocol to use. Allowed values: *tls*, *ssl*. No default.

#### Examples

##### SMTP configuration using a Gmail account

This would be an example of SMTP configuration using a Gmail account:

- Modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/ghost/docker-compose.yml) file present in this repository:

    ```yaml
      ghost:
        ...
        environment:
          - GHOST_DATABASE_USER=bn_ghost
          - GHOST_DATABASE_NAME=bitnami_ghost
          - ALLOW_EMPTY_PASSWORD=yes
          - GHOST_SMTP_HOST=smtp.gmail.com
          - GHOST_SMTP_PORT=587
          - GHOST_SMTP_USER=your_email@gmail.com
          - GHOST_SMTP_PASSWORD=your_password
          - GHOST_SMTP_FROM_ADDRESS=ghost@blog.com
      ...
    ```

- For manual execution:

    ```console
    $ docker run -d --name ghost -p 80:8080 -p 443:8443 \
      --env GHOST_DATABASE_USER=bn_ghost \
      --env GHOST_DATABASE_NAME=bitnami_ghost \
      --env GHOST_SMTP_HOST=smtp.gmail.com \
      --env GHOST_SMTP_PORT=587 \
      --env GHOST_SMTP_USER=your_email@gmail.com \
      --env GHOST_SMTP_PASSWORD=your_password \
      --env GHOST_SMTP_FROM_ADDRESS=ghost@blog.com \
      --network ghost-tier \
      --volume /path/to/ghost-persistence:/bitnami \
      bitnami/ghost:latest
    ```

##### Connect Ghost container to an existing database

The Bitnami Ghost container supports connecting the Ghost application to an external database. This would be an example of using an external database for Ghost.

- Modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/ghost/docker-compose.yml) file present in this repository:

    ```diff
       ghost:
         ...
         environment:
    -      - GHOST_DATABASE_HOST=mysql
    +      - GHOST_DATABASE_HOST=mysql_host
           - GHOST_DATABASE_PORT_NUMBER=3306
           - GHOST_DATABASE_NAME=ghost_db
           - GHOST_DATABASE_USER=ghost_user
    -      - ALLOW_EMPTY_PASSWORD=yes
    +      - GHOST_DATABASE_PASSWORD=ghost_password
         ...
    ```

- For manual execution:

    ```console
    $ docker run -d --name ghost\
      -p 8080:8080 -p 8443:8443 \
      --network ghost-network \
      --env GHOST_DATABASE_HOST=mysql_host \
      --env GHOST_DATABASE_PORT_NUMBER=3306 \
      --env GHOST_DATABASE_NAME=ghost_db \
      --env GHOST_DATABASE_USER=ghost_user \
      --env GHOST_DATABASE_PASSWORD=ghost_password \
      --volume ghost_data:/bitnami/ghost \
      bitnami/ghost:latest
    ```

In case the database already contains data from a previous Ghost installation, you need to set the variable `GHOST_SKIP_BOOTSTRAP` to `yes`. Otherwise, the container would execute the installation wizard and could modify the existing data in the database. Note that, when setting `GHOST_SKIP_BOOTSTRAP` to `yes`, values for environment variables such as `GHOST_USERNAME`, `GHOST_PASSWORD` or `GHOST_EMAIL` will be ignored.

## Logging

The Bitnami Ghost Docker image sends the container logs to `stdout`. To view the logs:

```console
$ docker logs ghost
```

Or using Docker Compose:

```console
$ docker-compose logs ghost
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Backing up your container

To backup your data, configuration and logs, follow these simple steps:

#### Step 1: Stop the currently running container

```console
$ docker stop ghost
```

Or using Docker Compose:

```console
$ docker-compose stop ghost
```

#### Step 2: Run the backup command

We need to mount two volumes in a container we will use to create the backup: a directory on your host to store the backup in, and the volumes from the container we just stopped so we can access the data.

```console
$ docker run --rm -v /path/to/ghost-backups:/backups --volumes-from ghost busybox \
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

### Upgrade this image

Bitnami provides up-to-date versions of MySQL and Ghost, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the Ghost container. For the MySQL upgrade see: https://github.com/bitnami/containers/blob/main/bitnami/mysql/blob/master/README.md#upgrade-this-image

The `bitnami/ghost:latest` tag always points to the most recent release. To get the most recent release you can simple repull the `latest` tag from the Docker Hub with `docker pull bitnami/ghost:latest`. However it is recommended to use [tagged versions](https://hub.docker.com/r/bitnami/ghost/tags/).

#### Step 1: Get the updated image

```console
$ docker pull bitnami/ghost:latest
```

#### Step 2: Stop the running container

Stop the currently running container using the command

```console
$ docker-compose stop ghost
```

#### Step 3: Take a snapshot of the application state

Follow the steps in [Backing up your container](#backing-up-your-container) to take a snapshot of the current application state.

#### Step 4: Remove the currently running container

Remove the currently running container by executing the following command:

```console
docker-compose rm -v ghost
```

#### Step 5: Run the new image

Update the image tag in `docker-compose.yml` and re-create your container with the new image:

```console
$ docker-compose up -d
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

#### Create a script named `post_ghost_config.sh` using `jq` for adding configuration to the `config.production.json`.

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

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues) or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/containers/issues/new/choose). For us to provide better support, be sure to fill the issue template.

### Community supported solution

Please, note this asset is a community-supported solution. This means that the Bitnami team is not actively working on new features/improvements nor providing support through GitHub Issues. Any new issue will stay open for 20 days to allow the community to contribute, after 15 days without activity the issue will be marked as stale being closed after 5 days.

The Bitnami team will review any PR that is created, feel free to create a PR if you find any issue or want to implement a new feature.

New versions and releases cadence are not going to be affected. Once a new version is released in the upstream project, the Bitnami container image will be updated to use the latest version, supporting the different branches supported by the upstream project as usual.

## License

Copyright &copy; 2023 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
