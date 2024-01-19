# Jaeger packaged by Bitnami

## What is jaeger?

> Jaeger is a Distributed Tracing System

[Overview of jaeger](https://www.jaegertracing.io/)

## TL;DR

```console
docker run --name v bitnami/jaeger:latest
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use jaeger in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami Jaeger Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/jaeger).

```console
docker pull bitnami/jaeger:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/jaeger/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/jaeger:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

## Configuration

### Environment variables

| Name                                         | Description                                                                | Default Value                   | Can be set |
|----------------------------------------------|----------------------------------------------------------------------------|---------------------------------|------------|
| `$JAEGER_BASE_DIR`                           | Jaeger installation directory.                                             | `${BITNAMI_ROOT_DIR}/jaeger`    |            |
| `$JAEGER_BIN_DIR`                            | Jaeger directory for binary files.                                         | `${JAEGER_BASE_DIR}/bin`        |            |
| `$JAEGER_CONF_DIR`                           | Jaeger configuration directory.                                            | `${JAEGER_BASE_DIR}/conf`       |            |
| `$JAEGER_CONF_FILE`                          | Jaeger configuration file.                                                 | `${JAEGER_CONF_DIR}/jaeger.yml` |            |
| `$JAEGER_LOGS_DIR`                           | Jaeger logs directory.                                                     | `${JAEGER_BASE_DIR}/logs`       |            |
| `$JAEGER_LOG_FILE`                           | Jaeger log file.                                                           | `${JAEGER_LOGS_DIR}/jaeger.log` |            |
| `$JAEGER_TMP_DIR`                            | Jaeger temporary directory.                                                | `${JAEGER_BASE_DIR}/tmp`        |            |
| `$JAEGER_PID_FILE`                           | Jaeger PID file.                                                           | `${JAEGER_TMP_DIR}/jaeger.pid`  |            |
| `$JAEGER_DAEMON_USER`                        | Jaeger daemon system user.                                                 | `jaeger`                        |            |
| `$JAEGER_DAEMON_GROUP`                       | Jaeger daemon system group.                                                | `jaeger`                        |            |
| `$JAEGER_USERNAME`                           | Jaeger username.                                                           | `user`                          | &check;    |
| `$JAEGER_PASSWORD`                           | Jaeger password.                                                           | `bitnami`                       | &check;    |
| `$JAEGER_AGENT_ZIPKIN_UDP_PORT_NUMBER`       | Jaeger Agent UDP port. Accept zipkin.thrift over compact thrift protocol   | `5775`                          | &check;    |
| `$JAEGER_AGENT_COMPACT_UDP_PORT_NUMBER`      | Jaeger Agent UDP port. Accept jaeger.thrift over compact thrift protocol   | `6831`                          | &check;    |
| `$JAEGER_AGENT_BINARY_UDP_PORT_NUMBER`       | Jaeger Agent UDP port. Accept jaeger.thrift over binary thrift protocol    | `6832`                          | &check;    |
| `$JAEGER_AGENT_HTTP_PORT_NUMBER`             | Jaeger Agent HTTP port. Serve configs.                                     | `5778`                          | &check;    |
| `$JAEGER_QUERY_HTTP_PORT_NUMBER`             | Jaeger Query HTTP port.                                                    | `16686`                         | &check;    |
| `$JAEGER_QUERY_GRPC_PORT_NUMBER`             | Jaeger Query GRPC port.                                                    | `16685`                         | &check;    |
| `$JAEGER_COLLECTOR_ZIPKIN_PORT_NUMBER`       | Jaeger Collector Zipkin compatible port.                                   |                                 | &check;    |
| `$JAEGER_COLLECTOR_HTTP_PORT_NUMBER`         | Jaeger Collector HTTP port. Accept jaeger.thrift directly from clients     | `14268`                         | &check;    |
| `$JAEGER_COLLECTOR_GRPC_PORT_NUMBER`         | Jaeger Collector GRPC port. Accept jaeger.thrift directly from clients     | `14250`                         | &check;    |
| `$JAEGER_ADMIN_HTTP_PORT_NUMBER`             | Jaeger Admin port.                                                         | `14269`                         | &check;    |
| `$JAEGER_AGENT_ZIPKIN_UDP_HOST`              | Jaeger Agent UDP host. Accept zipkin.thrift over compact thrift protocol   |                                 | &check;    |
| `$JAEGER_AGENT_COMPACT_UDP_HOST`             | Jaeger Agent UDP host. Accept jaeger.thrift over compact thrift protocol   |                                 | &check;    |
| `$JAEGER_AGENT_BINARY_UDP_HOST`              | Jaeger Agent UDP host. Accept jaeger.thrift over binary thrift protocol    |                                 | &check;    |
| `$JAEGER_AGENT_HTTP_HOST`                    | Jaeger Agent HTTP host. Serve configs.                                     |                                 | &check;    |
| `$JAEGER_QUERY_HTTP_HOST`                    | Jaeger Query HTTP host.                                                    |                                 | &check;    |
| `$JAEGER_QUERY_GRPC_HOST`                    | Jaeger Query GRPC host.                                                    |                                 | &check;    |
| `$JAEGER_COLLECTOR_HTTP_HOST`                | Jaeger Collector Zipkin compatible host.                                   |                                 | &check;    |
| `$JAEGER_COLLECTOR_GRPC_HOST`                | Jaeger Collector HTTP host. Accept jaeger.thrift directly from clients     |                                 | &check;    |
| `$JAEGER_ADMIN_HTTP_HOST`                    | Jaeger Collector GRPC host. Accept jaeger.thrift directly from clients     |                                 | &check;    |
| `$JAEGER_COLLECTOR_ZIPKIN_HOST`              | Jaeger Admin host.                                                         |                                 | &check;    |
| `$JAEGER_APACHE_QUERY_HTTP_PORT_NUMBER`      | Jaeger Query UI HTTP port, exposed via Apache with basic authentication.   |                                 | &check;    |
| `$JAEGER_APACHE_QUERY_HTTPS_PORT_NUMBER`     | Jaeger Query UI HTTPS port, exposed via Apache with basic authentication.  |                                 | &check;    |
| `$JAEGER_APACHE_COLLECTOR_HTTP_PORT_NUMBER`  | Jaeger Collector HTTP port, exposed via Apache with basic authentication.  | `14270`                         | &check;    |
| `$JAEGER_APACHE_COLLECTOR_HTTPS_PORT_NUMBER` | Jaeger Collector HTTPS port, exposed via Apache with basic authentication. | `14271`                         | &check;    |
| `$SPAN_STORAGE_TYPE`                         | Jaeger storage type.                                                       | `cassandra`                     | &check;    |
| `$JAEGER_CASSANDRA_HOST`                     | Cassandra server host.                                                     | `127.0.0.1`                     | &check;    |
| `$JAEGER_CASSANDRA_PORT_NUMBER`              | Cassandra server port.                                                     | `9042`                          | &check;    |
| `$JAEGER_CASSANDRA_KEYSPACE`                 | Cassandra keyspace.                                                        | `bn_jaeger`                     | &check;    |
| `$JAEGER_CASSANDRA_DATACENTER`               | Cassandra keyspace.                                                        | `dc1`                           | &check;    |
| `$JAEGER_CASSANDRA_USER`                     | Cassandra user name.                                                       | `cassandra`                     | &check;    |
| `$JAEGER_CASSANDRA_PASSWORD`                 | Cassandra user password.                                                   |                                 | &check;    |


### Running commands

To run commands inside this container you can use `docker run`, for example to execute `jaeger-all-in-one --help` you can follow the example below:

```console
docker run --rm --name jaeger bitnami/jaeger:latest --help
```

Check the [official jaeger documentation](https://www.jaegertracing.io//docs) for more information.

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues) or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/containers/issues/new/choose). For us to provide better support, be sure to fill the issue template.

## License

Copyright &copy; 2024 Broadcom. The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
