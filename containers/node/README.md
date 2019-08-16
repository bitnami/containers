# What is Node.js?

> Node.js is a platform built on Chrome's JavaScript runtime for easily building fast, scalable network applications. Node.js uses an event-driven, non-blocking I/O model that makes it lightweight and efficient, perfect for data-intensive real-time applications that run across distributed devices.

[nodejs.org](https://nodejs.org/)

# TL;DR;

```bash
$ docker run -it --name node bitnami/node
```

## Docker Compose

```bash
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-node/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DTC)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/node?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy Node.js in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Node.js Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/node).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

# Supported tags and respective `Dockerfile` links

> NOTE: Debian 8 images have been deprecated in favor of Debian 9 images. Bitnami will not longer publish new Docker images based on Debian 8.

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/).


* [`12-ol-7-prod`, `12.8.1-ol-7-r0-prod` (12-prod/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-node/blob/12.8.1-ol-7-r0-prod/12-prod/ol-7/Dockerfile)
* [`12-ol-7`, `12.8.1-ol-7-r0` (12/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-node/blob/12.8.1-ol-7-r0/12/ol-7/Dockerfile)
* [`12-debian-9-prod`, `12.8.1-debian-9-r0-prod`, `12-prod`, `12.8.1-prod`, `12.8.1-r0-prod` (12-prod/debian-9/Dockerfile)](https://github.com/bitnami/bitnami-docker-node/blob/12.8.1-debian-9-r0-prod/12-prod/debian-9/Dockerfile)
* [`12-debian-9`, `12.8.1-debian-9-r0`, `12`, `12.8.1`, `12.8.1-r0` (12/debian-9/Dockerfile)](https://github.com/bitnami/bitnami-docker-node/blob/12.8.1-debian-9-r0/12/debian-9/Dockerfile)
* [`11-ol-7-prod`, `11.15.0-ol-7-r113-prod` (11-prod/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-node/blob/11.15.0-ol-7-r113-prod/11-prod/ol-7/Dockerfile)
* [`11-ol-7`, `11.15.0-ol-7-r110` (11/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-node/blob/11.15.0-ol-7-r110/11/ol-7/Dockerfile)
* [`11-debian-9-prod`, `11.15.0-debian-9-r99-prod`, `11-prod`, `11.15.0-prod`, `11.15.0-r99-prod` (11-prod/debian-9/Dockerfile)](https://github.com/bitnami/bitnami-docker-node/blob/11.15.0-debian-9-r99-prod/11-prod/debian-9/Dockerfile)
* [`11-debian-9`, `11.15.0-debian-9-r99`, `11`, `11.15.0`, `11.15.0-r99` (11/debian-9/Dockerfile)](https://github.com/bitnami/bitnami-docker-node/blob/11.15.0-debian-9-r99/11/debian-9/Dockerfile)
* [`10-photon-3`, `10.16.2-photon-3-r0` (10/photon-3/Dockerfile)](https://github.com/bitnami/bitnami-docker-node/blob/10.16.2-photon-3-r0/10/photon-3/Dockerfile)
* [`10-ol-7-prod`, `10.16.2-ol-7-r9-prod` (10-prod/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-node/blob/10.16.2-ol-7-r9-prod/10-prod/ol-7/Dockerfile)
* [`10-ol-7`, `10.16.2-ol-7-r9` (10/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-node/blob/10.16.2-ol-7-r9/10/ol-7/Dockerfile)
* [`10-debian-9-prod`, `10.16.2-debian-9-r9-prod`, `10-prod`, `10.16.2-prod`, `10.16.2-r9-prod`, `latest-prod` (10-prod/debian-9/Dockerfile)](https://github.com/bitnami/bitnami-docker-node/blob/10.16.2-debian-9-r9-prod/10-prod/debian-9/Dockerfile)
* [`10-debian-9`, `10.16.2-debian-9-r9`, `10`, `10.16.2`, `10.16.2-r9`, `latest` (10/debian-9/Dockerfile)](https://github.com/bitnami/bitnami-docker-node/blob/10.16.2-debian-9-r9/10/debian-9/Dockerfile)
* [`8-ol-7-prod`, `8.16.0-ol-7-r113-prod` (8-prod/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-node/blob/8.16.0-ol-7-r113-prod/8-prod/ol-7/Dockerfile)
* [`8-ol-7`, `8.16.0-ol-7-r112` (8/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-node/blob/8.16.0-ol-7-r112/8/ol-7/Dockerfile)
* [`8-debian-9-prod`, `8.16.0-debian-9-r105-prod`, `8-prod`, `8.16.0-prod`, `8.16.0-r105-prod` (8-prod/debian-9/Dockerfile)](https://github.com/bitnami/bitnami-docker-node/blob/8.16.0-debian-9-r105-prod/8-prod/debian-9/Dockerfile)
* [`8-debian-9`, `8.16.0-debian-9-r105`, `8`, `8.16.0`, `8.16.0-r105` (8/debian-9/Dockerfile)](https://github.com/bitnami/bitnami-docker-node/blob/8.16.0-debian-9-r105/8/debian-9/Dockerfile)
* [`6-ol-7-prod`, `6.17.1-ol-7-r128-prod` (6-prod/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-node/blob/6.17.1-ol-7-r128-prod/6-prod/ol-7/Dockerfile)
* [`6-ol-7`, `6.17.1-ol-7-r126` (6/ol-7/Dockerfile)](https://github.com/bitnami/bitnami-docker-node/blob/6.17.1-ol-7-r126/6/ol-7/Dockerfile)
* [`6-debian-9`, `6.17.1-debian-9-r117`, `6`, `6.17.1`, `6.17.1-r117` (6/debian-9/Dockerfile)](https://github.com/bitnami/bitnami-docker-node/blob/6.17.1-debian-9-r117/6/debian-9/Dockerfile)
* [`6-debian-9-prod`, `6.17.1-debian-9-r116-prod`, `6-prod`, `6.17.1-prod`, `6.17.1-r116-prod` (6-prod/debian-9/Dockerfile)](https://github.com/bitnami/bitnami-docker-node/blob/6.17.1-debian-9-r116-prod/6-prod/debian-9/Dockerfile)

Subscribe to project updates by watching the [bitnami/node GitHub repo](https://github.com/bitnami/bitnami-docker-node).

# What are `prod` tagged containers for?

Containers tagged `prod` are production containers based on [minideb](https://github.com/bitnami/minideb). They contain the minimal dependencies required by an application to work.

They don't include development dependencies, so they are commonly used in multi-stage builds as the target image. Application code and dependencies should be copied from a different container.

The resultant containers only contain the necessary pieces of software to run the application. Therefore, they are smaller and safer.

Learn how to use multi-stage builds to build your production application container in the [example](/example) directory

# Get this image

The recommended way to get the Bitnami Node.js Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/node).

```bash
$ docker pull bitnami/node:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/node/tags/) in the Docker Hub Registry.

```bash
$ docker pull bitnami/node:[TAG]
```

If you wish, you can also build the image yourself.

```bash
$ docker build -t bitnami/node 'https://github.com/bitnami/bitnami-docker-node.git#master:10/debian-9'
```

# Entering the REPL

By default, running this image will drop you into the Node.js REPL, where you can interactively test and try things out in Node.js.

```bash
$ docker run -it --name node bitnami/node
```

**Further Reading:**

  - [nodejs.org/api/repl.html](https://nodejs.org/api/repl.html)

# Configuration

## Running your Node.js script

The default work directory for the Node.js image is `/app`. You can mount a folder from your host here that includes your Node.js script, and run it normally using the `node` command.

```bash
$ docker run -it --name node -v /path/to/app:/app bitnami/node \
  node script.js
```

## Running a Node.js app with npm dependencies

If your Node.js app has a `package.json` defining your app's dependencies and start script, you can install the dependencies before running your app.

```bash
$ docker run --rm -v /path/to/app:/app bitnami/node npm install
$ docker run -it --name node  -v /path/to/app:/app bitnami/node npm start
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-node/blob/master/docker-compose.yml) file present in this repository:


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

```bash
//registry.npmjs.org/:_authToken=${NPM_TOKEN}
```

* Add some new lines to the Dockerfile in order to copy the `npmrc` file, add the expected `NPM_TOKEN` by using the ARG parameter, and remove the `npmrc` file once the npm install is completed.

You can find the Dockerfile below:

```dockerfile
FROM bitnami/node

ARG NPM_TOKEN
COPY npmrc /root/.npmrc

COPY . /app

WORKDIR /app
RUN npm install

CMD node app.js
```

* Now you can build the image using the above Dockerfile and the token. Run the `docker build` command as follows:

```bash
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

```bash
$ docker run -it --name node -v /path/to/app:/app -P bitnami/node node index.js
```

Run `docker port` to determine the random port Docker assigned.

```bash
$ docker port node
3000/tcp -> 0.0.0.0:32769
```

You can also specify the port you want forwarded from your host to the container.

```bash
$ docker run -it --name node -p 8080:3000 -v /path/to/app:/app bitnami/node node index.js
```

Access your web server in the browser by navigating to [http://localhost:8080](http://localhost:8080/).

# Connecting to other containers

If you want to connect to your Node.js web server inside another container, you can use docker networking to create a network and attach all the containers to that network.

## Serving your Node.js app through an nginx frontend

We may want to make our Node.js web server only accessible via an nginx web server. Doing so will allow us to setup more complex configuration, serve static assets using nginx, load balance to different Node.js instances, etc.

### Step 1: Create a network

```bash
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

```bash
$ docker run -it --name myapp --network app-tier \
  -v /path/to/app:/app \
  bitnami/node node index.js
```

or using Docker Compose:

```yaml
version: '2'
myapp:
  image: bitnami/node
  command: node index.js
  networks:
    - app-tier
  volumes:
    - .:/app
```

### Step 4: Run the nginx image

```bash
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

```bash
$ docker pull bitnami/node:latest
```

or if you're using Docker Compose, update the value of the image property to `bitnami/node:latest`.

### Step 2: Remove the currently running container

```bash
$ docker rm -v node
```

or using Docker Compose:

```bash
$ docker-compose rm -v node
```

### Step 3: Run the new image

Re-create your container from the new image.

```bash
$ docker run --name node bitnami/node:latest
```

or using Docker Compose:

```bash
$ docker-compose up node
```

# Notable Changes

## 4.8.4-r1, 6.11.2-r1, 7.10.1-r1 and 8.3.0-r1

- The node container has been migrated to a non-root container approach. Previously the container run as `root`. From now own the container run as user `1001`.

## 6.2.0-r0 (2016-05-11)

- Commands are now executed as the `root` user. Use the `--user` argument to switch to another user or change to the required user using `sudo` to launch applications. Alternatively, as of Docker 1.10 User Namespaces are supported by the docker daemon. Refer to the [daemon user namespace options](https://docs.docker.com/engine/security/userns-remap/) for more details.

## 4.1.2-0 (2015-10-12)

- Permissions fixed so `bitnami` user can install global npm modules without needing `sudo`.

## 4.1.1-0-r01 (2015-10-07)

- `/app` directory is no longer exported as a volume. This caused problems when building on top of the image, since changes in the volume are not persisted between Dockerfile `RUN` instructions. To keep the previous behavior (so that you can mount the volume in another container), create the container with the `-v /app` option.

# Contributing

We'd love for you to contribute to this Docker image. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-node/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-node/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-node/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive
information)

# License

Copyright (c) 2015-2019 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
