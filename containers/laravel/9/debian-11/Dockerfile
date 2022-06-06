FROM docker.io/bitnami/minideb:bullseye
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libbrotli1 libbsd0 libbz2-1.0 libc6 libcom-err2 libcrypt1 libcurl4 libexpat1 libffi7 libfftw3-double3 libfontconfig1 libfreetype6 libgcc-s1 libgcrypt20 libglib2.0-0 libgmp10 libgnutls30 libgomp1 libgpg-error0 libgssapi-krb5-2 libhogweed6 libicu67 libidn2-0 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblcms2-2 libldap-2.4-2 liblqr-1-0 libltdl7 liblzma5 libmagickcore-6.q16-6 libmagickwand-6.q16-6 libmd0 libmemcached11 libncursesw6 libnettle8 libnghttp2-14 libnsl2 libonig5 libp11-kit0 libpcre3 libpng16-16 libpq5 libpsl5 libreadline8 librtmp1 libsasl2-2 libsodium23 libsqlite3-0 libssh2-1 libssl1.1 libstdc++6 libsybdb5 libtasn1-6 libtidy5deb1 libtinfo6 libtirpc3 libunistring2 libuuid1 libwebp6 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxml2 libxslt1.1 libzip4 procps sqlite3 sudo tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.8.13-1" --checksum 79af9dcbaa89c4047d2d24b4a4c2ae17b771fe94972734379b9e50ef3dec3442
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "php" "8.1.6-1" --checksum 18a874b9dfdd587a7f7d259eeca35b8f520dc585ec5e4b069e77cb34ffaf4a41
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "node" "14.19.3-0" --checksum 97cffecfb637e5758197e4eb14d50b42048768eba242da4b534f1d8bacbd6958
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.3-0" --checksum 1013e2ebbe58e5dc8f3c79fc952f020fc5306ba48463803cacfbed7779173924
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "laravel" "9.1.9-0" --checksum fa6113817caa403c6e96d1622a6fb0d626a07bdcb3614cb9f3a27fbf9eea211a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum da4a2f759ccc57c100d795b71ab297f48b31c4dd7578d773d963bbd49c42bd7b
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN /build/bitnami-user.sh

COPY rootfs /
RUN /opt/bitnami/scripts/laravel/postunpack.sh
RUN /opt/bitnami/scripts/php/postunpack.sh
ENV APP_VERSION="9.1.9" \
    BITNAMI_APP_NAME="laravel" \
    NODE_PATH="/opt/bitnami/node/lib/node_modules" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/node/bin:/opt/bitnami/common/bin:$PATH" \
    PHP_ENABLE_OPCACHE="0"

EXPOSE 3000 8000

WORKDIR /app
ENTRYPOINT [ "/opt/bitnami/scripts/laravel/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/laravel/run.sh" ]
