FROM bitnami/oraclelinux-extras:7-r497
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib expat freetds-libs freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmemcached libnghttp2 libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack apache-2.4.41-2 --checksum bf50a12c033c1ff0e1cb7696cc1abd29a132cc1c5225e9d2fdbb3c6584e349fe
RUN bitnami-pkg unpack php-7.3.10-3 --checksum b601801a832f7ca051c692bfc5f72a89cac9fb6018afdecac47429b98f3e6943
RUN bitnami-pkg install libphp-7.3.10-0 --checksum b9c55b3b223315814d89e903e8a076971e2970edfaa3d74ce0377576f499eacd
RUN bitnami-pkg unpack phpmyadmin-4.9.1-0 --checksum 4c154ea3ad22c4c496dd13fabf0a8aa16488d899a3eb2a5cc8cd539ac4e09d78

COPY rootfs /
ENV BITNAMI_APP_NAME="phpmyadmin" \
    BITNAMI_IMAGE_VERSION="4.9.1-ol-7-r23" \
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
