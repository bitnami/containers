# Bitnami package for Concourse

## What is Concourse?

> Concourse is an automation system written in Go. It is most commonly used for CI/CD, and is built to scale to any kind of automation pipeline, from simple to complex.

[Overview of Concourse](https://concourse-ci.org/)

## TL;DR

```console
docker run --name concourse bitnami/concourse:latest
```

**Warning**: This quick setup is only intended for development environments. You are encouraged to change the insecure default credentials and check out the available configuration options for the [PostgreSQL container](https://github.com/bitnami/containers/tree/main/bitnami/postgresql#readme) for a more secure deployment.

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use Concourse in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/containers/how-to/work-with-non-root-containers/).

## Only latest stable branch maintained in the free Bitnami catalog

Starting December 10th 2024, only the latest stable branch of any container will receive updates in the free Bitnami catalog. To access up-to-date releases for all upstream-supported branches, consider upgrading to Bitnami Premium. Previous versions already released will not be deleted. They are still available to pull from DockerHub.

Please check the Bitnami Premium page in our partner [Arrow Electronics](https://www.arrow.com/globalecs/na/vendors/bitnami?utm_source=GitHub&utm_medium=containers) for more information.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami concourse Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/concourse).

```console
docker pull bitnami/concourse:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/concourse/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/concourse:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami` path. If the mounted directory is empty, it will be initialized on the first run.

```console
docker run \
    -v /path/to/concourse-persistence:/bitnami/concourse \
    bitnami/concourse:latest
```

You can also do this with a minor change to the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/concourse/docker-compose.yml) file present in this repository:

```yaml
concourse:
  ...
  volumes:
    - /path/to/concourse-persistence:/bitnami/concourse
  ...
```

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the hostname.

### Using the Command Line

#### Step 1: Create a network

```console
docker network create concourse-network --driver bridge
```

#### Step 2: Launch the concourse container within your network

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `concourse-network` network.

```console
docker run --name concourse-node1 --network concourse-network bitnami/concourse:latest
```

#### Step 3: Run another container

We can launch another container using the same flag (`--network NETWORK`) in the `docker run` command. If you also set a name to your container, you will be able to use it as hostname in your network.

## Configuration

Find how to configure Concourse in its [official documentation](https://concourse-ci.org//docs.html).

### Environment variables

#### Customizable environment variables

| Name                                              | Description                                                             | Default Value                              |
|---------------------------------------------------|-------------------------------------------------------------------------|--------------------------------------------|
| `CONCOURSE_WEB_PUBLIC_DIR`                        | Concourse web/public directory.                                         | `${CONCOURSE_BASE_DIR}/web/public`         |
| `CONCOURSE_SESSION_SIGNING_KEY_FILE`              | Concourse private key for signing.                                      | `${CONCOURSE_KEY_DIR}/session_signing_key` |
| `CONCOURSE_TSA_HOST_KEY_FILE`                     | Concourse private key for TSA.                                          | `${CONCOURSE_KEY_DIR}/tsa_host_key`        |
| `CONCOURSE_TSA_HOST_PUBLIC_KEY_FILE`              | Concourse public key for TSA.                                           | `${CONCOURSE_TSA_HOST_KEY_FILE}.pub`       |
| `CONCOURSE_TSA_WORKER_KEY_FILE`                   | Concourse private key for worker.                                       | `${CONCOURSE_KEY_DIR}/worker_key`          |
| `CONCOURSE_TSA_WORKER_PUBLIC_KEY_FILE`            | Concourse public key for worker.                                        | `${CONCOURSE_TSA_WORKER_PRIVATE_KEY}.pub`  |
| `CONCOURSE_USERNAME`                              | Concourse main local user.                                              | `user`                                     |
| `CONCOURSE_PASSWORD`                              | Concourse local user password.                                          | `bitnami`                                  |
| `CONCOURSE_RUNTIME`                               | Concourse runtime.                                                      | `containerd`                               |
| `CONCOURSE_WEB_PORT_NUMBER`                       | Concourse Web port.                                                     | `8080`                                     |
| `CONCOURSE_WEB_TSA_PORT_NUMBER`                   | Concourse Web TSA port                                                  | `2222`                                     |
| `CONCOURSE_WEB_TSA_DEBUG_PORT_NUMBER`             | Concourse Web Debug TSA port                                            | `2221`                                     |
| `CONCOURSE_WORKER_GARDEN_PORT_NUMBER`             | Concourse Worker Garden port                                            | `7777`                                     |
| `CONCOURSE_WORKER_BAGGAGECLAIM_PORT_NUMBER`       | Concourse worker Baggageclaim port                                      | `7788`                                     |
| `CONCOURSE_WORKER_BAGGAGECLAIM_DEBUG_PORT_NUMBER` | Concourse worker Baggageclaim debug port                                | `7787`                                     |
| `CONCOURSE_WORKER_HEALTH_PORT_NUMBER`             | Concourse worker healthcheck port                                       | `8888`                                     |
| `CONCOURSE_BIND_IP`                               | Concourse bind IP                                                       | `0.0.0.0`                                  |
| `CONCOURSE_TSA_BIND_IP`                           | Concourse TSA bind IP                                                   | `127.0.0.1`                                |
| `CONCOURSE_TSA_DEBUG_BIND_IP`                     | Concourse TSA debug bind IP                                             | `127.0.0.1`                                |
| `CONCOURSE_EXTERNAL_URL`                          | Concourse external URL                                                  | `http://127.0.0.1`                         |
| `CONCOURSE_PEER_ADDRESS`                          | Concourse peer address                                                  | `127.0.0.1`                                |
| `CONCOURSE_APACHE_HTTP_PORT_NUMBER`               | Concourse Web HTTP port, exposed via Apache with basic authentication.  | `80`                                       |
| `CONCOURSE_APACHE_HTTPS_PORT_NUMBER`              | Concourse Web HTTPS port, exposed via Apache with basic authentication. | `443`                                      |
| `CONCOURSE_DATABASE_HOST`                         | Database host address.                                                  | `127.0.0.1`                                |
| `CONCOURSE_DATABASE_PORT_NUMBER`                  | Database host port.                                                     | `5432`                                     |
| `CONCOURSE_DATABASE_NAME`                         | Database name.                                                          | `bitnami_concourse`                        |
| `CONCOURSE_DATABASE_USERNAME`                     | Database username.                                                      | `bn_concourse`                             |
| `CONCOURSE_DATABASE_PASSWORD`                     | Database password.                                                      | `nil`                                      |

#### Read-only environment variables

| Name                        | Description                                | Value                                        |
|-----------------------------|--------------------------------------------|----------------------------------------------|
| `CONCOURSE_BASE_DIR`        | Concourse installation directory.          | `${BITNAMI_ROOT_DIR}/concourse`              |
| `CONCOURSE_BIN_DIR`         | Concourse directory for binary files.      | `${CONCOURSE_BASE_DIR}/bin`                  |
| `CONCOURSE_LOGS_DIR`        | Concourse logs directory.                  | `${CONCOURSE_BASE_DIR}/logs`                 |
| `CONCOURSE_TMP_DIR`         | Concourse temporary directory.             | `${CONCOURSE_BASE_DIR}/tmp`                  |
| `CONCOURSE_WEB_LOG_FILE`    | Concourse log file for the web service.    | `${CONCOURSE_LOGS_DIR}/concourse-web.log`    |
| `CONCOURSE_WEB_PID_FILE`    | Concourse PID file for the web service.    | `${CONCOURSE_TMP_DIR}/concourse-web.pid`     |
| `CONCOURSE_WORKER_LOG_FILE` | Concourse log file for the worker service. | `${CONCOURSE_LOGS_DIR}/concourse-worker.log` |
| `CONCOURSE_WORKER_PID_FILE` | Concourse PID file for the worker service. | `${CONCOURSE_TMP_DIR}/concourse-worker.pid`  |
| `CONCOURSE_KEY_DIR`         | Concourse keys directory.                  | `${CONCOURSE_BASE_DIR}/concourse-keys`       |
| `CONCOURSE_VOLUME_DIR`      | Concourse directory for mounted data.      | `${BITNAMI_VOLUME_DIR}/concourse`            |
| `CONCOURSE_DAEMON_USER`     | Concourse daemon system user.              | `concourse`                                  |
| `CONCOURSE_DAEMON_GROUP`    | Concourse daemon system group.             | `concourse`                                  |

## Logging

The Bitnami concourse Docker image sends the container logs to `stdout`. To view the logs:

```console
docker logs concourse
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of concourse, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/concourse:latest
```

#### Step 2: Stop the running container

Stop the currently running container using the command

```console
docker stop concourse
```

#### Step 3: Remove the currently running container

```console
docker rm -v concourse
```

#### Step 4: Run the new image

Re-create your container from the new image.

```console
docker run --name concourse bitnami/concourse:latest
```

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/concourse).

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
