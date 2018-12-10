FROM bitnami/minideb-extras:stretch-r218
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libbz2-1.0 libc6 libcomerr2 libcurl3 libexpat1 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu57 libidn11 libidn2-0 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmcrypt4 libmemcached11 libmemcachedutil2 libncurses5 libnettle6 libnghttp2-14 libp11-kit0 libpcap0.8 libpcre3 libpng16-16 libpq5 libpsl5 libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.0.2 libssl1.1 libstdc++6 libsybdb5 libtasn1-6 libtidy5 libtinfo5 libunistring0 libuv1 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg unpack apache-2.4.37-20 --checksum 810294929de06cf7019e88df932ce5776f4b49458914382cdd69cbe7d3acfc85
RUN bitnami-pkg install redis-client-4.0.11-2 --checksum cd23f28ac660a179d25d238d5d74958d577b8b91c877954a805f54fc1e13eb91
RUN bitnami-pkg unpack php-7.1.25-0 --checksum 8030630711336415f43e2f757ee7da368809b1b5f5bc49ac2e1de253c8820da8
RUN bitnami-pkg install mysql-client-10.2.19-0 --checksum 3546a8f5166c6c945b65f58cbadf8355e9389c019390a2f3dba72caa3af6efb5
RUN bitnami-pkg install mongodb-client-3.6.8-0 --checksum a677064910e00fdf3289720ce77ec130eda12aceb058ee7526a1523b7bdf178b
RUN bitnami-pkg unpack libphp-7.1.25-20 --checksum a399bce1ef71a9a8965abc499b5abed2bb7862e28136223ab0b87f689748f9e1
RUN bitnami-pkg unpack dreamfactory-2.14.1-20 --checksum de247f6c455feefe15f5a3c2700c5e91259be7f06c06a12e49e952c0a0229686
RUN mkdir -p /opt/bitnami/apache/tmp && chmod g+rwX /opt/bitnami/apache/tmp
RUN ln -sf /dev/stdout /opt/bitnami/apache/logs/access_log
RUN ln -sf /dev/stderr /opt/bitnami/apache/logs/error_log

COPY rootfs /
ENV APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="dreamfactory" \
    BITNAMI_IMAGE_VERSION="2.14.1-debian-9-r61" \
    MARIADB_HOST="mariadb" \
    MARIADB_PASSWORD="" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_USER="root" \
    MONGODB_HOST="mongodb" \
    MONGODB_PASSWORD="" \
    MONGODB_PORT_NUMBER="27017" \
    MONGODB_USER="" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/redis/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/mysql/bin:/opt/bitnami/mongodb/bin:$PATH" \
    REDIS_HOST="redis" \
    REDIS_PASSWORD="" \
    REDIS_PORT_NUMBER="6379" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_PROTOCOL="" \
    SMTP_USER=""

EXPOSE 80 443

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "httpd", "-f", "/bitnami/apache/conf/httpd.conf", "-DFOREGROUND" ]
