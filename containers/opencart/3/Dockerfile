FROM bitnami/minideb-extras:jessie-r75
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libapr1 libaprutil1 libbz2-1.0 libc6 libcomerr2 libcurl3 libexpat1 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls-deb0-28 libgpg-error0 libgssapi-krb5-2 libhogweed2 libicu52 libidn11 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmcrypt4 libncurses5 libnettle4 libp11-kit0 libpcre3 libpng12-0 libpq5 libreadline6 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.0.0 libstdc++6 libsybdb5 libtasn1-6 libtidy-0.99-0 libtinfo5 libuuid1 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg unpack apache-2.4.33-4 --checksum f26751a96abdc45db43c4b92eb9f792a4b630ad0edd5667aa73ccafa0aeb3810
RUN bitnami-pkg unpack php-7.0.30-5 --checksum 8b8f5178a659f816a4319125fc0997010e2e2cca9ba09bac7e308119973db106
RUN bitnami-pkg unpack mysql-client-10.1.33-0 --checksum 1b1608f1c1f4e21f05037225e095c49035ad8bfdb8b580abbb904c9f2448a5c6
RUN bitnami-pkg install libphp-7.0.30-8 --checksum 0fb74a5477bdf72ee85751af91ee2e41beec5b18657a9891d7081a3e2ce7289e
RUN bitnami-pkg unpack opencart-3.0.2-0-2 --checksum 7e88941da42c2dd152841dd5b296ea88b5a59d1695e9b252cc80525205edfa85

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="opencart" \
    BITNAMI_IMAGE_VERSION="3.0.2-0-r43" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    OPENCART_DATABASE_NAME="bitnami_opencart" \
    OPENCART_DATABASE_PASSWORD="" \
    OPENCART_DATABASE_USER="bn_opencart" \
    OPENCART_EMAIL="user@example.com" \
    OPENCART_HOST="127.0.0.1" \
    OPENCART_PASSWORD="bitnami1" \
    OPENCART_USERNAME="user" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/mysql/bin:$PATH" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_PROTOCOL="" \
    SMTP_USER=""

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","apache"]
