FROM bitnami/minideb-extras:jessie-r19
LABEL maintainer "Bitnami <containers@bitnami.com>"



# Install required system packages and dependencies
RUN install_packages libapr1 libaprutil1 libbz2-1.0 libc6 libcomerr2 libcurl3 libexpat1 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls-deb0-28 libgpg-error0 libgssapi-krb5-2 libhogweed2 libicu52 libidn11 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmcrypt4 libncurses5 libnettle4 libp11-kit0 libpcre3 libpng12-0 libpq5 libreadline6 librtmp1 libsasl2-2 libssh2-1 libssl1.0.0 libstdc++6 libsybdb5 libtasn1-6 libtidy-0.99-0 libtinfo5 libuuid1 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg unpack apache-2.4.26-0 --checksum 2d01547a273e715388bae110707a41f458b5092193d31e6b726b5527a56a1eac
RUN bitnami-pkg unpack php-7.1.6-0 --checksum 135fae0bd830e3c8d1bf1d8b314fcdfd9a32f7a884fc5a90b1662af0db953b9a
RUN bitnami-pkg install mysql-client-10.1.25-0 --checksum 513ef36ab1efa5570332547c2027ae29886fe4bb56472de11ca083423a3fe366
RUN bitnami-pkg install libphp-7.1.6-0 --checksum b0447c52cb825706ce41864e5d164ca4df1de30d10ffe4afc54f3888049f7712
RUN bitnami-pkg unpack osclass-3.7.3-0 --checksum 54437a74f6476867c7ec97fb00447bfa935daa901a3401ec71cebbf6f7c5dbe5

COPY rootfs /

ENV APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="osclass" \
    BITNAMI_IMAGE_VERSION="3.7.3-r4" \
    MARIADB_HOST="mariadb" \
    MARIADB_PASSWORD="" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_USER="root" \
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
