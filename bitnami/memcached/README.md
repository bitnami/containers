# Bitnami Secure Image for Memcached

> Memcached is an high-performance, distributed memory object caching system, generic in nature, but intended for use in speeding up dynamic web applications by alleviating database load.

[Overview of Memcached](https://memcached.org)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

Use this quick command to run the container.

```console
docker run --name memcached bitnami/memcached:latest
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

## How to deploy Memcached in Kubernetes

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Memcached Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/memcached).

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

## Get this image

The Bitnami Memcached Docker image is only available to [Bitnami Secure Images](https://bitnami.com) customers.

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/memcached).

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a Memcached server running inside a container can easily be accessed by your application containers.

Containers attached to the same network can communicate with each other using the container name as the host name.

## Configuration

The following sections describe environment variables and related settings.

### Environment variables

The following tables list the main variables you can set.

#### Customizable environment variables

| Name                        | Description                                                            | Default Value |
|-----------------------------|------------------------------------------------------------------------|---------------|
| `MEMCACHED_LISTEN_ADDRESS`  | Host that the Memcached service will bind to.                          | `nil`         |
| `MEMCACHED_PORT_NUMBER`     | Port number used by Memcached.                                         | `11211`       |
| `MEMCACHED_USERNAME`        | Memcached admin username.                                              | `root`        |
| `MEMCACHED_PASSWORD`        | Password for the Memcached admin user.                                 | `nil`         |
| `MEMCACHED_MAX_ITEM_SIZE`   | Memcached maximum item size.                                           | `nil`         |
| `MEMCACHED_EXTRA_FLAGS`     | Extra flags to be used when running Memcached.                         | `nil`         |
| `MEMCACHED_MAX_TIMEOUT`     | Maximum timeout in seconds for Memcached to start or stop.             | `5`           |
| `MEMCACHED_CACHE_SIZE`      | Memcached cache size in MB.                                            | `nil`         |
| `MEMCACHED_MAX_CONNECTIONS` | Maximum amount of concurrent connections that Memcached will tolerate. | `nil`         |
| `MEMCACHED_THREADS`         | Amount of process threads that Memcached will use.                     | `nil`         |

#### Read-only environment variables

| Name                         | Description                                 | Value                                |
|------------------------------|---------------------------------------------|--------------------------------------|
| `MEMCACHED_BASE_DIR`         | Memcached installation directory.           | `${BITNAMI_ROOT_DIR}/memcached`      |
| `MEMCACHED_CONF_DIR`         | Memcached configuration directory.          | `${MEMCACHED_BASE_DIR}/conf`         |
| `MEMCACHED_DEFAULT_CONF_DIR` | Memcached configuration directory.          | `${MEMCACHED_BASE_DIR}/conf.default` |
| `MEMCACHED_BIN_DIR`          | Memcached directory for binary executables. | `${MEMCACHED_BASE_DIR}/bin`          |
| `SASL_CONF_PATH`             | Memcached SASL configuration directory.     | `${MEMCACHED_CONF_DIR}/sasl2`        |
| `SASL_CONF_FILE`             | Memcached SASL configuration                | `${SASL_CONF_PATH}/memcached.conf`   |
| `SASL_DB_FILE`               | Memcached SASL database file.               | `${SASL_CONF_PATH}/memcachedsasldb`  |
| `MEMCACHED_DAEMON_USER`      | Memcached system user.                      | `memcached`                          |
| `MEMCACHED_DAEMON_GROUP`     | Memcached system group.                     | `memcached`                          |

### Specify the cache size

By default, the Bitnami Memcached container will not specify any cache size and will start with Memcached defaults (64MB). You can specify a different value with the `MEMCACHED_CACHE_SIZE` environment variable (in MB).

### Specify maximum number of concurrent connections

By default, the Bitnami Memcached container will not specify any maximum number of concurrent connections and will start with Memcached defaults (1024 concurrent connections). You can specify a different value with the `MEMCACHED_MAX_CONNECTIONS` environment variable.

### Specify number of threads to process requests

By default, the Bitnami Memcached container will not specify the amount of threads for which to process requests for and will start with Memcached defaults (4 threads). You can specify a different value with the `MEMCACHED_THREADS` environment variable.

### Specify max item size (slab size)

By default, the Memcached container will not specify any max item size and will start with Memcached defaults (1048576 ~ 1 megabyte). You can specify a different value with the `MEMCACHED_MAX_ITEM_SIZE` environment variable. Only numeric values are accepted - use `8388608` instead of `8m`

### Creating the Memcached admin user

Authentication on the Memcached server is disabled by default. To enable authentication, specify the password for the Memcached admin user using the `MEMCACHED_PASSWORD` environment variable (or in the content of the file specified in `MEMCACHED_PASSWORD_FILE`).

To customize the username of the Memcached admin user, which defaults to `root`, the `MEMCACHED_USERNAME` variable should be specified.

> **NOTE** The default value of the `MEMCACHED_USERNAME` is `root`.

### Passing extra command-line flags to memcached

Passing extra command-line flags to the Memcached service command is possible by adding them as arguments to *run.sh* script:

```console
docker run --name memcached bitnami/memcached:latest /opt/bitnami/scripts/memcached/run.sh -vvv
```

Alternatively, modify the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/memcached/docker-compose.yml) file present in this repository:

```yaml
services:
  memcached:
  ...
    command: /opt/bitnami/scripts/memcached/run.sh -vvv
  ...
```

Refer to the [Memcached man page](https://www.unix.com/man-page/linux/1/memcached/) for the complete list of arguments.

### Using custom SASL configuration

In order to load your own SASL configuration file, you will have to make them available to the container. You can do it doing the following:

- Mounting a volume with your custom configuration
- Adding custom configuration via environment variable.

By default, when authentication is enabled the SASL configuration of Memcached is written to `/opt/bitnami/memcached/sasl2/memcached.conf` file with the following content:

```config
mech_list: plain
sasldb_path: /opt/bitnami/memcached/conf/memcachedsasldb
```

The `/opt/bitnami/memcached/conf/memcachedsasldb` is the path to the `sasldb` file that contains the list of Memcached users.

### FIPS configuration in Bitnami Secure Images

The Bitnami Memcached Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.

## Logging

The Bitnami Memcached Docker image sends the container logs to the `stdout`. To view the logs:

```console
docker logs memcached
```

or using Docker Compose:

```console
docker-compose logs memcached
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Notable changes

The following subsections describe notable changes.

### 1.5.18-debian-9-r13 and 1.5.19-ol-7-r1

- Fixes regression in Memcached Authentication introduced in release `1.5.18-debian-9-r6` and `1.5.18-ol-7-r7` (#62).

### 1.5.18-debian-9-r6 and 1.5.18-ol-7-r7

- Decrease the size of the container. The configuration logic is now based on Bash scripts in the `rootfs/` folder.
- Custom SASL configuration should be mounted at `/opt/bitnami/memcached/conf/sasl2/` instead of `/bitnami/memcached/conf/`.
- Password for Memcached admin user can be specified in the content of the file specified in `MEMCACHED_PASSWORD_FILE`.

### 1.5.0-r1

- The Memcached container has been migrated to a non-root container approach. Previously the container run as `root` user and the Memcached daemon was started as `memcached` user. From now on, both the container and the Memcached daemon run as user `1001`.
  As a consequence, the user running the Memcached process can write to the configuration files.

### 1.4.25-r4

- `MEMCACHED_USER` parameter has been renamed to `MEMCACHED_USERNAME`.

### 1.4.25-r0

- The logs are always sent to the `stdout` and are no longer collected in the volume.

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
