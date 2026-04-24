# Bitnami Secure Image for HAProxy

> HAProxy is a TCP proxy and a HTTP reverse proxy. It supports SSL termination and offloading, TCP and HTTP normalization, traffic regulation, caching and protection against DDoS attacks.

[Overview of HAProxy](https://www.haproxy.org/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name haproxy bitnami/haproxy:latest
```

## Using `docker-compose.yml`

The docker-compose.yaml file of this container can be found in the [Bitnami Containers repository](https://github.com/bitnami/containers/).

[https://github.com/bitnami/containers/tree/main/bitnami/haproxy/docker-compose.yml](https://github.com/bitnami/containers/tree/main/bitnami/haproxy/docker-compose.yml)

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/haproxy).

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

The Bitnami HAProxy Docker image is only available to [Bitnami Secure Images](https://bitnami.com) customers.

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

## Configuration

The following section describes how to run commands

### Running commands

To run commands inside this container you can use `docker run`, for example to execute `haproxy --version` you can follow the example below:

```console
docker run --rm --name haproxy bitnami/haproxy:latest -- --version
```

In order for the container to work, you need to mount your custom `haproxy.cfg` file in `/bitnami/haproxy/conf/`. The following example runs HAProxy with a custom configuration file:

```console
docker run --rm --name haproxy -v /path/to/haproxy.cfg:/bitnami/haproxy/conf/haproxy.cfg bitnami/haproxy:latest
```

Using docker-compose:

```yaml
version: '2'
services:

  haproxy:
    image: bitnami/haproxy:latest
    volumes:
      - /path/to/haproxy.cfg:/bitnami/haproxy/conf/haproxy.cfg
```

Check the [official HAProxy documentation](http://cbonte.github.io/haproxy-dconv/2.5/configuration.html) to understand the possible configurations.

### FIPS configuration in Bitnami Secure Images

The Bitnami HAProxy Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

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
