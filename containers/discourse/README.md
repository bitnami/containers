# What is Discourse?

> Discourse is the next-next-generation community forum platform. Discourse has a thoroughly modern design and is written in JavaScript. Page loads are very fast and new content is loaded as the user scrolls down the page. Discourse allows you to create categories, tag posts, manage notifications, create user profiles, and includes features to let communities govern themselves by voting out trolls and spammers. Discourse is built for mobile from the ground up and support high-res devices.

https://www.discourse.org/

# Prerequisites

To run this application you need Docker Engine 1.10.0. Docker Compose is recommended with a version 1.6.0 or later.

# How to use this image

## Run Discourse with a Database Container

Running Discourse with a database server is the recommended way. You can either use docker-compose or run the containers manually.

### Run the application using Docker Compose

This is the recommended way to run Discourse. You can use the following docker compose template:

```yaml
version: '2'

services:
  postgresql:
    image: 'bitnami/postgresql:latest'
    volumes:
      - 'postgresql_data:/bitnami/postgresql'
  redis:
    image: 'bitnami/redis:latest'
    volumes:
      - 'redis_data:/bitnami/redis'
  application:
    image: 'bitnami/discourse:latest'
    ports:
      - '80:3000'
    volumes:
      - 'discourse_data:/bitnami/discourse'
    depends_on:
      - postgresql
      - redis

volumes:
  postgresql_data:
    driver: local
  redis_data:
    driver: local
  discourse_data:
    driver: local
```

Launch the containers using:

```bash
$ docker-compose up -d
```

### Run the application manually

If you want to run the application manually instead of using docker-compose, these are the basic steps you need to run:

1. Create a new network for the application and the database:

  ```
  $ docker network create discourse-tier
  ```

2. Start a Postgresql database in the network generated:

  ```
  $ docker run -d --name postgresql --net=discourse-tier bitnami/postgresql
  ```

  *Note:* You need to give the container a name in order to Discourse to resolve the host

3. Start Redis in the network generated:

  ```
  $ docker run -d --name redis --net=discourse-tier bitnami/redis
  ```

4. Run the Discourse container:

  ```
  $ docker run -d -p 80:3000 --name discourse --net=discourse-tier bitnami/discourse
  ```

Then you can access your application at <http://your-ip/>

## Persisting your application

If you remove every container and volume all your data will be lost, and the next time you run the image the application will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed. If you are using docker-compose your data will be persistent as long as you don't remove `postgresql_data`, `redis_data` and `application_data` data volumes. If you have run the containers manually or you want to mount the folders with persistent data in your host follow the next steps:

> **Note!** If you have already started using your application, follow the steps on [backing](#backing-up-your-application) up to pull the data from your running container down to your host.

### Mount persistent folders in the host using docker-compose

This requires a sightly modification from the template previously shown:
```yaml
version: '2'

services:
  postgresql:
    image: 'bitnami/postgresql:latest'
    volumes:
      - '/path/to/your/local/postgresql_data:/bitnami/postgresql'
  redis:
    image: 'bitnami/redis:latest'
    volumes:
      - '/path/to/your/local/redis_data:/bitnami/redis'
  application:
    image: 'bitnami/discourse:latest'
    ports:
      - '80:3000'
    volumes:
      - '/path/to/discourse-persistence:/bitnami/discourse'
    depends_on:
      - postgresql
      - redis
```

### Mount persistent folders manually

In this case you need to specify the directories to mount on the run command. The process is the same than the one previously shown:

1. If you haven't done this before, create a new network for the application and the database:

  ```
  $ docker network create discourse-tier
  ```

2. Start a Postgresql database in the previous network:

  ```
  $ docker run -d --name postgresql \
  --net=discourse-tier \
  --volume /path/to/postgresql-persistence:/bitnami/postgresql \
  bitnami/postgresql
  ```

3. Start Redis in the previous network as well:

  ```
  $ docker run -d --name redis \
  --net=discourse-tier \
  --volume /path/to/redis-persistence:/bitnami/redis \
  bitnami/redis
  ```

  *Note:* You need to give the container a name in order to Discourse to resolve the host

4. Run the Discourse container:

  ```
  $ docker run -d --name discourse -p 80:80 \
  --net=discourse-tier \
  --volume /path/to/discourse-persistence:/bitnami/discourse \
  bitnami/discourse
  ```

# Upgrade this application

Bitnami provides up-to-date versions of Postgresql and Discourse, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the Discourse container. For the Postgresql upgrade see https://github.com/bitnami/bitnami-docker-postgresql/blob/master/README.md#upgrade-this-image

1. Get the updated images:

  ```
  $ docker pull bitnami/discourse:latest
  ```

2. Stop your container

 * For docker-compose: `$ docker-compose stop discourse`
 * For manual execution: `$ docker stop discourse`

3. (For non-compose execution only) Create a [backup](#backing-up-your-application) if you have not mounted the discourse folder in the host.

4. Remove the currently running container

 * For docker-compose: `$ docker-compose rm -v discourse`
 * For manual execution: `$ docker rm -v discourse`

5. Run the new image

 * For docker-compose: `$ docker-compose start discourse`
 * For manual execution ([mount](#mount-persistent-folders-manually) the directories if needed): `docker run --name discourse bitnami/discourse:latest`

# Configuration
## Environment variables
 When you start the discourse image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the docker run command line. If you want to add a new environment variable:

 * For docker-compose add the variable name and value under the application section:
```yaml
application:
  image: bitnami/discourse:latest
  ports:
    - 80:80
  environment:
    - DISCOURSE_PASSWORD=bitnami
  volumes_from:
    - discourse_data:/bitnami/discourse
```

 * For manual execution add a `-e` option with each variable and value:

```
 $ docker run -d --name discourse -p 80:80 \
 --net=discourse-tier \
 --env DISCOURSE_PASSWORD=bitnami \
 --volume discourse_data:/bitnami/discourse \
 bitnami/discourse
```

Available variables:

 - `DISCOURSE_USERNAME`: Discourse application username. Default: **user**
 - `DISCOURSE_PASSWORD`: Discourse application password. Default: **bitnami1**
 - `DISCOURSE_EMAIL`: Discourse application email. Default: **user@example.com**
 - `DISCOURSE_SITENAME`: Discourse site name. Default: **User's site**
 - `POSTGRES_USER`: Root user for the Postgresql database. Default: **postgres**
 - `POSTGRES_PASSWORD`: Root password for Postgresql.
 - `POSTGRES_MASTER_HOST`: Hostname for Postgresql server. Default: **postgresql**
 - `POSTGRES_MASTER_PORT`: Port used by Postgresql server. Default: **5432**
 - `REDIS_MASTER_HOST`: Hostname for Redis. Default: **redis**
 - `REDIS_MASTER_PORT`: Port used by Redis. Default: **6379**
 - `REDIS_PASSWORD`: Password for Redis.
 - `SMTP_HOST`: Hostname for the SMTP server (necessary for sending e-mails from the application).
 - `SMTP_PORT`: Port for the SMTP server.
 - `SMTP_USER`: Username for the SMTP server.

# Backing up your application

To backup your application data follow these steps:

1. Stop the running container:

  * For docker-compose: `$ docker-compose stop discourse`
  * For manual execution: `$ docker stop discourse`

2. Copy the Discourse data folder in the host:

  ```
  $ docker cp /your/local/path/bitnami:/bitnami/discourse
  ```

# Restoring a backup

To restore your application using backed up data simply mount the folder with Discourse data in the container. See [persisting your application](#persisting-your-application) section for more info.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an
[issue](https://github.com/bitnami/bitnami-docker-discourse/issues), or submit a
[pull request](https://github.com/bitnami/bitnami-docker-discourse/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an
[issue](https://github.com/bitnami/bitnami-docker-discourse/issues). For us to provide better support,
be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_APP_VERSION` inside the container)
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
