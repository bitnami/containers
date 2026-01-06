# Bitnami Secure Image for Cypress

## What is Cypress?

> Cypress is a next-gen front-end testing tool built on Node.js for modern web. Features an improved UI, multiple browser support and high debuggability and real-time reloads.

[Overview of Cypress](https://www.cypress.io/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run -it --name cypress bitnami/cypress
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

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami cypress Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/cypress).

```console
docker pull bitnami/cypress:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/cypress/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/cypress:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Configuration

### Running your Cypress app

The default work directory for the Cypress image is `/app`. You can mount a folder from your host here that includes your Cypress script, and run it normally using the `cypress` command.

```console
docker run -it --name cypress -v /path/to/app:/app bitnami/cypress
```

**Further Reading:**

- [cypress documentation](https://www.cypress.io//docs)

### Browsers

By default, the Cypress image contains the `chromium` browser included in the distro package repositories. In order to include extra browsers, you can extend the image using Cypress as a base. In the example below, we add the Firefox browser to the image:

```dockerfile
FROM bitnami/cypress:latest

USER 0
RUN apt update && apt install dirmngr ca-certificates software-properties-common apt-transport-https wget -y
RUN wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | gpg --dearmor && tee /usr/share/keyrings/packages.mozilla.org.gpg > /dev/null
RUN echo "deb [signed-by=/usr/share/keyrings/packages.mozilla.org.gpg] https://packages.mozilla.org/apt mozilla main" | tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null
RUN apt update
RUN apt install firefox -y
RUN apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives
USER 1001
```

### FIPS configuration in Bitnami Secure Images

The Bitnami Cypress Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of Cypress, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/cypress:latest
```

#### Step 2: Remove the currently running container

```console
docker rm -v cypress
```

#### Step 3: Run the new image

Re-create your container from the new image.

```console
docker run --name cypress bitnami/cypress:latest
```

## Contributing

We'd love for you to contribute to this Docker image. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues) or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/containers/issues/new/choose). For us to provide better support, be sure to fill the issue template.

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
