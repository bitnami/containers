# What is ReportServer Community ?

> ReportServer is an open source business intelligence (OSBI) platform with powerful reporting and analysis tools. It provides a unified interface to reporting engines from different providers, making it easy for managers to collate, analyze and take action on data from multiple business touchpoints. With support for Jasper, Birt, Mondrian and Excel as well as a powerful ad-hoc reporting component ReportServer is the ideal tool for business decision makers, analysts and consultants. 

https://reportserver.net/en/#secondsection

# TL;DR;

## Docker Compose

```bash
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-reportserver-community/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DTC)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/reportserver-community?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# Supported tags and respective `Dockerfile` links

> NOTE: Debian 9 images have been deprecated in favor of Debian 10 images. Bitnami will not longer publish new Docker images based on Debian 9.

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/).


* [`3-ol-7`, `3.1.1-6020-ol-7-r6` (3/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-reportserver-community/blob/3.1.1-6020-ol-7-r6/3/ol-7/Dockerfile)
* [`3-debian-10`, `3.1.1-6020-debian-10-r6`, `3`, `3.1.1-6020`, `latest` (3/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-reportserver-community/blob/3.1.1-6020-debian-10-r6/3/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/reportserver-community GitHub repo](https://github.com/bitnami/bitnami-docker-reportserver-community).


# Prerequisites

To run this application you need Docker Engine 1.10.0. Docker Compose is recomended with a version 1.6.0 or later.

# How to use this image

## Run the application using Docker Compose

The main folder of this repository contains a functional [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-reportserver-community/blob/master/docker-compose.yml) file. Run the application using it as shown below:

```bash
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-reportserver-community/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

Then you can access your application at http://your-ip/. Enter bitnami default username and password `user/ bitnami`

## Run the application manually

If you want to run the application manually instead of using docker-compose, these are the basic steps you need to run:

1. Create a new network for the application:

  ```bash
  $ docker network create reportserver-tier
  ```

2. Create a volume for MariaDB persistence and create a MariaDB container

  ```bash
  $ docker volume create --name mariadb_data
  $ docker run -d --name mariadb \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e MARIADB_USER=bn_reportserver \
    -e MARIADB_DATABASE=bitnami_reportserver \
    --net reportserver-tier \
    --volume mariadb_data:/bitnami \
    bitnami/mariadb:latest
  ```

3. Launch the container

  ```bash
  $ docker volume create --name reportserver_data
  $ docker run -d --name reportserver-community -p 80:8080 \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e REPORTSERVER_DATABASE_USER=bn_reportserver \
    -e REPORTSERVER_DATABASE_NAME=bitnami_reportserver \
    --net reporserver-tier \
    bitnami/reportserver-community:latest
  ```

Then you can access your application at http://your-ip/. Enter bitnami default username and password:
`user/ bitnami`

>**Note!** If you are using **Docker for Windows** (regardless of running the application using Docker compose or manually) you must check the Docker virtual machine IP executing this command:

`docker-machine ip`

This IP address allowing you to access to your application.

## Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

You should mount a volume for [persistence of the MariaDB data](https://github.com/bitnami/bitnami-docker-mariadb#persisting-your-database).

The above examples define docker volumes namely `mariadb_data`. The Reportserver Community state will persist as long as database is persisted.

To avoid inadvertent removal of these volumes you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.


### Mount persistent folders manually

In this case you need to specify the directories to mount on the run command. The process is the same than the one previously shown:

1. Create a network (if it does not exist):

  ```bash
  $ docker network create reportserver-tier
  ```

2. Create a MariaDB container with host volume:

  ```bash
  $ docker run -d --name mariadb \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e MARIADB_USER=bn_reportserver \
    -e MARIADB_DATABASE=bitnami_reportserver \
    --net reportserver-tier \
    --volume /path/to/mariadb-persistence:/bitnami \
   bitnami/mariadb:latest
  ```

3. Create the Reportserver Community container:

  ```bash
  $  docker run -d --name reportserver-community -p 80:8080 \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e REPORTSERVER_DATABASE_USER=bn_reportserver \
    -e REPORTSERVER_DATABASE_NAME=bitnami_reportserver \
    --net reportserver-tier \
    bitnami/reportserver-community:latest
  ```

# Upgrade this application

Bitnami provides up-to-date versions of Reportserver Community, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the Reportserver Community container.

1. Get the updated images:

  ```bash
  $ docker pull bitnami/reportserver-community:latest
  ```

2. Stop your container

  * For docker-compose: `$ docker-compose stop reportserver-community`
  * For manual execution: `$ docker stop reportserver-community`

3. [snapshot the MariaDB data](https://github.com/bitnami/bitnami-docker-mariadb#step-2-stop-and-backup-the-currently-running-container)

You can use these snapshots to restore the application state should the upgrade fail.

4. Remove the currently running container

  * For docker-compose: `$ docker-compose rm -v reportserver-community`
  * For manual execution: `$ docker rm -v reportserver-community`

5. Run the new image

  * For docker-compose: `$ docker-compose up reportserver-community`
  * For manual execution ([mount](#mount-persistent-folders-manually) the directories if needed): `docker run --name reportserver bitnami/reportserver-community:latest`

# Configuration

## Environment variables

When you start the reportserver-community image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the docker run command line.

##### User and Site configuration

 - `REPORTSERVER_USERNAME`: Reportserver admin username. Default: **user**
 - `REPORTSERVER_PASSWORD`: Reportserver admin password. Default: **bitnami**
 - `REPORTSERVER_EMAIL`: Reportserver admin email. Default: **user@example.com**

##### Use an existing database

- `MARIADB_HOST`: Hostname for MariaDB server. Default: **mariadb**
- `MARIADB_PORT_NUMBER`: Port used by MariaDB server. Default: **3306**
- `REPORTSERVER_DATABASE_NAME`: Database name that Reportserver will use to connect with the database. Default: **bitnami_reportserver**
- `REPORTSERVER_DATABASE_USER`: Database user that Reportserver will use to connect with the database. Default: **bn_reportserver**
- `REPORTSERVER_DATABASE_PASSWORD`: Database password that Reportserver will use to connect with the database. No defaults.
- `ALLOW_EMPTY_PASSWORD`: It can be used to allow blank passwords. Default: **no**

##### Create a database for Reportserver using mysql-client

- `MARIADB_HOST`: Hostname for MariaDB server. Default: **mariadb**
- `MARIADB_PORT_NUMBER`: Port used by MariaDB server. Default: **3306**
- `MARIADB_ROOT_USER`: Database admin user. Default: **root**
- `MARIADB_ROOT_PASSWORD`: Database password for the `MARIADB_ROOT_USER` user. No defaults.
- `MYSQL_CLIENT_CREATE_DATABASE_NAME`: New database to be created by the mysql client module. No defaults.
- `MYSQL_CLIENT_CREATE_DATABASE_USER`: New database user to be created by the mysql client module. No defaults.
- `MYSQL_CLIENT_CREATE_DATABASE_PASSWORD`: Database password for the `MYSQL_CLIENT_CREATE_DATABASE_USER` user. No defaults.
- `ALLOW_EMPTY_PASSWORD`: It can be used to allow blank passwords. Default: **no**

If you want to add a new environment variable:

 * For Docker Compose, add the variable name and value under the application section:

  ```yaml
  reportserver-community:
    environment:
      - REPORTSERVER_PASSWORD=my_password
  ```

 * For manual execution add a `-e` option with each variable and value:

  ```bash
  $ docker run -d -e REPORTSERVER_PASSWORD=my_password -p 80:8080 --name reportserver -v --network=reportserver-tier bitnami/reportserver-community
  ```
### Install demo data

Reportserver brings in demo data that can be autmatically loaded setting the following environment variable:

 - REPORTSERVER_INSTALLDEMODATA=yes

### Setting a passphrase and salt

If set, this passphrase and salt are used to generate the passwords of the Reportserver users in the database. If not, they are ramdonly generated.

 - REPORTSERVER_CRYPTPASSPHRASE="my_passphrase"
 - REPORTSERVER_CRYPTSALT="my_salt" # Maximum 8 characters

### SMTP Configuration

To configure Reportserver Community to send email using SMTP you can set the following environment variables:

 - `SMTP_HOST`: SMTP host.
 - `SMTP_PORT`: SMTP port.
 - `SMTP_EMAIL`: SMTP email.
 - `SMTP_USER`: SMTP account user.
 - `SMTP_PASSWORD`: SMTP account password.
 - `SMTP_SSL_ENABLE`: Enable SSL for SMTP.
 - `SMTP_TLS_ENABLE`: Enable TLS for SMTP.
 - `SMTP_TLS_REQUIRED`: TLS is required for SMTP.

This would be an example of SMTP configuration using a GMail account:

 * Modify the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-reportserver-community/blob/master/docker-compose.yml) file present in this repository:


```yaml
reportserver-community:
  environment:
    - MARIADB_HOST=mariadb
    - MARIADB_PORT_NUMBER=3306
    - REPORTSERVER_DATABASE_USER=bn_reportserver
    - REPORTSERVER_DATABASE_NAME=bitnami_reportserver
    - SMTP_HOST=smtp.gmail.com
    - SMTP_PORT=587
    - SMTP_EMAIL=your_email@gmail.com
    - SMTP_USER=your_email@gmail.com
    - SMTP_PASSWORD=your_password
```

 * For manual execution:

```bash
 $ docker run -d -p 80:8080 --name reportserver-community --net=reportserver-tier \
    -e MARIADB_HOST=mariadb \
    -e MARIADB_PORT_NUMBER=3306 \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e REPORTSERVER_DATABASE_USER=bn_reportserver \
    -e REPORTSERVER_DATABASE_NAME=bitnami_reportserver \
    -e SMTP_HOST=smtp.gmail.com \
    -e SMTP_PORT=587 \
    -e SMTP_USER=your_email@gmail.com \
    -e SMTP_PASSWORD=your_password \
    bitnami/reportserver-community
```

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-reportserver-community/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-reportserver-community/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-reportserver-community/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright 2016-2020 Bitnami

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
