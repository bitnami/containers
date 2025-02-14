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

## Announcing General Availability of Bitnami Premium

### A new commercial version of Bitnami open source containers and Helm charts

Enterprises that love Bitnami can now purchase a Bitnami Premium subscription from [Arrow Electronics](https://www.arrow.com/globalecs/na/vendors/bitnami?utm_source=github&utm_medium=containers) and consume the containers and Helm charts right in Docker Hub. Bitnami Premium users will get access to private Docker Hub repositories with the same containers and Helm charts they are used to, plus new commercial features including:

* Enterprise support for all 500+ Bitnami Premium packages
* All LTS branches of all Bitnami application packages maintained up-to-date
* Unlimited pulls of all Bitnami Premium containers and Helm charts from Docker Hub
* Secure software supply chain metadata including Software Bills of Material (SBOMs), SLSA 3 pipeline validation with in-toto attestations, Notation and Cosign signatures, Build-time CVE and anti-virus scan reports, and more.
* Minimal application runtimes (Node.js, Python, Ruby, Java, ASP.NET, PHP) with comparable and often smaller size than distroless alternatives.

Alongside the launch of Bitnami Premium, we are making some changes to how we deliver the Bitnami Application Catalog:

* Unlimited pulls from Docker Hub will no longer be available. Free Bitnami Application Catalog containers and charts will be subject to the same limits as any other Docker Hub repos starting December 16th, 2024. Pulls of Bitnami Premium containers and Helm charts will not count towards your [Docker Hub pull](https://hub.docker.com/usage/pulls) limits or overages.
* Long-term-support (LTS) branches of the software we package will no longer be maintained in the free Bitnami Application Catalog. To continue receiving updates for LTS branches of packages, you will have to upgrade to Bitnami Premium.
* We are improving Bitnami Application Catalog users’ supply chain security through additional integrity checks in our Helm chart installation process. These checks enable users to be aware when they are using containers that were not created and tested by Bitnami.

These changes enable us to deliver a premium Bitnami experience to our enterprise users who will benefit from support and security metadata, but who do not need the extensive customization that is core to our other commercial offering called [Tanzu Application Catalog](https://www.vmware.com/products/app-platform/tanzu-application-catalog) (TAC). We are committed to continue delivering free Bitnami Application Catalog content to our community of developers and other open source project maintainers over the long term.

Read on to learn more about Bitnami Premium and the coming changes to the free Bitnami Application Catalog content.

### New goodness in Bitnami Premium

Bitnami Premium is a new version of the content packaged by Bitnami that is sold through [Arrow Electronics](https://www.arrow.com/globalecs/na/vendors/bitnami?utm_source=github&utm_medium=containers). You can connect to an Arrow salesperson if you have any questions or want to purchase access. Once you buy Bitnami Premium, you will be given access to the Bitnami Premium registries in Docker Hub. You can then return to Docker Hub where you will have access to the Bitnami Premium containers, Helm charts, and software supply chain metadata from the new **/bitnamiprem** and **/bitnamichartsprem** orgs. These private repos are what enable you to pull without limits or caps. You will also see containers for all LTS branches continuously maintained up-to-date: for example, you will see PostgreSQL containers for versions 12, 13, 14, 15, 16, and 17; while in the free Bitnami catalog, you will only find version 17.

#### A middle ground between free Bitnami Application Catalog and Tanzu Application Catalog customized packages

In Bitnami Premium, all of the applications are built on Debian just as they are in the free Bitnami library. You get the entire library of containers and Helm charts kept up-to-date with the latest changes anywhere in each app from the OS to the application code itself. You can consume the content through Docker Hub where you’ve already been pulling it to date. However, in the Bitnami Premium registries, you will also find important software supply chain security metadata delivered as OCI artifacts alongside the containers and Helm charts. This metadata is useful for enterprises that need third-party open source software to be compliant with policies around auditability, supply chain integrity, and time to remediation of vulnerabilities.

* **Supply chain security and integrity**: Bitnami Premium containers and Helm charts are built on an SLSA 3 pipeline, with attestations and signatures serving as proof that the software you’re deploying in your clusters is what you expect and has not been tampered with.
* **Software bills of material (SBOMs)**: At both the Helm chart and container levels, SBOMs give you fine-grained insight into the contents of every package. Bitnami Premium also includes build-time CVE scans and anti-virus reports (helpful for our Federal government customers). This will make it far easier to continuously validate the integrity of software supply chains and to track and triage vulnerabilities as they are discovered and patched.
* **Build time CVE scans, anti-virus scans, and more**: also included with Bitnami Premium content are Trivy CVE scan results and ClamAV scan results that satisfy requirements for, among other things, doing business with the US Federal government. You will also find the results of Bitnami’s automated functional tests that run as part of every artifact update, trigger information that specifies why the latest update was released, and more.

Bitnami Premium differs from Tanzu Application Catalog in that, just like our free Bitnami content, it is a one-size-fits-all library of containers and Helm charts all built on Debian. Tanzu Application Catalog gives you the ability to customize your artifacts along many different dimensions. Some of the key differences include:

* **Private delivery**: TAC containers and Helm charts are delivered directly to your private registries, or are hosted in a private registry maintained by us that you can pull from.
* **Choose a Linux distro or use your own “golden image”**: TAC gives you the ability to choose among four supported Linux distros: Debian, Ubuntu, RedHat UBI, or VMware’s own PhotonOS. All of the software packages on these distributions are maintained up-to-date and are tested to work in multiple Kubernetes environments as part of the release process. You can also use your own golden image: we’ll build and maintain the artifacts on top of it. For customers that need it, PhotonOS includes FIPS OpenSSL, is STIG-compliant, and includes zero/minimal CVES with VEX statements to triage any remaining ones.
* **App-specific customization**: With TAC, you can inject your own customizations such as user settings, certificates, or plugins into our SLSA 3 pipeline, so the artifacts you receive are truly promotable to production environments.
* **Software knowledge graph**: This keeps track of all your software dependencies at the individual package level. It continuously scans them for vulnerabilities, and organizes them into a searchable graph database so you can see in real-time which versions of which apps are affected and patched. It also includes useful information such as open source licenses, package management ecosystem data, and more.
* **UI and API**: TAC includes access to a user interface where you can add and remove applications from your catalog, and interact with the software knowledge graph to see at-a-glance details about your software. The [TAC API](https://developer.broadcom.com/xapis/application-catalog/latest/) enables you to build information from the software knowledge graph into your pipelines to ensure you are keeping your applications up-to-date with the latest patched applications.

#### Minimal application runtimes

Both Bitnami Premium and TAC ship include a set of minimal application runtimes built with only minimal set of dependencies required to run applications in different programming languages. Bitnami Premium minimal application runtimes are based on Debian 12, whereas TAC includes Debian 12 and Photon OS based container images for all the supported programming languages (.NET, Node.js, Java, PHP, Python and Ruby). A scratch-like static container image which is only 3Mb in size and a glibc based container image complete both of this products giving your teams options to run both dynamically and statically compiled applications built in languages like C/C++, Golang or Rust, amongst others. These minimal application runtimes are much smaller in size than their traditional alternatives, have much fewer CVEs and have a smoother maintenance lifecycle due to the minimal dependencies. There are more details about the topic in [this announcement](https://blogs.vmware.com/tanzu/introducing-minimal-application-runtimes-in-tanzu-application-catalog-and-bitnami-premium/).

### Continuing our long tradition of partnerships

Since Bitnami’s beginning over a decade ago, our many partnerships have propelled us to be a leading publisher of open source software. Bitnami cloud images drive billions of compute hours annually for our hyperscale cloud partners, for example, and our containers and Helm charts are pulled hundreds of millions of times per month from our partners at Docker Hub.

We now begin our newest endeavor with [Arrow Electronics](https://www.arrow.com/globalecs/na/vendors/bitnami?utm_source=github&utm_medium=containers). Arrow is a global leader in IT distribution. Arrow is known for its ability to help businesses navigate the complexities of modern IT landscapes, providing the tools, technology, and expertise needed to drive digital transformation and operational efficiency.

Arrow will sell Bitnami Premium access through its website. Bitnami users interested in purchasing Bitnami Premium will find a streamlined process to pay, share their Docker Hub user identification, and gain access to the private Bitnami Premium repos in Docker Hub. Bitnami Premium customers can add and remove users through Arrow's support team, as well as submit tickets for enterprise support jointly delivered by the software packaging experts at Arrow and Bitnami.

### What changes are coming for the free Bitnami library?

#### Pull limits for free Bitnami content

Beginning December 16th, 2024, the Bitnami Application Catalog will use [standard Docker Hub pull rate limits](https://docs.docker.com/docker-hub/download-rate-limit/) for Bitnami apps. Enterprise customers will be able to access the full Bitnami library in Bitnami Premium, purchased through Arrow and consumed right in Docker Hub, with no rate limits or restrictions. Note that we are not changing any licenses for our packages, meaning that projects can continue to bundle our Helm charts and containers in their own application packages.

#### Long Term Support version updates

Many open source projects we publish packages for have multiple LTS versions supported by their communities. Currently, Bitnami maintains all of these LTS versions up-to-date. Starting December 10th, 2024, we will only continue updating the latest version available for apps in the free Bitnami Application Catalog. This will enable OSS projects and individual/small businesses to continue using the latest versions of Bitnami applications. Bitnami Premium customers who need to continue pulling up-to-date versions of LTS branches can access them in the Bitnami Premium repo in Docker Hub.

#### Supply chain integrity check in Bitnami Helm charts

Bitnami has invested hundreds of thousands of developer hours in constructing a world-leading pipeline to build, monitor, update, and test open source software in multiple Kubernetes environments. For these Helm charts to perform as intended, and for them to leverage the many security features built-in, they need to deploy the Bitnami containers they were designed to work with. Therefore, we are adding new checks in the deployment process to check that the containers they were designed to deploy are the ones being deployed.

### Keep an eye out for more updates

We are excited to deliver an enhanced experience for [Bitnami Premium](https://www.arrow.com/globalecs/na/vendors/bitnami?utm_source=github&utm_medium=containers) users, but this is just the beginning. We will continue to build on the value that all of our Bitnami community members, both free and paid, realize through our many years of experience publishing high-quality open source software packages for the world’s developers.

Keep abreast of our blog for new updates and features, and be sure to check to follow us on [X (formerly Twitter)](https://x.com/bitnami) and [LinkedIn](https://www.linkedin.com/company/bitnami/).

## Vulnerability scan in Bitnami container images

As part of the release process, the Bitnami container images are analyzed for vulnerabilities. At this moment, we are using two different tools:

* [Trivy](https://github.com/aquasecurity/trivy)
* [Grype](https://github.com/anchore/grype)

This scanning process is triggered via a GH action for every PR affecting the source code of the containers, regardless of its nature or origin.

## Changes in version support and pull-rate limits in Docker Hub for BItnami containers and Helm charts 

Following the release of Bitnami Premium, we are making some changes in the way we distribute our free catalog. These changes enable us to sustain a viable business while also continuing to serve our community, including other open source projects, with free, high-quality software packages. 

Beginning on December 16th, 2024, Bitnami will no longer subsidize unlimited pulls from the free Bitnami catalog in Docker Hub. Bitnami containers and charts will be subject to standard pull-rate limits and pull caps. Users who upgrade to Bitnami Premium will be able to pull without any limitations on pull rate or pulls per time period, regardless of the type of Docker subscription you have.

Also on December 10t,h 2024, only the latest stable branch of any container will receive updates in the free Bitnami catalog. Suppose you use a branch of any Bitnami container other than the latest stable. In that case, you can either migrate to the latest stable branch or upgrade to Bitnami Premium to pull the most up-to-date images of all upstream-supported branches. Previous versions already released will not be deleted. They are still available to pull from DockerHub.

We have partnered with Arrow Electronics as the exclusive vendor of Bitnami Premium. When you purchase a Bitnami Premium subscription through ArrowSphere Marketplace, you will be granted access to the /bitnamiprem and /bitnamichartsprem distribution registries in Docker Hub. To learn more, visit [https://www.arrow.com/globalecs/na/vendors/bitnami](https://www.arrow.com/globalecs/na/vendors/bitnami?utm_source=github&utm_medium=containers).

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
