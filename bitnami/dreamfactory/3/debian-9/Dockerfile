FROM bitnami/minideb-extras:stretch-r487
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libbz2-1.0 libc6 libcomerr2 libcurl3 libexpat1 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu57 libidn11 libidn2-0 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmcrypt4 libmemcached11 libmemcachedutil2 libncurses5 libnettle6 libnghttp2-14 libp11-kit0 libpcre3 libpng16-16 libpq5 libpsl5 libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.0.2 libssl1.1 libstdc++6 libsybdb5 libtasn1-6 libtidy5 libtinfo5 libunistring0 libuv1 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg unpack apache-2.4.41-2 --checksum 54e604bee81357824146780a26fbd99a889852240ae94cc4779264c9f231f535
RUN bitnami-pkg install redis-client-5.0.5-1 --checksum a44787c2f6aee259d3d1b83f0d41b5dede9a96667d0798083aab0cc927b0a556
RUN bitnami-pkg unpack php-7.1.32-3 --checksum ee807e1356f1f84db2149915de1d21146342d942474e2522641cb91e38a4a443
RUN bitnami-pkg install mysql-client-10.3.18-2 --checksum 9ba76d9543cc87642f23cc4987e12750e8690d45274c3701aa429ef19e3b8e08
RUN bitnami-pkg install mongodb-client-4.0.12-1 --checksum 313f0329cf3f25f5eb8b36caf1ec87381e82f303df332713fdecc6422ae77bda
RUN bitnami-pkg install libphp-7.1.32-1 --checksum b5a26bd1be0d9e03d9dce6c4fbf556b0a24f878f620a1f788006cc1f04c31104
RUN bitnami-pkg unpack dreamfactory-3.0.1-0 --checksum df6b9bf059e291a77d6cfe9d0c1049138f7f2502dcbac7342f9e2f5334596177

COPY rootfs /
ENV BITNAMI_APP_NAME="dreamfactory" \
    BITNAMI_IMAGE_VERSION="3.0.1-debian-9-r38" \
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
CMD [ "nami", "start", "--foreground", "apache" ]
