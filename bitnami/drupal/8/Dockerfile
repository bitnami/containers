FROM bitnami/minideb-extras:jessie-r13

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=drupal \
    BITNAMI_IMAGE_VERSION=8.3.1-r1 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/drush:/opt/bitnami/mysql/bin/:/opt/bitnami/apache/bin/:$PATH

# System packages required
RUN install_packages libaprutil1 libapr1 libc6 libuuid1 libexpat1 libssl1.0.0 libpcre3 libldap-2.4-2 libsasl2-2 libgnutls-deb0-28 zlib1g libp11-kit0 libtasn1-6 libnettle4 libhogweed2 libgmp10 libffi6 libxslt1.1 libtidy-0.99-0 libreadline6 libncurses5 libtinfo5 libmcrypt4 libstdc++6 libpng12-0 libjpeg62-turbo libbz2-1.0 libxml2 libcurl3 libfreetype6 libicu52 libgcc1 libgcrypt20 liblzma5 libidn11 librtmp1 libssh2-1 libgssapi-krb5-2 libkrb5-3 libk5crypto3 libcomerr2 libgpg-error0 libkrb5support0 libkeyutils1 libsybdb5 libpq5

# Additional modules require
RUN bitnami-pkg unpack apache-2.4.25-0 --checksum 8b46af7d737772d7d301da8b30a2770b7e549674e33b8a5b07480f53c39f5c3f
RUN bitnami-pkg unpack php-7.0.18-0 --checksum 71c77e2a448543126606f054ae6dc85d893dc39e36d2bc55eb496f6910561a80
RUN bitnami-pkg install libphp-7.0.18-0 --checksum 315fafc5c3942d854971ddc660cc35586e79d867af41c516c23a02871d22a5f6
RUN bitnami-pkg install mysql-client-10.1.22-3 --checksum 9e881a7c404f658c93abd665ecd1372f61a591d784e6456c64c0129358a7ff1a
RUN bitnami-pkg install drush-8.0.5-1 --checksum cdea2d5067ef67bcda7e5cfe96798c2d6e0167578395fac2d7a5f92a814ecc69

# Install drupal
RUN bitnami-pkg unpack drupal-8.3.1-0 --checksum 4e355cfc1d1a456628bb28a8b2ed8b2c4ad84fd3740d75f275469c3a1ad468fa

COPY rootfs /

ENV APACHE_HTTP_PORT="80" \
    APACHE_HTTPS_PORT="443" \
    DRUPAL_USERNAME="user" \
    DRUPAL_PASSWORD="bitnami" \
    DRUPAL_EMAIL="user@example.com" \
    MARIADB_USER="root" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT="3306"

VOLUME ["/bitnami/drupal", "/bitnami/apache", "/bitnami/php"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["/run.sh"]
