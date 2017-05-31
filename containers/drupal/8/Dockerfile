FROM bitnami/minideb-extras:jessie-r16
LABEL maintainer "Bitnami <containers@bitnami.com>"



# Install required system packages and dependencies
RUN install_packages libapr1 libaprutil1 libbz2-1.0 libc6 libcomerr2 libcurl3 libexpat1 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls-deb0-28 libgpg-error0 libgssapi-krb5-2 libhogweed2 libicu52 libidn11 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmcrypt4 libncurses5 libnettle4 libp11-kit0 libpcre3 libpng12-0 libpq5 libreadline6 librtmp1 libsasl2-2 libssh2-1 libssl1.0.0 libstdc++6 libsybdb5 libtasn1-6 libtidy-0.99-0 libtinfo5 libuuid1 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg unpack apache-2.4.25-0 --checksum 8b46af7d737772d7d301da8b30a2770b7e549674e33b8a5b07480f53c39f5c3f
RUN bitnami-pkg unpack php-7.0.19-0 --checksum dcd5e4a19792dbfde5157d33f09e3c030ac11da92606ade08576bea795d6ac53
RUN bitnami-pkg install mysql-client-10.1.23-1 --checksum 0be92fcc4f7fec93edfa7f788e2bbb87b5b3aac92dfdec159a10590345362512
RUN bitnami-pkg install libphp-7.0.19-1 --checksum a72cb1bc3513549b5e94052549e78921a127617c38a4bd4586ae26976cac0af6
RUN bitnami-pkg install drush-8.0.5-1 --checksum cdea2d5067ef67bcda7e5cfe96798c2d6e0167578395fac2d7a5f92a814ecc69
RUN bitnami-pkg unpack drupal-8.3.2-0 --checksum ef523bae111d0dc9ec8817a269a68f4ca13bb4a54a76d4ae2b0d2a5ec1c7b39c

COPY rootfs /

ENV APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="drupal" \
    BITNAMI_IMAGE_VERSION="8.3.2-r1" \
    DRUPAL_EMAIL="user@example.com" \
    DRUPAL_PASSWORD="bitnami" \
    DRUPAL_USERNAME="user" \
    MARIADB_HOST="mariadb" \
    MARIADB_PASSWORD="" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_USER="root" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/mysql/bin:/opt/bitnami/drush:$PATH"



VOLUME ["/bitnami/apache","/bitnami/drupal","/bitnami/php"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["/run.sh"]
