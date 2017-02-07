# What is Piwik?

> Piwik is a free and open source web analytics application written by a team of international developers that runs on a PHP/MySQL webserver. It tracks online visits to one or more websites and displays reports on these visits for analysis. As of September 2015, Piwik was used by nearly 900 thousand websites, or 1.3% of all websites, and has been translated to more than 45 languages. New versions are regularly released every few weeks.

https://www.piwik.org/

# TL;DR;
```bash
$ curl -LO https://raw.githubusercontent.com/bitnami/bitnami-docker-piwik/master/docker-compose.yml
$ docker-compose up
```

# Prerequisites

To run this application you need Docker Engine 1.10.0. Docker Compose is recommended with a version 1.6.0 or later.


# How to get this image
The recommended way to get the Bitnami Piwik Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/piwik/).
To use a specific version, you can pull a versioned tag. Find the [list of available versions] (https://hub.docker.com/r/bitnami/piwik/tags/) in the Docker Hub Registry.

```bash
docker pull bitnami/piwik:[TAG]
```
If you wish, you can also build the image youself.

```bash
docker build -t bitnami/piwik:latest https://github.com/bitnami/bitnami-docker-piwik.git
```

# How to use this image
Piwik requires access to a MySQL database or MariaDB database to store information. It uses our [MariaDB image] (https://github.com/bitnami/bitnami-docker-mariadb) for the database requirements.

## Run the Piwik image using Docker Compose

This is the recommended way to run Piwik. You can use the following docker compose template:

```
version: '2'

services:
  mariadb:
    image: 'bitnami/mariadb:latest'
    volumes:
      - 'mariadb_data:/bitnami/mariadb'
  application:
    image: 'bitnami/piwik:latest'
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - 'piwik_data:/bitnami/piwik'
      - 'php_data:/bitnami/php'
      - 'apache_data:/bitnami/apache'
    depends_on:
      - mariadb

volumes:
  mariadb_data:
    driver: local
  piwik_data:
    driver: local
  apache_data:
    driver: local
```

## Run the Piwik image using the Docker Command Line

If you want to run the application manually instead of using docker-compose, these are the basic steps you need to run:

1. Create a new network for the application and the database:

  ```
  $ docker network create piwik_network
  ```

2. Start a MariaDB database in the network generated:

  ```
   $ docker run -d --name mariadb --net=piwik_network bitnami/mariadb
  ```

  *Note:* You need to give the container a name in order to Piwik to resolve the host

3. Run the Piwik container:

  ```
  $ docker run -d -p 80:80 --name piwik --net=piwik_network bitnami/piwik
  ```

Then you can access your application at http://your-ip/

## Persisting your application

If you remove every container and volume all your data will be lost, and the next time you run the image the application will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

If you are using docker-compose your data will be persistent as long as you don't remove `mariadb_data`, `piwik_data` and `apache_data` volumes.

To avoid inadvertent removal of these volumes you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

> **Note!** If you have already started using your application, follow the steps on [backing](#backing-up-your-application) up to pull the data from your running container down to your host.

### Mount host directories as data volumes with Docker Compose

This requires a minor change to the `docker-compose.yml` template previously shown:

```
version: '2'

services:
  mariadb:
    image: 'bitnami/mariadb:latest'
    volumes:
      - '/path/to/your/local/mariadb_data:/bitnami/mariadb'
  piwik:
    image: 'bitnami/piwik:latest'
    depends_on:
      - mariadb
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - '/path/to/piwik-persistence:/bitnami/piwik'
      - '/path/to/php-persistence:/bitnami/php'
      - '/path/to/apache-persistence:/bitnami/apache'
```

### Mount host directories as data volumes using the Docker command line

In this case you need to specify the directories to mount on the run command. The process is the same than the one previously shown:

1. Create a network (if it does not exist):

  ```
  $ docker network create piwik-tier
  ```

2. Create a MariaDB container with host volume:

  ```
  $$ docker run -d --name mariadb \
    --net piwik-tier \
    --volume /path/to/mariadb-persistence:/bitnami/mariadb \
    bitnami/mariadb:latest
  ```
   *Note:* You need to give the container a name in order to Piwik to resolve the host

3. Create the Piwik container with host volumes:

  ```
  $ docker run -d --name piwik -p 80:80 -p 443:443 \
    --net piwik-tier \
    --volume /path/to/piwik-persistence:/bitnami/piwik \
    --volume /path/to/apache-persistence:/bitnami/apache \
    --volume /path/to/php-persistence:/bitnami/php \
    bitnami/piwik:latest
  ```

# Upgrading Piwik

Bitnami provides up-to-date versions of MariaDB and Piwik, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the Piwik container. For the MariaDB upgrade you can take a look at https://github.com/bitnami/bitnami-docker-mariadb/blob/master/README.md#upgrade-this-image

1. Get the updated images:

  ```
  $ docker pull bitnami/piwik:latest
  ```

2. Stop your container

 * For docker-compose: `$ docker-compose stop piwik`
 * For manual execution: `$ docker stop piwik`

3. (For non-compose execution only) Create a [backup](#backing-up-your-application) if you have not mounted the piwik folder in the host.

4. Remove the currently running container

 * For docker-compose: `$ docker-compose rm -v piwik`
 * For manual execution: `$ docker rm -v piwik`

5. Run the new image

 * For docker-compose: `$ docker-compose start piwik`
 * For manual execution ([mount](#mount-persistent-folders-manually) the directories if needed): `docker run --name piwik bitnami/piwik:latest`

# Configuration
## Environment variables
 When you start the Piwik image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the docker run command line. If you want to add a new environment variable:

 * For docker-compose add the variable name and value under the application section:

```
application:
  image: bitnami/piwik:latest
  ports:
    - 80:80
  environment:
    - PIWIK_PASSWORD=my_password
  volumes_from:
    - application_data
```

 * For manual execution add a `-e` option with each variable and value:

```
 $ docker run -d -e PIWIK_PASSWORD=my_password -p 80:80 --name piwik -v /your/local/path/bitnami/piwik:/bitnami/piwik --net=piwik_network bitnami/piwik
```

Available variables:

 - `PIWIK_USERNAME`: Piwik application username. Default: **User**
 - `PIWIK_HOST`: Piwik application host. Default: **127.0.0.1**
 - `PIWIK_PASSWORD`: Piwik application password. Default: **bitnami**
 - `PIWIK_EMAIL`: Piwik application email. Default: **user@example.com**
 - `PIWIK_WEBSITE_NAME`: Name of a website to track in Piwik. Default: **example**
 - `PIWIK_WEBSITE_HOST`: Website's host or domain to track in Piwik. Default: **https://example.org**
 - `MARIADB_USER`: Root user for the MariaDB database. Default: **root**
 - `MARIADB_PASSWORD`: Root password for the MariaDB.
 - `MARIADB_HOST`: Hostname for MariaDB server. Default: **mariadb**
 - `MARIADB_PORT`: Port used by MariaDB server. Default: **3306**

### SMTP Configuration

To configure Piwik to send email using SMTP you can set the following environment variables:

 - `SMTP_HOST`: Piwik SMTP host.
 - `SMTP_PORT`: Piwik SMTP port.
 - `SMTP_USER`: Piwik SMTP account user.
 - `SMTP_PASSWORD`: Piwik SMTP account password.
 - `SMTP_PROTOCOL`: Piwik SMTP protocol to use.

This would be an example of SMTP configuration using a Gmail account:

 * docker-compose:

```
  application:
    image: bitnami/piwik:latest
    ports:
      - 80:80
    environment:
      - SMTP_HOST=smtp.gmail.com
      - SMTP_USER=your_email@gmail.com
      - SMTP_PASSWORD=your_password
      - SMTP_PROTOCOL=tls
      - SMTP_PORT=587
```

 * For manual execution:

```
 $ docker run -d -e SMTP_HOST=smtp.gmail.com -e SMTP_PROTOCOL=TLS -e SMTP_PORT=587 -e SMTP_USER=your_email@gmail.com -e \
 SMTP_PASSWORD=your_password -p 80:80 --name piwik -v /your/local/path/bitnami/piwik:/bitnami/piwik bitnami/piwik
```

# Backing up your container
To backup your application data follow these steps:
## Back up Piwik using Docker Compose

1. Stop the Piwik container:

  * For docker-compose: `$ docker-compose stop piwik`

2. Copy the Piwik, PHP and Apache data to your backup path:

  ```bash
$ docker cp $(docker-compose ps -q piwik):/bitnami/piwik/ /path/to/backups/piwik/latest/
$ docker cp $(docker-compose ps -q piwik):/bitnami/apache/ /path/to/backups/apache/latest/
$ docker cp $(docker-compose ps -q piwik):/bitnami/php/ /path/to/backups/php/latest/
  ```
3. Start the Piwik container:
```bash
$ docker-compose start piwik
```

## Back up Piwik using the Docker Command Line

1. Stop the Piwik container:
2. Copy the Piwik,PHP and Apache data to your backup path:

```bash
$ docker cp wordpress:/bitnami/piwik/ /path/to/backups/piwik/latest/
$ docker cp wordpress:/bitnami/apache/ /path/to/backups/apache/latest/
$ docker cp wordpress:/bitnami/php/ /path/to/backups/php/latest/

```

3. Start the Piwik container:
```bash
$ docker-compose start piwik
```



# Restoring a backup

To restore your application using backed up data simply mount the folder with Piwik data in the container. See [persisting your application](#persisting-your-application) section for more info.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an
[issue](https://github.com/bitnami/bitnami-docker-piwik/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-piwik/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an
[issue](https://github.com/bitnami/bitnami-docker-piwik/issues). For us to provide better support,
be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive
information)

# License

Copyright (c) 2017 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
