FROM bitnami/oraclelinux-extras:7-r195
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ImageMagick advancecomp cyrus-sasl-lib ghostscript gifsicle glibc hostname imagemagick jhead keyutils-libs krb5-libs libcom_err libcurl libgcc libidn libjpeg libselinux libssh2 libstdc++ libxml2 libxslt ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs optipng pcre pngquant postgresql-libs readline xz-libs zlib
RUN bitnami-pkg install ruby-2.4.5-20 --checksum f26eeb2bba7058b2327d6587e02911b4f906dbef8275f826e065f39e33bf668b
RUN bitnami-pkg unpack postgresql-client-9.6.11-20 --checksum 13d0c60206c7676545f5f07dec28d7672f12498e299ff155d72e2952b916ee0a
RUN bitnami-pkg install git-2.19.2-0 --checksum 0d98ba10081908724152c819b0b7ddec46329319fca45182e4a2a50d0c2e49b9
RUN bitnami-pkg unpack discourse-sidekiq-2.1.4-20 --checksum 0a92dbd8dcb3524389a1e1be41b5bffae0b55a700c3f1df4debfb6aabef813ce
RUN bitnami-pkg unpack discourse-2.1.4-20 --checksum a205b2ab2aa46995d695fa6b26e51f6e9f778732013b601a8ef3115271f2a367

COPY rootfs /
RUN install_packages rsync
ENV BITNAMI_APP_NAME="discourse" \
    BITNAMI_IMAGE_VERSION="2.1.4-ol-7-r1" \
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
