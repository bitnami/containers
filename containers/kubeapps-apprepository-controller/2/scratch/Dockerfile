FROM bitnami/minideb:bullseye as builder

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates gzip tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kubeapps-apprepository-controller-2.4.6-1-linux-amd64-debian-11.tar.gz && \
    echo "bd6cde3cce8f25cfaf6a74791d114892bf2bd57de034051829efda33b6861768  /tmp/bitnami/pkg/cache/kubeapps-apprepository-controller-2.4.6-1-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kubeapps-apprepository-controller-2.4.6-1-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kubeapps-apprepository-controller-2.4.6-1-linux-amd64-debian-11.tar.gz

######

FROM scratch

COPY prebuildfs /
COPY rootfs /
COPY --from=builder /opt/bitnami/kubeapps-apprepository-controller/bin/apprepository-controller /apprepository-controller

USER 1001

CMD [ "/apprepository-controller" ]
