FROM docker.io/bitnami/minideb:bullseye
ENV OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="6.1.3-debian-11-r6" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/symfony" \
      org.opencontainers.image.title="symfony" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="6.1.3"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libaudit1 libbrotli1 libbsd0 libbz2-1.0 libc6 libcap-ng0 libcom-err2 libcrypt1 libcurl4 libexpat1 libffi7 libfftw3-double3 libfontconfig1 libfreetype6 libgcc-s1 libgcrypt20 libglib2.0-0 libgmp10 libgnutls30 libgomp1 libgpg-error0 libgssapi-krb5-2 libhogweed6 libicu67 libidn2-0 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblcms2-2 libldap-2.4-2 liblqr-1-0 libltdl7 liblzma5 libmagickcore-6.q16-6 libmagickwand-6.q16-6 libmd0 libmemcached11 libncurses6 libnettle8 libnghttp2-14 libonig5 libp11-kit0 libpam0g libpcre3 libpng16-16 libpq5 libpsl5 libreadline8 librtmp1 libsasl2-2 libsodium23 libsqlite3-0 libssh2-1 libssl1.1 libstdc++6 libsybdb5 libtasn1-6 libtidy5deb1 libtinfo6 libunistring2 libuuid1 libwebp6 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxml2 libxslt1.1 libzip4 procps sudo tar unzip zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "php" "8.0.22-1" --checksum 9db7fc9a4c7083406fad1c07b0ff8f27a6236431d904dc0a98a5060df1f8ee15
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql-client" "10.6.8-152" --checksum 3c4757f1064b7a1648886658f05706957cf165c57fa922f4a6ebb757a19034cb
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "symfony" "6.1.3-1" --checksum f5250ce4d9023a523d7d848df2818aadca736f833347089902c5ba833fe4d862
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-153" --checksum d3ae0109be24e8bc56f97359b8290b91243454de946dd60bd8520a0896a88449
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN /build/bitnami-user.sh

COPY rootfs /
RUN /opt/bitnami/scripts/mysql-client/postunpack.sh
RUN /opt/bitnami/scripts/php/postunpack.sh
RUN /opt/bitnami/scripts/symfony/postunpack.sh
ENV APP_VERSION="6.1.3" \
    BITNAMI_APP_NAME="symfony" \
    PATH="/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/mysql/bin:/opt/bitnami/symfony/bin:/opt/bitnami/common/bin:$PATH" \
    PHP_ENABLE_OPCACHE="0"

EXPOSE 8000

WORKDIR /app
ENTRYPOINT [ "/opt/bitnami/scripts/symfony/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/symfony/run.sh" ]
