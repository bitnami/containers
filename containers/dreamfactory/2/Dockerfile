FROM gcr.io/stacksmith-images/minideb:jessie-r11

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=dreamfactory \
    BITNAMI_IMAGE_VERSION=2.5.0-r0 \
    PATH=/opt/bitnami/mysql/bin/:/opt/bitnami/php/bin/:$PATH

# System packages required
RUN install_packages libssl1.0.0 libaprutil1 libapr1 libc6 libuuid1 libexpat1 libpcre3 libldap-2.4-2 libsasl2-2 libgnutls-deb0-28 zlib1g libp11-kit0 libtasn1-6 libnettle4 libhogweed2 libgmp10 libffi6 libxslt1.1 libtidy-0.99-0 libreadline6 libncurses5 libtinfo5 libmcrypt4 libstdc++6 libpng12-0 libjpeg62-turbo libbz2-1.0 libxml2 libcurl3 libfreetype6 libicu52 libgcc1 libgcrypt20 liblzma5 libidn11 librtmp1 libssh2-1 libgssapi-krb5-2 libkrb5-3 libk5crypto3 libcomerr2 libgpg-error0 libkrb5support0 libkeyutils1 libsybdb5 libpq5 libuv0.10

# Additional modules required
RUN bitnami-pkg unpack apache-2.4.25-0 --checksum 8b46af7d737772d7d301da8b30a2770b7e549674e33b8a5b07480f53c39f5c3f
RUN bitnami-pkg unpack php-7.0.16-1 --checksum 870b6b92ef762fc3a49eeaa71dfa78bacabf50a5fa41f811cdd99a49844d9d9b
RUN bitnami-pkg install libphp-7.0.16-0 --checksum 91548c756818a24b9d5477d2cb09d4eff689a2c6ad51d2ef7cd99370020b6494
RUN bitnami-pkg install mysql-client-10.1.21-3 --checksum 9f636d5c4f0c734290ecbb93b51dd71bb81674fee14c3e517ec4f9440bb26bcb
RUN bitnami-pkg install mongodb-client-3.4.2-1 --checksum 7ab29c774c254b155fdb0ea02ed244d8acd93964edab384df7fce3fd8e544673
RUN bitnami-pkg install redis-client-3.2.8-0 --checksum f4f899bfda566cb3c689a83d1763748a4790c0a8ad3513d82cce1c910f89c5a0

# Install dreamfactory
RUN bitnami-pkg unpack dreamfactory-2.5.0-1 --checksum 0e3077b8e45c4c7a202e712b04f65fc89b2ecd06fc00188f9f2481f28f88cb33

ENV APACHE_HTTP_PORT="80" \
    APACHE_HTTPS_PORT="443" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT="3306" \
    MARIADB_ROOT_USER="root" \
    MARIADB_ROOT_PASSWORD="" \
    MONGODB_HOST="mongodb" \
    MONGODB_PORT="27017" \
    REDIS_HOST="redis"

COPY rootfs /

VOLUME ["/bitnami/dreamfactory", "/bitnami/apache", "/bitnami/php"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami","start","--foreground","apache"]
