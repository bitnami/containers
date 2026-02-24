# Bitnami Secure Image for Apache Airflow

## What is Apache Airflow?

> Apache Airflow is a tool to express and execute workflows as directed acyclic graphs (DAGs). It includes utilities to schedule tasks, monitor task progress and handle task dependencies.

[Overview of Apache Airflow](https://airflow.apache.org/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name airflow bitnami/airflow:latest
```

**Warning**: This quick setup is only intended for development environments. You are encouraged to change the insecure default credentials and check out the available configuration options in the [Environment Variables](#environment-variables) section for a more secure d
eployment.

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

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

## How to use this image

Airflow requires access to a PostgreSQL database to store information. We will use the [Bitnami PostgreSQL image](https://github.com/bitnami/containers/tree/main/bitnami/postgresql) for the database requirements. Additionally, if you pretend to use the `CeleryExecutor`, you will also need a [Bitnami Redis(R) server](https://github.com/bitnami/containers/tree/main/bitnami/redis).

### Using `docker-compose.yaml`

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/airflow).

### Persisting your application

The Bitnami Airflow container relies on the PostgreSQL database & Redis to persist the data. This means that Airflow does not persist anything. To avoid loss of data, you should mount volumes for persistence of [PostgreSQL data](https://github.com/bitnami/containers/blob/main/bitnami/mariadb#persisting-your-database) and [Redis(R) data](https://github.com/bitnami/containers/blob/main/bitnami/redis#persisting-your-database)

The above examples define docker volumes namely `postgresql_data`, and `redis_data`. The Airflow application state will persist as long as these volumes are not removed.

To avoid inadvertent removal of these volumes you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

## Configuration

### Load DAG files

Custom DAG files can be mounted to `/opt/bitnami/airflow/dags`.

### Installing additional python modules

This container supports the installation of additional python modules at start-up time. In order to do that, you can mount a `requirements.txt` file with your specific needs under the path `/bitnami/python/requirements.txt`.

### Environment variables

#### Customizable environment variables

| Name                                     | Description                                                                                                                                 | Default Value                   |
|------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------|
| `AIRFLOW_USERNAME`                       | Airflow username                                                                                                                            | `user`                          |
| `AIRFLOW_PASSWORD`                       | Airflow password                                                                                                                            | `bitnami`                       |
| `AIRFLOW_FIRSTNAME`                      | Airflow firstname                                                                                                                           | `Firstname`                     |
| `AIRFLOW_LASTNAME`                       | Airflow lastname                                                                                                                            | `Lastname`                      |
| `AIRFLOW_EMAIL`                          | Airflow email                                                                                                                               | `user@example.com`              |
| `AIRFLOW_COMPONENT_TYPE`                 | Airflow component type. Allowed values: *api-server*, *scheduler*, *dag-processor*, *triggerer*, *webserver* (2.x versions only), *worker*. | `api-server`                    |
| `AIRFLOW_EXECUTOR`                       | Airflow executor.                                                                                                                           | `LocalExecutor`                 |
| `AIRFLOW_RAW_FERNET_KEY`                 | Airflow raw/unencoded Fernet key                                                                                                            | `nil`                           |
| `AIRFLOW_FORCE_OVERWRITE_CONF_FILE`      | Force the airflow.cfg config file generation.                                                                                               | `no`                            |
| `AIRFLOW_FERNET_KEY`                     | Airflow Fernet key                                                                                                                          | `nil`                           |
| `AIRFLOW_WEBSERVER_SECRET_KEY`           | Airflow webserver secret key                                                                                                                | `airflow-web-server-key`        |
| `AIRFLOW_APISERVER_SECRET_KEY`           | Airflow API secret key                                                                                                                      | `airflow-api-server-key`        |
| `AIRFLOW_APISERVER_BASE_URL`             | Airflow API server base URL.                                                                                                                | `nil`                           |
| `AIRFLOW_APISERVER_HOST`                 | Airflow API server host                                                                                                                     | `127.0.0.1`                     |
| `AIRFLOW_APISERVER_PORT_NUMBER`          | Airflow API server port.                                                                                                                    | `8080`                          |
| `AIRFLOW_LOAD_EXAMPLES`                  | To load example tasks into the application.                                                                                                 | `yes`                           |
| `AIRFLOW_HOSTNAME_CALLABLE`              | Method to obtain the hostname.                                                                                                              | `nil`                           |
| `AIRFLOW_POOL_NAME`                      | Pool name.                                                                                                                                  | `nil`                           |
| `AIRFLOW_POOL_SIZE`                      | Pool size, required with AIRFLOW_POOL_NAME.                                                                                                 | `nil`                           |
| `AIRFLOW_POOL_DESC`                      | Pool description, required with AIRFLOW_POOL_NAME.                                                                                          | `nil`                           |
| `AIRFLOW_STANDALONE_DAG_PROCESSOR`       | Enable running Dag Processor in standalone mode                                                                                             | `no`                            |
| `AIRFLOW_TRIGGERER_DEFAULT_CAPACITY`     | How many triggers a single Triggerer can run at once.                                                                                       | `1000`                          |
| `AIRFLOW_WORKER_QUEUE`                   | A queue for the worker to pull tasks from.                                                                                                  | `nil`                           |
| `AIRFLOW_SKIP_DB_SETUP`                  | Skip db init / db migrate actions during the setup                                                                                          | `no`                            |
| `PYTHONPYCACHEPREFIX`                    | Configure Python .pyc files cache prefix                                                                                                    | `/opt/bitnami/airflow/venv/tmp` |
| `AIRFLOW_DB_MIGRATE_TIMEOUT`             | How much time to wait for database migrations                                                                                               | `120`                           |
| `AIRFLOW_ENABLE_HTTPS`                   | Whether to enable HTTPS for Airflow by default.                                                                                             | `no`                            |
| `AIRFLOW_EXTERNAL_APISERVER_PORT_NUMBER` | External HTTP/HTTPS port for Airflow.                                                                                                       | `80`                            |
| `AIRFLOW_DATABASE_HOST`                  | Hostname for PostgreSQL server.                                                                                                             | `postgresql`                    |
| `AIRFLOW_DATABASE_PORT_NUMBER`           | Port used by PostgreSQL server.                                                                                                             | `5432`                          |
| `AIRFLOW_DATABASE_NAME`                  | Database name that Airflow will use to connect with the database.                                                                           | `bitnami_airflow`               |
| `AIRFLOW_DATABASE_USERNAME`              | Database user that Airflow will use to connect with the database.                                                                           | `bn_airflow`                    |
| `AIRFLOW_DATABASE_PASSWORD`              | Database password that Airflow will use to connect with the database.                                                                       | `nil`                           |
| `AIRFLOW_DATABASE_USE_SSL`               | Set to yes if the database is using SSL.                                                                                                    | `no`                            |
| `AIRFLOW_REDIS_USE_SSL`                  | Set to yes if Redis(R) uses SSL.                                                                                                            | `no`                            |
| `REDIS_HOST`                             | Hostname for Redis(R) server.                                                                                                               | `redis`                         |
| `REDIS_PORT_NUMBER`                      | Port used by Redis(R) server.                                                                                                               | `6379`                          |
| `REDIS_USER`                             | User that Airflow will use to connect with Redis(R).                                                                                        | `nil`                           |
| `REDIS_PASSWORD`                         | Password that Airflow will use to connect with Redis(R).                                                                                    | `nil`                           |
| `REDIS_DATABASE`                         | Name of the Redis(R) database.                                                                                                              | `1`                             |
| `AIRFLOW_LDAP_ENABLE`                    | Enable LDAP authentication.                                                                                                                 | `no`                            |
| `AIRFLOW_LDAP_URI`                       | LDAP server URI.                                                                                                                            | `nil`                           |
| `AIRFLOW_LDAP_SEARCH`                    | LDAP search base.                                                                                                                           | `nil`                           |
| `AIRFLOW_LDAP_UID_FIELD`                 | LDAP field used for uid.                                                                                                                    | `nil`                           |
| `AIRFLOW_LDAP_BIND_USER`                 | LDAP user name.                                                                                                                             | `nil`                           |
| `AIRFLOW_LDAP_BIND_PASSWORD`             | LDAP user password.                                                                                                                         | `nil`                           |
| `AIRFLOW_LDAP_USER_REGISTRATION`         | User self registration.                                                                                                                     | `True`                          |
| `AIRFLOW_LDAP_USER_REGISTRATION_ROLE`    | Role name to be assign when a user registers himself.                                                                                       | `nil`                           |
| `AIRFLOW_LDAP_ROLES_MAPPING`             | Mapping from LDAP DN to a list of Airflow roles.                                                                                            | `nil`                           |
| `AIRFLOW_LDAP_ROLES_SYNC_AT_LOGIN`       | Replace ALL the user roles each login, or only on registration.                                                                             | `True`                          |
| `AIRFLOW_LDAP_USE_TLS`                   | Use LDAP SSL.                                                                                                                               | `False`                         |
| `AIRFLOW_LDAP_ALLOW_SELF_SIGNED`         | Allow self signed certificates in LDAP ssl.                                                                                                 | `True`                          |
| `AIRFLOW_LDAP_TLS_CA_CERTIFICATE`        | File that store the CA for LDAP ssl.                                                                                                        | `nil`                           |

#### Read-only environment variables

| Name                          | Description                               | Value                                     |
|-------------------------------|-------------------------------------------|-------------------------------------------|
| `AIRFLOW_BASE_DIR`            | Airflow home/installation directory.      | `${BITNAMI_ROOT_DIR}/airflow`             |
| `AIRFLOW_BIN_DIR`             | Airflow directory for binary executables. | `${AIRFLOW_BASE_DIR}/venv/bin`            |
| `AIRFLOW_LOGS_DIR`            | Airflow logs directory.                   | `${AIRFLOW_BASE_DIR}/logs`                |
| `AIRFLOW_SCHEDULER_LOGS_DIR`  | Airflow scheduler logs directory.         | `${AIRFLOW_LOGS_DIR}/scheduler`           |
| `AIRFLOW_CONF_FILE`           | Airflow configuration file.               | `${AIRFLOW_BASE_DIR}/airflow.cfg`         |
| `AIRFLOW_WEBSERVER_CONF_FILE` | Airflow Webserver configuration file.     | `${AIRFLOW_BASE_DIR}/webserver_config.py` |
| `AIRFLOW_TMP_DIR`             | Airflow directory temporary files.        | `${AIRFLOW_BASE_DIR}/tmp`                 |
| `AIRFLOW_DAGS_DIR`            | Airflow data to be persisted.             | `${AIRFLOW_BASE_DIR}/dags`                |
| `AIRFLOW_DAEMON_USER`         | Airflow system user.                      | `airflow`                                 |
| `AIRFLOW_DAEMON_GROUP`        | Airflow system group.                     | `airflow`                                 |

> In addition to the previous environment variables, all the parameters from the configuration file can be overwritten by using environment variables with this format: `AIRFLOW__{SECTION}__{KEY}`. Note the double underscores.

#### SMTP Configuration

To configure Airflow to send email using SMTP you can set the following environment variables:

- `AIRFLOW__SMTP__SMTP_HOST`: Host for outgoing SMTP email. Default: **localhost**
- `AIRFLOW__SMTP__SMTP_PORT`: Port for outgoing SMTP email. Default: **25**
- `AIRFLOW__SMTP__SMTP_STARTTLS`: To use TLS communication. Default: **True**
- `AIRFLOW__SMTP__SMTP_SSL`: To use SSL communication. Default: **False**
- `AIRFLOW__SMTP__SMTP_USER`: User of SMTP used for authentication (likely email). No defaults.
- `AIRFLOW__SMTP__SMTP_PASSWORD`: Password for SMTP. No defaults.
- `AIRFLOW__SMTP__SMTP_MAIL_FROM`: To modify the "from email address". Default: **<airflow@example.com>**

### FIPS configuration in Bitnami Secure Images

The Bitnami Apache Airflow Docker image from the [Bitnami Secure Images](https://go-vmware.broadcom.com/contact-us) catalog includes extra features and settings to configure the container with FIPS capabilities. You can configure the next environment variables:

- `OPENSSL_FIPS`: whether OpenSSL runs in FIPS mode or not. `yes` (default), `no`.

## Notable Changes

### Starting October 30, 2024

- The Airflow container now supports running as a Web server, Scheduler or Worker component, so it's no longer necessary to combine this container image with `bitnami/airflow-scheduler` and `bitnami/airflow-worker` in order to use the `CeleryExecutor`.
- The `AIRFLOW_COMPONENT_TYPE` environment variable was introduced to specify the component type. Current supported values are `webserver`, `scheduler` and `worker`, although it's planned to add soon support for `dag-processor` and `triggerer` components. The default value is `webserver`.

### 1.10.15-debian-10-r17 and 2.0.1-debian-10-r50

- The size of the container image has been decreased.
- The configuration logic is now based on Bash scripts in the *rootfs/* folder.

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
