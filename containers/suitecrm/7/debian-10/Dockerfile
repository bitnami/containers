FROM bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/mysql/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates cron curl dirmngr gnupg libbz2-1.0 libc6 libcom-err2 libcurl4 libexpat1 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmemcached11 libmemcachedutil2 libncurses6 libnettle6 libnghttp2-14 libp11-kit0 libpcre3 libpng16-16 libpq5 libpsl5 libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.1 libstdc++6 libsybdb5 libtasn1-6 libtidy5deb1 libtinfo6 libunistring2 libxml2 libxslt1.1 libzip4 procps sudo unzip zlib1g
RUN /build/bitnami-user.sh && \
    /build/install-nami.sh
RUN bitnami-pkg unpack apache-2.4.41-0 --checksum 0364e80e08a89fda2d2d302609f813d5d497b6cb6bcf6643d2770b825abbc0fb
RUN bitnami-pkg unpack php-7.3.14-0 --checksum 58ea3eac602c9e840afb1cde192bda1018c62e3485c41962bc0266b079dd731f
RUN bitnami-pkg unpack mysql-client-10.3.22-0 --checksum 9529ac5187264223e3852602f7d9a51ed0b2547bbed99f3d05f3b7fa20adf57f
RUN bitnami-pkg install libphp-7.3.14-0 --checksum b9d1872eeaf47fe678aaefd4d5925be1bbab64d67f808c14d849039a204faad8
RUN bitnami-pkg unpack suitecrm-7.11.10-0 --checksum ad73e00590acb5710c1b22bfa18c26eb9a66e1c58a655107a4a79be728a41b21
RUN apt-get update && apt-get upgrade && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN sed -i -e '/pam_loginuid.so/ s/^#*/#/' /etc/pam.d/cron
RUN /build/install-gosu.sh
RUN /build/install-tini.sh

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="suitecrm" \
    BITNAMI_IMAGE_VERSION="7.11.10-debian-10-r7" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    SUITECRM_DATABASE_NAME="bitnami_<<name>>" \
    SUITECRM_DATABASE_PASSWORD="" \
    SUITECRM_DATABASE_USER="bn_<<name>>" \
    SUITECRM_EMAIL="user@example.com" \
    SUITECRM_HOST="127.0.0.1" \
    SUITECRM_HTTP_TIMEOUT="120" \
    SUITECRM_LAST_NAME="Name" \
    SUITECRM_PASSWORD="bitnami" \
    SUITECRM_SMTP_HOST="" \
    SUITECRM_SMTP_PASSWORD="" \
    SUITECRM_SMTP_PORT="" \
    SUITECRM_SMTP_PROTOCOL="" \
    SUITECRM_SMTP_USER="" \
    SUITECRM_USERNAME="user" \
    SUITECRM_VALIDATE_USER_IP="yes"

EXPOSE 80 443

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
