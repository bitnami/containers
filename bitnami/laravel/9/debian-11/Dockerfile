FROM docker.io/bitnami/minideb:bullseye
ENV OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libbrotli1 libbsd0 libbz2-1.0 libc6 libcom-err2 libcrypt1 libcurl4 libexpat1 libffi7 libfftw3-double3 libfontconfig1 libfreetype6 libgcc-s1 libgcrypt20 libglib2.0-0 libgmp10 libgnutls30 libgomp1 libgpg-error0 libgssapi-krb5-2 libhogweed6 libicu67 libidn2-0 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblcms2-2 libldap-2.4-2 liblqr-1-0 libltdl7 liblzma5 libmagickcore-6.q16-6 libmagickwand-6.q16-6 libmd0 libmemcached11 libncursesw6 libnettle8 libnghttp2-14 libnsl2 libonig5 libp11-kit0 libpcre3 libpng16-16 libpq5 libpsl5 libreadline8 librtmp1 libsasl2-2 libsodium23 libsqlite3-0 libssh2-1 libssl1.1 libstdc++6 libsybdb5 libtasn1-6 libtidy5deb1 libtinfo6 libtirpc3 libunistring2 libuuid1 libwebp6 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxml2 libxslt1.1 libzip4 procps sqlite3 sudo tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.8.13-157" --checksum 90a2d048ed71588dfff55262b4522e3ee49418b7ea6e560054bf50988ae1265f
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "php" "8.1.8-3" --checksum 2c50aee695f0f253d1a41e869eea69ad64d2faa862ef72580fe8c66ebd86ab5a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "node" "14.20.0-1" --checksum 1308eadfadd439cc82f4ca51185828f49cac7b38fcafd783e24f52c7c2768b4b
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.3-152" --checksum 0694ae67645c416d9f6875e90c0f7cef379b4ac8030a6a5b8b5cc9ca77c6975d
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "laravel" "9.3.1-0" --checksum fb3fad84a77c1f4639f9aa98d6df952337c39c712b026073f7e92fe3993f02c6
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-152" --checksum 0c751c7e2ec0bc900a19dbec0306d6294fe744ddfb0fa64197ba1a36040092f0
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN /build/bitnami-user.sh

COPY rootfs /
RUN /opt/bitnami/scripts/laravel/postunpack.sh
RUN /opt/bitnami/scripts/php/postunpack.sh
ENV APP_VERSION="9.3.1" \
    BITNAMI_APP_NAME="laravel" \
    NODE_PATH="/opt/bitnami/node/lib/node_modules" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/node/bin:/opt/bitnami/common/bin:$PATH" \
    PHP_ENABLE_OPCACHE="0"

EXPOSE 3000 8000

WORKDIR /app
ENTRYPOINT [ "/opt/bitnami/scripts/laravel/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/laravel/run.sh" ]
