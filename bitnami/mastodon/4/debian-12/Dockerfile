# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

FROM docker.io/bitnami/minideb:bookworm

ARG DOWNLOADS_URL="downloads.bitnami.com/files/stacksmith"
ARG TARGETARCH

LABEL org.opencontainers.image.base.name="docker.io/bitnami/minideb:bookworm" \
      org.opencontainers.image.created="2025-09-28T00:33:04Z" \
      org.opencontainers.image.description="Application packaged by Broadcom, Inc." \
      org.opencontainers.image.documentation="https://github.com/bitnami/containers/tree/main/bitnami/mastodon/README.md" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/mastodon" \
      org.opencontainers.image.title="mastodon" \
      org.opencontainers.image.vendor="Broadcom, Inc." \
      org.opencontainers.image.version="4.4.5"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl ffmpeg file imagemagick libblkid1 libbrotli1 libbsd0 libbz2-1.0 libcairo-gobject2 libcairo2 libcom-err2 libcrypt1 libcurl4 libdatrie1 libdeflate0 libedit2 libexif-dev libexif12 libexpat1 libffi8 libfftw3-double3 libfontconfig1 libfreetype6 libfribidi0 libgcc-s1 libgdk-pixbuf-2.0-0 libglib2.0-0 libgmp10 libgnutls30 libgomp1 libgraphite2-3 libgssapi-krb5-2 libharfbuzz0b libhogweed6 libicu72 libidn12 libidn2-0 libimath-3-1-29 libjbig0 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblcms2-2 libldap-2.5-0 liblerc4 liblqr-1-0 libltdl7 liblz4-1 liblzma5 libmagickcore-6.q16-6 libmd0 libmount1 libncursesw6 libnettle8 libnghttp2-14 libopenexr-3-1-30 libopenexr-dev libopenjp2-7 libp11-kit0 libpango-1.0-0 libpangocairo-1.0-0 libpangoft2-1.0-0 libpcre2-8-0 libpixman-1-0 libpng16-16 libpq5 libpsl5 libreadline-dev libreadline8 librsvg2-2 librtmp1 libsasl2-2 libselinux1 libsqlite3-0 libssh2-1 libssl-dev libssl3 libstdc++6 libtasn1-6 libthai0 libtiff6 libtinfo6 libunistring2 libuuid1 libwebp7 libwebpdemux2 libwebpmux3 libx11-6 libxau6 libxcb-render0 libxcb-shm0 libxcb1 libxdmcp6 libxext6 libxml2 libxrender1 libxslt1.1 libyaml-0-2 libyaml-dev libzstd1 procps zlib1g
RUN --mount=type=secret,id=downloads_url,env=SECRET_DOWNLOADS_URL \
    DOWNLOADS_URL=${SECRET_DOWNLOADS_URL:-${DOWNLOADS_URL}} ; \
    mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ || exit 1 ; \
    COMPONENTS=( \
      "python-3.13.7-2-linux-${OS_ARCH}-debian-12" \
      "wait-for-port-1.0.10-1-linux-${OS_ARCH}-debian-12" \
      "ruby-3.4.6-0-linux-${OS_ARCH}-debian-12" \
      "redis-client-8.2.1-0-linux-${OS_ARCH}-debian-12" \
      "postgresql-client-18.0.0-0-linux-${OS_ARCH}-debian-12" \
      "node-22.20.0-0-linux-${OS_ARCH}-debian-12" \
      "mastodon-4.4.5-1-linux-${OS_ARCH}-debian-12" \
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
RUN /opt/bitnami/scripts/mastodon/postunpack.sh
ENV APP_VERSION="4.4.5" \
    BITNAMI_APP_NAME="mastodon" \
    IMAGE_REVISION="6" \
    LD_LIBRARY_PATH="/opt/bitnami/common/lib:$LD_LIBRARY_PATH" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/python/bin:/opt/bitnami/ruby/bin:/opt/bitnami/redis/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/node/bin:/opt/bitnami/mastodon/bin:$PATH"

EXPOSE 3000

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/mastodon/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/mastodon/run.sh" ]
