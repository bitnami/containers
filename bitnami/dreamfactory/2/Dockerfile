FROM bitnami/minideb-extras:jessie-r68
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libapr1 libaprutil1 libbz2-1.0 libc6 libcomerr2 libcurl3 libexpat1 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls-deb0-28 libgpg-error0 libgssapi-krb5-2 libhogweed2 libicu52 libidn11 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmcrypt4 libncurses5 libnettle4 libp11-kit0 libpcap0.8 libpcre3 libpng12-0 libpq5 libreadline6 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.0.0 libstdc++6 libsybdb5 libtasn1-6 libtidy-0.99-0 libtinfo5 libuuid1 libuv0.10 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg unpack apache-2.4.33-4 --checksum f26751a96abdc45db43c4b92eb9f792a4b630ad0edd5667aa73ccafa0aeb3810
RUN bitnami-pkg install redis-client-4.0.9-0 --checksum 3de4cafc0663d94d597258d4d6f16358abb0bb7cf38aadc800c8fbf942f1e8ff
RUN bitnami-pkg unpack php-7.0.30-4 --checksum e6c48cb951db7abeb83319bf06155385a5170a833e2ebfd1ee61e137633c0c7a
RUN bitnami-pkg install mysql-client-10.1.33-0 --checksum 1b1608f1c1f4e21f05037225e095c49035ad8bfdb8b580abbb904c9f2448a5c6
RUN bitnami-pkg install mongodb-client-3.6.5-0 --checksum 3bbd11cf129e37857075e4babd8735d4a6f7511908bc09fbe6bf666ab3550521
RUN bitnami-pkg install libphp-7.0.30-7 --checksum ee53b007b7ba11b7202fff5c112d0b13fd78cabab8fabf13a94723475f325f2e
RUN bitnami-pkg unpack dreamfactory-2.12.0-0 --checksum 6a51a4c9d3982da10e46a38282dd9de8a6c77b322a62e07d63c2ac3b0a313e12

COPY rootfs /
ENV APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="dreamfactory" \
    BITNAMI_IMAGE_VERSION="2.12.0-r37" \
    MARIADB_HOST="mariadb" \
    MARIADB_PASSWORD="" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_USER="root" \
    MONGODB_HOST="mongodb" \
    MONGODB_PASSWORD="" \
    MONGODB_PORT_NUMBER="27017" \
    MONGODB_USER="" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/redis/bin:/opt/bitnami/php/bin:/opt/bitnami/mysql/bin:/opt/bitnami/mongodb/bin:$PATH" \
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
