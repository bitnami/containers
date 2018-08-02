FROM bitnami/oraclelinux-extras:7-r56
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ImageMagick bzip2-libs cyrus-sasl-lib expat fontconfig freetype ghostscript glibc imagemagick jbigkit-libs keyutils-libs krb5-libs libICE libSM libX11 libXau libXext libXt libcom_err libcurl libgcc libgomp libidn libjpeg-turbo libselinux libssh2 libstdc++ libtiff libtool-ltdl libuuid libxcb libxml2 libxslt mariadb-libs ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre postgresql-libs readline xz-libs zlib
RUN bitnami-pkg install ruby-2.4.4-0 --checksum 8623ed8b7963916ff7f5ecf56c62ce3c144a1d11e56767500d0034c8e4f7e17c
RUN bitnami-pkg install postgresql-client-9.6.9-1 --checksum b7007d79eb6b282769262c4a2717a50cbfa1150abdbce70d79e6e8b6a42a237c
RUN bitnami-pkg install mysql-client-10.1.34-0 --checksum 012f1f222898565b55f7d4522514c7c130d2bfe4c988754eed658ef6dafa980c
RUN bitnami-pkg install git-2.18.0-1 --checksum e09020e93542133c5f61daaa5a47bdcb94ec5303dd336ae05fa561729786284c
RUN bitnami-pkg unpack redmine-3.4.6-1 --checksum 1c00bfe523614039b8565c944e95ed4fbb4cff252f47d45bf1e4c84684091ef6

COPY rootfs /
ENV BITNAMI_APP_NAME="redmine" \
    BITNAMI_IMAGE_VERSION="3.4.6-ol-7-r38" \
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

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["/run.sh"]
