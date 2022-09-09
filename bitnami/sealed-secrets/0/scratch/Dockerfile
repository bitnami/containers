FROM bitnami/minideb:bullseye as builder

ARG TARGETARCH

ENV OS_ARCH="${TARGETARCH:-amd64}"

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f sealed-secrets-0.18.2-0-linux-${OS_ARCH}-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/sealed-secrets-0.18.2-0-linux-${OS_ARCH}-debian-11.tar.gz -O ; \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/sealed-secrets-0.18.2-0-linux-${OS_ARCH}-debian-11.tar.gz.sha256 -O ; \
    fi && \
    sha256sum -c sealed-secrets-0.18.2-0-linux-${OS_ARCH}-debian-11.tar.gz.sha256 && \
    tar -zxf sealed-secrets-0.18.2-0-linux-${OS_ARCH}-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf sealed-secrets-0.18.2-0-linux-${OS_ARCH}-debian-11.tar.gz

######

FROM scratch

ARG TARGETARCH

ENV OS_ARCH="${TARGETARCH:-amd64}"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="0.18.2-scratch-r1" \
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
