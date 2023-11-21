# Copyright VMware, Inc.
# SPDX-License-Identifier: APACHE-2.0

FROM docker.io/bitnami/minideb:bullseye

ARG TARGETARCH

LABEL com.vmware.cp.artifact.flavor="sha256:1e1b4657a77f0d47e9220f0c37b9bf7802581b93214fff7d1bd2364c8bf22e8e" \
      org.opencontainers.image.base.name="docker.io/bitnami/minideb:bullseye" \
      org.opencontainers.image.created="2023-11-21T04:43:17Z" \
      org.opencontainers.image.description="Application packaged by VMware, Inc" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.ref.name="3.7.0-debian-11-r0" \
      org.opencontainers.image.title="apisix" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="3.7.0"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libbrotli1 libbsd0 libcrypt1 libdeflate0 libexpat1 libffi7 libfontconfig1 libfreetype6 libgcc-s1 libgcrypt20 libgd3 libgeoip1 libgmp10 libgnutls30 libgpg-error0 libhogweed6 libicu67 libidn2-0 libjbig0 libjpeg62-turbo libldap-2.4-2 liblzma5 libmd0 libnettle8 libp11-kit0 libpcre3 libpng16-16 libsasl2-2 libssl1.1 libstdc++6 libtasn1-6 libtiff5 libunistring2 libuuid1 libwebp6 libx11-6 libxau6 libxcb1 libxdmcp6 libxml2 libxpm4 libxslt1.1 libzstd1 procps zlib1g
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    COMPONENTS=( \
      "yq-4.40.2-0-linux-${OS_ARCH}-debian-11" \
      "render-template-1.0.6-3-linux-${OS_ARCH}-debian-11" \
      "apisix-3.7.0-0-linux-${OS_ARCH}-debian-11" \
    ) && \
    for COMPONENT in "${COMPONENTS[@]}"; do \
      if [ ! -f "${COMPONENT}.tar.gz" ]; then \
        curl -SsLf "https://downloads.bitnami.com/files/stacksmith/${COMPONENT}.tar.gz" -O ; \
        curl -SsLf "https://downloads.bitnami.com/files/stacksmith/${COMPONENT}.tar.gz.sha256" -O ; \
      fi && \
      sha256sum -c "${COMPONENT}.tar.gz.sha256" && \
      tar -zxf "${COMPONENT}.tar.gz" -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
      rm -rf "${COMPONENT}".tar.gz{,.sha256} ; \
    done
RUN apt-get autoremove --purge -y curl && \
    apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives
RUN useradd -r -u 1001 -g root apisix
RUN chmod g+rwX /opt/bitnami/apisix/conf && mkdir -p /usr/local/apisix/logs && chmod -R g+rwX /usr/local/apisix && ln -s /opt/bitnami/apisix/conf /usr/local/apisix && ln -s /opt/bitnami/apisix/deps /usr/local/apisix && ln -s /opt/bitnami/apisix/openresty/luajit/share/lua/*/apisix /usr/local/apisix

ENV APP_VERSION="3.7.0" \
    BITNAMI_APP_NAME="apisix" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/apisix/bin:/opt/bitnami/apisix/openresty/bin:/opt/bitnami/apisix/openresty/luajit/bin:/opt/bitnami/apisix/openresty/luarocks/bin:/opt/bitnami/apisix/openresty/nginx/sbin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/apisix/bin/apisix" ]
