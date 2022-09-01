FROM bitnami/minideb:bullseye as builder

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f kubeapps-asset-syncer-2.5.1-0-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/kubeapps-asset-syncer-2.5.1-0-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "77aed9dcc38f1d82c127056c8183dbe961617091dee051cdfa9c303d73613d08  kubeapps-asset-syncer-2.5.1-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf kubeapps-asset-syncer-2.5.1-0-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf kubeapps-asset-syncer-2.5.1-0-linux-amd64-debian-11.tar.gz

######

FROM scratch

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="2.5.1-scratch-r0" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/kubeapps-asset-syncer" \
      org.opencontainers.image.title="kubeapps-asset-syncer" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="2.5.1"
COPY prebuildfs /
COPY rootfs /
COPY --from=builder /opt/bitnami/kubeapps-asset-syncer/bin/asset-syncer /asset-syncer

USER 1001

CMD [ "/asset-syncer" ]
