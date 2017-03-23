FROM bitnami/minideb-extras:jessie-r13

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=drupal \
    BITNAMI_IMAGE_VERSION=8.2.7-r0 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/drush:/opt/bitnami/mysql/bin/:$PATH

# System packages required
RUN install_packages libaprutil1 libapr1 libc6 libuuid1 libexpat1 libssl1.0.0 libpcre3 libldap-2.4-2 libsasl2-2 libgnutls-deb0-28 zlib1g libp11-kit0 libtasn1-6 libnettle4 libhogweed2 libgmp10 libffi6 libxslt1.1 libtidy-0.99-0 libreadline6 libncurses5 libtinfo5 libmcrypt4 libstdc++6 libpng12-0 libjpeg62-turbo libbz2-1.0 libxml2 libcurl3 libfreetype6 libicu52 libgcc1 libgcrypt20 liblzma5 libidn11 librtmp1 libssh2-1 libgssapi-krb5-2 libkrb5-3 libk5crypto3 libcomerr2 libgpg-error0 libkrb5support0 libkeyutils1 libsybdb5 libpq5

# Additional modules require
RUN bitnami-pkg unpack apache-2.4.25-0 --checksum 8b46af7d737772d7d301da8b30a2770b7e549674e33b8a5b07480f53c39f5c3f
RUN bitnami-pkg unpack php-7.0.16-1 --checksum 870b6b92ef762fc3a49eeaa71dfa78bacabf50a5fa41f811cdd99a49844d9d9b
RUN bitnami-pkg install libphp-7.0.16-0 --checksum 91548c756818a24b9d5477d2cb09d4eff689a2c6ad51d2ef7cd99370020b6494
RUN bitnami-pkg install mysql-client-10.1.21-3 --checksum 9f636d5c4f0c734290ecbb93b51dd71bb81674fee14c3e517ec4f9440bb26bcb
RUN bitnami-pkg install drush-8.0.5-1 --checksum cdea2d5067ef67bcda7e5cfe96798c2d6e0167578395fac2d7a5f92a814ecc69

# Install drupal
RUN bitnami-pkg unpack drupal-8.2.7-0 --checksum 58c31129b87a121a5895ce2c0cda4d1975cfec376c4b3eb26b9df77669eadb54

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

CMD ["nami", "start", "--foreground", "apache"]
