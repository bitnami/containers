FROM bitnami/oraclelinux-extras:7-r26
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib freetds freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmcrypt libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline xz-libs zlib
RUN bitnami-pkg install php-7.1.19-2 --checksum 8bceb8da3c241d59b06a27c3859b49681f090af90117a79cba226ac648501d5a
RUN bitnami-pkg install mysql-client-10.1.34-0 --checksum 012f1f222898565b55f7d4522514c7c130d2bfe4c988754eed658ef6dafa980c
RUN bitnami-pkg install codeigniter-3.1.9-2 --checksum b56c0faab9619db37fb047578c650c2a7b403542b7a78b3a4f93d84748d3d16d

COPY rootfs /
ENV BITNAMI_APP_NAME="codeigniter" \
    BITNAMI_IMAGE_VERSION="3.1.9-ol-7-r8" \
    CODEIGNITER_PROJECT_NAME="myapp" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_USER="root" \
    PATH="/opt/bitnami/php/bin:/opt/bitnami/mysql/bin:/opt/bitnami/codeigniter/bin:$PATH"

EXPOSE 8000

WORKDIR /app
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["php","-S","0.0.0.0:8000"]
