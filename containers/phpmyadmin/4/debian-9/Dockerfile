FROM bitnami/minideb-extras:stretch-r494
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libbz2-1.0 libc6 libcomerr2 libcurl3 libexpat1 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu57 libidn11 libidn2-0 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmemcached11 libmemcachedutil2 libncurses5 libnettle6 libnghttp2-14 libp11-kit0 libpcre3 libpng16-16 libpq5 libpsl5 libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.0.2 libssl1.1 libstdc++6 libsybdb5 libtasn1-6 libtidy5 libtinfo5 libunistring0 libxml2 libxslt1.1 libzip4 zlib1g
RUN bitnami-pkg unpack apache-2.4.41-3 --checksum 4cbd05e6df93361999856d4f77a4124443bc11b47abb090b3cfd19544cce627c
RUN bitnami-pkg unpack php-7.3.12-1 --checksum 13b8e6816e848f6e3800574eca78b635b3e255deb4c7c6576a2f8c648d867520
RUN bitnami-pkg install libphp-7.3.12-0 --checksum 7ec2d2d73c6f945b16f00ee8f76639d894c4e5123b7f51095e0cbd84015dc2cf
RUN bitnami-pkg unpack phpmyadmin-4.9.2-0 --checksum 94012ebf509efa1d5399e4ede66fa824a6691ac7636948d633662848848e535b

COPY rootfs /
ENV BITNAMI_APP_NAME="phpmyadmin" \
    BITNAMI_IMAGE_VERSION="4.9.2-debian-9-r20" \
    DATABASE_ENABLE_SSL="no" \
    DATABASE_HOST="mariadb" \
    DATABASE_PORT_NUMBER="3306" \
    DATABASE_SSL_CA="" \
    DATABASE_SSL_CA_PATH="" \
    DATABASE_SSL_CERT="" \
    DATABASE_SSL_CIPHERS="" \
    DATABASE_SSL_KEY="" \
    DATABASE_SSL_VERIFY="yes" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:$PATH" \
    PHPMYADMIN_ALLOW_ARBITRARY_SERVER="" \
    PHPMYADMIN_ALLOW_NO_PASSWORD="true" \
    REQUIRE_LOCAL="no"

EXPOSE 80 443

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "apache" ]
