FROM bitnami/oraclelinux-extras:7-r436
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ImageMagick advancecomp cyrus-sasl-lib file ghostscript gifsicle glibc hostname jhead keyutils-libs krb5-libs libcom_err libcurl libedit libgcc libidn libjpeg libselinux libssh2 libstdc++ libxml2 libxslt ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs optipng pcre pngquant postgresql-libs readline rsync xz-libs zlib
RUN bitnami-pkg install ruby-2.5.5-0 --checksum 2d6b87df0bb10d2b017ab0338330daf3b81ab92f167a16da7488c10a7b87ff53
RUN bitnami-pkg unpack postgresql-client-11.5.0-0 --checksum 928f0e50c64eed64cb72c16a9da0602c2489685985abba677e1d9350fe9a421c
RUN bitnami-pkg install git-2.23.0-0 --checksum 30618c63e72727b90b3cc3e7f8747e599ec11352b29812285a27029807d8766d
RUN bitnami-pkg unpack discourse-sidekiq-2.3.2-3 --checksum b1869e39dfdc9f13ae13a70b8f1c12252f311a17258f5cb012407df60253965c
RUN bitnami-pkg install brotli-1.0.7-0 --checksum f24dfc1de31ef2294b31d84ec577ea186a64d3399481de7e8b32c102e6334d7f
RUN bitnami-pkg unpack discourse-2.3.2-2 --checksum 6563d53c738b089fc8799543ae00414590f01cabfb7c0aafd9993ed6a90af4e3
RUN /opt/bitnami/ruby/bin/gem install --force bundler -v '< 2'

COPY rootfs /
ENV BITNAMI_APP_NAME="discourse" \
    BITNAMI_IMAGE_VERSION="2.3.2-ol-7-r40" \
    DISCOURSE_EMAIL="user@example.com" \
    DISCOURSE_HOST="discourse" \
    DISCOURSE_HOSTNAME="127.0.0.1" \
    DISCOURSE_PASSWORD="bitnami123" \
    DISCOURSE_PORT="3000" \
    DISCOURSE_PORT_NUMBER="3000" \
    DISCOURSE_POSTGRESQL_NAME="bitnami_application" \
    DISCOURSE_POSTGRESQL_PASSWORD="bitnami1" \
    DISCOURSE_POSTGRESQL_USERNAME="bn_discourse" \
    DISCOURSE_SITENAME="My site!" \
    DISCOURSE_SKIP_INSTALL="no" \
    DISCOURSE_USERNAME="user" \
    PATH="/opt/bitnami/ruby/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/git/bin:/opt/bitnami/brotli/bin:$PATH" \
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
