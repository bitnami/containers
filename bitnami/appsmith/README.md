# Appsmith packaged by Bitnami

## What is Appsmith?

> Appsmith is an open source platform for building and maintaining internal tools, such as custom dashboards, admin panels or CRUD apps.

[Overview of Appsmith](https://www.appsmith.com/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
$ docker run -it --name appsmith bitnami/appsmith
```

### Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/containers/main/bitnami/appsmith/docker-compose.yml > docker-compose.yml
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

The recommended way to get the Bitnami Appsmith Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/appsmith).

```console
$ docker pull bitnami/appsmith:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/appsmith/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/appsmith:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
$ git clone https://github.com/bitnami/containers.git
$ cd bitnami/APP/VERSION/OPERATING-SYSTEM
$ docker build -t bitnami/APP:latest .
```

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of Appsmith, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
$ docker pull bitnami/appsmith:latest
```

or if you're using Docker Compose, update the value of the image property to `bitnami/appsmith:latest`.

#### Step 2: Remove the currently running container

```console
$ docker rm -v appsmith
```

or using Docker Compose:

```console
$ docker-compose rm -v appsmith
```

#### Step 3: Run the new image

Re-create your container from the new image.

```console
$ docker run --name appsmith bitnami/appsmith:latest
```

or using Docker Compose:

```console
$ docker-compose up appsmith
```

## Configuration

### Environment variables

When you start the Appsmith image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line. Please note that some variables are only considered when the container is started for the first time. If you want to add a new environment variable:

- For docker-compose add the variable name and value under the application section in the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/appsmith/docker-compose.yml) file present in this repository:

    ```yaml
    appsmith-api:
      ...
      environment:
        - APPSMITH_PASSWORD=my_password
      ...
    ```

- For manual execution add a `--env` option with each variable and value:

    ```console
    $ docker run -d --name appsmith-api -p 80:8080 -p 443:8443 \
      --env APPSMITH_PASSWORD=my_password \
      --env APPSMITH_MODE=backend \
      --network appsmith-tier \
      --volume /path/to/appsmith-persistence:/bitnami \
      bitnami/appsmith:latest
    ```

Available environment variables:

#### Run mode

Appsmith supports three running modes:

- Backend: The Appsmith API. It is the essential functional element of Appsmith.
- RTS: Necessary for performing real-time editing of the applications created by Appsmith.
- Client: Contains the UI of Appsmith. This is the main entrypoint for users.

The running mode is defined via the `APPSMITH_MODE` environment variable. The possible values are `backend`, `rts` and `client`.

##### User and Site configuration

- `APPSMITH_UI_HTTP_PORT`: Port used by the Client for HTTP. Default: **8080**
- `APPSMITH_USERNAME`: Appsmith application username. Default: **user**
- `APPSMITH_PASSWORD`: Appsmith application password. Default: **bitnami**
- `APPSMITH_EMAIL`: Appsmith application email. Default: **user@example.com**
- `APPSMITH_DATA_TO_PERSIST`: Space separated list of files and directories to persist. Use a space to persist no data: `" "`. Default: **"docker.env"**

##### Salt and keys configuration

Authentication unique keys and salts. Specify these values to prevent cookies from being invalidated when creating a new container or when using multiple containers to serve the same Appsmith instance. By default these values are generated randomly:

- `APPSMITH_ENCRYPTION_PASSWORD`: Database encryption password. Default: **bitnami**.
- `APPSMITH_ENCRYPTION_SALT`: Database encryption salt. Default: **bitnami**.

##### Database connection configuration

- `APPSMITH_DATABASE_HOST`: Hostname for the MongoDB(TM) servers (comma separated). Default: **mongodb**
- `APPSMITH_DATABASE_PORT_NUMBER`: Port used by the MongoDB(TM) server. Default: **27017**
- `APPSMITH_DATABASE_NAME`: Database name that Appsmith will use to connect with the database. Default: **bitnami_appsmith**
- `APPSMITH_DATABASE_USER`: Database user that Appsmith will use to connect with the database. Default: **bn_appsmith**
- `APPSMITH_DATABASE_PASSWORD`: Database password that Appsmith will use to connect with the database. No defaults.
- `APPSMITH_REDIS_HOST`: Hostname for the Redis(TM) server. Default: **redis**
- `APPSMITH_REDIS_PORT_NUMBER`: Port used by the Redis(TM) server. Default: **6379**
- `APPSMITH_REDIS_PASSWORD`: Database password that Appsmith will use to connect with the database. No defaults.
- `ALLOW_EMPTY_PASSWORD`: It can be used to allow blank passwords. Default: **no**

##### Connect Appsmith container to an existing database

The Bitnami Appsmith container supports connecting the Appsmith application to an external database. This would be an example of using an external database for Appsmith.

- Modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/appsmith/docker-compose.yml) file present in this repository:

    ```diff
       appsmith:
         ...
         environment:
    -      - APPSMITH_DATABASE_HOST=mongodb
    +      - APPSMITH_DATABASE_HOST=mongodb_host
           - APPSMITH_DATABASE_PORT_NUMBER=27017
           - APPSMITH_DATABASE_NAME=appsmith_db
           - APPSMITH_DATABASE_USER=appsmith_user
    -      - ALLOW_EMPTY_PASSWORD=yes
    +      - APPSMITH_DATABASE_PASSWORD=appsmith_password
         ...
    ```

- For manual execution:

    ```console
    $ docker run -d --name appsmith\
      -p 8080:8080 -p 8443:8443 \
      --network appsmith-network \
      --env APPSMITH_DATABASE_HOST=mongodb_host \
      --env APPSMITH_DATABASE_PORT_NUMBER=27017 \
      --env APPSMITH_DATABASE_NAME=appsmith_db \
      --env APPSMITH_DATABASE_USER=appsmith_user \
      --env APPSMITH_DATABASE_PASSWORD=appsmith_password \
      --volume appsmith_data:/bitnami/appsmith \
      bitnami/appsmith:latest
    ```

## Logging

The Bitnami Appsmith Docker image sends the container logs to `stdout`. To view the logs:

```console
$ docker logs wordpress
```

Or using Docker Compose:

```console
$ docker-compose logs wordpress
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
