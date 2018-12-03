FROM bitnami/oraclelinux-extras:7-r186
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ImageMagick bzip2-libs cyrus-sasl-lib expat fontconfig freetype ghostscript glibc imagemagick jbigkit-libs keyutils-libs krb5-libs libICE libSM libX11 libXau libXext libXt libcom_err libcurl libgcc libgomp libidn libjpeg-turbo libpng libselinux libssh2 libstdc++ libtiff libtool-ltdl libuuid libxcb libxml2 libxslt mariadb-libs ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre postgresql-libs readline xz-libs zlib
RUN bitnami-pkg install ruby-2.4.5-0 --checksum baaa19777c655cdffb5859b412518719f3715cf17446e3c72369bdc876734f8c
RUN bitnami-pkg install postgresql-client-9.6.11-0 --checksum 9448fe9fbcff714a008ab0d91f704d3a7d522b492d4b6530bfc7eaadbc16032a
RUN bitnami-pkg install mysql-client-10.1.37-0 --checksum c1a94cb16b0325672c1c653d017f909e705a0be0efc46cc2a2a416d7e6a196da
RUN bitnami-pkg install git-2.19.2-0 --checksum 0d98ba10081908724152c819b0b7ddec46329319fca45182e4a2a50d0c2e49b9
RUN bitnami-pkg unpack redmine-3.4.6-3 --checksum 17c612cdab101f9e68a024320fd0dca1976fe608baf006cf4e320b76d35132e9

COPY rootfs /
ENV BITNAMI_APP_NAME="redmine" \
    BITNAMI_IMAGE_VERSION="3.4.6-ol-7-r142" \
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
