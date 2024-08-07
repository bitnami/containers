# Bitnami package for Supabase Storage

## What is Supabase Storage?

> supabase-storage is a component of Supabase. Supabase is an open source implementation of Firebase. supabase-storage is a RESTful API for managing the PostgreSQL database.

[Overview of Supabase Storage](https://github.com/supabase/storage-api)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run -it --name supabase-storage bitnami/supabase-storage
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use Supabase Storage in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami Supabase Storage Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/supabase-storage).

```console
docker pull bitnami/supabase-storage:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/supabase-storage/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/supabase-storage:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of Supabase Storage, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/supabase-storage:latest
```

#### Step 2: Remove the currently running container

```console
docker rm -v supabase-storage
```

#### Step 3: Run the new image

Re-create your container from the new image.

```console
docker run --name supabase-storage bitnami/supabase-storage:latest
```

## Configuration

### Environment variables

#### Customizable environment variables

| Name                        | Description            | Default Value                                                             |
|-----------------------------|------------------------|---------------------------------------------------------------------------|
| `DB_HOST`                   | Database host          | `localhost`                                                               |
| `DB_PORT`                   | Database port number   | `5432`                                                                    |
| `DB_NAME`                   | Database name          | `postgres`                                                                |
| `DB_USER`                   | Database user username | `postgres`                                                                |
| `DB_PASSWORD`               | Database password      | `nil`                                                                     |
| `DATABASE_URL`              | Database url           | `postgresql://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}` |
| `PGRST_JWT_SECRET`          | JWT key                | `nil`                                                                     |
| `ANON_KEY`                  | Anon key               | `nil`                                                                     |
| `SERVICE_KEY`               | Service key            | `nil`                                                                     |
| `PORT`                      | Service Port           | `5000`                                                                    |
| `POSTGREST_URL`             | Postgrest url          | `http://localhost:3000`                                                   |
| `PGOPTIONS`                 | PG Options             | `-c search_path=storage,public`                                           |
| `FILE_SIZE_LIMIT`           |                        | `52428800`                                                                |
| `STORAGE_BACKEND`           | Backend for storage    | `file`                                                                    |
| `FILE_STORAGE_BACKEND_PATH` | Storage backend path   | `/bitnami/supabase-storage`                                               |
| `TENANT_ID`                 | Tenant ID              | `stub`                                                                    |
| `REGION`                    | Region                 | `stub`                                                                    |
| `GLOBAL_S3_BUCKET`          | Global S3 Bucket       | `stub`                                                                    |

#### Read-only environment variables

| Name                            | Description                                        | Value                                               |
|---------------------------------|----------------------------------------------------|-----------------------------------------------------|
| `SUPABASE_STORAGE_BASE_DIR`     | Supabase-storage installation directory.           | `${BITNAMI_ROOT_DIR}/supabase-storage`              |
| `SUPABASE_STORAGE_LOGS_DIR`     | Directory where Supabase-storage logs are stored.  | `${SUPABASE_STORAGE_BASE_DIR}/logs`                 |
| `SUPABASE_STORAGE_LOG_FILE`     | Directory where Supabase-storage logs are stored.  | `${SUPABASE_STORAGE_LOGS_DIR}/supabase-storage.log` |
| `SUPABASE_STORAGE_BIN_DIR`      | Supabase-storage directory for binary executables. | `${SUPABASE_STORAGE_BASE_DIR}/node_modules/.bin`    |
| `SUPABASE_STORAGE_DAEMON_USER`  | postgrest system user.                             | `supabase`                                          |
| `SUPABASE_STORAGE_DAEMON_GROUP` | postgrest system group.                            | `supabase`                                          |

### Running commands

To run commands inside this container you can use `docker run`, for example to execute `supabase-storage --help` you can follow the example below:

```console
docker run --rm --name supabase-storage bitnami/supabase-storage:latest --help
```

Check the [official Supabase Storage documentation](https://github.com/supabase/storage-api) for more information about how to use Supabase Storage.

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
