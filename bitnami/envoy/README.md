# Bitnami Secure Image for Envoy

> Envoy is a distributed, high-performance proxy for cloud-native applications. It features a small memory footprint, universal application language compatibility, and supports http/2 and gRPC.

[Overview of Envoy](https://www.envoyproxy.io/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name envoy bitnami/envoy:latest
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

The Bitnami Envoy Docker image is only available to [Bitnami Secure Images](https://bitnami.com) customers.

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/contour).

## Configuration

The following section describes how to run commands

### Running commands

To run commands inside this container you can use `docker run`, for example to execute `envoy --version` you can follow the example below:

```console
docker run --rm --name envoy bitnami/envoy:latest -- --version
```

Check the [official envoy documentation](https://www.envoyproxy.io/docs/envoy/latest/operations/cli) for a list of the available parameters.

### Adding your custom configuration

By default, envoy will look for a configuration file in `/opt/bitnami/envoy/conf/envoy.yaml`. You can launch the envoy container with your custom configuration with the command below:

```console
docker run --rm -v /path/to/your/envoy.yaml:/opt/bitnami/envoy/conf/envoy.yaml bitnami/envoy:latest
```

Visit the [official envoy documentation](https://www.envoyproxy.io/docs/envoy/latest/configuration/configuration) for all the available configurations.

### FIPS configuration in Bitnami Secure Images

The Bitnami Envoy Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

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
