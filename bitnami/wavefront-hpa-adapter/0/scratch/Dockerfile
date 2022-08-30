FROM bitnami/minideb:bullseye as builder

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f wavefront-hpa-adapter-0.9.9-2-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/wavefront-hpa-adapter-0.9.9-2-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "7aedbc86b723387f664f50cef0b9401497eccf50b4e36fdb8672310d52eb828c  wavefront-hpa-adapter-0.9.9-2-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf wavefront-hpa-adapter-0.9.9-2-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --wildcards '*/files' && \
    rm -rf wavefront-hpa-adapter-0.9.9-2-linux-amd64-debian-11.tar.gz

######

FROM scratch

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="0.9.9-scratch-r6" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/wavefront-hpa-adapter" \
      org.opencontainers.image.title="wavefront-hpa-adapter" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="0.9.9"
COPY prebuildfs /
COPY rootfs /
COPY --from=builder /opt/bitnami/wavefront-hpa-adapter/bin/wavefront-adapter /wavefront-adapter

USER 1001

ENTRYPOINT [ "/wavefront-adapter" ]
