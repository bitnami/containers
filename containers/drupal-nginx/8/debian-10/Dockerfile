FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl dirmngr gnupg gzip libargon2-1 libaudit1 libbsd0 libbz2-1.0 libc6 libcap-ng0 libcom-err2 libcurl4 libexpat1 libffi6 libfftw3-double3 libfontconfig1 libfreetype6 libgcc1 libgcrypt20 libgeoip1 libglib2.0-0 libgmp10 libgnutls30 libgomp1 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libjemalloc2 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblcms2-2 libldap-2.4-2 liblqr-1-0 libltdl7 liblzma5 libmagickcore-6.q16-6 libmagickwand-6.q16-6 libmcrypt4 libmemcached11 libmemcachedutil2 libncurses6 libnettle6 libnghttp2-14 libp11-kit0 libpam0g libpcre3 libpng16-16 libpq5 libpsl5 libreadline7 librtmp1 libsasl2-2 libsodium23 libssh2-1 libssl1.1 libstdc++6 libsybdb5 libtasn1-6 libtidy5deb1 libtinfo6 libunistring2 libuuid1 libwebp6 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxml2 libxslt1.1 libzip4 procps tar unzip zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "php" "7.3.28-0" --checksum 029ca7c2678b4ccfb07db3b4ad18724070e0f49528ad17b42bbcf6b20620e574
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "nginx" "1.19.10-2" --checksum a3b7f2f5a8ec3c8c7643c2b93979d2b109573b64d7e0eec9df1f19768bcb0bba
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql-client" "10.3.29-0" --checksum 5bf8f1ed022c8ad75a4db5b8b72ae54ce427bff628d7e4025c5b5e67b876708d
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.0-3" --checksum 8179ad1371c9a7d897fe3b1bf53bbe763f94edafef19acad2498dd48b3674efe
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.12.0-2" --checksum 4d858ac600c38af8de454c27b7f65c0074ec3069880cb16d259a6e40a46bbc50
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "drupal" "8.9.15-1" --checksum 0359720dd7e7df160a8b501992e194f8716cfa43a55a07a3a58c9104bc33b5a1
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/nginx/postunpack.sh
RUN /opt/bitnami/scripts/php/postunpack.sh
RUN /opt/bitnami/scripts/nginx-php-fpm/postunpack.sh
RUN /opt/bitnami/scripts/drupal/postunpack.sh
RUN /opt/bitnami/scripts/mysql-client/postunpack.sh
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="drupal-nginx" \
    BITNAMI_IMAGE_VERSION="8.9.15-debian-10-r9" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    MYSQL_CLIENT_ENABLE_SSL="no" \
    MYSQL_CLIENT_SSL_CA_FILE="" \
    NGINX_ENABLE_CUSTOM_PORTS="no" \
    NGINX_HTTPS_PORT_NUMBER="" \
    NGINX_HTTP_PORT_NUMBER="" \
    PATH="/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/nginx/sbin:/opt/bitnami/mysql/bin:/opt/bitnami/common/bin:/opt/bitnami/drupal/vendor/bin:$PATH"

EXPOSE 8080 8443

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/drupal/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/nginx-php-fpm/run.sh" ]
