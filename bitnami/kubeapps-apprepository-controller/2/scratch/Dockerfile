FROM bitnami/minideb:bullseye as builder

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f kubeapps-apprepository-controller-2.5.0-1-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/kubeapps-apprepository-controller-2.5.0-1-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "37917e3209de55a13ff2c316a4d2138b19738bc02895b229a6f3545009bd9d6d  kubeapps-apprepository-controller-2.5.0-1-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf kubeapps-apprepository-controller-2.5.0-1-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --wildcards '*/files' && \
    rm -rf kubeapps-apprepository-controller-2.5.0-1-linux-amd64-debian-11.tar.gz

######

FROM scratch

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="2.5.0-scratch-r1" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/kubeapps-apprepository-controller" \
      org.opencontainers.image.title="kubeapps-apprepository-controller" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="2.5.0"
COPY prebuildfs /
COPY rootfs /
COPY --from=builder /opt/bitnami/kubeapps-apprepository-controller/bin/apprepository-controller /apprepository-controller

USER 1001

CMD [ "/apprepository-controller" ]
