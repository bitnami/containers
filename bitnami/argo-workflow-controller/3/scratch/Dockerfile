FROM bitnami/minideb:bullseye as builder

ARG TARGETARCH

ENV OS_ARCH="${TARGETARCH:-amd64}"

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates curl
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f argo-workflow-controller-3.4.1-0-linux-${OS_ARCH}-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/argo-workflow-controller-3.4.1-0-linux-${OS_ARCH}-debian-11.tar.gz -O ; \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/argo-workflow-controller-3.4.1-0-linux-${OS_ARCH}-debian-11.tar.gz.sha256 -O ; \
    fi && \
    sha256sum -c argo-workflow-controller-3.4.1-0-linux-${OS_ARCH}-debian-11.tar.gz.sha256 && \
    tar -zxf argo-workflow-controller-3.4.1-0-linux-${OS_ARCH}-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf argo-workflow-controller-3.4.1-0-linux-${OS_ARCH}-debian-11.tar.gz argo-workflow-controller-3.4.1-0-linux-${OS_ARCH}-debian-11.tar.gz.sha256

######

FROM scratch

ARG TARGETARCH

ENV OS_ARCH="${TARGETARCH:-amd64}"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="3.4.1-scratch-r0" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/argo-workflow-controller" \
      org.opencontainers.image.title="argo-workflow-controller" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="3.4.1"

COPY prebuildfs /
COPY rootfs /
COPY --from=builder /opt/bitnami/argo-workflow-controller/bin/workflow-controller /workflow-controller

USER 1001

ENTRYPOINT [ "/workflow-controller" ]
