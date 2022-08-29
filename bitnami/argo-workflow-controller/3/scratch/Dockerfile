FROM bitnami/minideb:bullseye as builder

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f argo-workflow-controller-3.3.9-1-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/argo-workflow-controller-3.3.9-1-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "b147f60cb95cc8333835860bc3b1d1401956ad37fbbf2c794f1195b1df7351cf  argo-workflow-controller-3.3.9-1-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf argo-workflow-controller-3.3.9-1-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --wildcards '*/files' && \
    rm -rf argo-workflow-controller-3.3.9-1-linux-amd64-debian-11.tar.gz

######

FROM scratch

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="3.3.9-scratch-r1" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/argo-workflow-controller" \
      org.opencontainers.image.title="argo-workflow-controller" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="3.3.9"
COPY prebuildfs /
COPY rootfs /
COPY --from=builder /opt/bitnami/argo-workflow-controller/bin/workflow-controller /workflow-controller

USER 1001

ENTRYPOINT [ "/workflow-controller" ]
