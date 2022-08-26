FROM bitnami/minideb:bullseye as builder

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates gzip tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/contour-operator-1.22.0-1-linux-amd64-debian-11.tar.gz && \
    echo "579709ff80095c948226be10028021841f78361729feb1f840de236a459705d6  /tmp/bitnami/pkg/cache/contour-operator-1.22.0-1-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/contour-operator-1.22.0-1-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/contour-operator-1.22.0-1-linux-amd64-debian-11.tar.gz

######

FROM scratch

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="1.22.0-scratch-r3" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/contour-operator" \
      org.opencontainers.image.title="contour-operator" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.22.0"
COPY prebuildfs /
COPY rootfs /
COPY --from=builder /opt/bitnami/contour-operator/bin/contour-operator /contour-operator

USER 1001

ENTRYPOINT [ "/contour-operator" ]
