FROM bitnami/minideb:bullseye as builder

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates gzip tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/wavefront-hpa-adapter-0.9.9-1-linux-amd64-debian-11.tar.gz && \
    echo "8ba9ab540c1a5b87b87f5dfafe0df727661fbeeef3a03d52f2db7cfd24ced1ed  /tmp/bitnami/pkg/cache/wavefront-hpa-adapter-0.9.9-1-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/wavefront-hpa-adapter-0.9.9-1-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/wavefront-hpa-adapter-0.9.9-1-linux-amd64-debian-11.tar.gz

######

FROM scratch

COPY prebuildfs /
COPY rootfs /
COPY --from=builder /opt/bitnami/wavefront-hpa-adapter/bin/wavefront-adapter /wavefront-adapter

USER 1001

ENTRYPOINT [ "/wavefront-adapter" ]
