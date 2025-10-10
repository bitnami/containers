# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

FROM docker.io/bitnami/minideb:bookworm

ARG DOWNLOADS_URL="downloads.bitnami.com/files/stacksmith"
ARG TARGETARCH

LABEL org.opencontainers.image.base.name="docker.io/bitnami/minideb:bookworm" \
      org.opencontainers.image.created="2025-10-10T14:43:53Z" \
      org.opencontainers.image.description="Application packaged by Broadcom, Inc." \
      org.opencontainers.image.documentation="https://github.com/bitnami/containers/tree/main/bitnami/redmine/README.md" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/redmine" \
      org.opencontainers.image.title="redmine" \
      org.opencontainers.image.vendor="Broadcom, Inc." \
      org.opencontainers.image.version="6.1.0"

ENV OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl ghostscript git gsfonts imagemagick libaudit1 libbrotli1 libbsd0 libcap-ng0 libcom-err2 libcrypt1 libcurl4 libedit2 libffi8 libgcc-s1 libgmp10 libgnutls30 libgssapi-krb5-2 libhogweed6 libicu72 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.5-0 liblz4-1 liblzma5 libmariadb3 libmd0 libncurses6 libnettle8 libnghttp2-14 libp11-kit0 libpam0g libpcre2-8-0 libpq5 libpsl5 libreadline-dev librtmp1 libsasl2-2 libssh2-1 libssl-dev libssl3 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libuuid1 libxml2 libxslt1.1 libyaml-0-2 libyaml-dev libzstd1 procps zlib1g
RUN --mount=type=secret,id=downloads_url,env=SECRET_DOWNLOADS_URL \
    DOWNLOADS_URL=${SECRET_DOWNLOADS_URL:-${DOWNLOADS_URL}} ; \
    mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ || exit 1 ; \
    COMPONENTS=( \
      "yq-4.47.2-1-linux-${OS_ARCH}-debian-12" \
      "ruby-3.3.9-3-linux-${OS_ARCH}-debian-12" \
      "postgresql-client-18.0.0-0-linux-${OS_ARCH}-debian-12" \
      "mysql-client-12.0.2-0-linux-${OS_ARCH}-debian-12" \
      "redmine-6.1.0-1-linux-${OS_ARCH}-debian-12" \
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
RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true
RUN uninstall_packages curl

COPY rootfs /
RUN /opt/bitnami/scripts/mysql-client/postunpack.sh
RUN /opt/bitnami/scripts/redmine/postunpack.sh
ENV APP_VERSION="6.1.0" \
    BITNAMI_APP_NAME="redmine" \
    IMAGE_REVISION="5" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/ruby/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/mysql/bin:$PATH"

EXPOSE 3000

ENTRYPOINT [ "/opt/bitnami/scripts/redmine/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/redmine/run.sh" ]
