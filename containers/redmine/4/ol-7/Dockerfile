FROM bitnami/oraclelinux-extras:7-r516
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ImageMagick bzip2-libs cyrus-sasl-lib expat fontconfig freetype ghostscript glibc jbigkit-libs keyutils-libs krb5-libs lcms2 libICE libSM libX11 libXau libXext libXt libcom_err libcurl libedit libgcc libgomp libidn libjpeg-turbo libpng libselinux libssh2 libstdc++ libtiff libtool-ltdl libuuid libxcb libxml2 libxslt mariadb-libs ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre postgresql-libs readline xz-libs zlib
RUN bitnami-pkg install ruby-2.6.5-0 --checksum 29ef6f1ed911c95ada9710d617438ec90e6e822cae31d2b82d578f9b9e7b1c30
RUN bitnami-pkg install postgresql-client-11.5.0-1 --checksum d2d9a6bb144786c32d7ffa13bb1cd525c658d436dec0b5e92936c7f202dae549
RUN bitnami-pkg install mysql-client-10.3.18-2 --checksum c9d987cf8f6f6831d04920d64598d0c77cf994235753cf4d5d18ac787c12918e
RUN bitnami-pkg install git-2.23.0-1 --checksum a145f72a986e09dbdb13ce0d1ccbaf2bb78c8571610f4d3d61b8d97abab0c342
RUN bitnami-pkg unpack redmine-4.0.5-0 --checksum 9c16648fceec04b060d5574a4be170d89b957179947795fe7f16c57f49309379

COPY rootfs /
ENV BITNAMI_APP_NAME="redmine" \
    BITNAMI_IMAGE_VERSION="4.0.5-ol-7-r15" \
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
