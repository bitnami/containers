# Bitnami package for Grafana Image Renderer

## What is Grafana Image Renderer?

> The Grafana Image Renderer is a plugin for Grafana that uses headless Chrome to render panels and dashboards as PNG images.

[Overview of Grafana Image Renderer](https://github.com/grafana/grafana-image-renderer)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name grafana-image-renderer bitnami/grafana-image-renderer:latest
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use Grafana Image Renderer in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## How to deploy Grafana Image Renderer in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Grafana Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/grafana).

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

The recommended way to get the Bitnami Grafana Image Renderer Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/grafana-image-renderer).

```console
docker pull bitnami/grafana-image-renderer:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/grafana-image-renderer/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/grafana-image-renderer:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the hostname.

### Using the Command Line

#### Step 1: Create a network

```console
docker network create my-network --driver bridge
```

#### Step 2: Launch the grafana-image-renderer container within your network

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `my-network` network.

```console
docker run -d --name grafana-image-renderer \
    --env HTTP_PORT="8080" \
    --env HTTP_HOST="0.0.0.0" \
    --network my-network \
    bitnami/grafana-image-renderer:latest
```

#### Step 3: Launch a Grafana container within your network that uses grafana-image-renderer as rendering service

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `my-network` network.

```console
docker run -d --name grafana \
    --network my-network \
    --publish 3000:3000 \
    --env GF_RENDERING_SERVER_URL="http://grafana-image-renderer:8080/render" \
    --env GF_RENDERING_CALLBACK_URL="http://grafana:3000" \
    --env GF_LOG_FILTERS="rendering:debug" \
    bitnami/grafana:latest
```

## Configuration

You can customize Grafana Image Renderer settings by replacing the default configuration file with your custom configuration, or using environment variables.

### Environment variables

#### Customizable environment variables

| Name                                    | Description                                          | Default Value |
|-----------------------------------------|------------------------------------------------------|---------------|
| `GRAFANA_IMAGE_RENDERER_LISTEN_ADDRESS` | Grafana Image Renderer listen address                | `127.0.0.1`   |
| `GRAFANA_IMAGE_RENDERER_PORT_NUMBER`    | Grafana Image Renderer port number                   | `8080`        |
| `GRAFANA_IMAGE_RENDERER_ENABLE_METRICS` | Whether to enable metrics for Grafana Image Renderer | `yes`         |

#### Read-only environment variables

| Name                                  | Description                                                  | Value                                                 |
|---------------------------------------|--------------------------------------------------------------|-------------------------------------------------------|
| `GRAFANA_IMAGE_RENDERER_BASE_DIR`     | Path to the Grafana Image Renderer installation directory    | `${BITNAMI_ROOT_DIR}/grafana-image-renderer`          |
| `GRAFANA_IMAGE_RENDERER_TMP_DIR`      | Grafana Image Renderer directory for temporary runtime files | `${GRAFANA_IMAGE_RENDERER_BASE_DIR}/tmp`              |
| `GRAFANA_IMAGE_RENDERER_LOGS_DIR`     | Grafana Image Renderer directory for log files               | `${GRAFANA_IMAGE_RENDERER_BASE_DIR}/logs`             |
| `GRAFANA_IMAGE_RENDERER_PID_FILE`     | Grafana Image Renderer PID file                              | `${GRAFANA_IMAGE_RENDERER_TMP_DIR}/renderer.pid`      |
| `GRAFANA_IMAGE_RENDERER_LOG_FILE`     | Grafana Image Renderer log file                              | `${GRAFANA_IMAGE_RENDERER_LOGS_DIR}/renderer.log`     |
| `GRAFANA_IMAGE_RENDERER_CONF_FILE`    | Path to the Grafana Image Renderer configuration file        | `${GRAFANA_IMAGE_RENDERER_BASE_DIR}/conf/config.json` |
| `GRAFANA_IMAGE_RENDERER_DAEMON_USER`  | Grafana system user.                                         | `grafana-image-renderer`                              |
| `GRAFANA_IMAGE_RENDERER_DAEMON_GROUP` | Grafana system group.                                        | `grafana-image-renderer`                              |

### Configuration file

The image looks for a `config.json` file in `/opt/bitnami/grafana-image-renderer/conf/`. You can mount a volume at `/opt/bitnami/grafana-image-renderer/conf/` and copy/edit the `config.json` file in the `/path/to/grafana-image-renderer-conf/` path. The default configurations will be populated to the `conf/` directory if it's empty.

```console
/path/to/grafana-image-renderer-conf/
└── config.json

0 directories, 1 file
```

#### Step 1: Run the Grafana Image Renderer container

Run the Grafana Image Renderer container, mounting a directory from your host.

docker run --name grafana-image-renderer bitnami/grafana-image-renderer:latest

```console
docker run --name grafana-image-renderer -v ${PWD}/path/to/grafana-image-renderer-conf:/opt/bitnami/grafana-image-renderer/conf/ bitnami/grafana-image-renderer:latest
```

#### Step 2: Edit the configuration

Edit the configuration on your host using your favorite editor.

```console
vi /path/to/grafana-image-renderer-conf/config.json
```

#### Step 3: Restart Grafana Image Renderer

After changing the configuration, restart your Grafana Image Renderer container for changes to take effect.

After that, your configuration will be taken into account in the server's behaviour.

## Logging

The Bitnami Grafana Image Renderer Docker image sends the container logs to the `stdout`. To view the logs:

```console
docker logs grafana-image-renderer
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of Grafana Image Renderer, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/grafana-image-renderer:latest
```

#### Step 2: Stop the currently running container

Stop the currently running container using the command

```console
docker stop grafana-image-renderer
```

#### Step 3: Remove the currently running container

```console
docker rm -v grafana-image-renderer
```

#### Step 4: Run the new image

Re-create your container from the new image:

```console
docker run --name grafana-image-renderer bitnami/grafana-image-renderer:latest
```

## Notable Changes

### Starting January 16, 2024

* The `docker-compose.yaml` file has been removed, as it was solely intended for internal testing purposes.

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
