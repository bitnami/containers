FROM bitnami/oraclelinux-extras:7-r66
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib freetds freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmcrypt libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline xz-libs zlib
RUN bitnami-pkg install php-7.1.20-1 --checksum 453099c5c33e2d3f011ab61b7dc27e68e77063a80e6ce166a2ef26f73434ef62
RUN bitnami-pkg install mysql-client-10.1.35-0 --checksum e8b7b1feec15c0dd8c1643eb0ab0220c384e1eb981e1ef7cd51d06bb9fb09e6e
RUN bitnami-pkg install codeigniter-3.1.9-2 --checksum b56c0faab9619db37fb047578c650c2a7b403542b7a78b3a4f93d84748d3d16d

COPY rootfs /
ENV BITNAMI_APP_NAME="codeigniter" \
    BITNAMI_IMAGE_VERSION="3.1.9-ol-7-r36" \
    CODEIGNITER_PROJECT_NAME="myapp" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_USER="root" \
    PATH="/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/mysql/bin:/opt/bitnami/codeigniter/bin:$PATH"

EXPOSE 8000

WORKDIR /app
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["php","-S","0.0.0.0:8000"]
