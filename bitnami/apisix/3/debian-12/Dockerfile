# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

FROM docker.io/bitnami/minideb:bookworm

ARG DOWNLOADS_URL="downloads.bitnami.com/files/stacksmith"
ARG TARGETARCH

LABEL org.opencontainers.image.base.name="docker.io/bitnami/minideb:bookworm" \
      org.opencontainers.image.created="2025-10-07T00:40:56Z" \
      org.opencontainers.image.description="Application packaged by Broadcom, Inc." \
      org.opencontainers.image.documentation="https://github.com/bitnami/containers/tree/main/bitnami/apisix/README.md" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/apisix" \
      org.opencontainers.image.title="apisix" \
      org.opencontainers.image.vendor="Broadcom, Inc." \
      org.opencontainers.image.version="3.13.0"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libcrypt1 libgcc-s1 libpcre3 libstdc++6 libyaml-0-2 procps zlib1g
RUN --mount=type=secret,id=downloads_url,env=SECRET_DOWNLOADS_URL \
    DOWNLOADS_URL=${SECRET_DOWNLOADS_URL:-${DOWNLOADS_URL}} ; \
    mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ || exit 1 ; \
    COMPONENTS=( \
      "apisix-3.13.0-2-linux-${OS_ARCH}-debian-12" \
    ) ; \
    for COMPONENT in "${COMPONENTS[@]}"; do \
      if [ ! -f "${COMPONENT}.tar.gz" ]; then \
        curl -SsLf "https://${DOWNLOADS_URL}/${COMPONENT}.tar.gz" -O ; \
        curl -SsLf "https://${DOWNLOADS_URL}/${COMPONENT}.tar.gz.sha256" -O ; \
      fi ; \
      sha256sum -c "${COMPONENT}.tar.gz.sha256" ; \
      tar -zxf "${COMPONENT}.tar.gz" -C /opt/bitnami --strip-components=2 --no-same-owner ; \
      rm -rf "${COMPONENT}".tar.gz{,.sha256} ; \
    done
RUN apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives
RUN useradd -r -u 1001 -g root apisix
RUN chmod g+rwX /opt/bitnami/apisix/conf && mkdir -p /usr/local/apisix/logs && chmod -R g+rwX /usr/local/apisix && ln -s /opt/bitnami/apisix/conf /usr/local/apisix && ln -s /opt/bitnami/apisix/ui /usr/local/apisix && ln -s /opt/bitnami/apisix/deps /usr/local/apisix && ln -s /opt/bitnami/apisix/openresty/luajit/share/lua/*/apisix /usr/local/apisix
RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true
RUN uninstall_packages curl

ENV APP_VERSION="3.13.0" \
    BITNAMI_APP_NAME="apisix" \
    IMAGE_REVISION="6" \
    LUA_PATH="/opt/bitnami/apisix/deps/share/lua/5.1/?/init.lua" \
    PATH="/opt/bitnami/apisix/bin:/opt/bitnami/apisix/openresty/bin:/opt/bitnami/apisix/openresty/luajit/bin:/opt/bitnami/apisix/openresty/nginx/sbin:/opt/bitnami/apisix/openresty/luarocks/bin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/apisix/bin/apisix" ]
