FROM bitnami/minideb:bullseye as builder

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    curl -SsLf https://downloads.bitnami.com/files/stacksmith/argo-workflows-3.3.9-0-linux-amd64-debian-11.tar.gz -o argo-workflows-3.3.9-0-linux-amd64-debian-11.tar.gz && \
    echo "762cf01060577fe80a7031a555d14ca65d8fa7faa5e65bd05a397774fb1cb2aa  argo-workflows-3.3.9-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf argo-workflows-3.3.9-0-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --wildcards '*/files' && \
    rm -rf argo-workflows-3.3.9-0-linux-amd64-debian-11.tar.gz

######

FROM scratch

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="3.3.9-scratch-r1" \
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
