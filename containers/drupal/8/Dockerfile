FROM bitnami/minideb-extras:jessie-r22
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libapr1 libaprutil1 libbz2-1.0 libc6 libcomerr2 libcurl3 libexpat1 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls-deb0-28 libgpg-error0 libgssapi-krb5-2 libhogweed2 libicu52 libidn11 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmcrypt4 libncurses5 libnettle4 libp11-kit0 libpcre3 libpng12-0 libpq5 libreadline6 librtmp1 libsasl2-2 libssh2-1 libssl1.0.0 libstdc++6 libsybdb5 libtasn1-6 libtidy-0.99-0 libtinfo5 libuuid1 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg unpack apache-2.4.29-0 --checksum 38af9f5ee6088655536238d9f70f4ce7fd6047e1c84fd5b02fa351efbc4f60c6
RUN bitnami-pkg unpack php-7.0.26-1 --checksum c2862ccbd91f993cf7862e8637434f718a62e3c2b90dcd933b21023e00b841ca
RUN bitnami-pkg unpack mysql-client-10.1.30-0 --checksum 2f7bfecc0e405c53c0dc0508670af2b87124fbf3475f597fe8359e85d14e2a0c
RUN bitnami-pkg install libphp-7.0.26-0 --checksum d797c28ea51a77aa19707f3594176057f26a888d4fc6254db752433739cf974f
RUN bitnami-pkg install drush-8.1.15-0 --checksum 3f3b9931aebc37c5a63dc6bc2ae1657dc0152054b787e64cd19b33a9e56024c3
RUN bitnami-pkg unpack drupal-8.4.4-0 --checksum b0108da7bc88b88ab30f556fbdc086917026227f093d72283434e863a83e8a03

COPY rootfs /

ENV ALLOW_EMPTY_PASSWORD="no" \
    APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="drupal" \
    BITNAMI_IMAGE_VERSION="8.4.4-r0" \
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
