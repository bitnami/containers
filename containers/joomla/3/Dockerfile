FROM bitnami/minideb-extras:jessie-r22
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libapr1 libaprutil1 libbz2-1.0 libc6 libcomerr2 libcurl3 libexpat1 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls-deb0-28 libgpg-error0 libgssapi-krb5-2 libhogweed2 libicu52 libidn11 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmcrypt4 libncurses5 libnettle4 libp11-kit0 libpcre3 libpng12-0 libpq5 libreadline6 librtmp1 libsasl2-2 libssh2-1 libssl1.0.0 libstdc++6 libsybdb5 libtasn1-6 libtidy-0.99-0 libtinfo5 libuuid1 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg unpack apache-2.4.27-0 --checksum 27b8591b6564856428e2a3480949d549316e2f7e5bd207faa7b8c6e3a9bb9cc0
RUN bitnami-pkg unpack php-7.0.24-0 --checksum 05908d63d2d54cdeb5123e89a71e1355d25ffa2e84d448088d05aba3e3b3855f
RUN bitnami-pkg install mysql-client-10.1.28-0 --checksum 8a0ccfd6a62ffccdb25fcf39754c2526b120f416dd390194e8d6edd2ec8ddcee
RUN bitnami-pkg install libphp-7.0.24-0 --checksum bbaa3ed760fc144e3f0a68f8aafa11ae24816d783f5cc757087a8089974fc5cd
RUN bitnami-pkg unpack joomla-3.8.1-0 --checksum 7a3f90962a03b0497b93299d414c80e0ec6dc1c8e6fb8a02a84f86b08a8ce026

COPY rootfs /

ENV APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="joomla" \
    BITNAMI_IMAGE_VERSION="3.8.1-r0" \
    JOOMLA_EMAIL="user@example.com" \
    JOOMLA_FIRST_NAME="User" \
    JOOMLA_LAST_NAME="Name" \
    JOOMLA_PASSWORD="bitnami" \
    JOOMLA_USERNAME="user" \
    MARIADB_HOST="mariadb" \
    MARIADB_PASSWORD="" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_USER="root" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/mysql/bin:$PATH" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_PROTOCOL="tls" \
    SMTP_USER=""

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","apache"]
