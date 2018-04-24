FROM bitnami/minideb-extras:jessie-r28
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libapr1 libaprutil1 libbz2-1.0 libc6 libcomerr2 libcurl3 libexpat1 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls-deb0-28 libgpg-error0 libgssapi-krb5-2 libhogweed2 libicu52 libidn11 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmcrypt4 libncurses5 libnettle4 libp11-kit0 libpcre3 libpng12-0 libpq5 libreadline6 librtmp1 libsasl2-2 libssh2-1 libssl1.0.0 libstdc++6 libsybdb5 libtasn1-6 libtidy-0.99-0 libtinfo5 libuuid1 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg unpack apache-2.4.33-0 --checksum 8b7e149b571298efb73d476ba0a87df0d0f8aa17fa3adf0590ffc0d37bf5d6cf
RUN bitnami-pkg unpack php-7.1.16-0 --checksum fcedd29037381558faa891c0966cb46c504306c5887b33a708395543f27b34c6
RUN bitnami-pkg unpack mysql-client-10.1.32-0 --checksum e65dc7fa2dd7fa6cac74d62a2cff2e3d40f650e721ac955381dc7b6f83d4a141
RUN bitnami-pkg install libphp-7.1.16-0 --checksum 3cecd20b90ee37662a8fc14812ccb07e53c9ec52b8c7b6bf22e6d88bfe13e199
RUN bitnami-pkg install drush-8.1.16-0 --checksum 6cdfc4f32b6c89ebf8fdeb6cc4d3223b0f5591cd0969a040319e6b8f53ab971f
RUN bitnami-pkg unpack drupal-8.5.2-1 --checksum 3b3e0a8969b6ade278ca7a7752542e085837f3c65368fec3feab291d79831b18

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="drupal" \
    BITNAMI_IMAGE_VERSION="8.5.2-r3" \
    DRUPAL_DATABASE_NAME="bitnami_drupal" \
    DRUPAL_DATABASE_PASSWORD="" \
    DRUPAL_DATABASE_USER="bn_drupal" \
    DRUPAL_EMAIL="user@example.com" \
    DRUPAL_PASSWORD="bitnami" \
    DRUPAL_USERNAME="user" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/mysql/bin:/opt/bitnami/drush:$PATH"

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["/run.sh"]
