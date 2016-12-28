FROM gcr.io/stacksmith-images/minideb:jessie-r8
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=7.0.14-r0 \
    BITNAMI_APP_NAME=php-fpm \
    BITNAMI_APP_USER=daemon

# System packages required
RUN install_packages libc6 zlib1g libxslt1.1 libtidy-0.99-0 libreadline6 libncurses5 libtinfo5 libsybdb5 libmcrypt4 libldap-2.4-2 libstdc++6 libgmp10 libpng12-0 libjpeg62-turbo libbz2-1.0 libxml2 libssl1.0.0 libcurl3 libfreetype6 libicu52 libgcc1 libgcrypt20 libgssapi-krb5-2 libgnutls-deb0-28 libsasl2-2 liblzma5 libidn11 librtmp1 libssh2-1 libkrb5-3 libk5crypto3 libcomerr2 libgpg-error0 libkrb5support0 libkeyutils1 libp11-kit0 libtasn1-6 libnettle4 libhogweed2 libffi6

# Install php
RUN bitnami-pkg unpack php-7.0.14-0 --checksum 9144f590d0cbbf751288c27467128b5f95507729c22144008c453c94cd8ef8b9
RUN mkdir -p /bitnami && ln -sf /bitnami/php /bitnami/php-fpm
ENV PATH=/opt/bitnami/php/sbin:/opt/bitnami/php/bin:/opt/bitnami/common/bin:$PATH

WORKDIR /app

COPY rootfs/ /

VOLUME ["/bitnami/$BITNAMI_APP_NAME"]

EXPOSE 9000

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "php"]
