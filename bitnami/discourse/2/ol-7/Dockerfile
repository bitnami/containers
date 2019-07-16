FROM bitnami/oraclelinux-extras:7-r399
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ImageMagick advancecomp cyrus-sasl-lib file ghostscript gifsicle glibc hostname jhead keyutils-libs krb5-libs libcom_err libcurl libedit libgcc libidn libjpeg libselinux libssh2 libstdc++ libxml2 libxslt ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs optipng pcre pngquant postgresql-libs readline rsync xz-libs zlib
RUN bitnami-pkg install ruby-2.5.5-0 --checksum 2d6b87df0bb10d2b017ab0338330daf3b81ab92f167a16da7488c10a7b87ff53
RUN bitnami-pkg unpack postgresql-client-11.4.0-0 --checksum 1cdcdcb1b64aa03958b0f4c80b608d2a53da594317ccf683fb50f486f4356e1b
RUN bitnami-pkg install git-2.22.0-0 --checksum 5dc73d3ed8b4f84c89e75fd7c08ec147a528eaf1017946d68c3732748885b3e2
RUN bitnami-pkg unpack discourse-sidekiq-2.3.2-0 --checksum 9027c29b425c3220dd759911061970db498a23a04ac2a5a96e17ed34519c24a9
RUN bitnami-pkg install brotli-1.0.7-0 --checksum f24dfc1de31ef2294b31d84ec577ea186a64d3399481de7e8b32c102e6334d7f
RUN bitnami-pkg unpack discourse-2.3.2-0 --checksum 936e4e0c04aa98dd30e3276079499b072ee707812a37279a8abf8f8833dd1208
RUN /opt/bitnami/ruby/bin/gem install --force bundler -v '< 2'

COPY rootfs /
ENV BITNAMI_APP_NAME="discourse" \
    BITNAMI_IMAGE_VERSION="2.3.2-ol-7-r1" \
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
    SMTP_TLS="true" \
    SMTP_USER=""

EXPOSE 3000

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "discourse" ]
