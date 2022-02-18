FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip less libaudit1 libbsd0 libbz2-1.0 libc6 libcap-ng0 libcom-err2 libcurl4 libexpat1 libffi6 libfftw3-double3 libfontconfig1 libfreetype6 libgcc1 libgcrypt20 libgeoip1 libglib2.0-0 libgmp10 libgnutls30 libgomp1 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libjemalloc2 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblcms2-2 libldap-2.4-2 liblqr-1-0 libltdl7 liblzma5 libmagickcore-6.q16-6 libmagickwand-6.q16-6 libmcrypt4 libmemcached11 libmemcachedutil2 libncurses6 libnettle6 libnghttp2-14 libonig5 libp11-kit0 libpam0g libpcre3 libpng16-16 libpq5 libpsl5 libreadline7 librtmp1 libsasl2-2 libsodium23 libsqlite3-0 libssh2-1 libssl1.1 libstdc++6 libsybdb5 libtasn1-6 libtidy5deb1 libtinfo6 libunistring2 libuuid1 libwebp6 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxml2 libxslt1.1 libzip4 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.1-9" --checksum 4694f01476c5a457a71f280562df45ea542bdf3f9b298ff87643a89ea365f5fb
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "qatengine" "0.6.11-4" --checksum b37daa55e544d3a25a19c257a3e49371e6e634c41cd69bb3b90ca316c793dadd
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "php" "7.4.28-2" --checksum 54e6b41ed87ed76ea41b5e9edca5eb79be84c404ed2151b7245084997eefce08
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wp-cli" "2.6.0-3" --checksum b9ff8ce30dc4066f9a09722f4327e8987554252fda65db266e9e68d31ec99589
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "nginx-intel" "0.4.7-8" --checksum e7924e45eb2f6ff901a8deef6159a9c964f99aec73bc752f2cc8db68d0bc7a4f
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql-client" "10.3.34-2" --checksum e4111d4f7ed30cafbf80e97f6fae69787445517a7a18c5a0dcca23360cf185ae
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wordpress" "5.9.0-6" --checksum 63c42401482377ed238f7eea9cafc1d418fa8e5d79741aca930280031aaaf154
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-5" --checksum 6f8fd2267481ffbe899a7f93b7b3076cd78dd70b7b9835bed79414932a749664
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
ENV BITNAMI_APP_NAME="wordpress-intel" \
    BITNAMI_IMAGE_VERSION="5.9.0-debian-10-r11" \
    NGINX_HTTPS_PORT_NUMBER="" \
    NGINX_HTTP_PORT_NUMBER="" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/wp-cli/bin:/opt/bitnami/nginx/sbin:/opt/bitnami/mysql/bin:$PATH"

EXPOSE 8080 8443

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/wordpress/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/nginx-php-fpm/run.sh" ]
