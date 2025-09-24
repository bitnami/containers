# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

FROM docker.io/bitnami/minideb:bookworm

ARG DOWNLOADS_URL="downloads.bitnami.com/files/stacksmith"
ARG TARGETARCH

LABEL org.opencontainers.image.base.name="docker.io/bitnami/minideb:bookworm" \
      org.opencontainers.image.created="2025-09-24T09:29:50Z" \
      org.opencontainers.image.description="Application packaged by Broadcom, Inc." \
      org.opencontainers.image.documentation="https://github.com/bitnami/containers/tree/main/bitnami/kong/README.md" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/kong" \
      org.opencontainers.image.title="kong" \
      org.opencontainers.image.vendor="Broadcom, Inc." \
      org.opencontainers.image.version="3.9.1"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libabsl20220623 libaom3 libavif15 libbrotli1 libbsd0 libcrypt1 libdav1d6 libde265-0 libdeflate0 libexpat1 libfontconfig1 libfreetype6 libgav1-1 libgcc-s1 libgcrypt20 libgd3 libgeoip1 libgpg-error0 libheif1 libicu72 libjbig0 libjpeg62-turbo liblerc4 liblzma5 libmd0 libnuma1 libpcre3 libpng16-16 libprotobuf-dev librav1e0 libssl3 libstdc++6 libsvtav1enc1 libtiff6 libwebp7 libx11-6 libx265-199 libxau6 libxcb1 libxdmcp6 libxml2 libxpm4 libxslt1.1 libyaml-0-2 libyuv0 libzstd1 perl procps zlib1g zlib1g-dev
RUN --mount=type=secret,id=downloads_url,env=SECRET_DOWNLOADS_URL \
    DOWNLOADS_URL=${SECRET_DOWNLOADS_URL:-${DOWNLOADS_URL}} ; \
    mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ || exit 1 ; \
    COMPONENTS=( \
      "kong-3.9.1-9-linux-${OS_ARCH}-debian-12" \
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
RUN chmod g+rwX /opt/bitnami
RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true

COPY rootfs /
RUN /opt/bitnami/scripts/kong/postunpack.sh
ENV APP_VERSION="3.9.1" \
    BITNAMI_APP_NAME="kong" \
    IMAGE_REVISION="15" \
    PATH="/opt/bitnami/kong/bin:/opt/bitnami/kong/openresty/bin:/opt/bitnami/kong/openresty/luajit/bin:/opt/bitnami/kong/openresty/nginx/sbin:/opt/bitnami/kong/luarocks/bin:$PATH"

EXPOSE 8000 8001 8443 8444

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/kong/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/kong/run.sh" ]
