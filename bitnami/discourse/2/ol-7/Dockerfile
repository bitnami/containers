FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV PATH="/opt/bitnami/ruby/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/git/bin:/opt/bitnami/brotli/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ImageMagick advancecomp ca-certificates curl cyrus-sasl-lib file ghostscript gifsicle glibc gzip hostname jhead keyutils-libs krb5-libs libaio-devel libcom_err libcurl libedit libgcc libidn libjpeg libselinux libssh2 libstdc++ libuuid libxml2 libxslt ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs optipng pcre pngquant postgresql-libs procps-ng readline rsync sudo tar which xz-libs zlib
RUN /build/bitnami-user.sh && \
    /build/install-nami.sh
RUN bitnami-pkg install ruby-2.6.5-0 --checksum 29ef6f1ed911c95ada9710d617438ec90e6e822cae31d2b82d578f9b9e7b1c30
RUN bitnami-pkg unpack postgresql-client-11.7.0-0 --checksum 42b639dbc64ff5b40dc1dffc8ed1e9bed4320480706b2d76313ebeb3203b9f0c
RUN bitnami-pkg install git-2.25.1-0 --checksum 037457371b4782c6e780a899463a54544590a20a12c344bf5d14cef5ef470077
RUN bitnami-pkg unpack discourse-sidekiq-2.3.10-0 --checksum 01fe3c3f00d84cac08540ca4ea518b4da31758158e2cfc6cbb4cc06e284becd8
RUN bitnami-pkg install brotli-1.0.7-1 --checksum 92c77710e899ebedff06d583af7938a56b80df9584675109df5aee1d5899e8da
RUN bitnami-pkg unpack discourse-2.3.10-0 --checksum 348c20af35763c53aafa32f378f5ff35af5305d306121992c7a9eb9e9a3a85af
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN /build/install-gosu.sh
RUN /opt/bitnami/ruby/bin/gem install --force bundler -v '< 2'
RUN /build/install-tini.sh

COPY rootfs /
ENV BITNAMI_APP_NAME="discourse" \
    BITNAMI_IMAGE_VERSION="2.3.10-ol-7-r8" \
    DISCOURSE_EMAIL="user@example.com" \
    DISCOURSE_HOST="discourse" \
    DISCOURSE_HOSTNAME="127.0.0.1" \
    DISCOURSE_PASSENGER_SPAWN_METHOD="direct" \
    DISCOURSE_PASSWORD="bitnami123" \
    DISCOURSE_PORT="3000" \
    DISCOURSE_PORT_NUMBER="3000" \
    DISCOURSE_POSTGRESQL_NAME="bitnami_application" \
    DISCOURSE_POSTGRESQL_PASSWORD="bitnami1" \
    DISCOURSE_POSTGRESQL_USERNAME="bn_discourse" \
    DISCOURSE_SITENAME="My site!" \
    DISCOURSE_SKIP_INSTALL="no" \
    DISCOURSE_USERNAME="user" \
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
    SMTP_AUTH="login" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_TLS="yes" \
    SMTP_USER=""

EXPOSE 3000

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "discourse" ]
