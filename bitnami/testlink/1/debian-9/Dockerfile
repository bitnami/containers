FROM bitnami/minideb-extras:stretch-r94
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libbz2-1.0 libc6 libcomerr2 libcurl3 libexpat1 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu57 libidn11 libidn2-0 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmcrypt4 libncurses5 libnettle6 libnghttp2-14 libp11-kit0 libpcre3 libpng16-16 libpq5 libpsl5 libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.0.2 libssl1.1 libstdc++6 libsybdb5 libtasn1-6 libtidy5 libtinfo5 libunistring0 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg unpack apache-2.4.34-1 --checksum 35ab4cfd39577d1e7c5f6ef815ff27940add60ba498f7db7e558085de57b9ee3
RUN bitnami-pkg unpack php-7.0.31-1 --checksum 820ec53b4671f5308575805afbbb48b2e870f0ff83da4746f8189b71ca31fb61
RUN bitnami-pkg unpack mysql-client-10.1.34-0 --checksum 7d537c0be87ed489edf0fc9ec386036a23b5d119e0a439e8b42181850a036b9a
RUN bitnami-pkg install libphp-7.0.31-0 --checksum d6e6bff000d896b9dbc1407d1e01ccc81d5845ea3fd9cb9af1a63d8060c62671
RUN bitnami-pkg unpack testlink-1.9.17-0 --checksum 518a988ece12b1d5280ee764fdf2d8f0b56eec30a4d3f130c6fac4597485c2e3

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="testlink" \
    BITNAMI_IMAGE_VERSION="1.9.17-debian-9-r22" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/mysql/bin:$PATH" \
    SMTP_CONNECTION_MODE="" \
    SMTP_ENABLE="false" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_USER="" \
    TESTLINK_DATABASE_NAME="bitnami_testlink" \
    TESTLINK_DATABASE_PASSWORD="" \
    TESTLINK_DATABASE_USER="bn_testlink" \
    TESTLINK_EMAIL="user@example.com" \
    TESTLINK_LANGUAGE="en_US" \
    TESTLINK_PASSWORD="bitnami" \
    TESTLINK_USERNAME="user"

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","apache"]
