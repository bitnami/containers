# Bitnami Secure Image for OpenLDAP

> OpenLDAP is the open-source solution for LDAP (Lightweight Directory Access Protocol). It is a protocol used to  store and retrieve data from a hierarchical directory structure such as in databases.

[Overview of OpenLDAP](https://openldap.org/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## <a id="tl-dr"></a> TL;DR

```console
docker run --name openldap bitnami/openldap:latest
```

## <a id="why-use-bitnami-secure-images"></a> Why use Bitnami Secure Images?

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

## <a id="why-non-root"></a> Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

## <a id="supported-tags"></a> Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

## <a id="get-this-image"></a> Get this image

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

## <a id="using-`docker-compose.yaml`"></a> Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes.

## <a id="connecting-to-other-containers"></a> Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## <a id="configuration"></a> Configuration

The Bitnami Docker OpenLDAP can be easily setup with the following environment variables:

- `LDAP_PORT_NUMBER`: The port OpenLDAP is listening for requests. Priviledged port is supported (e.g. `389`). Default: **1389** (non privileged port).
- `LDAP_ROOT`: LDAP baseDN (or suffix) of the LDAP tree. Default: **dc=example,dc=org**
- `LDAP_ADMIN_USERNAME`: LDAP database admin user. Default: **admin**
- `LDAP_ADMIN_PASSWORD`: LDAP database admin password. Default: **adminpassword**
- `LDAP_ADMIN_PASSWORD_FILE`: Path to a file that contains the LDAP database admin user password. This will override the value specified in `LDAP_ADMIN_PASSWORD`. No defaults.
- `LDAP_CONFIG_ADMIN_ENABLED`: Whether to create a configuration admin user. Default: **no**.
- `LDAP_CONFIG_ADMIN_USERNAME`: LDAP configuration admin user. This is separate from `LDAP_ADMIN_USERNAME`. Default: **admin**.
- `LDAP_CONFIG_ADMIN_PASSWORD`: LDAP configuration admin password. Default: **configpassword**.
- `LDAP_CONFIG_ADMIN_PASSWORD_FILE`: Path to a file that contains the LDAP configuration admin user password. This will override the value specified in `LDAP_CONFIG_ADMIN_PASSWORD`. No defaults.
- `LDAP_USERS`: Comma separated list of LDAP users to create in the default LDAP tree. Default: **user01,user02**
- `LDAP_PASSWORDS`: Comma separated list of passwords to use for LDAP users. Default: **bitnami1,bitnami2**
- `LDAP_USER_OU`: Name for the user's organizational unit. Default: **users**
- `LDAP_GROUP_OU`: Name for the group's organizational unit. Default: **groups**
- `LDAP_USER_DC`: DC for the users' organizational unit. **DEPRECATED** Please use `LDAP_USER_OU` and `LDAP_GROUP_OU` instead.
- `LDAP_GROUP`: Group used to group created users. Default: **readers**
- `LDAP_ADD_SCHEMAS`: Whether to add the schemas specified in `LDAP_EXTRA_SCHEMAS`. Default: **yes**
- `LDAP_EXTRA_SCHEMAS`: Extra schemas to add, among OpenLDAP's distributed schemas. Default: **cosine, inetorgperson, nis**
- `LDAP_SKIP_DEFAULT_TREE`: Whether to skip creating the default LDAP tree based on `LDAP_USERS`, `LDAP_PASSWORDS`, `LDAP_USER_OU`, `LDAP_GROUP_OU` and `LDAP_GROUP`. Please note that this will **not** skip the addition of schemas or importing of LDIF files. Default: **no**
- `LDAP_CUSTOM_LDIF_DIR`: Location of a directory that contains LDIF files that should be used to bootstrap the database. Only files ending in `.ldif` will be used. Default LDAP tree based on the `LDAP_USERS`, `LDAP_PASSWORDS`, `LDAP_USER_OU`, `LDAP_GROUP_OU` and `LDAP_GROUP` will be skipped when `LDAP_CUSTOM_LDIF_DIR` is used. When using this it will override the usage of `LDAP_USERS`, `LDAP_PASSWORDS`, `LDAP_USER_OU`, `LDAP_GROUP_OU` and `LDAP_GROUP`. You should set `LDAP_ROOT` to your base to make sure the `olcSuffix` configured on the database matches the contents imported from the LDIF files. Default: **/ldifs**
- `LDAP_CUSTOM_SCHEMA_FILE`: Location of a custom internal schema file that could not be added as custom ldif file (i.e. containing some `structuralObjectClass`). Default is **/schema/custom.ldif**"
- `LDAP_CUSTOM_SCHEMA_DIR`: Location of a directory containing custom internal schema files that could not be added as custom ldif files (i.e. containing some `structuralObjectClass`). This can be used in addition to or instead of `LDAP_CUSTOM_SCHEMA_FILE` (above) to add multiple schema files. Default: **/schemas**
- `LDAP_ULIMIT_NOFILES`: Maximum number of open file descriptors. Default: **1024**.
- `LDAP_ALLOW_ANON_BINDING`: Allow anonymous bindings to the LDAP server. Default: **yes**.
- `LDAP_LOGLEVEL`: Set the loglevel for the OpenLDAP server (see <https://www.openldap.org/doc/admin26/slapdconfig.html> for possible values). Default: **256**.
- `LDAP_PASSWORD_HASH`: Hash to be used in generation of user passwords. Must be one of {SSHA}, {SHA}, {SMD5}, {MD5}, {CRYPT}, and {CLEARTEXT}. Default: **{SSHA}**.
- `LDAP_CONFIGURE_PPOLICY`: Enables the ppolicy module and creates an empty configuration. Default: **no**.
- `LDAP_PPOLICY_USE_LOCKOUT`: Whether bind attempts to locked accounts will always return an error. Will only be applied with `LDAP_CONFIGURE_PPOLICY` active. Default: **no**.
- `LDAP_PPOLICY_HASH_CLEARTEXT`: Whether plaintext passwords should be hashed automatically. Will only be applied with `LDAP_CONFIGURE_PPOLICY` active. Default: **no**.

### <a id="bootstrapping"></a> Bootstrapping

User side bootstrapping happens in two primary phases:

Note: Image level modifications, like modules and tools might require a custom Dockerfile that uses the bitnami-openldap as it's base if you need to modify image paths as root, some stuff might be doable in /docker-entrypoint-initdb.d/

1. /docker-entrypoint-initdb.d/ - Targets: Place ldifs or executable .sh scripts here to be run prior to slap.d (To be used with slapadd not ldapadd). Good place to load and configure overlays.
2. /ldifs - Place ldifs here that target the base dn of your root db that would be loaded after cn=config. Good place to load org units and groups etc.

Check the official [OpenLDAP Configuration Reference](https://www.openldap.org/doc/admin26/guide.html) for more information about how to configure OpenLDAP.

#### 1. /docker-entrypoint-initdb.d/

Some key concepts:

- slapd is not running during this phase of the bootstrapping
- you should expect to use slapadd and slapcat against `-F /opt/bitnami/openldap/etc/slapd.d -b cn=config`
- ldapadd won't work here `ldapadd -Q -Y EXTERNAL -H "ldapi:///" -f /ldifs/01-enable-memberof-overlay.ldif`. Many doc sources suggest using ldapadd but slapd isn't running yet.
- slapadd ldifs are different then ldapadd specifically the `changetype: modify` directives required by ldapadd.
- scripts are executed in alpha-numeric order so to control order use 01-myscript.sh 02-otherscript.sh is recommended.

#### 2. Bootstrap your ldap DB in /ldifs

You can bootstrap the contents of **your** database by putting LDIF files in the directory `/ldifs` (or the one you define in `LDAP_CUSTOM_LDIF_DIR`). Those may only contain content underneath your base DN (set by `LDAP_ROOT`). You can **not** set configuration for e.g. `cn=config` in those files.

Some key concepts:

- you can **not** set configuration for e.g. `cn=config` here, use the /docker-entrypoint-initdb.d/ method!
- ldifs are loaded in alpha-numeric order so you can load things in 01-mygroups.ldif, 02-myusers.ldif etc.
- this only runs on first init of the container.

### <a id="data-persistence"></a> Data Persistence

To ensure that the OpenLDAP state is retained across container restarts and updates, it is recommended to mount a volume at `/bitnami/openldap`.

### <a id="overlays"></a> Overlays

Overlays are dynamic modules that can be added to an OpenLDAP server to extend or modify its functionality. See section on Bootstrapping for an example on adding the memberOf or other overlays not directly provided as an overlay flag.

#### Access Logging

This overlay can record accesses to a given backend database on another database.

- `LDAP_ENABLE_ACCESSLOG`: Enables the accesslog module with the following configuration defaults unless specified otherwise. Default: **no**.
- `LDAP_ACCESSLOG_ADMIN_USERNAME`: Admin user for accesslog database. Default: **admin**.
- `LDAP_ACCESSLOG_ADMIN_PASSWORD`: Admin password for accesslog database. Default: **accesspassword**.
- `LDAP_ACCESSLOG_DB`: The DN (Distinguished Name) of the database where the access log entries will be stored. Will only be applied with `LDAP_ENABLE_ACCESSLOG` active. Default: **cn=accesslog**.
- `LDAP_ACCESSLOG_LOGOPS`: Specify which types of operations to log. Valid aliases for common sets of operations are: writes, reads, session or all. Will only be applied with `LDAP_ENABLE_ACCESSLOG` active. Default: **writes**.
- `LDAP_ACCESSLOG_LOGSUCCESS`: Whether successful operations should be logged. Will only be applied with `LDAP_ENABLE_ACCESSLOG` active. Default: **TRUE**.
- `LDAP_ACCESSLOG_LOGPURGE`: When and how often old access log entries should be purged. Format `"dd+hh:mm"`. Will only be applied with `LDAP_ENABLE_ACCESSLOG` active. Default: **07+00:00 01+00:00**.
- `LDAP_ACCESSLOG_LOGOLD`: An LDAP filter that determines which entries should be logged. Will only be applied with `LDAP_ENABLE_ACCESSLOG` active. Default: **(objectClass=*)**.
- `LDAP_ACCESSLOG_LOGOLDATTR`: Specifies an attribute that should be logged. Will only be applied with `LDAP_ENABLE_ACCESSLOG` active. Default: **objectClass**.

Check the official page [OpenLDAP, Overlays, Access Logging](https://www.openldap.org/doc/admin26/overlays.html#Access%20Logging) for detailed configuration information.

#### Sync Provider

- `LDAP_ENABLE_SYNCPROV`: Enables the syncrepl module with the following configuration defaults unless specified otherwise. Default: **no**.
- `LDAP_SYNCPROV_CHECKPPOINT`: For every 100 operations or 10 minutes, which ever is sooner, the contextCSN will be checkpointed. Will only be applied with `LDAP_ENABLE_SYNCPROV` active. Default: **100 10**.
- `LDAP_SYNCPROV_SESSIONLOG`: The maximum number of session log entries the session log can record. Will only be applied with `LDAP_ENABLE_SYNCPROV` active. Default: **100**.

Check the official page [OpenLDAP, Overlays, Sync Provider](https://www.openldap.org/doc/admin26/overlays.html#Sync%20Provider) for detailed configuration information.

#### Dynamic List or Member Of

The overlays `dynlist` and `memberof` both require the operational `memberOf` attribute to be present in the loaded schema. During initialization, a check is performed for the presence of this attribute; if it is absent, it is created programmatically.

At the same time, the `msuser` schema declares the same attribute. If both the schema and at least one of the overlays are required, a conflict may arise depending on the load order, such as whether the schema is loaded before or after the overlays. If the overlays are loaded first, the process stops and raises a `Duplicate attribute` error.

In a standard OpenLDAP installation (deb or rpm), its configuration is stored in the main file, which may include another one. In this case, the order is determined by the order of directives.

For configuration flexibility, the container-based approach relies on a file tree structure rather than a master file with includes. To ensure the correct order, the file tree must be read deterministically. Fortunately, Linux sorts folder content using alphanumeric order. This allows overlay loading after the schema by using a keyword that is after `schema` in alphanumeric sorting (i.e. `cn=z-module{N}` will be loaded after `cn=schema` as they are both children of `cn=config`). Doing so, the configuration merging `msuser` schema and `dynlist` (or `memberof`) will load without errors.

IMPORTANT: The `dynlist` requires the schema `dyngroup`. This can be done by adding it to the list of schemas to load through `LDAP_EXTRA_SCHEMAS`.

Check the official page [OpenLDAP, Overlays, Dynamic Lists](https://www.openldap.org/doc/admin26/overlays.html#Dynamic%20Lists) for detailed configuration information.

### <a id="securing-traffic"></a> Securing OpenLDAP traffic

OpenLDAP clients and servers are capable of using the Transport Layer Security (TLS) framework to provide integrity and confidentiality protections and to support LDAP authentication using the SASL EXTERNAL mechanism. Should you desire to enable this optional feature, you may use the following environment variables to configure the application:

- `LDAP_ENABLE_TLS`: Whether to enable TLS for traffic or not. Defaults to `no`.
- `LDAP_REQUIRE_TLS`: Whether connections must use TLS. Will only be applied with `LDAP_ENABLE_TLS` active. Defaults to `no`.
- `LDAP_LDAPS_PORT_NUMBER`: Port used for TLS secure traffic. Priviledged port is supported (e.g. `636`). Default: **1636** (non privileged port).
- `LDAP_TLS_CERT_FILE`: File containing the certificate file for the TLS traffic. No defaults.
- `LDAP_TLS_KEY_FILE`: File containing the key for certificate. No defaults.
- `LDAP_TLS_CA_FILE`: File containing the CA of the certificate. No defaults.
- `LDAP_TLS_DH_PARAMS_FILE`: File containing the DH parameters. No defaults.

This new feature is not mutually exclusive, which means it is possible to listen to both TLS and non-TLS connection simultaneously. To use TLS you can use the URI `ldaps://openldap:1636` or use the non-TLS URI forcing ldap to use TLS `ldap://openldap:1389 -ZZ`.

### <a id="run-behind-load-balancer"></a> Run behind load balancer

OpenLDAP supports the HAProxy proxy protocol version 2 to detect real client IP that is masked when server runs behind load balancer. You can enable and configure this feature with the following environment variables:

- `LDAP_ENABLE_PROXYPROTO`: Whether to enable proxy protocol support for traffic or not. Defaults to `no`.
- `LDAP_PROXYPROTO_PORT_NUMBER`: The port OpenLDAP is listening for requests that is wrapped in proxy protocol. Default: the **LDAP_PORT_NUMBER** value.
- `LDAP_PROXYPROTO_LDAPS_PORT_NUMBER`: Port used for TLS secure traffic that is wrapped in proxy protocol. Default: the **LDAP_LDAPS_PORT_NUMBER** value.

Enabling this feature will replace regular and TLS ports with proxy protocol capable analogs. To use both port types, set **LDAP_PROXYPROTO_PORT_NUMBER** to some different value than **LDAP_PORT_NUMBER**. The same statement applied to **LDAP_PROXYPROTO_LDAPS_PORT_NUMBER** and **LDAP_LDAPS_PORT_NUMBER** pair.

**Security warning**: To prevent client IP spoofing, it is highly advised to secure the proxy protocol capable ports by firewall that allow traffic only from load balancer hosts.

Check the official page [OpenLDAP, Running slapd, Command-Line Options](https://www.openldap.org/doc/admin26/runningslapd.html#Command-Line%20Options) for additional information.

### <a id="initializing-a-new-instance"></a> Initializing a new instance

The [Bitnami OpenLDAP](https://github.com/bitnami/containers/blob/main/bitnami/openldap) image allows you to use your custom scripts to initialize a fresh instance.

The allowed script extension is `.sh`, all scripts are executed in alphabetical order and need to reside in `/docker-entrypoint-initdb.d/`.

Scripts are executed are after the initilization and before the startup of the OpenLDAP service.

### <a id="fips-configuration"></a> FIPS configuration in Bitnami Secure Images

The Bitnami OpenLDAP Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.

## <a id="logging"></a> Logging

The Bitnami OpenLDAP Docker image sends the container logs to `stdout`. To view the logs:

```console
docker logs openldap
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

To see the actual output of slapd in the container's logs, set the environment variable `BITNAMI_DEBUG=true`. Useful especially to find/debug problems in your configuration that lead to errors so OpenLDAP won't start.

## <a id="notable-changes"></a> Notable Changes

### 2.4.58-debian-10-r93

- The default database backend has been changed from `hdb` to `mdb` as recommended. No additional steps should be necessary at upgrade time; the new container version `2.4.59` will initialize using the persisted data.

## <a id="license"></a> License

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
