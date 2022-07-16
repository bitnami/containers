FROM bitnami/minideb:bullseye as builder

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates gzip tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/rabbitmq-cluster-operator-1.14.0-1-linux-amd64-debian-11.tar.gz && \
    echo "c55a43c1e4b603cabefc745500550835c71f42ce8b72e68c27db059867e6d42d  /tmp/bitnami/pkg/cache/rabbitmq-cluster-operator-1.14.0-1-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/rabbitmq-cluster-operator-1.14.0-1-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/rabbitmq-cluster-operator-1.14.0-1-linux-amd64-debian-11.tar.gz

######

FROM scratch

COPY prebuildfs /
COPY rootfs /
COPY --from=builder /opt/bitnami/rabbitmq-cluster-operator/bin/manager /manager

USER 1001

ENTRYPOINT [ "/manager" ]
