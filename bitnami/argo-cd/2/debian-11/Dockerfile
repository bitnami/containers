FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="2.4.11-debian-11-r0" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/argo-cd" \
      org.opencontainers.image.title="argo-cd" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="2.4.11"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl git git-lfs gnupg gzip libc6 openssh-client procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f kustomize-4.5.7-2-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/kustomize-4.5.7-2-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "49f7301f564267ae9f7a89db86399f8c497180bbec7c097b9428ece71e1e6916  kustomize-4.5.7-2-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf kustomize-4.5.7-2-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf kustomize-4.5.7-2-linux-amd64-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f ksonnet-0.13.1-153-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/ksonnet-0.13.1-153-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "9a09e8c678994d62acd0070b03161423ef396389e6848ac50b529d2f29bd811a  ksonnet-0.13.1-153-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf ksonnet-0.13.1-153-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf ksonnet-0.13.1-153-linux-amd64-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f helm-3.9.4-1-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/helm-3.9.4-1-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "2f8d7916efa3f4c6005d08f9d68d1220c3f8960c0c1686d30245b70941827b7b  helm-3.9.4-1-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf helm-3.9.4-1-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf helm-3.9.4-1-linux-amd64-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f gosu-1.14.0-154-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/gosu-1.14.0-154-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "e36c3d90f4fbfbe989f40947fa7c8ab817f12fcf97d3aef893c753a20ce976ab  gosu-1.14.0-154-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf gosu-1.14.0-154-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf gosu-1.14.0-154-linux-amd64-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f argo-cd-2.4.11-1-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/argo-cd-2.4.11-1-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "13718c43bc4373541b164e4f12ced0bb67ff9ca53f13fd9fabb994d7c63c3db4  argo-cd-2.4.11-1-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf argo-cd-2.4.11-1-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf argo-cd-2.4.11-1-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/argo-cd/postunpack.sh
ENV APP_VERSION="2.4.11" \
    BITNAMI_APP_NAME="argo-cd" \
    PATH="/opt/bitnami/kustomize/bin:/opt/bitnami/ksonnet/bin:/opt/bitnami/helm/bin:/opt/bitnami/common/bin:/opt/bitnami/argo-cd/bin:/opt/bitnami/argo-cd/hack:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/argo-cd/entrypoint.sh" ]
CMD [ "argocd", "--help" ]
