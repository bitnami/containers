FROM bitnami/minideb:bullseye as builder

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates gzip tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kubeapps-kubeops-2.4.6-1-linux-amd64-debian-11.tar.gz && \
    echo "62947df6bcaa7273eb67cfbdd57030a01a5c311b415edaace4c3775e38510d3e  /tmp/bitnami/pkg/cache/kubeapps-kubeops-2.4.6-1-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kubeapps-kubeops-2.4.6-1-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kubeapps-kubeops-2.4.6-1-linux-amd64-debian-11.tar.gz

######

FROM scratch

COPY prebuildfs /
COPY rootfs /
COPY --from=builder /opt/bitnami/kubeapps-kubeops/bin/kubeops /kubeops

USER 1001

CMD [ "/kubeops" ]
