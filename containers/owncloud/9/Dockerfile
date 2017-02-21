FROM gcr.io/stacksmith-images/minideb:jessie-r10

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=owncloud \
    BITNAMI_IMAGE_VERSION=9.1.4-r1 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/mysql/bin/:$PATH

# Required system packages
RUN install_packages libc6 zlib1g libxslt1.1 libtidy-0.99-0 libreadline6 libncurses5 libtinfo5 libmcrypt4 libldap-2.4-2 libstdc++6 libgmp10 libpng12-0 libjpeg62-turbo libbz2-1.0 libxml2 libssl1.0.0 libcurl3 libfreetype6 libicu52 libgcc1 libgcrypt20 libsasl2-2 libgnutls-deb0-28 liblzma5 libidn11 librtmp1 libssh2-1 libgssapi-krb5-2 libkrb5-3 libk5crypto3 libcomerr2 libgpg-error0 libp11-kit0 libtasn1-6 libnettle4 libhogweed2 libkrb5support0 libkeyutils1 libffi6 libaprutil1 libapr1 libuuid1 libexpat1 libpcre3

# Additional modules required
RUN bitnami-pkg unpack apache-2.4.25-0 --checksum 8b46af7d737772d7d301da8b30a2770b7e549674e33b8a5b07480f53c39f5c3f
RUN bitnami-pkg unpack php-5.6.30-2 --checksum 79f4cc1ccc3a03777939b81230d83dee8211b9891ddf6e1cb1d17bab46d47d2b
RUN bitnami-pkg install libphp-5.6.30-1 --checksum a62cad2320fa2d141309e75663aed3d1bd82626d51b784678d18ec3f985d83bf
RUN bitnami-pkg install mysql-client-10.1.21-0 --checksum 8e868a3e46bfa59f3fb4e1aae22fd9a95fd656c020614a64706106ba2eba224e

# Install owncloud
RUN bitnami-pkg unpack owncloud-9.1.4-0 --checksum c1a546e4d154c89d1f8e96338368124c8e5b3dc63f05da079bec91b1ec7ef7e5

COPY rootfs /

ENV APACHE_HTTP_PORT="80" \
    APACHE_HTTPS_PORT="443" \
    OWNCLOUD_USERNAME="user" \
    OWNCLOUD_PASSWORD="bitnami" \
    OWNCLOUD_EMAIL="user@example.com" \
    MARIADB_USER="root" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT="3306"

VOLUME ["/bitnami/owncloud", "/bitnami/apache", "/bitnami/php"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "apache"]
