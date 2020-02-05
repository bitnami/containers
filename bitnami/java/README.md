# What is Java?

> Java is a general-purpose computer programming language that is concurrent, class-based, object-oriented, and specifically designed to have as few implementation dependencies as possible.

```bash
$ docker run -it --name java bitnami/java
```

## Docker Compose

```bash
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-java/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DTC)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/java?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy Java in Kubernetes?

You can find an example for testing in the file `test.yaml`. To launch this sample file run:

```bash
$ kubectl apply -f test.yaml
```

> NOTE: If you are pulling from a private containers registry, replace the image name with the full URL to the docker image. E.g.
>
> - image: 'your-registry/image-name:your-version'

# Supported tags and respective `Dockerfile` links

> NOTE: Debian 9 images have been deprecated in favor of Debian 10 images. Bitnami will not longer publish new Docker images based on Debian 9.

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/).


- [`13`, `13.0.2-photon-3-r0` (13/photon-3/Dockerfile)](https://github.com/bitnami/bitnami-docker-java/blob/13.0.2-photon-3-r0/13/photon-3/Dockerfile), [`13-prod`, `13.0.2-photon-3-r0-prod` (13/photon-3/prod/Dockerfile)](https://github.com/bitnami/bitnami-docker-java/blob/13.0.2-photon-3-r0/13/photon-3/prod/Dockerfile)
- [`13`, `13.0.2-ol-7-r12` (13/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-java/blob/13.0.2-ol-7-r12/13/ol-7/Dockerfile), [`13-prod`, `13.0.2-ol-7-r12-prod` (13/ol-7/prod/Dockerfile)](https://github.com/bitnami/bitnami-docker-java/blob/13.0.2-ol-7-r12/13/ol-7/prod/Dockerfile)
- [`13`, `13.0.2-ol-7-r11-prod` (13/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-java/blob/13.0.2-ol-7-r11-prod/13/ol-7/Dockerfile), [`13-prod`, `13.0.2-ol-7-r11-prod-prod` (13/ol-7/prod/Dockerfile)](https://github.com/bitnami/bitnami-docker-java/blob/13.0.2-ol-7-r11-prod/13/ol-7/prod/Dockerfile)
- [`13`, `13.0.2-debian-10-r9-prod` (13/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-java/blob/13.0.2-debian-10-r9-prod/13/debian-10/Dockerfile), [`13-prod`, `13.0.2-debian-10-r9-prod-prod` (13/debian-10/prod/Dockerfile)](https://github.com/bitnami/bitnami-docker-java/blob/13.0.2-debian-10-r9-prod/13/debian-10/prod/Dockerfile)
- [`13`, `13.0.2-debian-10-r10` (13/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-java/blob/13.0.2-debian-10-r10/13/debian-10/Dockerfile), [`13-prod`, `13.0.2-debian-10-r10-prod` (13/debian-10/prod/Dockerfile)](https://github.com/bitnami/bitnami-docker-java/blob/13.0.2-debian-10-r10/13/debian-10/prod/Dockerfile)
- [`11`, `11.0.6-photon-3-r0` (11/photon-3/Dockerfile)](https://github.com/bitnami/bitnami-docker-java/blob/11.0.6-photon-3-r0/11/photon-3/Dockerfile), [`11-prod`, `11.0.6-photon-3-r0-prod` (11/photon-3/prod/Dockerfile)](https://github.com/bitnami/bitnami-docker-java/blob/11.0.6-photon-3-r0/11/photon-3/prod/Dockerfile)
- [`11`, `11.0.6-ol-7-r12` (11/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-java/blob/11.0.6-ol-7-r12/11/ol-7/Dockerfile), [`11-prod`, `11.0.6-ol-7-r12-prod` (11/ol-7/prod/Dockerfile)](https://github.com/bitnami/bitnami-docker-java/blob/11.0.6-ol-7-r12/11/ol-7/prod/Dockerfile)
- [`11`, `11.0.6-ol-7-r11-prod` (11/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-java/blob/11.0.6-ol-7-r11-prod/11/ol-7/Dockerfile), [`11-prod`, `11.0.6-ol-7-r11-prod-prod` (11/ol-7/prod/Dockerfile)](https://github.com/bitnami/bitnami-docker-java/blob/11.0.6-ol-7-r11-prod/11/ol-7/prod/Dockerfile)
- [`11`, `11.0.6-debian-10-r9-prod` (11/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-java/blob/11.0.6-debian-10-r9-prod/11/debian-10/Dockerfile), [`11-prod`, `11.0.6-debian-10-r9-prod-prod` (11/debian-10/prod/Dockerfile)](https://github.com/bitnami/bitnami-docker-java/blob/11.0.6-debian-10-r9-prod/11/debian-10/prod/Dockerfile)
- [`11`, `11.0.6-debian-10-r10` (11/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-java/blob/11.0.6-debian-10-r10/11/debian-10/Dockerfile), [`11-prod`, `11.0.6-debian-10-r10-prod` (11/debian-10/prod/Dockerfile)](https://github.com/bitnami/bitnami-docker-java/blob/11.0.6-debian-10-r10/11/debian-10/prod/Dockerfile)
- [`10`, `10.0.2-photon-3-r0` (10/photon-3/Dockerfile)](https://github.com/bitnami/bitnami-docker-java/blob/10.0.2-photon-3-r0/10/photon-3/Dockerfile), [`10-prod`, `10.0.2-photon-3-r0-prod` (10/photon-3/prod/Dockerfile)](https://github.com/bitnami/bitnami-docker-java/blob/10.0.2-photon-3-r0/10/photon-3/prod/Dockerfile)
- [`10`, `10.0.2-ol-7-r0` (10/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-java/blob/10.0.2-ol-7-r0/10/ol-7/Dockerfile), [`10-prod`, `10.0.2-ol-7-r0-prod` (10/ol-7/prod/Dockerfile)](https://github.com/bitnami/bitnami-docker-java/blob/10.0.2-ol-7-r0/10/ol-7/prod/Dockerfile)
- [`10`, `10.0.2-debian-10-r0` (10/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-java/blob/10.0.2-debian-10-r0/10/debian-10/Dockerfile), [`10-prod`, `10.0.2-debian-10-r0-prod` (10/debian-10/prod/Dockerfile)](https://github.com/bitnami/bitnami-docker-java/blob/10.0.2-debian-10-r0/10/debian-10/prod/Dockerfile)
- [`1.9`, `1.9.181-photon-3-r0` (1.9/photon-3/Dockerfile)](https://github.com/bitnami/bitnami-docker-java/blob/1.9.181-photon-3-r0/1.9/photon-3/Dockerfile), [`1.9-prod`, `1.9.181-photon-3-r0-prod` (1.9/photon-3/prod/Dockerfile)](https://github.com/bitnami/bitnami-docker-java/blob/1.9.181-photon-3-r0/1.9/photon-3/prod/Dockerfile)
- [`1.9`, `1.9.181-ol-7-r0` (1.9/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-java/blob/1.9.181-ol-7-r0/1.9/ol-7/Dockerfile), [`1.9-prod`, `1.9.181-ol-7-r0-prod` (1.9/ol-7/prod/Dockerfile)](https://github.com/bitnami/bitnami-docker-java/blob/1.9.181-ol-7-r0/1.9/ol-7/prod/Dockerfile)
- [`1.9`, `1.9.181-debian-10-r0` (1.9/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-java/blob/1.9.181-debian-10-r0/1.9/debian-10/Dockerfile), [`1.9-prod`, `1.9.181-debian-10-r0-prod` (1.9/debian-10/prod/Dockerfile)](https://github.com/bitnami/bitnami-docker-java/blob/1.9.181-debian-10-r0/1.9/debian-10/prod/Dockerfile)
- [`1.8`, `1.8.242-photon-3-r0` (1.8/photon-3/Dockerfile)](https://github.com/bitnami/bitnami-docker-java/blob/1.8.242-photon-3-r0/1.8/photon-3/Dockerfile), [`1.8-prod`, `1.8.242-photon-3-r0-prod` (1.8/photon-3/prod/Dockerfile)](https://github.com/bitnami/bitnami-docker-java/blob/1.8.242-photon-3-r0/1.8/photon-3/prod/Dockerfile)
- [`1.8`, `1.8.242-ol-7-r10-prod` (1.8/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-java/blob/1.8.242-ol-7-r10-prod/1.8/ol-7/Dockerfile), [`1.8-prod`, `1.8.242-ol-7-r10-prod-prod` (1.8/ol-7/prod/Dockerfile)](https://github.com/bitnami/bitnami-docker-java/blob/1.8.242-ol-7-r10-prod/1.8/ol-7/prod/Dockerfile)
- [`1.8`, `1.8.242-ol-7-r10` (1.8/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-java/blob/1.8.242-ol-7-r10/1.8/ol-7/Dockerfile), [`1.8-prod`, `1.8.242-ol-7-r10-prod` (1.8/ol-7/prod/Dockerfile)](https://github.com/bitnami/bitnami-docker-java/blob/1.8.242-ol-7-r10/1.8/ol-7/prod/Dockerfile)
- [`1.8`, `1.8.242-debian-10-r10-prod` (1.8/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-java/blob/1.8.242-debian-10-r10-prod/1.8/debian-10/Dockerfile), [`1.8-prod`, `1.8.242-debian-10-r10-prod-prod` (1.8/debian-10/prod/Dockerfile)](https://github.com/bitnami/bitnami-docker-java/blob/1.8.242-debian-10-r10-prod/1.8/debian-10/prod/Dockerfile)
- [`1.8`, `1.8.242-debian-10-r10` (1.8/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-java/blob/1.8.242-debian-10-r10/1.8/debian-10/Dockerfile), [`1.8-prod`, `1.8.242-debian-10-r10-prod` (1.8/debian-10/prod/Dockerfile)](https://github.com/bitnami/bitnami-docker-java/blob/1.8.242-debian-10-r10/1.8/debian-10/prod/Dockerfile)

Subscribe to project updates by watching the [bitnami/java GitHub repo](https://github.com/bitnami/bitnami-docker-java).

# What are `prod` tagged containers for?

Containers tagged `prod` are production containers based on [minideb](https://github.com/bitnami/minideb). They contain the minimal dependencies required by an application to work.

They don't include development dependencies, so they are commonly used in multi-stage builds as the target image. Application code and dependencies should be copied from a different container.

The resultant containers only contain the necessary pieces of software to run the application. Therefore, they are smaller and safer.

Learn how to use multi-stage builds to build your production application container in the [example](/example) directory

# Get this image

The recommended way to get the Bitnami Java Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/java).

```bash
$ docker pull bitnami/java:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/java/tags/) in the Docker Hub Registry.

```bash
$ docker pull bitnami/java:[TAG]
```

If you wish, you can also build the image yourself.

```bash
$ docker build -t bitnami/java 'https://github.com/bitnami/bitnami-docker-java.git#master:1.8/debian-10'
```

# Configuration

## Running your Java jar or war

The default work directory for the Java image is `/app`. You can mount a folder from your host here that includes your Java jar or war, and run it normally using the `java` command.

```bash
$ docker run -it --name java -v /path/to/app:/app bitnami/java:latest \
  java -jar package.jar
```

or using Docker Compose:

```
java:
  image: bitnami/java:latest
  command: "java -jar package.jar"
  volumes:
    - .:/app
```

**Further Reading:**

  - [Java SE Documentation](https://docs.oracle.com/javase/8/docs/api/)

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of Java, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```bash
$ docker pull bitnami/java:latest
```

or if you're using Docker Compose, update the value of the image property to `bitnami/java:latest`.

### Step 2: Remove the currently running container

```bash
$ docker rm -v java
```

or using Docker Compose:

```bash
$ docker-compose rm -v java
```

### Step 3: Run the new image

Re-create your container from the new image.

```bash
$ docker run --name java bitnami/java:latest
```

or using Docker Compose:

```bash
$ docker-compose up java
```

# Contributing

We'd love for you to contribute to this Docker image. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-java/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-java/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-java/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive
information)

# License

Copyright (c) 2020 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
