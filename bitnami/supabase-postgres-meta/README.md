# Bitnami package for Supabase postgres-meta

## What is Supabase postgres-meta?

> postgres-meta is a component of Supabase. Supabase is an open source implementation of Firebase. postgres-meta is a a scalable, light-weight object storage service.

[Overview of Supabase postgres-meta](https://github.com/supabase/postgres-meta)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run -it --name supabase-postgres-meta bitnami/supabase-postgres-meta
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use Supabase postgres-meta in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami Supabase postgres-meta Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/supabase-postgres-meta).

```console
docker pull bitnami/supabase-postgres-meta:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/supabase-postgres-meta/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/supabase-postgres-meta:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of Supabase postgres-meta, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/supabase-postgres-meta:latest
```

#### Step 2: Remove the currently running container

```console
docker rm -v supabase-postgres-meta
```

#### Step 3: Run the new image

Re-create your container from the new image.

```console
docker run --name supabase-postgres-meta bitnami/supabase-postgres-meta:latest
```

## Configuration

### Environment variables

#### Customizable environment variables

| Name                  | Description            | Default Value    |
|-----------------------|------------------------|------------------|
| `PG_META_DB_HOST`     | Database host          | `localhost`      |
| `PG_META_DB_PORT`     | Database port number   | `5432`           |
| `PG_META_DB_NAME`     | Database name          | `postgres`       |
| `PG_META_DB_USER`     | Database user username | `supabase_admin` |
| `PG_META_DB_PASSWORD` | Database password      | `nil`            |
| `PG_META_DB_SSL_MODE` | Database SSL mode      | `disable`        |
| `PG_META_PORT`        | Service Port           | `9600`           |

#### Read-only environment variables

| Name                                  | Description                                              | Value                                                           |
|---------------------------------------|----------------------------------------------------------|-----------------------------------------------------------------|
| `SUPABASE_POSTGRES_META_BASE_DIR`     | Supabase-postgres-meta installation directory.           | `${BITNAMI_ROOT_DIR}/supabase-postgres-meta`                    |
| `SUPABASE_POSTGRES_META_LOGS_DIR`     | Directory where Supabase-postgres-meta logs are stored.  | `${SUPABASE_POSTGRES_META_BASE_DIR}/logs`                       |
| `SUPABASE_POSTGRES_META_LOG_FILE`     | Directory where Supabase-postgres-meta logs are stored.  | `${SUPABASE_POSTGRES_META_LOGS_DIR}/supabase-postgres-meta.log` |
| `SUPABASE_POSTGRES_META_BIN_DIR`      | Supabase-postgres-meta directory for binary executables. | `${SUPABASE_POSTGRES_META_BASE_DIR}/node_modules/.bin`          |
| `SUPABASE_POSTGRES_META_DAEMON_USER`  | postgrest system user.                                   | `supabase`                                                      |
| `SUPABASE_POSTGRES_META_DAEMON_GROUP` | postgrest system group.                                  | `supabase`                                                      |

### Running commands

To run commands inside this container you can use `docker run`, for example to execute `npm --help` you can follow the example below:

```console
docker run --rm --name supabase-postgres-meta bitnami/supabase-postgres-meta:latest --help
```

Check the [official Supabase postgres-meta documentation](https://github.com/supabase/postgres-meta) for more information about how to use Supabase postgres-meta.

## Notable Changes

### Starting January 16, 2024

* The `docker-compose.yaml` file has been removed, as it was solely intended for internal testing purposes.

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
