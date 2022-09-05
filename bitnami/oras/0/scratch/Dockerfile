FROM bitnami/minideb:bullseye as builder

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f oras-0.14.1-0-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/oras-0.14.1-0-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "408b1fce120fd810413dc8da6369a2a0013b61912dda321ccc60ede96e8d069d  oras-0.14.1-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf oras-0.14.1-0-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf oras-0.14.1-0-linux-amd64-debian-11.tar.gz

######

FROM scratch

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="0.14.1-scratch-r0" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/oras" \
      org.opencontainers.image.title="oras" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="0.14.1"
COPY prebuildfs /
COPY rootfs /
COPY --from=builder /opt/bitnami/oras/bin/oras /oras

USER 1001

ENTRYPOINT [ "/oras" ]
