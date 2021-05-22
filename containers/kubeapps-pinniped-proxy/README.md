# What is Kubeapps Pinniped Proxy?

> Kubeapps Pinniped-Proxy is one of the main components of Kubeapps, a web-based application for deploying and managing applications in Kubernetes clusters.
>
> This component proxies incoming requests with an `Authorization: Bearer token` header, exchanging the token via the pinniped aggregate API for x509 short-lived client certificates, before forwarding the request onwards to the destination k8s API server.
>
> It is used to ensure OIDC requests for the Kubernetes API server are forwarded through only after exchanging the OIDC id token for client certificates used by the Kubernetes API server, for situations where the Kubernetes API server is not configured for OIDC.

[https://kubeapps.com/](https://kubeapps.com/)

# TL;DR

```console
$ docker run --name kubeapps-pinniped-proxy bitnami/kubeapps-pinniped-proxy:latest
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.

> This [CVE scan report](https://quay.io/repository/bitnami/kubeapps-pinniped-proxy?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# How to deploy Kubeapps Pinniped Proxy in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Kubeapps Chart GitHub repository](https://github.com/bitnami/charts/tree/master/bitnami/kubeapps).

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`2`, `2-debian-10`, `2.3.2`, `2.3.2-debian-10-r21`, `latest` (2/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-kubeapps-pinniped-proxy/blob/2.3.2-debian-10-r21/2/debian-10/Dockerfile)

# Configuration

For further documentation, please check [here](https://github.com/kubeapps/kubeapps/tree/master/cmd/pinniped-proxy).

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-kubeapps-pinniped-proxy/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-kubeapps-pinniped-proxy/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-kubeapps-pinniped-proxy/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright (c) 2021 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
