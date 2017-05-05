FROM bitnami/minideb-extras:jessie-r15

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=suitecrm \
    BITNAMI_IMAGE_VERSION=7.8.3-r2 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/apache/bin:/opt/bitnami/mariadb/bin/:$PATH

# System packages required
RUN install_packages libaprutil1 libapr1 libc6 libuuid1 libexpat1 libssl1.0.0 libpcre3 libldap-2.4-2 libsasl2-2 libgnutls-deb0-28 zlib1g libp11-kit0 libtasn1-6 libnettle4 libhogweed2 libgmp10 libffi6 libxslt1.1 libtidy-0.99-0 libreadline6 libncurses5 libtinfo5 libmcrypt4 libstdc++6 libpng12-0 libjpeg62-turbo libbz2-1.0 libxml2 libcurl3 libfreetype6 libicu52 libgcc1 libgcrypt20 liblzma5 libidn11 librtmp1 libssh2-1 libgssapi-krb5-2 libkrb5-3 libk5crypto3 libcomerr2 libgpg-error0 libkrb5support0 libkeyutils1 libsybdb5 libpq5

# Additional modules required
RUN bitnami-pkg unpack apache-2.4.25-0 --checksum 8b46af7d737772d7d301da8b30a2770b7e549674e33b8a5b07480f53c39f5c3f
RUN bitnami-pkg unpack php-7.0.18-0 --checksum 71c77e2a448543126606f054ae6dc85d893dc39e36d2bc55eb496f6910561a80
RUN bitnami-pkg install libphp-7.0.18-0 --checksum 315fafc5c3942d854971ddc660cc35586e79d867af41c516c23a02871d22a5f6
RUN bitnami-pkg install mysql-client-10.1.23-0 --checksum 9c38e41f237a4b9ce1aca7b9ecad86be5c55b924880cef45b87d635a4aea9d3d

# Install suitecrm
RUN bitnami-pkg unpack suitecrm-7.8.3-1 --checksum 03702aedb1b7e940a4872141eb236524d9f35cc727f1523e200709c879227831

COPY rootfs /

ENV APACHE_HTTP_PORT="80" \
    APACHE_HTTPS_PORT="443" \
    SUITECRM_USERNAME="user" \
    SUITECRM_LAST_NAME="Name" \
    SUITECRM_PASSWORD="bitnami" \
    SUITECRM_EMAIL="user@example.com" \
    MARIADB_USER="root" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT="3306"

VOLUME ["/bitnami/suitecrm", "/bitnami/apache", "/bitnami/php"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["/init.sh"]
