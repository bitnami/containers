FROM bitnami/minideb-extras:jessie-r24
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libapr1 libaprutil1 libbz2-1.0 libc6 libcomerr2 libcurl3 libexpat1 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls-deb0-28 libgpg-error0 libgssapi-krb5-2 libhogweed2 libicu52 libidn11 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmcrypt4 libncurses5 libnettle4 libp11-kit0 libpcap0.8 libpcre3 libpng12-0 libpq5 libreadline6 librtmp1 libsasl2-2 libssh2-1 libssl1.0.0 libstdc++6 libsybdb5 libtasn1-6 libtidy-0.99-0 libtinfo5 libuuid1 libuv0.10 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg unpack apache-2.4.33-0 --checksum 8b7e149b571298efb73d476ba0a87df0d0f8aa17fa3adf0590ffc0d37bf5d6cf
RUN bitnami-pkg install redis-client-4.0.9-0 --checksum 3de4cafc0663d94d597258d4d6f16358abb0bb7cf38aadc800c8fbf942f1e8ff
RUN bitnami-pkg unpack php-7.0.29-0 --checksum 978aae6e1eb9130edbfd2d340c0fccd8a294011b7582c1fa290cd6c12a8f8732
RUN bitnami-pkg install mysql-client-10.1.32-0 --checksum e65dc7fa2dd7fa6cac74d62a2cff2e3d40f650e721ac955381dc7b6f83d4a141
RUN bitnami-pkg install mongodb-client-3.7.2-0 --checksum 8c9d4f443ee9625b255c65d251e059084b477c71eacfe369f3b2df97335a0b6f
RUN bitnami-pkg install libphp-7.0.29-0 --checksum 4b37430c93913ba40be454a5837993ca60c3e6f15018d83df5619f16ff20af1c
RUN bitnami-pkg unpack dreamfactory-2.12.0-0 --checksum 6a51a4c9d3982da10e46a38282dd9de8a6c77b322a62e07d63c2ac3b0a313e12

COPY rootfs /

ENV APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="dreamfactory" \
    BITNAMI_IMAGE_VERSION="2.12.0-r2" \
    MARIADB_HOST="mariadb" \
    MARIADB_PASSWORD="" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_USER="root" \
    MONGODB_HOST="mongodb" \
    MONGODB_PASSWORD="" \
    MONGODB_PORT_NUMBER="27017" \
    MONGODB_USER="" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/redis-client/bin:/opt/bitnami/php/bin:/opt/bitnami/mysql/bin:/opt/bitnami/mongodb/bin:$PATH" \
    REDIS_HOST="redis" \
    REDIS_PASSWORD="" \
    REDIS_PORT_NUMBER="6379" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_PROTOCOL="" \
    SMTP_USER=""

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","apache"]
