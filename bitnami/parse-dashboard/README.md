# Bitnami package for Parse Dashboard

## What is Parse Dashboard?

> Parse Dashboard is a standalone dashboard for managing your Parse apps. You can use it to manage your Parse Server apps.

[Overview of Parse Dashboard](https://parseplatform.org/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name parse-dashboard bitnami/parse-dashboard:latest
```

## ⚠️ Important Notice: Upcoming changes to the Bitnami Catalog

Beginning August 28th, 2025, Bitnami will evolve its public catalog to offer a curated set of hardened, security-focused images under the new [Bitnami Secure Images initiative](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications). As part of this transition:

- Granting community users access for the first time to security-optimized versions of popular container images.
- Bitnami will begin deprecating support for non-hardened, Debian-based software images in its free tier and will gradually remove non-latest tags from the public catalog. As a result, community users will have access to a reduced number of hardened images. These images are published only under the “latest” tag and are intended for development purposes
- Starting August 28th, over two weeks, all existing container images, including older or versioned tags (e.g., 2.50.0, 10.6), will be migrated from the public catalog (docker.io/bitnami) to the “Bitnami Legacy” repository (docker.io/bitnamilegacy), where they will no longer receive updates.
- For production workloads and long-term support, users are encouraged to adopt Bitnami Secure Images, which include hardened containers, smaller attack surfaces, CVE transparency (via VEX/KEV), SBOMs, and enterprise support.

These changes aim to improve the security posture of all Bitnami users by promoting best practices for software supply chain integrity and up-to-date deployments. For more details, visit the [Bitnami Secure Images announcement](https://github.com/bitnami/containers/issues/83267).

## Why use Bitnami Secure Images?

- Bitnami Secure Images and Helm charts are built to make open source more secure and enterprise ready.
- Triage security vulnerabilities faster, with transparency into CVE risks using industry standard Vulnerability Exploitability Exchange (VEX), KEV, and EPSS scores.
- Our hardened images use a minimal OS (Photon Linux), which reduces the attack surface while maintaining extensibility through the use of an industry standard package format.
- Stay more secure and compliant with continuously built images updated within hours of upstream patches.
- Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
- Hardened images come with attestation signatures (Notation), SBOMs, virus scan reports and other metadata produced in an SLSA-3 compliant software factory.

Only a subset of BSI applications are available for free. Looking to access the entire catalog of applications as well as enterprise support? Try the [commercial edition of Bitnami Secure Images today](https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/).

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Prerequisites

To run this application you need Docker Engine 1.10.0.

## How to use this image

### Run the application manually

If you want to run the application manually instead of using the Helm chart, these are the basic steps you need to run:

1. Create a network for the application, Parse Server and the database:

    ```console
    docker network create parse_dashboard-tier
    ```

2. Start a MongoDB&reg; database in the network generated:

    ```console
    docker run -d --name mongodb --net=parse_dashboard-tier bitnami/mongodb
    ```

    *Note:* You need to give the container a name in order to Parse to resolve the host.

3. Start a Parse Server container:

    ```console
    docker run -d -p 1337:1337 --name parse --net=parse_dashboard-tier bitnami/parse
    ```

4. Run the Parse Dashboard container:

    ```console
    docker run -d -p 80:4040 --name parse-dashboard --net=parse_dashboard-tier bitnami/parse-dashboard
    ```

    Then you can access your application at `http://your-ip/`

### Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a volume at the `/bitnami` path. Additionally you should mount a volume for the persistence of [MongoDB&reg;](https://github.com/bitnami/containers/blob/main/bitnami/mongodb#persisting-your-database) and [Parse](https://github.com/bitnami/containers/blob/main/bitnami/parse#persisting-your-application) data.

The above examples define docker volumes namely `mongodb_data`, `parse_data` and `parse_dashboard_data`. The application state will persist as long as these volumes are not removed.

To avoid inadvertent removal of these volumes you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

#### Mount host directories as data volumes using the Docker command line

In this case you need to specify the directories to mount on the run command. The process is the same than the one previously shown:

1. Create a network (if it does not exist):

    ```console
    docker network create parse_dashboard-tier
    ```

2. Create a MongoDB&reg; container with host volume:

    ```console
    docker run -d --name mongodb \
      --net parse-dashboard-tier \
      --volume /path/to/mongodb-persistence:/bitnami \
      bitnami/mongodb:latest
    ```

    *Note:* You need to give the container a name in order to Parse to resolve the host.

3. Start a Parse Server container:

    ```console
    docker run -d -name parse -p 1337:1337 \
      --net parse-dashboard-tier
      --volume /path/to/parse-persistence:/bitnami \
      bitnami/parse:latest
    ```

4. Run the Parse Dashboard container:

    ```console
    docker run -d --name parse-dashboard -p 80:4040 \
    --volume /path/to/parse_dashboard-persistence:/bitnami \
    bitnami/parse-dashboard:latest
    ```

## Upgrade this application

Bitnami provides up-to-date versions of Parse Dashboard, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the Parse Dashboard container.

1. Get the updated images:

    ```console
    docker pull bitnami/parse-dashboard:latest
    ```

2. Stop your container

    - `$ docker stop parse-dashboard`

3. Take a snapshot of the application state

    ```console
    rsync -a /path/to/parse-persistence /path/to/parse-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
    ```

    Additionally, snapshot the [MongoDB&reg;](https://github.com/bitnami/containers/blob/main/bitnami/mongodb#step-2-stop-and-backup-the-currently-running-container) and [Parse server](https://github.com/bitnami/containers/blob/main/bitnami/parse#step-2-stop-and-backup-the-currently-running-container) data.

    You can use these snapshots to restore the application state should the upgrade fail.

4. Remove the currently running container

    - `$ docker rm parse-dashboard`

5. Run the new image

    - Mount the directories if needed: `docker run --name parse-dashboard bitnami/parse-dashboard:latest`

## Configuration

### Environment variables

#### Customizable environment variables

| Name                                         | Description                                             | Default Value |
|----------------------------------------------|---------------------------------------------------------|---------------|
| `PARSE_DASHBOARD_FORCE_OVERWRITE_CONF_FILE`  | Force the config.json config file generation.           | `no`          |
| `PARSE_DASHBOARD_ENABLE_HTTPS`               | Whether to enable HTTPS for Parse Dashboard by default. | `no`          |
| `PARSE_DASHBOARD_EXTERNAL_HTTP_PORT_NUMBER`  | External HTTP port for Parse Dashboard.                 | `80`          |
| `PARSE_DASHBOARD_EXTERNAL_HTTPS_PORT_NUMBER` | External HTTPS port for Parse Dashboard.                | `443`         |
| `PARSE_DASHBOARD_PARSE_HOST`                 | Parse host name.                                        | `parse`       |
| `PARSE_DASHBOARD_PORT_NUMBER`                | Port number in which Parse Dashboard will run.          | `4040`        |
| `PARSE_DASHBOARD_PARSE_PORT_NUMBER`          | Parse server port number.                               | `1337`        |
| `PARSE_DASHBOARD_PARSE_APP_ID`               | A sample string environment variable.                   | `myappID`     |
| `PARSE_DASHBOARD_APP_NAME`                   | Parse Dashboard App name.                               | `MyDashboard` |
| `PARSE_DASHBOARD_PARSE_MASTER_KEY`           | Parse server master key.                                | `mymasterKey` |
| `PARSE_DASHBOARD_PARSE_MOUNT_PATH`           | Parse Dashboard mount path.                             | `/parse`      |
| `PARSE_DASHBOARD_PARSE_PROTOCOL`             | Parse server protocol.                                  | `http`        |
| `PARSE_DASHBOARD_USERNAME`                   | Parse Dashboard user name.                              | `user`        |
| `PARSE_DASHBOARD_PASSWORD`                   | Parse Dashboard user password.                          | `bitnami`     |

#### Read-only environment variables

| Name                           | Description                                      | Value                                             |
|--------------------------------|--------------------------------------------------|---------------------------------------------------|
| `PARSE_DASHBOARD_BASE_DIR`     | Parse installation directory.                    | `${BITNAMI_ROOT_DIR}/parse-dashboard`             |
| `PARSE_DASHBOARD_TMP_DIR`      | Parse temp directory.                            | `${PARSE_DASHBOARD_BASE_DIR}/tmp`                 |
| `PARSE_DASHBOARD_LOGS_DIR`     | Parse logs directory.                            | `${PARSE_DASHBOARD_BASE_DIR}/logs`                |
| `PARSE_DASHBOARD_PID_FILE`     | Parse PID file.                                  | `${PARSE_DASHBOARD_TMP_DIR}/parse-dashboard.pid`  |
| `PARSE_DASHBOARD_LOG_FILE`     | Parse logs file.                                 | `${PARSE_DASHBOARD_LOGS_DIR}/parse-dashboard.log` |
| `PARSE_DASHBOARD_CONF_FILE`    | Configuration file for Parse Dashboard.          | `${PARSE_DASHBOARD_BASE_DIR}/config.json`         |
| `PARSE_DASHBOARD_VOLUME_DIR`   | Parse directory for mounted configuration files. | `${BITNAMI_VOLUME_DIR}/parse-dashboard`           |
| `PARSE_DASHBOARD_DAEMON_USER`  | Parse system user.                               | `parsedashboard`                                  |
| `PARSE_DASHBOARD_DAEMON_GROUP` | Parse system group.                              | `parsedashboard`                                  |

When you start the parse-dashboard image, you can adjust the configuration of the instance by passing one or more environment variables on the `docker run` command line. If you want to add a new environment variable:

```yaml
parse-dashboard:
  ...
  environment:
    - PARSE_DASHBOARD_PASSWORD=my_password
  ...
```

- For manual execution add a `-e` option with each variable and value:

```console
 docker run -d -e PARSE_DASHBOARD_PASSWORD=my_password -p 80:4040 --name parse-dashboard -v /your/local/path/bitnami/parse_dashboard:/bitnami --network=parse_dashboard-tier bitnami/parse-dashboard
```

### FIPS configuration in Bitnami Secure Images

The Bitnami Parse Dashboard Docker image from the [Bitnami Secure Images](https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.

## Notable Changes

### Starting January 16, 2024

- The `docker-compose.yaml` file has been removed, as it was solely intended for internal testing purposes.

### 2.1.0-debian-10-r328

- The size of the container image has been decreased.
- The configuration logic is now based on Bash scripts in the *rootfs/* folder.

### 1.2.0-r69

- The Parse Dashboard container has been migrated to a non-root user approach. Previously the container ran as the `root` user and the Parse Dashboard daemon was started as the `parsedashboard` user. From now on, both the container and the Parse Dashboard daemon run as user `1001`. As a consequence, the data directory must be writable by that user. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile.

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
