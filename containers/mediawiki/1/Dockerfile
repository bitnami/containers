FROM bitnami/minideb-extras:jessie-r48
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libapr1 libaprutil1 libbz2-1.0 libc6 libcomerr2 libcurl3 libexpat1 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls-deb0-28 libgpg-error0 libgssapi-krb5-2 libhogweed2 libicu52 libidn11 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmcrypt4 libncurses5 libnettle4 libp11-kit0 libpcre3 libpng12-0 libpq5 libreadline6 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.0.0 libstdc++6 libsybdb5 libtasn1-6 libtidy-0.99-0 libtinfo5 libuuid1 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg unpack apache-2.4.33-1 --checksum 6d75b2446161eed96d5ab40d301d9a21d7d304f0323642fee9760e8525b0f852
RUN bitnami-pkg unpack php-7.0.30-3 --checksum 6bd722cbf50b23d159394997370e1066fa1d4e05a70ff19fb940046db526c54b
RUN bitnami-pkg unpack mysql-client-10.1.32-4 --checksum b5469f2122a5b9b19b9b3c96c8f7903503506ea756738c681dd56360cdf887d1
RUN bitnami-pkg install libphp-7.0.30-3 --checksum 56a92497c5965c026a1faaa25bd7c47a65d629330d3f047f53a06a49d183c85f
RUN bitnami-pkg unpack mediawiki-1.30.0-0 --checksum f1a1caea8933c9485a0e432266074ecc3b62dd21339e5ee93100a940c90f5d3e

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="mediawiki" \
    BITNAMI_IMAGE_VERSION="1.30.0-r25" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MEDIAWIKI_DATABASE_NAME="bitnami_mediawiki" \
    MEDIAWIKI_DATABASE_PASSWORD="" \
    MEDIAWIKI_DATABASE_USER="bn_mediawiki" \
    MEDIAWIKI_EMAIL="user@example.com" \
    MEDIAWIKI_PASSWORD="bitnami1" \
    MEDIAWIKI_USERNAME="user" \
    MEDIAWIKI_WIKI_NAME="Bitnami MediaWiki" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/mysql/bin:$PATH" \
    SMTP_HOST="" \
    SMTP_HOST_ID="" \
    SMTP_PASSWORD="" \
    SMTP_PORT=""

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","apache"]
