FROM bitnami/minideb-extras:stretch-r333
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libbz2-1.0 libc6 libcomerr2 libcurl3 libexpat1 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu57 libidn11 libidn2-0 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmcrypt4 libmemcached11 libmemcachedutil2 libncurses5 libnettle6 libnghttp2-14 libp11-kit0 libpcre3 libpng16-16 libpq5 libpsl5 libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.0.2 libssl1.1 libstdc++6 libsybdb5 libtasn1-6 libtidy5 libtinfo5 libunistring0 libuv1 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg unpack apache-2.4.39-0 --checksum e6108f6ea91c18d8f5481a1015b301d17ea59ba9d641e1a06b3860d66ffa46b0
RUN bitnami-pkg install redis-client-4.0.14-0 --checksum d5a5372563f5059746d8dac878439a16e3b7898b62bab2518f37b66d98dd6d69
RUN bitnami-pkg unpack php-7.1.27-0 --checksum 4b1d988744f941ce434e6367ae2ebb24d5eb0165ff8a5f17fb8c3f048cfc6189
RUN bitnami-pkg install mysql-client-10.2.23-0 --checksum 3f364d915f1e62037db20a41c7d750004d69c897dd7934e9a3cd2d4c491f4175
RUN bitnami-pkg install mongodb-client-3.6.11-0 --checksum e77cafbdc2761d551864c38aaba80f38672af81dff6096d461e4edb081c42d8c
RUN bitnami-pkg unpack libphp-7.1.27-1 --checksum 76b77f8e1a604e9f9d22f92ab400b98c0162ca6240643d231fc106cbd8130684
RUN bitnami-pkg unpack dreamfactory-2.14.1-20 --checksum de247f6c455feefe15f5a3c2700c5e91259be7f06c06a12e49e952c0a0229686
RUN mkdir -p /opt/bitnami/apache/tmp && chmod g+rwX /opt/bitnami/apache/tmp
RUN ln -sf /dev/stdout /opt/bitnami/apache/logs/access_log
RUN ln -sf /dev/stderr /opt/bitnami/apache/logs/error_log

COPY rootfs /
ENV APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="dreamfactory" \
    BITNAMI_IMAGE_VERSION="2.14.1-debian-9-r171" \
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
