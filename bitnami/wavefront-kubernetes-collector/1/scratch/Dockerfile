FROM bitnami/minideb:bullseye as builder

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f wavefront-1.12.0-0-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/wavefront-1.12.0-0-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "f76732c79a8aafc46403caf9051df5fc3601bf91370ff3c1e05897ec184fec32  wavefront-1.12.0-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf wavefront-1.12.0-0-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf wavefront-1.12.0-0-linux-amd64-debian-11.tar.gz

######

FROM scratch

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="1.12.0-scratch-r0" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/wavefront-kubernetes-collector" \
      org.opencontainers.image.title="wavefront-kubernetes-collector" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.12.0"
COPY prebuildfs /
COPY --from=builder /opt/bitnami/wavefront/bin/wavefront-collector /wavefront-collector

USER 1001

ENTRYPOINT [ "/wavefront-collector" ]

CMD [ "--help" ]
