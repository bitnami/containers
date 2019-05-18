FROM bitnami/oraclelinux-extras:7-r340
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib freetds freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmemcached libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline xz-libs zlib
RUN bitnami-pkg install php-7.3.5-0 --checksum d87f224bceb767f97cf5f611e61f9bbfc9347b1de7795a1f0f10063eb8e40f91
RUN bitnami-pkg install mysql-client-10.3.15-0 --checksum 8200bab1521dde4a6c377789abdff7f4b30d64843a4a78affb319f833f9f260f
RUN bitnami-pkg install codeigniter-3.1.10-0 --checksum a26be05acfc714a1ac5f4aa5f20f0c51b1db3d1dccbaf47b01d022f0a3353704

COPY rootfs /
ENV BITNAMI_APP_NAME="codeigniter" \
    BITNAMI_IMAGE_VERSION="3.1.10-ol-7-r97" \
    CODEIGNITER_PROJECT_NAME="myapp" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_USER="root" \
    PATH="/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/mysql/bin:/opt/bitnami/codeigniter/bin:$PATH"

EXPOSE 8000

WORKDIR /app
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "php", "-S", "0.0.0.0:8000" ]
