# Jenkins packaged by Bitnami

## What is Jenkins?

> Jenkins is an open source Continuous Integration and Continuous Delivery (CI/CD) server designed to automate the building, testing, and deploying of any software project.

[Overview of Jenkins](http://jenkins-ci.org/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/containers/main/bitnami/jenkins/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

You can find the default credentials and available configuration options in the [Environment Variables](#environment-variables) section.

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

## How to deploy Jenkins in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Jenkins Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/jenkins).

Bitnami containers can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami Jenkins Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/jenkins).

```console
$ docker pull bitnami/jenkins:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/jenkins/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/jenkins:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
$ git clone https://github.com/bitnami/containers.git
$ cd bitnami/APP/VERSION/OPERATING-SYSTEM
$ docker build -t bitnami/APP:latest .
```

## How to use this image

### Using Docker Compose

The main folder of this repository contains a functional [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/jenkins/docker-compose.yml) file. Run the application using it as shown below:

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/containers/main/bitnami/jenkins/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

### Using the Docker Command Line

If you want to run the application manually instead of using `docker-compose`, these are the basic steps you need to run:

#### Step 1: Create a network

```console
$ docker network create jenkins-network
```

#### Step 2: Create volumes for Jenkins persistence and launch the container

```console
$ docker volume create --name jenkins_data
$ docker run -d -p 80:8080 --name jenkins \
  --network jenkins-network \
  --volume jenkins_data:/bitnami/jenkins \
  bitnami/jenkins:latest
```

Access your application at `http://your-ip/`

## Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a volume at the `/bitnami/jenkins` path. The above examples define a docker volume namely `jenkins_data`. The Jenkins application state will persist as long as this volume is not removed.

To avoid inadvertent removal of this volume you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

### Mount host directories as data volumes with Docker Compose

This requires a minor change to the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/jenkins/docker-compose.yml) file present in this repository:

```diff
  ...
  services:
    jenkins:
    ...
    volumes:
-     - 'jenkins_data:/bitnami/jenkins
+     - /path/to/jenkins-persistence:/bitnami/jenkins
- volumes:
-   jenkins_data:
-     driver: local
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `1001`.

### Mount host directories as data volumes using the Docker command line

#### Step 1: Create a network (if it does not exist)

```console
$ docker network create jenkins-network
```

#### Step 2. Create the Jenkins container with host volumes

```console
$ docker run -d -p 80:8080 --name jenkins \
  --network jenkins-network \
  --volume /path/to/jenkins-persistence:/bitnami/jenkins \
  bitnami/jenkins:latest
```

## Configuration

### Environment variables

When you start the Jenkins image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line. If you want to add a new environment variable:

- For docker-compose add the variable name and value under the application section in the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/jenkins/docker-compose.yml) file present in this repository:

    ```yaml
    jenkins:
      ...
      environment:
        - JENKINS_PASSWORD=my_password
      ...
    ```

- For manual execution add a `--env` option with each variable and value:

    ```console
    $ docker run -d -p 80:8080 --name jenkins \
      --env JENKINS_PASSWORD=my_password \
      --network jenkins-network \
      --volume /path/to/jenkins-persistence:/bitnami/jenkins \
      bitnami/jenkins:latest
    ```

Available environment variables:

##### User and Site configuration

- `JENKINS_USERNAME`: Jenkins admin username. Default: **user**
- `JENKINS_PASSWORD`: Jenkins admin password. Default: **bitnami**
- `JENKINS_EMAIL`: Jenkins admin email. Default: **user@example.com**
- `JENKINS_HOME`: Jenkins home directory. Default: **/bitnami/jenkins/home**
- `JENKINS_HTTP_PORT_NUMBER`: Port used by Jenkins for HTTP. Default: **8080**
- `JENKINS_HTTPS_PORT_NUMBER`: Port used by Jenkins for HTTPS. Default: **8443**
- `JENKINS_EXTERNAL_HTTP_PORT_NUMBER`: Port to used by Jenkins to generate URLs and links when accessing using HTTP. Default: **80**
- `JENKINS_EXTERNAL_HTTPS_PORT_NUMBER`: Port to used by Jenkins to generate URLs and links when accessing using HTTPS. Default: **443**
- `JENKINS_JNLP_PORT_NUMBER`: Port used by Jenkins for JNLP. Default: **50000**
- `JENKINS_FORCE_HTTPS`: Enable serving Jenkins only through HTTPS. Default: **no**
- `JENKINS_SKIP_BOOTSTRAP`: Skip performing the initial bootstrapping. Default: **no**

##### JAVA configuration

- `JAVA_OPTS`: Customize JVM parameters. No defaults.

## Logging

The Bitnami Jenkins Docker image sends the container logs to `stdout`. To view the logs:

```console
$ docker logs jenkins
```

Or using Docker Compose:

```console
$ docker-compose logs jenkins
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Backing up your container

To backup your data, configuration and logs, follow these simple steps:

#### Step 1: Stop the currently running container

- For docker-compose: `$ docker-compose stop jenkins`
- For manual execution: `$ docker stop jenkins`

#### Step 2: Run the backup command

We need to mount two volumes in a container we will use to create the backup: a directory on your host to store the backup in, and the volumes from the container we just stopped so we can access the data.

```console
$ docker run --rm -v /path/to/jenkins-backups:/backups --volumes-from jenkins bitnami/bitnami-shell \
  cp -a /bitnami/jenkins /backups/latest
```

### Restoring a backup

Restoring a backup is as simple as mounting the backup as volumes in the containers.

```diff
 $ docker run -d --name jenkins \
   ...
-  --volume /path/to/jenkins-persistence:/bitnami/jenkins \
+  --volume /path/to/jenkins-backups/latest:/bitnami/jenkins \
   bitnami/jenkins:latest
```

### Upgrading Jenkins

Bitnami provides up-to-date versions of Jenkins, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the Jenkins container.

### Step 1. Get the updated images:

```console
$ docker pull bitnami/jenkins:latest
```

### Step 2. Stop your container

- For docker-compose: `$ docker-compose stop jenkins`
- For manual execution: `$ docker stop jenkins`

### Step 3. Take a snapshot of the application state

Follow the steps in [Backing up your container](#backing-up-your-container) to take a snapshot of the current application state.

### Step 4. Remove the stopped container

- For docker-compose: `$ docker-compose rm -v jenkins`
- For manual execution: `$ docker rm -v jenkins`

### Step 5. Run the new image

- For docker-compose: `$ docker-compose up jenkins`
- For manual execution ([mount](#mount-persistent-folders-manually) the directories if needed): `docker run --name jenkins bitnami/jenkins:latest`

## Customize this image

For customizations, please note that this image is, by default, a non-root container using the user `jenkins` with `uid=1001`.

### Extend this image

To extend the bitnami original image, you can create your own image using a Dockerfile with the format below:

```Dockerfile
FROM bitnami/jenkins
## Put your customizations below
...
```

Here is an example of extending the image with the following modifications:

- Install the `vim` editor

```Dockerfile
FROM bitnami/jenkins

## Change user to perform privileged actions
USER 0
## Install 'vim'
RUN install_packages vim
## Revert to the original non-root user
USER 1001
```

### Installing plugins

To download and install a set of plugins and their dependencies, use the [Plugin Installation Manager tool](https://github.com/jenkinsci/plugin-installation-manager-tool). You can find information about how to use this tool in the guide below:

- [Getting Started with Plugin Installation Manager tool](https://github.com/jenkinsci/plugin-installation-manager-tool#getting-started)

### Passing JVM parameters

You might need to customize the JVM running Jenkins, typically to pass system properties or to tweak heap memory settings. Use the `JAVA_OPTS` environment variable for this purpose:

```console
$ docker run -d --name jenkins -p 80:8080 \
  --env JAVA_OPTS=-Dhudson.footerURL=http://mycompany.com \
  bitnami/jenkins:latest
```

### Skipping Bitnami initialization

By default, when running this image, Bitnami implement some logic in order to configure it for working out of the box. This initialization consists of creating the user and password, preparing data to persist, configuring permissions, creating the `JENKINS_HOME`, etc. You can skip it in two ways:

- Setting the `JENKINS_SKIP_BOOTSTRAP` environment variable to `yes`.
- Attaching a volume with a custom `JENKINS_HOME` that contains a functional Jenkins installation.

### Adding files/directories to the image

You can include files to the image automatically. All files/directories located in `/usr/share/jenkins/ref` are copied to `/bitnami/jenkins/home` (default Jenkins home directory).

#### Examples:

##### Run groovy scripts at Jenkins start up

You can create custom groovy scripts and make Jenkins run them at start up.

However, using this feature will disable the default configuration done by the Bitnami scripts. This is intended to customize the Jenkins configuration by code.

```console
$ mkdir jenkins-init.groovy.d
$ echo "println '--> hello world'" > jenkins-init.groovy.d/AA_hello.groovy
$ echo "println '--> bye world'" > jenkins-init.groovy.d/BA_bye.groovy

$ docker run -d -p 80:8080 --name jenkins \
  --env "JENKINS_SKIP_BOOTSTRAP=yes" \
  --volume "$(pwd)/jenkins-init.groovy.d:/usr/share/jenkins/ref/init.groovy.d" \
  bitnami/jenkins:latest

$ docker logs jenkins | grep world
--> hello world!
--> bye world!
```

##### Run custom `config.xml`

You can use your our own `config.xml` file. However, using this feature will disable the default configuration generated by the Bitnami scripts. This is intended to customize the Jenkins configuration by code.

```console
$ docker run -d -p 80:8080 --name jenkins \
  --env "JENKINS_SKIP_BOOTSTRAP=yes" \
  --volume "$(pwd)/config.xml:/usr/share/jenkins/ref/config.xml" \
  bitnami/jenkins:latest
```

> NOTE: The default `admin` user with this setup will not be created. It should be done separately.

## Notable Changes

### 2.346.3-debian-11-r3

- The preinstalled plugins were removed.

### 2.332.2-debian-10-r21

- HTTPS and HTTP support are enabled by default.
- `JENKINS_ENABLE_HTTPS` has been renamed to `JENKINS_FORCE_HTTPS`.

### 2.277.4-debian-10-r19

- The size of the container image has been decreased.
- The configuration logic is now based on Bash scripts in the *rootfs/* folder.
- Only the Jenkins Home directory is persisted.
- The `install-plugins.sh` script has been deprecated. Instead use the Plugin Installation Manager Tool as explained in the [Installing Plugins](#installing-plugins) section.
- The `DISABLE_JENKINS_INITIALIZATION` environment variable was renamed to `JENKINS_SKIP_BOOTSTRAP`.

### 2.263.3-debian-10-rXX

- The deprecated plugins below are not included in the image by default anymore:
  - [GitHub Organization Folder](https://plugins.jenkins.io/github-organization-folder).
  - [Pipeline: Declarative Agent API](https://plugins.jenkins.io/pipeline-model-declarative-agent).

### 2.222.1-debian-10-r17

- Java distribution has been migrated from AdoptOpenJDK to OpenJDK Liberica. As part of VMware, we have an agreement with Bell Software to distribute the Liberica distribution of OpenJDK. That way, we can provide support & the latest versions and security releases for Java.

### 2.204.4-debian-10-r3

- The Jenkins container has been migrated to a "non-root" user approach. Previously the container ran as the `root` user and the Jenkins service was started as the `jenkins` user. From now on, both the container and the Jenkins service run as user `jenkins` (`uid=1001`). You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile.
- Consequences:
  - Backwards compatibility is not guaranteed when data is persisted using docker or docker-compose. We highly recommend migrating your Jenkins data ensuring the `jenkins` user has the appropriate permissions.
  - No "privileged" actions are allowed anymore.

### 2.121.2-ol-7-r14 / 2.121.2-debian-9-r18

- Use Jetty instead of Tomcat as web server.

### 2.107.1-r0

- The Jenkins container has been migrated to the LTS version. From now on, this repository will only track long term support releases from [Jenkins](https://jenkins.io/changelog-stable/).

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues) or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/containers/issues/new/choose). For us to provide better support, be sure to fill the issue template.

## License

Copyright &copy; 2023 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
