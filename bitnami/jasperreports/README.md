[![CircleCI](https://circleci.com/gh/bitnami/bitnami-docker-jasperreports/tree/master.svg?style=shield)](https://circleci.com/gh/bitnami/bitnami-docker-jasperreports/tree/master)
[![Slack](https://img.shields.io/badge/slack-join%20chat%20%E2%86%92-e01563.svg)](http://slack.oss.bitnami.com)
[![Kubectl](https://img.shields.io/badge/kubectl-Available-green.svg)](https://raw.githubusercontent.com/bitnami/bitnami-docker-jasperreports/master/kubernetes.yml)

# What is JasperReports?

> The JasperReports server can be used as a stand-alone or embedded reporting and BI server that offers web-based reporting, analytic tools and visualization, and a dashboard feature for compiling multiple custom views. JasperReports supports multiple data sources including Hadoop Hive, JSON data sources, Excel, XML/A, Hibernate and more. You can create reports with their WYSIWYG tool and build beautiful visualizations, charts and graphs.

http://community.jaspersoft.com/project/jasperreports-server

# TL;DR;

## Docker Compose

```bash
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-jasperreports/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

## Kubernetes

> **WARNING:** This is a beta configuration, currently unsupported.

Get the raw URL pointing to the kubernetes.yml manifest and use kubectl to create the resources on your Kubernetes cluster like so:

```bash
$ kubectl create -f https://raw.githubusercontent.com/bitnami/bitnami-docker-jasperreports/master/kubernetes.yml
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* Bitnami images are built on CircleCI and automatically pushed to the Docker Hub.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.

# Prerequisites

To run this application you need Docker Engine 1.10.0. Docker Compose is recomended with a version 1.6.0 or later.

# How to use this image

## Run the application using Docker Compose

This is the recommended way to run JasperReports. You can use the following docker compose template:

```yaml
version: '2'

services:
  mariadb:
    image: 'bitnami/mariadb:latest'
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
    volumes:
      - mariadb_data:/bitnami
  jasperreports:
    image: bitnami/jasperreports:latest
    depends_on:
      - mariadb
    ports:
      - '80:8080'
      - '443:8443'
    volumes:
      - jasperreports_data:/bitnami

volumes:
  mariadb_data:
    driver: local
  jasperreports_data:
    driver: local
```

Then you can access your application at http://your-ip/. Enter bitnami default username and password `user/ bitnami`

## Run the application manually

If you want to run the application manually instead of using docker-compose, these are the basic steps you need to run:

1. Create a new network for the application:

  ```bash
  $ docker network create jasperreports-tier
  ```

2. Run the JasperReports container:

  ```bash
  $ docker run -d -p 80:8080 --name jasperreports --net=jasperreports-tier bitnami/jasperreports
  ```

Then you can access your application at http://your-ip/. Enter bitnami default username and password:
`user/ bitnami`

>**Note!** If you are using **Docker for Windows** (regardless of running the application using Docker compose or manually) you must check the Docker virtual machine IP executing this command:

`docker-machine ip`

This IP address allowing you to access to your application.

## Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a volume at the `/bitnami` path. Additionally you should mount a volume for [persistence of the MariaDB data](https://github.com/bitnami/bitnami-docker-mariadb#persisting-your-database).

The above examples define docker volumes namely `mariadb_data` and `jasperreports_data`. The JasperReports application state will persist as long as these volumes are not removed.

To avoid inadvertent removal of these volumes you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

### Mount host directories as data volumes with Docker Compose

This requires a minor change to the `docker-compose.yml` template previously shown:
```yaml
version: '2'
services:
  mariadb: bitnami/mariadb:latest
  volumes:
    - /path/to/mariadb-persistence:/bitnami
jasperreports:
  image: bitnami/jasperreports:latest
  depends_on:
    - mariadb
  ports:
    - 80:8080
  volumes:
    - /path/to/jasperreports-persistence:/bitnami
```

### Mount persistent folders manually

In this case you need to specify the directories to mount on the run command. The process is the same than the one previously shown:

1. Create a network (if it does not exist):

  ```bash
  $ docker network create jasperreports-tier
  ```

2. Create a MariaDB container with host volume:

  ```bash
  $ docker run -d --name mariadb -e ALLOW_EMPTY_PASSWORD=yes \
    --net jasperreports-tier \
    --volume /path/to/mariadb-persistence:/bitnami \
   bitnami/mariadb:latest
  ```

3. Create the JasperReports container with host volume:

  ```bash
  $  docker run -d --name jasperreports -p 80:8080 \
    --net jasperreports-tier \
    --volume /path/to/jasperreports-persistence:/bitnami \
    bitnami/jasperreports:latest
  ```

# Upgrade this application

Bitnami provides up-to-date versions of JasperReports, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the JasperReports container.

1. Get the updated images:

  ```bash
  $ docker pull bitnami/jasperreports:latest
  ```

2. Stop your container

  * For docker-compose: `$ docker-compose stop jasperreports`
  * For manual execution: `$ docker stop jasperreports`

3. Take a snapshot of the application state

```bash
$ rsync -a /path/to/jasperreports-persistence /path/to/jasperreports-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

Additionally, [snapshot the MariaDB data](https://github.com/bitnami/bitnami-docker-mariadb#step-2-stop-and-backup-the-currently-running-container)

You can use these snapshots to restore the application state should the upgrade fail.

4. Remove the currently running container

  * For docker-compose: `$ docker-compose rm -v jasperreports`
  * For manual execution: `$ docker rm -v jasperreports`

5. Run the new image

  * For docker-compose: `$ docker-compose start jasperreports`
  * For manual execution ([mount](#mount-persistent-folders-manually) the directories if needed): `docker run --name jasperreports bitnami/jasperreports:latest`

# Configuration

## Environment variables

When you start the jasperreports image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the docker run command line. If you want to add a new environment variable:

 * For docker-compose add the variable name and value under the application section:

  ```yaml
  jasperreports:
    image: bitnami/jasperreports:latest
    ports:
      - 80:8080
    environment:
      - JASPERREPORTS_PASSWORD=my_password
  ```

 * For manual execution add a `-e` option with each variable and value:

  ```bash
  $ docker run -d -e JASPERREPORTS_PASSWORD=my_password -p 80:8080 --name jasperreports -v /your/local/path/bitnami/jasperreports:/bitnami --network=jasperreports-tier bitnami/jasperreports
  ```

Available variables:

 - `JASPERREPORTS_USERNAME`: JasperReports admin username. Default: **user**
 - `JASPERREPORTS_PASSWORD`: JasperReports admin password. Default: **bitnami**
 - `JASPERREPORTS_EMAIL`: JasperReports admin email. Default: **user@example.com**

### SMTP Configuration

To configure JasperReports to send email using SMTP you can set the following environment variables:
 - `SMTP_HOST`: SMTP host.
 - `SMTP_PORT`: SMTP port.
 - `SMTP_EMAIL`: SMTP email.
 - `SMTP_USER`: SMTP account user.
 - `SMTP_PASSWORD`: SMTP account password.
 - `SMTP_PROTOCOL`: SMTP protocol.

This would be an example of SMTP configuration using a GMail account:

 * docker-compose:

```yaml
  jasperreports:
    image: bitnami/jasperreports:latest
    ports:
      - 80:8080
    environment:
      - SMTP_HOST=smtp.gmail.com
      - SMTP_PORT=587
      - SMTP_EMAIL=your_email@gmail.com
      - SMTP_USER=your_email@gmail.com
      - SMTP_PASSWORD=your_password
```

 * For manual execution:

```bash
 $ docker run -d -p 80:8080 --name jasperreports --net=jasperreports-tier \
    -e SMTP_HOST=smtp.gmail.com \
    -e SMTP_PORT=587 \
    -e SMTP_USER=your_email@gmail.com \
    -e SMTP_PASSWORD=your_password \
    -v /your/local/path/bitnami/jasperreports:/bitnami \
    bitnami/jasperreports
```

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-jasperreports/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-jasperreports/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-jasperreports/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# Community

Most real time communication happens in the `#containers` channel at [bitnami-oss.slack.com](http://bitnami-oss.slack.com); you can sign up at [slack.oss.bitnami.com](http://slack.oss.bitnami.com).

Discussions are archived at [bitnami-oss.slackarchive.io](https://bitnami-oss.slackarchive.io).

# License

Copyright 2016-2017 Bitnami

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
