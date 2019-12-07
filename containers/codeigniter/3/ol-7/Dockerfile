FROM bitnami/oraclelinux-extras:7-r556
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib freetds-libs freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmemcached libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline xz-libs zlib
RUN bitnami-pkg unpack php-7.3.12-1 --checksum c809d01cf8f4542d340dda697674e919a4e96f95c5e409551a21562bc9446afe
RUN bitnami-pkg install mysql-client-10.3.20-0 --checksum 6e895c7c56273bf724d87014c70187045fa0a399d9f24067e84f27475e3c071a
RUN bitnami-pkg install codeigniter-3.1.11-1 --checksum 688a0ac5b62282e30398fa20f4d0b4e8c0c15575fa1b53328048a23889d9d711

COPY rootfs /
ENV BITNAMI_APP_NAME="codeigniter" \
    BITNAMI_IMAGE_VERSION="3.1.11-ol-7-r83" \
    CODEIGNITER_PROJECT_NAME="myapp" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_USER="root" \
    PATH="/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/mysql/bin:/opt/bitnami/codeigniter/bin:$PATH"

EXPOSE 8000

WORKDIR /app
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "php", "-S", "0.0.0.0:8000" ]
