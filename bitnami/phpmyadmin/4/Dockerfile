FROM bitnami/minideb-extras:jessie-r22
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libapr1 libaprutil1 libbz2-1.0 libc6 libcomerr2 libcurl3 libexpat1 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls-deb0-28 libgpg-error0 libgssapi-krb5-2 libhogweed2 libicu52 libidn11 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmcrypt4 libncurses5 libnettle4 libp11-kit0 libpcre3 libpng12-0 libpq5 libreadline6 librtmp1 libsasl2-2 libssh2-1 libssl1.0.0 libstdc++6 libsybdb5 libtasn1-6 libtidy-0.99-0 libtinfo5 libuuid1 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg unpack apache-2.4.29-0 --checksum 38af9f5ee6088655536238d9f70f4ce7fd6047e1c84fd5b02fa351efbc4f60c6
RUN bitnami-pkg unpack php-7.0.26-1 --checksum c2862ccbd91f993cf7862e8637434f718a62e3c2b90dcd933b21023e00b841ca
RUN bitnami-pkg install libphp-7.0.26-0 --checksum d797c28ea51a77aa19707f3594176057f26a888d4fc6254db752433739cf974f
RUN bitnami-pkg unpack phpmyadmin-4.7.7-0 --checksum ad61667a6dd890c5b9f795e7a9d50ebc43b785b35bb149bf5a7b137510287efc

COPY rootfs /

ENV APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="phpmyadmin" \
    BITNAMI_IMAGE_VERSION="4.7.7-r0" \
    DATABASE_HOST="mariadb" \
    DATABASE_PORT_NUMBER="3306" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:$PATH" \
    PHPMYADMIN_ALLOW_ARBITRARY_SERVER="" \
    PHPMYADMIN_ALLOW_NO_PASSWORD="true" \
    REQUIRE_LOCAL="0"

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","apache"]
