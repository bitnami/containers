FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl dirmngr gnupg gzip libaudit1 libbsd0 libbz2-1.0 libc6 libcap-ng0 libcom-err2 libcurl4 libexpat1 libffi6 libfftw3-double3 libfontconfig1 libfreetype6 libgcc1 libgcrypt20 libgeoip1 libglib2.0-0 libgmp10 libgnutls30 libgomp1 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblcms2-2 libldap-2.4-2 liblqr-1-0 libltdl7 liblzma5 libmagickcore-6.q16-6 libmagickwand-6.q16-6 libmemcached11 libmemcachedutil2 libncurses6 libnettle6 libnghttp2-14 libonig5 libp11-kit0 libpam0g libpcre3 libpng16-16 libpq5 libpsl5 libreadline7 librtmp1 libsasl2-2 libsodium23 libsqlite3-0 libssh2-1 libssl1.1 libstdc++6 libsybdb5 libtasn1-6 libtidy5deb1 libtinfo6 libunistring2 libuuid1 libwebp6 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxml2 libxslt1.1 libzip4 procps tar unzip zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "php" "8.1.5-0" --checksum a3cb00a122c8dea1bf67136767cb4efd98812a5daec4c068c9200bb58c9bc876
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "nginx" "1.21.6-7" --checksum 0998ed0dfcd1655f309642eada2681f3e604d7849899e0146ca6846d1a86dbd6
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql-client" "10.6.7-4" --checksum 14329a8ec0a649ecb9ffb37085a547183748efedea8ed029801ab9b381ab7173
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.1-10" --checksum 97c2ae4b001c5937e888b920bee7b1a40a076680caac53ded6d10f6207d54565
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-7" --checksum d6280b6f647a62bf6edc74dc8e526bfff63ddd8067dcb8540843f47203d9ccf1
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "drupal" "9.3.12-0" --checksum d89760d2063abebfabcb54d259e3c86b291f862608b440b1cb2a8854615cb0d0
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/nginx/postunpack.sh
RUN /opt/bitnami/scripts/php/postunpack.sh
RUN /opt/bitnami/scripts/nginx-php-fpm/postunpack.sh
RUN /opt/bitnami/scripts/drupal/postunpack.sh
RUN /opt/bitnami/scripts/mysql-client/postunpack.sh
ENV APP_VERSION="9.3.12" \
    BITNAMI_APP_NAME="drupal-nginx" \
    NGINX_HTTPS_PORT_NUMBER="" \
    NGINX_HTTP_PORT_NUMBER="" \
    PATH="/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/nginx/sbin:/opt/bitnami/mysql/bin:/opt/bitnami/common/bin:/opt/bitnami/drupal/vendor/bin:$PATH"

EXPOSE 8080 8443

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/drupal/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/nginx-php-fpm/run.sh" ]
