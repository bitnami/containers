# Express Application Development using Bitnami Docker Images

We increasingly see developers adopting two strategies for development. Using a so called “micro services” architecture and using containers for development. At Bitnami, we have developed tools and assets that dramatically lowers the overhead for developing with this approach.

If you’ve never tried to start a project with containers before, or you have tried it and found the advice, tools, and documentation to be chaotic, out of date, or wrong, then this tutorial may be for you.

In this tutorial we walk you through using the Bitnami docker images during the development lifecycle of a Ruby on Express application.

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

> **Note**:
> If you are using Linux as your host OS you will not need to setup a Docker Machine

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

Further, we also assume that your application will be using a database. In fact, we assume that it will be using MongoDB. Of course, for a real project you may be using a different database, or, in fact, no database. But, this is a common set up and will help you learn the development approach.

## Create a Docker Machine

> **Note**:
> Skip this section if you are using a Linux host.

We'll begin by creating a new Docker Machine named `express-dev` provisioned using VirtualBox and is where our MongoDB and Express containers will be deployed.

```bash
$ docker-machine create --driver virtualbox express-dev
```

Next, import the Docker Machine environment into your terminal using:

```bash
$ eval $(docker-machine env express-dev)
```

> **Note**
>
> The above command should be executed whenever you create a new terminal to import the Docker Machine environment.

To verify that the Docker Machine up and running, use the following command:

```bash
$ docker info
```

If everything has been setup correctly, the command will query and print status information of the Docker daemon running in the `express-dev` Docker Machine.

## Download a Bitnami Orchestration File

For this tutorial we'll be using the orchestration file for Node + Express.

Begin my creating directory for our Express application source.

```bash
$ mkdir ~/myapp
$ cd ~/myapp
```

Next, download the orchestration file in this directory.

```bash
$ curl -L "https://raw.githubusercontent.com/bitnami/bitnami-docker-express/master/docker-compose.yml" > docker-compose.yml
```

The orchestration file creates a Node + Express service named `myapp`. The service volume mounts the current working directory at the path `/app` of the Express container. If the mounted directory doesn't contain application source, a new Express application will be bootstrapped in this directory, following with the NPM dependencies installation and database setup tasks will be executed before starting the Node server on port `3000`.

The bootstrapped application does not require any database to work but for convenience the orchestration file also includes a MongoDB database ready to be used. You can find an example of how to connect your new Express application to MongoDB in `config/mongodb.js`.


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
$ docker-machine ip express-dev
```

Point your web browser to http://{DOCKER_MACHINE_IP}:3000 to access the Express application.

That’s actually all there is to it. Bitnami has done all the work behind the scenes so that the Docker Compose file “just works” to get you developing your code in a few minutes.

## Code and Test

Let's check the contents of the `~/myapp` directory.

```bash
~/myapp # ls
app.js  config              node_modules  public  views
bin     docker-compose.yml  package.json  routes
```

Yay! As you can see, the Express container bootstrapped a new Express application for us in the current working directory and we can now kickstart our application development.

Lets go ahead and modify the look and feel of the app adding the popular [Twitter Bootstrap](http://getbootstrap.com) library.

1 - Install Bootstrap npm module and restart your application.

```bash
$ docker-compose exec myapp npm install bootstrap --save
$ docker-compose restart
```

2 - Now lets tell Express to serve the Bootstrap CSS files from the `/stylesheets` url.

Using your favorite editor, open `app.js` and add the following line after `var app = express();`

```js
app.use('/stylesheets', express.static(__dirname + '/node_modules/bootstrap/dist/css'));
```

3 - Modify the HTML layout to include the new CSS file

Edit `views/layout.jade` and add the following line below to the `style.css` import.

```HTML
link(rel='stylesheet', href='/stylesheets/bootstrap.min.css')
```

At this point your web app should be using Twitter Bootstrap already, so let's just add some Bootstrap specific HTML markup (jade in this case) to your home page.

4 - Edit `views/index.jade` and replace it for the following code:  

```jade
extends layout

block content
  .container
    .jumbotron
      h1= title
      p My awesome website using Bootstrap CSS
```

And thats it, point your browser to http://{DOCKER_MACHINE_IP}:3000 and you will see that the look and feel has changed.

From the last couple commands, you must have already figured out that commands can be executed inside the `myapp` service container by prefixing the command with `docker-compose exec myapp`.

Similarly,

**To install an npm module in your project**

```bash
$ docker-compose exec myapp npm install [my-module] --save
```

**To see my application logs**

```bash
$ docker-compose logs -f myapp
```

**To restart my application**

```bash
$ docker-compose restart myapp
```

## Connect to a Database

Express by default does not require a database connection to work but we provide a running and configured MongoDB service and an example file `config/mongodb.js` with some insights for how to connect to it.

From this base, you can attach your favorite ODM, i.e [Mongoose](http://mongoosejs.com/) :)
