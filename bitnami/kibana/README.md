# Bitnami package for Kibana

## What is Kibana?

> Kibana is an open source, browser based analytics and search dashboard for Elasticsearch. Kibana strives to be easy to get started with, while also being flexible and powerful.

[Overview of Kibana](https://www.elastic.co/products/kibana)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

### Docker Compose

```console
docker run --name kibana bitnami/kibana:latest
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use Kibana in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

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

The recommended way to get the Bitnami Kibana Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/kibana).

```console
docker pull bitnami/kibana:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/kibana/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/kibana:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## How to use this image

### Run the application manually

If you want to run the application manually instead of using the chart, these are the basic steps you need to run:

1. Create a new network for the application and the database:

   ```console
   docker network create kibana_network
   ```

2. Run the Elasticsearch container:

    ```console
    docker run -d -p 9200:9200 --name elasticsearch --net=kibana_network bitnami/elasticsearch
    ```

3. Run the Kibana container:

    ```console
    docker run -d -p 5601:5601 --name kibana --net=kibana_network \
      -e KIBANA_ELASTICSEARCH_URL=elasticsearch \
      bitnami/kibana
    ```

  Then you can access your application at `http://your-ip:5601/`

## Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the application will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a volume at the `/bitnami` path. Additionally you should mount a volume for [persistence of the Elasticsearch data](https://github.com/bitnami/containers/blob/main/bitnami/elasticsearch#persisting-your-application).

The above examples define docker volumes namely `elasticsearch_data` and `kibana_data`. The Kibana application state will persist as long as these volumes are not removed.

To avoid inadvertent removal of these volumes you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

```console
docker run -v /path/to/kibana-persistence:/bitnami/kibana bitnami/kibana:latest
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a Kibana server running inside a container can easily be accessed by your application containers.

Containers attached to the same network can communicate with each other using the container name as the hostname.

### Using the Command Line

#### Step 1: Create a network

```console
docker network create app-tier --driver bridge
```

#### Step 2: Launch the Kibana server instance

Use the `--network app-tier` argument to the `docker run` command to attach the Kibana container to the `app-tier` network.

```console
docker run -d --name kibana-server \
    --network app-tier \
    bitnami/kibana:latest
```

#### Step 3: Launch your application container

```console
docker run -d --name myapp \
    --network app-tier \
    YOUR_APPLICATION_IMAGE
```

> **IMPORTANT**:
>
> 1. Please update the **YOUR_APPLICATION_IMAGE_** placeholder in the above snippet with your application image
> 2. In your application container, use the hostname `kibana-server` to connect to the Kibana server

## Configuration

### Environment variables

#### Customizable environment variables

| Name                                         | Description                                                                                        | Default Value                                                    |
|----------------------------------------------|----------------------------------------------------------------------------------------------------|------------------------------------------------------------------|
| `KIBANA_ELASTICSEARCH_URL`                   | Elasticsearch URL. Provide Client node url in the case of a cluster                                | `elasticsearch`                                                  |
| `KIBANA_ELASTICSEARCH_PORT_NUMBER`           | Elasticsearch port                                                                                 | `9200`                                                           |
| `KIBANA_HOST`                                | Kibana host                                                                                        | `0.0.0.0`                                                        |
| `KIBANA_PORT_NUMBER`                         | Kibana port                                                                                        | `5601`                                                           |
| `KIBANA_WAIT_READY_MAX_RETRIES`              | Max retries to wait for Kibana to be ready                                                         | `30`                                                             |
| `KIBANA_INITSCRIPTS_START_SERVER`            | Whether to start the Kibana server before executing the init scripts                               | `yes`                                                            |
| `KIBANA_FORCE_INITSCRIPTS`                   | Whether to force the execution of the init scripts                                                 | `no`                                                             |
| `KIBANA_DISABLE_STRICT_CSP`                  | Disable strict Content Security Policy (CSP) for Kibana                                            | `no`                                                             |
| `KIBANA_CERTS_DIR`                           | Path to certificates folder.                                                                       | `${SERVER_CONF_DIR}/certs`                                       |
| `KIBANA_SERVER_ENABLE_TLS`                   | Enable TLS for inbound connections via HTTPS.                                                      | `false`                                                          |
| `KIBANA_SERVER_KEYSTORE_LOCATION`            | Path to Keystore                                                                                   | `${SERVER_CERTS_DIR}/server/kibana.keystore.p12`                 |
| `KIBANA_SERVER_KEYSTORE_PASSWORD`            | Password for the Elasticsearch keystore containing the certificates or password-protected PEM key. | `nil`                                                            |
| `KIBANA_SERVER_TLS_USE_PEM`                  | Configure Kibana server TLS settings using PEM certificates.                                       | `false`                                                          |
| `KIBANA_SERVER_CERT_LOCATION`                | Path to PEM node certificate.                                                                      | `${SERVER_CERTS_DIR}/server/tls.crt`                             |
| `KIBANA_SERVER_KEY_LOCATION`                 | Path to PEM node key.                                                                              | `${SERVER_CERTS_DIR}/server/tls.key`                             |
| `KIBANA_SERVER_KEY_PASSWORD`                 | Password for the Elasticsearch node PEM key.                                                       | `nil`                                                            |
| `KIBANA_PASSWORD`                            | Kibana password.                                                                                   | `nil`                                                            |
| `KIBANA_ELASTICSEARCH_ENABLE_TLS`            | Enable TLS for Elasticsearch communications.                                                       | `false`                                                          |
| `KIBANA_ELASTICSEARCH_TLS_VERIFICATION_MODE` | Elasticsearch TLS verification mode.                                                               | `full`                                                           |
| `KIBANA_ELASTICSEARCH_TRUSTSTORE_LOCATION`   | Path to Elasticsearch Truststore.                                                                  | `${SERVER_CERTS_DIR}/elasticsearch/elasticsearch.truststore.p12` |
| `KIBANA_ELASTICSEARCH_TRUSTSTORE_PASSWORD`   | Password for the Elasticsearch truststore.                                                         | `nil`                                                            |
| `KIBANA_ELASTICSEARCH_TLS_USE_PEM`           | Configure Elasticsearch TLS settings using PEM certificates.                                       | `false`                                                          |
| `KIBANA_ELASTICSEARCH_CA_CERT_LOCATION`      | Path to Elasticsearch CA certificate.                                                              | `${SERVER_CERTS_DIR}/elasticsearch/ca.crt`                       |
| `KIBANA_DISABLE_STRICT_CSP`                  | Disable strict Content Security Policy (CSP) for Kibana                                            | `no`                                                             |
| `KIBANA_CREATE_USER`                         | Enable the creation of the kibana_system user, if it doesnt exists                                 | `false`                                                          |
| `KIBANA_ELASTICSEARCH_PASSWORD`              | Password for the elastic superuser. Required if KIBANA_CREATE_USER is enabled                      | `nil`                                                            |
| `KIBANA_SERVER_PUBLICBASEURL`                | Publicly available URL that end-users access Kibana at                                             | `nil`                                                            |
| `KIBANA_XPACK_SECURITY_ENCRYPTIONKEY`        | Encryption key so that sessions are not invalidated                                                | `nil`                                                            |
| `KIBANA_XPACK_REPORTING_ENCRYPTIONKEY`       | Static encryption key for reporting                                                                | `nil`                                                            |
| `KIBANA_NEWSFEED_ENABLED`                    | Control whether to enable the newsfeed system for the Kibana UI notification center                | `true`                                                           |
| `KIBANA_ELASTICSEARCH_REQUESTTIMEOUT`        | Time in milliseconds to wait for responses from the back end or Elasticsearch                      | `30000`                                                          |

#### Read-only environment variables

| Name                         | Description                                                                                   | Value                                |
|------------------------------|-----------------------------------------------------------------------------------------------|--------------------------------------|
| `SERVER_FLAVOR`              | Server flavor. Valid values: `kibana` or `opensearch-dashboards`.                             | `kibana`                             |
| `BITNAMI_VOLUME_DIR`         | Directory where to mount volumes                                                              | `/bitnami`                           |
| `KIBANA_VOLUME_DIR`          | Kibana persistence directory                                                                  | `${BITNAMI_VOLUME_DIR}/kibana`       |
| `KIBANA_BASE_DIR`            | Kibana installation directory                                                                 | `${BITNAMI_ROOT_DIR}/kibana`         |
| `KIBANA_CONF_DIR`            | Kibana configuration directory                                                                | `${SERVER_BASE_DIR}/config`          |
| `KIBANA_DEFAULT_CONF_DIR`    | Kibana default configuration directory                                                        | `${SERVER_BASE_DIR}/config.default`  |
| `KIBANA_LOGS_DIR`            | Kibana logs directory                                                                         | `${SERVER_BASE_DIR}/logs`            |
| `KIBANA_TMP_DIR`             | Kibana temporary directory                                                                    | `${SERVER_BASE_DIR}/tmp`             |
| `KIBANA_BIN_DIR`             | Kibana executable directory                                                                   | `${SERVER_BASE_DIR}/bin`             |
| `KIBANA_PLUGINS_DIR`         | Kibana plugins directory                                                                      | `${SERVER_BASE_DIR}/plugins`         |
| `KIBANA_DEFAULT_PLUGINS_DIR` | Kibana default plugins directory                                                              | `${SERVER_BASE_DIR}/plugins.default` |
| `KIBANA_DATA_DIR`            | Kibana data directory                                                                         | `${SERVER_VOLUME_DIR}/data`          |
| `KIBANA_MOUNTED_CONF_DIR`    | Directory for including custom configuration files (that override the default generated ones) | `${SERVER_VOLUME_DIR}/conf`          |
| `KIBANA_CONF_FILE`           | Path to Kibana configuration file                                                             | `${SERVER_CONF_DIR}/kibana.yml`      |
| `KIBANA_LOG_FILE`            | Path to the Kibana log file                                                                   | `${SERVER_LOGS_DIR}/kibana.log`      |
| `KIBANA_PID_FILE`            | Path to the Kibana pid file                                                                   | `${SERVER_TMP_DIR}/kibana.pid`       |
| `KIBANA_INITSCRIPTS_DIR`     | Path to the Kibana container init scripts directory                                           | `/docker-entrypoint-initdb.d`        |
| `KIBANA_DAEMON_USER`         | Kibana system user                                                                            | `kibana`                             |
| `KIBANA_DAEMON_GROUP`        | Kibana system group                                                                           | `kibana`                             |

When you start the kibana image, you can adjust the configuration of the instance by passing one or more environment variables on the `docker run` command line.

#### Specifying Environment Variables on the Docker command line

```console
docker run -d -e KIBANA_ELASTICSEARCH_URL=elasticsearch --name kibana bitnami/kibana:latest
```

### Initializing a new instance

When the container is executed for the first time, it will execute the files with extension `.sh`, located at `/docker-entrypoint-initdb.d`.

In order to have your custom files inside the docker image you can mount them as a volume.

### Configuration file

The image looks for configurations in `/bitnami/kibana/conf/`. As mentioned in [Persisting your application](#persisting-your-application) you can mount a volume at `/bitnami` and copy/edit the configurations in the `/path/to/kibana-persistence/kibana/conf/`. The default configurations will be populated to the `conf/` directory if it's empty.

#### Step 1: Run the Kibana image

Run the Kibana image, mounting a directory from your host.

```console
docker run --name kibana -v /path/to/kibana-persistence:/bitnami bitnami/kibana:latest
```

#### Step 2: Edit the configuration

Edit the configuration on your host using your favorite editor.

```console
vi /path/to/kibana-persistence/kibana/conf/kibana.conf
```

#### Step 3: Restart Kibana

After changing the configuration, restart your Kibana container for changes to take effect.

```console
docker restart kibana
```

Refer to the [configuration](https://www.elastic.co/guide/en/kibana/current/settings.html) manual for the complete list of configuration options.

## Logging

The Bitnami Kibana Docker image sends the container logs to the `stdout`. To view the logs:

```console
docker logs kibana
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of Kibana, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/kibana:latest
```

#### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```console
docker stop kibana
```

Next, take a snapshot of the persistent volume `/path/to/kibana-persistence` using:

```console
rsync -a /path/to/kibana-persistence /path/to/kibana-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

Additionally, [snapshot the Elasticsearch data](https://github.com/bitnami/containers/blob/main/bitnami/elasticsearch#step-2-stop-and-backup-the-currently-running-container)

You can use these snapshots to restore the application state should the upgrade fail.

#### Step 3: Remove the currently running container

```console
docker rm -v kibana
```

#### Step 4: Run the new image

Re-create your container from the new image, restoring your backup if necessary.

```console
docker run --name kibana bitnami/kibana:latest
```

## Notable Changes

### Starting January 16, 2024

* The `docker-compose.yaml` file has been removed, as it was solely intended for internal testing purposes.

### 6.8.15-debian-10-r12 & 7.10.2-debian-10-r62 & 7.12.0-debian-10-r0

* The size of the container image has been decreased.
* The configuration logic is now based on Bash scripts in the *rootfs/* folder.
* Kibana 7.12.0 version or later are licensed under the Elastic License that is not currently accepted as an Open Source license by the Open Source Initiative (OSI).
* Kibana 7.12.0 version or later are including x-pack plugin installed by default. Follow official documentation to use it.

### 6.5.1-r3 & 5.6.13-r20

* The Kibana container has been migrated to a non-root user approach. Previously the container ran as the `root` user and the Kibana daemon was started as the `kibana` user. From now on, both the container and the Kibana daemon run as user `1001`. As a consequence, the data directory must be writable by that user. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile.

### 4.5.4-r1

* `ELASTICSEARCH_URL` parameter has been renamed to `KIBANA_ELASTICSEARCH_URL`.
* `ELASTICSEARCH_PORT` parameter has been renamed to `KIBANA_ELASTICSEARCH_PORT`.

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
