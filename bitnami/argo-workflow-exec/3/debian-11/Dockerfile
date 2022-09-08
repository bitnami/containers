FROM docker.io/bitnami/minideb:bullseye

ARG TARGETARCH

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="3.3.9-debian-11-r9" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/argo-workflow-exec" \
      org.opencontainers.image.title="argo-workflow-exec" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="3.3.9"

ENV OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip jq procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f kubectl-1.23.10-1-linux-${OS_ARCH}-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/kubectl-1.23.10-1-linux-${OS_ARCH}-debian-11.tar.gz -O ; \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/kubectl-1.23.10-1-linux-${OS_ARCH}-debian-11.tar.gz.sha256 -O ; \
    fi && \
    sha256sum -c kubectl-1.23.10-1-linux-${OS_ARCH}-debian-11.tar.gz.sha256 && \
    tar -zxf kubectl-1.23.10-1-linux-${OS_ARCH}-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf kubectl-1.23.10-1-linux-${OS_ARCH}-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f gosu-1.14.0-154-linux-${OS_ARCH}-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/gosu-1.14.0-154-linux-${OS_ARCH}-debian-11.tar.gz -O ; \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/gosu-1.14.0-154-linux-${OS_ARCH}-debian-11.tar.gz.sha256 -O ; \
    fi && \
    sha256sum -c gosu-1.14.0-154-linux-${OS_ARCH}-debian-11.tar.gz.sha256 && \
    tar -zxf gosu-1.14.0-154-linux-${OS_ARCH}-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf gosu-1.14.0-154-linux-${OS_ARCH}-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f argo-workflow-exec-3.3.9-1-linux-${OS_ARCH}-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/argo-workflow-exec-3.3.9-1-linux-${OS_ARCH}-debian-11.tar.gz -O ; \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/argo-workflow-exec-3.3.9-1-linux-${OS_ARCH}-debian-11.tar.gz.sha256 -O ; \
    fi && \
    sha256sum -c argo-workflow-exec-3.3.9-1-linux-${OS_ARCH}-debian-11.tar.gz.sha256 && \
    tar -zxf argo-workflow-exec-3.3.9-1-linux-${OS_ARCH}-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf argo-workflow-exec-3.3.9-1-linux-${OS_ARCH}-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

COPY rootfs /
RUN /opt/bitnami/scripts/argo-workflow-exec/postunpack.sh
ENV APP_VERSION="3.3.9" \
    BITNAMI_APP_NAME="argo-workflow-exec" \
    PATH="/opt/bitnami/kubectl/bin:/opt/bitnami/common/bin:/opt/bitnami/argo-workflow-exec/bin:/opt/bitnami/argo-workflow-exec/hack:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/argo-workflow-exec/bin/argoexec" ]
CMD [ "help" ]
