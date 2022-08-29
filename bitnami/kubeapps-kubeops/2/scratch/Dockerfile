FROM bitnami/minideb:bullseye as builder

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f kubeapps-kubeops-2.5.0-1-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/kubeapps-kubeops-2.5.0-1-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "17bed5d5cc95e10354995dbef71ba1d12974644c9f6834b4b010403437f04f2b  kubeapps-kubeops-2.5.0-1-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf kubeapps-kubeops-2.5.0-1-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --wildcards '*/files' && \
    rm -rf kubeapps-kubeops-2.5.0-1-linux-amd64-debian-11.tar.gz

######

FROM scratch

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="2.5.0-scratch-r1" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/kubeapps-kubeops" \
      org.opencontainers.image.title="kubeapps-kubeops" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="2.5.0"
COPY prebuildfs /
COPY rootfs /
COPY --from=builder /opt/bitnami/kubeapps-kubeops/bin/kubeops /kubeops

USER 1001

CMD [ "/kubeops" ]
