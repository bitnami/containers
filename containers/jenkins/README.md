# What is Jenkins?

> Jenkins is widely recognized as the most feature-rich CI available with easy configuration, continuous delivery and continuous integration support, easily test, build and stage your app, and more. It supports multiple SCM tools including CVS, Subversion and Git. It can execute Apache Ant and Apache Maven-based projects as well as arbitrary scripts.

[https://jenkins.io](https://jenkins.io)

# TL;DR

## Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-jenkins/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

You can find the default credentials and available configuration options in the [Environment Variables](#environment-variables) section.

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.

> This [CVE scan report](https://quay.io/repository/bitnami/jenkins?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy Jenkins in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Jenkins Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/jenkins).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`2`, `2-debian-10`, `2.277.4`, `2.277.4-debian-10-r7`, `latest` (2/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-jenkins/blob/2.277.4-debian-10-r7/2/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/jenkins GitHub repo](https://github.com/bitnami/bitnami-docker-jenkins).

# Prerequisites

To run this application you need [Docker Engine](https://www.docker.com/products/docker-engine) >= `1.10.0`. [Docker Compose](https://www.docker.com/products/docker-compose) is recommended with a version `1.6.0` or later.

# How to use this image

## Using Docker Compose

The main folder of this repository contains a functional [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-jenkins/blob/master/docker-compose.yml) file. Run the application using it as shown below:

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-jenkins/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

## Using the Docker Command Line

If you want to run the application manually instead of using `docker-compose`, these are the basic steps you need to run:

### Step 1: Create a network

```console
$ docker network create jenkins-network
```

### Step 2: Create volumes for Jenkins persistence and launch the container

```console
$ docker volume create --name jenkins_data
$ docker run -d --name jenkins \
  -p 80:8080 -p 443:8443 \
  --network jenkins-network \
  --volume jenkins_data:/bitnami/jenkins \
  bitnami/jenkins:latest
```

Access your application at http://your-ip/

## Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a volume at the `/bitnami/jenkins` path. The above examples define a docker volume namely `jenkins_data`. The Jenkins application state will persist as long as this volume is not removed.

To avoid inadvertent removal of this volume you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

### Mount host directories as data volumes with Docker Compose

This requires a minor change to the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-jenkins/blob/master/docker-compose.yml) file present in this repository:

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

### Mount host directories as data volumes using the Docker command line

#### Step 1: Create a network (if it does not exist)

```console
$ docker network create jenkins-network
```

#### Step 2. Create the Jenkins container with host volumes

```console
$ docker run -d --name jenkins \
  -p 80:8080 -p 443:8443 \
  --network jenkins-network \
  --volume /path/to/jenkins-persistence:/bitnami/jenkins \
  bitnami/jenkins:latest
```

# Customizations

For customizations, please note that this image is, by default, a non-root container using the user `jenkins` with `uid=1001`.

## Extend this image

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
LABEL maintainer "Bitnami <containers@bitnami.com>"

## Change user to perform privileged actions
USER 0
## Install 'vim'
RUN install_packages vim
## Revert to the original non-root user
USER 1001
```

## Preinstalling plugins

To pass and download a set of plugins and their dependencies, use the `install-plugins.sh` script. It will download them from update centers

> NOTE: Default update centers must have Internet access

### Plugin version format

Use plugin artifact ID, without `-plugin` extension, and append the version if needed separated by `:`.
Dependencies that are already included in the Jenkins war file will only be downloaded if their required version is newer than the one already included.

You can also use a custom version specifier:

- `latest` - download the latest version from the main update center.
  For Jenkins LTS images
  (example: `git:latest`)

### Script usage

You can run the script manually in the Dockerfile by adding the following after the `COPY rootfs /` command:

```Dockerfile
RUN /install-plugins.sh docker-slaves github-branch-source:1.8
```

Furthermore, it is possible to pass a file that contains this set of plugins (with or without line breaks), you should locate this file in the `rootfs` directory.

```Dockerfile
RUN /install-plugins.sh < /plugins.txt
```

## Adding files/directories to the image

You can include files to the image automatically. All files/directories located in `/usr/share/jenkins/ref` are copied to `JENKINS_HOME`.

### Examples:

#### Run groovy scripts at Jenkins start up

We can create custom groovy scripts and make Jenkins run them at start up. We can also enforce them to run at a certain order by using a prefix in the names.

However, using this feature will disable the default configuration done by the Bitnami scripts. This is intended to customize the Jenkins configuration by code.

```console
$ mkdir jenkins-init.groovy.d
$ echo "println '--> hello world!'" >jenkins-init.groovy.d/AA_hello.groovy
$ echo "println '--> bye world!'" >jenkins-init.groovy.d/BA_bye.groovy

$ docker run -d --name jenkins -e "DISABLE_JENKINS_INITIALIZATION=yes" -v "$(pwd)/jenkins-init.groovy.d:/usr/share/jenkins/ref/init.groovy.d" -p 80:8080 -p 443:8443 bitnami/jenkins:latest

$ docker exec jenkins ls /opt/bitnami/jenkins/jenkins_home/init.groovy.d
AA_hello.groovy
BA_bye.groovy

$ docker exec jenkins cat /opt/bitnami/jenkins/logs/jenkins.log | grep world
--> hello world!
--> bye world!
```

#### Use pre-downloaded plugins

We can download plugins in a local folder and install them at run time.

```console
$ docker run \
  --volume "$(pwd)/jenkins-plugins:/usr/share/jenkins/ref/plugins" \
  bitnami/jenkins:latest \
  install-plugins.sh \
    role-strategy:latest

$ docker run -d --name jenkins \
  -p 80:8080 -p 443:8443 \
  --volume "$(pwd)/jenkins-plugins:/usr/share/jenkins/ref/plugins" \
  bitnami/jenkins:latest

$ docker exec jenkins ls /opt/bitnami/jenkins/jenkins_home/plugins/
```

#### Run custom `config.xml`

We can make Jenkins run our own `config.xml` file.

However, using this feature will disable the default configuration done by the Bitnami scripts. This is intended to customize the Jenkins configuration by code.

In the example below we are going to use a role-based authorization strategy by default.

```console
$ docker run \
  --volume "$(pwd)/jenkins-plugins:/usr/share/jenkins/ref/plugins" \
  bitnami/jenkins:latest \
  install-plugins.sh \
    role-strategy:latest

$ cat >config.xml <<EOF
<?xml version='1.1' encoding='UTF-8'?>
<hudson>
  <disabledAdministrativeMonitors/>
  <version>2.138.1</version>
  <numExecutors>2</numExecutors>
  <mode>NORMAL</mode>
  <useSecurity>true</useSecurity>
  <authorizationStrategy class="com.michelin.cio.hudson.plugins.rolestrategy.RoleBasedAuthorizationStrategy">
    <roleMap type="projectRoles"/>
    <roleMap type="globalRoles">
      <role name="admin" pattern=".*">
        <permissions>
          <permission>hudson.model.View.Delete</permission>
          <permission>hudson.model.Computer.Connect</permission>
          <permission>hudson.model.Run.Delete</permission>
          <permission>hudson.model.Computer.Create</permission>
          <permission>hudson.model.View.Configure</permission>
          <permission>hudson.model.Computer.Build</permission>
          <permission>hudson.model.Item.Configure</permission>
          <permission>hudson.model.Hudson.Administer</permission>
          <permission>hudson.model.Item.Cancel</permission>
          <permission>hudson.model.Item.Read</permission>
          <permission>hudson.model.Computer.Delete</permission>
          <permission>hudson.model.Item.Build</permission>
          <permission>hudson.scm.SCM.Tag</permission>
          <permission>hudson.model.Item.Move</permission>
          <permission>hudson.model.Item.Discover</permission>
          <permission>hudson.model.Hudson.Read</permission>
          <permission>hudson.model.Item.Create</permission>
          <permission>hudson.model.Item.Workspace</permission>
          <permission>hudson.model.Computer.Provision</permission>
          <permission>hudson.model.Run.Replay</permission>
          <permission>hudson.model.View.Read</permission>
          <permission>hudson.model.View.Create</permission>
          <permission>hudson.model.Item.Delete</permission>
          <permission>hudson.model.Computer.Configure</permission>
          <permission>hudson.model.Computer.Disconnect</permission>
          <permission>hudson.model.Run.Update</permission>
        </permissions>
        <assignedSIDs>
          <sid>admin</sid>
        </assignedSIDs>
      </role>
      <role name="viewer" pattern=".*">
        <permissions>
          <permission>hudson.model.Hudson.Read</permission>
          <permission>hudson.model.Item.Read</permission>
          <permission>hudson.model.Item.Discover</permission>
          <permission>hudson.model.View.Read</permission>
        </permissions>
        <assignedSIDs>
          <sid>authenticated</sid>
        </assignedSIDs>
      </role>
    </roleMap>
    <roleMap type="slaveRoles"/>
  </authorizationStrategy>
  <disableRememberMe>false</disableRememberMe>
  <projectNamingStrategy class="jenkins.model.ProjectNamingStrategy$DefaultProjectNamingStrategy"/>
  <workspaceDir>${JENKINS_HOME}/workspace/${ITEM_FULL_NAME}</workspaceDir>
  <buildsDir>${ITEM_ROOTDIR}/builds</buildsDir>
  <jdks/>
  <viewsTabBar class="hudson.views.DefaultViewsTabBar"/>
  <myViewsTabBar class="hudson.views.DefaultMyViewsTabBar"/>
  <clouds/>
  <scmCheckoutRetryCount>0</scmCheckoutRetryCount>
  <views>
    <hudson.model.AllView>
      <owner class="hudson" reference="../../.."/>
      <name>all</name>
      <filterExecutors>false</filterExecutors>
      <filterQueue>false</filterQueue>
      <properties class="hudson.model.View$PropertyList"/>
    </hudson.model.AllView>
  </views>
  <primaryView>all</primaryView>
  <slaveAgentPort>-1</slaveAgentPort>
  <label></label>
  <crumbIssuer class="hudson.security.csrf.DefaultCrumbIssuer">
    <excludeClientIPFromCrumb>false</excludeClientIPFromCrumb>
  </crumbIssuer>
  <nodeProperties/>
  <globalNodeProperties/>
</hudson>
EOF

$ docker run -d --name jenkins \
  -p 80:8080 -p 443:8443 \
  --env "DISABLE_JENKINS_INITIALIZATION=yes" \
  --volume "$(pwd)/jenkins-plugins:/usr/share/jenkins/ref/plugins" \
  --volume "$(pwd)/config.xml:/usr/share/jenkins/ref/config.xml" \
  bitnami/jenkins:latest
```

> NOTE: We are using a `config.xml` created by Jenkins at first run. You can consider using groovy scripts to perform this kind of configuration too.

> NOTE: We are not creating the `admin` user with this setup. It should be done separately.

## Passing JVM parameters

You might need to customize the JVM running Jenkins, typically to pass system properties or to tweak heap memory settings. Use the `JAVA_OPTS` environment variable for this purpose:

```console
$ docker run -d --name jenkins -p 80:8080 -p 443:8443 \
  --env JAVA_OPTS=-Dhudson.footerURL=http://mycompany.com \
  bitnami/jenkins:latest
```

## Skipping Bitnami initialization

By default, when running this image, Bitnami implement some logic in order to configure it for working out of the box. This initialization consists of creating the user and password, preparing data to persist, installing some plugins, configuring permissions, creating the `JENKINS_HOME`, etc.
You can skip it in two ways:

- Setting the `DISABLE_JENKINS_INITIALIZATION` environment variable to `yes`.
- Attaching a volume with a custom `JENKINS_HOME` that contains a functional Jenkins installation.

# Upgrading Jenkins

Bitnami provides up-to-date versions of Jenkins, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the Jenkins container.

## Step 1. Get the updated images:

```console
$ docker pull bitnami/jenkins:latest
```

## Step 2. Stop your container

- For docker-compose: `$ docker-compose stop jenkins`
- For manual execution: `$ docker stop jenkins`

## Step 3. Take a snapshot of the application state

```console
$ rsync -a /path/to/jenkins-persistence /path/to/jenkins-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

You can use this snapshot to restore the application state should the upgrade fail.

## Step 4. Remove the stopped container

- For docker-compose: `$ docker-compose rm -v jenkins`
- For manual execution: `$ docker rm -v jenkins`

## Step 5. Run the new image

- For docker-compose: `$ docker-compose up jenkins`
- For manual execution ([mount](#mount-persistent-folders-manually) the directories if needed): `docker run --name jenkins bitnami/jenkins:latest`

# Configuration

## Environment variables

The Jenkins instance can be customized by specifying environment variables on the first run. The following environment values are provided to customize Jenkins:

- `JENKINS_USERNAME`: Jenkins admin username. Default: **user**
- `JENKINS_PASSWORD`: Jenkins admin password. Default: **bitnami**
- `JENKINS_HOME`: Jenkins home directory. Default: **/opt/bitnami/jenkins/jenkins_home**
- `DISABLE_JENKINS_INITIALIZATION`: Allows to disable the initial Bitnami configuration for Jenkins. Default: **no**
- `JAVA_OPTS`: Customize JVM parameters. No defaults.

### Specifying Environment variables using Docker Compose

Modify the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-jenkins/blob/master/docker-compose.yml) file present in this repository:

```yaml
jenkins:
  ...
  environment:
    - JENKINS_PASSWORD=my_password
  ...
```

### Specifying Environment variables on the Docker command line

```console
$ docker run -d --name jenkins \
  -p 80:8080 -p 443:8443 \
  --network jenkins-network \
  --env JENKINS_PASSWORD=my_password \
  --volume jenkins_data:/bitnami/jenkins \
  bitnami/jenkins:latest
```

# Notable Changes

## 2.263.3-debian-10-rXX

- The deprecated plugins below are not included in the image by default anymore:
  - [GitHub Organization Folder](https://plugins.jenkins.io/github-organization-folder).
  - [Pipeline: Declarative Agent API](https://plugins.jenkins.io/pipeline-model-declarative-agent).

## 2.222.1-debian-10-r17

- Java distribution has been migrated from AdoptOpenJDK to OpenJDK Liberica. As part of VMware, we have an agreement with Bell Software to distribute the Liberica distribution of OpenJDK. That way, we can provide support & the latest versions and security releases for Java.

## 2.204.4-debian-10-r3

- The Jenkins container has been migrated to a "non-root" user approach. Previously the container ran as the `root` user and the Jenkins service was started as the `jenkins` user. From now on, both the container and the Jenkins service run as user `jenkins` (`uid=1001`). You can revert this behavior by changing `USER 1001` to `USER root` in the Dockerfile.
- Consequences:
  - Backwards compatibility is not guaranteed when data is persisted using docker or docker-compose. We highly recommend migrating your Jenkins data ensuring the `jenkins` user has the appropriate permissions.
  - No "privileged" actions are allowed anymore.

## 2.121.2-ol-7-r14 / 2.121.2-debian-9-r18

- Use Jetty instead of Tomcat as web server.

## 2.107.1-r0

- The Jenkins container has been migrated to the LTS version. From now on, this repository will only track long term support releases from [Jenkins](https://jenkins.io/changelog-stable/).

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-jenkins/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-jenkins/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-jenkins/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright 2015-2021 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
