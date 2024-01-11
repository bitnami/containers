# Bitnami package for Supabase Realtime

## What is Supabase Realtime?

> Supabase Realtime is a component of Supabase. Supabase is an open source implementation of Firebase. Supabase Realtime tracks and synchronizes changes in PostgreSQL instances using Websockets.

[Overview of Supabase Realtime](https://github.com/supabase/realtime)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run -it --name supabase-realtime bitnami/supabase-realtime
```

### Docker Compose

```console
curl -sSL https://raw.githubusercontent.com/bitnami/containers/main/bitnami/supabase-realtime/docker-compose.yml > docker-compose.yml
docker-compose up -d
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use Supabase Realtime in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami Supabase Realtime Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/supabase-realtime).

```console
docker pull bitnami/supabase-realtime:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/supabase-realtime/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/supabase-realtime:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of Supabase Realtime, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/supabase-realtime:latest
```

or if you're using Docker Compose, update the value of the image property to `bitnami/supabase-realtime:latest`.

#### Step 2: Remove the currently running container

```console
docker rm -v supabase-realtime
```

or using Docker Compose:

```console
docker-compose rm -v supabase-realtime
```

#### Step 3: Run the new image

Re-create your container from the new image.

```console
docker run --name supabase-realtime bitnami/supabase-realtime:latest
```

or using Docker Compose:

```console
docker-compose up supabase-realtime
```

## Configuration

### Environment variables

| Name                                | Description                                                                  | Default Value                                         | Can be set |
|-------------------------------------|------------------------------------------------------------------------------|-------------------------------------------------------|------------|
| `$SUPABASE_REALTIME_BASE_DIR`       | Supabase-realtime installation directory.                                    | `${BITNAMI_ROOT_DIR}/supabase-realtime`               |            |
| `$SUPABASE_REALTIME_LOGS_DIR`       | Directory where Supabase-realtime logs are stored.                           | `${SUPABASE_REALTIME_BASE_DIR}/logs`                  |            |
| `$SUPABASE_REALTIME_LOG_FILE`       | Directory where Supabase-realtime logs are stored.                           | `${SUPABASE_REALTIME_LOGS_DIR}/supabase-realtime.log` |            |
| `$SUPABASE_REALTIME_BIN_DIR`        | Supabase-realtime directory for binary executables.                          | `${SUPABASE_REALTIME_BASE_DIR}/bin`                   |            |
| `$SUPABASE_REALTIME_TMP_DIR`        | Directory where Supabase-realtime temporary files are stored.                | `${SUPABASE_REALTIME_BASE_DIR}/tmp`                   |            |
| `$SUPABASE_REALTIME_PID_FILE`       | Path to the PID file for Supabase-realtime.                                  | `${SUPABASE_REALTIME_TMP_DIR}/supabase-realtime.pid`  |            |
| `$SUPABASE_REALTIME_EXTRA_ENV_FILE` | File to store extra environment variables for the harbor-jobservice service. | `${SUPABASE_REALTIME_BASE_DIR}/.env`                  |            |
| `$DB_HOST`                          | Database host                                                                | `localhost`                                           | &check;    |
| `$DB_PORT`                          | Database port number                                                         | `5432`                                                | &check;    |
| `$DB_NAME`                          | Database name                                                                | `postgres`                                            | &check;    |
| `$DB_USER`                          | Database user username                                                       | `postgres`                                            | &check;    |
| `$DB_PASSWORD`                      | Database password                                                            |                                                       | &check;    |
| `$DB_SSL`                           | Database SSL connection enabled                                              | `disable`                                             | &check;    |
| `$API_JWT_SECRET`                   | API Secret                                                                   |                                                       | &check;    |
| `$SECRET_KEY_BASE`                  | Key Base Secret                                                              |                                                       | &check;    |
| `$PORT`                             | Service Port                                                                 | `9500`                                                | &check;    |
| `$FLY_APP_NAME`                     | App Name                                                                     | `realtime`                                            | &check;    |
| `$FLY_ALLOC_ID`                     | Alloc ID                                                                     | `realtime`                                            | &check;    |
| `$ERL_AFLAGS`                       | Flags                                                                        | `-proto_dist inet_tcp`                                | &check;    |
| `$REPLICATION_MODE`                 | Replication Mode                                                             | `RLS`                                                 | &check;    |
| `$REPLICATION_POLL_INTERVAL`        | Replication pool interval                                                    | `100`                                                 | &check;    |
| `$SECURE_CHANNELS`                  | Secure channels                                                              | `true`                                                | &check;    |
| `$SLOT_NAME`                        | Slot name                                                                    | `supabase_realtime_rls`                               | &check;    |
| `$TEMPORARY_SLOT`                   | Temporary Slot                                                               | `true`                                                | &check;    |
| `$SUPABASE_REALTIME_DAEMON_USER`    | postgrest system user.                                                       | `supabase`                                            |            |
| `$SUPABASE_REALTIME_DAEMON_GROUP`   | postgrest system group.                                                      | `supabase`                                            |            |


### Running commands

To run commands inside this container you can use `docker run`, for example to execute `supabase-realtime --help` you can follow the example below:

```console
docker run --rm --name supabase-realtime bitnami/supabase-realtime:latest --help
```

Check the [official Supabase Realtime documentation](https://github.com/supabase/realtime) for more information about how to use Supabase Realtime.

## Contributing

We'd love for you to contribute to this Docker image. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues) or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/containers/issues/new/choose). For us to provide better support, be sure to fill the issue template.

## License

Copyright &copy; 2024 Broadcom. The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
