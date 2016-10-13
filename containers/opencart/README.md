[![Docker Hub Automated Build](http://container.checkforupdates.com/badges/bitnami/opencart)](https://hub.docker.com/r/bitnami/opencart/)
# What is OpenCart?

> OpenCart is a free and open source e-commerce platform for online merchants. It provides a professional and reliable foundation for a successful online store.


http://www.opencart.com/

# Prerequisites

To run this application you need Docker Engine 1.10.0. Docker Compose is recomended with a version 1.6.0 or later.

## Run OpenCart with a Database Container

Running OpenCart with a database server is the recommended way. You can either use docker-compose or run the containers manually.

### Run the application using Docker Compose

This is the recommended way to run OpenCart. You can use the following docker compose template:

```
version: '2'
services:
  mariadb:
    image: 'bitnami/mariadb:latest'
    volumes:
      - 'mariadb_data:/bitnami/mariadb'
  application:
    image: 'bitnami/opencart:latest'
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - 'opencart_data:/bitnami/opencart'
      - 'apache_data:/bitnami/apache'
    depends_on:
      - mariadb
volumes:
  mariadb_data:
    driver: local
  opencart_data:
    driver: local
  apache_data:
    driver: local
```

### Run the application manually

If you want to run the application manually instead of using docker-compose, these are the basic steps you need to run:

1. Create a new network for the application and the database:

  ```
  $ docker network create opencart_network
  ```

2. Start a MariaDB database in the network generated:

  ```
  $ docker run -d --name mariadb --net=opencart_network bitnami/mariadb
  ```

  *Note:* You need to give the container a name in order to OpenCart to resolve the host

3. Run the OpenCart container:

  ```
  $ docker run -d -p 80:80 --name opencart --net=opencart_network bitnami/opencart
  ```

Then you can access the OpenCart storefront at http://your-ip/. To access the administration area, logon to http://your-ip/admin

  *Note:* If you want to access your application from a public IP or hostname you need to configure OpenCart for it. You can handle it adjusting the configuration of the instance by setting the environment variable "OPENCART_HOST" to your public IP or hostname.

## Persisting your application

If you remove every container all your data will be lost, and the next time you run the image the application will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed. If you are using docker-compose your data will be persistent as long as you don't remove `mariadb_data` and `opencart_data` and `apache_data` volumes.

> **Note!** If you have already started using your application, follow the steps on [backing](#backing-up-your-application) up to pull the data from your running container down to your host.

### Mount persistent folders in the host using docker-compose

This requires a sightly modification from the template previously shown:
```
version: '2'

services:
  mariadb:
    image: 'bitnami/mariadb:latest'
    volumes:
      - '/path/to/your/local/mariadb_data:/bitnami/mariadb'
  application:
    image: 'bitnami/opencart:latest'
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - '/path/to/your/local/opencart_data:/bitnami/opencart'
      - '/path/to/your/local/apache_data:/bitnami/apache'
    depends_on:
      - mariadb
```

### Mount persistent folders manually

In this case you need to specify the directories to mount on the run command. The process is the same than the one previously shown:

1. If you haven't done this before, create a new network for the application and the database:

  ```
  $ docker network create opencart_network
  ```

2. Start a MariaDB database in the previous network:

  ```
  $ docker run -d --name mariadb -v /your/local/path/bitnami/mariadb/data:/bitnami/mariadb/data -v /your/local/path/bitnami/mariadb/conf:/bitnami/mariadb/conf --network=opencart_network bitnami/mariadb
  ```

  *Note:* You need to give the container a name in order to OpenCart to resolve the host

3. Run the OpenCart container:

  ```
  $ docker run -d -p 80:80 --name opencart -v /your/local/path/bitnami/opencart:/bitnami/opencart --network=opencart_network bitnami/opencart
  ```

# Upgrade this application

Bitnami provides up-to-date versions of MariaDB and OpenCart, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the OpenCart container. For the MariaDB upgrade see https://github.com/bitnami/bitnami-docker-mariadb/blob/master/README.md#upgrade-this-image

1. Get the updated images:

  ```
  $ docker pull bitnami/opencart:latest
  ```

2. Stop your container

 * For docker-compose: `$ docker-compose stop opencart`
 * For manual execution: `$ docker stop opencart`

3. (For non-compose execution only) Create a [backup](#backing-up-your-application) if you have not mounted the opencart folder in the host.

4. Remove the currently running container

 * For docker-compose: `$ docker-compose rm -v opencart`
 * For manual execution: `$ docker rm -v opencart`

5. Run the new image

 * For docker-compose: `$ docker-compose start opencart`
 * For manual execution ([mount](#mount-persistent-folders-manually) the directories if needed): `docker run --name opencart bitnami/opencart:latest`

# Configuration
## Environment variables
 When you start the opencart image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the docker run command line. If you want to add a new environment variable:

 * For docker-compose add the variable name and value under the application section:
```
application:
  image: bitnami/opencart:latest
  ports:
    - 80:80
    - 443:443
  environment:
    - OPENCART_HOST=your_host
  volumes:
      - opencart_data:/bitnami/opencart
      - apache_data:/bitnami/apache
      - php_data:/bitnami/php
```

 * For manual execution add a `-e` option with each variable and value:

```
 $ docker run -d -e OPENCART_PASSWORD=my_password -p 80:80 --name opencart -v /your/local/path/bitnami/opencart:/bitnami/opencart --network=opencart_network bitnami/opencart
```

Available variables:

 - `OPENCART_USER_NAME`: OpenCart application User's First Name. Default: **user**
 - `OPENCART_PASSWORD`: OpenCart application password. Default: **bitnami1**
 - `OPENCART_EMAIL`: OpenCart application email. Default: **user@example.com**
 - `OPENCART_HOST`: OpenCart Host Server.
 - `MARIADB_PASSWORD`: Root password for the MariaDB.
 - `MARIADB_HOST`: Hostname for MariaDB server. Default: **mariadb**
 - `MARIADB_PORT`: Port used by MariaDB server. Default: **3306**


## SMTP Configuration

To configure OpenCart to send email using SMTP you can set the following environment variables:
 - `SMTP_HOST`: SMTP host.
 - `SMTP_PORT`: SMTP port.
 - `SMTP_USER`: SMTP account user.
 - `SMTP_PASSWORD`: SMTP account password.
 - `SMTP_PROTOCOL`: SMTP protocol.

This would be an example of SMTP configuration using a GMail account:

 * docker-compose:

```
  application:
    image: bitnami/opencart:latest
    ports:
      - 80:80
    environment:
      - SMTP_HOST=smtp.gmail.com
      - SMTP_PORT=587
      - SMTP_USER=your_email@gmail.com
      - SMTP_PASSWORD=your_password
```

 * For manual execution:

```
 $ docker run -d -e SMTP_HOST=smtp.gmail.com -e SMTP_PORT=587 -e SMTP_USER=your_email@gmail.com -e SMTP_PASSWORD=your_password -p 80:80 --name opencart -v /your/local/path/bitnami/opencart:/bitnami/opencart --net=opencart_network bitnami/opencart

# Backing up your application

To backup your application data follow these steps:

1. Stop the running container:

* For docker-compose: `$ docker-compose stop opencart`
* For manual execution: `$ docker stop opencart`

2. Copy the OpenCart data folder in the host:

```
$ docker cp /your/local/path/bitnami:/bitnami/opencart
```

# Restoring a backup

To restore your application using backed up data simply mount the folder with OpenCart data in the container. See [persisting your application](#persisting-your-application) section for more info.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an
[issue](https://github.com/bitnami/bitnami-docker-opencart/issues), or submit a
[pull request](https://github.com/bitnami/bitnami-docker-opencart/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an
[issue](https://github.com/bitnami/bitnami-docker-opencart/issues). For us to provide better support,
be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive
information)

# License

Copyright 2016 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
