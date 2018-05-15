FROM bitnami/minideb-extras:jessie-r46
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libapr1 libaprutil1 libbz2-1.0 libc6 libcomerr2 libcurl3 libexpat1 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls-deb0-28 libgpg-error0 libgssapi-krb5-2 libhogweed2 libicu52 libidn11 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmcrypt4 libncurses5 libnettle4 libp11-kit0 libpcre3 libpng12-0 libpq5 libreadline6 librtmp1 libsasl2-2 libssh2-1 libssl1.0.0 libstdc++6 libsybdb5 libtasn1-6 libtidy-0.99-0 libtinfo5 libuuid1 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg unpack apache-2.4.33-1 --checksum 6d75b2446161eed96d5ab40d301d9a21d7d304f0323642fee9760e8525b0f852
RUN bitnami-pkg unpack php-7.0.30-2 --checksum 2ef097768570b3eee1730781bc2d73b44964b8399376da48096ff31392fc5091
RUN bitnami-pkg install libphp-7.0.30-1 --checksum e418d963a22c437510aa99d8154c758a68311013d1918d46e4f4a382855c0695
RUN bitnami-pkg unpack phpmyadmin-4.8.0-1-0 --checksum 16e3f65cc506e6b0e3183dcdc2b522f90596484de395fae30886d91d86a27492

COPY rootfs /
ENV APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="phpmyadmin" \
    BITNAMI_IMAGE_VERSION="4.8.0-1-r17" \
    DATABASE_HOST="mariadb" \
    DATABASE_PORT_NUMBER="3306" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:$PATH" \
    PHPMYADMIN_ALLOW_ARBITRARY_SERVER="" \
    PHPMYADMIN_ALLOW_NO_PASSWORD="true" \
    REQUIRE_LOCAL="0"

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","apache"]
