# What is OpenLDAP?

> [OpenLDAP](https://openldap.org/) is the open-source solution for LDAP (Lightweight Directory Access Protocol). It is a protocol used to store and retrieve data from a hierarchical directory structure such as in databases.

# TL;DR

```console
$ docker run --name openldap bitnami/openldap:latest
```

## Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-openldap/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.

> This [CVE scan report](https://quay.io/repository/bitnami/openldap?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`2`, `2-debian-10`, `2.4.58`, `2.4.58-debian-10-r58`, `latest` (2/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-openldap/blob/2.4.58-debian-10-r58/2/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/openldap GitHub repo](https://github.com/bitnami/bitnami-docker-openldap).

# Get this image

The recommended way to get the Bitnami OpenLDAP Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/openldap).

```console
$ docker pull bitnami/openldap:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/openldap/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/openldap:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/openldap:latest 'https://github.com/bitnami/bitnami-docker-openldap.git#master:2/debian-10'
```

# Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Using the Command Line

In this example, we will use a MariaDB Galera instance that will use a OpenLDAP instance that is running on the same docker network to manage authentication.

### Step 1: Create a network

```console
$ docker network create my-network --driver bridge
```

### Step 2: Launch the OpenLDAP server instance

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `my-network` network.

```console
$ docker run --detach --rm --name openldap \
  --network my-network \
  --env LDAP_ADMIN_USERNAME=admin \
  --env LDAP_ADMIN_PASSWORD=adminpassword \
  --env LDAP_USERS=customuser \
  --env LDAP_PASSWORDS=custompassword \
  bitnami/openldap:latest
```

### Step 3: Launch the MariaDB Galera server instance

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `my-network` network.

```console
$ docker run --detach --rm --name mariadb-galera \
    --network my-network \
    --env MARIADB_ROOT_PASSWORD=root-password \
    --env MARIADB_GALERA_MARIABACKUP_PASSWORD=backup-password \
    --env MARIADB_USER=customuser \
    --env MARIADB_DATABASE=customdatabase \
    --env MARIADB_ENABLE_LDAP=yes \
    --env LDAP_URI=ldap://openldap:1389 \
    --env LDAP_ROOT=dc=example,dc=org \
    --env LDAP_BIND_DN=cn=admin,dc=example,dc=org \
    --env LDAP_BIND_PASSWORD=adminpassword \
    bitnami/mariadb-galera:latest
```

### Step 4: Launch the MariaDB client and test you can authenticate using LDAP credentials

Finally we create a new container instance to launch the MariaDB client and connect to the server created in the previous step:

```console
$ docker run -it --rm --name mariadb-client \
    --network my-network \
    bitnami/mariadb-galera:latest mysql -h mariadb-galera -u customuser -D customdatabase -pcustompassword
```

## Using Docker Compose

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new `bridge` network named `my-network`. In this example we assume that you want to connect to the OpenLDAP server from your own custom application image which is identified in the following snippet by the service name `myapp`.

```yaml
version: '2'

networks:
  my-network:
    driver: bridge
services:
  openldap:
    image: bitnami/openldap:2
    ports:
      - '1389:1389'
      - '1636:1636'
    environment:
      - LDAP_ADMIN_USERNAME=admin
      - LDAP_ADMIN_PASSWORD=adminpassword
      - LDAP_USERS=user01,user02
      - LDAP_PASSWORDS=password1,password2
    networks:
      - my-network
    volumes:
      - 'openldap_data:/bitnami/openldap'
  myapp:
    image: 'YOUR_APPLICATION_IMAGE'
    networks:
      - my-network
volumes:
  openldap_data:
    driver: local
```

> **IMPORTANT**:
>
> 1. Please update the **YOUR_APPLICATION_IMAGE_** placeholder in the above snippet with your application image
> 2. In your application container, use the hostname `openldap` to connect to the OpenLDAP server

Launch the containers using:

```console
$ docker-compose up -d
```

# Configuration

The Bitnami Docker OpenLDAP can be easily setup with the following environment variables:

- `LDAP_PORT_NUMBER`: The port OpenLDAP is listening for requests. Default: **1389** (non privileged port)
- `LDAP_ROOT`: LDAP database root node of the LDAP tree. Default: **dc=example,dc=org**
- `LDAP_ADMIN_USERNAME`: LDAP database admin user. Default: **admin**
- `LDAP_ADMIN_PASSWORD`: LDAP database admin password. Default: **adminpassword**
- `LDAP_USERS`: Comma separated list of LDAP users to create in the default LDAP tree. Default: **user01,user02**
- `LDAP_PASSWORDS`: Comma separated list of passwords to use for LDAP users. Default: **bitnami1,bitnami2**
- `LDAP_USER_DC`: DC for the users' organizational unit. Default: **users**
- `LDAP_GROUP`: Group used to group created users. Default: **readers**
- `LDAP_EXTRA_SCHEMAS`: Extra schemas to add, among OpenLDAP's distributed schemas. Default: **cosine, inetorgperson, nis**
- `LDAP_SKIP_DEFAULT_TREE`: Whether to skip creating the default LDAP tree based on `LDAP_USERS`, `LDAP_PASSWORDS`, `LDAP_USER_DC` and `LDAP_GROUP`. Default: **no**
- `LDAP_CUSTOM_LDIF_DIR`: Location of a directory that contains LDIF files that should be used to bootstrap the database. Only files ending in `.ldif` will be used. Default LDAP tree based on the `LDAP_USERS`, `LDAP_PASSWORDS`, `LDAP_USER_DC` and `LDAP_GROUP` will be skipped when `LDAP_CUSTOM_LDIF_DIR` is used. When using this will override the usage of `LDAP_ROOT`,`LDAP_USERS`, `LDAP_PASSWORDS`, `LDAP_USER_DC` and `LDAP_GROUP`. Default: **/ldifs**
- `LDAP_CUSTOM_SCHEMA_FILE`: Location of a custom internal schema file that could not be added as custom ldif file (i.e. containing some `structuralObjectClass`). Default is **/schema/custom.ldif**"
- `LDAP_ULIMIT_NOFILES`: Maximum number of open file descriptors. Default: **1024**.

Check the official [OpenLDAP Configuration Reference](https://www.openldap.org/doc/admin24/guide.html) for more information about how to configure OpenLDAP.

## Securing OpenLDAP traffic

OpenLDAP clients and servers are capable of using the Transport Layer Security (TLS) framework to provide integrity and confidentiality protections and to support LDAP authentication using the SASL EXTERNAL mechanism. Should you desire to enable this optional feature, you may use the following environment variables to configure the application:

 - `LDAP_ENABLE_TLS`: Whether to enable TLS for traffic or not. Defaults to `no`.
 - `LDAP_LDAPS_PORT_NUMBER`: Port used for TLS secure traffic. Defaults to `1636`.
 - `LDAP_TLS_CERT_FILE`: File containing the certificate file for the TSL traffic. No defaults.
 - `LDAP_TLS_KEY_FILE`: File containing the key for certificate. No defaults.
 - `LDAP_TLS_CA_FILE`: File containing the CA of the certificate. No defaults.
 - `LDAP_TLS_DH_PARAMS_FILE`: File containing the DH parameters. No defaults.

This new feature is not mutually exclusive, which means it is possible to listen to both TLS and non-TLS connection simultaneously. To use TLS you can use the URI `ldaps://openldap:1636` or use the non-TLS URI forcing ldap to use TLS `ldap://openldap:1389 -ZZ`.

1. Using `docker run`

    ```console
    $ docker run --name openldap \
        -v /path/to/certs:/opt/bitnami/openldap/certs \
        -v /path/to/openldap-data-persistence:/bitnami/openldap/data \
        -e ALLOW_EMPTY_PASSWORD=yes \
        -e LDAP_ENABLE_TLS=yes \
        -e LDAP_TLS_CERT_FILE=/opt/bitnami/openldap/certs/openldap.crt \
        -e LDAP_TLS_KEY_FILE=/opt/bitnami/openldap/certs/openldap.key \
        -e LDAP_TLS_CA_FILE=/opt/bitnami/openldap/certs/openldapCA.crt \
        bitnami/openldap:latest
    ```

2. Modifying the `docker-compose.yml` file present in this repository:

    ```yaml
    services:
      openldap:
      ...
        environment:
          ...
          - LDAP_ENABLE_TLS=yes
          - LDAP_TLS_CERT_FILE=/opt/bitnami/openldap/certs/openldap.crt
          - LDAP_TLS_KEY_FILE=/opt/bitnami/openldap/certs/openldap.key
          - LDAP_TLS_CA_FILE=/opt/bitnami/openldap/certs/openldapCA.crt
        ...
        volumes:
          - /path/to/certs:/opt/bitnami/openldap/certs
          - /path/to/openldap-data-persistence:/bitnami/openldap/data
      ...
    ```

# Logging

The Bitnami OpenLDAP Docker image sends the container logs to `stdout`. To view the logs:

```console
$ docker logs openldap
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of OpenLDAP, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```console
$ docker pull bitnami/openldap:latest
```

### Step 2: Stop the running container

Stop the currently running container using the command

```console
$ docker stop openldap
```

### Step 3: Remove the currently running container

```console
$ docker rm -v openldap
```

### Step 4: Run the new image

Re-create your container from the new image.

```console
$ docker run --name openldap bitnami/openldap:latest
```


# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-openldap/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-openldap/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-openldap/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright 2021 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
