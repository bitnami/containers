# Bitnami Secure Image for ClickHouse Backup

> Tool for easy backup and restore for ClickHouse using object storage for backup files

[Overview of ClickHouse Backup](https://github.com/Altinity/clickhouse-backup)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name clickhouse-backup bitnami/clickhouse-backup:latest
```

## Why use Bitnami Secure Images?

- Bitnami Secure Images and Helm charts are built to make open source more secure and enterprise ready.
- Triage security vulnerabilities faster, with transparency into CVE risks using industry standard Vulnerability Exploitability Exchange (VEX), KEV, and EPSS scores.
- Our hardened images use a minimal OS (Photon Linux), which reduces the attack surface while maintaining extensibility through the use of an industry standard package format.
- Stay more secure and compliant with continuously built images updated within hours of upstream patches.
- Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
- Hardened images come with attestation signatures (Notation), SBOMs, virus scan reports and other metadata produced in an SLSA-3 compliant software factory.

Only a subset of BSI applications are available for free. Looking to access the entire catalog of applications as well as enterprise support? Try the [commercial edition of Bitnami Secure Images today](https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/).

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html).

## Get this image

The Bitnami ClickHouse Backup Docker image is only available to [Bitnami Secure Images](https://bitnami.com) customers.

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-work-with-non-root-containers-index.html).

## Configuration

The following section describes how to configure the application

### Running commands

To run commands inside this container, you can use `docker run`, for example to execute `clickhouse-backup --help` you can follow the example below:

```console
docker run --rm --name clickhouse-backup bitnami/clickhouse-backup:latest -- --help
```

Check the [official ClickHouse Backup documentation](https://github.com/Altinity/clickhouse-backup) for more information.

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
