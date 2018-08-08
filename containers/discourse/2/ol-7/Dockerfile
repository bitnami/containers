FROM bitnami/oraclelinux-extras:7-r62
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ImageMagick cyrus-sasl-lib ghostscript glibc hostname imagemagick jhead keyutils-libs krb5-libs libcom_err libcurl libgcc libidn libselinux libssh2 libstdc++ libxml2 libxslt ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre postgresql-libs readline xz-libs zlib
RUN bitnami-pkg install ruby-2.4.4-0 --checksum 8623ed8b7963916ff7f5ecf56c62ce3c144a1d11e56767500d0034c8e4f7e17c
RUN bitnami-pkg unpack postgresql-client-9.6.9-1 --checksum b7007d79eb6b282769262c4a2717a50cbfa1150abdbce70d79e6e8b6a42a237c
RUN bitnami-pkg install git-2.18.0-1 --checksum e09020e93542133c5f61daaa5a47bdcb94ec5303dd336ae05fa561729786284c
RUN bitnami-pkg unpack discourse-sidekiq-2.0.3-4 --checksum 1a26fa115c66cca6c54e29793cc8ca33ddc106bd74e7ff68b0d009c969ee5ab2
RUN bitnami-pkg unpack discourse-2.0.3-2 --checksum 7c88ff6ff36c948560b85cee653f5e3bf296d39e092d25d4a873fcc81d5ccd76

COPY rootfs /
ENV BITNAMI_APP_NAME="discourse" \
    BITNAMI_IMAGE_VERSION="2.0.3-ol-7-r6" \
    DISCOURSE_EMAIL="user@example.com" \
    DISCOURSE_HOST="127.0.0.1" \
    DISCOURSE_HOSTNAME="www.example.com" \
    DISCOURSE_PASSWORD="bitnami123" \
    DISCOURSE_PORT="3000" \
    DISCOURSE_POSTGRESQL_NAME="bitnami_application" \
    DISCOURSE_POSTGRESQL_PASSWORD="bitnami1" \
    DISCOURSE_POSTGRESQL_USERNAME="bn_discourse" \
    DISCOURSE_SITE_NAME="My site!" \
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

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","discourse"]
