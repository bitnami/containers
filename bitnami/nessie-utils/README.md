# Bitnami Secure Image for Nessie Utils

## What is Nessie Utils?

> Nessie Utils contains the tools nessie-cli, nessie-gc and nessie-admin-server-tool. Nessie is an open-source version control system for data lakes.

[Overview of Nessie Utils](https://projectnessie.org/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run -it --name nessie-utils bitnami/nessie-utils
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

## Get this image

The recommended way to get the Bitnami Nessie Utils Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/nessie-utils).

```console
docker pull bitnami/nessie-utils:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/nessie-utils/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/nessie-utils:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of Nessie Utils, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/nessie-utils:latest
```

or if you're using Docker Compose, update the value of the image property to `bitnami/nessie-utils:latest`.

#### Step 2: Remove the currently running container

```console
docker rm -v nessie-utils
```

#### Step 3: Run the new image

Re-create your container from the new image.

```console
docker run --name nessie-utils bitnami/nessie-utils:latest
```

## Configuration

### Running commands

This container contains the nessie-cli, nessie-server-admin-tool and nessie-gc tools. These are the commands for running the different tools:

Running nessie-cli:

```console
docker run --rm --name nessie-utils bitnami/nessie-utils:latest -jar /opt/bitnami/nessie-utils/nessie-cli/nessie-cli.jar
```

Running nessie-gc:

```console
docker run --rm --name nessie-utils bitnami/nessie-utils:latest -jar /opt/bitnami/nessie-utils/nessie-gc/nessie-gc.jar
```

Running nessie-server-admin-tool:

```console
docker run --rm --name nessie-utils bitnami/nessie-utils:latest -jar /opt/bitnami/nessie-utils/nessie-server-admin-tool/quarkus-run.jar
```

Check the [official Nessie Utils documentation](https://projectnessie.org/) for more information about how to use Nessie Utils.

### Configuration variables

This container supports the upstream Nessie Utils environment variables. Check the [official Nessie Utils documentation](https://projectnessie.org//nessie-utils-latest/configuration/) for the possible environment variables.

### FIPS configuration in Bitnami Secure Images

The Bitnami Nessie Utils Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.

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
