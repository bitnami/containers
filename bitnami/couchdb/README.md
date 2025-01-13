# Bitnami package for CouchDB

## What is CouchDB?

> CouchDB is an open source NoSQL database that stores your data with JSON documents, which you can access via HTTP. It allows you to index, combine, and transform your documents with JavaScript.

[Overview of CouchDB](http://couchdb.apache.org)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name couchdb bitnami/couchdb:latest
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use CouchDB in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

## Only latest stable branch maintained in the free Bitnami catalog

Starting December 10th 2024, only the latest stable branch of any container will receive updates in the free Bitnami catalog. To access up-to-date releases for all upstream-supported branches, consider upgrading to Bitnami Premium. Previous versions already released will not be deleted. They are still available to pull from DockerHub.

Please check the Bitnami Premium page in our partner [Arrow Electronics](https://www.arrow.com/globalecs/na/vendors/bitnami?utm_source=GitHub&utm_medium=containers) for more information.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami CouchDB Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/couchdb).

```console
docker pull bitnami/couchdb:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/couchdb/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/couchdb:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami` path. If the mounted directory is empty, it will be initialized on the first run.

```console
docker run \
    -v /path/to/couchdb-persistence:/bitnami/couchdb \
    bitnami/couchdb:latest
```

You can also do this with a minor change to the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/couchdb/docker-compose.yml) file present in this repository:

```yaml
couchdb:
  ...
  volumes:
    - /path/to/couchdb-persistence:/bitnami/couchdb
  ...
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the hostname.

### Using the Command Line

#### Step 1: Create a network

```console
docker network create couchdb-network --driver bridge
```

#### Step 2: Launch the CouchDB container within your network

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `couchdb-network` network.

```console
docker run --name couchdb-node1 --network couchdb-network bitnami/couchdb:latest
```

#### Step 3: Run another containers

We can launch another containers using the same flag (`--network NETWORK`) in the `docker run` command. If you also set a name to your container, you will be able to use it as hostname in your network.

## Configuration

### Environment variables

#### Customizable environment variables

| Name                          | Description                                                                              | Default Value |
|-------------------------------|------------------------------------------------------------------------------------------|---------------|
| `COUCHDB_NODENAME`            | Name of the CouchDB node.                                                                | `nil`         |
| `COUCHDB_PORT_NUMBER`         | Port number used by CouchDB.                                                             | `nil`         |
| `COUCHDB_CLUSTER_PORT_NUMBER` | Port number used by CouchDB for clustering.                                              | `nil`         |
| `COUCHDB_BIND_ADDRESS`        | Address to which the CouchDB process will bind to.                                       | `nil`         |
| `COUCHDB_CREATE_DATABASES`    | Whether to create CouchDB system databases during initialization. Useful for clustering. | `yes`         |
| `COUCHDB_USER`                | CouchDB admin username.                                                                  | `admin`       |
| `COUCHDB_PASSWORD`            | Password for the CouchDB admin user.                                                     | `couchdb`     |
| `COUCHDB_SECRET`              | CouchDB secret/token used for proxy and cookie authentication.                           | `bitnami`     |

#### Read-only environment variables

| Name                   | Description                               | Value                                          |
|------------------------|-------------------------------------------|------------------------------------------------|
| `COUCHDB_BASE_DIR`     | CouchDB installation directory.           | `${BITNAMI_ROOT_DIR}/couchdb`                  |
| `COUCHDB_VOLUME_DIR`   | CouchDB persistence directory.            | `/bitnami/couchdb`                             |
| `COUCHDB_BIN_DIR`      | CouchDB directory for binary executables. | `${COUCHDB_BASE_DIR}/bin`                      |
| `COUCHDB_CONF_DIR`     | CouchDB configuration directory.          | `${COUCHDB_BASE_DIR}/etc`                      |
| `COUCHDB_CONF_FILE`    | CouchDB configuration file.               | `${COUCHDB_CONF_DIR}/default.d/10-bitnami.ini` |
| `COUCHDB_DATA_DIR`     | CouchDB directory where data is stored.   | `${COUCHDB_VOLUME_DIR}/data`                   |
| `COUCHDB_DAEMON_USER`  | CouchDB system user.                      | `couchdb`                                      |
| `COUCHDB_DAEMON_GROUP` | CouchDB system group.                     | `couchdb`                                      |

You can specify these environment variables in the `docker run` command:

```console
docker run --name couchdb -e COUCHDB_PORT_NUMBER=7777 bitnami/couchdb:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/couchdb/docker-compose.yml) file present in this repository:

```yaml
services:
  couchdb:
  ...
    environment:
      - COUCHDB_PORT_NUMBER=7777
  ...
```

### Mounting your own configuration files

If you want to provide more specific configuration options to CouchDB, you can always mount your own configuration files under `/opt/bitnami/couchdb/etc/`. You can either add new ones under `./local.d` or override the existing ones.

To understand the precedence of the different configuration files, please check [how CouchDB reads them](https://docs.couchdb.org/en/stable/config/intro.html#configuration-files).

#### Step 1: Run the CouchDB image

Run the CouchDB image, mounting a directory from your host.

```console
docker run --name couchdb -v /path/to/config/dir:/opt/bitnami/couchdb/etc bitnami/couchdb:latest
```

or using Docker Compose:

```yaml
services:
  couchdb:
  ...
    volumes:
      - /path/to/config/dir:/opt/bitnami/couchdb/etc/
  ...
```

#### Step 2: Edit the configuration

Edit the configuration on your host using your favorite editor.

```console
vi /path/to/config/file/10-custom.ini
```

#### Step 3: Restart CouchDB

After changing the configuration, restart your CouchDB container for changes to take effect.

```console
docker restart couchdb
```

or using Docker Compose:

```console
docker-compose restart couchdb
```

### Clustering configuration

In order to configure CouchDB as a cluster of nodes, please make sure you set proper values for the following environment variables:

* `COUCHDB_NODENAME`. A server alias. It should be different on each container.
* `COUCHDB_CLUSTER_PORT_NUMBER`: Port for cluster communication. Default: **9100**
* `COUCHDB_CREATE_DATABASES`: Whether to create the system databases or not. You should only set it to yes in one of the nodes. Default: **yes**

## Logging

The Bitnami CouchDB Docker image sends the container logs to `stdout`. To view the logs:

```console
docker logs couchdb
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Customize this image

The Bitnami CouchDB Docker image is designed to be extended so it can be used as the base image where you can add custom configuration files or other packages.

### Extend this image

Before extending this image, please note there are certain configuration settings you can modify using the original image:

* Settings that can be adapted using environment variables. For instance, you can change the port used by CouchDB by setting the environment variable `COUCHDB_PORT_NUMBER`.
* [Replacing or adding your own configuration files](#mounting-your-own-configuration-files).

If your desired customizations cannot be covered using the methods mentioned above, extend the image. To do so, create your own image using a Dockerfile with the format below:

```Dockerfile
FROM bitnami/couchdb
### Put your customizations below
...
```

Here is an example of extending the image with the following modifications:

* Install the `vim` editor
* Modify the port used by CouchDB
* Change the user that runs the container

```Dockerfile
FROM bitnami/couchdb

### Change user to perform privileged actions
USER 0
### Install 'vim'
RUN install_packages vim
### Revert to the original non-root user
USER 1001

### Modify the ports used by NGINX by default
ENV COUCHDB_PORT_NUMBER=1234 # It is also possible to change this environment variable at runtime
EXPOSE 1234 4369

### Modify the default container user
USER 1002
```

Based on the extended image, you can use a Docker Compose file like the one below to add other features:

* Add a custom configuration file

```yaml
version: '2'
services:
  couchdb:
    build: .
    environment:
      - COUCHDB_PASSWORD=couchdb
    ports:
      - '1234:1234'
      - '4369:4369'
    volumes:
      - couchdb_data:/bitnami/couchdb
      - /path/to/config/file/10-custom.ini:/opt/bitnami/couchdb/etc/local.d/10-custom.ini
volumes:
  couchdb_data:
    driver: local
```

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of CouchDB, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/couchdb:latest
```

#### Step 2: Stop the running container

Stop the currently running container using the command

```console
docker stop couchdb
```

#### Step 3: Remove the currently running container

```console
docker rm -v couchdb
```

#### Step 4: Run the new image

Re-create your container from the new image.

```console
docker run --name couchdb bitnami/couchdb:latest
```

## Notable Changes

### 3.0.0-0-debian-10-r0

* The usage of 'ALLOW_ANONYMOUS_LOGIN' is now deprecated. Please, specify a password for the admin user (defaults to "admin") by setting the 'COUCHDB_PASSWORD' environment variable.

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/couchdb).

If you detect any issue in the `docker-compose.yaml` file, feel free to report it or contribute with a fix by following our [Contributing Guidelines](https://github.com/bitnami/containers/blob/main/CONTRIBUTING.md).

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues) or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

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
