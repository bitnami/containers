# Bitnami Secure Image for Jenkins Agent

## What is Jenkins Agent?

> Jenkins Agent executable (agent.jar). This executable is an instance of the Jenkins Remoting library.

[Overview of Jenkins Agent](https://github.com/jenkinsci/remoting)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name jenkins-agent --env JENKINS_URL=http://jenkins:port bitnami/jenkins-agent:latest <agent-secret> <agent-name>
```

You can find all the available configuration options in the [Environment Variables](#environment-variables) section.

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

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

## Get this image

The recommended way to get the Bitnami Jenkins Agent Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/jenkins).

```console
docker pull bitnami/jenkins-agent:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/jenkins/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/jenkins-agent:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Configuration

### Environment variables

#### Customizable environment variables

| Name                              | Description                                                                                                                                | Default Value                      |
|-----------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------|
| `JENKINS_AGENT_TUNNEL`            | Connect to the specified host and port, instead of connecting directly to Jenkins. Useful when connection to Jenkins needs to be tunneled. | `nil`                              |
| `JENKINS_AGENT_URL`               | Specify the Jenkins root URLs to connect to.                                                                                               | `nil`                              |
| `JENKINS_AGENT_PROTOCOLS`         | Specify the remoting protocols to attempt when instanceIdentity is provided                                                                | `nil`                              |
| `JENKINS_AGENT_DIRECT_CONNECTION` | Connect directly to this TCP agent port, skipping the HTTP(S) connection                                                                   | `nil`                              |
| `JENKINS_AGENT_INSTANCE_IDENTITY` | The base64 encoded InstanceIdentity byte array of the Jenkins controller                                                                   | `nil`                              |
| `JENKINS_AGENT_WORKDIR`           | The working directory of the remoting instance (stores cache and logs by default).                                                         | `${JENKINS_AGENT_VOLUME_DIR}/home` |
| `JENKINS_AGENT_WEB_SOCKET`        | Make a WebSocket connection to Jenkins rather than using the TCP port                                                                      | `false`                            |
| `JENKINS_AGENT_SECRET`            | Jenkins agent name                                                                                                                         | `nil`                              |
| `JENKINS_AGENT_NAME`              | Jenkins agent secret                                                                                                                       | `nil`                              |
| `JAVA_HOME`                       | Java Home directory.                                                                                                                       | `${BITNAMI_ROOT_DIR}/java`         |
| `JAVA_OPTS`                       | Java options.                                                                                                                              | `nil`                              |

#### Read-only environment variables

| Name                         | Description                                          | Value                                         |
|------------------------------|------------------------------------------------------|-----------------------------------------------|
| `JENKINS_AGENT_BASE_DIR`     | Jenkins Agent installation directory.                | `${BITNAMI_ROOT_DIR}/jenkins-agent`           |
| `JENKINS_AGENT_LOGS_DIR`     | Jenkins Agent directory for log files.               | `${JENKINS_AGENT_BASE_DIR}/logs`              |
| `JENKINS_AGENT_LOG_FILE`     | Path to the Jenkins Agent log file.                  | `${JENKINS_AGENT_LOGS_DIR}/jenkins-agent.log` |
| `JENKINS_AGENT_TMP_DIR`      | Jenkins Agent directory for runtime temporary files. | `${JENKINS_AGENT_BASE_DIR}/tmp`               |
| `JENKINS_AGENT_PID_FILE`     | Path to the Jenkins Agent PID file.                  | `${JENKINS_AGENT_TMP_DIR}/jenkins-agent.pid`  |
| `JENKINS_AGENT_VOLUME_DIR`   | Persistence base directory.                          | `${BITNAMI_VOLUME_DIR}/jenkins`               |
| `JENKINS_AGENT_DAEMON_USER`  | Jenkins Agent system user.                           | `jenkins`                                     |
| `JENKINS_AGENT_DAEMON_GROUP` | Jenkins Agent system group.                          | `jenkins`                                     |

When you start the Jenkins Agent image, you can adjust the configuration of the instance by passing one or more environment variables either on the `docker run` command line. If you want to add a new environment variable:

- For manual execution add a `--env` option with each variable and value:

    ```console
    $ docker run -d --name jenkins-agent \
      --env JENKINS_URL=http://jenkins:port \
      bitnami/jenkins-agent:latest
    ```

### FIPS configuration in Bitnami Secure Images

The Bitnami Jenkins Agent Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.

## Logging

The Bitnami Jenkins Agent Docker image sends the container logs to `stdout`. To view the logs:

```console
docker logs jenkins
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

## Customize this image

For customizations, please note that this image is, by default, a non-root container using the user `jenkins` with `uid=1001`.

### Extend this image

To extend the bitnami original image, you can create your own image using a Dockerfile with the format below:

```Dockerfile
FROM bitnami/jenkins-agent
## Put your customizations below
...
```

## Notable Changes

### Starting January 16, 2024

- The `docker-compose.yaml` file has been removed, as it was solely intended for internal testing purposes.

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues) or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/containers/issues/new/choose). For us to provide better support, be sure to fill the issue template.

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
