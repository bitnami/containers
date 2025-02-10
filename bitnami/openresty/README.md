# Bitnami package for OpenResty

## What is OpenResty?

> OpenResty is a platform for scalable Web applications and services. It is based on enhanced versions of NGINX and LuaJIT.

[Overview of OpenResty](https://openresty.org/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name openresty bitnami/openresty:latest
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use OpenResty in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

## Only latest stable branch maintained in the free Bitnami catalog

Starting December 10th 2024, only the latest stable branch of any container will receive updates in the free Bitnami catalog. To access up-to-date releases for all upstream-supported branches, consider upgrading to Bitnami Premium. Previous versions already released will not be deleted. They are still available to pull from DockerHub.

Please check the Bitnami Premium page in our partner [Arrow Electronics](https://www.arrow.com/globalecs/na/vendors/bitnami?utm_source=GitHub&utm_medium=containers) for more information.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami OpenResty Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/openresty).

```console
docker pull bitnami/openresty:latest
```

To use a specific version, you can pull a versioned tag. You can view the
[list of available versions](https://hub.docker.com/r/bitnami/openresty/tags/)
in the Docker Hub Registry.

```console
docker pull bitnami/openresty:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Hosting a static website

This OpenResty image exposes a volume at `/app`. Content mounted here is served by the default catch-all server block.

```console
docker run -v /path/to/app:/app bitnami/openresty:latest
```

## Accessing your server from the host

To access your web server from your host machine you can ask Docker to map a random port on your host to ports `8080` and `8443` exposed in the container.

```console
docker run --name nginx -P bitnami/openresty:latest
```

Run `docker port` to determine the random ports Docker assigned.

```console
$ docker port openresty
8080/tcp -> 0.0.0.0:32769
```

You can also manually specify the ports you want forwarded from your host to the container.

```console
docker run -p 9000:8080 bitnami/openresty:latest
```

Access your web server in the browser by navigating to `http://localhost:9000`.

## Configuration

### Environment variables

#### Customizable environment variables

| Name                          | Description                                                          | Default Value |
|-------------------------------|----------------------------------------------------------------------|---------------|
| `OPENRESTY_HTTP_PORT_NUMBER`  | HTTP port number used by OpenResty.                                  | `nil`         |
| `OPENRESTY_HTTPS_PORT_NUMBER` | HTTPS port number used by OpenResty.                                 | `nil`         |
| `OPENRESTY_FORCE_INITSCRIPTS` | Force the init scripts running even if it is not in the first start. | `false`       |

#### Read-only environment variables

| Name                                  | Description                                                  | Value                                       |
|---------------------------------------|--------------------------------------------------------------|---------------------------------------------|
| `OPENRESTY_BASE_DIR`                  | OpenResty installation directory.                            | `${BITNAMI_ROOT_DIR}/openresty`             |
| `OPENRESTY_VOLUME_DIR`                | OpenResty directory for mounted files.                       | `${BITNAMI_VOLUME_DIR}/openresty`           |
| `OPENRESTY_BIN_DIR`                   | OpenResty directory for binary executables.                  | `${OPENRESTY_BASE_DIR}/bin`                 |
| `OPENRESTY_CONF_DIR`                  | OpenResty configuration directory.                           | `${OPENRESTY_BASE_DIR}/nginx/conf`          |
| `OPENRESTY_HTDOCS_DIR`                | Directory containing HTTP files to serve via OpenResty.      | `${OPENRESTY_BASE_DIR}/nginx/html`          |
| `OPENRESTY_TMP_DIR`                   | OpenResty directory for runtime temporary files.             | `${OPENRESTY_BASE_DIR}/nginx/tmp`           |
| `OPENRESTY_LOGS_DIR`                  | OpenResty directory for logs.                                | `${OPENRESTY_BASE_DIR}/nginx/logs`          |
| `OPENRESTY_SERVER_BLOCKS_DIR`         | OpenResty directory for virtual hosts.                       | `${OPENRESTY_CONF_DIR}/nginx/server_blocks` |
| `OPENRESTY_SITE_DIR`                  | OpenResty directory for installing Lua packages.             | `${OPENRESTY_BASE_DIR}/site`                |
| `OPENRESTY_INITSCRIPTS_DIR`           | OpenResty init scripts directory.                            | `/docker-entrypoint-initdb.d`               |
| `OPM_BASE_DIR`                        | OpenResty package manager base directory.                    | `/home/openresty`                           |
| `OPENRESTY_CONF_FILE`                 | Path to the OpenResty configuration.                         | `${OPENRESTY_CONF_DIR}/nginx.conf`          |
| `OPENRESTY_PID_FILE`                  | Path to the OpenResty PID file.                              | `${OPENRESTY_TMP_DIR}/nginx.pid`            |
| `OPENRESTY_DAEMON_USER`               | OpenResty system user.                                       | `daemon`                                    |
| `OPENRESTY_DAEMON_GROUP`              | OpenResty system group.                                      | `daemon`                                    |
| `OPENRESTY_DEFAULT_HTTP_PORT_NUMBER`  | Default OpenResty HTTP port number to enable at build time.  | `8080`                                      |
| `OPENRESTY_DEFAULT_HTTPS_PORT_NUMBER` | Default OpenResty HTTPS port number to enable at build time. | `8443`                                      |

### Initializing a new instance

When the container is executed for the first time, it will execute the files with extensions `.sh` located at `/docker-entrypoint-initdb.d`.

In order to have your custom files inside the docker image you can mount them as a volume.

### Adding custom server blocks

The default `nginx.conf` includes server blocks placed in `/opt/bitnami/openresty/nginx/conf/server_blocks/`. You can mount a `my_server_block.conf` file containing your custom server block at this location.

For example, in order add a server block for `www.example.com`:

#### Step 1: Write your `my_server_block.conf` file with the following content

```nginx
server {
  listen 0.0.0.0:8080;
  server_name www.example.com;
  root /app;
  index index.htm index.html;
}
```

#### Step 2: Mount the configuration as a volume

```console
docker run --name openresty \
  -v /path/to/my_server_block.conf:/opt/bitnami/openresty/nginx/conf/server_blocks/my_server_block.conf:ro \
  bitnami/openresty:latest
```

### Using custom SSL certificates

*NOTE:* The steps below assume that you are using a custom domain name and that you have already configured the custom domain name to point to your server.

#### Step 1: Prepare your certificate files

In your local computer, create a folder called `certs` and put your certificates files. Make sure you rename both files to `server.crt` and `server.key` respectively:

```console
mkdir -p /path/to/openresty-persistence/certs
cp /path/to/certfile.crt /path/to/openresty-persistence/certs/server.crt
cp /path/to/keyfile.key  /path/to/openresty-persistence/certs/server.key
```

#### Step 2: Provide a custom Server Block for SSL connections

Write your `my_server_block.conf` file with the SSL configuration and the relative path to the certificates:

```nginx
  server {
    listen       8443 ssl;

    ssl_certificate      bitnami/certs/server.crt;
    ssl_certificate_key  bitnami/certs/server.key;

    ssl_session_cache    shared:SSL:1m;
    ssl_session_timeout  5m;

    ssl_ciphers  HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers  on;

    location / {
      root   html;
      index  index.html index.htm;
    }
  }
```

#### Step 3: Run the OpenResty image and open the SSL port

Run the OpenResty image, mounting the certificates directory from your host.

```console
docker run --name openresty \
  -v /path/to/my_server_block.conf:/opt/bitnami/openresty/nginx/conf/server_blocks/my_server_block.conf:ro \
  -v /path/to/openresty-persistence/certs:/certs \
  bitnami/openresty:latest
```

### Full configuration

The image looks for configurations in `/opt/bitnami/openresty/nginx/conf/nginx.conf`. You can overwrite the `nginx.conf` file using your own custom configuration file.

```console
docker run --name openresty \
  -v /path/to/your_nginx.conf:/opt/bitnami/openresty/nginx/conf/nginx.conf:ro \
  bitnami/openresty:latest
```

### Adding lua modules

Openresty uses its own Lua's package manager named `opm`. It is advised to use `opm` [instead of other Lua's package manager like `luarocks`](https://openresty.org/en/using-luarocks.html). You can easily run the `opm` command from the container command-line, or build your custom image by extending Bitnami's:

```Dockerfile
FROM bitnami/openresty:latest
RUN opm get openresty/lua-resty-lock
```

Additionally, you can install your custom Lua modules using [your custom init scripts](#initializing-a-new-instance).

#### NGINX HTTP DAV module

The [module ngx_http_dav_module](https://nginx.org/en/docs/http/ngx_http_dav_module.html) is intended for file management automation via the WebDAV protocol. In current Bitnami images, this module is built as a dynamic module located under the `/opt/bitnami/openresty/nginx/modules` directory. You will need to load it in your configuration for you to be able to use its directives.

```
load_module /opt/bitnami/openresty/nginx/modules/ngx_http_dav_module.so;
```

## Reverse proxy to other containers

OpenResty can be used to reverse proxy to other containers using Docker's linking system. This is particularly useful if you want to serve dynamic content through an OpenResty frontend. To do so, [add a server block](#adding-custom-server-blocks) like the following in the `/opt/bitnami/openresty/nginx/conf/server_blocks/` folder:

```nginx
server {
    listen 0.0.0.0:8080;
    server_name yourapp.com;
    access_log /opt/bitnami/openresty/nginx/logs/yourapp_access.log;
    error_log /opt/bitnami/openresty/nginx/logs/yourapp_error.log;

    location / {
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header HOST $http_host;
        proxy_set_header X-NginX-Proxy true;

        proxy_pass http://[your_container_alias]:[your_container_port];
        proxy_redirect off;
    }
}
```

**Further Reading:**

* [NGINX reverse proxy](http://nginx.com/resources/admin-guide/reverse-proxy/)

## Logging

The Bitnami OpenResty Docker image sends the container logs to the `stdout`. To view the logs:

```console
docker logs openresty
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Customize this image

The Bitnami OpenResty Docker image is designed to be extended so it can be used as the base image for your custom web applications.

### Extend this image

Before extending this image, please note there are certain configuration settings you can modify using the original image:

* Settings that can be adapted using environment variables. For instance, you can change the port used by OpenResty for HTTP setting the environment variable `OPENRESTY_HTTP_PORT_NUMBER`.
* [Initializing a new instance](#initializing-a-new-instance)
* [Adding custom server blocks](#adding-custom-server-blocks).
* [Replacing the 'nginx.conf' file](#full-configuration).
* [Using custom SSL certificates](#using-custom-ssl-certificates).

If your desired customizations cannot be covered using the methods mentioned above, extend the image. To do so, create your own image using a Dockerfile with the format below:

```Dockerfile
FROM bitnami/openresty
## Put your customizations below
...
```

Here is an example of extending the image with the following modifications:

* Install the `vim` editor
* Modify the OpenResty configuration file
* Modify the ports used by OpenResty
* Change the user that runs the container

```Dockerfile
FROM bitnami/openresty

## Change user to perform privileged actions
USER 0
## Install 'vim'
RUN install_packages vim
## Revert to the original non-root user
USER 1001

## Modify 'worker_connections' on OpenResty config file to '512'
RUN sed -i -r "s#(\s+worker_connections\s+)[0-9]+;#\1512;#" /opt/bitnami/openresty/nginx/conf/nginx.conf

## Modify the ports used by OpenResty by default
ENV OPENRESTY_HTTP_PORT_NUMBER=8181 # It is also possible to change this environment variable at runtime
EXPOSE 8181 8143

## Modify the default container user
USER 1002
```

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of OpenResty, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/openresty:latest
```

#### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```console
docker stop openresty
```

#### Step 3: Remove the currently running container

```console
docker rm -v openresty
```

#### Step 4: Run the new image

Re-create your container from the new image.

```console
docker run --name nginx bitnami/openresty:latest
```

## Notable Changes

### Starting February 10, 2025

* The [module ngx_http_dav_module](http://nginx.org/en/docs/http/ngx_http_dav_module.html), WebDAV protocol, has been converted into a dynamic module.

### Starting January 16, 2024

* The `docker-compose.yaml` file has been removed, as it was solely intended for internal testing purposes.

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
