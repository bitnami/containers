FROM bitnami/minideb-extras:jessie-r13

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=moodle \
    BITNAMI_IMAGE_VERSION=3.2.2-r0 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/mysql/bin/:$PATH

# System packages required
RUN install_packages libaprutil1 libapr1 libc6 libuuid1 libexpat1 libssl1.0.0 libpcre3 libldap-2.4-2 libsasl2-2 libgnutls-deb0-28 zlib1g libp11-kit0 libtasn1-6 libnettle4 libhogweed2 libgmp10 libffi6 libncurses5 libtinfo5 libstdc++6 libgcc1 libxslt1.1 libtidy-0.99-0 libreadline6 libmcrypt4 libpng12-0 libjpeg62-turbo libbz2-1.0 libxml2 libcurl3 libfreetype6 libicu52 libgcrypt20 liblzma5 libidn11 librtmp1 libssh2-1 libgssapi-krb5-2 libkrb5-3 libk5crypto3 libcomerr2 libgpg-error0 libkrb5support0 libkeyutils1 libsybdb5 libpq5

# Additional modules required
RUN bitnami-pkg unpack apache-2.4.25-0 --checksum 8b46af7d737772d7d301da8b30a2770b7e549674e33b8a5b07480f53c39f5c3f
RUN bitnami-pkg install mysql-client-10.1.22-1 --checksum d9c3d9a5c986ae17eaa5089d85dcd19f314f057102ab40121714e6e3b8c33af5
RUN bitnami-pkg unpack php-7.1.3-0 --checksum 0b1270ac702523a9f2f448a71f953c5212db41e59a586b86c1b9422b28b6d5b8
RUN bitnami-pkg install libphp-7.1.3-0 --checksum 851c928d90c086ea48152fb3947379025cba36a497c3c57bb87ad0f2ff012b51

# Install moodle
RUN bitnami-pkg unpack moodle-3.2.2-0 --checksum 9e56bfd65b8bc46af4ce35297b595a9e7092d4efbe09eaf7d4a8bccf04165bf7

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
