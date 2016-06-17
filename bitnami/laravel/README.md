# Laravel Application Development using Bitnami Docker Images

We increasingly see developers adopting two strategies for development. Using a so called “micro services” architecture and using containers for development. At Bitnami, we have developed tools and assets that dramatically lowers the overhead for developing with this approach.

If you’ve never tried to start a project with containers before, or you have tried it and found the advice, tools, and documentation to be chaotic, out of date, or wrong, then this tutorial may be for you.

In this tutorial we walk you through using the Bitnami docker images during the development lifecycle of a Ruby on Rails application.

# Why Docker?

We think developers are adopting containers for development because they offer many of the same advantages as developing in VMs, but with lower overhead in terms of developer effort and development machine resources. With Docker, you can create a development environment for your code, and teammates can pull the whole development environment, install it, and quickly get started writing code or fixing bugs.

Docker development environments are more likely to be reproducible than VMs because the definition of each container and how to build it is captured in a dockerfile.

Docker also has a well known and standard API so tools and cloud services are readily available for docker containers.

# The Bitnami Approach

When we designed and built our development containers, we kept a the following guiding principles in mind:

1. Infrastructure should be effort free. By this, we mean, there are certain services in an application that are merely configured. For example, databases and web servers are essential parts of an application, but developers should depend on them like plumbing. They should be there ready to use, but developers should not be forced to waste time and effort creating the plumbing.

2. Production deployment is a late bound decision. Containers are great for development. Sometimes they are great for production, sometimes they are not. If you choose to get started with Bitnami containers for development, it is an easy matter to decide later between monolithic and services architectures, between VMs and Containers, between Cloud and bare metal deployment. This is because Bitnami builds containers specifically with flexibility of production deployment in mind. We ensure that a service running in an immutable and well tested container will behave precisely the same as the same service running in a VM or bare metal.

# Assumptions

Before you start, we are assuming that you have [Docker Engine](https://www.docker.com/products/docker-engine), [Docker Compose](https://www.docker.com/products/docker-compose) and [Docker Machine](https://www.docker.com/products/docker-machine) properly set up.

> Docker Machine also requires a [driver](https://docs.docker.com/machine/drivers/) to create a Docker Machine VM. We'll be using the [virtualbox](https://docs.docker.com/machine/drivers/virtualbox/) driver. Please download and install the latest version of [Oracle VirtualBox](https://www.virtualbox.org).

Open a terminal and try these commands:

```bash
$ docker version
$ docker-compose version
$ docker-machine version
```

The above commands will display the version string for each of the docker components. Additionally since we'll be using VirtualBox to create the Docker Machine VM, you can use the following command to print the version string of VirtualBox:

```bash
$ VBoxManage --version
```

Further, we also assume that your application will be using a database. In fact, we assume that it will be using MariaDB. Of course, for a real project you may be using a different database, or, in fact, no database. But, this is a common set up and will help you learn the development approach.

## Create a Docker Machine

We'll begin by creating a new Docker Machine named `laravel-dev` provisioned using VirtualBox and is where our MariaDB and Laravel containers will be deployed.

```bash
$ docker-machine create --driver virtualbox laravel-dev
```

Next, import the Docker Machine environment into your terminal using:

```bash
$ eval $(docker-machine env laravel-dev)
```

> **Note**
>
> The above command should be executed whenever you create a new terminal to import the Docker Machine environment.

To verify that the Docker Machine up and running, use the following command:

```bash
$ docker info
```

If everything has been setup correctly, the command will query and print status information of the Docker daemon running in the `laravel-dev` Docker Machine.

## Download a Bitnami Orchestration File

We have a collection of Docker Compose orchestration files for various development stacks available at https://github.com/bitnami?utf8=%E2%9C%93&query=docker. For this tutorial we'll be using the orchestration file for Laravel development.

Begin my creating directory for our Rails application source.

```bash
$ mkdir ~/myapp
$ cd ~/myapp
```

Next, download the orchestration file in this directory

```bash
$ curl -L "https://raw.githubusercontent.com/bitnami/bitnami-docker-laravel/master/docker-compose.yml" > docker-compose.yml
```

The orchestration file creates a Laravel service named `myapp`. The service volume mounts the current working directory at the path `/app` of the Laravel container. If the mounted directory doesn't contain application source, a new Laravel application will be bootstraped in this directory, following which the artisan installation and database setup tasks will be executed before starting the artisan server on port `3000`.

Additionally, the orchestration file also creates a service named `mariadb` and is setup as the database backend of our bootstrapped Laravel application.

## Run

Lets put the orchestration file to the test:

```bash
$ docker-compose up -d
```

This command will begin download the Bitnami Docker images and start the services defined in the orchestration file. This process can take a couple of minutes to complete.

> **TIP**
>
> View the container logs using:
>
> ```bash
> docker-compose -f logs
> ```

Get the IP address of the Docker Machine VM using:

```bash
$ docker-machine ip laravel-dev
```

Point your web browser to http://{DOCKER_MACHINE_IP}:3000 to access the laravel application.

That’s actually all there is to it. Bitnami has done all the work behind the scenes so that the Docker Compose file “just works” to get you developing your code in a few minutes.

## Code and Test

Let's check the contents of the `~/myapp` directory.

```bash
~/myapp # ls
Dockerfile         bootstrap          database           phpunit.xml        server.php
README.md          composer.json      docker-compose.yml public             storage
app                composer.lock      gulpfile.js        resources          tests
artisan            config             package.json       rootfs             vendor
```

Yay! As you can see, the Laravel container bootstrapped a new Laravel application for us in the current working directory and we can now kickstart our application development.

Lets go ahead and add a new controller named `User` to our application. We'll use the scaffold method to create it.

```bash
$ docker-compose exec myapp php artisan make:controller --resource UserResourceController
```

From the last command, you must have already figured out that commands can be executed inside the `myapp` service container by prefixing the command with `docker-compose exec myapp`.
