FROM bitnami/minideb:bullseye as builder

ARG TARGETARCH

ENV OS_ARCH="${TARGETARCH:-amd64}"

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f kube-rbac-proxy-0.13.0-3-linux-${OS_ARCH}-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/kube-rbac-proxy-0.13.0-3-linux-${OS_ARCH}-debian-11.tar.gz -O ; \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/kube-rbac-proxy-0.13.0-3-linux-${OS_ARCH}-debian-11.tar.gz.sha256 -O ; \
    fi && \
    sha256sum -c kube-rbac-proxy-0.13.0-3-linux-${OS_ARCH}-debian-11.tar.gz.sha256 && \
    tar -zxf kube-rbac-proxy-0.13.0-3-linux-${OS_ARCH}-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf kube-rbac-proxy-0.13.0-3-linux-${OS_ARCH}-debian-11.tar.gz

######

FROM scratch

ARG TARGETARCH

ENV OS_ARCH="${TARGETARCH:-amd64}"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="0.13.0-scratch-r5" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/kube-rbac-proxy" \
      org.opencontainers.image.title="kube-rbac-proxy" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="0.13.0"

COPY prebuildfs /
COPY rootfs /
COPY --from=builder /opt/bitnami/kube-rbac-proxy/bin/kube-rbac-proxy /kube-rbac-proxy

USER 1001

ENTRYPOINT [ "/kube-rbac-proxy" ]
