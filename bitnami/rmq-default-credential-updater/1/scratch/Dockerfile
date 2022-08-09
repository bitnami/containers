FROM bitnami/minideb:bullseye as builder

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates gzip tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/rmq-default-credential-updater-1.0.2-152-linux-amd64-debian-11.tar.gz && \
    echo "7522efbe4c4e0136ee89fa0003216f60931f604876d6737bef3663e8d9fe62ed  /tmp/bitnami/pkg/cache/rmq-default-credential-updater-1.0.2-152-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/rmq-default-credential-updater-1.0.2-152-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/rmq-default-credential-updater-1.0.2-152-linux-amd64-debian-11.tar.gz

######

FROM scratch

COPY prebuildfs /
COPY rootfs /
COPY --from=builder /opt/bitnami/rmq-default-credential-updater/bin/default-user-credential-updater /default-user-credential-updater

USER 1001

ENTRYPOINT [ "/default-user-credential-updater" ]
