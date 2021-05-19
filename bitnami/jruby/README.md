# What is JRuby?

> JRuby is an implementation of the Ruby language using the JVM.

[https://www.jruby.org/](https://www.jruby.org/)

# TL;DR

```console
$ docker run -it --name jruby bitnami/jruby:latest
```

## Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-jruby/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.

> This [CVE scan report](https://quay.io/repository/bitnami/jruby?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`9.2`, `9.2-debian-10`, `9.2.17-0`, `9.2.17-0-debian-10-r46`, `latest` (9.2/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-jruby/blob/9.2.17-0-debian-10-r46/9.2/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/jruby GitHub repo](https://github.com/bitnami/bitnami-docker-jruby).

# Get this image

The recommended way to get the Bitnami JRuby Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/jruby).

```console
$ docker pull bitnami/jruby:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/jruby/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/jruby:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/jruby:latest 'https://github.com/bitnami/bitnami-docker-jruby.git#master:9.2/debian-10'
```

# Entering the JRuby Interactive Console

By default, running this image will drop you into the JRuby Interactive Console (`jirb`), where you can interactively test and try things out in JRuby.

```console
$ docker run -it --name jruby bitnami/jruby:latest
```

**Further Reading:**

  - [JRuby Interactive Console Documentation](https://github.com/jruby/jruby/wiki/GettingStarted#jirb-ruby-interactive-console)

# Configuration

## Running your Ruby script

The default work directory for the JRuby image is `/app`. You can mount a folder from your host here that includes your Ruby script, and run it normally using the `ruby` command.

```console
$ docker run -it --name jruby -v /path/to/app:/app bitnami/jruby:latest \
  ruby script.rb
```

## Running a Ruby app with gems

If your Ruby app has a `Gemfile` defining your app's dependencies and start script, you can install the dependencies before running your app.

```console
$ docker run -it --name jruby -v /path/to/app:/app bitnami/jruby:latest \
  sh -c "bundle install && jruby script.rb"
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/bitnami-docker-ruby/blob/master/docker-compose.yml) file present in this repository:

```yaml
jruby:
  ...
  command: "sh -c 'bundle install && jruby script.rb'"
  volumes:
    - .:/app
  ...
```

**Further Reading:**

  - [rubygems.org](https://rubygems.org/)
  - [bundler.io](http://bundler.io/)

## Accessing a Ruby app running a web server

This image exposes port `3000` in the container, so you should ensure that your web server is binding to port `3000`, as well as listening on `0.0.0.0` to accept remote connections from your host.

Below is an example of a [Sinatra](http://www.sinatrarb.com/) app listening to remote connections on port `3000`:

```ruby
require 'sinatra'

set :bind, '0.0.0.0'
set :port, 3000

get '/hi' do
  "Hello World!"
end
```

To access your web server from your host machine you can ask Docker to map a random port on your host to port `3000` inside the container.

```console
$ docker run -it --name jruby -P bitnami/jruby:latest
```

Run `docker port` to determine the random port Docker assigned.

```console
$ docker port jruby
3000/tcp -> 0.0.0.0:32769
```

You can also manually specify the port you want forwarded from your host to the container.

```console
$ docker run -it --name jruby -p 8080:3000 bitnami/jruby:latest
```

Access your web server in the browser by navigating to [http://localhost:8080](http://localhost:8080/).

# Connecting to other containers

If you want to connect to your Ruby web server inside another container, you can use Docker networking to create a network and attach all the containers to that network.

## Serving your Ruby app through an nginx frontend

We may want to make our Ruby web server only accessible via an nginx web server. Doing so will allow us to setup more complex configuration, serve static assets using nginx, load balance to different Ruby instances, etc.

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

Let's create an nginx virtual host to reverse proxy to our JRuby container.

```nginx
server {
    listen 0.0.0.0:80;
    server_name yourapp.com;

    location / {
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header HOST $http_host;
        proxy_set_header X-NginX-Proxy true;

        # proxy_pass http://[your_jruby_container_link_alias]:3000;
        proxy_pass http://myapp:3000;
        proxy_redirect off;
    }
}
```

Notice we've substituted the link alias name `myapp`, we will use the same name when creating the container.

Copy the virtual host above, saving the file somewhere on your host. We will mount it as a volume in our nginx container.

### Step 3: Run the JRuby image with a specific name

```console
$ docker run -it --name myapp \
  --network app-tier \
  -v /path/to/app:/app \
  bitnami/jruby:latest jruby script.rb
```

or using Docker Compose:

```yaml
version: '2'
myapp:
  image: bitnami/jruby:latest
  command: jruby script.rb
  networks:
    - app-tier
  volumes:
    - .:/app
```

### Step 4: Run the nginx image

```console
$ docker run -it \
  -v /path/to/vhost.conf:/bitnami/nginx/conf/vhosts/yourapp.conf \
  --network app-tier \
  bitnami/nginx:latest
```

or using Docker Compose:

```yaml
version: '2'
nginx:
  image: bitnami/nginx:latest
  networks:
    - app-tier
  volumes:
    - /path/to/vhost.conf:/bitnami/nginx/conf/vhosts/yourapp.conf
```

# Maintenance

## Upgrade this image

Bitnami provides up-to-date versions of JRuby, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```console
$ docker pull bitnami/jruby:latest
```

### Step 2: Stop the running container

Stop the currently running container using the command

```console
$ docker stop jruby
```

### Step 3: Remove the currently running container

```console
$ docker-compose rm -v jruby
```

### Step 4: Run the new image

Re-create your container from the new image.

```console
$ docker run --name jruby bitnami/jruby:latest
```

or using Docker Compose:

```console
$ docker-compose up ruby
```

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-jruby/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-jruby/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-jruby/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

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
