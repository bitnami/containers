# Bitnami package for OpenLDAP

## What is OpenLDAP?

> OpenLDAP is the open-source solution for LDAP (Lightweight Directory Access Protocol). It is a protocol used to  store and retrieve data from a hierarchical directory structure such as in databases.

[Overview of OpenLDAP](https://openldap.org/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name openldap bitnami/openldap:latest
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use OpenLDAP in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

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

The recommended way to get the Bitnami OpenLDAP Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/openldap).

```console
docker pull bitnami/openldap:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/openldap/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/openldap:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the hostname.

### Using the Command Line

In this example, we will use a MariaDB Galera instance that will use a OpenLDAP instance that is running on the same docker network to manage authentication.

#### Step 1: Create a network

```console
docker network create my-network --driver bridge
```

#### Step 2: Launch the OpenLDAP server instance

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `my-network` network.

```console
docker run --detach --rm --name openldap \
  --network my-network \
  --env LDAP_ADMIN_USERNAME=admin \
  --env LDAP_ADMIN_PASSWORD=adminpassword \
  --env LDAP_USERS=customuser \
  --env LDAP_PASSWORDS=custompassword \
  --env LDAP_ROOT=dc=example,dc=org \
  --env LDAP_ADMIN_DN=cn=admin,dc=example,dc=org \
  bitnami/openldap:latest
```

#### Step 3: Launch the MariaDB Galera server instance

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `my-network` network.

```console
docker run --detach --rm --name mariadb-galera \
    --network my-network \
    --env MARIADB_ROOT_PASSWORD=root-password \
    --env MARIADB_GALERA_MARIABACKUP_PASSWORD=backup-password \
    --env MARIADB_USER=customuser \
    --env MARIADB_DATABASE=customdatabase \
    --env MARIADB_ENABLE_LDAP=yes \
    --env LDAP_URI=ldap://openldap:1389 \
    --env LDAP_BASE=dc=example,dc=org \
    --env LDAP_BIND_DN=cn=admin,dc=example,dc=org \
    --env LDAP_BIND_PASSWORD=adminpassword \
    bitnami/mariadb-galera:latest
```

#### Step 4: Launch the MariaDB client and test you can authenticate using LDAP credentials

Finally we create a new container instance to launch the MariaDB client and connect to the server created in the previous step:

```console
docker run -it --rm --name mariadb-client \
    --network my-network \
    bitnami/mariadb-galera:latest mysql -h mariadb-galera -u customuser -D customdatabase -pcustompassword
```

### Using a Docker Compose file

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
docker-compose up -d
```

## Configuration

The Bitnami Docker OpenLDAP can be easily setup with the following environment variables:

* `LDAP_PORT_NUMBER`: The port OpenLDAP is listening for requests. Priviledged port is supported (e.g. `389`). Default: **1389** (non privileged port).
* `LDAP_ROOT`: LDAP baseDN (or suffix) of the LDAP tree. Default: **dc=example,dc=org**
* `LDAP_ADMIN_USERNAME`: LDAP database admin user. Default: **admin**
* `LDAP_ADMIN_PASSWORD`: LDAP database admin password. Default: **adminpassword**
* `LDAP_ADMIN_PASSWORD_FILE`: Path to a file that contains the LDAP database admin user password. This will override the value specified in `LDAP_ADMIN_PASSWORD`. No defaults.
* `LDAP_CONFIG_ADMIN_ENABLED`: Whether to create a configuration admin user. Default: **no**.
* `LDAP_CONFIG_ADMIN_USERNAME`: LDAP configuration admin user. This is separate from `LDAP_ADMIN_USERNAME`. Default: **admin**.
* `LDAP_CONFIG_ADMIN_PASSWORD`: LDAP configuration admin password. Default: **configpassword**.
* `LDAP_CONFIG_ADMIN_PASSWORD_FILE`: Path to a file that contains the LDAP configuration admin user password. This will override the value specified in `LDAP_CONFIG_ADMIN_PASSWORD`. No defaults.
* `LDAP_USERS`: Comma separated list of LDAP users to create in the default LDAP tree. Default: **user01,user02**
* `LDAP_PASSWORDS`: Comma separated list of passwords to use for LDAP users. Default: **bitnami1,bitnami2**
* `LDAP_USER_OU`: Name for the user's organizational unit. Default: **users**
* `LDAP_GROUP_OU`: Name for the group's organizational unit. Default: **groups**
* `LDAP_USER_DC`: DC for the users' organizational unit. **DEPRECATED** Please use `LDAP_USER_OU` and `LDAP_GROUP_OU` instead.
* `LDAP_GROUP`: Group used to group created users. Default: **readers**
* `LDAP_ADD_SCHEMAS`: Whether to add the schemas specified in `LDAP_EXTRA_SCHEMAS`. Default: **yes**
* `LDAP_EXTRA_SCHEMAS`: Extra schemas to add, among OpenLDAP's distributed schemas. Default: **cosine, inetorgperson, nis**
* `LDAP_SKIP_DEFAULT_TREE`: Whether to skip creating the default LDAP tree based on `LDAP_USERS`, `LDAP_PASSWORDS`, `LDAP_USER_OU`, `LDAP_GROUP_OU` and `LDAP_GROUP`. Please note that this will **not** skip the addition of schemas or importing of LDIF files. Default: **no**
* `LDAP_CUSTOM_LDIF_DIR`: Location of a directory that contains LDIF files that should be used to bootstrap the database. Only files ending in `.ldif` will be used. Default LDAP tree based on the `LDAP_USERS`, `LDAP_PASSWORDS`, `LDAP_USER_OU`, `LDAP_GROUP_OU` and `LDAP_GROUP` will be skipped when `LDAP_CUSTOM_LDIF_DIR` is used. When using this it will override the usage of `LDAP_USERS`, `LDAP_PASSWORDS`, `LDAP_USER_OU`, `LDAP_GROUP_OU` and `LDAP_GROUP`. You should set `LDAP_ROOT` to your base to make sure the `olcSuffix` configured on the database matches the contents imported from the LDIF files. Default: **/ldifs**
* `LDAP_CUSTOM_SCHEMA_FILE`: Location of a custom internal schema file that could not be added as custom ldif file (i.e. containing some `structuralObjectClass`). Default is **/schema/custom.ldif**"
* `LDAP_CUSTOM_SCHEMA_DIR`: Location of a directory containing custom internal schema files that could not be added as custom ldif files (i.e. containing some `structuralObjectClass`). This can be used in addition to or instead of `LDAP_CUSTOM_SCHEMA_FILE` (above) to add multiple schema files. Default: **/schemas**
* `LDAP_ULIMIT_NOFILES`: Maximum number of open file descriptors. Default: **1024**.
* `LDAP_ALLOW_ANON_BINDING`: Allow anonymous bindings to the LDAP server. Default: **yes**.
* `LDAP_LOGLEVEL`: Set the loglevel for the OpenLDAP server (see <https://www.openldap.org/doc/admin26/slapdconfig.html> for possible values). Default: **256**.
* `LDAP_PASSWORD_HASH`: Hash to be used in generation of user passwords. Must be one of {SSHA}, {SHA}, {SMD5}, {MD5}, {CRYPT}, and {CLEARTEXT}. Default: **{SSHA}**.
* `LDAP_CONFIGURE_PPOLICY`: Enables the ppolicy module and creates an empty configuration. Default: **no**.
* `LDAP_PPOLICY_USE_LOCKOUT`: Whether bind attempts to locked accounts will always return an error. Will only be applied with `LDAP_CONFIGURE_PPOLICY` active. Default: **no**.
* `LDAP_PPOLICY_HASH_CLEARTEXT`: Whether plaintext passwords should be hashed automatically. Will only be applied with `LDAP_CONFIGURE_PPOLICY` active. Default: **no**.

You can bootstrap the contents of your database by putting LDIF files in the directory `/ldifs` (or the one you define in `LDAP_CUSTOM_LDIF_DIR`). Those may only contain content underneath your base DN (set by `LDAP_ROOT`). You can **not** set configuration for e.g. `cn=config` in those files.

Check the official [OpenLDAP Configuration Reference](https://www.openldap.org/doc/admin26/guide.html) for more information about how to configure OpenLDAP.

### Data Persistence

To ensure that the OpenLDAP state is retained across container restarts and updates, it is recommended to mount a volume at `/bitnami/openldap`.

### Overlays

Overlays are dynamic modules that can be added to an OpenLDAP server to extend or modify its functionality.

#### Access Logging

This overlay can record accesses to a given backend database on another database.

* `LDAP_ENABLE_ACCESSLOG`: Enables the accesslog module with the following configuration defaults unless specified otherwise. Default: **no**.
* `LDAP_ACCESSLOG_ADMIN_USERNAME`: Admin user for accesslog database. Default: **admin**.
* `LDAP_ACCESSLOG_ADMIN_PASSWORD`: Admin password for accesslog database. Default: **accesspassword**.
* `LDAP_ACCESSLOG_DB`: The DN (Distinguished Name) of the database where the access log entries will be stored. Will only be applied with `LDAP_ENABLE_ACCESSLOG` active. Default: **cn=accesslog**.
* `LDAP_ACCESSLOG_LOGOPS`: Specify which types of operations to log. Valid aliases for common sets of operations are: writes, reads, session or all. Will only be applied with `LDAP_ENABLE_ACCESSLOG` active. Default: **writes**.
* `LDAP_ACCESSLOG_LOGSUCCESS`: Whether successful operations should be logged. Will only be applied with `LDAP_ENABLE_ACCESSLOG` active. Default: **TRUE**.
* `LDAP_ACCESSLOG_LOGPURGE`: When and how often old access log entries should be purged. Format `"dd+hh:mm"`. Will only be applied with `LDAP_ENABLE_ACCESSLOG` active. Default: **07+00:00 01+00:00**.
* `LDAP_ACCESSLOG_LOGOLD`: An LDAP filter that determines which entries should be logged. Will only be applied with `LDAP_ENABLE_ACCESSLOG` active. Default: **(objectClass=*)**.
* `LDAP_ACCESSLOG_LOGOLDATTR`: Specifies an attribute that should be logged. Will only be applied with `LDAP_ENABLE_ACCESSLOG` active. Default: **objectClass**.

Check the official page [OpenLDAP, Overlays, Access Logging](https://www.openldap.org/doc/admin26/overlays.html#Access%20Logging) for detailed configuration information.

#### Sync Provider

* `LDAP_ENABLE_SYNCPROV`: Enables the syncrepl module with the following configuration defaults unless specified otherwise. Default: **no**.
* `LDAP_SYNCPROV_CHECKPPOINT`: For every 100 operations or 10 minutes, which ever is sooner, the contextCSN will be checkpointed. Will only be applied with `LDAP_ENABLE_SYNCPROV` active. Default: **100 10**.
* `LDAP_SYNCPROV_SESSIONLOG`: The maximum number of session log entries the session log can record. Will only be applied with `LDAP_ENABLE_SYNCPROV` active. Default: **100**.

Check the official page [OpenLDAP, Overlays, Sync Provider](https://www.openldap.org/doc/admin26/overlays.html#Sync%20Provider) for detailed configuration information.

#### Dynamic List or Member Of

The overlays `dynlist` and `memberof` both require the operational `memberOf` attribute to be present in the loaded schema. During initialization, a check is performed for the presence of this attribute; if it is absent, it is created programmatically.

At the same time, the `msuser` schema declares the same attribute. If both the schema and at least one of the overlays are required, a conflict may arise depending on the load order, such as whether the schema is loaded before or after the overlays. If the overlays are loaded first, the process stops and raises a `Duplicate attribute` error.

In a standard OpenLDAP installation (deb or rpm), its configuration is stored in the main file, which may include another one. In this case, the order is determined by the order of directives.

For configuration flexibility, the container-based approach relies on a file tree structure rather than a master file with includes. To ensure the correct order, the file tree must be read deterministically. Fortunately, Linux sorts folder content using alphanumeric order. This allows overlay loading after the schema by using a keyword that is after `schema` in alphanumeric sorting (i.e. `cn=z-module{N}` will be loaded after `cn=schema` as they are both children of `cn=config`). Doing so, the configuration merging `msuser` schema and `dynlist` (or `memberof`) will load without errors.

IMPORTANT: The `dynlist` requires the schema `dyngroup`. This can be done by adding it to the list of schemas to load through `LDAP_EXTRA_SCHEMAS`.

The following example shows how to declare the module `dynlist` with the support of dynamic (groupOfUrls) and static (groupOfNames) groups. The `olcDatabase={N}mdb` has to be adjusted to the target configuration.

```bash
ldapadd -D "cn=admin,cn=config" -w "configpassword" <<EOF
dn: cn=z-module,cn=config
objectClass: olcModuleList
cn: z-module
olcModuleLoad: dynlist.so
olcModulePath: /opt/bitnami/openldap/lib/openldap
dn: olcOverlay=dynlist,olcDatabase={N}mdb,cn=config
objectClass: olcConfig
objectClass: olcDynListConfig
objectClass: olcOverlayConfig
objectClass: top
olcOverlay: dynlist
olcDynListAttrSet: groupOfUrls memberURL member+memberOf@groupOfNames
EOF
```

This example is compatible with or without the usage of the `msuser` schema.

Check the official page [OpenLDAP, Overlays, Dynamic Lists](https://www.openldap.org/doc/admin26/overlays.html#Dynamic%20Lists) for detailed configuration information.

### Securing OpenLDAP traffic

OpenLDAP clients and servers are capable of using the Transport Layer Security (TLS) framework to provide integrity and confidentiality protections and to support LDAP authentication using the SASL EXTERNAL mechanism. Should you desire to enable this optional feature, you may use the following environment variables to configure the application:

* `LDAP_ENABLE_TLS`: Whether to enable TLS for traffic or not. Defaults to `no`.
* `LDAP_REQUIRE_TLS`: Whether connections must use TLS. Will only be applied with `LDAP_ENABLE_TLS` active. Defaults to `no`.
* `LDAP_LDAPS_PORT_NUMBER`: Port used for TLS secure traffic. Priviledged port is supported (e.g. `636`). Default: **1636** (non privileged port).
* `LDAP_TLS_CERT_FILE`: File containing the certificate file for the TLS traffic. No defaults.
* `LDAP_TLS_KEY_FILE`: File containing the key for certificate. No defaults.
* `LDAP_TLS_CA_FILE`: File containing the CA of the certificate. No defaults.
* `LDAP_TLS_DH_PARAMS_FILE`: File containing the DH parameters. No defaults.

This new feature is not mutually exclusive, which means it is possible to listen to both TLS and non-TLS connection simultaneously. To use TLS you can use the URI `ldaps://openldap:1636` or use the non-TLS URI forcing ldap to use TLS `ldap://openldap:1389 -ZZ`.

1. Using `docker run`

    ```console
    $ docker run --name openldap \
        -v /path/to/certs:/opt/bitnami/openldap/certs \
        -v /path/to/openldap-data-persistence:/bitnami/openldap/ \
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
          - /path/to/openldap-data-persistence:/bitnami/openldap/
      ...
    ```

### Run behind load balancer

OpenLDAP supports the HAProxy proxy protocol version 2 to detect real client IP that is masked when server runs behind load balancer. You can enable and configure this feature with the following environment variables:

* `LDAP_ENABLE_PROXYPROTO`: Whether to enable proxy protocol support for traffic or not. Defaults to `no`.
* `LDAP_PROXYPROTO_PORT_NUMBER`: The port OpenLDAP is listening for requests that is wrapped in proxy protocol. Default: the **LDAP_PORT_NUMBER** value.
* `LDAP_PROXYPROTO_LDAPS_PORT_NUMBER`: Port used for TLS secure traffic that is wrapped in proxy protocol. Default: the **LDAP_LDAPS_PORT_NUMBER** value.

Enabling this feature will replace regular and TLS ports with proxy protocol capable analogs. To use both port types, set **LDAP_PROXYPROTO_PORT_NUMBER** to some different value than **LDAP_PORT_NUMBER**. The same statement applied to **LDAP_PROXYPROTO_LDAPS_PORT_NUMBER** and **LDAP_LDAPS_PORT_NUMBER** pair.

**Security warning**: To prevent client IP spoofing, it is highly advised to secure the proxy protocol capable ports by firewall that allow traffic only from load balancer hosts.

Check the official page [OpenLDAP, Running slapd, Command-Line Options](https://www.openldap.org/doc/admin26/runningslapd.html#Command-Line%20Options) for additional information.

### Initializing a new instance

The [Bitnami OpenLDAP](https://github.com/bitnami/containers/blob/main/bitnami/openldap) image allows you to use your custom scripts to initialize a fresh instance.

The allowed script extension is `.sh`, all scripts are executed in alphabetical order and need to reside in `/docker-entrypoint-initdb.d/`.

Scripts are executed are after the initilization and before the startup of the OpenLDAP service.

## Logging

The Bitnami OpenLDAP Docker image sends the container logs to `stdout`. To view the logs:

```console
docker logs openldap
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

To see the actual output of slapd in the container's logs, set the environment variable `BITNAMI_DEBUG=true`. Useful especially to find/debug problems in your configuration that lead to errors so OpenLDAP won't start.

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of OpenLDAP, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/openldap:latest
```

#### Step 2: Stop the running container

Stop the currently running container using the command

```console
docker stop openldap
```

#### Step 3: Remove the currently running container

```console
docker rm -v openldap
```

#### Step 4: Run the new image

Re-create your container from the new image.

```console
docker run --name openldap bitnami/openldap:latest
```

## Notable Changes

### 2.4.58-debian-10-r93

* The default database backend has been changed from `hdb` to `mdb` as recommended. No additional steps should be necessary at upgrade time; the new container version `2.4.59` will initialize using the persisted data.

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes.

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
