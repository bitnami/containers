FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV PATH="/opt/bitnami/ruby/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/git/bin:/opt/bitnami/brotli/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ImageMagick advancecomp ca-certificates curl cyrus-sasl-lib file ghostscript gifsicle glibc gzip hostname jhead keyutils-libs krb5-libs libaio-devel libcom_err libcurl libedit libgcc libidn libjpeg libselinux libssh2 libstdc++ libuuid libxml2 libxslt ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs optipng pcre pngquant postgresql-libs procps-ng readline rsync sudo tar which xz-libs zlib
RUN /build/bitnami-user.sh && \
    /build/install-nami.sh
RUN bitnami-pkg install ruby-2.6.5-0 --checksum 29ef6f1ed911c95ada9710d617438ec90e6e822cae31d2b82d578f9b9e7b1c30
RUN bitnami-pkg unpack postgresql-client-11.6.0-0 --checksum c0df49723944b7b842053d0cfb4f2ffe0313575ecfbb213e113b50989d008c1a
RUN bitnami-pkg install git-2.25.0-0 --checksum 2fd25c5b37cec238a759c3c3643c156d4fe5b00716e2152c7c494cf6729673c9
RUN bitnami-pkg unpack discourse-sidekiq-2.3.9-0 --checksum 8d82ff53d49f1cde18a4ce4ad70f901c65d34e4a3ca71f4b9db7f6b9d05b8827
RUN bitnami-pkg install brotli-1.0.7-1 --checksum 92c77710e899ebedff06d583af7938a56b80df9584675109df5aee1d5899e8da
RUN bitnami-pkg unpack discourse-2.3.9-0 --checksum 8a441cbe788879e6f2ee4a6ad30ce7c5f722a1941b0aba8783573f6c63ea3d1b
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN /build/install-gosu.sh
RUN /opt/bitnami/ruby/bin/gem install --force bundler -v '< 2'
RUN /build/install-tini.sh

COPY rootfs /
ENV BITNAMI_APP_NAME="discourse" \
    BITNAMI_IMAGE_VERSION="2.3.9-ol-7-r11" \
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
