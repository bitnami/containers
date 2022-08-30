FROM bitnami/minideb:bullseye as builder

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f kube-rbac-proxy-0.13.0-3-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/kube-rbac-proxy-0.13.0-3-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "382c79e0d4234adc5532178dd85d7ba4dea46d72a7f6c899122f2db7cab26c1d  kube-rbac-proxy-0.13.0-3-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf kube-rbac-proxy-0.13.0-3-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --wildcards '*/files' && \
    rm -rf kube-rbac-proxy-0.13.0-3-linux-amd64-debian-11.tar.gz

######

FROM scratch

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="0.13.0-scratch-r4" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/kube-rbac-proxy" \
      org.opencontainers.image.title="kube-rbac-proxy" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="0.13.0"
COPY prebuildfs /
COPY rootfs /
COPY --from=builder /opt/bitnami/kube-rbac-proxy/bin/kube-rbac-proxy /kube-rbac-proxy

USER 1001

ENTRYPOINT [ "/kube-rbac-proxy" ]
