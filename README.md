<p align="center">
    <img width="180px" src="https://soldevelo.com/wp-content/uploads/2023/04/cropped-Frame-180x37.png" alt="SolDevelo Kafka" />
</p>

# SolDevelo Kafka Docker Image

This repository is a **fork of Bitnami's Containers Library**. Currently, we maintain only the **Apache Kafka container image**, but in the future we may add more containers. The Kafka image is maintained by SolDevelo to provide up-to-date Kafka versions and fixes, while keeping the original Bitnami base.

## Features

- Maintained Kafka container image by SolDevelo.
- Based on Bitnami Kafka container (Apache-2.0 licensed).
- Ready to use with Docker or Docker Compose.
- Future support for additional containers planned.

## Get an image

The recommended way to get any of the Images is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/soldevelo/).

```console
docker pull soldevelo/APP
```

To use a specific version, you can pull a versioned tag.

```console
docker pull soldevelo/APP:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile, and executing the `docker build` command.

```console
git clone https://github.com/soldevelo/containers.git
cd soldevelo/APP/VERSION/OPERATING-SYSTEM
docker build -t soldevelo/APP .
```

> [!TIP]
> Remember to replace the `APP`, `VERSION`, and `OPERATING-SYSTEM` placeholders in the example command above with the correct values.

## Run the application using Docker Compose

The main folder of each application contains a functional `docker-compose.yml` file. Run the application using it as shown below:

```console
curl -sSL https://raw.githubusercontent.com/soldevelo/containers/main/soldevelo/APP/docker-compose.yml > docker-compose.yml
docker-compose up -d
```

> [!TIP]
> Remember to replace the `APP` placeholder in the example command above with the correct value.

## Contributing

We'd love for you to contribute to those container images. You can request new features by creating an [issue](https://github.com/soldevelo/containers/issues/new/choose), or submit a [pull request](https://github.com/soldevelo/containers/pulls) with your contribution.

## License

Copyright 2025 SolDevelo
Based on Bitnami Containers Library (https://github.com/bitnami/containers) © 2025 Broadcom Inc. (licensed under Apache-2.0)

This project is licensed under the Apache License, Version 2.0.

You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and limitations under the License.
