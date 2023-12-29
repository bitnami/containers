# Bitnami package for Confluent Schema Registry

## What is Confluent Schema Registry?

> Confluent Schema Registry provides a RESTful interface by adding a serving layer for your metadata on top of Kafka. It expands Kafka enabling support for Apache Avro, JSON, and Protobuf schemas.

[Overview of Confluent Schema Registry](https://www.confluent.io)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name schema-registry bitnami/schema-registry:latest
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use Confluent Schema Registry in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami schema-registry Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/schema-registry).

```console
docker pull bitnami/schema-registry:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/schema-registry/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/schema-registry:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Configuration

### Environment variables

When you start the Confluent Schema Registry image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line. Please note that some variables are only considered when the container is started for the first time. If you want to add a new environment variable:

* For docker-compose add the variable name and value under the application section in the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/schema-registry/docker-compose.yml) file present in this repository:

    ```yaml
    schema-registry:
      ...
      environment:
        - SCHEMA_REGISTRY_DEBUG=true
      ...
    ```

* For manual execution add a `--env` option with each variable and value:

    ```console
    $ docker run -d --name schema-registry -p 8081:8081 \
      --env SCHEMA_REGISTRY_DEBUG=true \
      --network schema-registry-tier \
      --volume /path/to/schema-registry-persistence:/bitnami \
      bitnami/schema-registry:latest
    ```

Available environment variables:

#### Schema Registry settings

* `SCHEMA_REGISTRY_KAFKA_BROKERS`: List of Kafka brokers to connect to. Default: **PLAINTEXT://localhost:9092**.
* `SCHEMA_REGISTRY_ADVERTISED_HOSTNAME`: Advertised hostname in ZooKeeper. Default: **container IP**.
* `SCHEMA_REGISTRY_KAFKA_KEYSTORE_PASSWORD`: Password to access the keystore. Default: **empty value**.
* `SCHEMA_REGISTRY_KAFKA_KEY_PASSWORD`: Password to be able to used ssl secured kafka broker with Schema Registry. Default: **empty value**.
* `SCHEMA_REGISTRY_KAFKA_TRUSTSTORE_PASSWORD`: Password to access the truststore. Default: **empty value**.
* `SCHEMA_REGISTRY_KAFKA_SASL_USER`: SASL user to authenticate with Kafka. Default: **empty value**.
* `SCHEMA_REGISTRY_KAFKA_SASL_PASSWORD`: SASL password to authenticate with Kafka. Default: **empty value**.
* `SCHEMA_REGISTRY_LISTENERS`: Comma-separated list of listeners that listen for API requests over either HTTP or HTTPS. Default: **<http://0.0.0.0:8081>**.
* `SCHEMA_REGISTRY_SSL_KEYSTORE_PASSWORD`: Password to access the SSL keystore. Default: **empty value**.
* `SCHEMA_REGISTRY_SSL_KEY_PASSWORD`: Password to access the SSL key. Default: **empty value**.
* `SCHEMA_REGISTRY_SSL_TRUSTSTORE_PASSWORD`: Password to access the SSL truststore. Default: **empty value**.
* `SCHEMA_REGISTRY_SSL_ENDPOINT_IDENTIFICATION_ALGORITHM`: Endpoint identification algorithm to validate the server hostname using the server certificate. Default: **empty value**.
* `SCHEMA_REGISTRY_CLIENT_AUTHENTICATION`: Client authentication configuration. Valid options: `NONE`, `REQUESTED`, or `REQUIRED`.
* `SCHEMA_REGISTRY_AVRO_COMPATIBILY_LEVEL`: The Avro compatibility type. Valid options: `NONE`, `BACKWARD`, `BACKWARD_TRANSITIVE`, `FORWARD`, `FORWARD_TRANSITIVE`, `FULL`, or `FULL_TRANSITIVE`.
* `SCHEMA_REGISTRY_DEBUG`: Enable Schema Registry debug logs. Valid options: true or false. Default: **false**.

#### Kafka settings

Please check the configuration settings for the Kakfa service in the [Kafka's README file](https://github.com/bitnami/containers/tree/main/bitnami/kafka#configuration).

#### Zookeeper settings

Please check the configuration settings for the Kakfa service in the [Zookeeper's README file](https://github.com/bitnami/containers/tree/main/bitnami/zookeeper#configuration).

## Security

The Schema Registry container can be setup to serve clients securely via TLS. To do so, specify the listener protocol as **https** in the `SCHEMA_REGISTRY_LISTENERS` environment variable (ex. SCHEMA_REGISTRY_LISTENERS=`http://0.0.0.0:8081`,`https://0.0.0.0:8082`).
The keystore and trustore **must** be mounted in the `/opt/bitnami/schema-registry/certs` directory as `ssl.keystore.jks` and `ssl.truststore.jks` respectively. Only jks formats are currently supported and please note that the environment variables `SCHEMA_REGISTRY_SSL_KEYSTORE_LOCATION` or `SCHEMA_REGISTRY_SSL_TRUSTSTORE_LOCATION` **will not override the expected location or file names**, so please follow the instructions provided or you will get this error at startup: *ERROR ==> In order to configure HTTPS access, you must mount your ssl.keystore.jks (and optionally the ssl.truststore.jks) to the /opt/bitnami/schema-registry/certs directory*.

Here is a docker-compose.yaml example that exposes a TLS listener on port 8082
```yaml
schema-registry:
  image: bitnami/schema-registry
  ports:
    - "8081:8081"
    - "8082:8082"
  depends_on:
    - kafka
  environment:
    - SCHEMA_REGISTRY_KAFKA_BROKERS=PLAINTEXT://kafka:9092
    - SCHEMA_REGISTRY_HOST_NAME=schema-registry
    - SCHEMA_REGISTRY_LISTENERS=http://0.0.0.0:8081,https://0.0.0.0:8082
    - SCHEMA_REGISTRY_SSL_KEYSTORE_PASSWORD=keystore
    - SCHEMA_REGISTRY_SSL_TRUSTSTORE_PASSWORD=keystore
    - SCHEMA_REGISTRY_SSL_ENDPOINT_IDENTIFICATION_ALGORITHM=none
    - SCHEMA_REGISTRY_CLIENT_AUTHENTICATION=REQUESTED
  volumes:
    - ./keystore.jks:/opt/bitnami/schema-registry/certs/keystore.jks:ro
    - ./truststore.jks:/opt/bitnami/schema-registry/certs/truststore.jks:ro
```

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues) or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/containers/issues/new/choose). For us to provide better support, be sure to fill the issue template.

## License

Copyright &copy; 2023 VMware, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
