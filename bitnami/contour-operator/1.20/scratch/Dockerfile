FROM bitnami/minideb:bullseye as builder

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f contour-operator-1.20.2-3-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/contour-operator-1.20.2-3-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "2c260153809c4b19706b08b873333a9974e073486e4683642f05d0752ba0fcd6  contour-operator-1.20.2-3-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf contour-operator-1.20.2-3-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --wildcards '*/files' && \
    rm -rf contour-operator-1.20.2-3-linux-amd64-debian-11.tar.gz

######

FROM scratch

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="1.20.2-scratch-r6" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/contour-operator" \
      org.opencontainers.image.title="contour-operator" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.20.2"
COPY prebuildfs /
COPY rootfs /
COPY --from=builder /opt/bitnami/contour-operator/bin/contour-operator /contour-operator

USER 1001

ENTRYPOINT [ "/contour-operator" ]
