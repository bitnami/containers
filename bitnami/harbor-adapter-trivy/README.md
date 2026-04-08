# Bitnami Secure Image for Harbor Adapter Trivy

> Harbor Adapter for Trivy translates the Harbor API into Trivy API calls and allows Harbor to provide vulnerability reports on images through Trivy as part of its vulnerability scan.

[Overview of Harbor Adapter Trivy](https://goharbor.io/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

Use this quick command to run the container.

```console
docker run --name harbor-adapter-trivy bitnami/harbor-adapter-trivy:latest
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

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

## Get this image

The Bitnami Harbor Adapter Trivy Docker image is only available to [Bitnami Secure Images](https://bitnami.com) customers.

## Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami` path. If the mounted directory is empty, it will be initialized on the first run.

```console
docker run \
    -v /path/to/harbor-adapter-trivy-persistence:/bitnami \
    bitnami/harbor-adapter-trivy:latest
```

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the host name.

### Using the command line

Follow these steps to run the container using the Docker command line.

1. Create a network.

    ```console
    docker network create harbor-adapter-trivy-network --driver bridge
    ```

2. Launch the Harbor-Adapter-Trivy container within your network.

    Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `harbor-adapter-trivy-network` network.

    ```console
    docker run --name harbor-adapter-trivy-node1 --network harbor-adapter-trivy-network bitnami/harbor-adapter-trivy:latest
    ```

3. Run another container.

    We can launch another container using the same flag (`--network NETWORK`) in the `docker run` command. If you also set a name to your container, you will be able to use it as host name in your network.

## Configuration

Harbor Adapter Trivy is a component of the Harbor application. In order to get the Harbor application running on Kubernetes we encourage you to check the [bitnami/harbor Helm chart](https://github.com/bitnami/charts/tree/master/bitnami/harbor) and configure it using the options exposed in the values.yaml file.

For further information about the specific component itself, please refer to the [source repository documentation](https://goharbor.io/#configuration).

### Environment variables

The following tables list the main variables you can set.

#### Customizable environment variables

| Name                        | Description                                  | Default Value                                |
|-----------------------------|----------------------------------------------|----------------------------------------------|
| `SCANNER_TRIVY_VOLUME_DIR`  | harbor-adapter-trivy installation directory. | `${BITNAMI_VOLUME_DIR}/harbor-adapter-trivy` |
| `SCANNER_TRIVY_CACHE_DIR`   | harbor-adapter-trivy installation directory. | `${SCANNER_TRIVY_VOLUME_DIR}/.cache/trivy`   |
| `SCANNER_TRIVY_REPORTS_DIR` | harbor-adapter-trivy installation directory. | `${SCANNER_TRIVY_VOLUME_DIR}/.cache/reports` |

#### Read-only environment variables

| Name                         | Description                                  | Value                                      |
|------------------------------|----------------------------------------------|--------------------------------------------|
| `SCANNER_TRIVY_BASE_DIR`     | harbor-adapter-trivy installation directory. | `${BITNAMI_ROOT_DIR}/harbor-adapter-trivy` |
| `SCANNER_TRIVY_DAEMON_USER`  | harbor-adapter-trivy system user.            | `trivy-scanner`                            |
| `SCANNER_TRIVY_DAEMON_GROUP` | harbor-adapter-trivy system group.           | `trivy-scanner`                            |

### FIPS configuration in Bitnami Secure Images

The Bitnami Harbor Adapter Trivy Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.

## Logging

The Bitnami Harbor-Adapter-Trivy Docker image sends the container logs to `stdout`. To view the logs:

```console
docker logs harbor-adapter-trivy
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Notable changes

The following subsections describe notable changes.

### Starting January 16, 2024

- The `docker-compose.yaml` file has been removed, as it was solely intended for internal testing purposes.

## License

Copyright &copy; 2026 Broadcom. The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
