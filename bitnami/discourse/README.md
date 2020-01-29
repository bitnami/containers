
# What is Discourse?

> Discourse is the next-generation community forum platform. Discourse has a thoroughly modern design and is written in JavaScript. Page loads are very fast and new content is loaded as the user scrolls down the page. Discourse allows you to create categories, tag posts, manage notifications, create user profiles, and includes features to let communities govern themselves by voting out trolls and spammers. Discourse is built for mobile from the ground up and support high-res devices.

https://www.discourse.org/

# TL;DR;

## Docker Compose

```bash
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-discourse/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

**Note:** The `DISCOURSE_HOSTNAME` environment variable is set to `www.example.com` by default. Please, provide a valid domain name before deploying the solution, or add this domain to your local `hosts` file pointing to `127.0.0.1`.

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DTC)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/discourse?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy Discourse in Kubernetes?

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


* [`2-ol-7`, `2.3.9-ol-7-r6` (2/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-discourse/blob/2.3.9-ol-7-r6/2/ol-7/Dockerfile)
* [`2-debian-10`, `2.3.9-debian-10-r4`, `2`, `2.3.9`, `latest` (2/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-discourse/blob/2.3.9-debian-10-r4/2/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/discourse GitHub repo](https://github.com/bitnami/bitnami-docker-discourse).

# Prerequisites

To run this application you need Docker Engine 1.10.0. Docker Compose is recommended with a version 1.6.0 or later.

# How to use this image

## Run Discourse with a Database Container

Running Discourse with a database server is the recommended way. You can either use docker-compose or run the containers manually.

### Run the application using Docker Compose

The main folder of this repository contains a functional [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-discourse/blob/master/docker-compose.yml) file. Run the application using it as shown below:

```bash
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-discourse/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

### Run the application manually

If you want to run the application manually instead of using docker-compose, these are the basic steps you need to run:

1. Create a new network for the application and the database:

  ```bash
  $ docker network create discourse-tier
  ```

2. Start a Postgresql database in the network generated:

  ```bash
  $ docker run -d --name postgresql --net=discourse-tier bitnami/postgresql
  ```

  *Note:* You need to give the container a name in order to Discourse to resolve the host

3. Start Redis in the network generated:

  ```bash
  $ docker run -d --name redis --net=discourse-tier \
      -e ALLOW_EMPTY_PASSWORD=yes \
      bitnami/redis
  ```

4. Run the Discourse Sidekiq container:

  ```bash
  $ docker run -d -p 80:3000 --name sidekiq --net=discourse-tier \
      bitnami/discourse nami start --foreground discourse-sidekiq
  ```

5. Run the Discourse container:

  ```bash
  $ docker run -d -p 80:3000 --name discourse --net=discourse-tier bitnami/discourse
  ```

Then you can access your application at <http://your-ip/>

## Persisting your application

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a volume at the `/bitnami` path. Additionally you should mount a volume for persistence of the [PostgreSQL](https://github.com/bitnami/bitnami-docker-mariadb#persisting-your-database), [Redis](https://github.com/bitnami/bitnami-docker-redis#persisting-your-database) data.

The above examples define docker volumes namely `postgresql_data`, `redis_data`, `sidekiq_data` and `discourse_data`. The Discourse application state will persist as long as these volumes are not removed.

To avoid inadvertent removal of these volumes you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

### Mount persistent folders in the host using docker-compose

This requires a minor change to the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-discourse/blob/master/docker-compose.yml) file present in this repository:

```yaml
services:
  postgresql:
  ...
    volumes:
      - '/path/to/your/local/postgresql_data:/bitnami/postgresql'
  ...
  redis:
  ...
    volumes:
      - '/path/to/your/local/redis_data:/bitnami'
  ...
  discourse:
  ...
    volumes:
      - '/path/to/discourse-persistence:/bitnami'
  ...
  sidekiq:
  ...
    volumes:
      - '/path/to/sidekiq-persistence:/bitnami'
  ...
```

### Mount persistent folders manually

In this case you need to specify the directories to mount on the run command. The process is the same than the one previously shown:

1. If you haven't done this before, create a new network for the application and the database:

  ```bash
  $ docker network create discourse-tier
  ```

2. Start a Postgresql database in the previous network:

  ```bash
  $ docker run -d --name postgresql \
  --net=discourse-tier \
  --volume /path/to/postgresql-persistence:/bitnami \
  bitnami/postgresql
  ```

3. Start Redis in the previous network as well:

  ```bash
  $ docker run -d --name redis \
  --net=discourse-tier \
   -e ALLOW_EMPTY_PASSWORD=yes \
  --volume /path/to/redis-persistence:/bitnami \
  bitnami/redis
  ```

  *Note:* You need to give the container a name in order for Discourse to resolve the host

4. Start Sidekiq in the previous network as well:

```bash
 $ docker run -d --name sidekiq \
  --net=discourse-tier \
  --volume /path/to/sidekiq-persistence:/bitnami \
  bitnami/discourse nami start --foreground discourse-sidekiq
```

5. Run the Discourse container:

  ```bash
  $ docker run -d --name discourse -p 80:80 \
  --net=discourse-tier \
  --volume /path/to/discourse-persistence:/bitnami \
  bitnami/discourse
  ```

# Upgrade this application

Bitnami provides up-to-date versions of Postgresql and Discourse, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the Discourse container. For the Postgresql upgrade see https://github.com/bitnami/bitnami-docker-postgresql/blob/master/README.md#upgrade-this-image

1. Get the updated images:

  ```bash
  $ docker pull bitnami/discourse:latest
  ```

2. Stop your container

 * For docker-compose: `$ docker-compose stop discourse sidekiq`
 * For manual execution: `$ docker stop discourse sidekiq`

3. Take a snapshot of the application state

```bash
$ rsync -a /path/to/discourse-persistence /path/to/discourse-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
$ rsync -a /path/to/sidekiq-persistence /path/to/sidekiq-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

Additionally, [snapshot the PostgreSQL](https://github.com/bitnami/bitnami-docker-mariadb#step-2-stop-and-backup-the-currently-running-container) and [Redis](https://github.com/bitnami/bitnami-docker-redis#step-2-stop-and-backup-the-currently-running-container) data.

You can use these snapshots to restore the application state should the upgrade fail.

4. Remove the currently running container

 * For docker-compose: `$ docker-compose rm -v discourse sidekiq`
 * For manual execution: `$ docker rm -v discourse sidekiq`

5. Run the new image

 * For docker-compose: `$ docker-compose up discourse sidekiq`
 * For manual execution ([mount](#mount-persistent-folders-manually) the directories if needed): `docker run --name discourse bitnami/discourse:latest`

# Configuration

## Configuration files

You can mount your configuration files to the `/opt/bitnami/discourse/conf` directory.

## Environment variables

When you start the discourse image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the docker run command line. If you want to add a new environment variable:

 * Modify the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-discourse/blob/master/docker-compose.yml) file present in this repository:

```yaml
discourse:
  ...
  environment:
    - DISCOURSE_PASSWORD=bitnami123
  ...
```

 * For manual execution add a `-e` option with each variable and value:

```bash
 $ docker run -d --name discourse -p 80:80 \
 --net=discourse-tier \
 --env DISCOURSE_PASSWORD=bitnami123 \
 --volume discourse_data:/bitnami \
 bitnami/discourse
```

Available variables:

 - `DISCOURSE_USERNAME`: Discourse application username. Default: **user**
 - `DISCOURSE_PASSWORD`: Discourse application password. Default: **bitnami123**
 - `DISCOURSE_EMAIL`: Discourse application email. Default: **user@example.com**
 - `DISCOURSE_SITENAME`: Discourse site name. Default: **My site!**
 - `DISCOURSE_HOSTNAME`: Discourse hostname to create application URLs for features such as email notifications and emojis. It can be either an IP or a domain. Default: **www.example.com**
 - `DISCOURSE_SKIP_INSTALL`: Do not run the Discourse installation wizard. Use only in case you are importing an existing database. Default: **no**
 - `DISCOURSE_PASSENGER_SPAWN_METHOD`: Passenger method used for spawning application processes. Valid values: direct, smart. Default: **direct**
 - `DISCOURSE_PORT_NUMBER`: Port number in which Discourse will run. Default: **3000**
 - `POSTGRESQL_ROOT_USER`: Root user for the Postgresql database. Default: **postgres**
 - `POSTGRESQL_ROOT_PASSWORD`: Root password for Postgresql.
 - `POSTGRESQL_HOST`: Hostname for Postgresql server. Default: **postgresql**
 - `POSTGRESQL_PORT_NUMBER`: Port used by Postgresql server. Default: **5432**
 - `DISCOURSE_POSTGRESQL_USERNAME`: Discourse application database user. Default: **bn_discourse**
 - `DISCOURSE_POSTGRESQL_PASSWORD`: Discourse application database password. Default: **bitnami1**
 - `DISCOURSE_POSTGRESQL_NAME`: Discourse application database name. Default: **bitnami_application**
 - `REDIS_HOST`: Hostname for Redis. Default: **redis**
 - `REDIS_PORT_NUMBER`: Port used by Redis. Default: **6379**
 - `REDIS_PASSWORD`: Password for Redis.

### SMTP Configuration

To configure Discourse to send email using SMTP you can set the following environment variables for both container images, `discourse` and `discourse-sidekiq`:
- `SMTP_HOST`: Host for outgoing SMTP email. No defaults.
- `SMTP_PORT`: Port for outgoing SMTP email. No defaults.
- `SMTP_USER`: User of SMTP used for authentication (likely email). No defaults.
- `SMTP_PASSWORD`: Password for SMTP. No defaults.
- `SMTP_TLS`: Whether use TLS protocol for SMTP or not. Default: **yes**.
- `SMTP_AUTH`: Whether use Authentication for SMTP or not. Default: **login**.

This would be an example of SMTP configuration using a GMail account:

 * Modify the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-discourse/blob/master/docker-compose.yml) file present in this repository:

```yaml
  discourse:
  ...
    environment:
      - SMTP_HOST=smtp.gmail.com
      - SMTP_PORT=587
      - SMTP_USER=your_email@gmail.com
      - SMTP_PASSWORD=your_password
  ...
  sidekiq:
  ...
    environment:
      - SMTP_HOST=smtp.gmail.com
      - SMTP_PORT=587
      - SMTP_USER=your_email@gmail.com
      - SMTP_PASSWORD=your_password
  ...
```

In order to verify your configuration works properly, you can test your configuration parameters from the container itself.

```
docker run -it bitnami/discourse:latest bash
install_packages swaks
swaks --to your_email@domain.com --from your_email@domain.com --server your.smtp.server.com --auth LOGIN --auth-user your_email@domain.com -tls
```

See the [documentation on troubleshooting SMTP issues](https://docs.bitnami.com/general/how-to/troubleshoot-smtp-issues/) if there are problems.

# Notable Changes

## 2.3.2-debian-9-r48 and 2.3.2-ol-7-r47

- The Discourse container now uses Passenger's ['direct' process spawning method](https://www.phusionpassenger.com/docs/advanced_guides/in_depth/ruby/spawn_methods.html) (instead of the default 'smart'), which fixes a bug where settings would randomly revert back to the original values. This setting may cause an increase in memory usage. It is possible to configure the spawning method by setting the `DISCOURSE_PASSENGER_SPAWN_METHOD` environment variable. Related issues: [#107](https://github.com/bitnami/bitnami-docker-discourse/issues/107), [#109](https://github.com/bitnami/bitnami-docker-discourse/issues/109).

## 2.2.5-debian-9-r9 and 2.2.5-ol-7-r8

- It is now possible to import existing Discourse databases from other installations, as requested in [this ticket](https://github.com/bitnami/bitnami-docker-discourse/issues/82). In order to do this, use the environment variable `DISCOURSE_SKIP_INSTALL`, which forces the container not to run the initial Discourse setup wizard.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-discourse/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-discourse/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-discourse/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_APP_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright 2016-2020 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
