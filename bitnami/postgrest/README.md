# Bitnami package for PostgREST

## What is PostgREST?

> PostgREST is a web server that allows communicating to PostgreSQL using API endpoints and operations.

[Overview of PostgREST](https://postgrest.org/en/stable/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run -it --name postgrest bitnami/postgrest
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use PostgREST in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Only latest stable branch maintained in the free Bitnami catalog

Starting December 10th 2024, only the latest stable branch of any container will receive updates in the free Bitnami catalog. To access up-to-date releases for all upstream-supported branches, consider upgrading to Bitnami Premium. Previous versions already released will not be deleted. They are still available to pull from DockerHub.

Please check the Bitnami Premium page in our partner [Arrow Electronics](https://www.arrow.com/globalecs/na/vendors/bitnami?utm_source=GitHub&utm_medium=containers) for more information.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami PostgREST Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/postgrest).

```console
docker pull bitnami/postgrest:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/postgrest/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/postgrest:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of PostgREST, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/postgrest:latest
```

#### Step 2: Remove the currently running container

```console
docker rm -v postgrest
```

#### Step 3: Run the new image

Re-create your container from the new image.

```console
docker run --name postgrest bitnami/postgrest:latest
```

## Configuration

### Environment variables

#### Customizable environment variables

| Name                       | Description                     | Default Value    |
|----------------------------|---------------------------------|------------------|
| `DB_HOST`                  | Database host                   | `localhost`      |
| `DB_PORT`                  | Database port number            | `5432`           |
| `DB_USER`                  | Database user username          | `postgres`       |
| `DB_PASSWORD`              | Database user password          | `nil`            |
| `DB_NAME`                  | Database name                   | `postgres`       |
| `DB_SSL`                   | Database SSL connection enabled | `disable`        |
| `PGRST_JWT_SECRET`         | Postgrest JWT secret            | `nil`            |
| `PGRST_DB_ANON_ROLE`       | Postgrest anon role             | `anon`           |
| `PGRST_DB_SCHEMA`          | Postgrest database schema       | `public,storage` |
| `PGRST_DB_USE_LEGACY_GUCS` | Postgrest use legacy GUCS       | `false`          |
| `PGRST_SERVER_PORT`        | Postgrest server port           | `3000`           |

#### Read-only environment variables

| Name                     | Description                                 | Value                                                                                       |
|--------------------------|---------------------------------------------|---------------------------------------------------------------------------------------------|
| `POSTGREST_BASE_DIR`     | postgrest installation directory.           | `${BITNAMI_ROOT_DIR}/postgrest`                                                             |
| `POSTGREST_LOGS_DIR`     | Directory where postgrest logs are stored.  | `${POSTGREST_BASE_DIR}/logs`                                                                |
| `POSTGREST_LOG_FILE`     | Directory where postgrest logs are stored.  | `${POSTGREST_LOGS_DIR}/postgrest.log`                                                       |
| `POSTGREST_BIN_DIR`      | postgrest directory for binary executables. | `${POSTGREST_BASE_DIR}/bin`                                                                 |
| `PGRST_DB_URI`           | Postgres DB URI                             | `postgresql://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}?sslmode=${DB_SSL}` |
| `POSTGREST_DAEMON_USER`  | postgrest system user.                      | `supabase`                                                                                  |
| `POSTGREST_DAEMON_GROUP` | postgrest system group.                     | `supabase`                                                                                  |

### Running commands

To run commands inside this container you can use `docker run`, for example to execute `postgrest --help` you can follow the example below:

```console
docker run --rm --name postgrest bitnami/postgrest:latest --help
```

Check the [official PostgREST documentation](https://postgrest.org/en/stable//configuration.html) for more information about how to use PostgREST.

## Notable Changes

### Starting January 16, 2024

* The `docker-compose.yaml` file has been removed, as it was solely intended for internal testing purposes.

## Contributing

We'd love for you to contribute to this Docker image. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues) or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

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
