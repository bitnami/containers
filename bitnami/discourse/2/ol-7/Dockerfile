FROM bitnami/oraclelinux-extras:7-r253
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ImageMagick advancecomp cyrus-sasl-lib ghostscript gifsicle glibc hostname imagemagick jhead keyutils-libs krb5-libs libcom_err libcurl libgcc libidn libjpeg libselinux libssh2 libstdc++ libxml2 libxslt ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs optipng pcre pngquant postgresql-libs readline xz-libs zlib
RUN bitnami-pkg install ruby-2.4.5-20 --checksum f26eeb2bba7058b2327d6587e02911b4f906dbef8275f826e065f39e33bf668b
RUN bitnami-pkg unpack postgresql-client-9.6.11-20 --checksum 3167116810a3835a51f6110952d11d3951c940ee1bfc515d37f9f04816ba71fb
RUN bitnami-pkg install git-2.20.1-20 --checksum 160b41e17f0414c1206e97cc1eef3720596c0229922b68d4ded4a69bfc08cc51
RUN bitnami-pkg unpack discourse-sidekiq-2.2.0-0 --checksum 23ad302060fa76d5a508389cb38d03ea32e15bdcaad69653ad622b3ba39eb792
RUN bitnami-pkg unpack discourse-2.1.8-0 --checksum cfa9b66a41080facd540cb358c0a3547ade6b0d3b8a197c69d27671c0f0a31d8

COPY rootfs /
RUN install_packages rsync
ENV BITNAMI_APP_NAME="discourse" \
    BITNAMI_IMAGE_VERSION="2.1.8-ol-7-r12" \
    DISCOURSE_EMAIL="user@example.com" \
    DISCOURSE_EXTERNAL_PORT_NUMBER="80" \
    DISCOURSE_HOST="127.0.0.1" \
    DISCOURSE_HOSTNAME="127.0.0.1" \
    DISCOURSE_PASSWORD="bitnami123" \
    DISCOURSE_PORT="3000" \
    DISCOURSE_PORT_NUMBER="3000" \
    DISCOURSE_POSTGRESQL_NAME="bitnami_application" \
    DISCOURSE_POSTGRESQL_PASSWORD="bitnami1" \
    DISCOURSE_POSTGRESQL_USERNAME="bn_discourse" \
    DISCOURSE_SITENAME="My site!" \
    DISCOURSE_USERNAME="user" \
    PATH="/opt/bitnami/ruby/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/git/bin:$PATH" \
    POSTGRESQL_CLIENT_CREATE_DATABASE_NAME="" \
    POSTGRESQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    POSTGRESQL_CLIENT_CREATE_DATABASE_USERNAME="" \
    POSTGRESQL_HOST="postgresql" \
    POSTGRESQL_PORT_NUMBER="5432" \
    POSTGRESQL_ROOT_PASSWORD="" \
    POSTGRESQL_ROOT_USER="postgres" \
    REDIS_HOST="redis" \
    REDIS_PASSWORD="" \
    REDIS_PORT_NUMBER="6379" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_TLS="true" \
    SMTP_USER=""

EXPOSE 3000

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "discourse" ]
