[![Docker Hub Automated Build](http://container.checkforupdates.com/badges/bitnami/laravel)](https://hub.docker.com/r/bitnami/laravel/)

# Laravel Application Development using Bitnami Docker Images

We increasingly see developers adopting two strategies for development. Using a so called “micro services” architecture and using containers for development. At Bitnami, we have developed tools and assets that dramatically lowers the overhead for developing with this approach.

If you’ve never tried to start a project with containers before, or you have tried it and found the advice, tools, and documentation to be chaotic, out of date, or wrong, then this tutorial may be for you.

In this tutorial we walk you through using the Bitnami docker images during the development lifecycle of a Laravel application.

### Eclipse Che Developer Workspace

You can download this repository locally to your computer to start working with the tutorial or just click the link below to automatically create and launch a Laravel on-demand Eclipse Che developer workspace on Codenvy:

[![Contribute](http://beta.codenvy.com/factory/resources/codenvy-contribute.svg)](https://beta.codenvy.com/f/?url=https%3A%2F%2Fgithub.com%2Fbitnami%2Fbitnami-docker-laravel%2Ftree%2Fche)

You can find the configuation files used on the previous link in the [Che branch](https://github.com/bitnami/bitnami-docker-laravel/tree/che). For more information about Eclipse Che workspaces check  the [official documentation](https://eclipse-che.readme.io/docs/introduction)

If you want to start developing locally skip this step and follow the documentation below.

# Why Docker?

We think developers are adopting containers for development because they offer many of the same advantages as developing in VMs, but with lower overhead in terms of developer effort and development machine resources. With Docker, you can create a development environment for your code, and teammates can pull the whole development environment, install it, and quickly get started writing code or fixing bugs.

Docker development environments are more likely to be reproducible than VMs because the definition of each container and how to build it is captured in a Dockerfile.

Docker also has a well known and standard API so tools and cloud services are readily available for docker containers.

# The Bitnami Approach

When we designed and built our development containers, we kept the following guiding principles in mind:

1. Infrastructure should be effort free. By this, we mean, there are certain services in an application that are merely configured. For example, databases and web servers are essential parts of an application, but developers should depend on them like plumbing. They should be there ready to use, but developers should not be forced to waste time and effort creating the plumbing.

2. Production deployment is a late bound decision. Containers are great for development. Sometimes they are great for production, sometimes they are not. If you choose to get started with Bitnami containers for development, it is an easy matter to decide later between monolithic and services architectures, between VMs and Containers, between Cloud and bare metal deployment. This is because Bitnami builds containers specifically with flexibility of production deployment in mind. We ensure that a service running in an immutable and well tested container will behave precisely the same as the same service running in a VM or bare metal.

# Assumptions

First, we assume that you have the following components properly setup:

- [Docker Engine](https://www.docker.com/products/docker-engine)
- [Docker Compose](https://www.docker.com/products/docker-compose)
- [Docker Machine](https://www.docker.com/products/docker-machine)

> The [Docker documentation](https://docs.docker.com/) walks you through installing each of these components.

We also assume that you have some beginner-level experience using these tools.

> **Note**:
>
> If your host OS is Linux you may skip setting up Docker Machine since you'll be able to launch the containers directly in the host OS environment.

Further, we also assume that your application will be using a database. In fact, we assume that it will be using [MariaDB](http://mariadb.org/). Of course, for a real project you may be using a different database, or, in fact, no database. But, this is a common set up and will help you learn the development approach.

## Download the Bitnami Orchestration File for Laravel development

We assume that you're starting the development of the [Laravel](https://laravel.com/) application from scratch. So lets begin by creating a directory for the application source where we'll be bootstrapping a Laravel application:

```bash
$ mkdir ~/workdir/myapp
$ cd ~/workdir/myapp
```

Next, download our Docker Compose orchestration file for Laravel development:

```bash
$ curl -L "https://raw.githubusercontent.com/bitnami/bitnami-docker-laravel/master/docker-compose.yml" > docker-compose.yml
```

> We encourage you to take a look at the contents of the orchestration file to get an idea of the services that will be started for Laravel development.

## Run

Lets put the orchestration file to the test:

```bash
$ docker-compose up
```

This command reads the contents of the orchestration file and begins downloading the Docker images required to launch each of the services listed therein. Depending on the network speeds this can take anywhere from a few seconds to a couple minutes.

After the images have been downloaded, each of the services listed in the orchestration file is started, which in this case are the `mariadb` and `myapp` services.

As mentioned earlier, the `mariadb` service provides a database backend which can be used for the development of a data-driven Laravel application. The service is setup using the [bitnami/mariadb](https://github.com/bitnami/bitnami-docker-mariadb) docker image and is configured with the [default credentials](https://github.com/bitnami/bitnami-docker-mariadb#setting-the-root-password-on-first-run).

The second service thats started is named `myapp` and uses the Bitnami Laravel development image. The service mounts the current working directory (`~/workdir/myapp`) at the `/app` location in the container and provides all the necessary infrastucture to get you started developing a data-driven Laravel application.

Once the artisan server has been started, visit port `3000` of the Docker Machine in your favourite web browser and you'll be greeted by Laravel welcome page.

Lets inspect the contents of the `~/workdir/myapp` directory:

```bash
~/workdir/myapp # ls
app            composer.lock       gulpfile.js   readme.md   tests
artisan        config              package.json  resources   vendor
bootstrap      database            phpunit.xml   server.php
composer.json  docker-compose.yml  public        storage
```

You can see that we have a new Laravel application bootstrapped in the `~/workdir/myapp` directory of the host and is being served by the artisan server running inside the Bitnami Laravel development container.

Since the application source resides on the host, you can use your favourite IDE for developing the application. Only the execution of the application occurs inside the isolated container environment.

That’s all there is to it. Without actually installing a single Laravel component on the host you have a completely isolated and highly reproducible Laravel development environment which can be shared with the rest of the team to get them started building the next big feature without worrying about the plumbing involved in setting up the development environment. Let Bitnami do that for you.

In the next sections we take a look at some of the common tasks that are involved during the development of a Laravel application and how we go about executing those tasks.

## Executing commands

You may recall that we've not installed a single Laravel component on the host and that the entire Laravel development environment is running inside the `myapp` service container. This means that if we wanted to execute [rake](http://guides.rubyonlaravel.org/command_line.html#rake) or any other Laravel command, we'd have to execute it inside the container.

This may sound like a complex task to achieve. But don't worry, Docker Compose makes it very simple to execute tasks inside a service container using the `exec` command. The general form of the command looks something like the following:

```bash
$ docker-compose exec <service> <command>
```

This instructs Docker Compose to execute the command specified by `<command>` inside the service container specified by `<service>`. The return value of the `docker-compose` command will reflect that of the specified command.

With this information lets try listing all `artisan` commands:

```bash
$ docker-compose exec myapp php artisan list
```

Lets try listing all registered routes:

```bash
$ docker-compose exec myapp php artisan route:list
```

Or create a new application controller named `User`:

```bash
$ docker-compose exec myapp php artisan make:controller --resource UserResourceController
```

How about adding a new dependency to the project?

```bash
$ docker-compose exec myapp composer require phpmailer/phpmailer:5.2.*
```

You get the idea..
