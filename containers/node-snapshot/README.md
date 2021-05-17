# What is Node.js?

> Node.js is a platform built on Chrome's JavaScript runtime for easily building fast, scalable network applications. Node.js uses an event-driven, non-blocking I/O model that makes it lightweight and efficient, perfect for data-intensive real-time applications that run across distributed devices.

[nodejs.org](https://nodejs.org/)

# TL;DR

```console
$ docker run -it --name node bitnami/node-snapshot
```

> **_NOTE:_**  This Node.js "snapshot" container is based on [Debian Snapshot archive](https://snapshot.debian.org/). This archive provides a valuable resource for tracking down when regressions were introduced, or for providing a specific environment that a particular application may require to run. Using a specific snapshot repository allows you to build the container from source at any time and continue using the same system package versions.
> Bitnami also provides containers based on the upstream Debian repository that allows you to rebuild the container and get the latests packages available, see "bitnami-docker-node" repository.

## Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-node-snapshot/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/node-snapshot?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy Node.js in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Node.js Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/node).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`16-prod`, `16-prod-debian-10`, `16.1.0-prod`, `16.1.0-prod-debian-10-r11` (16-prod/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-node-snapshot/blob/16.1.0-prod-debian-10-r11/16-prod/debian-10/Dockerfile)
* [`16`, `16-debian-10`, `16.1.0`, `16.1.0-debian-10-r11` (16/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-node-snapshot/blob/16.1.0-debian-10-r11/16/debian-10/Dockerfile)
* [`15-prod`, `15-prod-debian-10`, `15.14.0-prod`, `15.14.0-prod-debian-10-r41` (15-prod/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-node-snapshot/blob/15.14.0-prod-debian-10-r41/15-prod/debian-10/Dockerfile)
* [`15`, `15-debian-10`, `15.14.0`, `15.14.0-debian-10-r39` (15/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-node-snapshot/blob/15.14.0-debian-10-r39/15/debian-10/Dockerfile)
* [`14-prod`, `14-prod-debian-10`, `14.17.0-prod`, `14.17.0-prod-debian-10-r4` (14-prod/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-node-snapshot/blob/14.17.0-prod-debian-10-r4/14-prod/debian-10/Dockerfile)
* [`14`, `14-debian-10`, `14.17.0`, `14.17.0-debian-10-r4` (14/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-node-snapshot/blob/14.17.0-debian-10-r4/14/debian-10/Dockerfile)
* [`12-prod`, `12-prod-debian-10`, `12.22.1-prod`, `12.22.1-prod-debian-10-r40` (12-prod/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-node-snapshot/blob/12.22.1-prod-debian-10-r40/12-prod/debian-10/Dockerfile)
* [`12`, `12-debian-10`, `12.22.1`, `12.22.1-debian-10-r40`, `latest` (12/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-node-snapshot/blob/12.22.1-debian-10-r40/12/debian-10/Dockerfile)
* [`10-prod`, `10-prod-debian-10`, `10.24.1-prod`, `10.24.1-prod-debian-10-r38` (10-prod/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-node-snapshot/blob/10.24.1-prod-debian-10-r38/10-prod/debian-10/Dockerfile)
* [`10`, `10-debian-10`, `10.24.1`, `10.24.1-debian-10-r40` (10/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-node-snapshot/blob/10.24.1-debian-10-r40/10/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/node-snapshot GitHub repo](https://github.com/bitnami/bitnami-docker-node-snapshot).

# What are `prod` tagged containers for?

Containers tagged `prod` are production containers based on [minideb](https://github.com/bitnami/minideb). They contain the minimal dependencies required by an application to work.

They don't include development dependencies, so they are commonly used in multi-stage builds as the target image. Application code and dependencies should be copied from a different container.

The resultant containers only contain the necessary pieces of software to run the application. Therefore, they are smaller and safer.

Learn how to use multi-stage builds to build your production application container in the [example](/example) directory

# Get this image

The recommended way to get the Bitnami Node.js Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/node-snapshot).

```console
$ docker pull bitnami/node-snapshot:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/node-snapshot/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/node-snapshot:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/node-snapshot 'https://github.com/bitnami/bitnami-docker-node-snapshot.git#master:12/debian-10'
```

# Entering the REPL

By default, running this image will drop you into the Node.js REPL, where you can interactively test and try things out in Node.js.

```console
$ docker run -it --name node bitnami/node-snapshot
```

**Further Reading:**

  - [nodejs.org/api/repl.html](https://nodejs.org/api/repl.html)

# Configuration

## Running your Node.js script

The default work directory for the Node.js image is `/app`. You can mount a folder from your host here that includes your Node.js script, and run it normally using the `node` command.

```console
$ docker run -it --name node -v /path/to/app:/app bitnami/node-snapshot \
  node script.js
```

## Running a Node.js app with npm dependencies

If your Node.js app has a `package.json` defining your app's dependencies and start script, you can install the dependencies before running your app.

```console
$ docker run --rm -v /path/to/app:/app bitnami/node-snapshot npm install
$ docker run -it --name node  -v /path/to/app:/app bitnami/node-snapshot npm start
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-node-snapshot/blob/master/docker-compose.yml) file present in this repository:


```yaml
node:
  ...
  command: "sh -c 'npm install && npm start'"
  volumes:
    - .:/app
  ...
```

**Further Reading:**

- [package.json documentation](https://docs.npmjs.com/files/package.json)
- [npm start script](https://docs.npmjs.com/misc/scripts#default-values)

# Working with private npm modules

To work with npm private modules, it is necessary to be logged into npm. npm CLI uses *auth tokens* for authentication. Check the official [npm documentation](https://www.npmjs.com/package/get-npm-token) for further information about how to obtain the token.

If you are working in a Docker environment, you can inject the token at build time in your Dockerfile by using the ARG parameter as follows:

* Create a `npmrc` file within the project. It contains the instructions for the `npm` command to authenticate against npmjs.org registry. The `NPM_TOKEN` will be taken at build time. The file should look like this:

```console
//registry.npmjs.org/:_authToken=${NPM_TOKEN}
```

* Add some new lines to the Dockerfile in order to copy the `npmrc` file, add the expected `NPM_TOKEN` by using the ARG parameter, and remove the `npmrc` file once the npm install is completed.

You can find the Dockerfile below:

```dockerfile
FROM bitnami/node-snapshot

ARG NPM_TOKEN
COPY npmrc /root/.npmrc

COPY . /app

WORKDIR /app
RUN npm install

CMD node app.js
```

* Now you can build the image using the above Dockerfile and the token. Run the `docker build` command as follows:

```console
$ docker build --build-arg NPM_TOKEN=${NPM_TOKEN} .
```

| NOTE: The "." at the end gives `docker build` the current directory as an argument.

Congratulations! You are now logged into the npm repo.

**Further reading**

- [npm official documentation](https://docs.npmjs.com/private-modules/docker-and-private-modules).

# Accessing a Node.js app running a web server

By default the image exposes the port `3000` of the container. You can use this port for your Node.js application server.

Below is an example of an [express.js](http://expressjs.com/) app listening to remote connections on port `3000`:

```javascript
var express = require('express');
var app = express();

app.get('/', function (req, res) {
  res.send('Hello World!');
});

var server = app.listen(3000, '0.0.0.0', function () {

  var host = server.address().address;
  var port = server.address().port;

  console.log('Example app listening at http://%s:%s', host, port);
});
```

To access your web server from your host machine you can ask Docker to map a random port on your host to port `3000` inside the container.

```console
$ docker run -it --name node -v /path/to/app:/app -P bitnami/node-snapshot node index.js
```

Run `docker port` to determine the random port Docker assigned.

```console
$ docker port node
3000/tcp -> 0.0.0.0:32769
```

You can also specify the port you want forwarded from your host to the container.

```console
$ docker run -it --name node -p 8080:3000 -v /path/to/app:/app bitnami/node-snapshot node index.js
```

Access your web server in the browser by navigating to [http://localhost:8080](http://localhost:8080/).

# Connecting to other containers

If you want to connect to your Node.js web server inside another container, you can use docker networking to create a network and attach all the containers to that network.

## Serving your Node.js app through an nginx frontend

We may want to make our Node.js web server only accessible via an nginx web server. Doing so will allow us to setup more complex configuration, serve static assets using nginx, load balance to different Node.js instances, etc.

### Step 1: Create a network

```console
$ docker network create app-tier --driver bridge
```

or using Docker Compose:

```yaml
version: '2'

networks:
  app-tier:
    driver: bridge
```

### Step 2: Create a virtual host

Let's create an nginx virtual host to reverse proxy to our Node.js container.

```nginx
server {
    listen 0.0.0.0:80;
    server_name yourapp.com;

    location / {
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header HOST $http_host;
        proxy_set_header X-NginX-Proxy true;

        # proxy_pass http://[your_node_container_link_alias]:3000;
        proxy_pass http://myapp:3000;
        proxy_redirect off;
    }
}
```

Notice we've substituted the link alias name `myapp`, we will use the same name when creating the container.

Copy the virtual host above, saving the file somewhere on your host. We will mount it as a volume in our nginx container.

### Step 3: Run the Node.js image with a specific name

```console
$ docker run -it --name myapp --network app-tier \
  -v /path/to/app:/app \
  bitnami/node-snapshot node index.js
```

or using Docker Compose:

```yaml
version: '2'
myapp:
  image: bitnami/node-snapshot
  command: node index.js
  networks:
    - app-tier
  volumes:
    - .:/app
```

### Step 4: Run the nginx image

```console
$ docker run -it \
  -v /path/to/vhost.conf:/bitnami/nginx/conf/vhosts/yourapp.conf:ro \
  --network app-tier \
  bitnami/nginx
```

or using Docker Compose:

```yaml
version: '2'
nginx:
  image: bitnami/nginx
  networks:
    - app-tier
  volumes:
    - /path/to/vhost.conf:/bitnami/nginx/conf/vhosts/yourapp.conf:ro
```

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of Node.js, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```console
$ docker pull bitnami/node-snapshot:latest
```

or if you're using Docker Compose, update the value of the image property to `bitnami/node-snapshot:latest`.

### Step 2: Remove the currently running container

```console
$ docker rm -v node
```

or using Docker Compose:

```console
$ docker-compose rm -v node
```

### Step 3: Run the new image

Re-create your container from the new image.

```console
$ docker run --name node bitnami/node-snapshot:latest
```

or using Docker Compose:

```console
$ docker-compose up node
```

# Branch Deprecation Notice

Node.js's 10 upstream branch will go End-of-Life at the end of April 2021 and has now been internally tagged as to be deprecated. The branch node-snapshot 10 will no longer be released in our catalog a month after this notice is published, but already released container images will still persist in the registries. Valid to be removed starting on: 05-27-2021

# Contributing

We'd love for you to contribute to this Docker image. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-node-snapshot/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-node-snapshot/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-node-snapshot/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive
information)

# License

Copyright (c) 2021 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
