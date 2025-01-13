# Bitnami package for Logstash

## What is Logstash?

> Logstash is an open source data processing engine. It ingests data from multiple sources, processes it, and sends the output to final destination in real-time. It is a core component of the ELK stack.

[Overview of Logstash](http://logstash.net)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name logstash bitnami/logstash:latest
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use Logstash in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## How to deploy Logstash in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Logstash Chart GitHub repository](https://github.com/bitnami/charts/tree/main/bitnami/logstash).

Bitnami containers can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

## Only latest stable branch maintained in the free Bitnami catalog

Starting December 10th 2024, only the latest stable branch of any container will receive updates in the free Bitnami catalog. To access up-to-date releases for all upstream-supported branches, consider upgrading to Bitnami Premium. Previous versions already released will not be deleted. They are still available to pull from DockerHub.

Please check the Bitnami Premium page in our partner [Arrow Electronics](https://www.arrow.com/globalecs/na/vendors/bitnami?utm_source=GitHub&utm_medium=containers) for more information.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami Logstash Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/logstash).

```console
docker pull bitnami/logstash:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/logstash/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/logstash:[TAG]
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
    -v /path/to/logstash-persistence:/bitnami \
    bitnami/logstash:latest
```

You can also do this with a minor change to the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/logstash/docker-compose.yml) file present in this repository:

```yaml
logstash:
  ...
  volumes:
    - /path/to/logstash-persistence:/bitnami
  ...
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the hostname.

### Using the Command Line

#### Step 1: Create a network

```console
docker network create logstash-network --driver bridge
```

#### Step 2: Launch the Logstash container within your network

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `logstash-network` network.

```console
docker run --name logstash-node1 --network logstash-network bitnami/logstash:latest
```

#### Step 3: Run another containers

We can launch another containers using the same flag (`--network NETWORK`) in the `docker run` command. If you also set a name to your container, you will be able to use it as hostname in your network.

## Configuration

By default, this container provides a very basic configuration for Logstash, that listen http on port 8080 and writes to stdout.

```console
docker run -d -p 8080:8080 bitnami/logstash:latest
```

### Environment variables

#### Customizable environment variables

| Name                                     | Description                                             | Default Value   |
|------------------------------------------|---------------------------------------------------------|-----------------|
| `LOGSTASH_PIPELINE_CONF_FILENAME`        | Logstash pipeline file name                             | `logstash.conf` |
| `LOGSTASH_BIND_ADDRESS`                  | Logstash listen address                                 | `0.0.0.0`       |
| `LOGSTASH_EXPOSE_API`                    | Whether to expose the expose the Logstash API           | `no`            |
| `LOGSTASH_API_PORT_NUMBER`               | Logstash API port number                                | `9600`          |
| `LOGSTASH_PIPELINE_CONF_STRING`          | Logstash pipeline configuration in a string             | `nil`           |
| `LOGSTASH_PLUGINS`                       | List of Logstash plugins to install                     | `nil`           |
| `LOGSTASH_EXTRA_FLAGS`                   | Extra arguments for running the Logstash server         | `nil`           |
| `LOGSTASH_HEAP_SIZE`                     | Logstash heap size                                      | `1024m`         |
| `LOGSTASH_MAX_ALLOWED_MEMORY_PERCENTAGE` | Logstash maximum allowed memory percentage              | `100`           |
| `LOGSTASH_MAX_ALLOWED_MEMORY`            | Logstash maximum allowed memory amount (in megabytes)   | `nil`           |
| `LOGSTASH_ENABLE_MULTIPLE_PIPELINES`     | Whether to enable multiple pipelines support            | `no`            |
| `LOGSTASH_ENABLE_BEATS_INPUT`            | Whether to listen for incoming Beats connections        | `no`            |
| `LOGSTASH_BEATS_PORT_NUMBER`             | Port number for listening to incoming Beats connections | `5044`          |
| `LOGSTASH_ENABLE_GELF_INPUT`             | Whether to listen for incoming Gelf connections         | `no`            |
| `LOGSTASH_GELF_PORT_NUMBER`              | Port number for listening to incoming Beats connections | `12201`         |
| `LOGSTASH_ENABLE_HTTP_INPUT`             | Whether to listen for incoming HTTP connections         | `yes`           |
| `LOGSTASH_HTTP_PORT_NUMBER`              | Port number for listening to incoming Beats connections | `8080`          |
| `LOGSTASH_ENABLE_TCP_INPUT`              | Whether to listen for incoming TDP connections          | `no`            |
| `LOGSTASH_TCP_PORT_NUMBER`               | Port number for listening to incoming TCP connections   | `5010`          |
| `LOGSTASH_ENABLE_UDP_INPUT`              | Whether to listen for incoming UDP connections          | `no`            |
| `LOGSTASH_UDP_PORT_NUMBER`               | Port number for listening to incoming UDP connections   | `5000`          |
| `LOGSTASH_ENABLE_STDOUT_OUTPUT`          | Whether to output to an Elasticsearch server            | `yes`           |
| `LOGSTASH_ENABLE_ELASTICSEARCH_OUTPUT`   | Whether to output to an Elasticsearch server            | `no`            |
| `LOGSTASH_ELASTICSEARCH_HOST`            | Elasticsearch server hostname                           | `elasticsearch` |
| `LOGSTASH_ELASTICSEARCH_PORT_NUMBER`     | Elasticsearch server port                               | `9200`          |

#### Read-only environment variables

| Name                                 | Description                                                            | Value                                                              |
|--------------------------------------|------------------------------------------------------------------------|--------------------------------------------------------------------|
| `LOGSTASH_BASE_DIR`                  | Logstash installation directory                                        | `/opt/bitnami/logstash`                                            |
| `LOGSTASH_CONF_DIR`                  | Logstash settings files directory                                      | `${LOGSTASH_BASE_DIR}/config`                                      |
| `LOGSTASH_DEFAULT_CONF_DIR`          | Logstash default settings files directory                              | `${LOGSTASH_BASE_DIR}/config.default`                              |
| `LOGSTASH_PIPELINE_CONF_DIR`         | Logstash pipeline configuration files directory                        | `${LOGSTASH_BASE_DIR}/pipeline`                                    |
| `LOGSTASH_DEFAULT_PIPELINE_CONF_DIR` | Logstash default pipeline configuration files directory                | `${LOGSTASH_BASE_DIR}/pipeline.default`                            |
| `LOGSTASH_BIN_DIR`                   | Logstash executables directory                                         | `${LOGSTASH_BASE_DIR}/bin`                                         |
| `LOGSTASH_CONF_FILE`                 | Path to Logstash settings file                                         | `${LOGSTASH_CONF_DIR}/logstash.yml`                                |
| `LOGSTASH_PIPELINE_CONF_FILE`        | Path to Logstash pipeline configuration file                           | `${LOGSTASH_PIPELINE_CONF_DIR}/${LOGSTASH_PIPELINE_CONF_FILENAME}` |
| `LOGSTASH_VOLUME_DIR`                | Persistence base directory                                             | `/bitnami/logstash`                                                |
| `LOGSTASH_DATA_DIR`                  | Logstash data directory                                                | `${LOGSTASH_VOLUME_DIR}/data`                                      |
| `LOGSTASH_MOUNTED_CONF_DIR`          | Directory where Logstash settings files will be mounted.               | `${LOGSTASH_VOLUME_DIR}/config`                                    |
| `LOGSTASH_MOUNTED_PIPELINE_CONF_DIR` | Directory where Logstash pipeline configuration files will be mounted. | `${LOGSTASH_VOLUME_DIR}/pipeline`                                  |
| `LOGSTASH_DAEMON_USER`               | Logstash system user                                                   | `logstash`                                                         |
| `LOGSTASH_DAEMON_GROUP`              | Logstash system group                                                  | `logstash`                                                         |
| `JAVA_HOME`                          | Java installation folder.                                              | `${BITNAMI_ROOT_DIR}/java`                                         |

### Using a configuration string

For simple configurations, you specify it using the `LOGSTASH_CONF_STRING` environment variable:

```console
docker run --env LOGSTASH_CONF_STRING="input {file {path => \"/tmp/logstash_input\"}} output {file {path => \"/tmp/logstash_output\"}}" bitnami/logstash:latest
```

### Using a configuration file

You can override the default configuration for Logstash by mounting your own configuration files on directory `/bitnami/logstash/pipeline`. You will need to indicate the file holding the pipeline definition by setting the `LOGSTASH_PIPELINE_CONF_FILENAME` environment variable.

```console
docker run -d --env LOGSTASH_PIPELINE_CONF_FILENAME=my_config.conf -v /path/to/custom-conf-directory:/bitnami/logstash/pipeline bitnami/logstash:latest
```

### Additional command line options

In case you want to add extra flags to the Logstash command, use the `LOGSTASH_EXTRA_FLAGS` variable. Example:

```console
docker run -d --env LOGSTASH_EXTRA_FLAGS="-w 4 -b 4096" bitnami/logstash:latest
```

### Using multiple pipelines

You can use [multiple pipelines](https://www.elastic.co/guide/en/logstash/master/multiple-pipelines.html) by setting the `LOGSTASH_ENABLE_MULTIPLE_PIPELINES` environment variable to `true`.

In that case, you should place your `pipelines.yml` file in the mounted volume (together with the rest of the desired configuration files). If the `LOGSTASH_ENABLE_MULTIPLE_PIPELINES` environment variable is set to `true` but there is not any `pipelines.yml` file in the mounted volume, a dummy file is created using `LOGSTASH_PIPELINE_CONF_FILENAME` as a single pipeline.

```console
docker run -d --env LOGSTASH_ENABLE_MULTIPLE_PIPELINES=true -v /path/to/custom-conf-directory:/bitnami/logstash/config bitnami/logstash:latest
```

### Exposing Logstash API

You can expose the Logstash API by setting the environment variable `LOGSTASH_EXPOSE_API`, you can also change the default port by using `LOGSTASH_API_PORT_NUMBER`.

```console
docker run -d --env LOGSTASH_EXPOSE_API=yes --env LOGSTASH_API_PORT_NUMBER=9090 -p 9090:9090 bitnami/logstash:latest
```

### Plugins

You can add extra plugins by setting the `LOGSTASH_PLUGINS` environment variable. To specify multiple plugins, separate them by spaces, commas or semicolons. When the container is initialized it will install all of the specified plugins before starting Logstash.

```console
docker run -d --name logstash \
    -e LOGSTASH_PLUGINS=logstash-input-github \
    bitnami/logstash:latest
```

#### Adding plugins at build time (persisting plugins)

The Bitnami Logstash image provides a way to create your custom image installing plugins on build time. This is the preferred way to persist plugins when using Logstash, as they will not be installed every time the container is started but just once at build time.

To create your own image providing plugins execute the following command. Remember to replace the `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/logstash/VERSION/OPERATING-SYSTEM
docker build --build-arg LOGSTASH_PLUGINS=<plugin1,plugin2,...> -t bitnami/logstash:latest .
```

The command above will build the image providing this GitHub repository as build context, and will pass the list of plugins to install to the build logic.

## Logging

The Bitnami Logstash Docker image sends the container logs to `stdout`. To view the logs:

```console
docker logs logstash
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

Additionally, in case you'd like to modify Logstash logging configuration, it can be done by overwriting the file `/opt/bitnami/logstash/config/log4j2.properties`.
The syntax of this file can be found in Logstash [logging documentation](https://www.elastic.co/guide/en/logstash/current/logging.html).

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of Logstash, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/logstash:latest
```

#### Step 2: Stop the running container

Stop the currently running container using the command

```console
docker stop logstash
```

#### Step 3: Remove the currently running container

```console
docker rm -v logstash
```

#### Step 4: Run the new image

Re-create your container from the new image.

```console
docker run --name logstash bitnami/logstash:latest
```

## Notable Changes

### 7.15.2-debian-10-r12

* Pipeline configuration files (i.e. `default_config.conf`) are being added into the `/opt/bitnami/logstash/pipeline` directory, instead of `/opt/bitnami/logstash/config`. Subsequently, `LOGSTASH_CONF_FILENAME` was renamed to `LOGSTASH_PIPELINE_CONF_FILENAME`, and `LOGSTASH_CONF_STRING` was renamed to `LOGSTASH_PIPELINE_CONF_STRING`.

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/logstash).

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
