# Bitnami package for Ruby

## What is Ruby?

> Ruby on Rails is a full-stack development environment optimized for programmer happiness and sustainable productivity. It lets you write beautiful code by favoring convention over configuration.

[Overview of Ruby](http://www.ruby-lang.org)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run -it --name ruby bitnami/ruby:latest
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use Ruby in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Only latest stable branch maintained in the free Bitnami catalog

Starting December 10th 2024, only the latest stable branch of any container will receive updates in the free Bitnami catalog. To access up-to-date releases for all upstream-supported branches, consider upgrading to Bitnami Premium. Previous versions already released will not be deleted. They are still available to pull from DockerHub.

Please check the Bitnami Premium page in our partner [Arrow Electronics](https://www.arrow.com/globalecs/na/vendors/bitnami?utm_source=GitHub&utm_medium=containers) for more information.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

### Deprecation Note (2022-01-21)

The `prod` tags has been removed; from now on just the regular container images will be released.

### Deprecation Note (2020-08-18)

The formatting convention for `prod` tags has been changed:

* `BRANCH-debian-10-prod` is now tagged as `BRANCH-prod-debian-10`
* `VERSION-debian-10-rX-prod` is now tagged as `VERSION-prod-debian-10-rX`
* `latest-prod` is now deprecated

## Get this image

The recommended way to get the Bitnami Ruby Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/ruby).

```console
docker pull bitnami/ruby:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/ruby/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/ruby:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Entering the REPL

By default, running this image will drop you into the Ruby REPL (`irb`), where you can interactively test and try things out in Ruby.

```console
docker run -it --name ruby bitnami/ruby:latest
```

**Further Reading:**

* [Ruby IRB Documentation](http://ruby-doc.org/stdlib-2.4.0/libdoc/irb/rdoc/IRB.html)

## Configuration

### Running your Ruby script

The default work directory for the Ruby image is `/app`. You can mount a folder from your host here that includes your Ruby script, and run it normally using the `ruby` command.

```console
docker run -it --name ruby -v /path/to/app:/app bitnami/ruby:latest \
  ruby script.rb
```

### Running a Ruby app with gems

If your Ruby app has a `Gemfile` defining your app's dependencies and start script, you can install the dependencies before running your app.

```console
docker run -it --name ruby -v /path/to/app:/app bitnami/ruby:latest \
  sh -c "bundle install && ruby script.rb"
```

or by modifying the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/ruby/docker-compose.yml) file present in this repository:

```yaml
ruby:
  ...
  command: "sh -c 'bundle install && ruby script.rb'"
  volumes:
    - .:/app
  ...
```

**Further Reading:**

* [rubygems.org](https://rubygems.org/)
* [bundler.io](http://bundler.io/)

### Accessing a Ruby app running a web server

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
docker run -it --name ruby -P bitnami/ruby:latest
```

Run `docker port` to determine the random port Docker assigned.

```console
$ docker port ruby
3000/tcp -> 0.0.0.0:32769
```

You can also manually specify the port you want forwarded from your host to the container.

```console
docker run -it --name ruby -p 8080:3000 bitnami/ruby:latest
```

Access your web server in the browser by navigating to `http://localhost:8080`.

## Connecting to other containers

If you want to connect to your Ruby web server inside another container, you can use docker networking to create a network and attach all the containers to that network.

### Serving your Ruby app through an nginx frontend

We may want to make our Ruby web server only accessible via an nginx web server. Doing so will allow us to setup more complex configuration, serve static assets using nginx, load balance to different Ruby instances, etc.

#### Step 1: Create a network

```console
docker network create app-tier --driver bridge
```

or using Docker Compose:

```yaml
version: '2'

networks:
  app-tier:
    driver: bridge
```

#### Step 2: Create a virtual host

Let's create an nginx virtual host to reverse proxy to our Ruby container.

```nginx
server {
    listen 0.0.0.0:80;
    server_name yourapp.com;

    location / {
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header HOST $http_host;
        proxy_set_header X-NginX-Proxy true;

        # proxy_pass http://[your_ruby_container_link_alias]:3000;
        proxy_pass http://myapp:3000;
        proxy_redirect off;
    }
}
```

Notice we've substituted the link alias name `myapp`, we will use the same name when creating the container.

Copy the virtual host above, saving the file somewhere on your host. We will mount it as a volume in our nginx container.

#### Step 3: Run the Ruby image with a specific name

```console
docker run -it --name myapp \
  --network app-tier \
  -v /path/to/app:/app \
  bitnami/ruby:latest ruby script.rb
```

or using Docker Compose:

```yaml
version: '2'
myapp:
  image: bitnami/ruby:latest
  command: ruby script.rb
  networks:
    - app-tier
  volumes:
    - .:/app
```

#### Step 4: Run the nginx image

```console
docker run -it \
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

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of Ruby, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/ruby:latest
```

or if you're using Docker Compose, update the value of the image property to `bitnami/ruby:latest`.

#### Step 2: Remove the currently running container

```console
docker rm -v ruby
```

or using Docker Compose:

```console
docker-compose rm -v ruby
```

#### Step 3: Run the new image

Re-create your container from the new image.

```console
docker run --name ruby bitnami/ruby:latest
```

or using Docker Compose:

```console
docker-compose up ruby
```

## Notable Changes

### 2.3.1-r0 (2016-05-11)

* Commands are now executed as the `root` user. Use the `--user` argument to switch to another user or change to the required user using `sudo` to launch applications. Alternatively, as of Docker 1.10 User Namespaces are supported by the docker daemon. Refer to the [daemon user namespace options](https://docs.docker.com/engine/security/userns-remap/) for more details.

### 2.2.3-0-r02 (2015-09-30)

* `/app` directory no longer exported as a volume. This caused problems when building on top of the image, since changes in the volume were not persisted between RUN commands. To keep the previous behavior (so that you can mount the volume in another container), create the container with the `-v /app` option.

### 2.2.3-0-r01 (2015-08-26)

* Permissions fixed so `bitnami` user can install gems without needing `sudo`.

## Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes.

If you detect any issue in the `docker-compose.yaml` file, feel free to report it or contribute with a fix by following our [Contributing Guidelines](https://github.com/bitnami/containers/blob/main/CONTRIBUTING.md).

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues) or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

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
