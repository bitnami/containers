# CouchDB packaged by Bitnami

## What is CouchDB?

> CouchDB is an open source NoSQL database that stores your data with JSON documents, which you can access via HTTP. It allows you to index, combine, and transform your documents with JavaScript.

[Overview of CouchDB](http://couchdb.apache.org)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
$ docker run --name couchdb bitnami/couchdb:latest
```

### Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/containers/main/bitnami/couchdb/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami CouchDB Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/couchdb).

```console
$ docker pull bitnami/couchdb:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/couchdb/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/couchdb:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
$ git clone https://github.com/bitnami/containers.git
$ cd bitnami/APP/VERSION/OPERATING-SYSTEM
$ docker build -t bitnami/APP:latest .
```

## Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/bitnami` path. If the mounted directory is empty, it will be initialized on the first run.

```console
$ docker run \
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
$ docker network create couchdb-network --driver bridge
```

#### Step 2: Launch the CouchDB container within your network

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `couchdb-network` network.

```console
$ docker run --name couchdb-node1 --network couchdb-network bitnami/couchdb:latest
```

#### Step 3: Run another containers

We can launch another containers using the same flag (`--network NETWORK`) in the `docker run` command. If you also set a name to your container, you will be able to use it as hostname in your network.

## Configuration

The configuration can easily be setup in the Bitnami CouchDB Docker image by using the following environment variables:

 - `COUCHDB_NODENAME`: A server alias for clustering support. Default: **couchdb@127.0.0.1**
 - `COUCHDB_PORT_NUMBER`: Standard port for all HTTP API requests. Default: **5984**
 - `COUCHDB_CLUSTER_PORT_NUMBER`: Port for cluster communication. Default: **9100**
 - `COUCHDB_BIND_ADDRESS`: Address binding for the standard port. Default: **0.0.0.0**
 - `COUCHDB_CREATE_DATABASES`: If set to yes, during the first initialization of the container the system databases will be created. Default: **yes**
 - `COUCHDB_USER`: The username of the administrator user when authentication is enabled. Default: **admin**
 - `COUCHDB_PASSWORD`: The password to use for login with the admin user set in the `COUCHDB_USER` environment variable. Default: **couchdb**
 - `COUCHDB_PASSWORD_FILE`: Path to a file that contains the password for the custom user set in the `COUCHDB_USER` environment variable. This will override the value specified in `COUCHDB_PASSWORD`. No defaults.
 - `COUCHDB_SECRET`: The secret token for Proxy and Cookie Authentication. If it is not specified, it will be randomly generated. No defaults.
 - `COUCHDB_SECRET_FILE`: Path to a file that contains the contents of the secret parameter for CouchDB. This will override the value specified in `COUCHDB_SECRET`. No defaults.

You can specify these environment variables in the `docker run` command:

```console
$ docker run --name couchdb -e COUCHDB_PORT_NUMBER=7777 bitnami/couchdb:latest
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
$ docker run --name couchdb -v /path/to/config/dir:/opt/bitnami/couchdb/etc bitnami/couchdb:latest
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
$ docker restart couchdb
```

or using Docker Compose:

```console
$ docker-compose restart couchdb
```

### Clustering configuration

In order to configure CouchDB as a cluster of nodes, please make sure you set proper values for the following environment variables:

- `COUCHDB_NODENAME`. A server alias. It should be different on each container.
- `COUCHDB_CLUSTER_PORT_NUMBER`: Port for cluster communication. Default: **9100**
- `COUCHDB_CREATE_DATABASES`: Whether to create the system databases or not. You should only set it to yes in one of the nodes. Default: **yes**

## Logging

The Bitnami CouchDB Docker image sends the container logs to `stdout`. To view the logs:

```console
$ docker logs couchdb
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Customize this image

The Bitnami CouchDB Docker image is designed to be extended so it can be used as the base image where you can add custom configuration files or other packages.

### Extend this image

Before extending this image, please note there are certain configuration settings you can modify using the original image:

- Settings that can be adapted using environment variables. For instance, you can change the port used by CouchDB by setting the environment variable `COUCHDB_PORT_NUMBER`.
- [Replacing or adding your own configuration files](#mounting-your-own-configuration-files).

If your desired customizations cannot be covered using the methods mentioned above, extend the image. To do so, create your own image using a Dockerfile with the format below:

```Dockerfile
FROM bitnami/couchdb
### Put your customizations below
...
```

Here is an example of extending the image with the following modifications:

- Install the `vim` editor
- Modify the port used by CouchDB
- Change the user that runs the container

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

- Add a custom configuration file

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
$ docker pull bitnami/couchdb:latest
```

#### Step 2: Stop the running container

Stop the currently running container using the command

```console
$ docker stop couchdb
```

#### Step 3: Remove the currently running container

```console
$ docker rm -v couchdb
```

#### Step 4: Run the new image

Re-create your container from the new image.

```console
$ docker run --name couchdb bitnami/couchdb:latest
```

## Notable Changes

### 3.0.0-0-debian-10-r0

- The usage of 'ALLOW_ANONYMOUS_LOGIN' is now deprecated. Please, specify a password for the admin user (defaults to "admin") by setting the 'COUCHDB_PASSWORD' environment variable.

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues) or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/containers/issues/new/choose). For us to provide better support, be sure to fill the issue template.

### Community supported solution

Please, note this asset is a community-supported solution. This means that the Bitnami team is not actively working on new features/improvements nor providing support through GitHub Issues. Any new issue will stay open for 20 days to allow the community to contribute, after 15 days without activity the issue will be marked as stale being closed after 5 days.

The Bitnami team will review any PR that is created, feel free to create a PR if you find any issue or want to implement a new feature.

New versions and releases cadence are not going to be affected. Once a new version is released in the upstream project, the Bitnami container image will be updated to use the latest version, supporting the different branches supported by the upstream project as usual.

## License

Copyright &copy; 2023 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
