[![CircleCI](https://circleci.com/gh/bitnami/bitnami-docker-open-service-broker-azure/tree/master.svg?style=shield)](https://circleci.com/gh/bitnami/bitnami-docker-open-service-broker-azure/tree/master)

# What is Open Service Broker Azure?

Open Service Broker for Azure is the open source, [Open Service Broker](https://www.openservicebrokerapi.org/)-compatible API server that provisions managed services in the Microsoft Azure public cloud.

# Prerequisites

In order to use the charts in this repository, you must have the following components installed:

1. A compatible [Kubernetes](https://github.com/kubernetes/kubernetes) cluster
(version 1.7 or later)
1. [Helm](https://github.com/kubernetes/helm)
1. [Kubernetes Service Catalog](https://github.com/kubernetes-incubator/service-catalog)
1. [Open Service Broker for Azure](https://github.com/azure/open-service-broker-azure)

This document describes how to install all these pre-requisities.

# ENV Vars

Remember that you need to provide these ENVs:


 - AZURE_SUBSCRIPTION_ID
 - AZURE_TENANT_ID
 - AZURE_CLIENT_ID
 - AZURE_CLIENT_SECRET

# Step 1: Create a Compatible Kubernetes Cluster

Please choose your preferred Kubernetes installation method below.

## Minikube

If you are using [Minikube](https://github.com/kubernetes/minikube), ensure that you
are using version [v0.22.0](https://github.com/kubernetes/minikube/releases/tag/v0.22.0) or
above, and simply execute the following to start your Kubernetes cluster:


```console
minikube start --extra-config=apiserver.Authorization.Mode=RBAC
```

Note: If you're using
[v0.23.0](https://github.com/kubernetes/minikube/releases/tag/v0.23.0),
execute the following after you install Minikube:

```console
kubectl create clusterrolebinding cluster-admin:kube-system \
       --clusterrole=cluster-admin \
       --serviceaccount=kube-system:default
```


## ACS Engine

If you are using [acs-engine](https://github.com/Azure/acs-engine) to install a cluster, run
the below command from the root of this repository.

_Note: make sure you update `keyData` and `servicePrincipalProfile` in the
given `acs-engine-kubernetes-config.json` file_

```console
acs-engine deploy \
    --subscription-id $SUB_ID \
    --dns-prefix $DNS_PREFIX \
    --location westus2 \
    --auto-suffix \
    --api-model docs/service-catalog/acs-engine-kubernetes-config.json
```

In the above command, `SUB_ID` is the ID for your Azure subscription and `DNS_PREFIX` is
a unique string that will prefix all cluster related DNS entries (to avoid collisions
with other clusters).

This command will generate a series of Kubernetes configuration files, named
according to the Azure region. Choose the one named for the region into which
you installed your cluster (by default, the new cluster will be installed
into the subscription's default region) and merge it into your
standard kubeconfig file.

Here's an easy way to do that merge:

```console
KUBECONFIG=$KUBECONFIG_PATH:_output/$CLUSTER_NAME/kubeconfig/kubeconfig.$REGION.json \
    kubectl config view --flatten > $KUBECONFIG_PATH
```

## Azure Container Service (AKS)

If you would like to use Service Catalog and Open Service Broker for Azure with
AKS, create a cluster as outlined in the AKS [quickstart](https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough).

# Step 2: Initialize Helm on the Cluster

Installing Service Catalog and Open Service Broker for Azure is accomplished
using Helm. If you created your Kubernetes cluster using `acs-engine` in the previous step,
Helm is already installed. However, you may need to upgrade the Tiller
component. To check the version, use the `helm version` command. You need
helm version `2.7.0` or later in order to install Service Catalog and Open
Service Broker for Azure. If you need to upgrade Helm, you can upgrade Tiller
by executing the following command:

```console
helm init --upgrade
```

Otherwise, you'll need to install the Helm componentry onto your cluster
yourself.

If you are using Minikube, run the following commands to complete the installation:

```console
kubectl create -f https://raw.githubusercontent.com/Azure/helm-charts/master/docs/prerequisities/helm-rbac-config.yaml
helm init --service-account tiller
```

Note: Currently, AKS does not support Role Based Access Control (RBAC).
If you are using AKS, you will need to install Helm without RBAC:

```console
helm init
```


# Step 3: Install Service Catalog

After you've successfully installed your Kubernetes cluster and installed Helm,
you'll need to install Service Catalog.

To install Service Catalog on an AKS cluster, execute the following commands:

```console
helm repo add svc-cat https://svc-catalog-charts.storage.googleapis.com
helm install svc-cat/catalog --name catalog --namespace catalog --set rbacEnable=false
```
Note: when using AKS, you must disable RBAC as shown above.

Otherwise, execute the following commands:

```console
helm repo add svc-cat https://svc-catalog-charts.storage.googleapis.com
helm install svc-cat/catalog --name catalog --namespace catalog
```

_If you'd like a more advanced installation, see the
[Service Catalog installation documentation](https://github.com/kubernetes-incubator/service-catalog/blob/master/docs/install.md)._

#### Service Catalog CLI

Once you've installed the prerequisites, you'll need the Service Catalog CLI, svcat,
installed to introspect the Kubernetes cluster. Please refer to the
[CLI installation instructions](https://github.com/kubernetes-incubator/service-catalog/blob/master/docs/install.md#installing-the-service-catalog-cli)
for details on how to install it onto your machine.

#### Helm Chart

Use [Helm](https://helm.sh) to install Open Service Broker for Azure onto your Kubernetes
cluster. Refer to the OSBA [Helm chart](https://github.com/Azure/helm-charts/tree/master/open-service-broker-azure)
for details on how to complete the installation.

### Provisioning

With the Kubernetes Service Catalog software and Open Service Broker for Azure both
installed on your Kubernetes cluster, try creating a `ServiceInstance` resource
to see service provisioning in action.

The following will provision PostgreSQL on Azure:

```console
$ kubectl create -f contrib/k8s/examples/postgresql/postgresql-instance.yaml
```

After the `ServiceInstance` resource is submitted, you can view its status:

```console
$ svcat get instance example-postgresql-all-in-one-instance
```

You'll see output that includes a status indicating that asynchronous
provisioning is ongoing. Eventually, that status will change to indicate
that asynchronous provisioning is complete.

### Binding

Upon provision success, bind to the instance:

```console
$ kubectl create -f contrib/k8s/examples/postgresql/postgresql-binding.yaml
```

To check the status of the binding:

```console
$ svcat get binding example-postgresql-all-in-one-binding
```

You'll see some output indicating that the binding was successful. Once it is,
a secret named `my-postgresql-secret` will be written that contains the database
connection details in it. You can observe that this secret exists and has been
populated:

```console
$ kubectl get secret example-postgresql-all-in-one-secret -o yaml
```

This secret can be used just as any other.

### Unbinding

To unbind:

```console
$ kubectl delete servicebinding my-postgresqldb-binding
```

Observe that the secret named `my-postgresqldb-secret` is also deleted:

```console
$ kubectl get secret my-postgresqldb-secret
Error from server (NotFound): secrets "my-postgresqldb-secret" not found
```

### Deprovisioning

To deprovision:

```console
$ kubectl delete serviceinstance my-postgresqldb-instance
```

You can observe the status to see that asynchronous deprovisioning is ongoing:

```console
$ svcat get instance my-postgresqldb-instance
```

# Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* Bitnami images are built on CircleCI and automatically pushed to the Docker Hub.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading linux distribution.

# Get this image

The recommended way to get the Bitnami Open Service Broker Azure Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/open-service-broker-azure).

```bash
$ docker pull bitnami/open-service-broker-azure:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/open-service-broker-azure/tags/) in the Docker Hub Registry.

```bash
$ docker pull bitnami/open-service-broker-azure:[TAG]
```

If you wish, you can also build the image yourself.

```bash
$ docker build -t bitnami/open-service-broker-azure:latest https://github.com/bitnami/bitnami-docker-open-service-broker-azure.git
```

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-open-service-broker-azure/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-open-service-broker-azure/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-open-service-broker-azure/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License
Copyright 2018 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
