FROM bitnami/oraclelinux-extras:7-r155
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ImageMagick bzip2-libs cyrus-sasl-lib expat fontconfig freetype glibc jbigkit-libs keyutils-libs krb5-libs libICE libSM libX11 libXau libXext libXt libcom_err libcurl libgcc libgomp libidn libjpeg-turbo libselinux libssh2 libstdc++ libtiff libtool-ltdl libuuid libxcb libxml2 libxslt mariadb-libs ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre postgresql-libs readline xz-libs zlib
RUN bitnami-pkg install ruby-2.4.5-0 --checksum baaa19777c655cdffb5859b412518719f3715cf17446e3c72369bdc876734f8c
RUN bitnami-pkg install postgresql-client-9.6.10-1 --checksum 51146a16db5ec6a3a2c2f007935ee5bd1da74fe1e5ba2b19a08b15976e8338cb
RUN bitnami-pkg install mysql-client-10.1.36-1 --checksum 37104f4fe6e526bbb437f61c33ecd8d14b2d576bc6d29b969daa252285acfd00
RUN bitnami-pkg install git-2.19.1-2 --checksum f216b1ac61b0bf86f3531671dee5be53c42ea436789484961bb41148911b32fa
RUN bitnami-pkg unpack redmine-3.4.6-2 --checksum 7ee7dac9288859017f7c38f9d2451aa3d74f781cad3fe1e27c0a8361c05daf52

COPY rootfs /
ENV BITNAMI_APP_NAME="redmine" \
    BITNAMI_IMAGE_VERSION="3.4.6-ol-7-r121" \
    PATH="/opt/bitnami/ruby/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/mysql/bin:/opt/bitnami/git/bin:$PATH" \
    REDMINE_DB_MYSQL="mariadb" \
    REDMINE_DB_PASSWORD="" \
    REDMINE_DB_PORT_NUMBER="" \
    REDMINE_DB_POSTGRES="" \
    REDMINE_DB_USERNAME="" \
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
