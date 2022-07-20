FROM bitnami/minideb:bullseye as builder

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates gzip tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kube-rbac-proxy-0.13.0-1-linux-amd64-debian-11.tar.gz && \
    echo "71191b745b22ec986028fc7e9cdc7571261bbdfc60d35fcfe23d0da5a999ce52  /tmp/bitnami/pkg/cache/kube-rbac-proxy-0.13.0-1-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kube-rbac-proxy-0.13.0-1-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kube-rbac-proxy-0.13.0-1-linux-amd64-debian-11.tar.gz

######

FROM scratch

COPY prebuildfs /
COPY rootfs /
COPY --from=builder /opt/bitnami/kube-rbac-proxy/bin/kube-rbac-proxy /kube-rbac-proxy

USER 1001

ENTRYPOINT [ "/kube-rbac-proxy" ]
