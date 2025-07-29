<!-- markdownlint-disable MD041 -->
<p align="center">
    <img width="400px" height=auto src="https://dyltqmyl993wv.cloudfront.net/bitnami/bitnami-by-vmware.png" />
</p>

<p align="center">
    <a href="https://twitter.com/bitnami"><img src="https://badgen.net/badge/twitter/@bitnami/1DA1F2?icon&label" /></a>
    <a href="https://github.com/bitnami/containers"><img src="https://badgen.net/github/stars/bitnami/containers?icon=github" /></a>
    <a href="https://github.com/bitnami/containers"><img src="https://badgen.net/github/forks/bitnami/containers?icon=github" /></a>
    <a href="https://github.com/bitnami/containers/actions/workflows/ci-pipeline.yml"><img src="https://github.com/bitnami/containers/actions/workflows/ci-pipeline.yml/badge.svg" /></a>
</p>

# The Bitnami Containers Library

Popular applications, provided by [Bitnami](https://bitnami.com), containerized and ready to launch.

## ⚠️ Important Notice: Upcoming changes to the Bitnami Catalog

Beginning August 28th, 2025, Bitnami will evolve its public catalog to offer a curated set of hardened, security-focused images under the new [Bitnami Secure Images initiative](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications). As part of this transition:

- Granting community users access for the first time to security-optimized versions of popular container images.
- Bitnami will begin deprecating support for non-hardened, Debian-based software images in its free tier and will gradually remove non-latest tags from the public catalog. As a result, community users will have access to a reduced number of hardened images. These images are published only under the “latest” tag and are intended for development purposes
- Starting August 28th, over two weeks, all existing container images, including older or versioned tags (e.g., 2.50.0, 10.6), will be migrated from the public catalog (docker.io/bitnami) to the “Bitnami Legacy” repository (docker.io/bitnamilegacy), where they will no longer receive updates.
- For production workloads and long-term support, users are encouraged to adopt Bitnami Secure Images, which include hardened containers, smaller attack surfaces, CVE transparency (via VEX/KEV), SBOMs, and enterprise support.

These changes aim to improve the security posture of all Bitnami users by promoting best practices for software supply chain integrity and up-to-date deployments. For more details, visit the [Bitnami Secure Images announcement](https://github.com/bitnami/containers/issues/83267).

## Why use Bitnami Secure Images?

- Bitnami Secure Images and Helm charts are built to make open source more secure and enterprise ready.
- Triage security vulnerabilities faster, with transparency into CVE risks using industry standard Vulnerability Exploitability Exchange (VEX), KEV, and EPSS scores.
- Our hardened images use a minimal OS (Photon Linux), which reduces the attack surface while maintaining extensibility through the use of an industry standard package format.
- Stay more secure and compliant with continuously built images updated within hours of upstream patches.
- Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
- Hardened images come with attestation signatures (Notation), SBOMs, virus scan reports and other metadata produced in an SLSA-3 compliant software factory.

Only a subset of BSI applications are available for free. Looking to access the entire catalog of applications as well as enterprise support? Try the [commercial edition of Bitnami Secure Images today](https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/).

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

> [!TIP]
> Remember to replace the `APP`, `VERSION`, and `OPERATING-SYSTEM` placeholders in the example command above with the correct values.

## Run the application using Docker Compose

The main folder of each application contains a functional `docker-compose.yml` file. Run the application using it as shown below:

```console
curl -sSL https://raw.githubusercontent.com/bitnami/containers/main/bitnami/APP/docker-compose.yml > docker-compose.yml
docker-compose up -d
```

> [!TIP]
> Remember to replace the `APP` placeholder in the example command above with the correct value.

## Vulnerability scan in Bitnami container images

As part of the release process, the Bitnami container images are analyzed for vulnerabilities. At this moment, we are using two different tools:

- [Trivy](https://github.com/aquasecurity/trivy)
- [Grype](https://github.com/anchore/grype)

This scanning process is triggered via a GH action for every PR affecting the source code of the containers, regardless of its nature or origin.

## Retention policy

Deprecated assets will be retained in the container registry ([Bitnami DockerHub org](https://hub.docker.com/u/bitnami)) without changes for, at least, 6 months after the deprecation.
After that period, all the images will be moved to a new _"archived"_ repository. For instance, once deprecated an asset named _foo_ whose container repository was `bitnami/foo`, all the images will be moved to `bitnami/foo-archived` where they will remain indefinitely.

Special images, like `bitnami/bitnami-shell` or `bitnami/sealed-secrets`, which are extensively used in Helm charts, will have an extended coexistence period of 1 year.

## Contributing

We'd love for you to contribute to those container images. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues/new/choose), or submit a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

## License

Copyright &copy; 2025 Broadcom. The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.

You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and limitations under the License.
