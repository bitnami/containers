# Bitnami Secure Image for ASP.NET Core

## What is ASP.NET Core?

> ASP.NET Core is an open-source framework for web application development created by Microsoft. It runs on both the full .NET Framework, on Windows, and the cross-platform .NET Core.

[Overview of ASP.NET Core](https://github.com/dotnet/aspnetcore)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name aspnet-core bitnami/aspnet-core:latest
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

## Choosing between the _Standard_ and _Minimal_ image

This asset is available in two flavors: _Standard_ and _Minimal_; designed to address different use cases and operational needs.

### Standard images

The standard images are full-featured, production-ready containers built on top of secure base operating systems. They include:

- The complete runtime and commonly used system tools.
- A familiar Linux environment (shell, package manager, debugging utilities).
- Full compatibility with most CI/CD pipelines and existing workloads.

Recommended for:

- Development and testing environments.
- Workloads requiring package installation or debugging tools.
- Applications that depend on system utilities or shared libraries.

### Minimal images

The minimal images are optimized, distroless-style containers derived from a stripped-down base. They only ship what’s strictly necessary to run the application; no shell, package manager, or extra libraries. They provide:

- Smaller size: Faster pull and startup times.
- Reduced attack surface: Fewer components and potential vulnerabilities.
- Simpler maintenance: Fewer dependencies to patch or update.

Recommended for:

- Production environments prioritizing performance and security.
- Regulated or security-sensitive workloads
- Containers built via multi-stage builds (e.g., Golang static binaries).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

## Get this image

The recommended way to get the Bitnami aspnet-core Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/aspnet-core).

```console
docker pull bitnami/aspnet-core:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/aspnet-core/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/aspnet-core:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/app` path. If the mounted directory is empty, it will be initialized on the first run.

```console
docker run \
    -v /path/to/aspnet-core-persistence:/app \
    bitnami/aspnet-core:latest
```

You can also do this with a minor change to the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/aspnet-core/docker-compose.yml) file present in this repository:

```yaml
aspnet-core:
  ...
  volumes:
    - /path/to/aspnet-core-persistence:/app
  ...
```

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the hostname.

### Using the Command Line

#### Step 1: Create a network

```console
docker network create aspnet-core-network --driver bridge
```

#### Step 2: Launch the aspnet-core container within your network

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `aspnet-core-network` network.

```console
docker run --name aspnet-core-node1 --network aspnet-core-network bitnami/aspnet-core:latest
```

#### Step 3: Run another containers

We can launch another containers using the same flag (`--network NETWORK`) in the `docker run` command. If you also set a name to your container, you will be able to use it as hostname in your network.

## Configuration

### FIPS configuration in Bitnami Secure Images

The Bitnami ASP.NET Core Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.

## Logging

The Bitnami aspnet-core Docker image sends the container logs to `stdout`. To view the logs:

```console
docker logs aspnet-core
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of aspnet-core, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/aspnet-core:latest
```

#### Step 2: Stop the running container

Stop the currently running container using the command

```console
docker stop aspnet-core
```

#### Step 3: Remove the currently running container

```console
docker rm -v aspnet-core
```

#### Step 4: Run the new image

Re-create your container from the new image.

```console
docker run --name aspnet-core bitnami/aspnet-core:latest
```

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/aspnet-core).

If you detect any issue in the `docker-compose.yaml` file, feel free to report it or contribute with a fix by following our [Contributing Guidelines](https://github.com/bitnami/containers/blob/main/CONTRIBUTING.md).

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
