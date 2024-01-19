# Bitnami package for Jenkins Agent

## What is Jenkins Agent?

> Jenkins Agent executable (agent.jar). This executable is an instance of the Jenkins Remoting library.

[Overview of Jenkins Agent](https://github.com/jenkinsci/remoting)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name jenkins-agent --env JENKINS_URL=http://jenkins:port bitnami/jenkins-agent:latest <agent-secret> <agent-name>
```

You can find all the available configuration options in the [Environment Variables](#environment-variables) section.

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use Jenkins Agent in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

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

When you start the Jenkins Agent image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line. If you want to add a new environment variable:

* For docker-compose add the variable name and value under the application section in the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/jenkins/docker-compose.yml) file present in this repository:

    ```yaml
    jenkins-agent:
      ...
      environment:
        - JENKINS_URL=http://jenkins:port
      ...
    ```

* For manual execution add a `--env` option with each variable and value:

    ```console
    $ docker run -d --name jenkins-agent \
      --env JENKINS_URL=http://jenkins:port \
      bitnami/jenkins-agent:latest
    ```

Available environment variables:

#### User and Site configuration

* `JENKINS_AGENT_WORKDIR`: The working directory of the remoting instance (stores cache and logs by default). Default: **/bitnami/jenkins/home**
* `JENKINS_URL`: Specify the Jenkins root URLs to connect to.
* `JENKINS_AGENT_TUNNEL`: Connect to the specified host and port, instead of connecting directly to Jenkins. Useful when connection to Jenkins needs to be tunneled.
* `JENKINS_AGENT_PROTOCOLS`: Specify the remoting protocols to attempt when instanceIdentity is provided.
* `JENKINS_AGENT_DIRECT_CONNECTION`: Connect directly to this TCP agent port, skipping the HTTP(S) connection.
* `JENKINS_AGENT_INSTANCE_IDENTITY`: The base64 encoded InstanceIdentity byte array of the Jenkins controller.
* `JENKINS_AGENT_WEB_SOCKET`: Make a WebSocket connection to Jenkins rather than using the TCP port. Default: **false**
* `JENKINS_AGENT_SECRET`: Jenkins Agent name.
* `JENKINS_AGENT_NAME`: Jenkins Agent secret.

##### JAVA configuration

* `JAVA_OPTS`: Customize JVM parameters. No defaults.
* `JAVA_HOME`: Java Home directory. Default: **/opt/bitnami/java**

## Logging

The Bitnami Jenkins Agent Docker image sends the container logs to `stdout`. To view the logs:

```console
docker logs jenkins
```

Or using Docker Compose:

```console
docker-compose logs jenkins
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

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues) or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

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
