# Bitnami package for Redis&reg; Sentinel

## What is Redis&reg; Sentinel?

> Redis&reg; Sentinel provides high availability for Redis. Redis Sentinel also provides other collateral tasks such as monitoring, notifications and acts as a configuration provider for clients.

[Overview of Redis&reg; Sentinel](http://redis.io/)
Disclaimer: Redis is a registered trademark of Redis Ltd. Any rights therein are reserved to Redis Ltd. Any use by Bitnami is for referential purposes only and does not indicate any sponsorship, endorsement, or affiliation between Redis Ltd.

## TL;DR

```console
docker run --name redis-sentinel -e REDIS_MASTER_HOST=redis bitnami/redis-sentinel:latest
```

**Warning**: This quick setup is only intended for development environments. You are encouraged to change the insecure default credentials and check out the available configuration options in the [Environment Variables](#environment-variables) section for a more secure deployment.

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use Redis&reg; Sentinel in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

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

The recommended way to get the Bitnami Redis(R) Sentinel Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/redis-sentinel).

```console
docker pull bitnami/redis-sentinel:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/redis-sentinel/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/redis-sentinel:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a Redis(R) server running inside a container can easily be accessed by your application containers.

Containers attached to the same network can communicate with each other using the container name as the hostname.

### Using the Command Line

In this example, we will create a Redis(R) Sentinel instance that will monitor a Redis(R) instance that is running on the same docker network.

#### Step 1: Create a network

```console
docker network create app-tier --driver bridge
```

#### Step 2: Launch the Redis(R) instance

Use the `--network app-tier` argument to the `docker run` command to attach the Redis(R) container to the `app-tier` network.

```console
docker run -d --name redis-server \
    -e ALLOW_EMPTY_PASSWORD=yes \
    --network app-tier \
    bitnami/redis:latest
```

#### Step 3: Launch your Redis(R) Sentinel instance

Finally we create a new container instance to launch the Redis(R) client and connect to the server created in the previous step:

```console
docker run -it --rm \
    -e REDIS_MASTER_HOST=redis-server \
    --network app-tier \
    bitnami/redis-sentinel:latest
```

## Configuration

### Environment variables

#### Customizable environment variables

| Name                                             | Description                                                            | Default Value                         |
|--------------------------------------------------|------------------------------------------------------------------------|---------------------------------------|
| `REDIS_SENTINEL_DATA_DIR`                        | Redis data directory                                                   | `${REDIS_SENTINEL_VOLUME_DIR}/data`   |
| `REDIS_SENTINEL_DISABLE_COMMANDS`                | Commands to disable in Redis                                           | `nil`                                 |
| `REDIS_SENTINEL_DATABASE`                        | Default Redis database                                                 | `redis`                               |
| `REDIS_SENTINEL_AOF_ENABLED`                     | Enable AOF                                                             | `yes`                                 |
| `REDIS_SENTINEL_HOST`                            | Redis Sentinel host                                                    | `nil`                                 |
| `REDIS_SENTINEL_MASTER_NAME`                     | Redis Sentinel master name                                             | `nil`                                 |
| `REDIS_SENTINEL_PORT_NUMBER`                     | Redis Sentinel host port                                               | `$REDIS_SENTINEL_DEFAULT_PORT_NUMBER` |
| `REDIS_SENTINEL_QUORUM`                          | Minimum number of sentinel nodes in order to reach a failover decision | `2`                                   |
| `REDIS_SENTINEL_DOWN_AFTER_MILLISECONDS`         | Time (in milliseconds) to consider a node to be down                   | `60000`                               |
| `REDIS_SENTINEL_FAILOVER_TIMEOUT`                | Specifies the failover timeout (in milliseconds)                       | `180000`                              |
| `REDIS_SENTINEL_MASTER_REBOOT_DOWN_AFTER_PERIOD` | Specifies the timeout (in milliseconds) for rebooting a master         | `0`                                   |
| `REDIS_SENTINEL_RESOLVE_HOSTNAMES`               | Enables hostnames support                                              | `yes`                                 |
| `REDIS_SENTINEL_ANNOUNCE_HOSTNAMES`              | Announce hostnames                                                     | `no`                                  |
| `ALLOW_EMPTY_PASSWORD`                           | Allow password-less access                                             | `no`                                  |
| `REDIS_SENTINEL_PASSWORD`                        | Password for Redis                                                     | `nil`                                 |
| `REDIS_MASTER_USER`                              | Redis master node username                                             | `nil`                                 |
| `REDIS_MASTER_PASSWORD`                          | Redis master node password                                             | `nil`                                 |
| `REDIS_SENTINEL_ANNOUNCE_IP`                     | IP address used to gossip its presence                                 | `nil`                                 |
| `REDIS_SENTINEL_ANNOUNCE_PORT`                   | Port used to gossip its presence                                       | `nil`                                 |
| `REDIS_SENTINEL_TLS_ENABLED`                     | Enable TLS for Redis authentication                                    | `no`                                  |
| `REDIS_SENTINEL_TLS_PORT_NUMBER`                 | Redis TLS port (requires REDIS_SENTINEL_ENABLE_TLS=yes)                | `26379`                               |
| `REDIS_SENTINEL_TLS_CERT_FILE`                   | Redis TLS certificate file                                             | `nil`                                 |
| `REDIS_SENTINEL_TLS_KEY_FILE`                    | Redis TLS key file                                                     | `nil`                                 |
| `REDIS_SENTINEL_TLS_CA_FILE`                     | Redis TLS CA file                                                      | `nil`                                 |
| `REDIS_SENTINEL_TLS_DH_PARAMS_FILE`              | Redis TLS DH parameter file                                            | `nil`                                 |
| `REDIS_SENTINEL_TLS_AUTH_CLIENTS`                | Enable Redis TLS client authentication                                 | `yes`                                 |
| `REDIS_MASTER_HOST`                              | Redis master host (used by slaves)                                     | `redis`                               |
| `REDIS_MASTER_PORT_NUMBER`                       | Redis master host port (used by slaves)                                | `6379`                                |
| `REDIS_MASTER_SET`                               | Redis sentinel master set                                              | `mymaster`                            |

#### Read-only environment variables

| Name                                 | Description                           | Value                                          |
|--------------------------------------|---------------------------------------|------------------------------------------------|
| `REDIS_SENTINEL_VOLUME_DIR`          | Persistence base directory            | `/bitnami/redis-sentinel`                      |
| `REDIS_SENTINEL_BASE_DIR`            | Redis installation directory          | `${BITNAMI_ROOT_DIR}/redis-sentinel`           |
| `REDIS_SENTINEL_CONF_DIR`            | Redis configuration directory         | `${REDIS_SENTINEL_BASE_DIR}/etc`               |
| `REDIS_SENTINEL_DEFAULT_CONF_DIR`    | Redis default configuration directory | `${REDIS_SENTINEL_BASE_DIR}/etc.default`       |
| `REDIS_SENTINEL_MOUNTED_CONF_DIR`    | Redis mounted configuration directory | `${REDIS_SENTINEL_BASE_DIR}/mounted-etc`       |
| `REDIS_SENTINEL_CONF_FILE`           | Redis configuration file              | `${REDIS_SENTINEL_CONF_DIR}/sentinel.conf`     |
| `REDIS_SENTINEL_LOG_DIR`             | Redis logs directory                  | `${REDIS_SENTINEL_BASE_DIR}/logs`              |
| `REDIS_SENTINEL_TMP_DIR`             | Redis temporary directory             | `${REDIS_SENTINEL_BASE_DIR}/tmp`               |
| `REDIS_SENTINEL_PID_FILE`            | Redis PID file                        | `${REDIS_SENTINEL_TMP_DIR}/redis-sentinel.pid` |
| `REDIS_SENTINEL_BIN_DIR`             | Redis executables directory           | `${REDIS_SENTINEL_BASE_DIR}/bin`               |
| `REDIS_SENTINEL_DAEMON_USER`         | Redis system user                     | `redis`                                        |
| `REDIS_SENTINEL_DAEMON_GROUP`        | Redis system group                    | `redis`                                        |
| `REDIS_SENTINEL_DEFAULT_PORT_NUMBER` | Redis Sentinel host port              | `26379`                                        |

### Securing Redis(R) Sentinel traffic

Starting with version 6, Redis(R) adds the support for SSL/TLS connections. Should you desire to enable this optional feature, you may use the aforementioned `REDIS_SENTINEL_TLS_*` environment variables to configure the application.

When enabling TLS, conventional standard traffic is disabled by default. However this new feature is not mutually exclusive, which means it is possible to listen to both TLS and non-TLS connection simultaneously. To enable non-TLS traffic, set `REDIS_SENTINEL_PORT_NUMBER` to another port different than `0`.

1. Using `docker run`

    ```console
    $ docker run --name redis-sentinel \
        -v /path/to/certs:/opt/bitnami/redis/certs \
        -v /path/to/redis-sentinel/persistence:/bitnami \
        -e REDIS_MASTER_HOST=redis \
        -e REDIS_SENTINEL_TLS_ENABLED=yes \
        -e REDIS_SENTINEL_TLS_CERT_FILE=/opt/bitnami/redis/certs/redis.crt \
        -e REDIS_SENTINEL_TLS_KEY_FILE=/opt/bitnami/redis/certs/redis.key \
        -e REDIS_SENTINEL_TLS_CA_FILE=/opt/bitnami/redis/certs/redisCA.crt \
        bitnami/redis-cluster:latest
        bitnami/redis-sentinel:latest
    ```

Alternatively, you may also provide with this configuration in your [custom](https://github.com/bitnami/containers/blob/main/bitnami/redis-sentinel#configuration-file) configuration file.

### Configuration file

The image looks for configurations in `/bitnami/redis-sentinel/conf/`. You can mount a volume at `/bitnami` and copy/edit the configurations in the `/path/to/redis-persistence/redis-sentinel/conf/`. The default configurations will be populated to the `conf/` directory if it's empty.

#### Step 1: Run the Redis(R) Sentinel image

Run the Redis(R) Sentinel image, mounting a directory from your host.

```console
docker run --name redis-sentinel \
    -e REDIS_MASTER_HOST=redis \
    -v /path/to/redis-sentinel/persistence:/bitnami \
    bitnami/redis-sentinel:latest
```

#### Step 2: Edit the configuration

Edit the configuration on your host using your favorite editor.

```console
vi /path/to/redis-persistence/redis-sentinel/conf/redis.conf
```

#### Step 3: Restart Redis(R)

After changing the configuration, restart your Redis(R) container for changes to take effect.

```console
docker restart redis
```

Refer to the [Redis(R) configuration](http://redis.io/topics/config) manual for the complete list of configuration options.

## Logging

The Bitnami Redis(R) Sentinel Docker Image sends the container logs to the `stdout`. To view the logs:

```console
docker logs redis
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of Redis(R) Sentinel, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/redis-sentinel:latest
```

#### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```console
docker stop redis
```

Next, take a snapshot of the persistent volume `/path/to/redis-persistence` using:

```console
rsync -a /path/to/redis-persistence /path/to/redis-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

#### Step 3: Remove the currently running container

```console
docker rm -v redis
```

#### Step 4: Run the new image

Re-create your container from the new image.

```console
docker run --name redis bitnami/redis-sentinel:latest
```

## Notable Changes

### Starting January 16, 2024

* The `docker-compose.yaml` file has been removed, as it was solely intended for internal testing purposes.

### 4.0.14-debian-9-r201, 4.0.14-ol-7-r222, 5.0.5-debian-9-r169, 5.0.5-ol-7-r175

* Decrease the size of the container. The configuration logic is now based on Bash scripts in the `rootfs/` folder.

### 4.0.10-r25

* The Redis(R) sentinel container has been migrated to a non-root container approach. Previously the container run as `root` user and the redis daemon was started as `redis` user. From now own, both the container and the redis daemon run as user `1001`. As a consequence, the configuration files are writable by the user running the redis process. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile.

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
