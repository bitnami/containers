FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip less libaudit1 libbrotli1 libbsd0 libbz2-1.0 libc6 libcap-ng0 libcom-err2 libcrypt1 libcurl4 libexpat1 libffi7 libfftw3-double3 libfontconfig1 libfreetype6 libgcc-s1 libgcrypt20 libgeoip1 libglib2.0-0 libgmp10 libgnutls30 libgomp1 libgpg-error0 libgssapi-krb5-2 libhogweed6 libicu67 libidn2-0 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblcms2-2 libldap-2.4-2 liblqr-1-0 libltdl7 liblzma5 libmagickcore-6.q16-6 libmagickwand-6.q16-6 libmd0 libmemcached11 libncurses6 libnettle8 libnghttp2-14 libonig5 libp11-kit0 libpam0g libpcre3 libpng16-16 libpq5 libpsl5 libreadline8 librtmp1 libsasl2-2 libsodium23 libsqlite3-0 libssh2-1 libssl1.1 libstdc++6 libsybdb5 libtasn1-6 libtidy5deb1 libtinfo6 libunistring2 libuuid1 libwebp6 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxml2 libxslt1.1 libzip4 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.3-150" --checksum 8b992a5ee513c5eaca52b19232b21a93588ddf4c4850be4d47c6f19b11d1d90a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "qatengine" "0.6.13-0" --checksum 849e1784ec8acb41f99abfb37bd11de8d3083c893677477a2c749665b4bfbfe0
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "php" "8.0.20-151" --checksum 6c8d302d4da0914ac1000c88ace9b873d76f985c7d22ab9cbab822b9dae5e182
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wp-cli" "2.6.0-150" --checksum 1d47407703e824d0d6c17ea6720947f7d55dd7db657e997b0411259de1cdc688
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "nginx-intel" "0.4.7-151" --checksum 8c9eeeda17b37a7fcd97a63d96d2c4f8193612e930a318de678d3d2a1bd57ff8
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql-client" "10.6.8-150" --checksum b47e1015fc1c9ce456f134ffd5b6ac6960c3f369c96fcd37319e9289b29a1047
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wordpress" "6.0.0-158" --checksum 0ea42f4c7e91b50d3809fec737b7abc9fb6e463b68a7069c456ddd79a851aac6
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-150" --checksum da4a2f759ccc57c100d795b71ab297f48b31c4dd7578d773d963bbd49c42bd7b
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/mysql-client/postunpack.sh
RUN /opt/bitnami/scripts/qatengine/postunpack.sh
RUN /opt/bitnami/scripts/nginx/postunpack.sh
RUN /opt/bitnami/scripts/php/postunpack.sh
RUN /opt/bitnami/scripts/nginx-php-fpm/postunpack.sh
RUN /opt/bitnami/scripts/wordpress/postunpack.sh
RUN /opt/bitnami/scripts/wp-cli/postunpack.sh
ENV APP_VERSION="6.0.0" \
    BITNAMI_APP_NAME="wordpress-intel" \
    NGINX_HTTPS_PORT_NUMBER="" \
    NGINX_HTTP_PORT_NUMBER="" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/wp-cli/bin:/opt/bitnami/nginx/sbin:/opt/bitnami/mysql/bin:$PATH"

EXPOSE 8080 8443

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/wordpress/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/nginx-php-fpm/run.sh" ]
