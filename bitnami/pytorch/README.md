# Bitnami Secure Image for PyTorch

> PyTorch is a deep learning platform that accelerates the transition from research prototyping to production deployment. Bitnami image includes Torchvision for specific computer vision support.

[Overview of PyTorch](https://pytorch.org/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run -it --name pytorch bitnami/pytorch
```

## Using `docker-compose.yml`

The docker-compose.yaml file of this container can be found in the [Bitnami Containers repository](https://github.com/bitnami/containers/).

[https://github.com/bitnami/containers/tree/main/bitnami/pytorch/docker-compose.yml](https://github.com/bitnami/containers/tree/main/bitnami/pytorch/docker-compose.yml)

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/pytorch).

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

The Bitnami PyTorch Docker image is only available to [Bitnami Secure Images](https://bitnami.com) customers.

## Entering the REPL

By default, running this image will drop you into the Python REPL, where you can interactively test and try things out with PyTorch in Python.

```console
docker run -it --name pytorch bitnami/pytorch
```

## Configuration

The following sections describe how to run your app and configure FIPS.

### Running your PyTorch app

The default work directory for the PyTorch image is `/app`. You can mount a folder from your host here that includes your PyTorch script and run it normally using the `python` command.

```console
docker run -it --name pytorch -v /path/to/app:/app bitnami/pytorch \
  python script.py
```

### Running a PyTorch app with package dependencies

If your PyTorch app has a `requirements.txt` defining your app's dependencies, you can install the dependencies before running your app.

```console
docker run -it --name pytorch -v /path/to/app:/app bitnami/pytorch \
  sh -c "conda install -y --file requirements.txt && python script.py"
```

**Additional documentation:**

- [PyTorch documentation](https://pytorch.org/docs/stable/index.html)
- [Conda documentation](https://docs.conda.io/en/latest/)

### FIPS configuration in Bitnami Secure Images

The Bitnami PyTorch Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.

## Notable changes

### 1.9.0-debian-10-r3

This version removes `miniconda` in favour of `pip`. This creates a smaller container and least prone to security issues. Users extending this container with other packages will need to switch from `conda` to `pip` commands.

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
