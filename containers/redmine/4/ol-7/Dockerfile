FROM bitnami/oraclelinux-extras:7-r253
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ImageMagick bzip2-libs cyrus-sasl-lib expat fontconfig freetype ghostscript glibc imagemagick jbigkit-libs keyutils-libs krb5-libs libICE libSM libX11 libXau libXext libXt libcom_err libcurl libgcc libgomp libidn libjpeg-turbo libpng libselinux libssh2 libstdc++ libtiff libtool-ltdl libuuid libxcb libxml2 libxslt mariadb-libs ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre postgresql-libs readline xz-libs zlib
RUN bitnami-pkg install ruby-2.4.5-20 --checksum f26eeb2bba7058b2327d6587e02911b4f906dbef8275f826e065f39e33bf668b
RUN bitnami-pkg install postgresql-client-9.6.11-20 --checksum 3167116810a3835a51f6110952d11d3951c940ee1bfc515d37f9f04816ba71fb
RUN bitnami-pkg install mysql-client-10.1.37-21 --checksum ce01cd40ec8c9612d6a37b75f9f559f7afb4508aa5ceae5f9392aa0d42c928fc
RUN bitnami-pkg install git-2.20.1-20 --checksum 160b41e17f0414c1206e97cc1eef3720596c0229922b68d4ded4a69bfc08cc51
RUN bitnami-pkg unpack redmine-4.0.1-0 --checksum f21f163c9327259135574db6d2e64cbe4c77ff59352e92f30f8f39f10820ad30

COPY rootfs /
ENV BITNAMI_APP_NAME="redmine" \
    BITNAMI_IMAGE_VERSION="4.0.1-ol-7-r14" \
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
