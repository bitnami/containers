FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl git git-lfs gnupg gzip libc6 procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "kustomize" "4.5.5-151" --checksum 03e1413bed0ba2d68e2cba2e0a1a7d319dd635034d625220bd66c7c40b77c575
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ksonnet" "0.13.1-151" --checksum aae808c3b053381c23ca11ce24303a489129ff509c827f25e1ba4fce2797bb40
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "helm" "3.9.1-1" --checksum aa15a6446a00db4e6f300171fc300869d3f99163788dd73a6c13e0f202a4e230
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-152" --checksum 0c751c7e2ec0bc900a19dbec0306d6294fe744ddfb0fa64197ba1a36040092f0
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "argo-cd" "2.4.7-0" --checksum f414ed51bc626b748f017f01e9f66d0e7d87d5ff377b8f62cc95c718b0edde09
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/argo-cd/postunpack.sh
ENV APP_VERSION="2.4.7" \
    BITNAMI_APP_NAME="argo-cd" \
    PATH="/opt/bitnami/kustomize/bin:/opt/bitnami/ksonnet/bin:/opt/bitnami/helm/bin:/opt/bitnami/common/bin:/opt/bitnami/argo-cd/bin:/opt/bitnami/argo-cd/hack:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/argo-cd/entrypoint.sh" ]
CMD [ "argocd", "--help" ]
