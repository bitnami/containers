FROM bitnami/minideb:bullseye as builder

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates gzip tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kube-rbac-proxy-0.12.0-150-linux-amd64-debian-11.tar.gz && \
    echo "c18aa57f6aa69ee74f8702314a0bc6d36680e92b26f16b88c93508472622feb6  /tmp/bitnami/pkg/cache/kube-rbac-proxy-0.12.0-150-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kube-rbac-proxy-0.12.0-150-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kube-rbac-proxy-0.12.0-150-linux-amd64-debian-11.tar.gz

######

FROM scratch

COPY prebuildfs /
COPY rootfs /
COPY --from=builder /opt/bitnami/kube-rbac-proxy/bin/kube-rbac-proxy /kube-rbac-proxy

USER 1001

ENTRYPOINT [ "/kube-rbac-proxy" ]
