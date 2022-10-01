FROM bitnami/minideb:bullseye as builder

ARG TARGETARCH

ENV OS_ARCH="${TARGETARCH:-amd64}"

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates curl
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f wavefront-1.12.0-0-linux-${OS_ARCH}-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/wavefront-1.12.0-0-linux-${OS_ARCH}-debian-11.tar.gz -O ; \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/wavefront-1.12.0-0-linux-${OS_ARCH}-debian-11.tar.gz.sha256 -O ; \
    fi && \
    sha256sum -c wavefront-1.12.0-0-linux-${OS_ARCH}-debian-11.tar.gz.sha256 && \
    tar -zxf wavefront-1.12.0-0-linux-${OS_ARCH}-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf wavefront-1.12.0-0-linux-${OS_ARCH}-debian-11.tar.gz wavefront-1.12.0-0-linux-${OS_ARCH}-debian-11.tar.gz.sha256

######

FROM scratch

ARG TARGETARCH

ENV OS_ARCH="${TARGETARCH:-amd64}"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="1.12.0-scratch-r1" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/wavefront-kubernetes-collector" \
      org.opencontainers.image.title="wavefront-kubernetes-collector" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.12.0"

COPY prebuildfs /
COPY --from=builder /opt/bitnami/wavefront/bin/wavefront-collector /wavefront-collector

USER 1001

ENTRYPOINT [ "/wavefront-collector" ]

CMD [ "--help" ]
