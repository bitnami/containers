# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

FROM docker.io/bitnami/minideb:bookworm

ARG DOWNLOADS_URL="downloads.bitnami.com/files/stacksmith"
ARG EXTRA_LOCALES
ARG TARGETARCH
ARG WITH_ALL_LOCALES="no"

LABEL com.vmware.cp.artifact.flavor="sha256:c50c90cfd9d12b445b011e6ad529f1ad3daea45c26d20b00732fae3cd71f6a83" \
      org.opencontainers.image.base.name="docker.io/bitnami/minideb:bookworm" \
      org.opencontainers.image.created="2025-01-11T18:25:53Z" \
      org.opencontainers.image.description="Application packaged by Broadcom, Inc." \
      org.opencontainers.image.documentation="https://github.com/bitnami/containers/tree/main/bitnami/moodle/README.md" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.ref.name="4.5.1-debian-12-r2" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/moodle" \
      org.opencontainers.image.title="moodle" \
      org.opencontainers.image.vendor="Broadcom, Inc." \
      org.opencontainers.image.version="4.5.1"

ENV OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates cron curl libaudit1 libbrotli1 libbsd0 libbz2-1.0 libcap-ng0 libcom-err2 libcrypt1 libcurl4 libedit2 libexpat1 libffi8 libfftw3-double3 libfontconfig1 libfreetype6 libgcc-s1 libgcrypt20 libglib2.0-0 libgmp10 libgnutls30 libgomp1 libgpg-error0 libgssapi-krb5-2 libhashkit2 libhogweed6 libicu72 libidn2-0 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblcms2-2 libldap-2.5-0 liblqr-1-0 libltdl7 liblzma5 libmagickcore-6.q16-6 libmagickwand-6.q16-6 libmd0 libmemcached11 libncurses6 libnettle8 libnghttp2-14 libonig5 libp11-kit0 libpam0g libpcre2-8-0 libpcre3 libpng16-16 libpq5 libpsl5 libreadline8 librtmp1 libsasl2-2 libsodium23 libsqlite3-0 libssh2-1 libssl3 libstdc++6 libsybdb5 libtasn1-6 libtidy5deb1 libtinfo6 libunistring2 libuuid1 libwebp7 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxml2 libxslt1.1 libzip4 libzstd1 locales openssl procps zlib1g
RUN mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ ; \
    COMPONENTS=( \
      "render-template-1.0.7-8-linux-${OS_ARCH}-debian-12" \
      "php-8.1.31-8-linux-${OS_ARCH}-debian-12" \
      "apache-2.4.62-4-linux-${OS_ARCH}-debian-12" \
      "postgresql-client-13.18.0-0-linux-${OS_ARCH}-debian-12" \
      "mysql-client-11.4.4-0-linux-${OS_ARCH}-debian-12" \
      "libphp-8.1.31-0-linux-${OS_ARCH}-debian-12" \
      "moodle-4.5.1-0-linux-${OS_ARCH}-debian-12" \
    ) ; \
    for COMPONENT in "${COMPONENTS[@]}"; do \
      if [ ! -f "${COMPONENT}.tar.gz" ]; then \
        curl -SsLf "https://${DOWNLOADS_URL}/${COMPONENT}.tar.gz" -O ; \
        curl -SsLf "https://${DOWNLOADS_URL}/${COMPONENT}.tar.gz.sha256" -O ; \
      fi ; \
      sha256sum -c "${COMPONENT}.tar.gz.sha256" ; \
      tar -zxf "${COMPONENT}.tar.gz" -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' ; \
      rm -rf "${COMPONENT}".tar.gz{,.sha256} ; \
    done
RUN apt-get autoremove --purge -y curl && \
    apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives
RUN localedef -c -f UTF-8 -i en_US en_US.UTF-8
RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true
RUN sed -i -e '/pam_loginuid.so/ s/^#*/#/' /etc/pam.d/cron
RUN update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales
RUN echo 'en_AU.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen

COPY rootfs /
RUN /opt/bitnami/scripts/locales/add-extra-locales.sh
RUN /opt/bitnami/scripts/apache/postunpack.sh
RUN /opt/bitnami/scripts/php/postunpack.sh
RUN /opt/bitnami/scripts/apache-modphp/postunpack.sh
RUN /opt/bitnami/scripts/moodle/postunpack.sh
RUN /opt/bitnami/scripts/mysql-client/postunpack.sh
ENV APACHE_HTTPS_PORT_NUMBER="" \
    APACHE_HTTP_PORT_NUMBER="" \
    APP_VERSION="4.5.1" \
    BITNAMI_APP_NAME="moodle" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/apache/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/mysql/bin:$PATH"

EXPOSE 8080 8443

ENTRYPOINT [ "/opt/bitnami/scripts/moodle/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/moodle/run.sh" ]
