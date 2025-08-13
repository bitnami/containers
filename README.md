# SCT Software Fork of the Bitnami Containers Library

SCT's fork of popular applications, provided by [Bitnami](https://bitnami.com), containerized and ready to launch.

## Why this Fork Exists

This fork exists as a means for our organization to remain operational after Bitnami licensing changes. As a smaller organization, SCT cannot absorb the licensing cost for the Bitnami Secure Images Initiative, as we are only using a small subset of the functionality. We will therefore work to build these containers on our own and publish for our own use. We are grateful to Bitnami for leaving the source available for organizations like ours to undertake the process, rather than losing access entirely. We will continue to hope for a licensing option that allows us to purchase the product, and we will continue to contribute upstream where opportunities arise.

## ⚠️ Changes to the Bitnami Catalog

Below is the original announcement from Bitnami from late July 2025, which was included in the upstream repository.

>Beginning August 28th, 2025, Bitnami will evolve its public catalog to offer a curated set of hardened, security-focused images under the new [Bitnami Secure Images initiative](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications). As part of this transition:
>
>- Granting community users access for the first time to security-optimized versions of popular container images.
>- Bitnami will begin deprecating support for non-hardened, Debian-based software images in its free tier and will gradually remove non-latest tags from the public catalog. As a result, community users will have access to a reduced number of hardened images. These images are published only under the “latest” tag and are intended for development purposes
>- Starting August 28th, over two weeks, all existing container images, including older or versioned tags (e.g., 2.50.0, 10.6), will be migrated from the public catalog (docker.io/bitnami) to the “Bitnami Legacy” repository (docker.io/bitnamilegacy), where they will no longer receive updates.
>- For production workloads and long-term support, users are encouraged to adopt Bitnami Secure Images, which include hardened containers, smaller attack surfaces, CVE transparency (via VEX/KEV), SBOMs, and enterprise support.
>
>These changes aim to improve the security posture of all Bitnami users by promoting best practices for software supply chain integrity and up-to-date deployments. For more details, visit the [Bitnami Secure Images announcement](https://github.com/bitnami/containers/issues/83267).

## More Information / Guidance

For additional instructions and information, please see the upstream repository: <https://github.com/bitnami/containers>

## Significant Changes

In compliance with the Apache 2.0 license, we are required to state any significant changes to the software.

In SCT's case, these changes extend to:

- Disabling existing GitHub Actions / CI processes that are not required to meet our needs
- Additional, simplified CI processes that allow us to build the applicable containers and publish them to our private GitHub Packages feed for our use.

Our goal is to otherwise keep the upstream repository entirely as-is.

## License

Copyright &copy; 2025 Broadcom. The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.

You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and limitations under the License.
