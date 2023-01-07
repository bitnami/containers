FROM docker.io/bitnami/minideb:bullseye

ARG EXTRA_LOCALES
ARG TARGETARCH
ARG WITH_ALL_LOCALES="no"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="3.11.11-debian-11-r19" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/moodle" \
      org.opencontainers.image.title="moodle" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="3.11.11"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates cron curl libaudit1 libbrotli1 libbsd0 libbz2-1.0 libcap-ng0 libcom-err2 libcrypt1 libcurl4 libedit2 libexpat1 libffi7 libfftw3-double3 libfontconfig1 libfreetype6 libgcc-s1 libgcrypt20 libglib2.0-0 libgmp10 libgnutls30 libgomp1 libgpg-error0 libgssapi-krb5-2 libhogweed6 libicu67 libidn2-0 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblcms2-2 libldap-2.4-2 liblqr-1-0 libltdl7 liblzma5 libmagickcore-6.q16-6 libmagickwand-6.q16-6 libmd0 libmemcached11 libncurses6 libnettle8 libnghttp2-14 libonig5 libp11-kit0 libpam0g libpcre2-8-0 libpcre3 libpng16-16 libpq5 libpsl5 libreadline8 librtmp1 libsasl2-2 libsodium23 libsqlite3-0 libssh2-1 libssl1.1 libstdc++6 libsybdb5 libtasn1-6 libtidy5deb1 libtinfo6 libunistring2 libuuid1 libwebp6 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxml2 libxslt1.1 libzip4 locales procps zlib1g
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    COMPONENTS=( \
      "php-8.0.27-0-linux-${OS_ARCH}-debian-11" \
      "apache-2.4.54-159-linux-${OS_ARCH}-debian-11" \
      "postgresql-client-13.9.0-0-linux-${OS_ARCH}-debian-11" \
      "mysql-client-10.6.11-1-linux-${OS_ARCH}-debian-11" \
      "libphp-8.0.27-0-linux-${OS_ARCH}-debian-11" \
      "render-template-1.0.4-1-linux-${OS_ARCH}-debian-11" \
      "moodle-3.11.11-2-linux-${OS_ARCH}-debian-11" \
      "gosu-1.16.0-0-linux-${OS_ARCH}-debian-11" \
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
RUN chmod g+rwX /opt/bitnami
RUN localedef -c -f UTF-8 -i en_US en_US.UTF-8
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
    APP_VERSION="3.11.11" \
    BITNAMI_APP_NAME="moodle" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    PATH="/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/apache/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/mysql/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 8080 8443

USER root
ENTRYPOINT [ "/opt/bitnami/scripts/moodle/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/moodle/run.sh" ]
