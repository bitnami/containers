# Bitnami package for Mastodon

## What is Mastodon?

> Mastodon is self-hosted social network server based on ActivityPub. Written in Ruby, features real-time updates, multimedia attachments and no vendor lock-in.

[Overview of Mastodon](https://joinmastodon.org/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run -it --name mastodon bitnami/mastodon
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use Mastodon in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Only latest stable branch maintained in the free Bitnami catalog

Starting December 10th 2024, only the latest stable branch of any container will receive updates in the free Bitnami catalog. To access up-to-date releases for all upstream-supported branches, consider upgrading to Bitnami Premium. Previous versions already released will not be deleted. They are still available to pull from DockerHub.

Please check the Bitnami Premium page in our partner [Arrow Electronics](https://www.arrow.com/globalecs/na/vendors/bitnami?utm_source=GitHub&utm_medium=containers) for more information.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami Mastodon Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/mastodon).

```console
docker pull bitnami/mastodon:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/mastodon/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/mastodon:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of Mastodon, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/mastodon:latest
```

or if you're using Docker Compose, update the value of the image property to `bitnami/mastodon:latest`.

#### Step 2: Remove the currently running container

```console
docker rm -v mastodon
```

or using Docker Compose:

```console
docker-compose rm -v mastodon
```

#### Step 3: Run the new image

Re-create your container from the new image.

```console
docker run --name mastodon bitnami/mastodon:latest
```

or using Docker Compose:

```console
docker-compose up mastodon
```

## Configuration

### Environment variables

#### Customizable environment variables

| Name                                 | Description                                                           | Default Value                                                                  |
|--------------------------------------|-----------------------------------------------------------------------|--------------------------------------------------------------------------------|
| `MASTODON_MODE`                      | Mastodon service to run (can be web, streaming or sidekiq).           | `web`                                                                          |
| `ALLOW_EMPTY_PASSWORD`               | Allow an empty password.                                              | `no`                                                                           |
| `MASTODON_CREATE_ADMIN`              | Create admin for Mastodon.                                            | `true`                                                                         |
| `MASTODON_ADMIN_USERNAME`            | Mastodon admin username.                                              | `user`                                                                         |
| `MASTODON_ADMIN_PASSWORD`            | Mastodon admin password.                                              | `bitnami1`                                                                     |
| `MASTODON_ADMIN_EMAIL`               | Mastodon admin email.                                                 | `user@bitnami.org`                                                             |
| `MASTODON_ALLOW_ALL_DOMAINS`         | Allow accessing Mastodon with any domain.                             | `true`                                                                         |
| `MASTODON_SECRET_KEY_BASE`           | Mastodon secret key base.                                             | `bitnami123`                                                                   |
| `MASTODON_OTP_SECRET`                | Mastodon OTP secret.                                                  | `bitnami123`                                                                   |
| `MASTODON_HTTPS_ENABLED`             | Enable HTTPS in Mastodon.                                             | `false`                                                                        |
| `MASTODON_ASSETS_PRECOMPILE`         | Run rake assets:precompile on startup.                                | `true`                                                                         |
| `MASTODON_WEB_DOMAIN`                | Mastodon web domain (for generating links).                           | `127.0.0.1`                                                                    |
| `MASTODON_WEB_HOST`                  | Mastodon web host (for the streaming and sidekiq services to access). | `mastodon`                                                                     |
| `MASTODON_WEB_PORT_NUMBER`           | Mastodon web port.                                                    | `3000`                                                                         |
| `MASTODON_STREAMING_PORT_NUMBER`     | Mastodon streaming port.                                              | `4000`                                                                         |
| `MASTODON_AUTHORIZED_FETCH`          | Use secure mode.                                                      | `false`                                                                        |
| `MASTODON_LIMITED_FEDERATION_MODE`   | Use an allow-list for federating with other servers.                  | `false`                                                                        |
| `MASTODON_STREAMING_API_BASE_URL`    | Mastodon public api base url.                                         | `ws://localhost:${MASTODON_STREAMING_PORT_NUMBER}`                             |
| `RAILS_SERVE_STATIC_FILES`           | Have puma server the static files in the public/ folder               | `true`                                                                         |
| `MASTODON_BIND_ADDRESS`              | Address to listen for interfaces                                      | `0.0.0.0`                                                                      |
| `MASTODON_DATA_TO_PERSIST`           | Data to persist from installations.                                   | `$MASTODON_ASSETS_DIR $MASTODON_SYSTEM_DIR`                                    |
| `MASTODON_MIGRATE_DATABASE`          | Run rake db:migrate job.                                              | `true`                                                                         |
| `MASTODON_DATABASE_HOST`             | Database server host.                                                 | `postgresql`                                                                   |
| `MASTODON_DATABASE_PORT_NUMBER`      | Database server port.                                                 | `5432`                                                                         |
| `MASTODON_DATABASE_NAME`             | Database name.                                                        | `bitnami_mastodon`                                                             |
| `MASTODON_DATABASE_USERNAME`         | Database user name.                                                   | `bn_mastodon`                                                                  |
| `MASTODON_DATABASE_PASSWORD`         | Database user password.                                               | `nil`                                                                          |
| `MASTODON_DATABASE_POOL`             | Number of DB pool processes.                                          | `5`                                                                            |
| `MASTODON_REDIS_HOST`                | Redis server host.                                                    | `redis`                                                                        |
| `MASTODON_REDIS_PORT_NUMBER`         | Redis server port.                                                    | `6379`                                                                         |
| `MASTODON_REDIS_PASSWORD`            | Redis user password.                                                  | `nil`                                                                          |
| `MASTODON_ELASTICSEARCH_ENABLED`     | Enable Elasticsearch.                                                 | `true`                                                                         |
| `MASTODON_MIGRATE_ELASTICSEARCH`     | Run rake chewy:upgrade on startup.                                    | `true`                                                                         |
| `MASTODON_ELASTICSEARCH_HOST`        | Elasticsearch server host.                                            | `elasticsearch`                                                                |
| `MASTODON_ELASTICSEARCH_PORT_NUMBER` | Elasticsearch server port.                                            | `9200`                                                                         |
| `MASTODON_ELASTICSEARCH_USER`        | Elasticsearch user.                                                   | `elastic`                                                                      |
| `MASTODON_ELASTICSEARCH_PASSWORD`    | Elasticsearch user password.                                          | `nil`                                                                          |
| `MASTODON_S3_ENABLED`                | Enable S3                                                             | `false`                                                                        |
| `MASTODON_S3_BUCKET`                 | S3 Bucket for storing data                                            | `bitnami_mastodon`                                                             |
| `MASTODON_S3_HOSTNAME`               | S3 endpoint                                                           | `minio`                                                                        |
| `MASTODON_S3_PROTOCOL`               | S3 protocol (can be https or http)                                    | `http`                                                                         |
| `MASTODON_S3_PORT_NUMBER`            | S3 port                                                               | `9000`                                                                         |
| `MASTODON_S3_ALIAS_HOST`             | S3 route for uploaded files (for generating links in Mastodon)        | `localhost:${MASTODON_S3_PORT_NUMBER}`                                         |
| `MASTODON_AWS_SECRET_ACCESS_KEY`     | AWS secret access key                                                 | `nil`                                                                          |
| `MASTODON_AWS_ACCESS_KEY_ID`         | AWS access key id                                                     | `nil`                                                                          |
| `MASTODON_S3_REGION`                 | S3 region                                                             | `us-east-1`                                                                    |
| `MASTODON_S3_ENDPOINT`               | S3 endpoint                                                           | `${MASTODON_S3_PROTOCOL}://${MASTODON_S3_HOSTNAME}:${MASTODON_S3_PORT_NUMBER}` |
| `MASTODON_STARTUP_ATTEMPTS`          | Startup check attempts.                                               | `40`                                                                           |

#### Read-only environment variables

| Name                    | Description                       | Value                                |
|-------------------------|-----------------------------------|--------------------------------------|
| `MASTODON_BASE_DIR`     | Mastodon installation directory.  | `${BITNAMI_ROOT_DIR}/mastodon`       |
| `MASTODON_VOLUME_DIR`   | Mastodon volume directory.        | `/bitnami/mastodon`                  |
| `MASTODON_ASSETS_DIR`   | Mastodon public assets directory. | `${MASTODON_BASE_DIR}/public/assets` |
| `MASTODON_SYSTEM_DIR`   | Mastodon public system directory. | `${MASTODON_BASE_DIR}/public/system` |
| `MASTODON_TMP_DIR`      | Mastodon tmp directory.           | `${MASTODON_BASE_DIR}/tmp`           |
| `MASTODON_LOGS_DIR`     | Mastodon logs directory.          | `${MASTODON_BASE_DIR}/log`           |
| `NODE_ENV`              | Node.js environment mode          | `production`                         |
| `RAILS_ENV`             | Rails environment mode            | `production`                         |
| `MASTODON_DAEMON_USER`  | Mastodon daemon system user.      | `mastodon`                           |
| `MASTODON_DAEMON_GROUP` | Mastodon daemon system group.     | `mastodon`                           |

When you start the Mastodon image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line. Please note that some variables are only considered when the container is started for the first time. If you want to add a new environment variable:

* For docker-compose add the variable name and value under the application section in the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/mastodon/docker-compose.yml) file present in this repository:

    ```yaml
    mastodon-api:
      ...
      environment:
        - MASTODON_ADMIN_PASSWORD=my_password
      ...
    ```

* For manual execution add a `--env` option with each variable and value:

    ```console
    $ docker run -d --name mastodon-api -p 80:8080 -p 443:8443 \
      --env MASTODON_ADMIN_PASSWORD=my_password \
      --env MASTODON_MODE=backend \
      --network mastodon-tier \
      --volume /path/to/mastodon-persistence:/bitnami \
      bitnami/mastodon:latest
    ```

This container is fully compatible with the upstream Mastodon environment variables. Check the official [Mastodon documentation page](https://docs.joinmastodon.org/admin/config/) for more information.

In addition to the official environment variables, the Bitnami Mastodon image adds the following extra environment variables:

#### Run mode

Mastodon supports three running modes:

* Web: The Mastodon web frontend. It is the essential functional element of Mastodon.
* Streaming: Necessary for performing real-time interactions inside Mastodon.
* Sidekiq: Performs background operations like sending emails.

The running mode is defined via the `MASTODON_MODE` environment variable. The possible values are `web`, `streaming` and `sidekiq`.

##### Connect Mastodon container to an existing database

The Bitnami Mastodon container supports connecting the Mastodon application to an external database. This would be an example of using an external database for Mastodon.

* Modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/mastodon/docker-compose.yml) file present in this repository:

    ```diff
       mastodon:
         ...
         environment:
    -      - DB_HOST=postgresql
    +      - DB_HOST=postgresql_host
           - DB_PORT=5432
           - DB_NAME=mastodon_db
           - DB_USER=mastodon_user
    +      - DB_PASS=mastodon_password
         ...
    ```

* For manual execution:

    ```console
    $ docker run -d --name mastodon\
      -p 8080:8080 -p 8443:8443 \
      --network mastodon-network \
      --env DB_HOST=postgresql_host \
      --env DB_PORT=5432 \
      --env DB_NAME=mastodon_db \
      --env DB_USER=mastodon_user \
      --env DB_PASS=mastodon_password \
      --volume mastodon_data:/bitnami/mastodon \
      bitnami/mastodon:latest
    ```

## Logging

The Bitnami Mastodon Docker image sends the container logs to `stdout`. To view the logs:

```console
docker logs mastodon
```

Or using Docker Compose:

```console
docker-compose logs mastodon
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/mastodon).

If you detect any issue in the `docker-compose.yaml` file, feel free to report it or contribute with a fix by following our [Contributing Guidelines](https://github.com/bitnami/containers/blob/main/CONTRIBUTING.md).

## Contributing

We'd love for you to contribute to this Docker image. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues) or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

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
