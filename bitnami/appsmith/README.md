# Bitnami package for Appsmith

## What is Appsmith?

> Appsmith is an open source platform for building and maintaining internal tools, such as custom dashboards, admin panels or CRUD apps.

[Overview of Appsmith](https://www.appsmith.com/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run -it --name appsmith bitnami/appsmith:latest
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use Appsmith in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Only latest stable branch maintained in the free Bitnami catalog

Starting December 10th 2024, only the latest stable branch of any container will receive updates in the free Bitnami catalog. To access up-to-date releases for all upstream-supported branches, consider upgrading to Bitnami Premium. Previous versions already released will not be deleted. They are still available to pull from DockerHub.

Please check the Bitnami Premium page in our partner [Arrow Electronics](https://www.arrow.com/globalecs/na/vendors/bitnami?utm_source=GitHub&utm_medium=containers) for more information.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami Appsmith Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/appsmith).

```console
docker pull bitnami/appsmith:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/appsmith/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/appsmith:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of Appsmith, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/appsmith:latest
```

or if you're using Docker Compose, update the value of the image property to `bitnami/appsmith:latest`.

#### Step 2: Remove the currently running container

```console
docker rm -v appsmith
```

or using Docker Compose:

```console
docker-compose rm -v appsmith
```

#### Step 3: Run the new image

Re-create your container from the new image.

```console
docker run --name appsmith bitnami/appsmith:latest
```

or using Docker Compose:

```console
docker-compose up appsmith
```

## Configuration

### Environment variables

#### Customizable environment variables

| Name                            | Description                                             | Default Value         |
|---------------------------------|---------------------------------------------------------|-----------------------|
| `ALLOW_EMPTY_PASSWORD`          | Allow an empty password.                                | `no`                  |
| `APPSMITH_USERNAME`             | Appsmith default username.                              | `user`                |
| `APPSMITH_PASSWORD`             | Appsmith default password.                              | `bitnami123`          |
| `APPSMITH_EMAIL`                | Appsmith default email.                                 | `user@example.com`    |
| `APPSMITH_MODE`                 | Appsmith service to run (can be backend, client or UI). | `backend`             |
| `APPSMITH_ENCRYPTION_PASSWORD`  | Appsmith database encryption password.                  | `bitnami123`          |
| `APPSMITH_ENCRYPTION_SALT`      | Appsmith database encryption salt.                      | `nil`                 |
| `APPSMITH_API_HOST`             | Appsmith API host.                                      | `appsmith-api`        |
| `APPSMITH_API_PORT`             | Appsmith API port.                                      | `8080`                |
| `APPSMITH_UI_HTTP_PORT`         | Appsmith UI HTTP port.                                  | `8080`                |
| `APPSMITH_UI_HTTPS_PORT`        | Appsmith UI HTTPS port.                                 | `8443`                |
| `APPSMITH_RTS_HOST`             | Appsmith RTS port.                                      | `appsmith-rts`        |
| `APPSMITH_RTS_PORT`             | Appsmith RTS port.                                      | `8091`                |
| `APPSMITH_DATABASE_HOST`        | Database server hosts (comma-separated list).           | `mongodb`             |
| `APPSMITH_DATABASE_PORT_NUMBER` | Database server port.                                   | `27017`               |
| `APPSMITH_DATABASE_NAME`        | Database name.                                          | `bitnami_appsmith`    |
| `APPSMITH_DATABASE_USER`        | Database user name.                                     | `bn_appsmith`         |
| `APPSMITH_DATABASE_PASSWORD`    | Database user password.                                 | `nil`                 |
| `APPSMITH_DATABASE_INIT_DELAY`  | Time to wait before the database is actually ready.     | `0`                   |
| `APPSMITH_REDIS_HOST`           | Redis server host.                                      | `redis`               |
| `APPSMITH_REDIS_PORT_NUMBER`    | Redis server port.                                      | `6379`                |
| `APPSMITH_REDIS_PASSWORD`       | Redis user password.                                    | `nil`                 |
| `APPSMITH_STARTUP_TIMEOUT`      | Appsmith startup check timeout.                         | `120`                 |
| `APPSMITH_STARTUP_ATTEMPTS`     | Appsmith startup check attempts.                        | `5`                   |
| `APPSMITH_DATA_TO_PERSIST`      | Data to persist from installations.                     | `$APPSMITH_CONF_FILE` |

#### Read-only environment variables

| Name                        | Description                               | Value                               |
|-----------------------------|-------------------------------------------|-------------------------------------|
| `APPSMITH_BASE_DIR`         | Appsmith installation directory.          | `${BITNAMI_ROOT_DIR}/appsmith`      |
| `APPSMITH_VOLUME_DIR`       | Appsmith volume directory.                | `/bitnami/appsmith`                 |
| `APPSMITH_LOG_DIR`          | Appsmith logs directory.                  | `${APPSMITH_BASE_DIR}/logs`         |
| `APPSMITH_LOG_FILE`         | Appsmith log file.                        | `${APPSMITH_LOG_DIR}/appsmith.log`  |
| `APPSMITH_CONF_DIR`         | Appsmith configuration directory.         | `${APPSMITH_BASE_DIR}/conf`         |
| `APPSMITH_DEFAULT_CONF_DIR` | Appsmith default configuration directory. | `${APPSMITH_BASE_DIR}/conf.default` |
| `APPSMITH_CONF_FILE`        | Appsmith configuration file.              | `${APPSMITH_CONF_DIR}/docker.env`   |
| `APPSMITH_TMP_DIR`          | Appsmith temporary directory.             | `${APPSMITH_BASE_DIR}/tmp`          |
| `APPSMITH_PID_FILE`         | Appsmith PID file.                        | `${APPSMITH_TMP_DIR}/appsmith.pid`  |
| `APPSMITH_DAEMON_USER`      | Appsmith daemon system user.              | `appsmith`                          |
| `APPSMITH_DAEMON_GROUP`     | Appsmith daemon system group.             | `appsmith`                          |

When you start the Appsmith image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line. Please note that some variables are only considered when the container is started for the first time. If you want to add a new environment variable:

* For docker-compose add the variable name and value under the application section in the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/appsmith/docker-compose.yml) file present in this repository:

    ```yaml
    appsmith-api:
      ...
      environment:
        - APPSMITH_PASSWORD=my_password
      ...
    ```

* For manual execution add a `--env` option with each variable and value:

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

* Backend: The Appsmith API. It is the essential functional element of Appsmith.
* RTS: Necessary for performing real-time editing of the applications created by Appsmith.
* Client: Contains the UI of Appsmith. This is the main entrypoint for users.

The running mode is defined via the `APPSMITH_MODE` environment variable. The possible values are `backend`, `rts` and `client`.

##### Connect Appsmith container to an existing database

The Bitnami Appsmith container supports connecting the Appsmith application to an external database. This would be an example of using an external database for Appsmith.

* Modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/appsmith/docker-compose.yml) file present in this repository:

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

* For manual execution:

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
docker logs wordpress
```

Or using Docker Compose:

```console
docker-compose logs wordpress
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/appsmith).

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
