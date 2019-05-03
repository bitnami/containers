FROM bitnami/oraclelinux-extras:7-r323
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ImageMagick advancecomp cyrus-sasl-lib file ghostscript gifsicle glibc hostname jhead keyutils-libs krb5-libs libcom_err libcurl libedit libgcc libidn libjpeg libselinux libssh2 libstdc++ libxml2 libxslt ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs optipng pcre pngquant postgresql-libs readline rsync xz-libs zlib
RUN bitnami-pkg install ruby-2.5.5-0 --checksum 2d6b87df0bb10d2b017ab0338330daf3b81ab92f167a16da7488c10a7b87ff53
RUN bitnami-pkg unpack postgresql-client-10.7.0-0 --checksum 8984b9748b6b696ca687c769b324371132c01ea9b71b4773a3d199f1987a6761
RUN bitnami-pkg install git-2.21.0-0 --checksum 8dc7078aeaa3c3bf7010f3adbdb2f7ec9c3737c7eb6c7c1b2f547350c42fcfa5
RUN bitnami-pkg unpack discourse-sidekiq-2.2.4-0 --checksum e94d955fce5bf8266822e56ba29219f53b0f39283fd7f6d2fcef6cb8978d9153
RUN bitnami-pkg unpack discourse-2.2.4-1 --checksum 7dd37ca4b4d2dd49197d8cf189a5e705b581decec87dd1cc0447228cb5158f74
RUN /opt/bitnami/ruby/bin/gem install --force bundler -v '< 2'

COPY rootfs /
ENV BITNAMI_APP_NAME="discourse" \
    BITNAMI_IMAGE_VERSION="2.2.4-ol-7-r18" \
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
