# Bitnami Secure Image for Parse Server

## What is Parse Server?

> Parse is a platform that enables users to add a scalable and powerful backend to launch a full-featured app for iOS, Android, JavaScript, Windows, Unity, and more.

[Overview of Parse Server](https://parseplatform.org/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name parse bitnami/parse:latest
```

You can find the default credentials and available configuration options in the [Environment Variables](#environment-variables) section.

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

## How to deploy Parse Server in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Parse Server Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/parse).

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

## How to use this image

### Run Parse with a Database Container

#### Run the application using Docker Compose

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/parse).

### Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a volume at the `/bitnami` path. Additionally you should mount a volume for [persistence of the MongoDB&reg; data](https://github.com/bitnami/containers/blob/main/bitnami/mongodb#persisting-your-database).

The above examples define docker volumes namely `mongodb_data` and `parse_data`. The Parse application state will persist as long as these volumes are not removed.

To avoid inadvertent removal of these volumes you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

## Upgrade this application

Bitnami provides up-to-date versions of Mongodb and Parse, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the Parse container. For the Mongodb upgrade see <https://github.com/bitnami/containers/tree/main/bitnami/mongodb#user-content-upgrade-this-image>

1. Get the updated images:

   ```console
   docker pull bitnami/parse:latest
   ```

2. Stop your container

    - For docker-compose: `$ docker-compose stop parse`
    - For manual execution: `$ docker stop parse`

3. Take a snapshot of the application state

    ```console
    rsync -a /path/to/parse-persistence /path/to/parse-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
    ```

    Additionally, [snapshot the MongoDB&reg; data](https://github.com/bitnami/containers/blob/main/bitnami/mongodb#step-2-stop-and-backup-the-currently-running-container)

    You can use these snapshots to restore the application state should the upgrade fail.

4. Remove the currently running container

    - For docker-compose: `$ docker-compose rm parse`
    - For manual execution: `$ docker rm parse`

5. Run the new image

    - For docker-compose: `$ docker-compose up parse`
    - For manual execution (mount the directories if needed): `docker run --name parse bitnami/parse:latest`

## Configuration

### Environment variables

#### Customizable environment variables

| Name                              | Description                                   | Default Value                  |
|-----------------------------------|-----------------------------------------------|--------------------------------|
| `PARSE_FORCE_OVERWRITE_CONF_FILE` | Force the config.json config file generation. | `no`                           |
| `PARSE_ENABLE_HTTPS`              | Whether to enable HTTPS for Parse by default. | `no`                           |
| `PARSE_BIND_HOST`                 | Parse bind host.                              | `0.0.0.0`                      |
| `PARSE_HOST`                      | Parse host.                                   | `127.0.0.1`                    |
| `PARSE_PORT_NUMBER`               | Port number in which Parse will run.          | `1337`                         |
| `PARSE_APP_ID`                    | Parse app ID.                                 | `myappID`                      |
| `PARSE_MASTER_KEY`                | Parse master key.                             | `mymasterKey`                  |
| `PARSE_APP_NAME`                  | Parse app name.                               | `parse-server`                 |
| `PARSE_MOUNT_PATH`                | Parse mount path.                             | `/parse`                       |
| `PARSE_ENABLE_CLOUD_CODE`         | Enable Parse cloud code support.              | `no`                           |
| `PARSE_DATABASE_HOST`             | Database server host.                         | `$PARSE_DEFAULT_DATABASE_HOST` |
| `PARSE_DATABASE_PORT_NUMBER`      | Database server port.                         | `27017`                        |
| `PARSE_DATABASE_NAME`             | Database name.                                | `bitnami_parse`                |
| `PARSE_DATABASE_USER`             | Database user name.                           | `bn_parse`                     |
| `PARSE_DATABASE_PASSWORD`         | Database user password.                       | `nil`                          |

#### Read-only environment variables

| Name                          | Description                                      | Value                           |
|-------------------------------|--------------------------------------------------|---------------------------------|
| `PARSE_BASE_DIR`              | Parse installation directory.                    | `${BITNAMI_ROOT_DIR}/parse`     |
| `PARSE_TMP_DIR`               | Parse temp directory.                            | `${PARSE_BASE_DIR}/tmp`         |
| `PARSE_LOGS_DIR`              | Parse logs directory.                            | `${PARSE_BASE_DIR}/logs`        |
| `PARSE_PID_FILE`              | Parse PID file.                                  | `${PARSE_TMP_DIR}/parse.pid`    |
| `PARSE_LOG_FILE`              | Parse logs file.                                 | `${PARSE_LOGS_DIR}/parse.log`   |
| `PARSE_CONF_FILE`             | Configuration file for Parse.                    | `${PARSE_BASE_DIR}/config.json` |
| `PARSE_VOLUME_DIR`            | Parse directory for mounted configuration files. | `${BITNAMI_VOLUME_DIR}/parse`   |
| `PARSE_DAEMON_USER`           | Parse system user.                               | `parse`                         |
| `PARSE_DAEMON_GROUP`          | Parse system group.                              | `parse`                         |
| `PARSE_DEFAULT_DATABASE_HOST` | Default database server host.                    | `mongodb`                       |

When you start the parse image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line.

### How to deploy your Cloud functions with Parse Cloud Code?

You can use Cloud Code to run a piece of code in your Parse Server instead of the user's mobile devices. To run your Cloud functions using this image, follow the steps below:

- Create a directory on your host machine and put your Cloud functions on it. In the example below, a simple "Hello world!" function is used:

```console
$ mkdir ~/cloud
$ cat > ~/cloud/main.js <<'EOF'
Parse.Cloud.define("sayHelloWorld", function(request, response) {
    return "Hello world!";
});
EOF
```

- Mount the directory as a data volume at the `/opt/bitnami/parse/cloud` path on your Parse Container and set the environment variable `PARSE_ENABLE_CLOUD_CODE` to `yes`.
- Once both Parse and Parse Dashboard are running, access Parse Dashboard and browse to 'My Dashboard -> API Console'.
- Then, send a 'test query' of type 'POST' using 'functions/sayHelloWorld' as endpoint. Ensure you activate the 'Master Key' parameter.
- Everything should be working now and you should receive a 'Hello World' message in the results.

Find more information about Cloud Code and Cloud functions in the [official documentation](https://docs.parseplatform.org/cloudcode/guide/).

### FIPS configuration in Bitnami Secure Images

The Bitnami Parse Server Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.

## Notable Changes

### 4.9.3

- This version was released from an incorrect version tag from the upstream Parse repositories. Parse developers have reported issues in some functionalities, though no concerns in regards to privacy, security, or legality were found. As such, we strongly recommend updating this version as soon as possible. You can find more information in [Parse 4.10.0 Release Notes](https://github.com/parse-community/parse-server/releases/tag/4.10.0)

### 4.9.3-debian-10-r161

- The size of the container image has been decreased.
- The configuration logic is now based on Bash scripts in the *rootfs/* folder.

### 3.1.2-r14

- The Parse container has been migrated to a non-root user approach. Previously the container ran as the `root` user and the Parse daemon was started as the `parse` user. From now on, both the container and the Parse daemon run as user `1001`. As a consequence, the data directory must be writable by that user. You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile.

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
