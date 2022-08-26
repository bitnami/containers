FROM bitnami/minideb:bullseye as builder

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates gzip tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/wavefront-1.11.0-152-linux-amd64-debian-11.tar.gz && \
    echo "ba9d3388d64d42b73d082e461ce269fe0a1546f2043b9930b3189573d45c2fbb  /tmp/bitnami/pkg/cache/wavefront-1.11.0-152-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/wavefront-1.11.0-152-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/wavefront-1.11.0-152-linux-amd64-debian-11.tar.gz

######

FROM scratch

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="1.11.0-scratch-r11" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/wavefront-kubernetes-collector" \
      org.opencontainers.image.title="wavefront-kubernetes-collector" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.11.0"
COPY prebuildfs /
COPY --from=builder /opt/bitnami/wavefront/bin/wavefront-collector /wavefront-collector

USER 1001

ENTRYPOINT [ "/wavefront-collector" ]

CMD [ "--help" ]
