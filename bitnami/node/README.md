# Bitnami package for Node.js

## What is Node.js?

> Node.js is a runtime environment built on V8 JavaScript engine. Its event-driven, non-blocking I/O model enables the development of fast, scalable, and data-intensive server applications.

[Overview of Node.js](http://nodejs.org/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run -it --name node bitnami/node:latest
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use Node.js in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Only latest stable branch maintained in the free Bitnami catalog

Starting December 10th 2024, only the latest stable branch of any container will receive updates in the free Bitnami catalog. To access up-to-date releases for all upstream-supported branches, consider upgrading to Bitnami Premium. Previous versions already released will not be deleted. They are still available to pull from DockerHub.

Please check the Bitnami Premium page in our partner [Arrow Electronics](https://www.arrow.com/globalecs/na/vendors/bitnami?utm_source=GitHub&utm_medium=containers) for more information.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami Node.js Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/node).

```console
docker pull bitnami/node:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/node/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/node:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Entering the REPL

By default, running this image will drop you into the Node.js REPL, where you can interactively test and try things out in Node.js.

```console
docker run -it --name node bitnami/node
```

**Further Reading:**

* [nodejs.org/api/repl.html](https://nodejs.org/api/repl.html)

## Configuration

### Running your Node.js script

The default work directory for the Node.js image is `/app`. You can mount a folder from your host here that includes your Node.js script, and run it normally using the `node` command.

```console
docker run -it --name node -v /path/to/app:/app bitnami/node \
  node script.js
```

### Running a Node.js app with npm dependencies

If your Node.js app has a `package.json` defining your app's dependencies and start script, you can install the dependencies before running your app.

```console
docker run --rm -v /path/to/app:/app bitnami/node npm install
docker run -it --name node  -v /path/to/app:/app bitnami/node npm start
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/node/docker-compose.yml) file present in this repository:

```yaml
node:
  ...
  command: "sh -c 'npm install && npm start'"
  volumes:
    - .:/app
  ...
```

**Further Reading:**

* [package.json documentation](https://docs.npmjs.com/files/package.json)
* [npm start script](https://docs.npmjs.com/misc/scripts#default-values)

## Working with private npm modules

To work with npm private modules, it is necessary to be logged into npm. npm CLI uses *auth tokens* for authentication. Check the official [npm documentation](https://www.npmjs.com/package/get-npm-token) for further information about how to obtain the token.

If you are working in a Docker environment, you can inject the token at build time in your Dockerfile by using the ARG parameter as follows:

* Create a `npmrc` file within the project. It contains the instructions for the `npm` command to authenticate against npmjs.org registry. The `NPM_TOKEN` will be taken at build time. The file should look like this:

```console
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

```console
docker build --build-arg NPM_TOKEN=${NPM_TOKEN} .
```

| NOTE: The "." at the end gives `docker build` the current directory as an argument.

Congratulations! You are now logged into the npm repo.

### Further reading

* [npm official documentation](https://docs.npmjs.com/private-modules/docker-and-private-modules).

## Accessing a Node.js app running a web server

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
docker run -it --name node -v /path/to/app:/app -P bitnami/node node index.js
```

Run `docker port` to determine the random port Docker assigned.

```console
$ docker port node
3000/tcp -> 0.0.0.0:32769
```

You can also specify the port you want forwarded from your host to the container.

```console
docker run -it --name node -p 8080:3000 -v /path/to/app:/app bitnami/node node index.js
```

Access your web server in the browser by navigating to `http://localhost:8080`.

## Connecting to other containers

If you want to connect to your Node.js web server inside another container, you can use docker networking to create a network and attach all the containers to that network.

### Serving your Node.js app through an nginx frontend

We may want to make our Node.js web server only accessible via an nginx web server. Doing so will allow us to setup more complex configuration, serve static assets using nginx, load balance to different Node.js instances, etc.

#### Step 1: Create a network

```console
docker network create app-tier --driver bridge
```

#### Step 2: Create a virtual host

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

#### Step 3: Run the Node.js image with a specific name

```console
docker run -it --name myapp --network app-tier \
  -v /path/to/app:/app \
  bitnami/node node index.js
```

#### Step 4: Run the nginx image

```console
docker run -it \
  -v /path/to/vhost.conf:/bitnami/nginx/conf/vhosts/yourapp.conf:ro \
  --network app-tier \
  bitnami/nginx
```

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of Node.js, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/node:latest
```

#### Step 2: Remove the currently running container

```console
docker rm -v node
```

#### Step 3: Run the new image

Re-create your container from the new image.

```console
docker run --name node bitnami/node:latest
```

## Notable Changes

### Starting January 16, 2024

* The `docker-compose.yaml` file has been removed, as it was solely intended for internal testing purposes.

### 6.2.0-r0 (2016-05-11)

* Commands are now executed as the `root` user. Use the `--user` argument to switch to another user or change to the required user using `sudo` to launch applications. Alternatively, as of Docker 1.10 User Namespaces are supported by the docker daemon. Refer to the [daemon user namespace options](https://docs.docker.com/engine/security/userns-remap/) for more details.

### 4.1.2-0 (2015-10-12)

* Permissions fixed so `bitnami` user can install global npm modules without needing `sudo`.

### 4.1.1-0-r01 (2015-10-07)

* `/app` directory is no longer exported as a volume. This caused problems when building on top of the image, since changes in the volume are not persisted between Dockerfile `RUN` instructions. To keep the previous behavior (so that you can mount the volume in another container), create the container with the `-v /app` option.

## Contributing

We'd love for you to contribute to this Docker image. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues) or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/containers/issues/new/choose). For us to provide better support, be sure to fill the issue template.

## License

Copyright &copy; 2025 Broadcom. The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
