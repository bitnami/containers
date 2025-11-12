# Bitnami Secure Image for Python

## What is Python?

> Python is a programming language that lets you work quickly and integrate systems more effectively.

[Overview of Python](https://www.python.org/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run -it --name python bitnami/python
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

### Deprecation Note (2022-01-21)

The `prod` tags has been removed; from now on just the regular container images will be released.

### Deprecation Note (2020-08-18)

The formatting convention for `prod` tags has been changed:

- `BRANCH-debian-10-prod` is now tagged as `BRANCH-prod-debian-10`
- `VERSION-debian-10-rX-prod` is now tagged as `VERSION-prod-debian-10-rX`
- `latest-prod` is now deprecated

## Get this image

The recommended way to get the Bitnami Python Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/python).

```console
docker pull bitnami/python:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/python/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/python:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Entering the REPL

By default, running this image will drop you into the Python REPL, where you can interactively test and try things out in Python.

```console
docker run -it --name python bitnami/python
```

## Configuration

### Running your Python script

The default work directory for the Python image is `/app`. You can mount a folder from your host here that includes your Python script, and run it normally using the `python` command.

```console
docker run -it --name python -v /path/to/app:/app bitnami/python \
  python script.py
```

### Running a Python app with package dependencies

If your Python app has a `requirements.txt` defining your app's dependencies, you can install the dependencies before running your app.

```console
docker run --rm -v /path/to/app:/app bitnami/python pip install -r requirements.txt
docker run -it --name python -v /path/to/app:/app bitnami/python python script.py
```

or using Docker Compose:

```yaml
python:
  image: bitnami/python:latest
  command: "sh -c 'pip install -r requirements.txt && python script.py'"
  volumes:
    - .:/app
```

**Further Reading:**

- [python documentation](https://www.python.org/doc/)
- [pip documentation](https://pip.pypa.io/en/stable/)

### FIPS configuration in Bitnami Secure Images

The Bitnami Python Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of Python, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/python:latest
```

or if you're using Docker Compose, update the value of the image property to `bitnami/python:latest`.

#### Step 2: Remove the currently running container

```console
docker rm -v python
```

or using Docker Compose:

```console
docker-compose rm -v python
```

#### Step 3: Run the new image

Re-create your container from the new image.

```console
docker run --name python bitnami/python:latest
```

or using Docker Compose:

```console
docker-compose up python
```

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes.

If you detect any issue in the `docker-compose.yaml` file, feel free to report it or contribute with a fix by following our [Contributing Guidelines](https://github.com/bitnami/containers/blob/main/CONTRIBUTING.md).

## Contributing

We'd love for you to contribute to this Docker image. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues) or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/containers/issues/new/choose). For us to provide better support, be sure to fill the issue template.

## License

Copyright &copy; 2025 Broadcom. The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
