# Bitnami Secure Image for Apache Spark

> Apache Spark is a high-performance engine for large-scale computing tasks, such as data processing, machine learning and real-time data streaming. It includes APIs for Java, Python, Scala and R.

[Overview of Apache Spark](https://spark.apache.org/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name spark bitnami/spark:latest
```

## Using `docker-compose.yml`

The docker-compose.yaml file of this container can be found in the [Bitnami Containers repository](https://github.com/bitnami/containers/).

[https://github.com/bitnami/containers/tree/main/bitnami/spark/docker-compose.yml](https://github.com/bitnami/containers/tree/main/bitnami/spark/docker-compose.yml)

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/spark).

## Why use Bitnami Secure Images?

Those are hardened, minimal CVE images built and maintained by Bitnami. Bitnami Secure Images are based on the cloud-optimized, security-hardened enterprise [OS Photon Linux](https://vmware.github.io/photon/). Why choose BSI images?

- Hardened secure images of popular open source software with Near-Zero Vulnerabilities
- Vulnerability Triage & Prioritization with VEX Statements, KEV and EPSS Scores
- Compliance focus with FIPS, STIG, and air-gap options, including secure bill of materials (SBOM)
- Software supply chain provenance attestation through in-toto
- First class support for the internet’s favorite Helm charts

Each image comes with valuable security metadata. You can view the metadata in [our public catalog here](https://app-catalog.vmware.com/bitnami/apps). Note: Some data is only available with [commercial subscriptions to BSI](https://bitnami.com/).

![Alt text](https://github.com/bitnami/containers/blob/main/BSI%20UI%201.png?raw=true "Application details")
![Alt text](https://github.com/bitnami/containers/blob/main/BSI%20UI%202.png?raw=true "Packaging report")

If you are looking for our previous generation of images based on Debian Linux, please see the [Bitnami Legacy registry](https://hub.docker.com/u/bitnamilegacy).

## How to deploy Apache Spark in Kubernetes

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Apache Spark Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/spark).

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

## Get this image

The Bitnami Apache Spark Docker image is only available to [Bitnami Secure Images](https://bitnami.com) customers.

## Configuration

The following sections describe environment variables and related settings.

### Environment variables

The following tables list the main variables you can set.

#### Customizable environment variables

| Name                                     | Description                                                                      | Default Value                                  |
|------------------------------------------|----------------------------------------------------------------------------------|------------------------------------------------|
| `SPARK_MODE`                             | Spark cluster mode to run (can be master or worker).                             | `master`                                       |
| `SPARK_MASTER_URL`                       | Url where the worker can find the master. Only needed when spark mode is worker. | `spark://spark-master:7077`                    |
| `SPARK_NO_DAEMONIZE`                     | Spark does not run as a daemon.                                                  | `true`                                         |
| `SPARK_RPC_AUTHENTICATION_ENABLED`       | Enable RPC authentication.                                                       | `no`                                           |
| `SPARK_RPC_AUTHENTICATION_SECRET`        | The secret key used for RPC authentication.                                      | `nil`                                          |
| `SPARK_RPC_ENCRYPTION_ENABLED`           | Enable RPC encryption.                                                           | `no`                                           |
| `SPARK_LOCAL_STORAGE_ENCRYPTION_ENABLED` | Enable local storage encryption.                                                 | `no`                                           |
| `SPARK_SSL_ENABLED`                      | Enable SSL configuration.                                                        | `no`                                           |
| `SPARK_SSL_KEY_PASSWORD`                 | The password to the private key in the key store.                                | `nil`                                          |
| `SPARK_SSL_KEYSTORE_PASSWORD`            | The password for the key store.                                                  | `nil`                                          |
| `SPARK_SSL_KEYSTORE_FILE`                | Location of the key store.                                                       | `${SPARK_CONF_DIR}/certs/spark-keystore.jks`   |
| `SPARK_SSL_TRUSTSTORE_PASSWORD`          | The password for the trust store.                                                | `nil`                                          |
| `SPARK_SSL_TRUSTSTORE_FILE`              | Location of the key store.                                                       | `${SPARK_CONF_DIR}/certs/spark-truststore.jks` |
| `SPARK_SSL_NEED_CLIENT_AUTH`             | Whether to require client authentication.                                        | `yes`                                          |
| `SPARK_SSL_PROTOCOL`                     | TLS protocol to use.                                                             | `TLSv1.2`                                      |
| `SPARK_WEBUI_SSL_PORT`                   | Spark management server port number for SSL/TLS connections.                     | `nil`                                          |
| `SPARK_METRICS_ENABLED`                  | Whether to enable metrics for Spark.                                             | `false`                                        |

#### Read-only environment variables

| Name                     | Description                            | Value                                   |
|--------------------------|----------------------------------------|-----------------------------------------|
| `SPARK_BASE_DIR`         | Spark installation directory.          | `${BITNAMI_ROOT_DIR}/spark`             |
| `SPARK_CONF_DIR`         | Spark configuration directory.         | `${SPARK_BASE_DIR}/conf`                |
| `SPARK_DEFAULT_CONF_DIR` | Spark default configuration directory. | `${SPARK_BASE_DIR}/conf.default`        |
| `SPARK_WORK_DIR`         | Spark workspace directory.             | `${SPARK_BASE_DIR}/work`                |
| `SPARK_CONF_FILE`        | Spark configuration file path.         | `${SPARK_CONF_DIR}/spark-defaults.conf` |
| `SPARK_LOG_DIR`          | Spark logs directory.                  | `${SPARK_BASE_DIR}/logs`                |
| `SPARK_TMP_DIR`          | Spark tmp directory.                   | `${SPARK_BASE_DIR}/tmp`                 |
| `SPARK_JARS_DIR`         | Spark jar directory.                   | `${SPARK_BASE_DIR}/jars`                |
| `SPARK_INITSCRIPTS_DIR`  | Spark init scripts directory.          | `/docker-entrypoint-initdb.d`           |
| `SPARK_USER`             | Spark user.                            | `spark`                                 |
| `SPARK_DAEMON_USER`      | Spark system user.                     | `spark`                                 |
| `SPARK_DAEMON_GROUP`     | Spark system group.                    | `spark`                                 |

Additionally, more environment variables natively supported by Apache Spark can be found [at the official documentation](https://spark.apache.org/docs/latest/spark-standalone.html#cluster-launch-scripts).

For example, you could still use `SPARK_WORKER_CORES` or `SPARK_WORKER_MEMORY` to configure the number of cores and the amount of memory to be used by a worker machine.

### Security

The Bitnami Apache Spark docker image supports enabling RPC authentication, RPC encryption and local storage encryption easily using the following environment variables in all the nodes of the cluster.

```diff
+ SPARK_RPC_AUTHENTICATION_ENABLED=yes
+ SPARK_RPC_AUTHENTICATION_SECRET=RPC_AUTHENTICATION_SECRET
+ SPARK_RPC_ENCRYPTION=yes
+ SPARK_LOCAL_STORAGE_ENCRYPTION=yes
```

> Please note that `RPC_AUTHENTICATION_SECRET` is a placeholder that needs to be updated with a correct value.
> Be also aware that currently is not possible to submit an application to a standalone cluster if RPC authentication is configured. More info about the issue [here](https://issues.apache.org/jira/browse/SPARK-25078).

Additionally, SSL configuration can be easily activated following the next steps:

1. Enable SSL configuration by setting the following environment variables:

    ```diff
    + SPARK_SSL_ENABLED=yes
    + SPARK_SSL_KEY_PASSWORD=KEY_PASSWORD
    + SPARK_SSL_KEYSTORE_PASSWORD=KEYSTORE_PASSWORD
    + SPARK_SSL_TRUSTSTORE_PASSWORD=TRUSTSTORE_PASSWORD
    + SPARK_SSL_NEED_CLIENT_AUTH=yes
    + SPARK_SSL_PROTOCOL=TLSv1.2
    ```

    > Please note that `KEY_PASSWORD`, `KEYSTORE_PASSWORD`, and `TRUSTSTORE_PASSWORD` are placeholders that needs to be updated with a correct value.

2. You need to mount your spark `keystore` and `truststore` files to `/opt/bitnami/spark/conf/certs`. Please note they should be called `spark-keystore.jks` and `spark-truststore.jks` and they should be in JKS format.

### Mount a custom configuration file

The image looks for configuration in the `conf/` directory of `/opt/bitnami/spark`.

### Installing additional jars

By default, this container bundles a generic set of jar files but the default image can be extended to add as many jars as needed for your specific use case. For instance, the following Dockerfile adds [`aws-java-sdk-bundle-1.11.704.jar`](https://mvnrepository.com/artifact/com.amazonaws/aws-java-sdk-bundle/1.11.704):

```Dockerfile
FROM bitnami/spark
USER root
RUN install_packages curl
USER 1001
RUN curl https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.11.704/aws-java-sdk-bundle-1.11.704.jar --output /opt/bitnami/spark/jars/aws-java-sdk-bundle-1.11.704.jar
```

#### Using a different version of Hadoop jars

In a similar way that in the previous section, you may want to use a different version of Hadoop jars.

Go to <https://spark.apache.org/downloads.html> and copy the download URL bundling the Hadoop version you want and matching the Apache Spark version of the container. Extend the Bitnami container image as below:

```Dockerfile
FROM bitnami/spark:latest
USER root
RUN install_packages curl
USER 1001
RUN rm -r /opt/bitnami/spark/jars && \
    curl --location https://dlcdn.apache.org/spark/spark-3.5.0/spark-3.5.0-bin-hadoop3.tgz | \
    tar --extract --gzip --strip=1 --directory /opt/bitnami/spark/ spark-3.5.0-bin-hadoop3/jars/
```

You can check the Hadoop version by running the following commands in the new container image:

```console
$ pyspark
>>> sc._gateway.jvm.org.apache.hadoop.util.VersionInfo.getVersion()
'2.7.4'
```

### FIPS configuration in Bitnami Secure Images

The Bitnami Apache Spark Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.
- `JAVA_TOOL_OPTIONS`: controls Java FIPS mode. Use `-Djava.security.properties==/opt/bitnami/java/conf/security/java.security.restricted` (restricted), `-Djava.security.properties==/opt/bitnami/java/conf/security/java.security.relaxed` (relaxed), or `-Djava.security.properties==/opt/bitnami/java/conf/security/java.security.original` (off).

## Logging

The Bitnami Apache Spark Docker image sends the container logs to the `stdout`. You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Notable changes

The following subsections describe notable changes.

### 4.0.0-debian-10-r2

- The container image was updated to use `hadoop-aws` `3.4.x` and `aws-java-sdk` was removed. If you want to use a different version, please read [Using a different version of Hadoop jars](#using-a-different-version-of-hadoop-jars).

### 3.0.0-debian-10-r44

- The container image was updated to use `hadoop-aws` `3.2.x`. If you want to use a different version, please read [Using a different version of Hadoop jars](#using-a-different-version-of-hadoop-jars).

### 2.4.5-debian-10-r49

- This image now has an aws-cli and two jars: `hadoop-aws` and `aws-java-sdk` for provide an easier way to use AWS.

## License

Copyright &copy; 2026 Broadcom. The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
