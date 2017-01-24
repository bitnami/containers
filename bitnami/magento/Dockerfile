FROM gcr.io/stacksmith-images/minideb:jessie-r8

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=magento \
    BITNAMI_IMAGE_VERSION=2.1.3-r1 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/apache/bin:/opt/bitnami/magento/bin/:$PATH

# System packages required
RUN install_packages libssl1.0.0 libaprutil1 libapr1 libc6 libuuid1 libexpat1 libpcre3 libldap-2.4-2 libsasl2-2 libgnutls-deb0-28 zlib1g libp11-kit0 libtasn1-6 libnettle4 libhogweed2 libgmp10 libffi6 libxslt1.1 libtidy-0.99-0 libreadline6 libncurses5 libtinfo5 libsybdb5 libmcrypt4 libstdc++6 libpng12-0 libjpeg62-turbo libbz2-1.0 libxml2 libcurl3 libfreetype6 libicu52 libgcc1 libgcrypt20 libgssapi-krb5-2 liblzma5 libidn11 librtmp1 libssh2-1 libkrb5-3 libk5crypto3 libcomerr2 libgpg-error0 libkrb5support0 libkeyutils1

# Additional modules required
RUN bitnami-pkg unpack apache-2.4.25-0 --checksum 8b46af7d737772d7d301da8b30a2770b7e549674e33b8a5b07480f53c39f5c3f
RUN bitnami-pkg unpack php-7.0.15-1 --checksum 8eb4ba4ca866a9459fe7bf9b4f4beede76f5b434da8991c4c98d482a0202f0a7
RUN bitnami-pkg install libphp-7.0.15-0 --checksum 11031c3b94ac04847aa12a65a3ac3afdd8ad88d409cf7a11086602fba041ce5f
RUN bitnami-pkg install mysql-client-10.1.21-0 --checksum 8e868a3e46bfa59f3fb4e1aae22fd9a95fd656c020614a64706106ba2eba224e

# Install magento
RUN bitnami-pkg unpack magento-2.1.3-0 --checksum b92b0f73bd99530945eb71d4ed6bd151a488aeb5d81d8eea68e895c120c23c92

COPY rootfs /

VOLUME ["/bitnami/magento", "/bitnami/apache", "/bitnami/php"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["/init.sh"]
