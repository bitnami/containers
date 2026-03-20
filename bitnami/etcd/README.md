# Bitnami Secure Image for Etcd

> etcd is a distributed key-value store designed to securely store data across a cluster. etcd is widely used in production on account of its reliability, fault-tolerance and ease of use.

[Overview of Etcd](https://etcd.io/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run -it --name etcd bitnami/etcd:latest
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

## How to deploy Etcd in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Etcd Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/etcd).

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

> Please note ARM support in branch 3.4 is experimental/unstable according to [upstream docs](https://github.com/etcd-io/website/blob/main/content/en/docs/v3.4/op-guide/supported-platform.md), therefore branch 3.4 is only supported for AMD archs while branch 3.5 supports multiarch (AMD and ARM)

## Get this image

The recommended way to get the Bitnami Etcd Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/etcd).

```console
docker pull bitnami/etcd:latest
```

To use a specific version, you can pull a versioned tag. You can view the
[list of available versions](https://hub.docker.com/r/bitnami/etcd/tags/)
in the Docker Hub Registry.

```console
docker pull bitnami/etcd:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/etcd).

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a Etcd server running inside a container can easily be accessed by your application containers using a Etcd client.

Containers attached to the same network can communicate with each other using the container name as the hostname.

## Configuration

The following section describes the supported environment variables

### Environment variables

Apart from providing your custom configuration file, you can also modify the server behavior via configuration as environment variables.

#### Customizable environment variables

| Name                               | Description                                                                                  | Default Value           |
|------------------------------------|----------------------------------------------------------------------------------------------|-------------------------|
| `ETCD_SNAPSHOTS_DIR`               | etcd snaphots directory (used on "disaster recovery" feature).                               | `/snapshots`            |
| `ETCD_SNAPSHOT_HISTORY_LIMIT`      | etcd snaphots history limit.                                                                 | `1`                     |
| `ETCD_INIT_SNAPSHOTS_DIR`          | etcd init snaphots directory (used on "init from snapshot" feature).                         | `/init-snapshot`        |
| `ALLOW_NONE_AUTHENTICATION`        | Allow accessing etcd without any password.                                                   | `no`                    |
| `ETCD_ROOT_PASSWORD`               | Password for the etcd root user.                                                             | `nil`                   |
| `ETCD_CLUSTER_DOMAIN`              | Domain to use to discover other etcd members.                                                | `nil`                   |
| `ETCD_START_FROM_SNAPSHOT`         | Whether etcd should start from an existing snapshot or not.                                  | `no`                    |
| `ETCD_DISASTER_RECOVERY`           | Whether etcd should try or not to recover from snapshots when the cluste disastrously fails. | `no`                    |
| `ETCD_ON_K8S`                      | Whether etcd is running on a K8s environment or not.                                         | `no`                    |
| `ETCD_INIT_SNAPSHOT_FILENAME`      | Existing snapshot filename to start the etcd cluster from.                                   | `nil`                   |
| `ETCD_PREUPGRADE_START_DELAY`      | Optional delay before starting the pre-upgrade hook (in seconds).                            | `nil`                   |
| `ETCD_NAME`                        | etcd member name.                                                                            | `nil`                   |
| `ETCD_LOG_LEVEL`                   | etcd log level.                                                                              | `info`                  |
| `ETCD_LISTEN_CLIENT_URLS`          | List of URLs to listen on for client traffic.                                                | `http://0.0.0.0:2379`   |
| `ETCD_ADVERTISE_CLIENT_URLS`       | List of this member client URLs to advertise to the rest of the cluster.                     | `http://127.0.0.1:2379` |
| `ETCD_INITIAL_CLUSTER`             | Initial list of members to bootstrap a cluster.                                              | `nil`                   |
| `ETCD_LISTEN_PEER_URLS`            | List of URLs to listen on for peers traffic.                                                 | `nil`                   |
| `ETCD_INITIAL_ADVERTISE_PEER_URLS` | List of this member peer URLs to advertise to the rest of the cluster while bootstrapping.   | `nil`                   |
| `ETCD_INITIAL_CLUSTER_TOKEN`       | Unique initial cluster token used for bootstrapping.                                         | `nil`                   |
| `ETCD_AUTO_TLS`                    | Use generated certificates for TLS communications with clients.                              | `false`                 |
| `ETCD_CERT_FILE`                   | Path to the client server TLS cert file.                                                     | `nil`                   |
| `ETCD_KEY_FILE`                    | Path to the client server TLS key file.                                                      | `nil`                   |
| `ETCD_TRUSTED_CA_FILE`             | Path to the client server TLS trusted CA cert file.                                          | `nil`                   |
| `ETCD_CLIENT_CERT_AUTH`            | Enable client cert authentication                                                            | `false`                 |
| `ETCD_PEER_AUTO_TLS`               | Use generated certificates for TLS communications with peers.                                | `false`                 |
| `ETCD_EXTRA_AUTH_FLAGS`            | Comma separated list of authentication flags to append to etcdctl                            | `nil`                   |

#### Read-only environment variables

| Name                        | Description                                                          | Value                              |
|-----------------------------|----------------------------------------------------------------------|------------------------------------|
| `ETCD_BASE_DIR`             | etcd installation directory.                                         | `/opt/bitnami/etcd`                |
| `ETCD_VOLUME_DIR`           | Persistence base directory.                                          | `/bitnami/etcd`                    |
| `ETCD_BIN_DIR`              | etcd executables directory.                                          | `${ETCD_BASE_DIR}/bin`             |
| `ETCD_DATA_DIR`             | etcd data directory.                                                 | `${ETCD_VOLUME_DIR}/data`          |
| `ETCD_CONF_DIR`             | etcd configuration directory.                                        | `${ETCD_BASE_DIR}/conf`            |
| `ETCD_DEFAULT_CONF_DIR`     | etcd default configuration directory.                                | `${ETCD_BASE_DIR}/conf.default`    |
| `ETCD_TMP_DIR`              | Directory where ETCD temporary files are stored.                     | `${ETCD_BASE_DIR}/tmp`             |
| `ETCD_CONF_FILE`            | ETCD configuration file.                                             | `${ETCD_CONF_DIR}/etcd.yaml`       |
| `ETCD_NEW_MEMBERS_ENV_FILE` | File containining the etcd environment to use after adding a member. | `${ETCD_DATA_DIR}/new_member_envs` |
| `ETCD_DAEMON_USER`          | etcd system user name.                                               | `etcd`                             |
| `ETCD_DAEMON_GROUP`         | etcd system user group.                                              | `etcd`                             |

Additionally, you can configure etcd using the upstream env variables [here](https://etcd.io/docs/v3.6/op-guide/configuration/)

### Configuration file

The configuration can easily be setup by mounting your own configuration file on the directory `/opt/bitnami/etcd/conf`:

You can find a sample configuration file on this [link](https://github.com/coreos/etcd/blob/master/etcd.conf.yml.sample)

### FIPS configuration in Bitnami Secure Images

The Bitnami Etcd Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.
- `GODEBUG`: controls Go FIPS mode. Use `fips140=only` (restricted), `fips140=on` (relaxed), or `fips140=off` (disabled).

## Notable Changes

### 3.5.17-debian-12-r4

- Drop support for non-Helm cluster deployment. Upgrading of any kind including increasing replica count must also be done with `helm upgrade` exclusively. CD automation tools that respect Helm hooks such as ArgoCD can also be used.
- Remove `prestop.sh` script. Hence, container should no longer define lifecycle prestop hook.
- Add `preupgrade.sh` script which should be run as a pre-upgrade Helm hook. This replaces the prestop hook as a more reliable mechanism to remove stale members when replica count is decreased.
- Stop storing member ID in a local file which is unreliable. The container now check the member ID from the data dir instead.
- Stop storing/checking for member removal from a local file. The container now check with other members in the cluster instead.

### 3.4.15-debian-10-r7

- The container now contains the needed logic to deploy the Etcd container on Kubernetes using the [Bitnami Etcd Chart](https://github.com/bitnami/charts/tree/master/bitnami/etcd).

### 3.4.13-debian-10-r7

- Arbitrary user ID(s) are supported again, see <https://github.com/etcd-io/etcd/issues/12158> for more information abut the changes in the upstream source code

### 3.4.10-debian-10-r0

- Arbitrary user ID(s) when running the container with a non-privileged user are not supported (only `1001` UID is allowed).

## Further documentation

For further documentation, please check [Etcd documentation](https://coreos.com/etcd/docs/latest/) or its [GitHub repository](https://github.com/coreos/etcd)

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
