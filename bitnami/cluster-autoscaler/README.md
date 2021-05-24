
# What is Cluster Autoscaler?

Cluster Autoscaler is a tool that automatically adjusts the size of the Kubernetes cluster when:

* There are pods that failed to run in the cluster due to insufficient resources.
* Some nodes in the cluster are so underutilized, for an extended period of time, that they can be deleted and their pods will be easily placed on some other, existing nodes.

[https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler](https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler)

# How to deploy Cluster Autoscaler in Kubernetes?

Cluster Autoscaler runs on the Kubernetes master node on most K8s cloud offerings.

> NOTE: It is possible to run customized Cluster Autoscaler inside of the cluster but then extra care needs to be taken to ensure that Cluster Autoscaler is up and running. User can put it into kube-system namespace (Cluster Autoscaler doesn't scale down node with non-manifest based kube-system pods running on them) and mark with scheduler.alpha.kubernetes.io/critical-pod annotation (so that the rescheduler, if enabled, will kill other pods to make space for it to run).

Currently, it is possible to run Cluster Autoscaler on:

* **AliCloud**: Consult [Cluster Autoscaler on AliCloud docs](https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler/cloudprovider/alicloud/README.md).
* **AWS**: Consult [Cluster Autoscaler on AWS docs](https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/README.md).
* **Azure**: Consult [Cluster Autoscaler on Azure docs](https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/azure/README.md).
* **GCE**: Consult [Cluster Autoscaler on GCE docs](https://kubernetes.io/docs/concepts/cluster-administration/cluster-management#upgrading-google-compute-engine-clusters).
* **GKE**: Consult [Cluster Autoscaler on GKE docs](https://cloud.google.com/container-engine/docs/cluster-autoscaler).

Please note that Cluster Autoscaler a series of permissions/privileges to adjusts the size of the K8s cluster. For instance, to run it on AWS, you need to:

* Provide the K8s worker node which runs the cluster autoscaler with a minimum IAM policy (check [permissions docs](https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler/cloudprovider/aws#permissions) for more information).
* Create a service account for Cluster Autoscaler's deployment and bind to it some roles and cluster roles that provide the corresponding RBAC privileges.

> NOTE: Find resources to deploy Cluster Autoscaler on AWS in the [aws-examples](./aws-examples) directory.

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released daily with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/cluster-autoscaler?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

# Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

# Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).


* [`1`, `1-debian-10`, `1.21.0`, `1.21.0-debian-10-r11`, `latest` (1/debian-10/Dockerfile)](https://github.com/bitnami/bitnami-docker-cluster-autoscaler/blob/1.21.0-debian-10-r11/1/debian-10/Dockerfile)

Subscribe to project updates by watching the [bitnami/cluster-autoscaler GitHub repo](https://github.com/bitnami/bitnami-docker-cluster-autoscaler).

# Get this image

The recommended way to get the Bitnami Cluster-autoscaler Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/cluster-autoscaler).

```console
$ docker pull bitnami/cluster-autoscaler:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/cluster-autoscaler/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/cluster-autoscaler:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/cluster-autoscaler:latest 'https://github.com/bitnami/bitnami-docker-cluster-autoscaler.git#master:1/debian-10'
```

# Configuration

## How to run a cluster with nodes in multiples zones for HA.

`--balance-similar-node-groups` flag is intended to support this use case. If you set the flag to true, Cluster Autoscaler will automatically identify node groups with the same instance type and the same set of labels (except for automatically added zone label) and try to keep the sizes of those node groups balanced.

This does not guarantee similar node groups will have exactly the same sizes:

Currently the balancing is only done at scale-up. Cluster Autoscaler will still scale down underutilized nodes regardless of the relative sizes of underlying node groups.

## How monitor Cluster Autoscaler?
Cluster Autoscaler provides metrics and livenessProbe endpoints. By default they're available on port 8085 (configurable with --address flag), respectively under /metrics and /health-check.

Metrics are provided in Prometheus format.

## How scale my cluster to just 1 node?
Prior to version 0.6, Cluster Autoscaler was not touching nodes that were running important kube-system pods like DNS, Heapster, Dashboard etc. If these pods landed on different nodes, CA could not scale the cluster down and the user could end up with a completely empty 3 node cluster. In 0.6, we added an option to tell CA that some system pods can be moved around. If the user configures a PodDisruptionBudget for the kube-system pod, then the default strategy of not touching the node running this pod is overridden with PDB settings. So, to enable kube-system pods migration, one should set minAvailable to 0 (or <= N if there are N+1 pod replicas.) See also I have a couple of nodes with low utilization, but they are not scaled down. Why?

## How scale a node group to 0?
For GCE/GKE and for AWS, it is possible to scale a node group to 0 (and obviously from 0), assuming that all scale-down conditions are met.

For AWS, if you are using nodeSelector, you need to tag the ASG with a node-template key "k8s.io/cluster-autoscaler/node-template/label/".

For example, for a node label of foo=bar, you would tag the ASG with:

```yaml
{
    "ResourceType": "auto-scaling-group",
    "ResourceId": "foo.example.com",
    "PropagateAtLaunch": true,
    "Value": "bar",
    "Key": "k8s.io/cluster-autoscaler/node-template/label/foo"
}
```

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-cluster-autoscaler/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-cluster-autoscaler/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-cluster-autoscaler/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container
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
