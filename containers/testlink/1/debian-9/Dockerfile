FROM bitnami/minideb-extras:stretch-r493
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libbz2-1.0 libc6 libcomerr2 libcurl3 libexpat1 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu57 libidn11 libidn2-0 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmemcached11 libmemcachedutil2 libncurses5 libnettle6 libnghttp2-14 libp11-kit0 libpcre3 libpng16-16 libpq5 libpsl5 libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.0.2 libssl1.1 libstdc++6 libsybdb5 libtasn1-6 libtidy5 libtinfo5 libunistring0 libxml2 libxslt1.1 libzip4 zlib1g
RUN bitnami-pkg unpack apache-2.4.41-2 --checksum 54e604bee81357824146780a26fbd99a889852240ae94cc4779264c9f231f535
RUN bitnami-pkg unpack php-7.3.10-3 --checksum 798b160f2f9d31bfd0dff0683741767e93bbd1a326501cf94838a08d7119d3ca
RUN bitnami-pkg unpack mysql-client-10.3.18-2 --checksum 9ba76d9543cc87642f23cc4987e12750e8690d45274c3701aa429ef19e3b8e08
RUN bitnami-pkg install libphp-7.3.10-0 --checksum 327bb89c9b0872d0bffd22476e623af4862b0c5401c0280ac626eb5406a2c51e
RUN bitnami-pkg unpack testlink-1.9.19-2 --checksum b91eb82ed2bedd9a779a11f4938ec544db5a3d3e6daac8ca9fb1fbcd8038368e

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="testlink" \
    BITNAMI_IMAGE_VERSION="1.9.19-debian-9-r229" \
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

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "apache" ]
