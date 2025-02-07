# Bitnami package for Valkey Sentinel

## What is Valkey Sentinel?

> Valkey Sentinel provides high availability for Valkey. Valkey Sentinel also provides other collateral tasks such as monitoring, notifications and acts as a configuration provider for clients.

[Overview of Valkey Sentinel](https://valkey.io/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name valkey-sentinel -e VALKEY_PRIMARY_HOST=valkey bitnami/valkey-sentinel:latest
```

**Warning**: This quick setup is only intended for development environments. You are encouraged to change the insecure default credentials and check out the available configuration options in the [Environment Variables](#environment-variables) section for a more secure deployment.

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use Valkey Sentinel in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

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

The recommended way to get the Bitnami Valkey Sentinel Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/valkey-sentinel).

```console
docker pull bitnami/valkey-sentinel:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/valkey-sentinel/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/valkey-sentinel:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a Valkey server running inside a container can easily be accessed by your application containers.

Containers attached to the same network can communicate with each other using the container name as the hostname.

### Using the Command Line

In this example, we will create a Valkey Sentinel instance that will monitor a Valkey instance that is running on the same docker network.

#### Step 1: Create a network

```console
docker network create app-tier --driver bridge
```

#### Step 2: Launch the Valkey instance

Use the `--network app-tier` argument to the `docker run` command to attach the Valkey container to the `app-tier` network.

```console
docker run -d --name valkey-server \
    -e ALLOW_EMPTY_PASSWORD=yes \
    --network app-tier \
    bitnami/valkey:latest
```

#### Step 3: Launch your Valkey Sentinel instance

Finally we create a new container instance to launch the Valkey client and connect to the server created in the previous step:

```console
docker run -it --rm \
    -e VALKEY_PRIMARY_HOST=valkey-server \
    --network app-tier \
    bitnami/valkey-sentinel:latest
```

## Configuration

### Environment variables

#### Customizable environment variables

| Name                                               | Description                                                            | Default Value                          |
|----------------------------------------------------|------------------------------------------------------------------------|----------------------------------------|
| `VALKEY_SENTINEL_DATA_DIR`                         | Valkey data directory                                                  | `${VALKEY_SENTINEL_VOLUME_DIR}/data`   |
| `VALKEY_SENTINEL_DISABLE_COMMANDS`                 | Commands to disable in Valkey                                          | `nil`                                  |
| `VALKEY_SENTINEL_DATABASE`                         | Default Valkey database                                                | `valkey`                               |
| `VALKEY_SENTINEL_AOF_ENABLED`                      | Enable AOF                                                             | `yes`                                  |
| `VALKEY_SENTINEL_HOST`                             | Valkey Sentinel host                                                   | `nil`                                  |
| `VALKEY_SENTINEL_PRIMARY_NAME`                     | Valkey Sentinel primary name                                           | `nil`                                  |
| `VALKEY_SENTINEL_PORT_NUMBER`                      | Valkey Sentinel host port                                              | `$VALKEY_SENTINEL_DEFAULT_PORT_NUMBER` |
| `VALKEY_SENTINEL_QUORUM`                           | Minimum number of sentinel nodes in order to reach a failover decision | `2`                                    |
| `VALKEY_SENTINEL_DOWN_AFTER_MILLISECONDS`          | Time (in milliseconds) to consider a node to be down                   | `60000`                                |
| `VALKEY_SENTINEL_FAILOVER_TIMEOUT`                 | Specifies the failover timeout (in milliseconds)                       | `180000`                               |
| `VALKEY_SENTINEL_PRIMARY_REBOOT_DOWN_AFTER_PERIOD` | Specifies the timeout (in milliseconds) for rebooting a primary        | `0`                                    |
| `VALKEY_SENTINEL_RESOLVE_HOSTNAMES`                | Enables hostnames support                                              | `yes`                                  |
| `VALKEY_SENTINEL_ANNOUNCE_HOSTNAMES`               | Announce hostnames                                                     | `no`                                   |
| `ALLOW_EMPTY_PASSWORD`                             | Allow password-less access                                             | `no`                                   |
| `VALKEY_SENTINEL_PASSWORD`                         | Password for Valkey                                                    | `nil`                                  |
| `VALKEY_PRIMARY_USER`                              | Valkey primary node username                                           | `nil`                                  |
| `VALKEY_PRIMARY_PASSWORD`                          | Valkey primary node password                                           | `nil`                                  |
| `VALKEY_SENTINEL_ANNOUNCE_IP`                      | IP address used to gossip its presence                                 | `nil`                                  |
| `VALKEY_SENTINEL_ANNOUNCE_PORT`                    | Port used to gossip its presence                                       | `nil`                                  |
| `VALKEY_SENTINEL_TLS_ENABLED`                      | Enable TLS for Valkey authentication                                   | `no`                                   |
| `VALKEY_SENTINEL_TLS_PORT_NUMBER`                  | Valkey TLS port (requires VALKEY_SENTINEL_ENABLE_TLS=yes)              | `26379`                                |
| `VALKEY_SENTINEL_TLS_CERT_FILE`                    | Valkey TLS certificate file                                            | `nil`                                  |
| `VALKEY_SENTINEL_TLS_KEY_FILE`                     | Valkey TLS key file                                                    | `nil`                                  |
| `VALKEY_SENTINEL_TLS_CA_FILE`                      | Valkey TLS CA file                                                     | `nil`                                  |
| `VALKEY_SENTINEL_TLS_DH_PARAMS_FILE`               | Valkey TLS DH parameter file                                           | `nil`                                  |
| `VALKEY_SENTINEL_TLS_AUTH_CLIENTS`                 | Enable Valkey TLS client authentication                                | `yes`                                  |
| `VALKEY_PRIMARY_HOST`                              | Valkey primary host (used by replicas)                                 | `valkey`                               |
| `VALKEY_PRIMARY_PORT_NUMBER`                       | Valkey primary host port (used by replicas)                            | `6379`                                 |
| `VALKEY_PRIMARY_SET`                               | Valkey sentinel primary set                                            | `myprimary`                            |

#### Read-only environment variables

| Name                                  | Description                            | Value                                            |
|---------------------------------------|----------------------------------------|--------------------------------------------------|
| `VALKEY_SENTINEL_VOLUME_DIR`          | Persistence base directory             | `/bitnami/valkey-sentinel`                       |
| `VALKEY_SENTINEL_BASE_DIR`            | Valkey installation directory          | `${BITNAMI_ROOT_DIR}/valkey-sentinel`            |
| `VALKEY_SENTINEL_CONF_DIR`            | Valkey configuration directory         | `${VALKEY_SENTINEL_BASE_DIR}/etc`                |
| `VALKEY_SENTINEL_DEFAULT_CONF_DIR`    | Valkey default configuration directory | `${VALKEY_SENTINEL_BASE_DIR}/etc.default`        |
| `VALKEY_SENTINEL_MOUNTED_CONF_DIR`    | Valkey mounted configuration directory | `${VALKEY_SENTINEL_BASE_DIR}/mounted-etc`        |
| `VALKEY_SENTINEL_CONF_FILE`           | Valkey configuration file              | `${VALKEY_SENTINEL_CONF_DIR}/sentinel.conf`      |
| `VALKEY_SENTINEL_LOG_DIR`             | Valkey logs directory                  | `${VALKEY_SENTINEL_BASE_DIR}/logs`               |
| `VALKEY_SENTINEL_TMP_DIR`             | Valkey temporary directory             | `${VALKEY_SENTINEL_BASE_DIR}/tmp`                |
| `VALKEY_SENTINEL_PID_FILE`            | Valkey PID file                        | `${VALKEY_SENTINEL_TMP_DIR}/valkey-sentinel.pid` |
| `VALKEY_SENTINEL_BIN_DIR`             | Valkey executables directory           | `${VALKEY_SENTINEL_BASE_DIR}/bin`                |
| `VALKEY_SENTINEL_DAEMON_USER`         | Valkey system user                     | `valkey`                                         |
| `VALKEY_SENTINEL_DAEMON_GROUP`        | Valkey system group                    | `valkey`                                         |
| `VALKEY_SENTINEL_DEFAULT_PORT_NUMBER` | Valkey Sentinel host port              | `26379`                                          |

### Securing Valkey Sentinel traffic

Valkey adds the support for SSL/TLS connections. Should you desire to enable this optional feature, you may use the aforementioned `VALKEY_SENTINEL_TLS_*` environment variables to configure the application.

When enabling TLS, conventional standard traffic is disabled by default. However this new feature is not mutually exclusive, which means it is possible to listen to both TLS and non-TLS connection simultaneously. To enable non-TLS traffic, set `VALKEY_SENTINEL_PORT_NUMBER` to another port different than `0`.

1. Using `docker run`

    ```console
    $ docker run --name valkey-sentinel \
        -v /path/to/certs:/opt/bitnami/valkey/certs \
        -v /path/to/valkey-sentinel/persistence:/bitnami \
        -e VALKEY_PRIMARY_HOST=valkey \
        -e VALKEY_SENTINEL_TLS_ENABLED=yes \
        -e VALKEY_SENTINEL_TLS_CERT_FILE=/opt/bitnami/valkey/certs/valkey.crt \
        -e VALKEY_SENTINEL_TLS_KEY_FILE=/opt/bitnami/valkey/certs/valkey.key \
        -e VALKEY_SENTINEL_TLS_CA_FILE=/opt/bitnami/valkey/certs/valkeyCA.crt \
        bitnami/valkey-cluster:latest
        bitnami/valkey-sentinel:latest
    ```

Alternatively, you may also provide with this configuration in your [custom](https://github.com/bitnami/containers/blob/main/bitnami/valkey-sentinel#configuration-file) configuration file.

### Configuration file

The image looks for configurations in `/bitnami/valkey-sentinel/conf/`. You can mount a volume at `/bitnami` and copy/edit the configurations in the `/path/to/valkey-persistence/valkey-sentinel/conf/`. The default configurations will be populated to the `conf/` directory if it's empty.

#### Step 1: Run the Valkey Sentinel image

Run the Valkey Sentinel image, mounting a directory from your host.

```console
docker run --name valkey-sentinel \
    -e VALKEY_PRIMARY_HOST=valkey \
    -v /path/to/valkey-sentinel/persistence:/bitnami \
    bitnami/valkey-sentinel:latest
```

#### Step 2: Edit the configuration

Edit the configuration on your host using your favorite editor.

```console
vi /path/to/valkey-persistence/valkey-sentinel/conf/valkey.conf
```

#### Step 3: Restart Valkey

After changing the configuration, restart your Valkey container for changes to take effect.

```console
docker restart valkey
```

## Logging

The Bitnami Valkey Sentinel Docker Image sends the container logs to the `stdout`. To view the logs:

```console
docker logs valkey
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of Valkey Sentinel, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/valkey-sentinel:latest
```

#### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```console
docker stop valkey
```

Next, take a snapshot of the persistent volume `/path/to/valkey-persistence` using:

```console
rsync -a /path/to/valkey-persistence /path/to/valkey-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

#### Step 3: Remove the currently running container

```console
docker rm -v valkey
```

#### Step 4: Run the new image

Re-create your container from the new image.

```console
docker run --name valkey bitnami/valkey-sentinel:latest
```

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues) or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

## Notable Changes

### Starting October 20, 2024

* All the references have been updated from `master/slave` to `primary/replica` to follow the upstream project strategy. Environment variables previously prefixed as `VALKEY_MASTER` or `VALKEY_SENTINEL_MASTER` use `VALKEY_PRIMARY` and `VALKEY_SENTINEL_PRIMARY` now.

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
