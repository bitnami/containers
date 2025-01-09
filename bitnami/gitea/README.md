# Bitnami package for Gitea

## What is Gitea?

> Gitea is a lightweight code hosting solution. Written in Go, features low resource consumption, easy upgrades and multiple databases.

[Overview of Gitea](https://gitea.io/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name gitea bitnami/gitea:latest
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use Gitea in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## How to deploy Gitea in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Gitea Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/gitea).

Bitnami containers can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Only latest stable branch maintained in the free Bitnami catalog

Starting December 10th 2024, only the latest stable branch of any container will receive updates in the free Bitnami catalog. To access up-to-date releases for all upstream-supported branches, consider upgrading to Bitnami Premium. Previous versions already released will not be deleted. They are still available to pull from DockerHub.

Please check the Bitnami Premium page in our partner [Arrow Electronics](https://www.arrow.com/globalecs/na/vendors/bitnami?utm_source=GitHub&utm_medium=containers) for more information.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami Gitea Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/gitea).

```console
docker pull bitnami/gitea:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/gitea/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/gitea:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami/gitea` path. If the mounted directory is empty, it will be initialized on the first run.

```console
docker run \
    --volume /path/to/gitea-persistence:/bitnami/gitea \
    --env ALLOM_EMPTY_PASSWORD=false \
    bitnami/gitea:latest
```

You can also do this with a minor change to the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/gitea/docker-compose.yml) file present in this repository:

```console
gitea:
  ...
  volumes:
    - /path/to/gitea-persistence:/bitnami/gitea
  ...
```

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the hostname.

### Using the Command Line

In this example, we will create a Gitea client instance that will connect to the server instance that is running on the same docker network as the client.

#### Step 1: Create a network

```console
docker network create my-network --driver bridge
```

#### Step 2: Launch the Gitea container within your network

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `my-network` network.

```console
docker run -d --name gitea-server \
  --network my-network \
  --env ALLOW_EMPTY_PASSWORD=yes \
  bitnami/gitea:latest
```

#### Step 3: Launch your Gitea client instance

Finally we create a new container instance to launch the Gitea client and connect to the server created in the previous step:

```console
docker run -it --rm \
    --network my-network \
    bitnami/gitea:latest gitea-client --host gitea-server
```

### Using a Docker Compose file

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new `bridge` network named `my-network`. In this example we assume that you want to connect to the Gitea server from your own custom application image which is identified in the following snippet by the service name `myapp`.

```yaml
version: '2'

networks:
  my-network:
    driver: bridge

services:
  gitea:
    image: bitnami/gitea:latest
    environment:
      - ALLOW_EMPTY_PASSWORD=no
    networks:
      - my-network
  myapp:
    image: 'YOUR_APPLICATION_IMAGE'
    networks:
      - my-network
```

> **IMPORTANT**:
>
> 1. Please update the `YOUR_APPLICATION_IMAGE` placeholder in the above snippet with your application image
> 2. In your application container, use the hostname `gitea` to connect to the Gitea server

Launch the containers using:

```console
docker-compose up -d
```

## Configuration

Gitea can be configured via environment variables or using a configuration file (`app.ini`). If a configuration option is not specified in either the configuration file or in an environment variable, Gitea uses its internal default configuration.

### Environment variables

#### Customizable environment variables

| Name                                            | Description                                                                                                       | Default Value                                            |
|-------------------------------------------------|-------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------|
| `GITEA_REPO_ROOT_PATH`                          | Gitea git repositories path.                                                                                      | `${GITEA_DATA_DIR}/git/repositories`                     |
| `GITEA_LFS_ROOT_PATH`                           | Gitea git LFS path.                                                                                               | `nil`                                                    |
| `GITEA_LOG_ROOT_PATH`                           | Gitea log path.                                                                                                   | `${GITEA_TMP_DIR}/log`                                   |
| `GITEA_LOG_MODE`                                | Gitea log mode.                                                                                                   | `nil`                                                    |
| `GITEA_LOG_ROUTER`                              | Gitea log router.                                                                                                 | `nil`                                                    |
| `GITEA_ADMIN_USER`                              | Admin username.                                                                                                   | `bn_user`                                                |
| `GITEA_ADMIN_PASSWORD`                          | Admin password.                                                                                                   | `bitnami`                                                |
| `GITEA_ADMIN_EMAIL`                             | Admin user email.                                                                                                 | `user@bitnami.org`                                       |
| `GITEA_APP_NAME`                                | Application name, used in the page title                                                                          | `Gitea: Git with a cup of tea`                           |
| `GITEA_RUN_MODE`                                | Application run mode, affects performance and debugging. Either "dev", "prod" or "test".                          | `prod`                                                   |
| `GITEA_DOMAIN`                                  | Domain name of this server.                                                                                       | `localhost`                                              |
| `GITEA_SSH_DOMAIN`                              | Domain name of this server, used for displayed clone URL.                                                         | `${GITEA_DOMAIN}`                                        |
| `GITEA_SSH_LISTEN_PORT`                         | Port for the built-in SSH server.                                                                                 | `2222`                                                   |
| `GITEA_SSH_PORT`                                | SSH port displayed in clone URL.                                                                                  | `${GITEA_SSH_LISTEN_PORT}`                               |
| `GITEA_HTTP_PORT`                               | Gitea HTTP listen port                                                                                            | `3000`                                                   |
| `GITEA_PROTOCOL`                                | [http, https, fcgi, http+unix, fcgi+unix]                                                                         | `http`                                                   |
| `GITEA_ROOT_URL`                                | Overwrite the automatically generated public URL. This is useful if the internal and the external URL don't match | `${GITEA_PROTOCOL}://${GITEA_DOMAIN}:${GITEA_HTTP_PORT}` |
| `GITEA_PASSWORD_HASH_ALGO`                      | The hash algorithm to use [argon2, pbkdf2, scrypt, bcrypt], argon2 will spend more memory than others.            | `pbkdf2`                                                 |
| `GITEA_LFS_START_SERVER`                        | Enables Git LFS support                                                                                           | `false`                                                  |
| `GITEA_ENABLE_OPENID_SIGNIN`                    | Enable OpenID sign-in.                                                                                            | `false`                                                  |
| `GITEA_ENABLE_OPENID_SIGNUP`                    | Enable OpenID sign-up.                                                                                            | `false`                                                  |
| `GITEA_DATABASE_TYPE`                           | The database type in use [mysql, postgres].                                                                       | `postgres`                                               |
| `GITEA_DATABASE_HOST`                           | Database host address.                                                                                            | `postgresql`                                             |
| `GITEA_DATABASE_PORT_NUMBER`                    | Database host port.                                                                                               | `5432`                                                   |
| `GITEA_DATABASE_NAME`                           | Database name.                                                                                                    | `bitnami_gitea`                                          |
| `GITEA_DATABASE_USERNAME`                       | Database username.                                                                                                | `bn_gitea`                                               |
| `GITEA_DATABASE_PASSWORD`                       | Database password.                                                                                                | `nil`                                                    |
| `GITEA_DATABASE_SSL_MODE`                       | Database SSL mode.                                                                                                | `disable`                                                |
| `GITEA_DATABASE_SCHEMA`                         | Database Schema.                                                                                                  | `nil`                                                    |
| `GITEA_DATABASE_CHARSET`                        | Database character set.                                                                                           | `utf8`                                                   |
| `GITEA_SMTP_ENABLED`                            | Enable to use a mail service.                                                                                     | `false`                                                  |
| `GITEA_SMTP_HOST`                               | SMTP mail host address (example: smtp.gitea.io).                                                                  | `nil`                                                    |
| `GITEA_SMTP_PORT`                               | SMTP mail port (example: 587).                                                                                    | `nil`                                                    |
| `GITEA_SMTP_FROM`                               | Mail from address, RFC 5322. This can be just an email address, or the "Name" email@example.com format.           | `nil`                                                    |
| `GITEA_SMTP_USER`                               | Username of mailing user (usually the senders e-mail address).                                                    | `nil`                                                    |
| `GITEA_SMTP_PASSWORD`                           | Password of mailing user. Use "your password" for quoting if you use special characters in the password.          | `nil`                                                    |
| `GITEA_OAUTH2_CLIENT_AUTO_REGISTRATION_ENABLED` | Password of mailing user. Use "your password" for quoting if you use special characters in the password.          | `false`                                                  |
| `GITEA_OAUTH2_CLIENT_USERNAME`                  | Password of mailing user. Use "your password" for quoting if you use special characters in the password.          | `nickname`                                               |

#### Read-only environment variables

| Name                    | Description                                                                                                                 | Value                         |
|-------------------------|-----------------------------------------------------------------------------------------------------------------------------|-------------------------------|
| `GITEA_BASE_DIR`        | Gitea installation directory.                                                                                               | `${BITNAMI_ROOT_DIR}/gitea`   |
| `GITEA_WORK_DIR`        | Gitea installation directory.                                                                                               | `${GITEA_BASE_DIR}`           |
| `GITEA_CUSTOM_DIR`      | Gitea configuration directory.                                                                                              | `${GITEA_BASE_DIR}/custom`    |
| `GITEA_TMP_DIR`         | Gitea TEMP directory.                                                                                                       | `${GITEA_BASE_DIR}/tmp`       |
| `GITEA_DATA_DIR`        | Gitea data directory.                                                                                                       | `${GITEA_WORK_DIR}/data`      |
| `GITEA_CONF_DIR`        | Gitea configuration directory.                                                                                              | `${GITEA_CUSTOM_DIR}/conf`    |
| `GITEA_CONF_FILE`       | Gitea configuration file.                                                                                                   | `${GITEA_CONF_DIR}/app.ini`   |
| `GITEA_PID_FILE`        | Gitea PID file.                                                                                                             | `${GITEA_TMP_DIR}/gitea.pid`  |
| `GITEA_VOLUME_DIR`      | Gitea directory for mounted configuration files.                                                                            | `${BITNAMI_VOLUME_DIR}/gitea` |
| `GITEA_DATA_TO_PERSIST` | Files to persist relative to the Gitea installation directory. To provide multiple values, separate them with a whitespace. | `${GITEA_CONF_FILE} data`     |
| `GITEA_DAEMON_USER`     | Gitea daemon system user.                                                                                                   | `gitea`                       |
| `GITEA_DAEMON_GROUP`    | Gitea daemon system group.                                                                                                  | `gitea`                       |

### Configuration overrides

The configuration can easily be setup by mounting your own configuration overrides on the directory `/bitnami/gitea/custom/conf/app.ini`:

```console
docker run --name gitea \
    --volume /path/to/override.ini:/bitnami/gitea/custom/conf/app.ini:ro \
    bitnami/gitea:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  gitea:
    image: bitnami/gitea:latest
    volumes:
      - /path/to/override.ini:/bitnami/gitea/custom/conf/app.ini:ro
```

Check the [official gitea configuration documentation](https://docs.gitea.io/en-us/config-cheat-sheet/) for all the possible overrides and settings.

### Initializing a new instance

In order to have your custom files inside the docker image you can mount them as a volume.

### Setting the admin password on first run

Passing the `GITEA_ADMIN_PASSWORD` environment variable when running the image for the first time will set the password of the `GITEA_ADMIN_USER`/`GITEA_ADMIN_EMAIL` user to the value of `GITEA_ADMIN_PASSWORD`.

```console
docker run --name gitea -e GITEA_ADMIN_PASSWORD=password123 bitnami/gitea:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/gitea/docker-compose.yml) file present in this repository:

```yaml
services:
  gitea:
  ...
    environment:
      - GITEA_ADMIN_PASSWORD=password123
  ...
```

## Logging

The Bitnami Gitea Docker image sends the container logs to `stdout`. To view the logs:

```console
docker logs gitea
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of Gitea, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/gitea:latest
```

or if you're using Docker Compose, update the value of the image property to `bitnami/gitea:latest`.

#### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```console
docker stop gitea
```

or using Docker Compose:

```console
docker-compose stop gitea
```

Next, take a snapshot of the persistent volume `/path/to/gitea-persistence` using:

```console
rsync -a /path/to/gitea-persistence /path/to/gitea-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

#### Step 3: Remove the currently running container

```console
docker rm -v gitea
```

or using Docker Compose:

```console
docker-compose rm -v gitea
```

#### Step 4: Run the new image

Re-create your container from the new image.

```console
docker run --name gitea bitnami/gitea:latest
```

or using Docker Compose:

```console
docker-compose up gitea
```

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/gitea).

If you detect any issue in the `docker-compose.yaml` file, feel free to report it or contribute with a fix by following our [Contributing Guidelines](https://github.com/bitnami/containers/blob/main/CONTRIBUTING.md).

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
