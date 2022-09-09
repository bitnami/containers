FROM docker.io/bitnami/minideb:bullseye

ARG TARGETARCH

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="7.3.0-debian-11-r33" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/oauth2-proxy" \
      org.opencontainers.image.title="oauth2-proxy" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="7.3.0"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f oauth2-proxy-7.3.0-153-linux-${OS_ARCH}-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/oauth2-proxy-7.3.0-153-linux-${OS_ARCH}-debian-11.tar.gz -O ; \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/oauth2-proxy-7.3.0-153-linux-${OS_ARCH}-debian-11.tar.gz.sha256 -O ; \
    fi && \
    sha256sum -c oauth2-proxy-7.3.0-153-linux-${OS_ARCH}-debian-11.tar.gz.sha256 && \
    tar -zxf oauth2-proxy-7.3.0-153-linux-${OS_ARCH}-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf oauth2-proxy-7.3.0-153-linux-${OS_ARCH}-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN chown -R 1001:1001 /opt/bitnami/oauth2-proxy

ENV APP_VERSION="7.3.0" \
    BITNAMI_APP_NAME="oauth2-proxy" \
    PATH="/opt/bitnami/oauth2-proxy/bin:$PATH"

EXPOSE 4180 8080

WORKDIR /opt/bitnami/oauth2-proxy
USER 1001
ENTRYPOINT [ "oauth2-proxy" ]
CMD [ "--upstream=http://0.0.0.0:8080/", "--http-address=0.0.0.0:4180" ]
