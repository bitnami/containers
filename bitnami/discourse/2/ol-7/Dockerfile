FROM bitnami/oraclelinux-extras:7-r343
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ImageMagick advancecomp cyrus-sasl-lib file ghostscript gifsicle glibc hostname jhead keyutils-libs krb5-libs libcom_err libcurl libedit libgcc libidn libjpeg libselinux libssh2 libstdc++ libxml2 libxslt ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs optipng pcre pngquant postgresql-libs readline rsync xz-libs zlib
RUN bitnami-pkg install ruby-2.5.5-0 --checksum 2d6b87df0bb10d2b017ab0338330daf3b81ab92f167a16da7488c10a7b87ff53
RUN bitnami-pkg unpack postgresql-client-11.3.0-0 --checksum 85cdf4e7ac8df71922a0ed95cd8c61f7b630070b3a315e46844a6b49a25c15d4
RUN bitnami-pkg install git-2.21.0-0 --checksum 8dc7078aeaa3c3bf7010f3adbdb2f7ec9c3737c7eb6c7c1b2f547350c42fcfa5
RUN bitnami-pkg unpack discourse-sidekiq-2.2.5-2 --checksum 86d6d3a3c72e87758e23e00489a7499815f7c3aff45d84db532586dcda040fbc
RUN bitnami-pkg unpack discourse-2.2.5-0 --checksum e1e255796bda15cd4570ada99b2f6903a49b8464d9c02719be2d083880048394
RUN /opt/bitnami/ruby/bin/gem install --force bundler -v '< 2'

COPY rootfs /
ENV BITNAMI_APP_NAME="discourse" \
    BITNAMI_IMAGE_VERSION="2.2.5-ol-7-r0" \
    DISCOURSE_EMAIL="user@example.com" \
    DISCOURSE_EXTERNAL_PORT_NUMBER="80" \
    DISCOURSE_HOST="discourse" \
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
