# What is Jenkins?

> Jenkins is widely recognized as the most feature-rich CI available with easy configuration, continuous delivery and continuous integration support, easily test, build and stage your app, and more. It supports multiple SCM tools including CVS, Subversion and Git. It can execute Apache Ant and Apache Maven-based projects as well as arbitrary scripts.

https://jenkins.io

# Prerequisites

To run this application you need Docker Engine 1.10.0. Docker Compose is recomended with a version 1.6.0 or later.

# How to use this image

## Run the application using Docker Compose

This is the recommended way to run Jenkins. You can use the following docker compose template:

```
version: '2'

services:
  application:
    build: bitnami/jenkins:latest
    ports:
      - 80:8080
    volumes_from:
      - application_data

  application_data:
    image: bitnami/jenkins:latest
    volumes:
      - /bitnami/jenkins
      - /bitnami/tomcat
    entrypoint: 'true'
```

### Run the application manually

If you want to run the application manually instead of using docker-compose, these are the basic steps you need to run:

1. Create a new network for the application:

  ```
  $ docker network create jenkins_network
  ```

2. Run the Jenkins container:

  ```
  $ docker run -d -p 80:8080 --name jenkins --net=jenkins_network bitnami/jenkins
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
    image: bitnami/jenkins:latest
    ports:
      - 80:8080
    volumes_from:
      - application_data

  application_data:
    image: bitnami/jenkins:latest
    volumes:
      - /bitnami/jenkins
      - /bitnami/tomcat
    entrypoint: 'true'
    mounts:
      - /your/local/path/bitnami/jenkins:/bitnami/jenkins
      - /your/local/path/bitnami/tomcat:/bitnami/tomcat
```

### Mount persistent folders manually

In this case you need to specify the directories to mount on the run command. The process is the same than the one previously shown:

1. If you haven't done this before, create a new network for the application:

  ```
  $ docker network create jenkins_network
  ```

2. Run the Jenkins container:

  ```
  $ docker run -d -p 80:8080 --name jenkins -v /your/local/path/bitnami/jenkins:/bitnami/jenkins --network=jenkins_network bitnami/jenkins
  ```

# Upgrade this application

Bitnami provides up-to-date versions of Jenkins, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container. We will cover here the upgrade of the Jenkins container.

1. Get the updated images:

```
$ docker pull bitnami/jenkins:latest
```

2. Stop your container

 * For docker-compose: `$ docker-compose stop jenkins`
 * For manual execution: `$ docker stop jenkins`

3. (For non-compose execution only) Create a [backup](#backing-up-your-application) if you have not mounted the jenkins folder in the host.

4. Remove the currently running container

 * For docker-compose: `$ docker-compose rm -v jenkins`
 * For manual execution: `$ docker rm -v jenkins`

5. Run the new image

 * For docker-compose: `$ docker-compose start jenkins`
 * For manual execution ([mount](#mount-persistent-folders-manually) the directories if needed): `docker run --name jenkins bitnami/jenkins:latest`

# Configuration
## Environment variables
 When you start the jenkins image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the docker run command line. If you want to add a new environment variable:

 * For docker-compose add the variable name and value under the application section:
```
application:
  image: bitnami/jenkins:latest
  ports:
    - 80:8080
  environment:
    - JENKINS_PASSWORD=my_password
  volumes_from:
    - application_data
```

 * For manual execution add a `-e` option with each variable and value:

```
 $ docker run -d -e JENKINS_PASSWORD=my_password -p 80:8080 --name jenkins -v /your/local/path/bitnami/jenkins:/bitnami/jenkins --network=jenkins_network bitnami/jenkins
```

Available variables:

 - `JENKINS_USERNAME`: Jenkins admin username. Default: **user**
 - `JENKINS_PASSWORD`: Jenkins admin password. Default: **bitnami**

# Backing up your application

To backup your application data follow these steps:

1. Stop the running container:

* For docker-compose: `$ docker-compose stop jenkins`
* For manual execution: `$ docker stop jenkins`

2. Copy the Jenkins data folder in the host:

```
$ docker cp /your/local/path/bitnami:/bitnami/jenkins
```

# Restoring a backup

To restore your application using backed up data simply mount the folder with Jenkins data in the container. See [persisting your application](#persisting-your-application) section for more info.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an
[issue](https://github.com/bitnami/jenkins/issues), or submit a
[pull request](https://github.com/bitnami/jenkins/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an
[issue](https://github.com/bitnami/jenkins/issues). For us to provide better support,
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
