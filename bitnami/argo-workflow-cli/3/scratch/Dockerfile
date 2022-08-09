FROM bitnami/minideb:bullseye as builder

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates gzip tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/argo-workflows-3.3.8-2-linux-amd64-debian-11.tar.gz && \
    echo "2a73fb34cdca676dc7f4edcea366328fde56ae57241ee8e3e098437a05ae9e92  /tmp/bitnami/pkg/cache/argo-workflows-3.3.8-2-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/argo-workflows-3.3.8-2-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/argo-workflows-3.3.8-2-linux-amd64-debian-11.tar.gz

######

FROM scratch

COPY prebuildfs /
COPY rootfs /
COPY --from=builder /opt/bitnami/argo-workflows/hack/nsswitch.conf  /etc/nsswitch.conf
COPY --from=builder /opt/bitnami/argo-workflows/bin/argo /argo
COPY --from=builder /opt/bitnami/argo-workflows/hack/ssh_known_hosts /etc/ssh/ssh_known_hosts

USER 1001

ENTRYPOINT [ "/argo" ]
