FROM bitnami/minideb:bullseye as builder

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f kubeapps-apprepository-controller-2.5.1-0-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/kubeapps-apprepository-controller-2.5.1-0-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "6d5c15718a90ed54413287709f653677301ec6d2546b4c2fc24ba4286bd5c6de  kubeapps-apprepository-controller-2.5.1-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf kubeapps-apprepository-controller-2.5.1-0-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf kubeapps-apprepository-controller-2.5.1-0-linux-amd64-debian-11.tar.gz

######

FROM scratch

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="2.5.1-scratch-r0" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/kubeapps-apprepository-controller" \
      org.opencontainers.image.title="kubeapps-apprepository-controller" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="2.5.1"
COPY prebuildfs /
COPY rootfs /
COPY --from=builder /opt/bitnami/kubeapps-apprepository-controller/bin/apprepository-controller /apprepository-controller

USER 1001

CMD [ "/apprepository-controller" ]
