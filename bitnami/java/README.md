# Bitnami Secure Image for Java

> Java is a general-purpose computer programming language that is concurrent, class-based, object-oriented, and specifically designed to have as few implementation dependencies as possible.

[Overview of Java](https://openjdk.org)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run -it --name java bitnami/java
```

## Using `docker-compose.yml`

The docker-compose.yaml file of this container can be found in the [Bitnami Containers repository](https://github.com/bitnami/containers/).

[https://github.com/bitnami/containers/tree/main/bitnami/java/docker-compose.yml](https://github.com/bitnami/containers/tree/main/bitnami/java/docker-compose.yml)

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

### Deprecation Note (2022-01-21)

The `prod` tags has been removed; from now on just the regular container images will be released.

### Deprecation Note (2020-08-18)

The formatting convention for `prod` tags has been changed:

- `BRANCH-debian-10-prod` is now tagged as `BRANCH-prod-debian-10`
- `VERSION-debian-10-rX-prod` is now tagged as `VERSION-prod-debian-10-rX`
- `latest-prod` is now deprecated

## Get this image

The Bitnami Java Docker image is only available to [Bitnami Secure Images](https://bitnami.com) customers.

## Configuration

The following section describes how to run commands

### Running your Java jar or war

The default work directory for the Java image is `/app`. You can mount a folder from your host here that includes your Java jar or war, and run it normally using the `java` command.

```console
docker run -it --name java -v /path/to/app:/app bitnami/java:latest \
  java -jar package.jar
```

or using Docker Compose:

```yaml
java:
  image: bitnami/java:latest
  command: "java -jar package.jar"
  volumes:
    - .:/app
```

**Further Reading:**

- [Java SE Documentation](https://docs.oracle.com/javase/8/docs/api/)

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

The Bitnami Java Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.
- `JAVA_TOOL_OPTIONS`: controls Java FIPS mode. Use `-Djava.security.properties==/opt/bitnami/java/conf/security/java.security.restricted` (restricted), `-Djava.security.properties==/opt/bitnami/java/conf/security/java.security.relaxed` (relaxed), or `-Djava.security.properties==/opt/bitnami/java/conf/security/java.security.original` (off).

## Notable Changes

### 1.8.252-debian-10-r0, 11.0.7-debian-10-r7, and 15.0.1-debian-10-r20

- Java distribution has been migrated from AdoptOpenJDK to OpenJDK Liberica. As part of VMware, we have an agreement with Bell Software to distribute the Liberica distribution of OpenJDK. That way, we can provide support & the latest versions and security releases for Java.

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
