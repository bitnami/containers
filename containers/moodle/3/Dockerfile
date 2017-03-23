FROM bitnami/minideb-extras:jessie-r13

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=moodle \
    BITNAMI_IMAGE_VERSION=3.2.1-r3 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/mysql/bin/:$PATH

# System packages required
RUN install_packages libssl1.0.0 libaprutil1 libapr1 libc6 libuuid1 libexpat1 libpcre3 libldap-2.4-2 libsasl2-2 libgnutls-deb0-28 zlib1g libp11-kit0 libtasn1-6 libnettle4 libhogweed2 libgmp10 libffi6 libncurses5 libtinfo5 libstdc++6 libgcc1 libxslt1.1 libtidy-0.99-0 libreadline6 libsybdb5 libmcrypt4 libpng12-0 libjpeg62-turbo libbz2-1.0 libxml2 libcurl3 libfreetype6 libicu52 libgcrypt20 libgssapi-krb5-2 liblzma5 libidn11 librtmp1 libssh2-1 libkrb5-3 libk5crypto3 libcomerr2 libgpg-error0 libkrb5support0 libkeyutils1

# Additional modules required
RUN bitnami-pkg unpack apache-2.4.25-0 --checksum 8b46af7d737772d7d301da8b30a2770b7e549674e33b8a5b07480f53c39f5c3f
RUN bitnami-pkg install mysql-client-10.1.21-0 --checksum 8e868a3e46bfa59f3fb4e1aae22fd9a95fd656c020614a64706106ba2eba224e
RUN bitnami-pkg unpack php-7.1.1-1 --checksum cc64828e801996f2f84d48814d8f74687ffbb0bb15f078586b2bf0a50371c7a9
RUN bitnami-pkg install libphp-7.1.1-0 --checksum 44dcbd3692c4de97638bb8830619f3dbb555e59686804393cd0f2c6038fdcd31

# Install moodle
RUN bitnami-pkg unpack moodle-3.2.1-0 --checksum eebfb4df5bf66921373405a606f95d51eff911fea2f4b55440256b6c5624f448

COPY rootfs /

ENV MOODLE_USERNAME="user" \
    MOODLE_PASSWORD="bitnami" \
    MOODLE_EMAIL="user@example.com" \
    MOODLE_LANGUAGE="en" \
    MARIADB_USER="root" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT="3306" \
    MOODLE_SITENAME="New Site"

VOLUME ["/bitnami/moodle", "/bitnami/apache", "/bitnami/php"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["/init.sh"]
