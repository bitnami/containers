FROM bitnami/minideb:bullseye as builder

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f thanos-0.28.0-0-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/thanos-0.28.0-0-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "8bc50d6e82ce7c5173cf75e844e575925139b2f76f68e01b69ff74e1512d155c  thanos-0.28.0-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf thanos-0.28.0-0-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --wildcards '*/files' && \
    rm -rf thanos-0.28.0-0-linux-amd64-debian-11.tar.gz

######

FROM scratch

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="0.28.0-scratch-r0" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/thanos" \
      org.opencontainers.image.title="thanos" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="0.28.0"
COPY prebuildfs /
COPY rootfs /
COPY --from=builder /opt/bitnami/thanos/bin/thanos /bin/thanos

USER 1001

ENTRYPOINT [ "/bin/thanos" ]
