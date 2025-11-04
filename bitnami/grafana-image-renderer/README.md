# Bitnami Secure Image for Grafana Image Renderer

## What is Grafana Image Renderer?

> The Grafana Image Renderer is a plugin for Grafana that uses headless Chrome to render panels and dashboards as PNG images.

[Overview of Grafana Image Renderer](https://github.com/grafana/grafana-image-renderer)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name grafana-image-renderer bitnami/grafana-image-renderer:latest
```

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

## How to deploy Grafana Image Renderer in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Grafana Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/grafana).

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

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

| Name                                    | Description                           | Default Value |
|-----------------------------------------|---------------------------------------|---------------|
| `GRAFANA_IMAGE_RENDERER_LISTEN_ADDRESS` | Grafana Image Renderer listen address | `127.0.0.1`   |
| `GRAFANA_IMAGE_RENDERER_PORT_NUMBER`    | Grafana Image Renderer port number    | `8080`        |

#### Read-only environment variables

| Name                                  | Description                                                  | Value                                             |
|---------------------------------------|--------------------------------------------------------------|---------------------------------------------------|
| `GRAFANA_IMAGE_RENDERER_BASE_DIR`     | Path to the Grafana Image Renderer installation directory    | `${BITNAMI_ROOT_DIR}/grafana-image-renderer`      |
| `GRAFANA_IMAGE_RENDERER_TMP_DIR`      | Grafana Image Renderer directory for temporary runtime files | `${GRAFANA_IMAGE_RENDERER_BASE_DIR}/tmp`          |
| `GRAFANA_IMAGE_RENDERER_LOGS_DIR`     | Grafana Image Renderer directory for log files               | `${GRAFANA_IMAGE_RENDERER_BASE_DIR}/logs`         |
| `GRAFANA_IMAGE_RENDERER_PID_FILE`     | Grafana Image Renderer PID file                              | `${GRAFANA_IMAGE_RENDERER_TMP_DIR}/renderer.pid`  |
| `GRAFANA_IMAGE_RENDERER_LOG_FILE`     | Grafana Image Renderer log file                              | `${GRAFANA_IMAGE_RENDERER_LOGS_DIR}/renderer.log` |
| `GRAFANA_IMAGE_RENDERER_DAEMON_USER`  | Grafana system user.                                         | `grafana-image-renderer`                          |
| `GRAFANA_IMAGE_RENDERER_DAEMON_GROUP` | Grafana system group.                                        | `grafana-image-renderer`                          |

### FIPS configuration in Bitnami Secure Images

The Bitnami Grafana Image Renderer Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.

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

### 5.0.3-debian-12-r0

The entire service has been rewritten in Go, replacing the previous Node.js implementation. This new version no longer uses the `config.json` file for configuration. More detailed context can be found on [the upstream PR](https://github.com/grafana/grafana-image-renderer/pull/818).

### Starting January 16, 2024

- The `docker-compose.yaml` file has been removed, as it was solely intended for internal testing purposes.

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
