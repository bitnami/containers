# What is JasperServer?

> The JasperReports server can be used as a stand-alone or embedded reporting and BI server that offers web-based reporting, analytic tools and visualization, and a dashboard feature for compiling multiple custom views. JasperReports supports multiple data sources including Hadoop Hive, JSON data sources, Excel, XML/A, Hibernate and more. You can create reports with their WYSIWYG tool and build beautiful visualizations, charts and graphs.

http://community.jaspersoft.com/project/jasperreports-server

# Prerequisites

To run this application you need Docker Engine 1.10.0. Docker Compose is recomended with a version 1.6.0 or later.

# How to use this image

## Run the application using Docker Compose

This is the recommended way to run JasperServer. You can use the following docker compose template:

```
version: '2'

services:
  mariadb:
    image: bitnami/mariadb:latest
    volumes:
      - mariadb_data:/bitnami/mariadb
  jasperserver:
    image: bitnami/jasperserver:latest
    depends_on:
      - mariadb
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - jasperserver_data:/bitnami/jasperserver

volumes:
  mariadb_data:
    driver: local
  jasperserver_data:
    driver: local
```

### Run the application manually

If you want to run the application manually instead of using docker-compose, these are the basic steps you need to run:

1. Create a new network for the application:

  ```
  $ docker network create jasperserver_network
  ```

2. Run the JasperServer container:

  ```
  $ docker run -d -p 80:8080 --name jasperserver --net=jasperserver_network bitnami/jasperserver
  ```

Then you can access your application at http://your-ip/

## Persisting your application

If you remove every container and volume all your data will be lost, and the next time you run the image the application will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed. If you are using docker-compose your data will be persistent as long as you don't remove `application_data` data volume. If you have run the containers manually or you want to mount the folders with persistent data in your host follow the next steps:

> **Note!** If you have already started using your application, follow the steps on [backing](#backing-up-your-application) up to pull the data from your running container down to your host.

### Mount persistent folders in the host using docker-compose

This requires a sightly modification from the template previously shown:
```
version: '2'

services:
  application:
    image: bitnami/jasperserver:latest
    ports:
      - 80:8080
    volumes_from:
      - application_data

  application_data:
    image: bitnami/jasperserver:latest
    volumes:
      - /bitnami/jasperserver
      - /bitnami/tomcat
    entrypoint: 'true'
    mounts:
      - /your/local/path/bitnami/jasperserver:/bitnami/jasperserver
      - /your/local/path/bitnami/tomcat:/bitnami/tomcat
```

### Mount persistent folders manually

In this case you need to specify the directories to mount on the run command. The process is the same than the one previously shown:

1. If you haven't done this before, create a new network for the application:

  ```
  $ docker network create jasperserver_network
  ```

2. Run the JasperServer container:

  ```
  $ docker run -d -p 80:8080 --name jasperserver -v /your/local/path/bitnami/jasperserver:/bitnami/jasperserver --network=jasperserver_network bitnami/jasperserver
  ```

# Upgrade this application

Bitnami provides up-to-date versions of JasperServer, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the JasperServer container.

1. Get the updated images:

```
$ docker pull bitnami/jasperserver:latest
```

2. Stop your container

 * For docker-compose: `$ docker-compose stop jasperserver`
 * For manual execution: `$ docker stop jasperserver`

3. (For non-compose execution only) Create a [backup](#backing-up-your-application) if you have not mounted the jasperserver folder in the host.

4. Remove the currently running container

 * For docker-compose: `$ docker-compose rm -v jasperserver`
 * For manual execution: `$ docker rm -v jasperserver`

5. Run the new image

 * For docker-compose: `$ docker-compose start jasperserver`
 * For manual execution ([mount](#mount-persistent-folders-manually) the directories if needed): `docker run --name jasperserver bitnami/jasperserver:latest`

# Configuration
## Environment variables
 When you start the jasperserver image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the docker run command line. If you want to add a new environment variable:

 * For docker-compose add the variable name and value under the application section:
```
application:
  image: bitnami/jasperserver:latest
  ports:
    - 80:8080
  environment:
    - JASPERSERVER_PASSWORD=my_password
  volumes_from:
    - application_data
```

 * For manual execution add a `-e` option with each variable and value:

```
 $ docker run -d -e JASPERSERVER_PASSWORD=my_password -p 80:8080 --name jasperserver -v /your/local/path/bitnami/jasperserver:/bitnami/jasperserver --network=jasperserver_network bitnami/jasperserver
```

Available variables:

 - `JASPERSERVER_USERNAME`: JasperServer admin username. Default: **user**
 - `JASPERSERVER_PASSWORD`: JasperServer admin password. Default: **bitnami**

### SMTP Configuration

To configure JasperServer to send email using SMTP you can set the following environment variables:
 - `SMTP_HOST`: SMTP host.
 - `SMTP_PORT`: SMTP port.
 - `SMTP_USER`: SMTP account user.
 - `SMTP_PASSWORD`: SMTP account password.
 - `SMTP_PROTOCOL`: SMTP protocol.

This would be an example of SMTP configuration using a GMail account:

 * docker-compose:

```
  application:
    image: bitnami/jasperserver:latest
    ports:
      - 80:80
    environment:
      - SMTP_HOST=smtp.gmail.com
      - SMTP_PORT=587
      - SMTP_USER=your_email@gmail.com
      - SMTP_PASSWORD=your_password
    volumes_from:
      - application_data
```

 * For manual execution:

```
 $ docker run -d -e SMTP_HOST=smtp.gmail.com -e SMTP_PORT=587 -e SMTP_USER=your_email@gmail.com -e SMTP_PASSWORD=your_password -p 80:80 --name jasperserver -v /your/local/path/bitnami/jasperserver:/bitnami/jasperserver --net=jasperserver_network bitnami/jasperserver
```

# Backing up your application

To backup your application data follow these steps:

1. Stop the running container:
* For docker-compose: `$ docker-compose stop jasperserver`
* For manual execution: `$ docker stop jasperserver`

2. Copy the JasperServer data folder in the host:

```
$ docker cp /your/local/path/bitnami:/bitnami/jasperserver
```

# Restoring a backup

To restore your application using backed up data simply mount the folder with JasperServer data in the container. See [persisting your application](#persisting-your-application) section for more info.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an
[issue](https://github.com/bitnami/jasperserver/issues), or submit a
[pull request](https://github.com/bitnami/jasperserver/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an
[issue](https://github.com/bitnami/jasperserver/issues). For us to provide better support,
be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_APP_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive
information)

# License

Copyright 2016 Bitnami

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
