FROM bitnami/minideb:bullseye as builder

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates gzip tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/rmq-messaging-topology-operator-1.7.1-1-linux-amd64-debian-11.tar.gz && \
    echo "b944c0d368dbbd7048b5489f990d3c8f945957fe75c14a43371fc598fa1fd7be  /tmp/bitnami/pkg/cache/rmq-messaging-topology-operator-1.7.1-1-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/rmq-messaging-topology-operator-1.7.1-1-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/rmq-messaging-topology-operator-1.7.1-1-linux-amd64-debian-11.tar.gz

######

FROM scratch

COPY prebuildfs /
COPY rootfs /
COPY --from=builder /opt/bitnami/rmq-messaging-topology-operator/bin/manager /manager

USER 1001

ENTRYPOINT [ "/manager" ]
