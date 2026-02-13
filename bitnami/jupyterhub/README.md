# Bitnami Secure Image for JupyterHub

## What is JupyterHub?

> JupyterHub brings the power of notebooks to groups of users. It gives users access to computational environments and resources without burdening the users with installation and maintenance tasks.

[Overview of JupyterHub](https://jupyter.org/hub)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

This image is meant to run in a Kubernetes cluster.

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

The recommended way to get the Bitnami jupyterhub Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/jupyterhub).

```console
docker pull bitnami/jupyterhub:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/jupyterhub/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/jupyterhub:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

## Configuration

### Environment variables

#### Customizable environment variables

| Name                              | Description                   | Default Value        |
|-----------------------------------|-------------------------------|----------------------|
| `JUPYTERHUB_USERNAME`             | JupyterHub admin username.    | `user`               |
| `JUPYTERHUB_PASSWORD`             | JupyterHub admin password.    | `bitnami`            |
| `JUPYTERHUB_PROXY_PORT_NUMBER`    | JupyterHub proxy port number. | `8000`               |
| `JUPYTERHUB_DATABASE_TYPE`        | Database server type.         | `postgresql`         |
| `JUPYTERHUB_DATABASE_HOST`        | Database server host.         | `127.0.0.1`          |
| `JUPYTERHUB_DATABASE_PORT_NUMBER` | Database server port.         | `5432`               |
| `JUPYTERHUB_DATABASE_NAME`        | Database name.                | `bitnami_jupyterhub` |
| `JUPYTERHUB_DATABASE_USER`        | Database user name.           | `bn_jupyterhub`      |
| `JUPYTERHUB_DATABASE_PASSWORD`    | Database user password.       | `nil`                |

#### Read-only environment variables

| Name                        | Description                                  | Value                                             |
|-----------------------------|----------------------------------------------|---------------------------------------------------|
| `JUPYTERHUB_BASE_DIR`       | JupyterHub installation directory.           | `${BITNAMI_ROOT_DIR}/jupyterhub`                  |
| `JUPYTERHUB_BIN_DIR`        | JupyterHub directory for binary executables. | `${BITNAMI_ROOT_DIR}/miniforge/bin`               |
| `JUPYTERHUB_PROXY_BIN_DIR`  | JupyterHub directory for binary executables. | `${BITNAMI_ROOT_DIR}/configurable-http-proxy/bin` |
| `JUPYTERHUB_CONF_DIR`       | JupyterHub configuration directory.          | `${JUPYTERHUB_BASE_DIR}/etc`                      |
| `JUPYTERHUB_CONF_FILE`      | JupyterHub configuration file.               | `${JUPYTERHUB_CONF_DIR}/jupyterhub_config.py`     |
| `JUPYTERHUB_LOGS_DIR`       | JupyterHub logs directory.                   | `${JUPYTERHUB_BASE_DIR}/logs`                     |
| `JUPYTERHUB_LOG_FILE`       | JupyterHub log file.                         | `${JUPYTERHUB_LOGS_DIR}/jupyterhub.log`           |
| `JUPYTERHUB_TMP_DIR`        | JupyterHub temporary directory.              | `${JUPYTERHUB_BASE_DIR}/tmp`                      |
| `JUPYTERHUB_PID_FILE`       | JupyterHub PID file.                         | `${JUPYTERHUB_TMP_DIR}/jupyterhub.pid`            |
| `JUPYTERHUB_PROXY_PID_FILE` | JupyterHub proxy PID file.                   | `${JUPYTERHUB_TMP_DIR}/jupyterhub-proxy.pid`      |
| `JUPYTERHUB_DAEMON_USER`    | JupyterHub daemon system user.               | `jupyterhub`                                      |
| `JUPYTERHUB_DAEMON_GROUP`   | JupyterHub daemon system group.              | `jupyterhub`                                      |

### Running commands

To run commands inside this container you can use `docker run`, for example to execute `jupyterhub --version` you can follow the example below:

```console
docker run --rm --name jupyterhub bitnami/jupyterhub:latest --version
```

Check the [official Jupyter Hub documentation](https://jupyterhub.readthedocs.io/en/stable/reference/config-reference.html)i, or run the following to list of the available parameters.

```console
docker run --rm --name jupyterhub bitnami/jupyterhub:latest --help-all
```

### FIPS configuration in Bitnami Secure Images

The Bitnami JupyterHub Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/jupyterhub).

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
