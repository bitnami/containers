FROM bitnami/minideb-extras:stretch-r276
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libbz2-1.0 libc6 libcomerr2 libcurl3 libexpat1 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu57 libidn11 libidn2-0 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmcrypt4 libmemcached11 libmemcachedutil2 libncurses5 libnettle6 libnghttp2-14 libp11-kit0 libpcre3 libpng16-16 libpq5 libpsl5 libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.0.2 libssl1.1 libstdc++6 libsybdb5 libtasn1-6 libtidy5 libtinfo5 libunistring0 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg unpack apache-2.4.38-1 --checksum 05c93df10a6e9fc17ee5f810045d80276fb394c1795667917f941d34c9f446e2
RUN bitnami-pkg unpack php-7.1.26-0 --checksum 7eb823409228a314524d99c9982bc2a3c2d0f79a377fe269c40f4e24fe2a18fc
RUN bitnami-pkg unpack libphp-7.1.26-1 --checksum 68a4b24e65f92258e376e8523dbf2b48011e8279290e4944dc510079f34504fa
RUN bitnami-pkg unpack phpmyadmin-4.8.5-0 --checksum e927b2563d2e47d67aec8a5cccd53ba6644657d797ce0f30471182f7d8c30f54
RUN mkdir -p /opt/bitnami/apache/tmp && chmod g+rwX /opt/bitnami/apache/tmp
RUN ln -sf /dev/stdout /opt/bitnami/apache/logs/access_log
RUN ln -sf /dev/stderr /opt/bitnami/apache/logs/error_log

COPY rootfs /
ENV APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="phpmyadmin" \
    BITNAMI_IMAGE_VERSION="4.8.5-debian-9-r5" \
    DATABASE_HOST="mariadb" \
    DATABASE_PORT_NUMBER="3306" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:$PATH" \
    PHPMYADMIN_ALLOW_ARBITRARY_SERVER="" \
    PHPMYADMIN_ALLOW_NO_PASSWORD="true" \
    REQUIRE_LOCAL="0"

EXPOSE 80 443

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "httpd", "-f", "/bitnami/apache/conf/httpd.conf", "-DFOREGROUND" ]
