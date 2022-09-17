FROM docker.io/bitnami/minideb:bullseye

ARG TARGETARCH

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="1.21.4-1-debian-11-r37" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/openresty" \
      org.opencontainers.image.title="openresty" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.21.4-1"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libbrotli1 libbsd0 libc6 libcrypt1 libdeflate0 libexpat1 libfontconfig1 libfreetype6 libgcc-s1 libgcrypt20 libgd3 libgeoip1 libgpg-error0 libicu67 libjbig0 libjpeg62-turbo liblzma5 libmd0 libpcre3 libpng16-16 libssl1.1 libstdc++6 libtiff5 libuuid1 libwebp6 libx11-6 libxau6 libxcb1 libxdmcp6 libxml2 libxpm4 libxslt1.1 libzstd1 perl procps tar zlib1g
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f openresty-1.21.4-1-153-linux-${OS_ARCH}-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/openresty-1.21.4-1-153-linux-${OS_ARCH}-debian-11.tar.gz -O ; \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/openresty-1.21.4-1-153-linux-${OS_ARCH}-debian-11.tar.gz.sha256 -O ; \
    fi && \
    sha256sum -c openresty-1.21.4-1-153-linux-${OS_ARCH}-debian-11.tar.gz.sha256 && \
    tar -zxf openresty-1.21.4-1-153-linux-${OS_ARCH}-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf openresty-1.21.4-1-153-linux-${OS_ARCH}-debian-11.tar.gz openresty-1.21.4-1-153-linux-${OS_ARCH}-debian-11.tar.gz.sha256
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f gosu-1.14.0-154-linux-${OS_ARCH}-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/gosu-1.14.0-154-linux-${OS_ARCH}-debian-11.tar.gz -O ; \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/gosu-1.14.0-154-linux-${OS_ARCH}-debian-11.tar.gz.sha256 -O ; \
    fi && \
    sha256sum -c gosu-1.14.0-154-linux-${OS_ARCH}-debian-11.tar.gz.sha256 && \
    tar -zxf gosu-1.14.0-154-linux-${OS_ARCH}-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf gosu-1.14.0-154-linux-${OS_ARCH}-debian-11.tar.gz gosu-1.14.0-154-linux-${OS_ARCH}-debian-11.tar.gz.sha256
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/openresty/postunpack.sh
ENV APP_VERSION="1.21.4-1" \
    BITNAMI_APP_NAME="openresty" \
    PATH="/opt/bitnami/openresty/bin:/opt/bitnami/openresty/luajit/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 8080 8443

WORKDIR /app
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/openresty/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/openresty/run.sh" ]
