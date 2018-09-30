FROM bitnami/oraclelinux-extras:7-r122
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib expat freetds freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmcrypt libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack apache-2.4.35-0 --checksum 5d3d1836c2ff00e299779b9f5ad90f65e599655b6a96908c579966d206bb4396
RUN bitnami-pkg unpack php-7.0.32-1 --checksum e4dc53e7136006e86064102fea76ffe2f3ac357c48ff7393eb3047fd82ae05b6
RUN bitnami-pkg install libphp-7.0.32-2 --checksum a9477d2211a4d63d3894d43767c796305e55b196182223d1ad986455f1daf1de
RUN bitnami-pkg unpack phpmyadmin-4.8.3-0 --checksum c8ea7d8d5dd8bd2f9d146aef3957b1604f58a3b693629aa28d38aed1b9b5edeb

COPY rootfs /
ENV APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="phpmyadmin" \
    BITNAMI_IMAGE_VERSION="4.8.3-ol-7-r36" \
    DATABASE_HOST="mariadb" \
    DATABASE_PORT_NUMBER="3306" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:$PATH" \
    PHPMYADMIN_ALLOW_ARBITRARY_SERVER="" \
    PHPMYADMIN_ALLOW_NO_PASSWORD="true" \
    REQUIRE_LOCAL="0"

EXPOSE 80 443

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "apache" ]
