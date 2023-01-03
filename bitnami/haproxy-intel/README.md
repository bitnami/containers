# HAProxy for Intel packaged by Bitnami

## What is HAProxy for Intel?

> HAProxy is a high-performance, open-source load balancer and reverse proxy for TCP and HTTP applications. This image is optimized with Intel&reg; QuickAssist Technology OpenSSL* Engine (QAT_Engine).

[Overview of HAProxy for Intel](https://www.haproxy.org/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
$ docker run --name haproxy bitnami/haproxy-intel:latest
```

## Why use Intel optimized containers

Optimized containers fully leverage 3rd gen Intel(R) Xeon(R) Scalable Processor (Ice Lake) cores and architecture. Intel(R) AVX-512 instructions have been further improved to accelerate performance for HPC/AI across a diverse set of workloads, including 3D modeling, scientific simulation, financial analytics, machine learning, and AI, image processing, visualization, digital content creation, and data compression. This wider vectorization speeds computation processes per clock, increasing frequency over the prior generation. New instructions, coupled with algorithmic and software innovations, also deliver breakthrough performance for the industry's most widely deployed cryptographic ciphers. Security is becoming more pervasive with most organizations increasingly adopting encryption for application execution, data in flight, and data storage.

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [minideb](https://github.com/bitnami/minideb) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* All Bitnami images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.


> This [CVE scan report](https://quay.io/repository/bitnami/haproxy-intel?tab=tags) contains a security report with all open CVEs. To get the list of actionable security issues, find the "latest" tag, click the vulnerability report link under the corresponding "Security scan" field and then select the "Only show fixable" filter on the next page.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Get this image

The recommended way to get the Bitnami HAProxy for Intel Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/haproxy-intel).

```console
$ docker pull bitnami/haproxy-intel:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/haproxy-intel/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/haproxy-intel:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
$ git clone https://github.com/bitnami/containers.git
$ cd bitnami/APP/VERSION/OPERATING-SYSTEM
$ docker build -t bitnami/APP:latest .
```

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

## Configuration

In order for the container to work, you need to mount your custom `haproxy.cfg` file in `/bitnami/haproxy/conf/`. The following example runs HAProxy for Intel with a custom configuration file:

```console
$ docker run --rm --name haproxy \
    --cpuset-cpus 0-7 \
    -v <TLS_key_local_path>:/etc/ssl/certs/tls.pem \
    -v <configuration_file_local_path>:/bitnami/haproxy/conf/haproxy.cfg \
    bitnami/haproxy-intel:latest
```

The following is an example of a configuration file:

```
global
    nbthread <number>
    cpu-map 1/1-<number> 0-<number-1>
    master-worker
    insecure-fork-wanted
    tune.ssl.default-dh-param 2048
    ssl-default-bind-ciphers ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256
    ssl-default-bind-options ssl-min-ver TLSV1.2 no-tls-tickets
    ssl-engine qatengine
    ssl-mode-async
```

Where some of the options used are:

```
nbthread <number>
    It makes HAProxy run on <number> threads. "nbthread" works when HAProxy is started
    eather in  foreground or background.
    On some platforms supporting CPU affinity, the default "nbthread" value is automatically
    set to the number of CPUs the process is bound to upon startup.

cpu-map [auto:]<process-set>[/<thread-set>] <cpu-set>...
    It is possible to bind a process or a thread to a specific CPU set. This means
    that the process or the thread will never run on other CPUs. The "cpu-map"
    directive specifies CPU sets for process or thread sets.
    <number> must be a number between 1 and the maximum core numbers in the system.
    It is possible to specify a range with two such number delimited by
    a dash ('-'). Each CPU set is either a unique number starting at 0 for the first
    CPU or a range with two such numbers delimited by a dash ('-').
    Ranges can be partially defined. The higher bound can be omitted. In such
    case, it is replaced by the corresponding maximum value in the system.
    The prefix "auto:" can be added before the process set to let HAProxy
    automatically bind a process or a thread to a CPU by incrementing threads and
    CPU sets.

insecure-fork-wanted
    By default HAProxy tries hard to prevent any thread and process creation after it starts.
    Due to QAT software requires the creation of threads in the background,
    when running in non-root mode, this option will disable this protection.
```
Check the [official HAProxy for Intel documentation](http://cbonte.github.io/haproxy-intel-dconv/2.5/configuration.html) to understand the possible configurations.

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues) or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/containers/issues/new/choose). For us to provide better support, be sure to fill the issue template.

## License

Copyright &copy; 2023 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
