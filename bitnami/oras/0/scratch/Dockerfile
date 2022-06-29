FROM bitnami/minideb:bullseye as builder

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates gzip tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/oras-0.12.0-150-linux-amd64-debian-11.tar.gz && \
    echo "89a11bcb492e1d64ef80139b41d3ce3aa494c23359fc6b0458d320a2f3ad22b9  /tmp/bitnami/pkg/cache/oras-0.12.0-150-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/oras-0.12.0-150-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/oras-0.12.0-150-linux-amd64-debian-11.tar.gz

######

FROM scratch

COPY prebuildfs /
COPY rootfs /
COPY --from=builder /opt/bitnami/oras/bin/oras /oras

USER 1001

ENTRYPOINT [ "/oras" ]
