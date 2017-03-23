FROM bitnami/minideb-extras:jessie-r13

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=suitecrm \
    BITNAMI_IMAGE_VERSION=7.8.1-r3 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/apache/bin:/opt/bitnami/mariadb/bin/:$PATH

# System packages required
RUN install_packages libssl1.0.0 libaprutil1 libapr1 libc6 libuuid1 libexpat1 libpcre3 libldap-2.4-2 libsasl2-2 libgnutls-deb0-28 zlib1g libp11-kit0 libtasn1-6 libnettle4 libhogweed2 libgmp10 libffi6 libxslt1.1 libtidy-0.99-0 libreadline6 libncurses5 libtinfo5 libmcrypt4 libstdc++6 libpng12-0 libjpeg62-turbo libbz2-1.0 libxml2 libcurl3 libfreetype6 libicu52 libgcc1 libgcrypt20 liblzma5 libidn11 librtmp1 libssh2-1 libgssapi-krb5-2 libkrb5-3 libk5crypto3 libcomerr2 libgpg-error0 libkrb5support0 libkeyutils1 libsybdb5 libpq5

# Additional modules required
RUN bitnami-pkg unpack apache-2.4.25-0 --checksum 8b46af7d737772d7d301da8b30a2770b7e549674e33b8a5b07480f53c39f5c3f
RUN bitnami-pkg unpack php-7.0.15-4 --checksum 855e77fc7b87d1b263b08fdc96518c6fc301531923974917335f1cb8539d2a68
RUN bitnami-pkg install libphp-7.0.15-1 --checksum b65f40603838865d1974f071119cda9d63c80d9c14f146707dcd88940e215077
RUN bitnami-pkg install mysql-client-10.1.21-0 --checksum 8e868a3e46bfa59f3fb4e1aae22fd9a95fd656c020614a64706106ba2eba224e

# Install suitecrm
RUN bitnami-pkg unpack suitecrm-7.8.1-1 --checksum d0f0d2955a6131096ed94eb8e60e1e052a440a72fe7f0933f824142bcd358c78

COPY rootfs /

ENV APACHE_HTTP_PORT="80" \
    APACHE_HTTPS_PORT="443" \
    SUITECRM_USERNAME="user" \
    SUITECRM_LAST_NAME="Name" \
    SUITECRM_PASSWORD="bitnami" \
    SUITECRM_EMAIL="user@example.com" \
    MARIADB_USER="root" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT="3306"

VOLUME ["/bitnami/suitecrm", "/bitnami/apache", "/bitnami/php"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["/init.sh"]
