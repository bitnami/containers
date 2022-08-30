FROM bitnami/minideb:bullseye as builder

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f pinniped-0.19.0-0-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/pinniped-0.19.0-0-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "01f100b1223cf3dd409569845e0d2284272bb941dddb08f01e4e4dae4a10d65f  pinniped-0.19.0-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf pinniped-0.19.0-0-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --wildcards '*/files' && \
    rm -rf pinniped-0.19.0-0-linux-amd64-debian-11.tar.gz

######

FROM scratch

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="0.19.0-scratch-r0" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/pinniped" \
      org.opencontainers.image.title="pinniped" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="0.19.0"
COPY prebuildfs /
COPY rootfs /
COPY --from=builder /opt/bitnami/pinniped/bin /

ENV PATH="/"

USER 1001

ENTRYPOINT [ "/pinniped-concierge" ]
