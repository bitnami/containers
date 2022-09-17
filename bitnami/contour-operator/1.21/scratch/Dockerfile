FROM bitnami/minideb:bullseye as builder

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f contour-operator-1.21.1-3-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/contour-operator-1.21.1-3-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "c1e486c79148df59e34ad3360a5810a835bc3311e8345a842531807c042e3619  contour-operator-1.21.1-3-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf contour-operator-1.21.1-3-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --wildcards '*/files' && \
    rm -rf contour-operator-1.21.1-3-linux-amd64-debian-11.tar.gz

######

FROM scratch

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="1.21.1-scratch-r3" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/contour-operator" \
      org.opencontainers.image.title="contour-operator" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.21.1"
COPY prebuildfs /
COPY rootfs /
COPY --from=builder /opt/bitnami/contour-operator/bin/contour-operator /contour-operator

USER 1001

ENTRYPOINT [ "/contour-operator" ]
