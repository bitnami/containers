# Mastodon packaged by Bitnami

## What is Mastodon?

> Mastodon is self-hosted social network server based on ActivityPub. Written in Ruby, features real-time updates, multimedia attachments and no vendor lock-in.

[Overview of Mastodon](https://joinmastodon.org/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
$ docker run -it --name mastodon bitnami/mastodon
```

### Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/containers/main/bitnami/mastodon/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami Mastodon Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/mastodon).

```console
$ docker pull bitnami/mastodon:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/mastodon/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/mastodon:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
$ git clone https://github.com/bitnami/containers.git
$ cd bitnami/APP/VERSION/OPERATING-SYSTEM
$ docker build -t bitnami/APP:latest .
```

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of Mastodon, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
$ docker pull bitnami/mastodon:latest
```

or if you're using Docker Compose, update the value of the image property to `bitnami/mastodon:latest`.

#### Step 2: Remove the currently running container

```console
$ docker rm -v mastodon
```

or using Docker Compose:

```console
$ docker-compose rm -v mastodon
```

#### Step 3: Run the new image

Re-create your container from the new image.

```console
$ docker run --name mastodon bitnami/mastodon:latest
```

or using Docker Compose:

```console
$ docker-compose up mastodon
```

## Configuration

### Environment variables

When you start the Mastodon image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line. Please note that some variables are only considered when the container is started for the first time. If you want to add a new environment variable:

- For docker-compose add the variable name and value under the application section in the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/mastodon/docker-compose.yml) file present in this repository:

    ```yaml
    mastodon-api:
      ...
      environment:
        - MASTODON_ADMIN_PASSWORD=my_password
      ...
    ```

- For manual execution add a `--env` option with each variable and value:

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

- Web: The Mastodon web frontend. It is the essential functional element of Mastodon.
- Streaming: Necessary for performing real-time interactions inside Mastodon.
- Sidekiq: Performs background operations like sending emails.

The running mode is defined via the `MASTODON_MODE` environment variable. The possible values are `web`, `streaming` and `sidekiq`.

##### User and Site configuration

- `MASTODON_CREATE_ADMIN`: Create admin users if it does not exist. Default: **true**
- `MASTODON_ADMIN_USERNAME`: Mastodon application username. Default: **user**
- `MASTODON_ADMIN_PASSWORD`: Mastodon application password. Default: **bitnami1**
- `MASTODON_ADMIN_EMAIL`: Mastodon application email. Default: **user@bitnami.org**
- `MASTODON_HTTPS_ENABLED`: Set the Mastodon Puma server as HTTPS. Default: **false**.
- `MASTODON_ALLOW_ALL_DOMAINS`: Disable the Mastodon host verification process. Default: **true**.
- `MASTODON_DATA_TO_PERSIST`: Space separated list of files and directories to persist. Use a space to persist no data: `" "`. Default: **public/system, public/assets**

##### Startup operations

At startup, several operations are necessary. In order to allow multiple replicas of the web server, the container allows enabling certain operations via flags:

- `MASTODON_PRECOMPILE_ASSETS`: Perform `rake assets:precompile` at startup. Default: **true**.
- `MASTODON_MIGRATE_DATABASE`: Perform `rake db:migrate`. Default: **true**.
- `MASTODON_MIGRATE_ELASTICSEARCH`: Perform `rake chewy:upgrade`. Default: **true**.

##### Connect Mastodon container to an existing database

The Bitnami Mastodon container supports connecting the Mastodon application to an external database. This would be an example of using an external database for Mastodon.

- Modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/mastodon/docker-compose.yml) file present in this repository:

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

- For manual execution:

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
$ docker logs mastodon
```

Or using Docker Compose:

```console
$ docker-compose logs mastodon
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Contributing

We'd love for you to contribute to this Docker image. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues) or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/containers/issues/new/choose). For us to provide better support, be sure to fill the issue template.

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
