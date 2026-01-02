# SCT Software Fork of the Bitnami Containers Library

SCT's fork of popular applications, provided by [Bitnami](https://bitnami.com), containerized and ready to launch.

## Why this Fork Exists

This fork exists as a means for our organization to remain operational after Bitnami licensing changes. As a smaller organization, SCT cannot absorb the licensing cost for the Bitnami Secure Images Initiative, as we are only using a small subset of the functionality. We will therefore work to build these containers on our own and publish for our own use. We are grateful to Bitnami for leaving the source available for organizations like ours to undertake the process, rather than losing access entirely. We will continue to hope for a licensing option that allows us to purchase the product, and we will continue to contribute upstream where opportunities arise.

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

In SCT's case, these changes extend to:

- Disabling existing GitHub Actions / CI processes that are not required to meet our needs
- Additional, simplified CI processes that allow us to build the applicable containers and publish them to our private GitHub Packages feed for our use.

Our goal is to otherwise keep the upstream repository entirely as-is.

## License

Copyright &copy; 2026 Broadcom. The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.

You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and limitations under the License.
