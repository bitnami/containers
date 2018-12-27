FROM bitnami/minideb-extras:stretch-r235
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libbz2-1.0 libc6 libcomerr2 libcurl3 libexpat1 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu57 libidn11 libidn2-0 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmcrypt4 libmemcached11 libmemcachedutil2 libncurses5 libnettle6 libnghttp2-14 libp11-kit0 libpcre3 libpng16-16 libpq5 libpsl5 libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.0.2 libssl1.1 libstdc++6 libsybdb5 libtasn1-6 libtidy5 libtinfo5 libunistring0 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg unpack apache-2.4.37-21 --checksum b930db2471cbcdf2639c647794e724972cfcaba777ba0b922ddfc604a79c23fa
RUN bitnami-pkg unpack php-7.1.25-21 --checksum 9c0ca4fc5ddafad98d27c94d459a921c1077139d5ece08198a6a48d18485fe13
RUN bitnami-pkg unpack mysql-client-10.1.37-21 --checksum b7a5a18edfffc9440e852a412ea08a90e5f64924240f1f76a2813e6e93edaa39
RUN bitnami-pkg unpack libphp-7.1.25-21 --checksum c55887490c4242caaf4a7a9abefefaff71b5413cec6965b1e08a2795e4aff167
RUN bitnami-pkg unpack mediawiki-1.31.1-20 --checksum 170f5f74d2c1111798dcb9803766166a151a3758d0c7b9181d59addd067a915b
RUN mkdir -p /opt/bitnami/apache/tmp && chmod g+rwX /opt/bitnami/apache/tmp
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
RUN ln -sf /dev/stdout /opt/bitnami/apache/logs/access_log
RUN ln -sf /dev/stderr /opt/bitnami/apache/logs/error_log

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="mediawiki" \
    BITNAMI_IMAGE_VERSION="1.31.1-debian-9-r78" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
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
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/mysql/bin:$PATH" \
    SMTP_HOST="" \
    SMTP_HOST_ID="" \
    SMTP_PASSWORD="" \
    SMTP_PORT=""

EXPOSE 80 443

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "httpd", "-f", "/bitnami/apache/conf/httpd.conf", "-DFOREGROUND" ]
