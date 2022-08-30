FROM bitnami/minideb:bullseye as builder

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f sealed-secrets-0.18.2-0-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/sealed-secrets-0.18.2-0-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "f97cf4a2ea24150f5501666698d65cb1584c7de185edeab18959258c0c9589bd  sealed-secrets-0.18.2-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf sealed-secrets-0.18.2-0-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --wildcards '*/files' && \
    rm -rf sealed-secrets-0.18.2-0-linux-amd64-debian-11.tar.gz

######

FROM scratch

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="0.18.2-scratch-r0" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/sealed-secrets" \
      org.opencontainers.image.title="sealed-secrets" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="0.18.2"
COPY prebuildfs /
COPY rootfs /
COPY --from=builder /opt/bitnami/sealed-secrets/bin/controller /controller
COPY --from=builder /opt/bitnami/sealed-secrets/bin/kubeseal /kubeseal

USER 1001

ENTRYPOINT [ "/controller" ]
