FROM bitnami/minideb:bullseye as builder

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates gzip tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/oras-0.14.0-0-linux-amd64-debian-11.tar.gz && \
    echo "21ab06affacd7ed8b3584e8e2d7e29e517f407b9ade550850d7b470c4da5df03  /tmp/bitnami/pkg/cache/oras-0.14.0-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/oras-0.14.0-0-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/oras-0.14.0-0-linux-amd64-debian-11.tar.gz

######

FROM scratch

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="0.14.0-scratch-r0" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/oras" \
      org.opencontainers.image.title="oras" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="0.14.0"
COPY prebuildfs /
COPY rootfs /
COPY --from=builder /opt/bitnami/oras/bin/oras /oras

USER 1001

ENTRYPOINT [ "/oras" ]
