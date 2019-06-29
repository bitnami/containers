FROM bitnami/minideb-extras:stretch-r405
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libbz2-1.0 libc6 libcomerr2 libcurl3 libexpat1 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu57 libidn11 libidn2-0 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmemcached11 libmemcachedutil2 libncurses5 libnettle6 libnghttp2-14 libp11-kit0 libpcre3 libpng16-16 libpq5 libpsl5 libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.0.2 libssl1.1 libstdc++6 libsybdb5 libtasn1-6 libtidy5 libtinfo5 libunistring0 libxml2 libxslt1.1 libzip4 zlib1g
RUN bitnami-pkg unpack apache-2.4.39-2 --checksum ff55ee9cccf484bac61fa91558fc7f8445e91ea00bb104aca216f08aea003c6b
RUN bitnami-pkg unpack php-7.3.6-0 --checksum 42338902021f2a52bfc02b29487caaa73138b39d5f0e7188e6879cc9dfee2e52
RUN bitnami-pkg install libphp-7.3.6-0 --checksum 980e81874c99c09286ec595bcb8dad62eab605ee5f22b686a561e5740795908b
RUN bitnami-pkg unpack phpmyadmin-4.9.0-1-1 --checksum f4b69d7702612f2b0cbcb13c62aa0b0b2cde9082fc7cd35126969cd491212980
RUN ln -sf /dev/stdout /opt/bitnami/apache/logs/access_log
RUN ln -sf /dev/stderr /opt/bitnami/apache/logs/error_log

COPY rootfs /
ENV APACHE_HTTPS_PORT_NUMBER="" \
    APACHE_HTTP_PORT_NUMBER="" \
    APACHE_SET_HTTPS_PORT="no" \
    APACHE_SET_HTTP_PORT="no" \
    BITNAMI_APP_NAME="phpmyadmin" \
    BITNAMI_IMAGE_VERSION="4.9.0-1-debian-9-r26" \
    DATABASE_ENABLE_SSL="no" \
    DATABASE_HOST="mariadb" \
    DATABASE_PORT_NUMBER="3306" \
    DATABASE_SSL_CA="" \
    DATABASE_SSL_CA_PATH="" \
    DATABASE_SSL_CERT="" \
    DATABASE_SSL_CIPHERS="" \
    DATABASE_SSL_KEY="" \
    DATABASE_SSL_VERIFY="yes" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:$PATH" \
    PHPMYADMIN_ALLOW_ARBITRARY_SERVER="" \
    PHPMYADMIN_ALLOW_NO_PASSWORD="true" \
    REQUIRE_LOCAL="no"

VOLUME [ "/certs" ]

EXPOSE 80 443

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "httpd", "-f", "/opt/bitnami/apache/conf/httpd.conf", "-DFOREGROUND" ]
