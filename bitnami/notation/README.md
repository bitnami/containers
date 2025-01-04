# Bitnami package for Notation

## What is Notation?

> Notation is a CLI project to add signatures as standard items in the OCI registry ecosystem, and to build a set of simple tooling for signing and verifying these signatures.

[Overview of Notation](https://notaryproject.dev)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run -it --name notation bitnami/notation
```

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use Notation in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Only latest stable branch maintained in the free Bitnami catalog

Starting December 10th 2024, only the latest stable branch of any container will receive updates in the free Bitnami catalog. To access up-to-date releases for all upstream-supported branches, consider upgrading to Bitnami Premium. Previous versions already released will not be deleted. They are still available to pull from DockerHub.

Please check the Bitnami Premium page in our partner [Arrow Electronics](https://www.arrow.com/globalecs/na/vendors/bitnami?utm_source=GitHub&utm_medium=containers) for more information.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami Notation Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/notation).

```console
docker pull bitnami/notation:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/notation/tags/) in the Docker Hub Registry.

```console
docker pull bitnami/notation:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of Notation, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull bitnami/notation:latest
```

#### Step 2: Remove the currently running container

```console
docker rm -v notation
```

#### Step 3: Run the new image

Re-create your container from the new image.

```console
docker run --name notation bitnami/notation:latest
```

## Configuration

### Running commands

To run commands inside this container you can use `docker run`, for example to execute `notation --help` you can follow the example below:

```console
docker run --rm --name notation bitnami/notation:latest --help
```

### Customize configuration file

You can import a custom configuration by setting a volume pointing to `/.config`:

```console
docker run -v $(pwd)/config:/.config bitnami/notation key ls
NAME              KEY PATH                                        CERTIFICATE PATH                                ID   PLUGIN NAME
* my-domain.com   /.config/notation/localkeys/my-domain.com.key   /.config/notation/localkeys/my-domain.com.crt
```

For doing that, the `config` folder should follow Notation [directory structure](https://notaryproject.dev/docs/user-guides/how-to/directory-structure/), for example:

```console
config
└── notation
    ├── config.json
    ├── localkeys
    │   ├── my-domain.com.crt
    │   └── my-domain.com.key
    ├── signingkeys.json
    └── truststore
        └── x509
            └── ca
                └── my-domain.com
                    └── my-domain.com.crt
```

Here a sample `signingkeys.json` based on the Notation [example](https://notaryproject.dev/docs/user-guides/how-to/notation-config-file/#sample-of-signingkeysjson):

```json
{
    "default": "my-domain.com",
    "keys": [
        {
            "name": "my-domain.com",
            "keyPath": "/.config/notation/localkeys/my-domain.com.key",
            "certPath": "/.config/notation/localkeys/my-domain.com.crt"
        }
    ]
}
```

### Generate a test key and self-signed certificate

The following command generates a test key and a self-signed X.509 certificate:

```console
docker run -v $(pwd)/config:/.config bitnami/notation \
    cert generate-test --default "my-domain.com"
generating RSA Key with 2048 bits
generated certificate expiring on 2023-10-19T10:31:41Z
wrote key: /.config/notation/localkeys/my-domain.com.key
wrote certificate: /.config/notation/localkeys/my-domain.com.crt
Successfully added my-domain.com.crt to named store my-domain.com of type ca
my-domain.com: added to the key list
my-domain.com: mark as default signing key
```

Confirm the signing key and certificate are correctly configured:

```console
docker run -v $(pwd)/config:/.config bitnami/notation key ls
NAME              KEY PATH                                        CERTIFICATE PATH                                ID   PLUGIN NAME
* my-domain.com   /.config/notation/localkeys/my-domain.com.key   /.config/notation/localkeys/my-domain.com.crt

docker run -v $(pwd)/config:/.config bitnami/notation cert ls
/.config/notation/truststore/x509/ca/my-domain.com/my-domain.com.crt
```

### Sign a container image

Assuming you have a registry in `registry.my-network` from which notation container has connectivity. If you are running a registry locally, you can create a docker network, for example by running `docker network create my-network`, and use that network whenever you need to access the registry from the notation container.

```console
docker inspect localhost:5000/<image-name>:v1 | grep RepoDigests -A1 | grep sha256 | cut -d\" -f2
localhost:5000/<image-name>@sha256:cab52de182d770cae8c3622eb5252a36fcdd24cfb33818a68a4f012c5c0a2d2a
```

In case you do not want to deal with HTTPS configuration, create a `config/notation/config.js` file with the following content:

```javascript
{
    "insecureRegistries": [
        "registry.my-network:5000"
    ]
}

```

Run the following command to sign a container image:

```console
docker run -v $(pwd)/config:/.config --network <network-name> \
    bitnami/notation sign registry.my-network:5000/<image-name>@sha256:073b75987e95b89f187a89809f08a32033972bb63cda279db8a9ca16b7ff555a
Successfully signed registry.my-network:5000/<image-name>@sha256:073b75987e95b89f187a89809f08a32033972bb63cda279db8a9ca16b7ff555a
```

Check that your signature has been created as expected:

```console
docker run -v $(pwd)/config:/.config --network <network-name> \
    bitnami/notation ls registry.my-network:5000/<image-name>@sha256:073b75987e95b89f187a89809f08a32033972bb63cda279db8a9ca16b7ff555a
registry.my-network:5000/<image-name>@sha256:073b75987e95b89f187a89809f08a32033972bb63cda279db8a9ca16b7ff555a
└── application/vnd.cncf.notary.signature
    └── sha256:528017e21fc9f8342d4a888ed91bb61031974814695001f453bb829517cfe931
```

Check the [official Notation documentation](https://notaryproject.dev/docs/quickstart-guides/quickstart/) for more information about how to use Notation.

## Notable Changes

### Starting January 16, 2024

* The `docker-compose.yaml` file has been removed, as it was solely intended for internal testing purposes.

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
