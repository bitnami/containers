FROM bitnami/minideb:bullseye as builder

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates gzip tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/argo-workflows-3.3.9-0-linux-amd64-debian-11.tar.gz && \
    echo "762cf01060577fe80a7031a555d14ca65d8fa7faa5e65bd05a397774fb1cb2aa  /tmp/bitnami/pkg/cache/argo-workflows-3.3.9-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/argo-workflows-3.3.9-0-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/argo-workflows-3.3.9-0-linux-amd64-debian-11.tar.gz

######

FROM scratch

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/argo-workflow-cli" \
      org.opencontainers.image.title="argo-workflow-cli" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="3.3.9"
COPY prebuildfs /
COPY rootfs /
COPY --from=builder /opt/bitnami/argo-workflows/hack/nsswitch.conf  /etc/nsswitch.conf
COPY --from=builder /opt/bitnami/argo-workflows/bin/argo /argo
COPY --from=builder /opt/bitnami/argo-workflows/hack/ssh_known_hosts /etc/ssh/ssh_known_hosts

USER 1001

ENTRYPOINT [ "/argo" ]
