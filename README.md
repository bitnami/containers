<p align="center">
    <img width="400px" height=auto src="https://bitnami.com/downloads/logos/bitnami-by-vmware.png" />
</p>

<p align="center">
    <a href="https://twitter.com/bitnami"><img src="https://badgen.net/badge/twitter/@bitnami/1DA1F2?icon&label" /></a>
    <a href="https://github.com/bitnami/containers"><img src="https://badgen.net/github/stars/bitnami/containers?icon=github" /></a>
    <a href="https://github.com/bitnami/containers"><img src="https://badgen.net/github/forks/bitnami/containers?icon=github" /></a>
    <a href="https://github.com/bitnami/containers/actions/workflows/ci-pipeline.yml"><img src="https://github.com/bitnami/containers/actions/workflows/ci-pipeline.yml/badge.svg" /></a>
</p>

# The Bitnami Containers Library

Popular applications, provided by [Bitnami](https://bitnami.com), containerized and ready to launch.

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines, and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian-based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released regularly with the latest distribution packages available.

Looking to use our applications in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Get an image

The recommended way to get any of the Bitnami Images is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/).

```console
docker pull bitnami/APP
```

To use a specific version, you can pull a versioned tag.

```console
docker pull bitnami/APP:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile, and executing the `docker build` command.

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP .
```

> Remember to replace the `APP`, `VERSION`, and `OPERATING-SYSTEM` placeholders in the example command above with the correct values.

## Run the application using Docker Compose

The main folder of each application contains a functional `docker-compose.yml` file. Run the application using it as shown below:

```console
curl -sSL https://raw.githubusercontent.com/bitnami/containers/main/bitnami/APP/docker-compose.yml > docker-compose.yml
docker-compose up -d
```

> Remember to replace the `APP` placeholder in the example command above with the correct value.

## Vulnerability scan in Bitnami container images

As part of the release process, the Bitnami container images are analyzed for vulnerabilities. At this moment, we are using two different tools:

* [Trivy](https://github.com/aquasecurity/trivy)
* [Grype](https://github.com/anchore/grype)

This scanning process is triggered via a GH action for every PR affecting the source code of the containers, regardless of its nature or origin.

## Retention policy

Deprecated assets will be retained in the container registry ([Bitnami DockerHub org](https://hub.docker.com/u/bitnami)) without changes for, at least, 6 months after the deprecation.
After that period, all the images will be moved to a new _"archived"_ repository. For instance, once deprecated an asset named _foo_ whose container repository was `bitnami/foo`, all the images will be moved to `bitnami/foo-archived` where they will remain indefinitely.

Special images, like `bitnami/bitnami-shell` or `bitnami/sealed-secrets`, which are extensively used in Helm charts, will have an extended coexistence period of 1 year.

## Contributing

We'd love for you to contribute to those container images. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues/new/choose), or submit a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

## License

Copyright &copy; 2024 Broadcom. The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.

You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and limitations under the License.
