FROM bitnami/oraclelinux-extras:7-r454
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ImageMagick bzip2-libs cyrus-sasl-lib expat fontconfig freetype ghostscript glibc jbigkit-libs keyutils-libs krb5-libs libICE libSM libX11 libXau libXext libXt libcom_err libcurl libedit libgcc libgomp libidn libjpeg-turbo libpng libselinux libssh2 libstdc++ libtiff libtool-ltdl libuuid libxcb libxml2 libxslt mariadb-libs ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre postgresql-libs readline xz-libs zlib
RUN bitnami-pkg install ruby-2.6.4-0 --checksum 8774fa00c7fbf9bd5e8af4425f20c466c606c9bdf2df4aee80db525bbd45ab49
RUN bitnami-pkg install postgresql-client-11.5.0-0 --checksum 928f0e50c64eed64cb72c16a9da0602c2489685985abba677e1d9350fe9a421c
RUN bitnami-pkg install mysql-client-10.3.17-0 --checksum 83fd01acb88a54d028a327870cec66bf43f57f326814a16dc4626a5171742229
RUN bitnami-pkg install git-2.23.0-0 --checksum 30618c63e72727b90b3cc3e7f8747e599ec11352b29812285a27029807d8766d
RUN bitnami-pkg unpack redmine-4.0.4-1 --checksum 9a0f0711a13e17f6e85d7aba5b19cc8bff028422f16272f75689681b0be6dc66

COPY rootfs /
ENV BITNAMI_APP_NAME="redmine" \
    BITNAMI_IMAGE_VERSION="4.0.4-ol-7-r84" \
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
