FROM bitnami/minideb:bullseye as builder

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates gzip tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kubeapps-asset-syncer-2.4.6-0-linux-amd64-debian-11.tar.gz && \
    echo "48d7231f27f9e7cea49aabb2fd09d1ba115c49100e228bf3c253a34b8285c2f5  /tmp/bitnami/pkg/cache/kubeapps-asset-syncer-2.4.6-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kubeapps-asset-syncer-2.4.6-0-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kubeapps-asset-syncer-2.4.6-0-linux-amd64-debian-11.tar.gz

######

FROM scratch

COPY prebuildfs /
COPY rootfs /
COPY --from=builder /opt/bitnami/kubeapps-asset-syncer/bin/asset-syncer /asset-syncer

USER 1001

CMD [ "/asset-syncer" ]
