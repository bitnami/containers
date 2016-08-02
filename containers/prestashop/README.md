# What is PrestaShop?

> PrestaShop is a popular open source ecommerce solution. Professional tools are easily accessible to increase online sales including instant guest checkout, abandoned cart reminders and automated Email marketing.

http://www.prestashop.com

# Prerequisites

To run this application you need Docker Engine 1.10.0. Docker Compose is recomended with a version 1.6.0 or later.

## Run PrestaShop with a Database Container

Running PrestaShop with a database server is the recommended way. You can either use docker-compose or run the containers manually.

### Run the application using Docker Compose

This is the recommended way to run PrestaShop. You can use the following docker compose template:

```
version: '2'
services:
  mariadb:
    image: 'bitnami/mariadb:latest'
    volumes:
      - 'mariadb_data:/bitnami/mariadb'
  application:
    image: 'bitnami/prestashop:latest'
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - 'prestashop_data:/bitnami/prestashop'
      - 'apache_data:/bitnami/apache'
    depends_on:
      - mariadb
volumes:
  mariadb_data:
    driver: local
  prestashop_data:
    driver: local
  apache_data:
    driver: local
```

### Run the application manually

If you want to run the application manually instead of using docker-compose, these are the basic steps you need to run:

1. Create a new network for the application and the database:

  ```
  $ docker network create prestashop_network
  ```

2. Start a MariaDB database in the network generated:

  ```
  $ docker run -d --name mariadb --net=prestashop_network bitnami/mariadb
  ```

  *Note:* You need to give the container a name in order to PrestaShop to resolve the host

3. Run the PrestaShop container:

  ```
  $ docker run -d -p 80:80 --name prestashop --net=prestashop_network bitnami/prestashop
  ```

Then you can access your application at http://your-ip/

  *Note:* If you want to access your application from a public IP or hostname you need to configure PrestaShop for it. You can handle it adjusting the configuration of the instance by setting the environment variable "PRESTASHOP_HOST" to your public IP or hostname.

## Persisting your application

If you remove every container all your data will be lost, and the next time you run the image the application will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed. If you are using docker-compose your data will be persistent as long as you don't remove `mariadb_data` and `prestashop_data` and `apache_data` volumes. 

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
    image: 'bitnami/prestashop:latest'
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - '/path/to/your/local/prestashop_data:/bitnami/prestashop'
      - '/path/to/your/local/apache_data:/bitnami/apache'
    depends_on:
      - mariadb
```

### Mount persistent folders manually

In this case you need to specify the directories to mount on the run command. The process is the same than the one previously shown:

1. If you haven't done this before, create a new network for the application and the database:

  ```
  $ docker network create prestashop_network
  ```

2. Start a MariaDB database in the previous network:

  ```
  $ docker run -d --name mariadb -v /your/local/path/bitnami/mariadb/data:/bitnami/mariadb/data -v /your/local/path/bitnami/mariadb/conf:/bitnami/mariadb/conf --network=prestashop_network bitnami/mariadb
  ```

  *Note:* You need to give the container a name in order to PrestaShop to resolve the host

3. Run the PrestaShop container:

  ```
  $ docker run -d -p 80:80 --name prestashop -v /your/local/path/bitnami/prestashop:/bitnami/prestashop --network=prestashop_network bitnami/prestashop
  ```

# Upgrade this application

Bitnami provides up-to-date versions of MariaDB and PrestaShop, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the PrestaShop container. For the MariaDB upgrade see https://github.com/bitnami/bitnami-docker-mariadb/blob/master/README.md#upgrade-this-image

1. Get the updated images:

```
$ docker pull bitnami/prestashop:latest
```

2. Stop your container

 * For docker-compose: `$ docker-compose stop prestashop`
 * For manual execution: `$ docker stop prestashop`

3. (For non-compose execution only) Create a [backup](#backing-up-your-application) if you have not mounted the prestashop folder in the host.

4. Remove the currently running container

 * For docker-compose: `$ docker-compose rm -v prestashop`
 * For manual execution: `$ docker rm -v prestashop`

5. Run the new image

 * For docker-compose: `$ docker-compose start prestashop`
 * For manual execution ([mount](#mount-persistent-folders-manually) the directories if needed): `docker run --name prestashop bitnami/prestashop:latest`

# Configuration
## Environment variables
 When you start the prestashop image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the docker run command line. If you want to add a new environment variable:

 * For docker-compose add the variable name and value under the application section:
```
application:
  image: bitnami/prestashop:latest
  ports:
    - 80:80
    - 443:443
  environment:
    - PRESTASHOP_HOST=your_host
  volumes:
      - prestashop_data:/bitnami/prestashop
      - apache_data:/bitnami/apache
      - php_data:/bitnami/php
```

 * For manual execution add a `-e` option with each variable and value:

```
 $ docker run -d -e PRESTASHOP_PASSWORD=my_password -p 80:80 --name prestashop -v /your/local/path/bitnami/prestashop:/bitnami/prestashop --network=prestashop_network bitnami/prestashop
```

Available variables:

 - `APACHE_HTTP_PORT`: Port used by Apache for HTTP. Default: **80**
 - `APACHE_HTTPS_PORT`: Port used by Apache for HTTPS. Default: **443**
 - `PRESTASHOP_FIRST_NAME`: PrestaShop application User's First Name. Default: **User**
 - `PRESTASHOP_LAST_NAME`: PrestaShop application User's Last Name. Default: **Name**
 - `PRESTASHOP_PASSWORD`: PrestaShop application password. Default: **bitnami**
 - `PRESTASHOP_EMAIL`: PrestaShop application email. Default: **user@example.com**
 - `PRESTASHOP_HOST`: PrestaShop Host Server.
 - `MARIADB_PASSWORD`: Root password for the MariaDB.
 - `MARIADB_HOST`: Hostname for MariaDB server. Default: **mariadb**
 - `MARIADB_PORT`: Port used by MariaDB server. Default: **3306**

# Backing up your application

To backup your application data follow these steps:

1. Stop the running container:

* For docker-compose: `$ docker-compose stop prestashop`
* For manual execution: `$ docker stop prestashop`

2. Copy the PrestaShop data folder in the host:

```
$ docker cp /your/local/path/bitnami:/bitnami/prestashop
```

# Restoring a backup

To restore your application using backed up data simply mount the folder with PrestaShop data in the container. See [persisting your application](#persisting-your-application) section for more info.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an
[issue](https://github.com/bitnami/prestashop/issues), or submit a
[pull request](https://github.com/bitnami/prestashop/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an
[issue](https://github.com/bitnami/prestashop/issues). For us to provide better support,
be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_APP_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive
information)

# License

Copyright (c) 2016 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
