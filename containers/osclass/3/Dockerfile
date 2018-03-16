FROM bitnami/minideb-extras:jessie-r24
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libapr1 libaprutil1 libbz2-1.0 libc6 libcomerr2 libcurl3 libexpat1 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls-deb0-28 libgpg-error0 libgssapi-krb5-2 libhogweed2 libicu52 libidn11 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmcrypt4 libncurses5 libnettle4 libp11-kit0 libpcre3 libpng12-0 libpq5 libreadline6 librtmp1 libsasl2-2 libssh2-1 libssl1.0.0 libstdc++6 libsybdb5 libtasn1-6 libtidy-0.99-0 libtinfo5 libuuid1 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg unpack apache-2.4.29-1 --checksum 42114e87aafb1d519ab33451b6836873bca125d78ce7423c5f7f1de4a7198596
RUN bitnami-pkg unpack php-7.1.15-1 --checksum 2cd22fa0293f483a2fc26f8bdd14c04c92067bf8d064c08acf7d33998179bf27
RUN bitnami-pkg unpack mysql-client-10.1.31-0 --checksum c5140f9fd386782201b78559972045018928a405df324564deb392c6c61073c1
RUN bitnami-pkg install libphp-7.1.15-0 --checksum f7573e30ebf7a686c5b0c2bc481685948c09f9f9d6da414cb1a7aaccc840d7fa
RUN bitnami-pkg unpack osclass-3.7.4-2 --checksum 78f2b8200bbd85ea4348bf1e9c02068ae1d704885b6e3aa91a585b5b583c2e9c

COPY rootfs /

ENV ALLOW_EMPTY_PASSWORD="no" \
    APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="osclass" \
    BITNAMI_IMAGE_VERSION="3.7.4-r4" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    OSCLASS_DATABASE_NAME="bitnami_osclass" \
    OSCLASS_DATABASE_PASSWORD="" \
    OSCLASS_DATABASE_USER="bn_osclass" \
    OSCLASS_EMAIL="user@example.com" \
    OSCLASS_HOST="127.0.0.1" \
    OSCLASS_PASSWORD="bitnami1" \
    OSCLASS_PING_ENGINES="1" \
    OSCLASS_SAVE_STATS="1" \
    OSCLASS_USERNAME="user" \
    OSCLASS_WEB_TITLE="Sample Web Page" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/mysql/bin:$PATH" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_PROTOCOL="" \
    SMTP_USER=""

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","apache"]
