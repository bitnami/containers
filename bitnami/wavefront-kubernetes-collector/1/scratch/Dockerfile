FROM bitnami/minideb:bullseye as builder

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f wavefront-1.11.0-153-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/wavefront-1.11.0-153-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "087d8444d5bf24e5b0fd6e9b551feb509852103f3e2d7bd4fb903e5274626254  wavefront-1.11.0-153-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf wavefront-1.11.0-153-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --wildcards '*/files' && \
    rm -rf wavefront-1.11.0-153-linux-amd64-debian-11.tar.gz

######

FROM scratch

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="1.11.0-scratch-r12" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/wavefront-kubernetes-collector" \
      org.opencontainers.image.title="wavefront-kubernetes-collector" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.11.0"
COPY prebuildfs /
COPY --from=builder /opt/bitnami/wavefront/bin/wavefront-collector /wavefront-collector

USER 1001

ENTRYPOINT [ "/wavefront-collector" ]

CMD [ "--help" ]
