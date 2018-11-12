FROM bitnami/oraclelinux-extras:7-r166
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ImageMagick advancecomp cyrus-sasl-lib ghostscript gifsicle glibc hostname imagemagick jhead keyutils-libs krb5-libs libcom_err libcurl libgcc libidn libjpeg libselinux libssh2 libstdc++ libxml2 libxslt ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs optipng pcre pngquant postgresql-libs readline xz-libs zlib
RUN bitnami-pkg install ruby-2.4.5-0 --checksum baaa19777c655cdffb5859b412518719f3715cf17446e3c72369bdc876734f8c
RUN bitnami-pkg unpack postgresql-client-9.6.11-0 --checksum 9448fe9fbcff714a008ab0d91f704d3a7d522b492d4b6530bfc7eaadbc16032a
RUN bitnami-pkg install git-2.19.1-2 --checksum f216b1ac61b0bf86f3531671dee5be53c42ea436789484961bb41148911b32fa
RUN bitnami-pkg unpack discourse-sidekiq-2.1.3-1 --checksum b8394d5d7700feedffc799cb6410ba130052576605d7557b4368313d2690832e
RUN bitnami-pkg unpack discourse-2.1.3-0 --checksum ebc9621f05ce613be9dc6e6f7cb13cacbd53787a25f7c17971ad8d756259d261

COPY rootfs /
RUN install_packages rsync
ENV BITNAMI_APP_NAME="discourse" \
    BITNAMI_IMAGE_VERSION="2.1.3-ol-7-r0" \
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

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "discourse" ]
