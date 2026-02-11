# Bitnami Secure Image for Kaniko

## What is Kaniko?

> Kaniko is a tool that builds and pushes container images directly in userspace. This allows securely building container images in environments like a standard Kubernetes cluster.

[Overview of Kaniko](https://github.com/chainguard-dev/kaniko)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run -it --name kaniko bitnami/kaniko
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

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

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

## Get this image

The recommended way to get the Bitnami Kaniko Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/kaniko).

```console
docker pull bitnami/kaniko:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/kaniko/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/kaniko:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of Kaniko, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/kaniko:latest
```

#### Step 2: Remove the currently running container

```console
docker rm -v kaniko
```

#### Step 3: Run the new image

Re-create your container from the new image.

```console
docker run --name kaniko bitnami/kaniko:latest
```

## Configuration

### Running commands

To run commands inside this container you can use `docker run`, for example to execute `kaniko --help` you can follow the example below:

```console
docker run --rm --name kaniko bitnami/kaniko:latest --help
```

Check the [official Kaniko documentation](https://github.com/chainguard-dev/kanikodocs/) for more information about how to use Kaniko.

## Notable Changes

### Starting September 23, 2025

* The `bitnami/kaniko` is now based on minimal Linux distribution instead of scratch. This change means the container now includes a shell and basic utilities, allowing you to easily debug and troubleshoot within the container.

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
