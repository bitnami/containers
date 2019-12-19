FROM bitnami/oraclelinux-extras:7-r568
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ImageMagick bzip2-libs cyrus-sasl-lib expat fontconfig freetype ghostscript glibc jbigkit-libs keyutils-libs krb5-libs lcms2 libICE libSM libX11 libXau libXext libXt libcom_err libcurl libedit libgcc libgomp libidn libjpeg-turbo libpng libselinux libssh2 libstdc++ libtiff libtool-ltdl libuuid libxcb libxml2 libxslt mariadb-libs ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre postgresql-libs readline xz-libs zlib
RUN bitnami-pkg install ruby-2.6.5-0 --checksum 29ef6f1ed911c95ada9710d617438ec90e6e822cae31d2b82d578f9b9e7b1c30
RUN bitnami-pkg install postgresql-client-11.6.0-0 --checksum c0df49723944b7b842053d0cfb4f2ffe0313575ecfbb213e113b50989d008c1a
RUN bitnami-pkg install mysql-client-10.3.21-0 --checksum 9e012f0e449a963c923c8ea7a5cc2ab2c688564ed910eaab2aef1ad70c5d8e4b
RUN bitnami-pkg install git-2.24.1-0 --checksum ecc3a4f7b7a77ffb00ef66a9b02613c52a5b6d77bf9a5279fa139a66e6265460
RUN bitnami-pkg unpack redmine-4.0.5-0 --checksum 9c16648fceec04b060d5574a4be170d89b957179947795fe7f16c57f49309379

COPY rootfs /
ENV BITNAMI_APP_NAME="redmine" \
    BITNAMI_IMAGE_VERSION="4.0.5-ol-7-r64" \
    PATH="/opt/bitnami/ruby/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/mysql/bin:/opt/bitnami/git/bin:$PATH" \
    REDMINE_DB_MYSQL="mariadb" \
    REDMINE_DB_NAME="bitnami_redmine" \
    REDMINE_DB_PASSWORD="" \
    REDMINE_DB_PORT_NUMBER="" \
    REDMINE_DB_POSTGRES="" \
    REDMINE_DB_USERNAME="bn_redmine" \
    REDMINE_EMAIL="user@example.com" \
    REDMINE_LANGUAGE="en" \
    REDMINE_PASSWORD="bitnami1" \
    REDMINE_USERNAME="user" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_TLS="true" \
    SMTP_USER=""

EXPOSE 3000

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
