FROM bitnami/oraclelinux-extras:7-r276
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ImageMagick advancecomp cyrus-sasl-lib file ghostscript gifsicle glibc hostname jhead keyutils-libs krb5-libs libcom_err libcurl libedit libgcc libidn libjpeg libselinux libssh2 libstdc++ libxml2 libxslt ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs optipng pcre pngquant postgresql-libs readline xz-libs zlib
RUN bitnami-pkg install ruby-2.5.3-21 --checksum 065e8e8c592b2c1543c97ab30cb4a1ea2740b7c98a4cb3b137121a0ea6fb5a32
RUN bitnami-pkg unpack postgresql-client-10.7.0-0 --checksum 8984b9748b6b696ca687c769b324371132c01ea9b71b4773a3d199f1987a6761
RUN bitnami-pkg install git-2.21.0-0 --checksum 8dc7078aeaa3c3bf7010f3adbdb2f7ec9c3737c7eb6c7c1b2f547350c42fcfa5
RUN bitnami-pkg unpack discourse-sidekiq-2.2.2-0 --checksum a7e29a26edf78457d370693745180cff095c4f7c991370be78aa8649e69c122a
RUN bitnami-pkg unpack discourse-2.2.2-0 --checksum c532c1864fe9ebee2b83748e71e76066daab05a8bbd450dede1013fdde0d5427

COPY rootfs /
RUN install_packages rsync
ENV BITNAMI_APP_NAME="discourse" \
    BITNAMI_IMAGE_VERSION="2.2.2-ol-7-r0" \
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
