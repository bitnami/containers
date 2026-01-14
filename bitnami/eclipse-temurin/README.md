# Bitnami Secure Image for Eclipse Temurin

## What is Eclipse Temurin?

> Eclipse Temurin is a high-performance Java runtime (JDK/JRE) built from OpenJDK, offering enterprise-grade stability and security, and serving as a robust, vendor-neutral alternative to Oracle's JDK.

[Overview of Eclipse Temurin](https://adoptium.net/temurin)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name eclipse-temurin bitnami/eclipse-temurin:latest
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

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami Eclipse Temurin Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/eclipse-temurin).

```console
docker pull bitnami/eclipse-temurin:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/eclipse-temurin/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/eclipse-temurin:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Configuration

### Running commands

To run commands inside this container, you can use `docker run`, for example to execute `command --help` you can follow the example below:

```console
docker run --rm --name eclipse-temurin bitnami/eclipse-temurin:latest -- --help
```

Check the [official Eclipse Temurin documentation](https://adoptium.net/temurin for more information.

### Running your Eclipse Temurin jar or war

The default work directory for the Eclipse Temurin image is `/app`. You can mount a folder from your host here that includes your Eclipse Temurin jar or war, and run it normally using the `java` command.

```console
docker run -it --name eclipse-temurin -v /path/to/app:/app bitnami/eclipse-temurin:latest \
  java -jar package.jar
```

## Replace the default truststore using a custom base image

In case you are replacing the default [minideb](https://github.com/bitnami/minideb) base image with a custom base image (based on Debian), it is possible to replace the default truststore located in the `/opt/bitnami/java/lib/security` folder. This is done by setting the `JAVA_EXTRA_SECURITY_DIR` docker build ARG variable, which needs to point to a location that contains a *cacerts* file that would substitute the originally bundled truststore. In the following example we will use a minideb fork that contains a custom *cacerts* file in the */bitnami/java/extra-security* folder:

- In the Dockerfile, replace `FROM docker.io/bitnami/minideb:latest` to use a custom image, defined with the `MYJAVAFORK:TAG` placeholder:

```diff
- FROM bitnami/minideb:latest
+ FROM MYFORK:TAG
```

- Run `docker build` setting the value of `JAVA_EXTRA_SECURITY_DIR`. Remember to replace the `MYJAVAFORK:TAG` placeholder.

```console
docker build --build-arg JAVA_EXTRA_SECURITY_DIR=/bitnami/java/extra-security -t MYJAVAFORK:TAG .
```

### FIPS configuration in Bitnami Secure Images

The Bitnami Eclipse Temurin Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues) or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

## Issues

If you encounter a problem running this container, you can file an [issue](https://github.com/bitnami/containers/issues/new/choose). For us to provide better support, be sure to fill the issue template.

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
