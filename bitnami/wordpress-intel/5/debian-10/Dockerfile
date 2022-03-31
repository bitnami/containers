FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip less libaudit1 libbsd0 libbz2-1.0 libc6 libcap-ng0 libcom-err2 libcurl4 libexpat1 libffi6 libfftw3-double3 libfontconfig1 libfreetype6 libgcc1 libgcrypt20 libgeoip1 libglib2.0-0 libgmp10 libgnutls30 libgomp1 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libjemalloc2 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblcms2-2 libldap-2.4-2 liblqr-1-0 libltdl7 liblzma5 libmagickcore-6.q16-6 libmagickwand-6.q16-6 libmcrypt4 libmemcached11 libmemcachedutil2 libncurses6 libnettle6 libnghttp2-14 libonig5 libp11-kit0 libpam0g libpcre3 libpng16-16 libpq5 libpsl5 libreadline7 librtmp1 libsasl2-2 libsodium23 libsqlite3-0 libssh2-1 libssl1.1 libstdc++6 libsybdb5 libtasn1-6 libtidy5deb1 libtinfo6 libunistring2 libuuid1 libwebp6 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxml2 libxslt1.1 libzip4 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.1-10" --checksum 97c2ae4b001c5937e888b920bee7b1a40a076680caac53ded6d10f6207d54565
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "qatengine" "0.6.11-6" --checksum eaadd4303f1b51690bf5bc391a27403d79c9f12f00e3a6fba7088bf9d4fcc326
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "php" "7.4.28-12" --checksum 4d49b52d64b513996834a32b3881c55b922be0f04fe6d4b6499078f8574237c8
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wp-cli" "2.6.0-4" --checksum fa48eb0bf1c92c18e4e82ab6cbde981bbf5d63116e0fb9b665bce6d84d9a52f2
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "nginx-intel" "0.4.7-9" --checksum 6c7c70448a53cc68065376fb051055df94b1e1ae2bea84212f366007b98f1e02
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql-client" "10.3.34-4" --checksum bb0089c26028b568dbe8b8875d39cca3c7835c582dda4fcbdcbed599320c57fe
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wordpress" "5.9.2-3" --checksum 0ad1a059d97af2dcdf6a9bd06b2a8a9549f21679d95275b4b73038319dcf026d
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-7" --checksum d6280b6f647a62bf6edc74dc8e526bfff63ddd8067dcb8540843f47203d9ccf1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/mysql-client/postunpack.sh
RUN /opt/bitnami/scripts/qatengine/postunpack.sh
RUN /opt/bitnami/scripts/php/postunpack.sh
RUN /opt/bitnami/scripts/nginx/postunpack.sh
RUN /opt/bitnami/scripts/nginx-php-fpm/postunpack.sh
RUN /opt/bitnami/scripts/wordpress/postunpack.sh
RUN /opt/bitnami/scripts/wp-cli/postunpack.sh
ENV APP_VERSION="5.9.2" \
    BITNAMI_APP_NAME="wordpress-intel" \
    BITNAMI_IMAGE_VERSION="5.9.2-debian-10-r23" \
    NGINX_HTTPS_PORT_NUMBER="" \
    NGINX_HTTP_PORT_NUMBER="" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/wp-cli/bin:/opt/bitnami/nginx/sbin:/opt/bitnami/mysql/bin:$PATH"

EXPOSE 8080 8443

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/wordpress/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/nginx-php-fpm/run.sh" ]
